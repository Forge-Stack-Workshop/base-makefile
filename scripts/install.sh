#!/usr/bin/env bash
# install.sh — wire the base-makefile ecosystem into a target project.
# Copies lib/ and one profile (renamed Makefile) into the destination, so the
# project gets `make help` and every brick target immediately.
#
# Usage:
#   scripts/install.sh --profile django --dest /path/to/project
#   scripts/install.sh -p micro-container -d .           # into current dir
#   scripts/install.sh --list                            # list profiles
#
# Flags:
#   -p, --profile   profile name (micro|micro-container|frontend|django|
#                   fullstack|fullstack-container|unity)
#   -d, --dest      target project directory (default: current directory)
#       --force     overwrite an existing Makefile / lib/ without asking
#       --list      print available profiles and exit
#   -h, --help      show this help
set -euo pipefail

here="$(cd "$(dirname "$0")/.." && pwd)"
profile=""
dest="."
force=0

list_profiles() {
	find "$here/profiles" -maxdepth 1 -name '*.Makefile' -exec basename {} \; \
		| sed 's/\.Makefile$//' | sort
}

die() { printf 'error: %s\n' "$1" >&2; exit 1; }

while [ $# -gt 0 ]; do
	case "$1" in
		-p|--profile) profile="${2:-}"; shift 2 ;;
		-d|--dest)    dest="${2:-}"; shift 2 ;;
		--force)      force=1; shift ;;
		--list)       list_profiles; exit 0 ;;
		-h|--help)    sed -n '2,20p' "$0"; exit 0 ;;
		*)            die "unknown argument: $1" ;;
	esac
done

[ -n "$profile" ] || die "missing --profile (see --list)"
profile_file="$here/profiles/$profile.Makefile"
[ -f "$profile_file" ] || die "unknown profile '$profile' (see --list)"
[ -d "$dest" ] || die "destination '$dest' does not exist"

# Guard against clobbering existing files unless --force.
if [ "$force" -ne 1 ]; then
	[ -e "$dest/Makefile" ] && die "$dest/Makefile exists (use --force to overwrite)"
	[ -e "$dest/lib" ] && die "$dest/lib exists (use --force to overwrite)"
fi

cp -R "$here/lib" "$dest/lib"
cp "$profile_file" "$dest/Makefile"

printf '✔ installed profile "%s" into %s\n' "$profile" "$dest"
printf '  - lib/ (Make bricks)\n  - Makefile (from profiles/%s.Makefile)\n' "$profile"
printf 'Next: edit the overrides at the top of %s/Makefile, then run `make`.\n' "$dest"
