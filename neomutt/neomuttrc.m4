set use_envelope_from
set use_8bitmime
set ispell="aspell -e -c"
set realname="NAME"
set signature="printf '%s' 'NAME'|"

named-mailboxes \
  "Personal" +digriz \
  "coreMem Limited" +coremem \
  "a9g" +a9g \
  "Network RADIUS" +networkradius

folder-hook .             "source ~/.config/neomutt/account.default"
folder-hook digriz        "source ~/.config/neomutt/account.digriz"
folder-hook coremem       "source ~/.config/neomutt/account.coremem"
folder-hook a9g           "source ~/.config/neomutt/account.a9g"
folder-hook networkradius "source ~/.config/neomutt/account.networkradius"

# https://to.mw/posts/neomutt-markdown-email
macro compose m \
"<enter-command>unset wait_key<enter>\
<enter-command>set pipe_decode<enter>\
<pipe-message>pandoc -f gfm -t plain -o /tmp/msg.txt<enter>\
<pipe-message>pandoc -s -f gfm --self-contained -o /tmp/msg.html --resource-path ~/.config/neomutt/templates --template email --metadata title="-"<enter>\
<enter-command>unset pipe_decode<enter>\
<enter-command>set wait_key=yes<enter>\
<attach-file>/tmp/msg.txt<enter>\
<attach-file>/tmp/msg.html<enter>\
<tag-entry><previous-entry><tag-entry><group-alternatives>\
<edit-description><kill-line><enter>\
<previous-entry><detach-file>" \
"Convert markdown to HTML5 and plaintext alternative content types"

# https://rinzewind.org/blog-en/2017/a-small-trick-for-sending-flowed-mail-in-mutt-with-vim.html
set text_flowed
set editor="vim -c 'match ErrorMsg \"\\s\\+$\"' '+setl list tw=72 fo=watqc nojs nosmartindent spell spelllang=en_gb'"

source /etc/t-prot/Muttrc
