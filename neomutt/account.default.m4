unset from
unset envelope_from_address
unset postponed
unset trash
unset record

unmacro index,pager "\Cs"

unalternates *

####
unmailboxes *

named-mailboxes \
  "Unified INBOX" "notmuch://?query=tag:inbox" \
  "DIGRIZ_NAME" +digriz/INBOX \
  "COREMEM_NAME" +coremem/INBOX \
  "SOAS_NAME" +soas/INBOX \
  "A9G_NAME" +a9g/INBOX \
  "NETWORKRADIUS_NAME" +networkradius/INBOX
####
