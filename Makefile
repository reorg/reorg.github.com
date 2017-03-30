# reorg.github.com -- html pages generation

CURRENT = 1.4

PIP = env/bin/pip
VIRTUALENV = virtualenv
CSS = sm/master/doc/style.css
RST2HTML = env/bin/rst2html.py
RSTCSS = $(shell python -c 'import docutils.writers.html4css1 as m; print m.Writer.default_stylesheet_path')
RSTOPTS = --template=template.txt --stylesheet-path=$(CSS),$(RSTCSS) --initial-header-level=2

ADDVERSION = python tools/addversion.py

HTML = pg_repack/index.html pg_repack/1.1/index.html pg_repack/1.2/index.html \
	   pg_repack/1.3/index.html pg_repack/1.4/index.html

all: html

html: $(HTML)

pg_repack/index.html: pg_repack/$(CURRENT)/index.html
	cat $< > $@

pg_repack/%/index.html: sm/%/doc/pg_repack.rst $(CSS) $(RST2HTML)
	mkdir -p `dirname $@`
	$(eval VER := $(shell \
		grep '"version":' `dirname $<`/..//META.json | head -1 \
			| sed -e 's/\s*"version":\s*"\(.*\)",/\1/'))
	$(ADDVERSION) $(VER) < $< | $(RST2HTML) $(RSTOPTS) > $@

$(RST2HTML): requirements.txt $(PIP)
	$(PIP) install -U -r requirements.txt

env/bin/pip:
	$(VIRTUALENV) env
