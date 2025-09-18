#!/usr/bin/env python3

# not the only person upset https://superuser.com/a/382592

# usually I would use Perl or sed, but then no
# one else would ever understand it, so here I
# find myself using a ghetto language... :(

from datetime import datetime
import fileinput
from io import TextIOWrapper
import re
import sys
from urllib.parse import parse_qs, urlparse

REPLY_MAGIC = '\x1E'

GARBAGE = [
    r'^_{16,}$',                                      # <hr/>
    r'^CAUTION: ',                                    # O365 warning
    r'^Sent from Outlook for ',                       # spam
    r'https://aka.ms/LearnAboutSenderIdentification'  # silly inlined warning
]

# cover the common formats so we avoid the penalty described in to_datetime()
DATETIME_FORMATS0 = [
    '%A, %d %B %Y at',
    '%A, %d %B %Y',
    '%A %d %B %Y',
    '%A, %B %d, %Y at',
    '%A, %B %d, %Y',
    '%d %B %Y',
    '%B %d, %Y',
]
DATETIME_FORMATS = []
for dtfmt in DATETIME_FORMATS0:
    DATETIME_FORMATS.extend([
        f'{dtfmt} %H:%M:%S',
        f'{dtfmt} %H:%M',
        f'{dtfmt} %I:%M:%S %p',
        f'{dtfmt} %I:%M %p',
    ])

def to_datetime(v):
    # convert all whitespace (including unicode) to a single space
    v = re.sub(r'\s+', ' ', v)
    for fmt in DATETIME_FORMATS:
        try:
            return datetime.strptime(v, fmt)
        except ValueError:
            pass
    # adds 200ms import load lag
    try:
        import dateparser
    except ModuleNotFoundError:
        return None
    return dateparser.parse(v)

message = []

# https://bugs.python.org/issue26756
sys.stdin = TextIOWrapper(sys.stdin.buffer, errors='replace')

with fileinput.input(files=('-',), encoding='utf-8') as f:
    for line in f:
        message.append(line.rstrip())

# remove silliness
for i, _ in enumerate(message):
    message[i] = re.sub(r'<mailto:[^>]+>', '', message[i])
    message[i] = re.sub(r'<https://[^/]+?\.safelinks\.protection\.outlook\.com/[^>]*?>', '', message[i])
    message[i] = re.sub(r'https://[^/]+?\.safelinks\.protection\.outlook\.com/[^\s]+', lambda m: parse_qs(urlparse(m.group(0)).query).get('url', [ m.group(0) ])[0], message[i])

for i in range(len(message) - 1, 0, -1):
    if any(( re.search(pattern, message[i]) for pattern in GARBAGE )):
        message.pop(i)

# rebuild attributions
for i in range(len(message) - 1, 0, -1):
    if not re.search(r'^From: .* <[^@]+@[^>]+>$', message[i]):
        continue
    e = 1
    while i + e < len(message):
        if not message[i + e]:
            break
        if not re.search(r'^[A-Z][a-z]+: ', message[i + e]):
            # sometimes there is no newline
            if e <= 1:
                e = False
            break
        # this cannot be a header
        if e == 10:
            e = False
            break
        e += 1
    if e is False:
        continue
    s = next(( j for j, v in enumerate(message[i:i + e]) if v.startswith('Sent: ') or v.startswith('Date: ') ), None)
    if s is None:
        continue
    from_ = re.search(r'^From: (.+?)(?: EXT)? <[^@]+@[^>]+>$', message[i]).group(1)
    date0 = message[i + s][6:]
    date1 = to_datetime(date0)
    if date1:
        date = date1.strftime('%a, %b %d, %Y at %I:%M')
        if date1.strftime('%S') != '00':
            date += date1.strftime(':%S')
        date += date1.strftime('%p')
        if date1.strftime('%Z'):
            date += date1.strftime(' %Z')
    else:
        print(f'unable to parse attribution date format: {date0}', file=sys.stderr)
        date = date0
    for _ in range(0, e):
        message.pop(i)
    message.insert(i, '')
    message.insert(i + 1, f'{REPLY_MAGIC}On {date}, {from_} wrote:')

# remove runs of blank lines, do this last!
for i in range(len(message) - 1, 0, -1):
    if not message[i] and (i == 0 or i == len(message) - 1 or not message[i - 1]):
        message.pop(i)

q = 0
for i, _ in enumerate(message):
    if message[i].startswith(REPLY_MAGIC):
        message[i] = ('> ' * q) + message[i][1:]
        q += 1
        continue
    # FIXME
    #if re.search('^\x1b]9;\d+\x07\[-- .* --\]$', message[i]):
    #    break
    message[i] = ('> ' * q) + message[i]

for line in message:
    print(line)
