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

_mbsync () {
	: > ~/.mbsyncrc
	chmod 600 ~/.mbsyncrc
	utils/macros mbsyncrc >> ~/.mbsyncrc
}

echo installing mutthub

printf ' - mutt: '
_mutt		|| { echo failed; exit 1; }
echo done

printf ' - msmtp: '
_msmtp		|| { echo failed; exit 1; }
echo done

printf ' - mbsync: '
_mbsync		|| { echo failed; exit 1; }
echo done

echo

exit 0
