Nubo: a repository for Dedukti proof blueprints
===============================================

This repository centralises meta data concerning Dedukti proofs. These metadata
ought to be structured enough so that proofs may be used practically.

Blueprints specification
------------------------

We call *blueprint* a file that identifies a library that has been translated
into Dedukti. A *blueprint* contains meta data concerning the library that
allows to check that the library can be type checked by Dedukti.

Currently, a *blueprint* is a BSD flavoured [Makefile][2] (see [[3]] for POSIX
makefiles) that define a set of variables.

- `LIB_NAME`: name of the library, in the folder hierarchy, `libA` is such a
  library name.

- `LIB_VERSION`: version of the library.

- `LIB_FLAVOUR`: denotes some options used in the generation of the library.

- `LIB_ORIGIN`: URL to the original files of the library, as distributed by the
  authors.

- `PKG_PATH`: path where the proof packages can be retrieved. Full URL to proof
  packages becomes `${PKG_PATH}/<libpath>` where _libpath_ is a tree location
  for the library.

- `DK_VERSION`: a string of the form `version:git_id`, where `version` is `2`
  or `3` that indicate whether proofs can be proof checked with Dedukti2.X or
  Dedukti3, and `git_id` is either a commit hash, a branch name or a tag.

- `TOOLING`: a list of tools used to translate proofs. A tool is specified by
  a string `<name>:<version>` where `<name>` is the name of the tool, and
  `<version>` is its version used. The format of the version may depend on the
  source of the tool. If the tool is stored on git, a commit hash, or tag, or
  branch name may be provided. Tools are referenced in `nubo/tools.md`.
  
**Note:**
These variables not only serve informative purposes, they can be used to fulfill
miscellaneous tasks using targets defined in `mk/library.mk`. More information
on these targets are given in
[How to use this repository](#how-to-use-this-repository).
  
Proof library path specification
--------------------------------

Each location in the library tree is uniquely identified through a *libpath*
which encodes the directory that allows to install a proof library.

Every *libpath* conforms to the pattern `name/version/flavour`. The `name` part
refers to the name of the library, as defined by the variable `LIB_NAME` of the
blueprint. The `version` part refers to a version of the library, as defined by
the variable `LIB_VERSION` of the blueprint. The `flavour` denotes some options
used in the generation of the library.

Such a *libpath* allows to find the package under the library tree.

For instance, `arith_fermat/1.0/sttfa` is the location of the library
`arith_fermat` version `1.0` translated with library `sttfa` as a dependency.

As an example, the overall structure of the library tree may look like this,
```
|- libA
   |- 1.0
      |- flav1
         |- Makefile
      |- flav2
         |- Makefile
   |- 1.1
      |- flav1
         |- Makefile
|- libB
   |- ...
```

Proof library name specification
--------------------------------

Each library has a name which consists of 3 parts

```
stem-version-flavour
```

The _stem_ part identifies the library. It may contain dashes.

The _version_ part starts at the first digit that follows a `-` and goes up to
the following `-`.

The remaining _flavour_ part identifies the flavour of the package.

The _version_ part must start with a digit, whereas the _flavour_ must not
start with a digit.

All packages must have a version number. Normally, the version number directly
matches the original library version number, or release date. In case there are
substantial changes in the translated library, a patch level marker should be
appended (e.g. `p0`, `p1`, &c.).

Version comparison is done using a lexicographic alphabetic order.

_This section is based on the manual page packages-specs(7) of OpenBSD_

Tooling specification
---------------------

The file `TOOLS` gathers information on the tools that may be used to translate
proofs or to operate on translated proofs. It follows the [record jar][1] 
format.

A record must at least contain the fields `name` and `homepage`. Any other field
is optional.

- `name`: a unique name that identifies the tool.

- `homepage`: URL of the homepage of the tool from where it can be downloaded.

Packaged libraries
------------------

Libraries that have been translated to Dedukti are packaged into gzipped
tarballs for easy access. Each library that is identified by a
[library name specification](#proof-library-name-specification) `libspec` is
packaged as `libspec.tgz`. Such an archives contains all files that constitute
the library.

How to use this repository
--------------------------

The library tree can be used to install, check or package libraries. These
operations are carried out using `make` and the targets defined in
`mk/library.mk`. The targets depend on the variables defined by
[blueprints](#bluprints-specification). These target are made available for
each library by including `mk/library.mk` _at the end_ of blueprints. Note
that makefiles are written using BSD make, Linux users may hence have to use
`bmake`.

For example, to download `arith_fermat-1.0-sttfa`,

``` sh
cd arith_fermat/1.0/sttfa
make download
```

Notes
-----

It is the user's responsability to install softwares and
[tools](#tooling-specification) in their appropriate version.

Upcoming
--------

- Setup a central repository such that downloading proof package
  `lib-0.1-enc.tgz` is as easy as `wget REPO/lib-0.1-enc.tgz`.
  
- Add a tool to resolve dependencies and install recursively libraries needed.

[1]: https://tools.ietf.org/html/draft-phillips-record-jar-01
[2]: https://man.openbsd.org/make.1
[3]: https://pubs.opengroup.org/onlinepubs/009695299/utilities/make.html
