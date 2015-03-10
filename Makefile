# reorg.github.com -- html pages generation

CURRENT = 1.3

CSS = sm/master/doc/style.css
RST2HTML = $(shell which rst2html || which rst2html.py)
RSTCSS = $(shell python -c 'import docutils.writers.html4css1 as m; print m.Writer.default_stylesheet_path')
RSTOPTS = --template=template.txt --stylesheet-path=$(CSS),$(RSTCSS) --initial-header-level=2

ADDVERSION = python tools/addversion.py
VERSION_1_1 = $(shell grep '"version":' sm/1.1/META.json | head -1 \
	| sed -e 's/\s*"version":\s*"\(.*\)",/\1/')
VERSION_1_2 = $(shell grep '"version":' sm/1.2/META.json | head -1 \
	| sed -e 's/\s*"version":\s*"\(.*\)",/\1/')
VERSION_1_3 = $(shell grep '"version":' sm/1.3/META.json | head -1 \
	| sed -e 's/\s*"version":\s*"\(.*\)",/\1/')

HTML = pg_repack/index.html pg_repack/1.1/index.html pg_repack/1.2/index.html pg_repack/1.3/index.html

.PHONY: $(HTML)

all: html

html: $(HTML)

pg_repack/index.html: pg_repack/$(CURRENT)/index.html
	cat $< > $@

pg_repack/1.1/index.html: sm/1.1/doc/pg_repack.rst $(CSS)
	mkdir -p pg_repack/1.1/
	$(ADDVERSION) $(VERSION_1_1) < $< | $(RST2HTML) $(RSTOPTS) > $@

pg_repack/1.2/index.html: sm/1.2/doc/pg_repack.rst $(CSS)
	mkdir -p pg_repack/1.2/
	$(ADDVERSION) $(VERSION_1_2) < $< | $(RST2HTML) $(RSTOPTS) > $@

pg_repack/1.3/index.html: sm/1.3/doc/pg_repack.rst $(CSS)
	mkdir -p pg_repack/1.3/
	$(ADDVERSION) $(VERSION_1_3) < $< | $(RST2HTML) $(RSTOPTS) > $@
