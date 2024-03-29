set from=COREMEM_EMAIL
set envelope_from_address=COREMEM_EMAIL_ENVELOPE
set postponed=+coremem/Drafts
set trash=+coremem/Trash
set record=+coremem/INBOX

macro index "\Cs" "<tag-prefix><enter-command>unset resolve<enter><tag-prefix><clear-flag>N<tag-prefix><enter-command>set resolve<enter><tag-prefix><save-message>+Spam<enter>" "file as Spam"
macro pager "\Cs" "<save-message>+Spam<enter>" "file as Spam"

alternates @([^@]+\\.)?coremem\\.com$

####
unmailboxes *

named-mailboxes \
  "Unified INBOX" "notmuch://?query=folder:/\/INBOX$/" \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX

mailboxes +coremem/INBOX/Clients
mailboxes +coremem/INBOX/Clients/Adloox +coremem/INBOX/Clients/KX +coremem/INBOX/Clients/SOAS
named-mailboxes '  Drafts' +coremem/Drafts
named-mailboxes '  Archive' +coremem/Archive
named-mailboxes '  Clients' +coremem/Archive/Clients
named-mailboxes \
                '  Adloox' +coremem/Archive/Clients/Adloox \
                '  KX' +coremem/Archive/Clients/KX \
                '  SOAS' +coremem/Archive/Clients/SOAS
named-mailboxes '  Trash' +coremem/Trash
named-mailboxes '  Spam' +coremem/Spam

named-mailboxes \
  "SOAS_NAME" +soas/INBOX \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX
####

folder-hook +coremem/(INBOX|Archive)/Clients/Adloox "set record=+coremem/INBOX/Clients/Adloox"
folder-hook +coremem/(INBOX|Archive)/Clients/KX "set record=+coremem/INBOX/Clients/KX"
folder-hook +coremem/(INBOX|Archive)/Clients/SOAS "set record=+coremem/INBOX/Clients/SOAS"
