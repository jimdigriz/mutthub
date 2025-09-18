MaildirStore digriz
Path ~/Mail/DIGRIZ_EMAIL/
Inbox ~/Mail/DIGRIZ_EMAIL/INBOX
SubFolders Verbatim
Flatten .

IMAPAccount DIGRIZ_EMAIL
Host DIGRIZ_SERVER_IMAP
Port ifdef(`DIGRIZ_SERVER_IMAP_PORT', `DIGRIZ_SERVER_IMAP_PORT', `993')
TLSVersions -1.0 -1.1 -1.2 +1.3
TLSType IMAPS
User DIGRIZ_SERVER_USERNAME
Pass DIGRIZ_SERVER_PASSWORD

IMAPStore DIGRIZ_EMAIL
Account DIGRIZ_EMAIL
Trash Trash

Channel digriz
Near :digriz:
Far :DIGRIZ_EMAIL:
Patterns INBOX Archive Trash
Create Near
CopyArrivalDate yes
Expunge Near
Sync Pull Full
SyncState *

###################

MaildirStore coremem
Path ~/Mail/COREMEM_EMAIL/
Inbox ~/Mail/COREMEM_EMAIL/INBOX
SubFolders Verbatim
Flatten .

IMAPAccount COREMEM_EMAIL
Host COREMEM_SERVER_IMAP
Port ifdef(`COREMEM_SERVER_IMAP_PORT', `COREMEM_SERVER_IMAP_PORT', `993')
TLSVersions -1.0 -1.1 -1.2 +1.3
TLSType IMAPS
User COREMEM_SERVER_USERNAME
Pass COREMEM_SERVER_PASSWORD

IMAPStore COREMEM_EMAIL
Account COREMEM_EMAIL
Trash Trash

Channel coremem
Near :coremem:
Far :COREMEM_EMAIL:
Patterns INBOX Archive Trash Archive/Clients/% "!Mailing Lists" "Mailing Lists/%" "!Mailing Lists/IETF" "Mailing Lists/IETF/%"
Create Near
CopyArrivalDate yes
Expunge Near
Sync Pull Full
SyncState *

###################

MaildirStore kx
Path ~/Mail/KX_EMAIL/
Inbox ~/Mail/KX_EMAIL/INBOX
SubFolders Verbatim
Flatten .

IMAPAccount KX_EMAIL
Host KX_SERVER_IMAP
Port ifdef(`KX_SERVER_IMAP_PORT', `KX_SERVER_IMAP_PORT', `993')
TLSVersions -1.0 -1.1 -1.2 +1.3
TLSType IMAPS
User KX_SERVER_USERNAME
Pass KX_SERVER_PASSWORD
PipelineDepth 10

IMAPStore KX_EMAIL
Account KX_EMAIL
Trash "Deleted Items"

Channel KX_EMAIL
Near :kx:
Far :KX_EMAIL:
Patterns INBOX Archive "Deleted Items"
Create Near
CopyArrivalDate yes
Expunge Near
Sync Pull Full
SyncState *
