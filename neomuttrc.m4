ignore *
unignore date: subject: from: to: cc: organization: user-agent:
hdr_order date: subject: from: to: cc: organization: user-agent:

unattachments +A */.*
attachments   +A */.*
attachments   -A text/vcard text/x-vcard
attachments   -A application/pgp.*
attachments   -A application/pkcs7-.* application/x-pkcs7-.*
attachments   +I text/plain
attachments   -A message/external-body
attachments   -I message/external-body

alternative_order multipart/mixed text/enriched text/plain text/html text/markdown

#auto_view text/markdown
#auto_view text/html
#auto_view text/uri-list

mime_lookup application/octet-stream

# we only import this for the colours, the macros are handled in common/mailboxes
source /etc/t-prot/Muttrc

source /usr/share/doc/neomutt/examples/colors.angdraug
# fix url
color body brightblue default "[a-z][a-z0-9]{2,}://[\-\.\,/+=&%~_:?\#a-zA-Z0-9]+"
# fix kdb+ dates
color body cyan default "(\(19|20\)?[0-9]{2}[/.][01]?[0-9][/.][0123]?[0-9]|[0123]?[0-9][/.][01]?[0-9][/.]\(19|20\)?[0-9]{2})(( at)? +[0-9]{1,2}:[0-9]{2}(:[0-9]{2})?( ?(AM|PM|am|pm))?( +[+-][0-9]{4})?)?"
# fix sep*t*ember
color body cyan default "((Sun(day)?|Mon(day)?|Tue(sday)?|Wed(nesday)?|Thu(sday)?|Fri(day)?|Sat(urday)?),? +)?(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|June?|July?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?)[ .]+[0-9]{1,2}(st|nd|rd|th)?,?( +(19|20)[0-9]{2}(,?( at)? [0-9]{1,2}:[0-9]{2}(:[0-9]{2})?( ?(AM|PM|am|pm))?( +[+-][0-9]{4})?)?)?"
color body cyan default "((Sun(day)?|Mon(day)?|Tue(sday)?|Wed(nesday)?|Thu(sday)?|Fri(day)?|Sat(urday)?),? +)?[0-9]{1,2}(st|nd|rd|th)?[ .]+(Jan(uary)?|Feb(ruary)?|Mar(ch)?|Apr(il)?|May|June?|July?|Aug(ust)?|Sep(tember)?|Oct(ober)?|Nov(ember)?|Dec(ember)?),?( +(19|20)?[0-9]{2})?(( at)? [0-9]{1,2}:[0-9]{2}(:[0-9]{2})?( ?(AM|PM|am|pm))?( +[+-][0-9]{4})?)?"

folder-hook . 'reset all; unmailboxes *; unsubscribe *; unmy_hdr *; source PWD/neomutt/common.rc'
folder-hook ~/Mail/patsubst(DIGRIZ_EMAIL, `\.', `\\\&')/? source PWD/neomutt/DIGRIZ_EMAIL.rc
folder-hook ~/Mail/patsubst(COREMEM_EMAIL, `\.', `\\\&')/? source PWD/neomutt/COREMEM_EMAIL.rc
folder-hook ~/Mail/patsubst(KX_EMAIL, `\.', `\\\&')/? source PWD/neomutt/KX_EMAIL.rc
