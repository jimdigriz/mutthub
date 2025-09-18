set from=KX_EMAIL
set imap_user="KX_SERVER_USERNAME"
set imap_pass="KX_SERVER_PASSWORD"

set folder=+KX_EMAIL
set spool_file=+INBOX
set record=+INBOX
set trash="+Deleted Items"
set maildir_trash=yes

alternates ^patsubst(patsubst(KX_EMAIL, `^\(.*\)\(@.*\)$', `\1+.*\2'), `\.', `\\\&')$

mailboxes +INBOX +Archive

set display_filter='/bin/sh PWD/format-email.sh -f m365 -t'
macro generic \e0 ":set display_filter='/bin/sh PWD/format-email.sh -f m365'" "Turn TOFU protection off"
macro generic \e1 ":set display_filter='/bin/sh PWD/format-email.sh -f m365 -t'" "Turn TOFU protection on"
macro pager \e0 ":set display_filter='/bin/sh PWD/format-email.sh -f m365'; exec exit\n:exec display-message\n" "Turn TOFU protection off"
macro pager \e1 ":set display_filter='/bin/sh PWD/format-email.sh -f m365 -t'; exec exit\n:exec display-message\n" "Turn TOFU protection on"

set editor="exec /bin/sh PWD/editor.sh -f m365"
