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
DIR_EXTERNAL := $(DIR_ROOT)/external

OUTDIR_ROOT := $(DIR_ROOT)/_site

# Utility
rwildcard=$(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

###
MODULES_JS := $(patsubst $(DIR_ROOT)/%,%,$(basename $(wildcard $(DIR_MODULES)/*.$(EXT_JS))))
MODULES_EXTERNAL_JS := $(patsubst $(DIR_ROOT)/%,%,$(basename $(call rwildcard,$(DIR_EXTERNAL)/,*.$(EXT_JS))))

MINIFIED_MAIN := $(OUTDIR_ROOT)/$(NAME_MAIN).$(EXT_MINJS)
MINIFIED_MODULES := $(foreach MODULE,$(MODULES_JS), $(addsuffix .$(EXT_MINJS), $(addprefix $(OUTDIR_ROOT)/,$(MODULE))))
MINIFIED_EXTERNAL_MODULES := $(foreach MODULE,$(MODULES_EXTERNAL_JS), $(addsuffix .$(EXT_MINJS), $(addprefix $(OUTDIR_ROOT)/,$(MODULE))))

###

.PHONY: print_versions default all clean site
.SECONDARY:

default: site
all: default

site: print_versions $(OUTDIR_ROOT)/$(NAME_INDEX).$(EXT_HTML) $(MINIFIED_MODULES) $(MINIFIED_EXTERNAL_MODULES) $(MINIFIED_MAIN)

clean:
	rm -r $(OUTDIR_ROOT) || exit 0

# _site/%.html from ./%.html
.SECONDEXPANSION:
$(OUTDIR_ROOT)/%.$(EXT_HTML): $(DIR_ROOT)/%.$(EXT_HTML) | $$(@D)/
	cp $< $@ 

# _site/%.js from ./%.js
.SECONDEXPANSION:
$(OUTDIR_ROOT)/%.$(EXT_MINJS): $(DIR_ROOT)/%.$(EXT_JS) | $$(@D)/
	$(TOOL_MINIFY) --compress --mangle --module --output $@ $<

# Doubles as a way to check if things are installed before trying to do anything
print_versions:
	$(TOOL_MINIFY) --version

# Create directories and subdirectories as necessary
$(OUTDIR_ROOT)/:
	mkdir -p $@

$(OUTDIR_ROOT)/%/:
	mkdir -p $@