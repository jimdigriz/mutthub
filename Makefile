SHELL = /bin/sh
.DELETE_ON_ERROR:

CLEAN = 
DISTCLEAN = 

XDG_CONFIG_HOME ?= $(HOME)/.config

.PHONY: all
all: $(foreach F,neomuttrc templates/email.html $(basename $(notdir $(wildcard neomutt/account.*.m4))),$(XDG_CONFIG_HOME)/neomutt/$(F)) $(XDG_CONFIG_HOME)/msmtp/config $(HOME)/.mbsyncrc $(HOME)/.notmuch-config $(XDG_CONFIG_HOME)/afew/config maildirs
	notmuch new
CLEAN += neomutt/neomuttrc $(basename $(wildcard neomutt/account.*.m4))
DISTCLEAN += $(XDG_CONFIG_HOME)/neomutt $(HOME)/.msmtp.log $(XDG_CONFIG_HOME)/msmtp $(HOME)/.mbsyncrc $(XDG_CONFIG_HOME)/afew $(HOME)/.notmuch-config

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

$(XDG_CONFIG_HOME)/afew/config: afew.config
	@mkdir -p $(@D)
	cp $< $@

.PHONY: maildirs
maildirs: mbsyncrc
	@cat $< | sed -ne 's/^Path // p' | sed -e 's~\~~$(HOME)~g' | sort -u | xargs -r mkdir -p
