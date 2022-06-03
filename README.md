Nubo: a repository for Dedukti developments
===========================================

This repository centralises metadata concerning Dedukti developments. 
These metadata ought to be structured enough so that developments 
may be processed by programs. 
We call _expression_ any string understood by Dedukti:
it can be the declaration of a type `Nat` in Dedukti,
a set of declarations and definitions, a collection of definitions,
declarations and theorems.
We call _module_ a Dedukti file containing proofs. The file `nat.dk` containing
```
Nat: Type.
z: Nat
s: Nat -> Nat
```
is a module containing expressions.
We call _library_ a set of modules which are related by topic are dependency.

Blueprint
---------

We call *blueprint* a file that holds metadata about a library.

A *blueprint* is a BSD flavoured [Makefile][2] (see [[3]] for POSIX makefiles)
defining the following variables:

- `LIB_NAME`: name of the library. This is not the [library
  name](#library-name-specification)

- `LIB_VERSION`: version of the library.

- `LIB_FLAVOUR`: denotes some options used in the generation of the library.
  This field is optional.

- `LIB_DEPENDS`: a list of [library paths](#library-path-specification) on
  which the library depends.

- `LIB_ORIGIN`: URL to the original files of the library, as distributed by the
  authors.

- `ENCODING`: a list of [library path](#library-path-specification) that
  specifies the encoding of the logic the library is expressed into. It must be
  a (possibly empty) subset of `LIB_DEPENDS`. This field serves interoperability
  purposes.
 
- `SYNTAX`: concrete syntax the library is written in. See the [syntax
  specification](#syntax-specification).

- `TOOLING`: a list of tools used to translate proofs. A tool is specified by
  a string `<name>:<version>` where `<name>` is the name of the tool, and
  `<version>` is its version used. The format of the version may depend on the
  source of the tool. If the tool is stored on git, a commit hash, or tag, or
  branch name may be provided. Tools are referenced in `TOOLS`.

- `MAIN`: a list of modules standing for entry points to the library. The entry
  points are explicitly checked whereas other modules are usually checked
  as dependencies.

- `FLAGS`: flags that may be passed to the checker.
  
**Note:**
These variables not only serve informative purposes, they can be used to fulfill
miscellaneous tasks using targets defined in `infrastructure/mk/library.mk`.
More information on these targets are given in
[How to use this repository](#how-to-use-this-repository).
 
Library name
------------

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

Library path
------------

Each location in the library tree is uniquely identified by a *libpath*.

Every *libpath* conforms to the pattern `cat/stem/[flavour,]version` 
where `stem`, `version` and `flavour` are defined in the
[name specification](#library-name-specification). The `cat` (for
category) part refers to the first directory at the root of the library tree.
The `flavour,` part is optional.

Such a *libpath* locates uniquely a library in the library tree.

For instance, `arithmetic/arith_fermat/sttfa,1.0` is the location of the library
`arith_fermat` version `1.0` in its `sttfa` flavour.

As an example, the overall structure of the library tree may look like this,
```
nubo/
+- encodings/
|  +- libA/
|  |  +- 1.0/
|  |  |  +- Makefile
|  |  +- flavA,1.0/
|  |  |  +- Makefile
|  |  +- flavA,1.1/
|  |  |  +- Makefile
|  |  +- flavB,1.0/
|  |     +- Makefile
|  +- libB/
|     +- ...
+- arithmetic/
   +- ...
```

**Note:** in the previous example, each `Makefile` is a
[*blueprint*](#blueprint-specification).

Syntax specifier
----------------

Proofs are written in a concrete syntax that can be
identified by a syntax specification which conforms to the pattern
```
stem [options]
```

The _stem_ part is a string without spaces that identifies a grammar.

The _options_ part is a (possibly empty) space-separated list of strings
preceded by a `-` or a `+`. An option identifies one or more syntax
extensions that are added to the grammar _stem_ if the option is preceded by `+`
or removed from the grammar if the option is preceded by `-`.

The possible stems and options are referenced in the file `SYNTAXES`. The
`SYNTAXES` file follows the [record jar][1] format where records contain the
following fields:
- `type`: either `stem` or `option`,
- `key`: the string that may be used in the syntax specifier,
- `description`: a short description of the grammar or the syntax extension
  introduced by the record.

Tooling
-------

The file `TOOLS` gathers information on the tools that may be used to translate
proofs or to operate on translated proofs. It follows the [record jar][1] 
format.

A record must at least contain the fields `name` and `homepage`. Any other field
is optional.

- `name`: a unique name that identifies the tool.
- `homepage`: URL of the homepage of the tool from where it can be downloaded.

Packaged libraries
------------------

Libraries are packaged into gzipped tarballs with the extension `.tgz` for
distribution.
Each library identified by a
[library name specification](#library-name-specification) _libname_ is
packaged as `libname.tgz`. Such an archive must contain

- the proofs (`.dk` files),

- a [Makefile][2] dependency list named `.depend` listing the dependencies
  between the modules.

Proofs are expected to be in the same directory as the dependency file.

For instance, the archive of `arith_fermat-1.0-sttfa` is available at
`${PKG_PATH}/arith_fermat-1.0-sttfa.tgz` (see the documentation of
[makefiles](mk/README.md) for a description of `${PKG_PATH}`).

How to use this repository
--------------------------

The library tree can be used to install, check or package libraries using
_make_.

**Caution:** [*BSD* _make_](https://man.netbsd.org/make.1) must be used,
Linux users must invoke `bmake` rather than `make`.

**Caution:** the variable `NUBOROOT` must be set for most of these
commands to work.

The available targets are
- *download*: download and extracts the source files of the library,
- *check*: check the library. By defaults it uses Dedukti to check the library.
  It can be invoked as `make check=CHECKER` where `CHECKER` is the name of a
  known checker. Currently available are `dedukti` and `kontroli`.
- *package*: create a library package from the downloaded files. 
- *lint*: performs sanity checks on a package.
- *makesum*: computes the checksum of the library package and replace it in the
  blueprint.
- *list*: list available libraries.
- *clean*: clean content. By default, clean the blueprint directory. It can be
  invoked as `make clean='[work build]'`.
  - _work_: clean the blueprint directory (remove archives and uncompressed
    library).
  - _build_: clean typechecked files.

These commands must be called in the same directory as the
[blueprint](#blueprint-specification). For example, to download
`arith_fermat-1.0-sttfa`,

``` sh
cd libraries/arith_fermat/sttfa,1.0
make download
```

More documentation on targets is available in `infrastructure/mk/README.md`.

Contributing to Nubo
--------------------

If you have translated a library in Dedukti (and it typechecks), or you
designed an encoding; you may submit it to Nubo.

**Contribution checklist:**

1. Fetch a copy of the Nubo proof tree. Let _root_ be the path to the proof tree.
2. Pick a category for your ports. Either an already existing one at
   _root_`/<cat>` or create a new one. Let _cat_ be the chosen category.
3. Create the directory structure: let _name_ be the name of your library,
   _ver_ its version. Create the directory tree
   _root_`/`_cat_`/`_name_`/`_ver_`/`. If there are different version of the
   same library, flavours may be specified. In that case, the directory tree is
   _root_`/`_cat_`/`_name_`/`_ver_`,`_flavour_`/`.
4. Copy the template blueprint from _root_`/infrastructure/templates/Makefile`
   to the created directory, and fill all variables noted `# REQUIRED`.
5. Copy your modules into a directory named _name_`-`_ver_ or
   _name_`-`_ver_`-`_flav_ alongside the new blueprint. There must not be any
   subdirectory in the directory containing the modules.
6. In the former directory, create a `.depend` file such that for each module
   _m_ that depends on modules _m1_, _m2_, ... there is a target _m_`.dko`
   which depends on _m_`.dk` and _mi_`.dko`.
7. Make the library package with `make package`.
8. Add the checksum of the package with `make makesum`. The original blueprint
   is saved as `Makefile.bak`.
9. Run basic verifications with `make lint`.
10. Assert it typechecks running `make check`.
11. Incorporate your new library: email your blueprint to
    <dedukti-dev@inria.fr> with its category and the package or an URL where it
    can be retrieved.  If you cloned Nubo using git, add a one-line entry for
    the new library in its parent directory's makefile, e.g. for
    `libraries/arith_fermat/`, add it to `libraries/Makefile`, commit and email
    a patch (see `git-format-patch(1)`) or create a pull request.
    
Steps 2 to 4 can be automated using `make new` at _root_. Step 6 can be automated
using [`dkdep`](https://github.com/Deducteam/dedukti).
 
Notes
-----

It is the user's responsability to install softwares and
[tools](#tooling-specification) in their appropriate version.

Upcoming
--------

- Add a maintainer for each library

- Use another format than Makefile to have easily parsable meta data. Or
  add target to generate json from makefile.

[1]: https://tools.ietf.org/html/draft-phillips-record-jar-01
[2]: https://man.openbsd.org/make.1
[3]: https://pubs.opengroup.org/onlinepubs/009695299/utilities/make.html
