SyncState *

####

MaildirStore local,digriz
Path ~/Mail/digriz/
Inbox ~/Mail/digriz/INBOX
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
Patterns *
Sync Pull
Create Slave
CopyArrivalDate yes

####

MaildirStore local,coremem
Path ~/Mail/coremem/
Inbox ~/Mail/coremem/INBOX
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
Patterns *
Sync Pull
Create Slave
CopyArrivalDate yes

####

MaildirStore local,soas
Path ~/Mail/soas/
Inbox ~/Mail/soas/INBOX
SubFolders Verbatim

IMAPAccount soas
Host SOAS_SERVER_IMAP
User SOAS_SERVER_IMAP_USERNAME
Pass SOAS_SERVER_IMAP_PASSWORD
SSLType IMAPS
SSLVersions TLSv1.2

IMAPStore soas
Account soas

Channel soas
Master :soas:
Slave :local,soas:
Patterns * !Calendar !Calendar/* !Contacts !"Conversation History" !Journal !Notes !Outbox !Tasks
Sync Pull
Create Slave
CopyArrivalDate yes

####

MaildirStore local,a9g
Path ~/Mail/a9g/
Inbox ~/Mail/a9g/INBOX
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
Patterns *
Sync Pull
Create Slave
CopyArrivalDate yes

####

MaildirStore local,networkradius
Path ~/Mail/networkradius/
Inbox ~/Mail/networkradius/INBOX
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
Patterns %
Sync Pull
Create Slave
CopyArrivalDate yes
