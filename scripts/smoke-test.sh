#!/usr/bin/env bash
# Smoke test for the Makefile templates.
# Each template's `help` target must dry-run cleanly: exit 0 AND emit no stderr.
# A shell syntax error inside a $(shell ...) or recipe prints to stderr while make
# still exits 0 — so we check stderr, not just the exit code. This is what catches
# the class of bug that previously shipped (unescaped parens in .PHONY).
set -euo pipefail

fail=0

check() {
	local template="$1"
	local stderr rc
	stderr="$(make -n -f "$template" help 2>&1 >/dev/null)" && rc=0 || rc=$?
	if [ "$rc" -ne 0 ]; then
		echo "FAIL: $template — make exited $rc"
		fail=1
	elif [ -n "$stderr" ]; then
		echo "FAIL: $template — stderr not empty:"
		echo "$stderr" | sed 's/^/    /'
		fail=1
	else
		echo "OK:   $template"
	fi
}

check Makefile.basic
check Makefile.with-sub-folder
check Makefile.python

exit "$fail"
