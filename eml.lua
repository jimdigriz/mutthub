-- eml.lua - pandoc EML filter
-- Copyright (C) 2025, Alexander Clouter <alex@digriz.org.uk>
-- SPDX-License-Identifier: GPL-3.0-only

-- Inspired by:
-- https://begriffs.com/posts/2020-07-16-generating-mime-email.html
-- https://github.com/begriffs/mimedown/

-- Dependencies:
--  * curl
--  * file
--  * lua-basexx (pandoc is linked with Lua 5.4 so we have to symlink it in)
--  * pandoc (tested with 3.1.11.1)

-- Usage:
-- env MESSAGE_ID=... BOUNDARY=... pandoc --eol=crlf -f commonmark -t eml.lua message.md

-- Structure:
-- multipart/mixed [environment variable BOUNDARY is used]
--  multipart/related
--   multipart/alternative
--    multipart/mixed
--     text/plain {inline}
--     ...
--     text/uri-list {inline}
--    text/html {inline}
--    text/markdown {inline}
--   cid {inline}
--   ...
--  [attachments to be added by your UA]

-- Render Results:
--  * neomutt works fine
--     * other: needs 'alternative_order multipart/mixed ...'
--  * GMail:
--     * html: renders fine
--     * NOTE: inline content with filenames is treated as attachment and not shown
--  * Fastmail works fine
--     * html: renders fine
--     * plain: same as Gmail
--  * FairEmail (Android version >1.2300)
--     * html: renders fine
--     * plain: renders fine (except text/uri-list) but =<1.2300 same as Gmail
--  * AquaMail (Android release 2025-06-25):
--     * html: renders fine
--     * plain: renders only the first part
--     * NOTE: for both everything after the first text/plain part is shown as an attachment
--  * M365 Outlook Web
--     * html: renders fine
--     * plain: renders only the first part
--     * NOTE: for both everything after the first text/plain part is shown as an attachment

-- TODO
--  * text: implement format=flowed
--  * text: if all parts are just filename-less inline, merge them into one
--  * text: nested CodeBlock's inside a Block
--  * text: include filename of cid to make it clearer what is there
--  * text: rewrite got_filenames/flatten so we write straight into the previous Block
--  * pandoc: just the presence of filenames in a codeblock makes it 6x slower (80ms to 500ms)

local basexx = require "basexx"

local message_id = os.getenv("MESSAGE_ID")
assert(message_id, "missing MESSAGE_ID env")

local boundary = os.getenv("BOUNDARY")
assert(boundary, "missing BOUNDARY env")

math.randomseed(os.time())
local function random_hex_string (l)
	local v = ""
	for i = 1, l do
		v = v .. string.format("%02x", math.random(0, 255))
	end
	return v
end

--- http://lua-users.org/wiki/StringTrim
local function trim (s)
	return s:gsub("^%s+", ""):gsub("%s+$", "")
end

local function encode_7bit (body0)
	local l = 1
	for i=1,body0:len() do
		local v = body0:sub(i, i)
		local b = v:byte()
		if b > 127 then
			return false
		end
		if b == 10 then
			l = 1
		else
			l = l + 1
		end
		-- 1000 sans the trailing CRLF
		if l == 998 then
			return false
		end
	end
	return true
end

-- https://datatracker.ietf.org/doc/html/rfc2045#section-6.7
local function encode_quoted_printable (body0)
	local l = 1
	local body = {}
	for i=1,body0:len() do
		local v = body0:sub(i, i)
		local b = v:byte()
		local qp = true
		if (b >= 33 and b <= 60) or (b >= 62 and b <= 126) then
			qp = false
		elseif l < 76 and (b == 9 or b == 32) then
			qp = false
		elseif b == 10 then
			qp = false
		end
		if qp then
			v = string.format("=%02X", b)
		end
		if l + v:len() > 76 then
			table.insert(body, "=\n")
			l = 1
		end
		table.insert(body, v)
		if b == 10 then
			l = 1
		else
			l = l + v:len()
		end
	end
	return table.concat(body, "")
end

local function encode_base64 (body0)
	local body0 = basexx.to_base64(body0)
	local body = {}
	for i=1,body0:len(),76 do
		table.insert(body, body0:sub(i, i + 75))
	end
	return table.concat(body, "\n")
end

local function encode (headers, body0)
	if encode_7bit(body0) then
		return headers, body0
	end
	body = encode_quoted_printable(body0)
	-- estimate the base64 encoded version size (including newlines)
	b64len = body0:len() * 1.33
	b64len = b64len + (b64len / 76)
	if body:len() <= b64len then
		table.insert(headers, { "content-transfer-encoding", "quoted-printable" })
	else
		body = encode_base64(body0)
		table.insert(headers, { "content-transfer-encoding", "base64" })
	end
	return headers, body
end

