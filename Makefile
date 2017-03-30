# reorg.github.com -- html pages generation

VERSIONS = 1.1 1.2 1.3 1.4
VERSIONS_JP = 1.3 1.4
CURRENT = 1.4

PIP = env/bin/pip
VIRTUALENV = virtualenv
CSS = sm/master/doc/style.css
RST2HTML = env/bin/rst2html.py
RSTCSS = $(shell python -c 'import docutils.writers.html4css1 as m; print m.Writer.default_stylesheet_path')
RSTOPTS = --template=template.txt --stylesheet-path=$(CSS),$(RSTCSS) --initial-header-level=2

ADDVERSION = python tools/addversion.py

SM = sm/1.1 sm/1.2 sm/1.3 sm/master

HTML_EN = pg_repack/index.html $(patsubst %,pg_repack/%/index.html,$(VERSIONS))
HTML_JP = pg_repack/jp/index.html $(patsubst %,pg_repack/%/jp/index.html,$(VERSIONS_JP))

HTML = $(HTML_EN) $(HTML_JP)

all: html

sm: $(SM)

html: $(HTML)

sm/master: FORCE
	cd $@ && git fetch && git reset --hard origin/master

sm/?.?: FORCE
	cd $@ && git fetch && git reset --hard origin/maint_`basename $@`

pg_repack/index.html: pg_repack/$(CURRENT)/index.html
	cat $< > $@

pg_repack/jp/index.html: pg_repack/$(CURRENT)/jp/index.html
	mkdir -p `dirname $@`
	cat $< > $@

pg_repack/%/index.html: sm/%/doc/pg_repack.rst $(CSS) $(RST2HTML)
	mkdir -p `dirname $@`
	$(eval VER := $(shell \
		grep '"version":' `dirname $<`/..//META.json | head -1 \
			| sed -e 's/\s*"version":\s*"\(.*\)",/\1/'))
	$(ADDVERSION) $(VER) < $< | $(RST2HTML) $(RSTOPTS) > $@

pg_repack/%/jp/index.html: sm/%/doc/pg_repack_jp.rst $(CSS) $(RST2HTML)
	mkdir -p `dirname $@`
	$(eval VER := $(shell \
		grep '"version":' `dirname $<`/..//META.json | head -1 \
			| sed -e 's/\s*"version":\s*"\(.*\)",/\1/'))
	$(ADDVERSION) $(VER) < $< | $(RST2HTML) $(RSTOPTS) > $@

$(RST2HTML): requirements.txt $(PIP)
	$(PIP) install -U -r requirements.txt

env/bin/pip:
	$(VIRTUALENV) env

# .PHONY doesn't seem to work with vpath rules?
FORCE:
