# s6 debian packaging

Unofficial Debian packages for [Laurent Bercot](https://skarnet.org)'s skaware
software suites.

## Preface

This repository contains build infrastructure for building Debian packages for
[skarnet.org](https://skarnet.org) software and dependencies (which, at this
point in time, includes [BearSSL](https://www.bearssl.org)).

This branch contains packaging for the **stretch** release of Debian. Please see
other branches in this repository for packaging for other versions of Debian.

## Setup

Clone this git repository, and initialise submodules:

```shellsession
$ git clone https://github.com/s6-debs/s6-debs
$ cd s6-debs
$ git submodule init
$ git submodule update
```

The Makefiles in this repository use the `sbuild(1)` tool to build packages
within a clean chroot environment and `dpkg-parsechangelog(1)` for extracting
versioning information of packages, which requires the installation of the
`dpkg-dev`, `sbuild`, `schroot` and `debootstrap` packages on the host build
machine.

Once these packages are installed, a build chroot must be created for `sbuild`.
This can be achieved by running a command similar to:

```shellsession
# sbuild-createchroot --include=debhelper,dh-exec,quilt,fakeroot,perl-openssl-defaults,lintian stretch /srv/chroots/stretch
```

Note that the `--include=...` argument is optional, and is specified here in
order to include a number of common build dependencies in the base chroot so
that they are not redownloaded every time a package is built. You may also
provide the URL of a Debian mirror as a further argument, in which case,
`debootstrap` will use that mirror instead of the default of
`http://deb.debian.org/debian`, which may be desirable in order to use a
geographically closer Debian mirror than the default.

You should then add your user to the `sbuild` group in order to permit them to
run the `sbuild` command. More information can be found on the [Debian wiki page
for `sbuild`](https://wiki.debian.org/sbuild).

These packages can also be built by invoking `debuild` directly in each
package's directory on the host system, though this does not automatically
install dependencies nor guarantee a clean build environment, and is therefore
not supported by the build Makefiles in this repository.

## Building

The entire suite of packages can be compiled by issuing `make` at the root of
the repository. Alternatively, the name of each of the packages in this
repository may be specified as make targets, e.g. `make skalibs` or `make s6`,
which will cause the named package and all of its dependencies to be compiled.
The build artefacts (including `.deb` packages) can then be found in the
generated `build-out` directory under the repository root.

If you wish to compile in your host environment without the use of `sbuild`,
then you should change to the directory of the package you wish to build (e.g.
`cd skalibs`), run `make origtgz` to generate a source tarball, then change into
the submodule directory and run `debuild`.

