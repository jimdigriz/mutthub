SHELL = /bin/sh
.DELETE_ON_ERROR:

CLEAN = 
DISTCLEAN = 

XDG_CONFIG_HOME ?= $(HOME)/.config

ACCOUNTS = digriz coremem a9g networkradius

.PHONY: all
all: $(foreach F,neomuttrc templates/email.html $(foreach A,default $(ACCOUNTS),account.$(A)),$(XDG_CONFIG_HOME)/neomutt/$(F)) $(XDG_CONFIG_HOME)/msmtp/config $(HOME)/.mbsyncrc $(HOME)/.notmuch-config maildirs
CLEAN += neomutt/neomuttrc $(foreach A,$(ACCOUNTS),neomutt/account.$(A))
DISTCLEAN += $(XDG_CONFIG_HOME)/neomutt $(HOME)/.msmtp.log $(XDG_CONFIG_HOME)/msmtp $(HOME)/.mbsyncrc $(HOME)/.notmuch-config

.PHONY: clean
clean:
	rm -rf $(CLEAN)

.PHONY: distclean
distclean: clean
	rm -rf $(DISTCLEAN)

$(XDG_CONFIG_HOME)/neomutt/%: neomutt/%
	@mkdir -p $(@D)
	cp $< $@

neomutt/%: neomutt/%.m4 defines.m4
	m4 defines.m4 $< > $@

%: %.m4 defines.m4
	m4 defines.m4 $< > $@

$(HOME)/.mbsyncrc: mbsyncrc
	touch $@
	chmod 600 $@
	cat $< > $@
CLEAN += mbsyncrc

$(HOME)/.notmuch-config: notmuch-config
	cp $< $@
CLEAN += notmuch-config

$(XDG_CONFIG_HOME)/msmtp/config: msmtprc
	@mkdir -p $(@D)
	touch $@
	chmod 600 $@
	cat $< > $@
CLEAN += msmtprc

.PHONY: maildirs
maildirs: mbsyncrc
	@cat $< | sed -ne 's/^Path // p' | sed -e 's~\~~$(HOME)~g' | sort -u | xargs -r mkdir -p
