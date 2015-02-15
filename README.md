This project has the moving parts that make up how I handle email, others may find it useful.

## Issues

 * notmuch support
 * background smtp
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

# Preflight

You will need to [have git installed on your workstation](http://git-scm.com/book/en/Getting-Started-Installing-Git).

    $ git clone https://github.com/jimdigriz/mutthub.git
    $ cd mutthub
    
    $ cp example.macros macros

As you amend the configuration files detailed below, you can use the `macros` to handle substitutions for you.

## Debian

    $ sudo apt-get install -yy --no-install-recommends \
    	mutt-patched notmuch-mutt msmtp aspell-en \
    	runit offlineimap lbdb signify t-prot \
    	fortunes-min fortunes-bofh-excuses urlscan

# Deploy

## mutt

You should copy `mutt/accounts/_template` to `mutt/accounts/main` as you see fit, to create individual accounts.

**N.B.** pay attention to the `# :hook` commands at the top of those files, they do the plumbing

    $ mkdir -p ~/.mutt/accounts
    $ touch ~/.mutt/aliases ~/.mutt/certificates
    $ sudo cp lbdbwrap /usr/local/bin
    $ find mutt -type f -name '[_a-zA-Z0-9]*' ! -name '_template' | awk '{ printf "touch ~/.%s && chmod 600 ~/.%s && utils/macros %s >> ~/.%s\n", $1, $1, $1, $1 }' | xargs -I{} sh -c "{}"

## msmtp

    $ touch ~/.msmtprc
    $ chmod 600 ~/.msmtprc
    $ utils/macros msmtprc >> ~/.msmtprc

## offlineimap

    $ touch ~/.offlineimaprc
    $ chmod 600 ~/.offlineimaprc
    $ utils/macros offlineimaprc >> ~/.offlineimaprc
    $ mkdir ~/service
    $ cp -r runit/offlineimap ~/service
    $ echo "$HOME" > ~/service/offlineimap/env/HOME
    
    $ sudo mkdir -p /etc/sv/runsvdir-$USER
    $ sudo touch /etc/sv/runsvdir-$USER/run
    $ sudo chmod +x /etc/sv/runsvdir-$USER/run
    $ cat <<EOF | sudo cat >> /etc/sv/runsvdir-$USER/run
    #!/bin/sh
    
    set -eu
    
    exec 2>&1
    exec chpst -u $USER runsvdir /home/$USER/service
    EOF
