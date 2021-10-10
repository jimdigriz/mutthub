SyncState *

####

MaildirStore local,digriz
Path ~/Mail/digriz
Inbox ~/Mail/digriz
SubFolders Verbatim

IMAPAccount digriz
Host DIGRIZ_SERVER_IMAP
User DIGRIZ_SERVER_IMAP_USERNAME
Pass DIGRIZ_SERVER_IMAP_PASSWORD
SSLType IMAPS
SSLVersions TLSv1.2

IMAPStore digriz
Account digriz

Channel digriz
Master :digriz:
Slave :local,digriz:
Sync Pull
Create Slave
CopyArrivalDate yes

####

MaildirStore local,coremem
Path ~/Mail/coremem
Inbox ~/Mail/coremem
SubFolders Verbatim

IMAPAccount coremem
Host COREMEM_SERVER_IMAP
User COREMEM_SERVER_IMAP_USERNAME
Pass COREMEM_SERVER_IMAP_PASSWORD
SSLType IMAPS
SSLVersions TLSv1.2

IMAPStore coremem
Account coremem

Channel coremem
Master :coremem:
Slave :local,coremem:
Sync Pull
Create Slave
CopyArrivalDate yes

####

MaildirStore local,a9g
Path ~/Mail/a9g
Inbox ~/Mail/a9g
SubFolders Verbatim

IMAPAccount a9g
Host A9G_SERVER_IMAP
User A9G_SERVER_IMAP_USERNAME
Pass A9G_SERVER_IMAP_PASSWORD
SSLType IMAPS
SSLVersions TLSv1.2

IMAPStore a9g
Account a9g

Channel a9g
Master :a9g:
Slave :local,a9g:
Sync Pull
Create Slave
CopyArrivalDate yes

####

MaildirStore local,networkradius
Path ~/Mail/networkradius
Inbox ~/Mail/networkradius
SubFolders Verbatim

IMAPAccount networkradius
Host NETWORKRADIUS_SERVER_IMAP
User NETWORKRADIUS_SERVER_IMAP_USERNAME
Pass NETWORKRADIUS_SERVER_IMAP_PASSWORD
SSLType IMAPS
SSLVersions TLSv1.2

IMAPStore networkradius
Account networkradius

Channel networkradius
Master :networkradius:
Slave :local,networkradius:
Sync Pull
Create Slave
CopyArrivalDate yes
