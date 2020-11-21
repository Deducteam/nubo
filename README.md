Nubo: a repository for Dedukti proof blueprints
===============================================

This repository centralises meta data concerning Dedukti proofs. These metadata
ought to be structured enough so that proofs may be used practically.

File system structure
---------------------

We denote by `nubo` the root directory of this repository. The repository
is structured the following way
```
|- README.md
|- libA
   |- 1.0
      |- encoding1
         |- Makefile
      |- encoding2
         |- Makefile
   |- 1.1
      |- encoding1
         |- Makefile
|- libB
   |- ...
```

where each `libX` is a library that has been translated. Theses libraries may
exist in several version, which are kept in parallel for dependencies issues
(we may want to use a library `libX-1.0` that depends on `libY-v` with `v <=
1.1` even though `libY-2.0` has been released and translated).
Each library may be translated into several encodings, or several encoded
_theories_. Folders `encodingX` denote such encodings.

The leaves of the structure are the blueprints, or meta data files. They
consist in a sequence of variable declarations that uniquely determine and
should at least specify how to type check these proofs.

Proofs are stored elsewhere, in the form of proof packages. These packages must
follow a standard as well.

Blueprints data
---------------

We provide here a description of the fields contained in a blueprint.

- `LIB_NAME`: name of the library, in the folder hierarchy, `libA` is such a
  library name.

- `LIB_VERSION`: version of the library (appears in the directory hierarchy).

- `LIB_SRC`: location of the library

- `ENCODING`: name of the encoding in which the proofs are stated.

- `PKG_URL`, `PKG_DOI`: location of the proof package, can be either a plain
  url with `PKG_URL`, or a Digital Object Identifier if the proof package has
  one.

- `DK_VERSION`: a string of the form `version:git_id`, where `version` is `2`
  or `3` that indicate whether proofs can be proof checked with Dedukti2.X or
  Dedukti3, and `git_id` is either a commit hash, a branch name or a tag.

- `TOOLING`: a list of tools used to translate proofs. A tool is specified by
  a string `<name>:<version>` where `<name>` is the name of the tool, and
  `<version>` is its version used. The format of the version may depend on the
  source of the tool. If the tool is stored on git, a commit hash, or tag, or
  branch name may be provided. Tools are referenced in `nubo/tools.md`.

Proof package name specification
--------------------------------

Each library package has a name which consists in 3 parth

```
stem-version-encoding
```

The _stem_ part identifies the library. It may contain dashes.

The _version_ part starts at the first digit that follows a '-' and goes up to
the following '-'.

The remaining _encoding_ part identifies an encoding in which the proofs are
stated.

All packages must have a version number. Normally, the version number directly
matches the original library version number, or release date. In case there are
substantial changes in the translated library, a patch level marker should be
appended (e.g. 'p0', 'p1', &c.).

Version comparison is done using a lexicographic alphabetic order.

_This section is based on the manual page packages-specs(7) of OpenBSD_

Tooling specification
---------------------

TODO

Proof package format
--------------------

TODO

How to use this repository
--------------------------

TODO

TODO
----

- Possibility to setup a central repository such that downloading proof package
  `lib-0.1-enc.tgz` is as easy as `wget REPO/lib-0.1-enc.tgz`.

- Replicate the `pkgpagth` field of OpenBSD
