
# The order of these files is the order that they will be included in the
# final document
MD_SOURCES=00-preface/preface.md \
           templates/recipe.md \
           01-installing-and-running/introduction.md \
           01-installing-and-running/fixing-redhawk-rpm-installs.md \
           01-installing-and-running/installing-on-ubuntu.md \
           01-installing-and-running/configuring-ubuntu-for-development.md \
           01-installing-and-running/configuring-omniorb.md \
           01-installing-and-running/alternate-sdrroot.md \
           01-installing-and-running/multiple-domains.md \
           01-installing-and-running/shared-ide-install.md \
           03-components/introduction.md \
           03-components/allocating_gpp_resources.md \
           08-interface-libraries/introduction.md \
           08-interface-libraries/python_property_helpers.md \
           13-misc/introduction.md \
           13-misc/understanding-corba-bad-param.md \
           13-misc/understanding-corba-unknown-python-exception.md

HTML=$(MD_SOURCES:%.md=build/html/%.html)

all: html pdf

html: build/html/redhawk_cookbook.html build/html/index.html $(HTML)
	mkdir -p build/html
	cp templates/*.css build/html
	mkdir -p build/html/figures
	cp figures/* build/html/figures

pdf: build/html/redhawk_cookbook.pdf

build/html/redhawk_cookbook.pdf: Makefile templates/cookbook.latex $(MD_SOURCES)
	mkdir -p build/pdf
	pandoc --toc -N --chapters --template=$(CURDIR)/templates/cookbook.latex $(MD_SOURCES) -o $@

build/toc.md: Makefile $(MD_SOURCES)
	rm -f build/toc.md
	echo "% REDHAWK Cookbook\n" > build/toc.md
	@for md in $(MD_SOURCES); do \
	  TITLE=`head -n 1 $$md`; \
	  HTML=$${md%.*}; \
	  if [ "=" = `sed -n 2p $$md | cut -c1-1` ]; then \
	     echo "1. [$$TITLE]($$HTML.html)" >> build/toc.md; \
	  elif [ "-" = `sed -n 2p $$md | cut -c1-1` ]; then \
	     echo "    * [$$TITLE]($$HTML.html)" >> build/toc.md; \
	  fi \
	done
	echo "\n" >> build/toc.md
	echo "\[ [PDF](redhawk_cookbook.pdf) \]<br/>" >> build/toc.md
	echo "\[ [All On One Page](redhawk_cookbook.html) \]<br/>" >> build/toc.md
	echo "\[ [Documentation Source Code](https://github.com/Axios-Engineering/redhawk-cookbook) \]<br/>" >> build/toc.md

build/html/index.html: build/toc.md templates/cookbook.html templates/style.css templates/chrome.css $(MD_SOURCES)
	pandoc -S -N --highlight-style pygments -H templates/google-analytics.html -c style.css -c chrome.css --template=$(CURDIR)/templates/cookbook.html -s build/toc.md -o $@
	
build/html/%.html: %.md
	mkdir -p build/html/$(shell dirname $<)
	sed -e '1 s/^/%/; 2d' $< | pandoc -S --highlight-style pygments -H templates/google-analytics.html -c ../style.css -c ../chrome.css --template=$(CURDIR)/templates/recipe.html -s -o $@;
	sed -i 's!src="figures!src="../figures!g' $@

build/html/redhawk_cookbook.html: templates/cookbook.html templates/style.css templates/chrome.css $(MD_SOURCES)
	mkdir -p build/html
	pandoc --toc -S -N --chapters --highlight-style pygments -H templates/google-analytics.html -c style.css -c chrome.css --template=$(CURDIR)/templates/cookbook.html -s $(MD_SOURCES) -o $@

clean:
	rm -rf build
