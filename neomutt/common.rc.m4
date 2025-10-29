set abort_noattach=ask-yes
set fast_reply=yes
set header_cache=~/.cache/mutthub/hcache/
set pager_index_lines=10
set pager_stop
set pager_read_delay=5
set use_domain=no
set use_threads=threads sort=last-date sort_aux=date
set strict_threads=yes
set honor_disposition=yes
set preferred_languages=en
set include=yes
set implicit_auto_view=yes

set sendmail="msmtp"
set realname="Alexander Clouter"
set use_envelope_from=yes

set display_filter='/bin/sh PWD/format-email.sh -t'
macro generic \e0 ":set display_filter='/bin/sh PWD/format-email.sh'" "Turn TOFU protection off"
macro generic \e1 ":set display_filter='/bin/sh PWD/format-email.sh -t'" "Turn TOFU protection on"
macro pager \e0 ":set display_filter='/bin/sh PWD/format-email.sh'; exec exit\n:exec display-message\n" "Turn TOFU protection off"
macro pager \e1 ":set display_filter='/bin/sh PWD/format-email.sh -t'; exec exit\n:exec display-message\n" "Turn TOFU protection on"

set send_charset="utf-8:iso-8859-1:us-ascii"
# https://datatracker.ietf.org/doc/html/rfc7764#section-3.5
#set content_type="text/markdown; charset=utf-8; variant=CommonMark"
set ispell="exec aspell -e -c"

# we use quoted-printable instead and disable line wrapping
# https://www.fastmail.com/blog/format-flowed/
# https://mathiasbynens.be/notes/gmail-plain-text
set text_flowed=no

# mailcap 'edit=' used as this only applies to text/plain and not text/markdown
set editor="exec /bin/sh PWD/editor.sh -p"

mailboxes -label "DIGRIZ_NAME" -poll -notify +DIGRIZ_EMAIL/INBOX
mailboxes -label "COREMEM_NAME" -poll -notify +COREMEM_EMAIL/INBOX
mailboxes -label "KX_NAME" -poll -notify +KX_EMAIL/INBOX

reply-hook ~h'list-id:\\s*' 'unset record'
