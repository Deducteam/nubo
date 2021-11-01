Makefiles for Nubo
==================

The makefiles of this directory provide the different commands available to
interact with the libraries.

`nubo.library.mk`
-----------------

The makefile `nubo.library.mk` must be included *at the end* of the blueprints with

``` makefile
.include "${NUBOROOT}/infrastructure/mk/nubo.library.mk"
```

**Variables:**

TODO

**Targets:**

TODO

`nubo.subdir.mk`
----------------

TODO

`nubo.common.mk`
----------------

TODO

`dedukti.mk`, `kontroli.mk`
---------------------------

These two makefiles are used by the `check` target of `nubo.library.mk`. Let `M` be
any of the two makefiles and `T1 T2 ...` be module names to be compiled. Then
`make -f M T1 T2 ...` must check the modules `T1 T2 ...` located in files
`T1.dk T2.dk ...`. Each of these makefiles ensure such a property for a given
`CHECKER`, either [Dedukti](https://github.com/Deducteam/dedukti) or
[Kontroli](https://github.com/01mf02/kontroli-rs).

`tc.mk`
-------

The makefile `tc.mk` (for *t*ransitive *c*losure) is used to compute the
transitive closure of the dependencies of a file.

Assuming we have a list of files `f1.dk f2.dk ...` and a (valid) `.depend`
file, calling `make -f ${NUBOROOT}/mk/tc.mk fk.dko` prints the dependencies of
`fk.dko`
to the standard output.

`isabelle.mk`
-------------

Provides recipes to generate Dedukti file from Isabelle standard library.
