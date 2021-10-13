set from=DIGRIZ_EMAIL
set envelope_from_address=DIGRIZ_EMAIL_ENVELOPE
set postponed=+digriz/Drafts
set trash=+digriz/Trash
set record=+digriz/Archive

macro index "\Cs" "<tag-prefix><enter-command>unset resolve<enter><tag-prefix><clear-flag>N<tag-prefix><enter-command>set resolve<enter><tag-prefix><save-message>+'Junk Mail'<enter>" "file as Spam"
macro pager "\Cs" "<save-message>+'Junk Mail'<enter>" "file as Spam"

alternates @(.*\.)?digriz\.org\.uk$

####
unmailboxes *

named-mailboxes \
  "Unified INBOX" "notmuch://?query=tag:inbox" \
  "DIGRIZ_NAME" +digriz/INBOX

named-mailboxes '  Drafts' +digriz/Drafts
named-mailboxes '  Archive' +digriz/Archive
named-mailboxes '  Trash' +digriz/Trash
named-mailboxes '  Spam' +'digriz/Junk Mail'

named-mailboxes \
  "COREMEM_NAME" +coremem/INBOX \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX
####
