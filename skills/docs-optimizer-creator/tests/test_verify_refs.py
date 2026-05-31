#!/usr/bin/env python3
"""Regression tests for verify_refs.py.

Each test creates a tiny repo in a temp dir, runs the verifier as a subprocess,
and asserts on the findings. Coverage targets:

  - Real broken markdown links are caught
  - Real broken inline-code paths are caught (when the leading directory exists)
  - Generic file-type mentions (`composer.json` in prose) are NOT flagged
  - Placeholder paths (`<name>.json`, `path/to/foo`) are NOT flagged
  - Coordinate-style slashes (`vendor/package`) are NOT flagged when leading dir is missing
  - Top-level .gitignore patterns are respected, including leading-slash anchored patterns
  - Make targets and npm scripts are validated against the actual files

Plus a drift-prevention check:

  - verify_refs.py is byte-identical to the sibling skill's copy. The
    docs-optimizer-creator deploys the script into target repos and needs
    the same logic the docs-optimizer uses. Edits to one without the other
    cause both skills' tests to fail loudly. Skipped when the sibling skill
    isn't present (e.g. when this skill has been deployed standalone into a
    target repo).

Run:
    python3 tests/test_verify_refs.py
"""
from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import tempfile
from pathlib import Path

VERIFIER = Path(__file__).resolve().parents[1] / "scripts" / "verify_refs.py"


def run(repo: Path) -> list[dict]:
    """Run the verifier and return findings."""
    result = subprocess.run(
        ["python3", str(VERIFIER), str(repo), "--json"],
        capture_output=True, text=True, check=False,
    )
    if result.returncode not in (0, 1):
        raise RuntimeError(f"verifier exited {result.returncode}: {result.stderr}")
    data = json.loads(result.stdout)
    return data["findings"]


def write(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def assert_finding(findings: list[dict], *, file: str, kind: str, snippet_substr: str) -> None:
    for f in findings:
        if f["file"] == file and f["kind"] == kind and snippet_substr in f["snippet"]:
            return
    raise AssertionError(
        f"expected finding (file={file}, kind={kind}, snippet contains {snippet_substr!r}); "
        f"got: {findings}"
    )


def assert_no_finding_with(findings: list[dict], snippet_substr: str) -> None:
    matches = [f for f in findings if snippet_substr in f["snippet"]]
    if matches:
        raise AssertionError(
            f"unexpected finding(s) with snippet containing {snippet_substr!r}: {matches}"
        )


# --- tests ---

def test_real_broken_link_caught():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "README.md", "See [the spec](docs/missing.md) for details.\n")
        findings = run(repo)
        assert_finding(findings, file="README.md", kind="broken_link", snippet_substr="docs/missing.md")


def test_real_broken_inline_path_caught():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "src/main.py", "")
        write(repo / "README.md", "Edit `src/missing.py` to configure.\n")
        findings = run(repo)
        assert_finding(findings, file="README.md", kind="missing_path", snippet_substr="src/missing.py")


def test_generic_file_type_mention_not_flagged():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "README.md", "Make sure your `composer.json` has the right autoload section.\n")
        findings = run(repo)
        # `composer.json` has no slash → must NOT be flagged.
        assert_no_finding_with(findings, "composer.json")


def test_placeholder_paths_not_flagged():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "src/real.py", "")
        write(repo / "README.md",
              "Templates use `templates/<name>.json` "
              "and example scripts like `path/to/foo.sh` are placeholders.\n")
        findings = run(repo)
        assert_no_finding_with(findings, "<name>")
        assert_no_finding_with(findings, "path/to/foo")


def test_coordinate_style_slashes_not_flagged():
    """vendor/package coordinates (e.g. Composer packages, npm scoped packages)
    look like paths but the leading segment isn't a directory in the repo."""
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "README.md", "We use `vendor-org/some-package` for parsing.\n")
        findings = run(repo)
        assert_no_finding_with(findings, "vendor-org/some-package")


def test_gitignore_leading_slash_respected():
    """Patterns like /build/* should suppress findings under build/."""
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / ".gitignore", "/build/*\n")
        write(repo / "build/.gitkeep", "")  # build dir exists so leading-segment check passes
        write(repo / "README.md", "Output goes to `build/site-artifact/manifest.txt`.\n")
        findings = run(repo)
        assert_no_finding_with(findings, "build/site-artifact/manifest.txt")


def test_gitignore_specific_file_respected():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / ".gitignore", "/secrets/local.json\n")
        write(repo / "secrets/.gitkeep", "")
        write(repo / "AGENTS.md", "Local-only config lives in `secrets/local.json`.\n")
        findings = run(repo)
        assert_no_finding_with(findings, "secrets/local.json")


def test_make_target_existence_checked():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "Makefile", "real-target:\n\techo hi\n")
        write(repo / "README.md", "Run `make missing-target` to do the thing.\n")
        findings = run(repo)
        assert_finding(findings, file="README.md", kind="missing_make_target",
                       snippet_substr="make missing-target")


def test_npm_script_existence_checked():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "package.json", json.dumps({"scripts": {"build": "echo build"}}))
        write(repo / "README.md", "Run `npm run missing` to ship.\n")
        findings = run(repo)
        assert_finding(findings, file="README.md", kind="missing_npm_script",
                       snippet_substr="npm run missing")


def test_verify_refs_matches_sibling():
    """verify_refs.py must stay byte-identical across docs-optimizer and
    docs-optimizer-creator. The creator deploys this script into
    target repos; if the two copies drift, repos created from one will
    behave differently from the optimizer they were calibrated against.

    Skipped silently when no sibling skill is present (e.g. after deployment
    into a target repo where this is a standalone skill).
    """
    skill_root = VERIFIER.parents[1]
    skills_root = skill_root.parent
    here = skill_root.name
    siblings = {
        "docs-optimizer": "docs-optimizer-creator",
        "docs-optimizer-creator": "docs-optimizer",
    }
    sibling_name = siblings.get(here)
    if not sibling_name:
        return  # standalone deployment; nothing to compare
    sibling_verifier = skills_root / sibling_name / "scripts" / "verify_refs.py"
    if not sibling_verifier.exists():
        return  # sibling not installed in this layout; skip
    here_hash = hashlib.sha256(VERIFIER.read_bytes()).hexdigest()
    there_hash = hashlib.sha256(sibling_verifier.read_bytes()).hexdigest()
    if here_hash != there_hash:
        raise AssertionError(
            f"verify_refs.py drift: {VERIFIER} (sha256={here_hash[:12]}) "
            f"differs from {sibling_verifier} (sha256={there_hash[:12]}). "
            f"Sync the two copies before committing."
        )


def test_clean_repo_has_no_findings():
    with tempfile.TemporaryDirectory() as td:
        repo = Path(td)
        write(repo / "src/main.py", "")
        write(repo / "Makefile", "build:\n\techo build\n")
        write(repo / "README.md",
              "See [main.py](src/main.py). Build with `make build`. "
              "Generic refs like `composer.json` and `package.json` are fine.\n")
        findings = run(repo)
        if findings:
            raise AssertionError(f"clean repo produced findings: {findings}")


# --- runner ---

def main() -> int:
    tests = [v for k, v in globals().items() if k.startswith("test_") and callable(v)]
    failed = 0
    for t in tests:
        try:
            t()
            print(f"  ok   {t.__name__}")
        except Exception as e:
            failed += 1
            print(f"  FAIL {t.__name__}: {e}")
    total = len(tests)
    print(f"\n{total - failed}/{total} passed")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
