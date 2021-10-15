set from=A9G_EMAIL
set envelope_from_address=A9G_EMAIL_ENVELOPE
set postponed=+a9g/Drafts
set trash=+a9g/Trash
set record=+a9g/Archive

macro index "\Cs" "<tag-prefix><enter-command>unset resolve<enter><tag-prefix><clear-flag>N<tag-prefix><enter-command>set resolve<enter><tag-prefix><save-message>+Spam<enter>" "file as Spam"
macro pager "\Cs" "<save-message>+Spam<enter>" "file as Spam"

alternates ^alex(\\+[^@]+)?@([^@]+\\.)?a9g\\.com$

####
unmailboxes *

named-mailboxes \
  "Unified INBOX" "notmuch://?query=folder:/\/INBOX$/" \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX \
  "SOAS_NAME" +soas/INBOX \
  "A9G_NAME" +a9g/INBOX

named-mailboxes '  Drafts' +a9g/Drafts
named-mailboxes '  Archive' +a9g/Archive
named-mailboxes '  Trash' +a9g/Trash
named-mailboxes '  Spam' +a9g/Spam

named-mailboxes \
  "NETWORKRADIUS_NAME" +networkradius/INBOX
####
