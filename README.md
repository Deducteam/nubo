Nubo: a repository for Dedukti proof blueprints
===============================================

This repository centralises meta data concerning Dedukti proofs. These metadata
ought to be structured enough so that proofs may be used practically.

Blueprint specification
-----------------------

We call *blueprint* a file that identifies a library that has been translated
into Dedukti. A *blueprint* contains meta data concerning the library that
allows to check that the library can be type checked by Dedukti.

Currently, a *blueprint* is a BSD flavoured [Makefile][2] (see [[3]] for POSIX
makefiles) that define a set of variables.

- `LIB_NAME`: identify the library.

- `LIB_VERSION`: version of the library.

- `LIB_FLAVOUR`: denotes some options used in the generation of the library.
  This field is optional.

- `LIB_DEPENDS`: a list of [library paths](#proof-library-path-specification) on
  which the library depends.

- `LIB_ORIGIN`: URL to the original files of the library, as distributed by the
  authors.
  
- `ENCODING`: a list of [library path](#proof-library-path-specification) that
  specifies the encoding into which proofs are stated. It must be a (possibly
  empty) subset of `LIB_DEPENDS`. This field is meant to be used for
  interoperability purposes.

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
  
Proof library name specification
--------------------------------

Each library has a name which consists of 3 parts

```
stem-version[-flavour]
```

The _stem_ part identifies the library and refers to the variable `LIB_NAME` of
the blueprint. It may contain dashes.

The _version_ part starts at the first digit that follows a `-` and goes up to
the following `-`. It refers to the variable `LIB_VERSION` of the blueprint.

The remaining _flavour_ part refers to the variable `LIB_FLAVOUR` of the
blueprint. It is optional.

The _version_ part must start with a digit, whereas the _flavour_ must not
start with a digit.

All packages must have a version number. Normally, the version number directly
matches the original library version number, or release date. In case there are
substantial changes in the translated library, a patch level marker should be
appended (e.g. `p0`, `p1`, &c.).

Version comparison is done using a lexicographic alphabetic order.

_This section is based on the manual page packages-specs(7) of OpenBSD_

Proof library path specification
--------------------------------

Each location in the library tree is uniquely identified by a *libpath*.

Every *libpath* conforms to the pattern `cat/stem/[flavour,]version` 
where `stem`, `version` and `flavour` are defined in the
[name specification](#proof-library-name-specification). The `cat` (for
category) part refers to the first directory at the root of the library tree.
The `flavour,` part is optional.

Such a *libpath* allows to find the package under the library tree.

For instance, `arithmetic/arith_fermat/sttfa,1.0` is the location of the library
`arith_fermat` version `1.0` in its `sttfa` flavour.

As an example, the overall structure of the library tree may look like this,
```
|- encodings
   |- libA
      |- 1.0
         |- Makefile
      |- flavA,1.0
         |- Makefile
      |- flavA,1.1
         |- Makefile
      |- flavB,1.0
         |- Makefile
   |- libB
      |- ...
|- arithmetic
   |- ...
```

**Note:** in the previous example, each `Makefile` is a
[*blueprint*](#blueprint-specification).

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
tarballs with the extension `.tgz`.
Each library identified by a
[library name specification](#proof-library-name-specification) `libspec` is
packaged as `libspec.tgz`. Such an archive must contain

- the source files of the library (`.dk` files) and

- a [Makefile][2] dependency list named `.depend` that provides the
  dependencies between the source files of the library.

The dependency list serves two purposes.
The first is to provide the dependencies between source files so that they can
be checked in an appropriate order. It also provides dependency for a (phony)
target `all` that allows to check all the library at once.

All source files are supposed to be in a single directory, including the source
files of libraries which are dependencies.

For instance, the archive of `arith_fermat-1.0-sttfa` is available at
`${PKG_PATH}/arith_fermat-1.0-sttfa.tgz` (see the documentation of
[makefiles](mk/README.md) for a description of `${PKG_PATH}`).

How to use this repository
--------------------------

The library tree can be used to install, check or package libraries using
the `make` program, in its BSD variant (Linux users may have to use `bmake`).

Currently, two commands are available,
- `download`: download and extracts the source files of the library,
- `check`: downloads and checks the library.

These commands must be called in the same directory as the
[blueprint](#blueprint-specification). For example, to download
`arith_fermat-1.0-sttfa`,

``` sh
cd libraries/arith_fermat/sttfa,1.0
make download
```

More documentation on the targets is available in `mk/README.md`.

Notes
-----

It is the user's responsability to install softwares and
[tools](#tooling-specification) in their appropriate version.

Upcoming
--------

- Add a maintainer for each library

<<<<<<< HEAD
- Implement automated type checking of libraries (target `check` of
  `library.mk`), possibly by providing a script alongside the `Makefile`
  
- Add a tool to resolve dependencies and install recursively libraries needed.

||||||| merged common ancestors
- Setup a central repository such that downloading proof package
  `lib-0.1-enc.tgz` is as easy as `wget REPO/lib-0.1-enc.tgz`.
  
- Implement automated type checking of libraries (target `check` of
  `library.mk`), possibly by providing a script alongside the `Makefile`
  
- Add a tool to resolve dependencies and install recursively libraries needed.

=======
>>>>>>> target_check
- Use another format than Makefile to have easily parsable meta data. Or
  add target to generate json from makefile.

[1]: https://tools.ietf.org/html/draft-phillips-record-jar-01
[2]: https://man.openbsd.org/make.1
[3]: https://pubs.opengroup.org/onlinepubs/009695299/utilities/make.html
