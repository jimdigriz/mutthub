set from=NETWORKRADIUS_EMAIL
set envelope_from_address=NETWORKRADIUS_EMAIL_ENVELOPE
set postponed=+networkradius/Drafts
set trash=+networkradius/Trash
set record=+networkradius/Archive

macro index,pager "\Cs" purge-message

alternates ^aclouter(\\+[^@]+)?@networkradius\\.com$

####
unmailboxes *

named-mailboxes \
  "Unified INBOX" "notmuch://?query=folder:/\/INBOX$/" \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX \
  "SOAS_NAME" +soas/INBOX \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX

named-mailboxes '  Drafts' +networkradius/Drafts
named-mailboxes '  Archive' +networkradius/Archive
named-mailboxes '  Trash' +networkradius/Trash
####
