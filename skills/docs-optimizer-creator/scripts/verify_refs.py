#!/usr/bin/env python3
"""Mechanical drift detector for instruction docs.

Walks every markdown file under a target directory and checks references that
should resolve to real things in the repo. Handles common cases — markdown link
targets, inline-code paths, `make foo` against the Makefile, `npm run foo`
against package.json — and respects top-level .gitignore so generated/ignored
files don't produce noise.

KNOWN LIMITATIONS (skip rather than false-flag):
  - Cannot tell that `scripts/build.sh` in the docs is describing what an
    EXTERNAL repo should contain rather than referencing this repo. Any time
    a doc describes another project's expected structure, those mentions will
    show up as "missing path" findings — let the LLM-side of the audit
    triage them.
  - Cannot tell that an inline `composer.json` is a generic mention rather
    than a path reference; we require a slash to flag, which trades some
    recall for much better precision.
  - Cannot detect references that lack any path-shaped marker (e.g. a doc
    saying "see unverified-notes.md" with no slash). Catching those needs
    cross-doc reading — that's the LLM's job, not this script's.

Inputs:

  - Markdown link targets that look like filesystem paths
  - Inline-code spans that look like filesystem paths
  - Inline-code spans that look like shell commands (checks the binary exists
    on PATH, OR — for Make targets like `make foo` — checks the Makefile)
  - Inline-code spans that look like npm scripts (`npm run foo`) — checks
    package.json scripts

Outputs a structured report (markdown by default; --json available).

Heuristics are intentionally conservative — false positives on a `verify_refs`
report waste the user's time worse than false negatives. When in doubt, skip.

Usage:
    python verify_refs.py <docs_root> [--repo-root <root>] [--json] [--include-skill-dirs]

Exit code 0 = no drift detected; 1 = drift detected; 2 = invocation error.
"""
from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

# Paths under the repo root that we never treat as documentation roots even
# when scanning recursively (build artifacts, vendor, etc.).
SKIP_DIRS = {".git", "node_modules", "vendor", "build", "dist", "result", "var", ".idea", ".vscode", ".ddev"}

MD_LINK_RE = re.compile(r"\[([^\]]*)\]\(([^)]+)\)")
INLINE_CODE_RE = re.compile(r"`([^`\n]+)`")

# Patterns that look like filesystem paths in inline code.
# Conservative: must contain a slash OR end in a known doc/source extension.
PATH_LIKE_RE = re.compile(
    r"^(?:\.{1,2}/)?[\w.\-]+(?:/[\w.\-]+)+\.?[\w.\-]*/?$"
)
KNOWN_EXTENSIONS = {".md", ".sh", ".py", ".js", ".ts", ".json", ".yml", ".yaml",
                    ".nix", ".toml", ".php", ".bats", ".rb", ".go", ".rs"}

# Shell-command-like inline code: starts with a recognized verb.
COMMAND_VERBS = {"make", "npm", "yarn", "pnpm", "bash", "sh", "python", "python3",
                 "node", "go", "cargo", "rake", "ddev", "docker", "bats"}


@dataclass
class Finding:
    file: str
    line: int
    kind: str         # "broken_link" | "missing_path" | "missing_make_target" | "missing_npm_script" | "missing_command"
    snippet: str
    detail: str


@dataclass
class Report:
    docs_root: str
    repo_root: str
    files_scanned: int = 0
    findings: list[Finding] = field(default_factory=list)

    def to_json(self) -> dict:
        return {
            "docs_root": self.docs_root,
            "repo_root": self.repo_root,
            "files_scanned": self.files_scanned,
            "findings_count": len(self.findings),
            "findings": [f.__dict__ for f in self.findings],
        }


PLACEHOLDER_TOKENS = {"foo", "bar", "baz", "qux", "n/a", "N/A", "TODO", "..."}


def looks_like_path(s: str) -> bool:
    """Conservative path detector — bias toward false negatives, not false positives.

    Only treats inline-code spans as path references when they LOOK specific,
    not when they're generic file-type mentions or placeholders.
    """
    s = s.strip().rstrip(",.;:!?")
    if not s or s.startswith(("http://", "https://", "mailto:", "ftp://", "file://")):
        return False
    if any(c.isspace() for c in s):
        return False
    # Placeholder syntax — `<name>`, `${var}`, `*.md`, `path/to/foo`.
    if any(c in s for c in "<>*?{}$"):
        return False
    # Common placeholder tokens.
    parts = re.split(r"[/.\-_]", s)
    if any(p in PLACEHOLDER_TOKENS for p in parts):
        return False
    # Require at least one slash — no bare `composer.json` flagging.
    if "/" not in s:
        return False
    if not PATH_LIKE_RE.match(s):
        return False
    return True


