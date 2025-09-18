set from=COREMEM_EMAIL
set imap_user="COREMEM_SERVER_USERNAME"
set imap_pass="COREMEM_SERVER_PASSWORD"

set folder=+COREMEM_EMAIL
set spool_file=+INBOX
set record=+INBOX
set trash=+Trash
set maildir_trash=yes

alternates ^patsubst(COREMEM_SERVER_USERNAME, `\.', `\\\&')$ patsubst(patsubst(COREMEM_EMAIL, `^.*\(@.*\)$', `\1'), `\.', `\\\&')$ ^alex=2Bietf=40coremem\.com@dmarc\.ietf\.org$

mailboxes +INBOX +Archive "+Mailing Lists.IETF.emu" "+Mailing Lists.IETF.radext" "+Mailing Lists.IETF.Meeting" "+Mailing Lists.freeradius-users" "+Mailing Lists.hostapd"

subscribe @ietf.org

reply-hook ~h'list-id:\\s*.*\\.ietf\\.org>' 'set from=alex+ietf@coremem.com'

folder-hook '^+Mailing Lists\\.'	'set content_type="text/plain"'
folder-hook '^+Mailing Lists\\.'	'set text_flowed'
folder-hook '^+Mailing Lists\\.'	'set editor="exec /bin/sh PWD/editor.sh -p"'
folder-hook '^+Mailing Lists\\.IETF\\.'	'set from=alex+ietf@coremem.com'
