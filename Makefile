# Build and Installation of libFRUIT

prefix ?= /usr/local
libdir = $(prefix)/lib
includedir = $(prefix)/include

sourcedir = ./src
builddir = $(sourcedir)
INSTALL = install
INSTALL_PROGRAM = $(INSTALL)
INSTALL_DATA = $(INSTALL) -m 644

FC = mpif90
FFLAGS = -O3 -fPIC

SOURCES = $(wildcard $(sourcedir)/*.f90)
OBJECTS = $(patsubst $(sourcedir)/%.f90, $(builddir)/%.o, $(SOURCES))

all: $(SOURCES) libfruit.so 

$(OBJECTS) : $(builddir)/%.o : $(sourcedir)/%.f90
	$(FC) $(FFLAGS) -J$(builddir) -c $< -o $@

libfruit.so : $(OBJECTS)
	$(FC) $(FFLAGS) -shared -o $(builddir)/libfruit.so $<

install : 
	$(INSTALL_DATA) $(builddir)/libfruit.so "$(DESTDIR)$(libdir)/"
	$(INSTALL_DATA) $(wildcard $(builddir)/*.mod) "$(DESTDIR)$(includedir)/"

clean :
	rm $(builddir)/*.mod $(builddir)/*.o

dir: 
	mkdir -p $(builddir)

print :
	@echo $(VAR)=$($(VAR))

print-% :
	$(info [ variable name]: $*)
	$(info [        origin]: $(origin $*))
	$(info [         value]: $(value $*))
	$(info [expanded value]: $($*))
	$(info )
	@true 

.PHONY: print, install, dir
