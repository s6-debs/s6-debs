include config.mk

all: setup $(SUBDIRS)

setup:
	mkdir $(OUTDIR)

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
	rm -rf $(OUTDIR)
	for i in $(SUBDIRS); do \
		$(MAKE) -C $$i clean; \
	done

