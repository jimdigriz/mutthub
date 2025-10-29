#!/bin/sh

set -eu

DIR=$(dirname $(readlink -f "$0"))

cleanup() {
	rm -f "$1.tmp"
}
trap cleanup EXIT

while getopts f:p F; do
	case $F in
	f)	FARG=$OPTARG;;
	p)	PARG=1;;
	esac
done
shift $((OPTIND - 1))

# not passthrough
if [ ! "${PARG:-}" ]; then
	# we need to reverse mutt adding an attribution and indent strings
	A=$(head -n1 "$1")
	sed -e '1 d; s/^> //;' "$1" > "$1.tmp"
	mv "$1.tmp" "$1"

	# preserve the signature seperately
	S=$(tail -n2 "$1")
	head -n -2 "$1" > "$1.tmp"
	mv "$1.tmp" "$1"

	/bin/sh "$DIR/format-email.sh" ${FARG:+-f $FARG} < "$1" > "$1.tmp"
	mv "$1.tmp" "$1"

	# ...and now add back in the attribution, signature and indent strings
	{ echo "$A"; sed -e 's/^/> /;' "$1"; echo "$S"; } > "$1.tmp"
	mv "$1.tmp" "$1"
fi

# https://rinzewind.org/blog-en/2017/a-small-trick-for-sending-flowed-mail-in-mutt-with-vim.html
exec vim -c 'setlocal fo=awnqptc comments=nb:> filetype=mail wm=0 tw=72 nonumber digraph list nojs nosmartindent spell spelllang=en_gb' "$1"
