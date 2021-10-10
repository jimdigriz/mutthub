This project has the moving parts that make up how I handle email, others may find it useful.

# Preflight

You will need to [have git installed on your workstation](http://git-scm.com/book/en/Getting-Started-Installing-Git).

    git clone https://github.com/jimdigriz/mutthub.git
    cd mutthub

## Debian

    $ sudo apt-get -y install --no-install-recommends \
        aspell-en \
        isync \
#        lbdb \
        make
        msmtp-mta \
        muttdown \
        neomutt \
        notmuch-mutt \
        pandoc \
        t-prot \
#        urlscan

# Configuration

Make a copy of [`defines.m4.example`](./defines.m4.example) for yourself and edit `defines.m4` with your own settings:

    cp defines.m4.example defines.m4

For your own account customisations you should look to creating your own `neomutt/account.NAME.m4` files.

Accounts are plumbed in via the [main configuration file](./neomutt/neomuttrc.m4)

# Deploy

    make
