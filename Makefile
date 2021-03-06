include config.mk

DIST ?= buster
export DIST

SUBDIRS := skalibs execline s6 s6-rc s6-dns bearssl s6-networking \
		s6-portable-utils s6-linux-utils s6-linux-init

all: setup $(SUBDIRS)

setup: $(OUTDIR)

$(OUTDIR):
	mkdir $@

skalibs: setup
	$(MAKE) -C $@ build

execline: setup skalibs
	$(MAKE) -C $@ build

s6: setup skalibs execline
	$(MAKE) -C $@ build

s6-rc: setup skalibs execline s6
	$(MAKE) -C $@ build

s6-dns: setup skalibs
	$(MAKE) -C $@ build

s6-networking: setup skalibs execline s6 s6-dns bearssl
	$(MAKE) -C $@ build

bearssl: setup
	$(MAKE) -C $@ build

s6-portable-utils: setup skalibs
	$(MAKE) -C $@ build

s6-linux-utils: setup skalibs
	$(MAKE) -C $@ build

s6-linux-init: setup skalibs execline s6
	$(MAKE) -C $@ build

clean:
	for i in $(SUBDIRS); do \
		rm -rf $$i/*.orig.tar.gz; \
		rm -rf $$i/*.dsc; \
		rm -rf $$i/*.debian.tar.xz; \
		rm -rf $(OUTDIR)/.$$i*.stamp; \
	done
	rm -rf $(OUTDIR)
