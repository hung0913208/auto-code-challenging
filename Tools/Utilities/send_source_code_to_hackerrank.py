#!/usr/bin/python

import sys, os
import json
import urllib2

if os.path.exists(sys.argv[1]):
    with open(sys.argv[1]) as fd:
        raw = ''

        for c in fd.read():
            if ord(c) == 0xa:
                raw += '\n'
            elif ord(c) == 0x9:
                raw += '    '
            else:
                raw += c
else:
    sys.exit(-1)

data = {
    'code': raw,
    'language': sys.argv[2],
    'contest_slug': 'master',
    'playlist_slug': sys.argv[5] if len(sys.argv) > 5 else ''
}

req = urllib2.Request('https://www.hackerrank.com/rest/contests/master/challenges/{}/{}'.format(sys.argv[3], sys.argv[4]))
req.add_header('X-CSRF-Token', os.environ.get('TOKEN') or '')
req.add_header('Cookie', os.environ.get('COOKIES') or '')
req.add_header('Accept', 'application/json')
req.add_header('Content-Type', 'application/json')

resp = urllib2.urlopen(req, json.dumps(data))

if resp.code == 200:
    try:
	    print(json.loads(resp.read())['model']['id'])
    except Exception:
	    sys.exit(-1)
else:
    sys.exit(-1)
