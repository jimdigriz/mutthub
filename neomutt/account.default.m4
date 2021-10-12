unset from
unset envelope_from_address
unset postponed
unset trash

unmacro index,pager S

unalternates *

####
unmailboxes *

named-mailboxes \
  "Unified INBOX" "notmuch://?query=tag:inbox" \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX
####
