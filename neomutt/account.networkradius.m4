set from=NETWORKRADIUS_EMAIL
set envelope_from_address=NETWORKRADIUS_EMAIL_ENVELOPE
set postponed=+networkradius/Drafts
set trash=+networkradius/Trash

macro index,pager S purge-message

alternates ^NETWORKRADIUS_EMAIL_ENVELOPE$ 'aclouter(\+[^@]+)@networkradius\.com$'

####
unmailboxes *

named-mailboxes \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX

named-mailboxes '  Drafts' +networkradius/Drafts
named-mailboxes '  Archive' +networkradius/Archive
named-mailboxes '  Trash' +networkradius/Trash
####
