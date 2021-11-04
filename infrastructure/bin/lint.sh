#!/bin/sh
# vim: set expandtab sw=4 ts=4:

set -eu

# Linting verifies that
# - the package is tar-gzipped archive
# - the sources are at the root of the archive
# - there is a .depend
# - files do not contain qualifications to themselves
# - there are no deprecated commands (such as '#NAME')

archive="$1"
tmp=$(mktemp -d)

trap cleanup INT

cleanup () {
    rm -rf "$tmp"
}

tar xzf "$archive" -C "$tmp" 
if [ ! -r "${tmp}/.depend" ]; then
    echo "No .depend at the root of the package"
    exit 127
fi

for f in "${tmp}"/*.dk; do
    mod="$(basename "$f")"
    if grep -q -E "$mod" "$f"; then
        echo "Self qualification in module $mod."
        exit 126
    fi
done

for f in "${tmp}"/*.dk; do
    if grep -q -E "#NAME" "$f"; then
        echo "Deprecated command in file $f."
        exit 125
    fi
done

cleanup
