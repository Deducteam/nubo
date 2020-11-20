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

Proof package format
--------------------

Using this repository in practice
---------------------------------
