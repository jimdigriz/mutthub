set abort_noattach=ask-yes
set fast_reply
set header_cache=~/.cache/mutthub/hcache/
set pager_context=1
set pager_index_lines=10
set pager_stop
set pager_read_delay=5
set sleep_time=0
set mail_check=60
set beep=no
set beep_new
set use_domain=no
set use_threads=threads sort=last-date sort_aux=date
set strict_threads
set honor_disposition
set preferred_languages=en
set include
set delete
set implicit_auto_view
set auto_edit
set maildir_header_cache_verify=no
set time_inc=100
set tilde
set new_mail_command="notify-send --icon=/usr/share/icons/hicolor/256x256/apps/neomutt.png \"You've got Mail\" '%b mailbox(es) with new messages.' &"

set sendmail="msmtp"
set realname="Alexander Clouter"
set use_envelope_from

set my_tofu=" -t"
message-hook . 'set my_msg_filter=""'
message-hook ~i'<.*\.outlook.com>' 'set my_msg_filter=" -f m365"'
message-hook ~h'references:\s*<.*\.outlook.com>' 'set my_msg_filter=" -f m365"'
message-hook . 'set display_filter="/bin/sh PWD/format-email.sh$my_msg_filter$my_tofu"'
message-hook . 'set editor="exec /bin/sh PWD/editor.sh$my_msg_filter"'

macro generic \e0 ':set my_tofu=""' 'Turn TOFU protection off'
macro generic \e1 ':set my_tofu=" -t"' 'Turn TOFU protection on'
macro pager \e0 ":set my_tofu=''; exec exit\n:exec display-message\n" 'Turn TOFU protection off'
macro pager \e1 ":set my_tofu=' -t'; exec exit\n:exec display-message\n" 'Turn TOFU protection on'

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
