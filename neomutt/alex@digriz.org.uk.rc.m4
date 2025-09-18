set from=DIGRIZ_EMAIL
set imap_user="DIGRIZ_SERVER_USERNAME"
set imap_pass="DIGRIZ_SERVER_PASSWORD"

set folder=+DIGRIZ_EMAIL
set spool_file=+INBOX
set record=+INBOX
set trash=+Trash
set maildir_trash=yes

alternates ^patsubst(DIGRIZ_SERVER_USERNAME, `\.', `\\\&')$ patsubst(patsubst(DIGRIZ_EMAIL, `^.*\(@.*\)$', `\1'), `\.', `\\\&')$

mailboxes +INBOX +Archive
