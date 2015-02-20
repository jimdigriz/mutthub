This project has the moving parts that make up how I handle email, others may find it useful.

## Issues

 * notmuch support
 * TLS timeout, O365 looking at my PTR records?
 * mailing list handling
  * including the case where server sends me another copy as I am a member (Exchange...)
 * URL extract
 * address book
 * no work account on personal workstation
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

We also need a recent version of [offlineimap](http://offlineimap.org/):

    $ git clone https://github.com/OfflineIMAP/offlineimap.git
    $ cd offlineimap
    $ make -C offlineimap
    $ ( cd offlineimap && python setup.py install )

## Debian

    $ sudo apt-get install -yy --no-install-recommends \
    	mutt-patched notmuch-mutt msmtp-mta aspell-en \
    	runit lbdb signify t-prot \
    	fortunes-min fortunes-bofh-excuses urlscan

# Configuration

## mutt

You should copy `mutt/accounts/_template` to `mutt/accounts/main` as you see fit, to create individual accounts.

**N.B.** pay attention to the `# :hook` commands at the top of those files, they do the plumbing

## offlineimap

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
    
    $ sudo mkdir /etc/sv/runsvdir-$USER
    $ sudo touch /etc/sv/runsvdir-$USER/run
    $ sudo chmod +x /etc/sv/runsvdir-$USER/run
    $ cat <<EOF | sudo cat >> /etc/sv/runsvdir-$USER/run
    #!/bin/sh
    
    set -eu
    
    exec 2>&1
    exec chpst -u $USER runsvdir /home/$USER/service
    EOF

This will start offlineimap almost instantly, but for a first run you may wish to run it all in debug mode:

    sv -w 30 force-stop ~/service/offlineimap
    env DEBUG=1 sh -x ~/service/offlineimap/run

Optionally you may want to use TTYUI due to rendering glitches, so run:

    env DEBUG=1 UI=ttyui sh -x ~/service/offlineimap/run