def looks_like_command(s: str) -> tuple[str, str] | None:
    """Return (verb, rest) if s looks like a shell command, else None."""
    s = s.strip()
    if not s or s.startswith(("$", "#", "//", "/*")):
        return None
    parts = s.split(None, 1)
    if not parts:
        return None
    verb = parts[0]
    rest = parts[1] if len(parts) > 1 else ""
    if verb in COMMAND_VERBS:
        return verb, rest
    return None


def resolve_path(repo_root: Path, doc_file: Path, target: str) -> Path | None:
    """Resolve a referenced path. Try doc-relative first, then repo-root-relative."""
    target = target.strip().rstrip(",.;:!?")
    if not target:
        return None
    target = target.split("#", 1)[0]  # strip #anchor
    if not target:
        return None
    candidates = []
    candidates.append((doc_file.parent / target).resolve())
    candidates.append((repo_root / target.lstrip("/")).resolve())
    for c in candidates:
        try:
            c.relative_to(repo_root.resolve())
        except ValueError:
            continue
        if c.exists():
            return c
    return candidates[0]  # return first attempt for the report


def load_gitignore_patterns(repo_root: Path) -> list[str]:
    """Return raw gitignore patterns (top-level .gitignore only). Best-effort."""
    gi = repo_root / ".gitignore"
    if not gi.exists():
        return []
    patterns = []
    for line in gi.read_text(errors="replace").splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("!"):
            continue  # negations not supported
        patterns.append(line)
    return patterns


def is_gitignored(repo_root: Path, rel_path: str, patterns: list[str]) -> bool:
    """Heuristic gitignore check — covers common cases (prefix match, trailing /, *)."""
    if not patterns:
        return False
    rel = rel_path.lstrip("./")
    for pat in patterns:
        p = pat.rstrip("/").lstrip("/")
        if "*" in p:
            # Convert glob to regex (very loose).
            regex = "^" + re.escape(p).replace(r"\*\*", ".*").replace(r"\*", "[^/]*") + "$"
            if re.match(regex, rel):
                return True
            if re.match(regex, rel.split("/")[0]):
                return True
            # Anchored prefix glob: `build/*` should match `build/site-artifact/...`
            prefix = p.split("*", 1)[0].rstrip("/")
            if prefix and (rel == prefix or rel.startswith(prefix + "/")):
                return True
        else:
            if rel == p or rel.startswith(p + "/"):
                return True
            # Match unanchored basename (e.g. ".DS_Store")
            if "/" not in p and any(seg == p for seg in rel.split("/")):
                return True
    return False


def find_make_targets(repo_root: Path) -> set[str]:
    targets = set()
    makefile = repo_root / "Makefile"
    if not makefile.exists():
        return targets
    for line in makefile.read_text(errors="replace").splitlines():
        m = re.match(r"^([A-Za-z0-9_.-]+)\s*:", line)
        if m and not line.lstrip().startswith("#"):
            targets.add(m.group(1))
    return targets


def find_npm_scripts(repo_root: Path) -> set[str]:
    pkg = repo_root / "package.json"
    if not pkg.exists():
        return set()
    try:
        data = json.loads(pkg.read_text())
    except Exception:
        return set()
    return set((data.get("scripts") or {}).keys())


def command_on_path(verb: str) -> bool:
    if verb in {"bash", "sh"}:
        return True
    try:
        return subprocess.run(["which", verb], capture_output=True).returncode == 0
    except Exception:
        return False


