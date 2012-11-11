# reorg.github.com -- html pages generation

REPACK_DIR=../pg_repack/doc
RSTCSS = $(shell python -c 'import docutils.writers.html4css1 as m; print m.Writer.default_stylesheet_path')
RSTOPTS = --template=template.txt --stylesheet-path=$(REPACK_DIR)/style.css,$(RSTCSS) --initial-header-level=2

.PHONY: pg_repack/index.html

HTML = pg_repack/index.html

all: html

html: $(HTML)

pg_repack/index.html: $(REPACK_DIR)/pg_repack.rst $(REPACK_DIR)/style.css
	mkdir -p pg_repack
	rst2html $(RSTOPTS) $< $@
