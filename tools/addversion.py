#!/usr/bin/env python
"""Add the version number to the pages title

usage: addversion VERSION < FILEIN > FILEOUT

Assume the title is underlined with '=' and contains a -- after the project
name.
"""

import os
import sys
import json


def main():
    docfn = sys.argv[1]

    with open(docfn) as f:
        lines = f.read().decode('utf8').splitlines()

    metafn = os.path.join(os.path.dirname(docfn), '..', 'META.json')
    with open(metafn) as f:
        meta = json.load(f)

    version = meta['version']

    # find the title
    for i, l in enumerate(lines):
        l = l.rstrip()
        if l and l == u'=' * len(l):
            title = lines[i-1]
            title = title.split()
            title.insert(title.index(u'--'), version)
            title = u' '.join(title)
            lines[i-1] = title
            lines[i] = u'=' * len(title.encode('utf8'))
            break
    else:
        raise ValueError('title not found')

    sys.stdout.write(u'\n'.join(lines).encode('utf8'))


if __name__ == '__main__':
    sys.exit(main())
