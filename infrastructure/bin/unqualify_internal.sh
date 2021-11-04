#!/bin/sh
set -eu

## Some Dedukti files have the symbols declared qualified by their modules. For
## instance, assuming the file "foo.dk" declaring a symbol "bar", "foo.bar" may
## appear inside "foo.dk". The following command curates all the files of a
## library, replacing "foo.bar" by "bar".

dir="$1" # Directory of the library

(cd "$dir" || exit 1
 for f in *.dk; do
     sed -i "s/${f%.dk}\\.//g" "$f"
 done)
