set from=COREMEM_EMAIL
set imap_user="COREMEM_SERVER_USERNAME"
set imap_pass="COREMEM_SERVER_PASSWORD"

set folder=+COREMEM_EMAIL
set spool_file=+INBOX
set record=+INBOX
set trash=+Trash
set maildir_trash

alternates ^patsubst(COREMEM_SERVER_USERNAME, `\.', `\\\&')$ patsubst(patsubst(COREMEM_EMAIL, `^.*\(@.*\)$', `\1'), `\.', `\\\&')$ ^alex=2Bietf=40coremem\.com@dmarc\.ietf\.org$

my_hdr Organization: coreMem Limited

mailboxes +INBOX
mailboxes +INBOX.Clients.Adloox
mailboxes +INBOX.Clients.KX
mailboxes +INBOX.Clients.NetworkRADIUS
mailboxes +INBOX.Clients.Radiator
mailboxes +INBOX.Clients.SOAS
mailboxes +Archive
mailboxes +Archive.Clients.Adloox
mailboxes +Archive.Clients.KX
mailboxes +Archive.Clients.NetworkRADIUS
mailboxes +Archive.Clients.Radiator
mailboxes +Archive.Clients.SOAS
mailboxes "+Mailing Lists.IETF.emu"
mailboxes "+Mailing Lists.IETF.radext"
mailboxes "+Mailing Lists.IETF.Meeting"
mailboxes "+Mailing Lists.freeradius-users"
mailboxes "+Mailing Lists.hostapd"

subscribe @ietf.org

reply-hook ~h'list-id:\\s*.*\\.ietf\\.org>' 'set from=alex+ietf@coremem.com'

folder-hook '+Mailing Lists\.'		'set content_type="text/plain"'
folder-hook '+Mailing Lists\.'		'set text_flowed'
folder-hook '+Mailing Lists\.'		'set editor="exec /bin/sh PWD/editor.sh -p"'
folder-hook '+Mailing Lists\.IETF\.'	'set from=alex+ietf@coremem.com'
