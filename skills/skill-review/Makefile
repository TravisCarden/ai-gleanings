# Simple development shortcuts (optional)
# Most users will invoke via Claude Code skill system, not make

.PHONY: test install

# Self-test for development
test:
	@./scripts/validate-skill.sh .
	@./scripts/review-skill.sh .
	@./tests/test-runner.sh

# Development installation (users typically install via skill system)
install:
	@ln -sf "$(PWD)" ~/.claude/skills/audit-skill
	@echo "Development installation complete"
