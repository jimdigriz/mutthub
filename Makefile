SHELL = /bin/sh
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:
.DELETE_ON_ERROR:

XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_STATE_HOME ?= $(HOME)/.local/state

SIGNATURE = $(HOME)/.signature
NEOMUTTRC = $(XDG_CONFIG_HOME)/neomutt/neomuttrc
ISYNCRC = $(XDG_CONFIG_HOME)/isyncrc
MSMTP = $(XDG_CONFIG_HOME)/msmtp/config
MAILCAP = $(HOME)/.mailcap
SYSTEMD_USER = $(XDG_CONFIG_HOME)/systemd/user

UNITS = $(wildcard systemd/*.timer systemd/*.service)

TARGETS  = $(SIGNATURE) $(NEOMUTTRC) $(ISYNCRC) $(MSMTP) $(MAILCAP)
TARGETS += $(basename $(wildcard neomutt/*.rc.m4))
TARGETS += $(foreach U,$(notdir $(UNITS)),$(SYSTEMD_USER)/$(U))

.PHONY: all
all: $(TARGETS)
	loginctl enable-linger
	systemctl --user enable $(UNITS)
	systemctl --user start mbsync.timer

.PHONY: clean
clean:
	systemctl --user disable --now $(notdir $(UNITS)) || true
	systemctl --user daemon-reload
	find $(HOME) -mindepth 1 -maxdepth 1 -type f -name '.neomuttdebug*' -delete
	rm -f $(TARGETS)

.PHONY: distclean
distclean: clean
	rm -rf '$(HOME)/.local/state/isync'
	rm -rf '$(HOME)/.cache/mutthub/hcache'

%: defines.m4 %.m4
	umask 077 && m4 -D PWD='$(PWD)' -D FQDN=$(shell hostname) $^ > $@

$(SIGNATURE): signature
	mkdir -p -m 700 $(@D)
	ln -f -s -r $^ $@

$(NEOMUTTRC): neomuttrc
	mkdir -p -m 700 $(@D)
	ln -f -s -r $^ $@

$(ISYNCRC): isyncrc
	mkdir -p -m 700 $(@D)
	ln -f -s -r $^ $@

# use cp over ln due to AppArmor
$(MSMTP): msmtp
	mkdir -p -m 700 $(@D)
	cp -f $^ $@

$(MAILCAP): mailcap
	ln -f -s -r $^ $@

$(SYSTEMD_USER)/%: systemd/%
	mkdir -p -m 700 $(@D)
	ln -f -s -r -t $(@D) $^
	systemctl --user daemon-reload
