#!/usr/bin/env python
"""Add version number to the pages title and generate cross links

Assume the title is underlined with '=' and contains a -- after the project
name.
"""

import re
import os
import sys
import json
from glob import glob


LANG = None
translations = {
    'jp': {}    # TODO
}


def _(s):
    if not LANG:
        return s
    xs = translations.get(LANG)
    if not xs:
        return s
    if s in xs:
        return xs[s]
    else:
        print >> sys.stderr("missing translation in %s: '%s'" % (LANG, s))
        return s


def main():
    global opt
    opt = parse_cmdline()

    with open(opt.docfn) as f:
        lines = f.read().decode('utf8').splitlines()

    pos = fix_title(lines)

    # find other versions of the same language
    versions = get_doc_versions(opt.docfn)
    if versions:
        versions = render_versions(versions)
        lines[pos+1:pos+1] = versions
        pos += len(versions)

    sys.stdout.write(u'\n'.join(lines).encode('utf8'))


def get_version():
    metafn = os.path.join(os.path.dirname(opt.docfn), '..', 'META.json')
    with open(metafn) as f:
        meta = json.load(f)

    return meta['version']


def fix_title(lines):
    """Find the title and inject the version number

    Return the line index after the title.
    """
    version = get_version()

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

    return i + 1


def get_doc_versions(docfn):
    """Return the available versions of a doc file

    The version must be included in the path.
    """
    tokens = docfn.split('/')
    tokens[-3] = '*'
    docs = sorted(glob('/'.join(tokens)))
    this = docfn.split('/')[-3]

    lang = get_language(tokens[-1])

    rv = []
    if not lang:
        for fn in docs:
            label = fn.split('/')[-3]
            if this == label:
                url = None
            elif this == 'master':
                url = '%s/' % label
            elif label == 'master':
                url = '../'
            else:
                url = '../%s/' % label

            rv.append((label, url))

    else:
        for fn in docs:
            label = fn.split('/')[-3]
            if this == label:
                url = None
            elif this == 'master':
                url = '%s/%s/' % (label, lang)
            elif label == 'master':
                url = '../../%s/' % lang
            else:
                url = '../../%s/%s/' % (label, lang)

            rv.append((label, url))

    return rv


def get_language(fn):
    m = re.match(r'pg_repack_(..)\.rst', fn)
    if m is not None:
        return m.group(1)


def render_versions(versions):
    """Render the block of versions links in reST"""
    rv = ['', _(u'Versions:')]
    for label, url in versions:
        if not url:
            rv.append(label)
        else:
            rv.append('`%s <%s>`__' % (label, url))

    rv.append('')
    return rv


def parse_cmdline():
    from argparse import ArgumentParser
    parser = ArgumentParser(description=__doc__)
    parser.add_argument(
        '--current', action="store_true",
        help="generate docs for the 'current' version")

    parser.add_argument(
        'docfn',
        help="the input file to manipulate")

    opt = parser.parse_args()

    return opt


if __name__ == '__main__':
    sys.exit(main())
