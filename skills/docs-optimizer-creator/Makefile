# Repo-local self-test and dev sync. Skills are installed via
# `npx skills`, not Make.

.PHONY: test sync

test:
	@python3 tests/test_verify_refs.py

# `verify_refs.py` is duplicated in `docs-optimizer` (canonical) and here
# (so the creator can deploy it into target repos as a self-contained
# unit). `make sync` pulls the canonical version. The sync test in
# `tests/test_verify_refs.py` fails loudly if the two drift.
sync:
	@cp ../docs-optimizer/scripts/verify_refs.py scripts/verify_refs.py
	@cp ../docs-optimizer/tests/test_verify_refs.py tests/test_verify_refs.py
	@echo "Synced verify_refs.py and test_verify_refs.py from docs-optimizer"
