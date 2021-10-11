set from=A9G_EMAIL
set envelope_from_address=A9G_EMAIL_ENVELOPE
set postponed=+Drafts
set trash=+Trash

macro index S "<tag-prefix><enter-command>unset resolve<enter><tag-prefix><clear-flag>N<tag-prefix><enter-command>set resolve<enter><tag-prefix><save-message>+Spam<enter>" "file as Spam"
macro pager S "<save-message>+Spam<enter>" "file as Spam"

alternates ^A9G_EMAIL_ENVELOPE$ 'alex(\+[^@]+)@(.*\.)?a9g\.com$'

unmailboxes *

named-mailboxes \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX \
  "A9G_NAME" +a9g/INBOX

mailboxes +a9g/INBOX/Solex
named-mailboxes '  Drafts' +a9g/Drafts
named-mailboxes '  Archive' +a9g/Archive
named-mailboxes '  Trash' +a9g/Trash
named-mailboxes '  Spam' +a9g/Spam

named-mailboxes \
  "NETWORKRADIUS_NAME" +networkradius/INBOX

