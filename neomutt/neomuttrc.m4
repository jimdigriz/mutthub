set use_envelope_from
set use_8bitmime
set ispell="aspell -e -c"
set realname="NAME"
set signature="printf '%s' 'NAME'|"
set abort_noattach

set sidebar_visible
set sidebar_short_path
set sidebar_delim_chars="/"
set sidebar_folder_indent
set sidebar_indent_string="  "

bind index,pager B sidebar-toggle-visible
bind index,pager \Cp sidebar-prev
bind index,pager \Cn sidebar-next
bind index,pager \Co sidebar-open

set spoolfile="Unified INBOX"

folder-hook .               "set header_cache=~/.cache/neomutt/header"
folder-hook (^notmuch:)     "unset header_cache"

folder-hook .               "source ~/.config/neomutt/account.default"
folder-hook +digriz/        "source ~/.config/neomutt/account.digriz"
folder-hook +coremem/       "source ~/.config/neomutt/account.coremem"
folder-hook +a9g/           "source ~/.config/neomutt/account.a9g"
folder-hook +networkradius/ "source ~/.config/neomutt/account.networkradius"

folder-hook .           "set sort=threads"
folder-hook (Spam|Junk) "set sort=date"
#folder-hook .           "set use_threads=threads sort=date sort_aux=date"
#folder-hook (Spam|Junk) "set use_threads=flat sort=date sort_aux=date"

bind pager D purge-message

# https://to.mw/posts/neomutt-markdown-email
macro compose m \
"<enter-command>unset wait_key<enter>\
<enter-command>set pipe_decode<enter>\
<pipe-message>pandoc -f gfm -t plain -o /tmp/msg.txt<enter>\
<pipe-message>pandoc -s -f gfm --self-contained -o /tmp/msg.html --resource-path ~/.config/neomutt/templates --template email --metadata title="-"<enter>\
<enter-command>unset pipe_decode<enter>\
<enter-command>set wait_key<enter>\
<attach-file>/tmp/msg.txt<enter>\
<attach-file>/tmp/msg.html<enter>\
<tag-entry><previous-entry><tag-entry><group-alternatives>\
<edit-description><kill-line><enter>\
<previous-entry><detach-file>" \
"Convert markdown to HTML5 and plaintext alternative content types"

# https://rinzewind.org/blog-en/2017/a-small-trick-for-sending-flowed-mail-in-mutt-with-vim.html
set text_flowed
set editor="vim -c 'match ErrorMsg \"\\s\\+$\"' '+setl list tw=72 fo=watqc nojs nosmartindent spell spelllang=en_gb'"

source /etc/Muttrc.d/notmuch-mutt.rc
source /etc/Muttrc.d/t-prot.rc
