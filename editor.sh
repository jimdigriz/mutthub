#!/bin/sh

set -eu

DIR=$(dirname $(readlink -f "$0"))

while getopts f:p F; do
	case $F in
	f)	FARG=$OPTARG;;
	p)	PARG=1;;
	esac
done
shift $((OPTIND - 1))

M=$1

cleanup() {
	rm -f "$M.orig" "$M.tmp"
}
trap cleanup EXIT

cp -p "$M" "$M.orig"

# we need to reverse mutt adding an attribution and indent strings
A=$(head -n1 "$M")
sed -e '1 d; s/^> //' "$M" > "$M.tmp"
mv "$M.tmp" "$M"

# preserve the signature seperately
S=$(tail -n2 "$M")
head -n -2 "$M" > "$M.tmp"
mv "$M.tmp" "$M"

# not passthrough
if [ ! "${PARG:-}" ]; then
	/bin/sh "$DIR/format-email.sh" ${FARG:+-f $FARG} < "$M" > "$M.tmp"
	mv "$M.tmp" "$M"
fi

sed -e '/^> > On .* wrote:$/ d; /^> > > / d' "$M" \
	| sed -e '$ { /^> > / d }' \
	> "$M.tmp"
mv "$M.tmp" "$M"

# ...and now add back in the attribution, signature and indent strings
{ test ! -s "$M" || printf '\n'; printf '%s\n' "$A"; sed -e 's/^/> /' "$M"; printf '\n%s' "$S"; } > "$M.tmp"
mv "$M.tmp" "$M"

CHKSUM=$(openssl dgst -md5 -r "$M" | awk '{ print $M }')

# https://rinzewind.org/blog-en/2017/a-small-trick-for-sending-flowed-mail-in-mutt-with-vim.html
vim -c 'setlocal fo=awnqptc comments=nb:> filetype=mail wm=0 tw=72 nonumber nodigraph list nojs nosmartindent spell spelllang=en_gb' "$M"

# allow 'abort_unmodified' to work
[ "$(openssl dgst -md5 -r "$M" | awk '{ print $M }')" != "$CHKSUM" ] || mv "$M.orig" "$M"

exit 0
