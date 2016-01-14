#!/bin/sh

set -eu

_mutt () {
	cp mailcap ~/.mailcap
	mkdir -p ~/.vcards

	mkdir -p ~/.mutt/accounts
	touch ~/.mutt/aliases ~/.mutt/certificates
	find mutt -type f -name '[_a-zA-Z0-9]*' ! -name '_template' | awk '{ printf "touch ~/.%s && chmod 600 ~/.%s && utils/macros %s > ~/.%s\n", $1, $1, $1, $1 }' | xargs -I{} sh -c "{}"
}

_msmtp () {
	: > ~/.msmtprc
	chmod 600 ~/.msmtprc
	utils/macros msmtprc >> ~/.msmtprc
}

_offlineimap () {
	: > ~/.offlineimaprc
	chmod 600 ~/.offlineimaprc
	utils/macros offlineimaprc >> ~/.offlineimaprc
	mkdir -p ~/service
	cp -r runit/offlineimap ~/service
	echo "$HOME" > ~/service/offlineimap/env/HOME

	sv -w 30 force-shutdown ~/service/offlineimap >/dev/null 2>/dev/null
}

echo installing mutthub

printf ' - mutt: '
_mutt		|| { echo failed; exit 1; }
echo done

printf ' - msmtp: '
_msmtp		|| { echo failed; exit 1; }
echo done

printf ' - offlineimap: '
_offlineimap	|| { echo failed; exit 1; }
echo done

echo

exit 0