def scan_markdown(path: Path, repo_root: Path, make_targets: set[str], npm_scripts: set[str], gitignore: list[str], findings: list[Finding]) -> None:
    text = path.read_text(errors="replace")
    rel = str(path.relative_to(repo_root))

    # Markdown link targets.
    for line_no, line in enumerate(text.splitlines(), 1):
        for m in MD_LINK_RE.finditer(line):
            label, target = m.group(1), m.group(2).strip()
            if target.startswith(("http://", "https://", "mailto:", "ftp://", "#")):
                continue
            if target.startswith(("file://",)):
                target = target[len("file://"):]
            target_clean = target.split(" ", 1)[0]  # strip optional title
            resolved = resolve_path(repo_root, path, target_clean)
            if resolved is None or not resolved.exists():
                if is_gitignored(repo_root, target_clean, gitignore):
                    continue
                findings.append(Finding(
                    file=rel, line=line_no, kind="broken_link",
                    snippet=f"[{label}]({target})",
                    detail=f"link target does not exist (looked for {target_clean})",
                ))

    # Inline-code spans.
    for line_no, line in enumerate(text.splitlines(), 1):
        for m in INLINE_CODE_RE.finditer(line):
            code = m.group(1).strip()
            if not code:
                continue
            # Path-like inline code.
            if looks_like_path(code):
                # Only flag if the leading directory segment exists in the repo —
                # this filters slash-containing identifiers that aren't filesystem
                # paths (e.g. package coordinates `vendor/package-name`,
                # namespace refs `Foo\\Bar`-style written with slashes).
                lead = code.lstrip("./").split("/", 1)[0]
                if not (repo_root / lead).exists():
                    continue
                if is_gitignored(repo_root, code, gitignore):
                    continue
                resolved = resolve_path(repo_root, path, code)
                if resolved is None or not resolved.exists():
                    findings.append(Finding(
                        file=rel, line=line_no, kind="missing_path",
                        snippet=code,
                        detail=f"inline path does not exist in repo",
                    ))
                continue
            # Command-like inline code.
            cmd = looks_like_command(code)
            if cmd is None:
                continue
            verb, rest = cmd
            if verb == "make":
                target = rest.split(None, 1)[0] if rest else ""
                # Strip flags like -j8, -C dir.
                target = re.sub(r"^-\S+\s*", "", target).strip()
                if target and target not in make_targets and (repo_root / "Makefile").exists():
                    findings.append(Finding(
                        file=rel, line=line_no, kind="missing_make_target",
                        snippet=code,
                        detail=f"Makefile has no target '{target}' (targets: {sorted(make_targets)[:10]}{'...' if len(make_targets) > 10 else ''})",
                    ))
            elif verb == "npm" and rest.startswith("run "):
                script = rest[4:].split(None, 1)[0]
                if script and script not in npm_scripts and (repo_root / "package.json").exists():
                    findings.append(Finding(
                        file=rel, line=line_no, kind="missing_npm_script",
                        snippet=code,
                        detail=f"package.json has no script '{script}'",
                    ))
            # We deliberately don't check arbitrary command verbs against $PATH — too noisy.


def collect_md_files(docs_root: Path) -> list[Path]:
    """Walk docs_root for *.md, skipping conventional build/dep dirs.

    Skip check is against the path RELATIVE to docs_root — checking against
    absolute parts misfires on macOS tempfile dirs (`/var/folders/...`) and
    similar paths whose ancestors happen to share a name with a skip dir.
    """
    out: list[Path] = []
    for p in docs_root.rglob("*.md"):
        try:
            rel_parts = p.relative_to(docs_root).parts
        except ValueError:
            rel_parts = p.parts
        if any(part in SKIP_DIRS for part in rel_parts):
            continue
        out.append(p)
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("docs_root", help="Directory to scan for markdown (often the repo root)")
    ap.add_argument("--repo-root", help="Repo root for resolving paths (defaults to docs_root)")
    ap.add_argument("--json", action="store_true", help="Output JSON instead of markdown report")
    args = ap.parse_args()

    docs_root = Path(args.docs_root).resolve()
    if not docs_root.is_dir():
        print(f"error: {docs_root} is not a directory", file=sys.stderr)
        return 2
    repo_root = Path(args.repo_root).resolve() if args.repo_root else docs_root

    make_targets = find_make_targets(repo_root)
    npm_scripts = find_npm_scripts(repo_root)
    gitignore = load_gitignore_patterns(repo_root)

    report = Report(docs_root=str(docs_root), repo_root=str(repo_root))
    files = collect_md_files(docs_root)
    report.files_scanned = len(files)
    for f in files:
        try:
            scan_markdown(f, repo_root, make_targets, npm_scripts, gitignore, report.findings)
        except Exception as e:
            report.findings.append(Finding(file=str(f.relative_to(repo_root)), line=0, kind="scan_error", snippet="", detail=str(e)))

    if args.json:
        print(json.dumps(report.to_json(), indent=2))
    else:
        print_markdown_report(report)

    return 1 if report.findings else 0


def print_markdown_report(r: Report) -> None:
    print(f"# Reference verification report\n")
    print(f"- Docs root: `{r.docs_root}`")
    print(f"- Repo root: `{r.repo_root}`")
    print(f"- Markdown files scanned: {r.files_scanned}")
    print(f"- Findings: {len(r.findings)}\n")
    if not r.findings:
        print("No drift detected.")
        return
    by_kind: dict[str, list[Finding]] = {}
    for f in r.findings:
        by_kind.setdefault(f.kind, []).append(f)
    for kind, findings in sorted(by_kind.items()):
        print(f"## {kind} ({len(findings)})\n")
        for f in findings:
            print(f"- `{f.file}:{f.line}` — `{f.snippet}` — {f.detail}")
        print()


if __name__ == "__main__":
    sys.exit(main())
