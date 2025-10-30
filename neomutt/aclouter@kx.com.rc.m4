set from=KX_EMAIL
set imap_user="KX_SERVER_USERNAME"
set imap_pass="KX_SERVER_PASSWORD"

set folder=+KX_EMAIL
set spool_file=+INBOX
set record=+INBOX
set trash="+Deleted Items"
set maildir_trash

alternates ^patsubst(patsubst(KX_EMAIL, `^\(.*\)\(@.*\)$', `\1+.*\2'), `\.', `\\\&')$

my_hdr Organization: KX Systems, Inc.

mailboxes +INBOX
mailboxes +Archive
