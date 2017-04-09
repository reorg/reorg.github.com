# reorg.github.com -- html pages generation

VERSIONS = 1.1 1.2 1.3 1.4
VERSIONS_JP = 1.3 1.4

PIP = env/bin/pip
VIRTUALENV = virtualenv
CSS = sm/master/doc/style.css
RST2HTML = env/bin/rst2html.py
RSTCSS = $(shell python -c 'import docutils.writers.html4css1 as m; print m.Writer.default_stylesheet_path')
RSTOPTS = --template=template.txt --stylesheet-path=$(CSS),$(RSTCSS) --initial-header-level=2

ADDVERSION = tools/addversion.py

SM = sm/1.1 sm/1.2 sm/1.3 sm/master

HTML_EN = pg_repack/index.html $(patsubst %,pg_repack/%/index.html,$(VERSIONS))
HTML_JP = pg_repack/jp/index.html $(patsubst %,pg_repack/%/jp/index.html,$(VERSIONS_JP))

HTML = $(HTML_EN) $(HTML_JP)
HTMLSUPP = $(CSS) $(RST2HTML) $(ADDVERSION)

all: html

sm: $(SM)

html: $(HTML)

sm/master: FORCE
	cd $@ && git fetch && git reset --hard origin/master

sm/?.?: FORCE
	cd $@ && git fetch && git reset --hard origin/maint_`basename $@`


pg_repack/index.html: sm/master/doc/pg_repack.rst $(HTMLSUPP)
	mkdir -p `dirname $@`
	$(ADDVERSION) $< | $(RST2HTML) $(RSTOPTS) > $@

pg_repack/%/index.html: sm/%/doc/pg_repack.rst $(HTMLSUPP)
	mkdir -p `dirname $@`
	$(ADDVERSION) $< | $(RST2HTML) $(RSTOPTS) > $@


pg_repack/jp/index.html: sm/master/doc/pg_repack_jp.rst $(HTMLSUPP)
	mkdir -p `dirname $@`
	$(ADDVERSION) $< | $(RST2HTML) $(RSTOPTS) > $@

pg_repack/%/jp/index.html: sm/%/doc/pg_repack_jp.rst $(HTMLSUPP)
	mkdir -p `dirname $@`
	$(ADDVERSION) $< | $(RST2HTML) $(RSTOPTS) > $@


$(RST2HTML): requirements.txt $(PIP)
	$(PIP) install -U -r requirements.txt

env/bin/pip:
	$(VIRTUALENV) env

# .PHONY doesn't seem to work with vpath rules?
FORCE:
