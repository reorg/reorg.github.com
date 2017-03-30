#!/usr/bin/env python
"""Add the version number to the pages title

usage: addversion VERSION < FILEIN > FILEOUT

Assume the title is underlined with '=' and contains a -- after the project
name.
"""

import sys


def main():
    version = sys.argv[1]
    lines = sys.stdin.readlines()

    # find the title
    for i, l in enumerate(lines):
        l = l.rstrip()
        if l and l == '=' * len(l):
            title = lines[i-1]
            title = title.split()
            title.insert(title.index('--'), version)
            title = ' '.join(title)
            lines[i-1] = title + '\n'
            lines[i] = '=' * len(title) + '\n'
            break
    else:
        raise ValueError('title not found')

    for l in lines:
        sys.stdout.write(l)

if __name__ == '__main__':
    sys.exit(main())
