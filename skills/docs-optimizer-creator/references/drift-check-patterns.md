# Drift-check patterns

When the creator proposes a drift-detection harness for a repo, match it
to the repo's existing test infrastructure. Don't introduce a new test
framework just to host the drift check. Pick the pattern that fits, fill
in the repo-specific assertions, and propose it alongside the tailored
skill.

These are reference shapes, not finished products. The creator should
adapt them to repo specifics. Patterns are listed PHP-first (the most
common case in this user's projects), but the principle is to match
whatever the repo actually uses.

In all patterns, replace `<skill-dir>` with the actual directory the
tailored skill is being deployed to (detected from the repo's existing
agent-skill convention; ask the user if no convention exists).

---

## Pattern A: PHPUnit (when the repo already uses PHPUnit)

File: `tests/InstructionConsistencyTest.php` (or wherever the repo
already keeps its PHPUnit tests).

```php
<?php
declare(strict_types=1);

namespace Tests;

use PHPUnit\Framework\TestCase;

/**
 * Drift checks for instruction docs. Catches the patterns the tailored
 * docs-optimizer describes — anything that should be enforced rather
 * than reviewed.
 */
final class InstructionConsistencyTest extends TestCase
{
    private string $repoRoot;

    protected function setUp(): void
    {
        $this->repoRoot = dirname(__DIR__);
    }

    public function testAllDocReferencesResolve(): void
    {
        $verifier = $this->repoRoot . '/<skill-dir>/scripts/verify_refs.py';
        $cmd = sprintf('python3 %s %s --json', escapeshellarg($verifier), escapeshellarg($this->repoRoot));
        $output = shell_exec($cmd) ?? '';
        $data = json_decode($output, true) ?? ['findings' => []];

        $this->assertEmpty(
            $data['findings'],
            'Doc drift detected: ' . print_r($data['findings'], true),
        );
    }

    public function testAgentsMdSkillListMatchesActualSkills(): void
    {
        // Repo-specific check the tailored skill described — example shape.
        // Replace with whatever inventory match this repo needs.
        $this->markTestIncomplete('Fill in repo-specific inventory check.');
    }
}
```

Wire into the repo's existing PHPUnit suite — usually no extra config
needed if `tests/` is already covered.

---

## Pattern B: Bats (when the repo already uses Bats)

File: `tests/instruction-consistency.bats` (or wherever the repo already
keeps Bats tests).

```bash
#!/usr/bin/env bats

# Drift checks for instruction docs. Catches the patterns the tailored
# docs-optimizer describes — anything that should be enforced rather
# than reviewed.

setup() {
  REPO_ROOT="$(git rev-parse --show-toplevel)"
}

@test "AGENTS.md skill list matches actual skills" {
  declared=$(awk '/^## Skills/,/^## /' "$REPO_ROOT/AGENTS.md" \
    | grep -oE '`[a-z][a-z0-9-]+`' | tr -d '`' | sort -u)
  actual=$(find "$REPO_ROOT/<repo-skills-location>" -mindepth 1 -maxdepth 1 -type d \
    -exec basename {} \; | sort -u)
  [ "$declared" = "$actual" ]
}

@test "all script paths mentioned in docs exist" {
  python3 "$REPO_ROOT/<skill-dir>/scripts/verify_refs.py" \
    "$REPO_ROOT" --json | python3 -c \
    "import json,sys; d=json.load(sys.stdin); sys.exit(1 if d['findings'] else 0)"
}

# Add more @test cases for repo-specific drift patterns the audit found.
```

Use this when the repo's CI already runs Bats.

---

## Pattern C: Pytest (Python repos)

File: `tests/test_docs_consistency.py`

```python
"""Drift checks for instruction docs. See SKILL.md for the patterns."""
import json
import subprocess
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parents[1]


def test_no_broken_refs():
    """Every doc-mentioned path resolves to a real file."""
    result = subprocess.run(
        ["python3", str(REPO_ROOT / "<skill-dir>/scripts/verify_refs.py"),
         str(REPO_ROOT), "--json"],
        capture_output=True, text=True,
    )
    findings = json.loads(result.stdout)["findings"]
    assert not findings, "Doc drift detected:\n" + "\n".join(
        f"  {f['file']}:{f['line']} — {f['snippet']}" for f in findings
    )


def test_command_examples_in_readme_use_canonical_form():
    """README examples should match what the CLI actually accepts."""
    # Repo-specific check the tailored skill described.
    ...
```

---

## Pattern D: Plain shell test (no test framework)

File: `scripts/check-docs-drift.sh`, runnable in CI as a job step.

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

fail=0

echo "Checking doc references..."
if ! python3 "<skill-dir>/scripts/verify_refs.py" . --json \
   | python3 -c "import json,sys; sys.exit(1 if json.load(sys.stdin)['findings'] else 0)"
then
  echo "  ✗ broken doc references — run with no --json to see details"
  fail=1
fi

# Repo-specific checks here. One example:
if grep -RnF "deprecated-api-host.example.com" docs/ AGENTS.md 2>/dev/null; then
  echo "  ✗ deprecated API host still mentioned in docs"
  fail=1
fi

[ "$fail" = 0 ] && echo "All checks passed"
exit "$fail"
```

Use this when the repo has no existing test framework and adding one
would be disproportionate. The user can wire it into pre-commit, CI,
or run it manually.

---

## What to include in any pattern

Always:
- The mechanical verifier (`verify_refs.py`) wired in. It's the
  cheapest, highest-leverage check.

Often:
- Cross-file synchronization checks the audit identified — e.g. "if
  flag X is declared in `scripts/foo.sh --help`, it must also appear
  in `docs/commands.md`".
- Inventory matches — skill list in `AGENTS.md` vs. actual skills
  on disk.

Sometimes:
- Forbidden-pattern grep (e.g. "no doc may recommend `bats` directly").

Never:
- Assertions about prose content that can't be mechanically checked.
  Those are the LLM-driven audit's job.

## How to wire it into CI

Match the repo's existing CI pattern. If GitHub Actions:

```yaml
- name: Docs drift check
  run: <the chosen pattern>
```

If the repo already has a "run all tests" target (`composer test`,
`make test`, `npm test`, or a project-specific wrapper), add the drift
check there so it can't be forgotten.

The creator should propose the wiring, not just the test file. A test
nobody runs is worse than no test.
