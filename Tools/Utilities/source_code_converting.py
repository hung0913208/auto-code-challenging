#!/usr/bin/python

import sys, os

source = sys.argv[1]

if os.path.exists(source):
    with open(source) as fd:
        raw = ''

        for c in fd.read():
            if ord(c) == 0xa:
                raw += '\\n'
            elif ord(c) == 0x9:
                raw += '    '
            else:
                raw += c
        else:
            print(raw)
else:
    sys.exit(-1)

