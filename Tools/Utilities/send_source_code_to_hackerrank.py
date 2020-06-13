#!/usr/bin/python

import sys, os
import json
import requests

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

url = 'https://www.hackerrank.com/rest/contests/master/challenges/{}/{}'.format(
            sys.argv[3], sys.argv[4])
headers = {
    'X-CSRF-Token': os.environ.get('TOKEN') or '',
    'Cookie': os.environ.get('COOKIES') or '',
    'Accept': 'application/json',
    'Content-Type': 'application/json'
}

data = {
    'code': raw,
    'language': sys.argv[2],
    'contest_slug': 'master',
    'playlist_slug': sys.argv[5] if len(sys.argv) > 5 else ''
}

resp = requests.post(url, json=data, headers=headers)

if resp.status_code == 200:
    try:
	    print(resp.json()['model']['id'])
    except Exception:
	    sys.exit(-1)
else:
    sys.exit(-1)
