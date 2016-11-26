This project has the moving parts that make up how I handle email, others may find it useful.

## Issues

 * use expect/openssl/... to do IMAP idle
  * ...and splice in and out mbsync into the existing connection
 * formating of email sent is different to how it was saved in editor
 * xargs -0 sh -c 'exec /usr/lib/sendmail -- "$@" < "$FILE.msg"' -f -- < "$FILE.arg"
 * better mailcap
 * improve use of par
 * notmuch support
 * mailing list handling
  * including the case where server sends me another copy as I am a member (Exchange...)
 * URL extract
 * address book
 * failure to send email, still drops copy in INBOX due to Fcc, leading to dupes
  * can we Fcc *after* sendmail?
  * Bcc self a better option?
  * does it matter once I do background smtp?
 * signature strip written in sed
 * handle scoring
 * whilst composing an email, viewing attachments added breaks if the filename has spaces
 * lbdb changes
  * remove dupes
  * sending email, have it ignore the 'from' field

# Preflight

You will need to [have git installed on your workstation](http://git-scm.com/book/en/Getting-Started-Installing-Git).

    $ git clone https://github.com/jimdigriz/mutthub.git
    $ cd mutthub
 
    $ cp example.macros macros

As you amend the configuration files detailed below, you can use the `macros` to handle substitutions for you.

## Debian

    $ sudo apt-get install -yy --no-install-recommends \
    	mutt-patched notmuch-mutt msmtp-mta aspell-en \
    	lbdb signify t-prot par isync urlscan

# Configuration

## mutt

You should copy `mutt/accounts/_template` to `mutt/accounts/main` as you see fit, to create individual accounts.

**N.B.** pay attention to the `# :hook` commands at the top of those files, they do the plumbing

## mbsync

Edit the end of the file as you see fit.

## msmtp

Edit the end of the file as you see fit.

# Deploy

    $ ./deploy.sh

## First Time

You will need to run the following for a first time install:

    $ mkdir ~/.vcards
    
    $ sudo cp lbdbwrap /usr/local/bin
    $ sudo cp sendmailq /usr/local/bin
    $ sudo cp format-email /usr/local/bin
