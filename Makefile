
# The order of these files is the order that they will be included in the
# final document
MD_SOURCES=preface.md \
           templates/recipe.md \
           01-installing-and-running/introduction.md \
           01-installing-and-running/installing-on-ubuntu.md \
           01-installing-and-running/configuring-ubuntu-for-development.md \
           01-installing-and-running/configuring-omniorb.md \
           01-installing-and-running/alternate-sdrroot.md \
           01-installing-and-running/multiple-domains.md \
           01-installing-and-running/shared-ide-install.md

all: build/html/index.html build/pdf/redhawk_cookbook.pdf

build/pdf/redhawk_cookbook.pdf: Makefile templates/cookbook.latex $(MD_SOURCES)
	mkdir -p build/pdf
	pandoc --toc -N --chapters --template=$(CURDIR)/templates/cookbook.latex $(MD_SOURCES) -o $@

build/html/index.html: Makefile templates/cookbook.html templates/style.css templates/chrome.css $(MD_SOURCES)
	mkdir -p build/html
	cp templates/*.css build/html
	mkdir -p build/html/figures
	cp figures/* build/html/figures
	pandoc --toc -S -N --chapters --highlight-style pygments -c style.css -c chrome.css --template=$(CURDIR)/templates/cookbook.html -s $(MD_SOURCES) -o $@

clean:
	rm -rf build
