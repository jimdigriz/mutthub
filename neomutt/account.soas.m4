set from=SOAS_EMAIL
set envelope_from_address=SOAS_EMAIL_ENVELOPE
set postponed=+soas/Drafts
set trash=+'soas/Deleted Items'
set record=+soas/Archive

macro index "\Cs" "<tag-prefix><enter-command>unset resolve<enter><tag-prefix><clear-flag>N<tag-prefix><enter-command>set resolve<enter><tag-prefix><save-message>+'Junk Email'<enter>" "file as Spam"
macro pager "\Cs" "<save-message>+Spam<enter>" "file as Spam"

alternates ^ac56(\\+[^@]+)?@soas\\.ac\\.uk$

####
unmailboxes *

named-mailboxes \
  "Unified INBOX" "notmuch://?query=folder:/\/INBOX$/" \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX \
  "SOAS_NAME" +soas/INBOX

named-mailboxes '  Drafts' +soas/Drafts
named-mailboxes '  Archive' +soas/Archive
named-mailboxes '  Trash' +'soas/Deleted Items'
named-mailboxes '  Spam' +'soas/Junk Email'

named-mailboxes \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX
####
