# A Makefile to process the raw javascript and generate something that GitHub pages can use to publish

# Common names
NAME_MAIN := main
NAME_INDEX := index

# File extensions
EXT_JS := js
EXT_MINJS := js
EXT_HTML := html

# Tools
TOOL_MINIFY := terser

# Directories
DIR_ROOT := .
DIR_MODULES := $(DIR_ROOT)/modules

OUTDIR_ROOT := $(DIR_ROOT)/_site
OUTDIR_MODULES := $(OUTDIR_ROOT)/modules

###

MODULES_JS := $(notdir $(basename $(wildcard $(DIR_MODULES)/*.$(EXT_JS))))

MINIFIED_MAIN := $(OUTDIR_ROOT)/$(NAME_MAIN).$(EXT_MINJS)
MINIFIED_MODULES := $(foreach MODULE,$(MODULES_JS), $(addsuffix .$(EXT_MINJS), $(addprefix $(OUTDIR_MODULES)/,$(MODULE))))

###

.PHONY: print_versions default all clean site
default: site
all: default

export INDEX_BODY
site: print_versions $(OUTDIR_ROOT)/$(NAME_INDEX).$(EXT_HTML) | $(OUTDIR_ROOT)

clean:
	rm -r $(OUTDIR_ROOT) || exit 0

# _site/%.html from ./%.html
$(OUTDIR_ROOT)/%.$(EXT_HTML): $(DIR_ROOT)/%.$(EXT_HTML) $(MINIFIED_MODULES) $(MINIFIED_MAIN) | $(OUTDIR_ROOT)
	cp $< $@ 

# _site/%.min.js from ./%.js
.SECONDARY:
$(OUTDIR_ROOT)/%.$(EXT_MINJS): $(DIR_ROOT)/%.$(EXT_JS) | $(OUTDIR_ROOT) $(OUTDIR_MODULES)
	$(TOOL_MINIFY) --compress --mangle --module --output $@ $<

# Doubles as a way to check if things are installed before trying to do anything
print_versions:
	$(TOOL_MINIFY) --version

$(OUTDIR_ROOT):
	mkdir -p $@

$(OUTDIR_MODULES):
	mkdir -p $@