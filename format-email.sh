#!/bin/sh

set -eu

DIR=$(dirname $(readlink -f "$0"))

while getopts f:t F; do
	case $F in
	f)	FARG=$OPTARG;;
	t)	TARG=$(sed -n -e "s~^set display_filter='\(.*\)'$~\1~ p" /etc/t-prot/Muttrc);;
	esac
done
shift $((OPTIND - 1))

F="cat"
[ -z "${TARG:-}" ] || F="${TARG} | ${F}"
case "${FARG:-}" in
"")	;;
m365)	F="/usr/bin/env python3 '$DIR/format-email.m365.py' | ${F}";;
*)	echo unknown pre-filter >&2; exit 1;;
esac

exec /bin/sh -c "$F"
