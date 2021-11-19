#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use File::Temp qw(tempdir);
use Archive::Tar;
use File::Basename qw(fileparse);

my $usage = <<EOT;
Usage: lint.pl LIBPKG
Lints the library package LIBPkG. Verifies that
- the package is a gzipped archive
- modules are located at the rot of the archive
- a dependency list .depend is present
- modules do not self qualify (refer to themselves)
- there are no deprecated syntax
EOT

my $libpkg = shift;
die $usage unless $libpkg;

my $libtar = Archive::Tar->new();
$libtar->read($libpkg);

my $tmpdir = tempdir( CLEANUP => 1 );
chdir $tmpdir;
$libtar->extract();

-r '.depend' or die 'Cannot read .depend at root of package';

my $errors = 0;

foreach my $fname (glob '*.dk') {
    my $mod = fileparse($fname, ('.dk'));
    open(my $fh, '<', $fname);
    while (<$fh>) {
        if (/$mod\.\w/) { $errors++; warn "[$fname:$.] Self qualification" }
        if (/^#NAME/  ) { $errors++; warn "[$fname:$.] Deprecated command" }
    }
    close $fh;
}
exit ($errors > 0 ? 1 : 0);