local function text (doc, opts)
	local parts = {}
	local in_message = false
	local got_filenames = false

	local links = {}
	doc:walk({
		Link = function (el)
			table.insert(links, {
				content = trim(pandoc.write(pandoc.Pandoc({el.content}), "plain")),
				target = el.target
			})
			table.insert(el.content, pandoc.space)
			table.insert(el.content, "[" .. tostring(#links) .. "]")
			return el.content
		end
	}):walk({
		-- https://pandoc.org/lua-filters.html#traversal-order
		traverse = "topdown",

		Block = function (el)
			local headers, body
			if el.tag == "CodeBlock" then
				headers = {
					{ "content-type", "text/plain; charset=utf-8" },
					{ "content-disposition", "inline" },
				}
				if #el.classes == 0 then
					body = el
				else
					got_filenames = true
					headers[2][2] = headers[2][2] .. "; filename=" .. el.classes[1]
					body = pandoc.Plain({el.text})
				end
				table.insert(parts, { headers, { body } })
				in_message = false
			else
				if not in_message then
					headers = {
						{ "content-type", "text/plain; charset=utf-8" },
						{ "content-disposition", "inline" },
					}
					body = {}
					table.insert(parts, { headers, body })
					in_message = true
				end
				table.insert(parts[#parts][2], el)
			end

			-- https://pandoc.org/lua-filters.html#topdown-traversal
			return nil, false
		end
	})

	-- fold down to a single part
	if not got_filenames then
		for i=#parts,2,-1 do
			local t = table.remove(parts, i)
			local headers = t[1]
			local body = t[2]
			for j, b in ipairs(body) do
				table.insert(parts[i-1][2], b)
			end
		end
	end
	for i=1,#parts do
		parts[i][2] = pandoc.write(pandoc.Pandoc(parts[i][2]), "plain", opts)
		parts[i][1], parts[i][2] = encode(parts[i][1], parts[i][2])
	end

	-- https://datatracker.ietf.org/doc/html/rfc2483#section-5
	if #links > 0 then
		local headers = {
			{ "content-type", "text/uri-list; charset=utf-8" },
			{ "content-disposition", "inline" },
		}
		local body = {}
		for i, v in ipairs(links) do
			table.insert(body, "# [" .. tostring(i) .. "] " .. v.content)
			table.insert(body, v.target)
		end
		headers, body = encode(headers, table.concat(body, "\n"))
		table.insert(parts, { headers, body })
	end

	local headers
	local body
	if #parts == 1 then
		headers = parts[1][1]
		body = parts[1][2]
	else
		headers = "multipart/mixed"
		body = parts
	end
	return headers, body
end

local function html (doc, opts)
	local headers = {
		{ "content-type", "text/html; charset=utf-8" },
		{ "content-disposition", "inline" },
	}
	local image = 0
	local filter = {
		Image = function (el)
			image = image + 1
			el.src = "cid:i" .. tostring(image) .. "." .. message_id
			return el
		end
	}
	local body = pandoc.write(doc:walk(filter), "html", opts)
	return encode(headers, body)
end

local function markdown (doc)
	local headers = {
		{ "content-type", "text/markdown; charset=utf-8; variant=CommonMark" },
		{ "content-disposition", "inline" },
	}
	local image = 0
	local filter = {
		Image = function (el)
			image = image + 1
			el.src = "cid:i" .. tostring(image) .. "." .. message_id
			return el
		end
	}
	local body = pandoc.write(doc:walk(filter), "commonmark", opts)
	return encode(headers, body)
end

local function build (doc, opts, boundary0, structure)
	local parts = {}
	for i, v in ipairs(structure) do
		local headers
		local body
		if type(v) == "function" then
			headers, body = v(doc, opts)
		else
			headers = v[1]
			body = v[2]
		end
		if type(headers) == "string" then
			-- https://datatracker.ietf.org/doc/html/rfc2045#section-6.7
			local boundary = "_=" .. random_hex_string(20) .. "=_"
			headers = {
				{ "content-type", headers .. "; boundary=" .. boundary },
			}
			body = build(doc, opts, boundary, body)
		end
		assert(type(headers) == "table", "unsupported")
		assert(type(body) == "string", "unsupported")
		local part = ""
		for i, h in ipairs(headers) do
			part = part .. table.concat(h, ": ") .. "\n"
		end
		part = part .. "\n"
		part = part .. body
		table.insert(parts, part)
	end

	local ret
	ret =        "--" .. boundary0 .. "\n"
	ret = ret .. table.concat(parts, "\n--" .. boundary0 .. "\n")
	ret = ret .. "\n--" .. boundary0 .. "--"
	return ret
end

function Writer (doc, opts)
	-- https://pandoc.org/lua-filters.html#type-writeroptions
	opts.wrap_text = "wrap-none"

	local structure = {
		{ "multipart/related", {
			{ "multipart/alternative", {
				text,
				html,
				markdown
			}}
		}}
	}
	local cid = 0
	doc:walk({
		Image = function(el)
			cid = cid + 1
			if el.src:find("^file://") then
				el.src = el.src:sub(8)
			end
			local filepath = el.src
			local fh, tmpfile
			if filepath:find("^[a-z][a-z0-9]+://") then
				fh = assert(io.popen("mktemp"))
				tmpfile = fh:read("*line")
				fh:close()
				os.execute("curl --compressed -sfLo '" .. tmpfile .. "' '" .. el.src .. "'")
				filepath = tmpfile
			end
			fh = assert(io.open(filepath, "rb"))
			local body0 = basexx.to_base64(fh:read("*all"))
			fh:close()
			fh = assert(io.popen("file --brief --mime-type '" .. filepath .. "'"))
			local content_type = fh:read("*line")
			fh:close()
			if tmpfile ~= nil then
				os.remove(tmpfile)
			end
			local body = {}
			for i=1,#body0,76 do
				table.insert(body, body0:sub(i, i + 75))
			end
			body = table.concat(body, "\n")

			local filename = el.src:gsub("^.*/", ""):gsub("?.*$", "")
			local description = trim(pandoc.write(pandoc.Pandoc({el.caption}), "plain"))
			local headers = {
				{ "content-type", content_type },
				{ "content-description", description },
				{ "content-disposition", "inline; filename=" .. filename },
				{ "content-transfer-encoding", "base64" },
				{ "content-id", "<i" .. tostring(cid) .. "." .. message_id .. ">" },
			}
			-- append to multipart/related
			table.insert(structure[1][2], { headers, body })
		end
	})
	return build(doc, opts, boundary, structure)
end
