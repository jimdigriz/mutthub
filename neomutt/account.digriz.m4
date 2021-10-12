set from=DIGRIZ_EMAIL
set envelope_from_address=DIGRIZ_EMAIL_ENVELOPE
set postponed=+digriz/Drafts
set trash=+digriz/Trash

macro index S "<tag-prefix><enter-command>unset resolve<enter><tag-prefix><clear-flag>N<tag-prefix><enter-command>set resolve<enter><tag-prefix><save-message>+'Junk Mail'<enter>" "file as Spam"
macro pager S "<save-message>+'Junk Mail'<enter>" "file as Spam"

alternates ^DIGRIZ_EMAIL_ENVELOPE$ '@(.*\.)?digriz\.org\.uk$'

unmailboxes *

named-mailboxes \
  "DIGRIZ_NAME" +digriz/INBOX

named-mailboxes '  Drafts' +digriz/Drafts
named-mailboxes '  Archive' +digriz/Archive
named-mailboxes '  Trash' +digriz/Trash
named-mailboxes '  Spam' +'digriz/Junk Mail'

named-mailboxes \
  "COREMEM_NAME" +coremem/INBOX \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX
