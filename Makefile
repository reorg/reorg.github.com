# reorg.github.com -- html pages generation

REPACK_DIR=../pg_repack/doc
RSTCSS = $(shell python -c 'import docutils.writers.html4css1 as m; print m.Writer.default_stylesheet_path')
RSTOPTS = --stylesheet-path=$(REPACK_DIR)/style.css,$(RSTCSS) --initial-header-level=2

HTML = index.html

.PHONY: clean

all: html

html: $(HTML)

index.html: $(REPACK_DIR)/pg_repack.rst $(REPACK_DIR)/style.css
	rst2html $(RSTOPTS) $< $@

clean:
	rm -f $(HTML)
