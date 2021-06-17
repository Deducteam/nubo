Makefiles for Nubo
==================

The makefiles of this directory provide the different commands available to
interact with the libraries.

`library.mk`
------------

The makefile `library.mk` must be included *at the end* of the blueprints with

``` makefile
.include "../../../mk/library.mk"
```

**Variables:**

- `PKG_PATH`: path where the packages can be retrieved. The full URL of a
  package from a library whose path is `lpth` is `${PKG_PATH}/lpth`.
- `PREFIX`: the path to the root of the library path tree.
- `CHECKER`: specify which program is to be used to check files. Can be either
  `dedukti` or `kontroli`. Defaults to `dedukti`.

**Targets:**

- `download`: download the library.
- `check`: download the library (if needed) and check it.
- `package`: TODO
- `install`: TODO

`dedukti.mk`, `kontroli.mk`
---------------------------

These two makefile define the inference rules to transform a `.dk` file into a
`.dko` file, using either [Dedukti](https://github.com/Deducteam/dedukti) or
[Kontroli](https://github.com/01mf02/kontroli-rs).
