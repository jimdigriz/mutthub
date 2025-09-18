Communications configuration centering around [`mutt`](http://mutt.org/).

# Preflight

Instructions for Debian 'trixie' 13:

    apt install --no-install-recommends \
    	aspell-en \
    	neomutt \
    	notmuch \
    	lua \
    	lua-basexx \
    	pandoc \
    	polkitd \
    	python3 \
    	python3-dateparser \
    	swayimg \
    	t-prot \
    	vim \
    	w3m \
    	w3m-img

    # pandoc is linked with Lua 5.4 so we have to symlink it in
    ln -s /usr/share/lua/5.2/basexx.lua

**N.B.** alternatively just download [`basexx.lua`](https://github.com/aiq/basexx/blob/master/lib/basexx.lua) manually

# Deploy

Copy `defines.m4.example` to `defines.m4` and edit with credentials. Finally run:

    make

# Troubleshooting

    journalctl --user -u mbsync.service -f
