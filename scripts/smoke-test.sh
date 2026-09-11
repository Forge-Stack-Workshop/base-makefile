#!/usr/bin/env bash
# Smoke-test every profile and example Makefile: dry-run its `help` target and
# assert a clean exit with no stderr. A shell syntax error inside a $(shell ...)
# or a recipe surfaces on stderr even when make's exit code is 0, so we check both.
set -u

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root" || exit 1
fail=0

# check <label> <make-args...> — run from an optional working dir set by caller.
check() {
	label="$1"; shift
	stderr="$("$@" 2>&1 >/dev/null)"; rc=$?
	if [ "$rc" -ne 0 ]; then
		echo "FAIL: $label — make exited $rc"; echo "$stderr" | sed 's/^/    /'; fail=1
	elif [ -n "$stderr" ]; then
		echo "FAIL: $label — stderr not empty:"; echo "$stderr" | sed 's/^/    /'; fail=1
	else
		echo "OK:   $label"
	fi
}

# Composable profiles: included from repo root (their `include lib/...` is CWD-relative).
for profile in profiles/*.Makefile; do
	check "$profile" make -f "$profile" --dry-run help
done

# Flat examples: the with-sub-folder demo scans its own dir, so run each from examples/.
for example in Makefile.basic Makefile.python Makefile.with-sub-folder; do
	check "examples/$example" make -C examples -f "$example" --dry-run help
done

exit "$fail"
