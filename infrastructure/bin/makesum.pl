#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use Env qw(PWD);
use Digest::file qw(digest_file_hex);
use File::Copy qw(move);

my $usage = <<EOT;
Usage: makesum.pl LIBPKG
Substitute the checksum with the one of ARCHIVE in the blueprint of the current
directory. The original blueprint is copied to Makefile.bak.
EOT

my $archive = shift;
die $usage unless defined($archive);
-r 'Makefile' or die "Can't read ${PWD}/Makefile";

my $digest = digest_file_hex($archive, 'MD5');
@ARGV = ('Makefile');
our $^I = '.bak'; # In place edit
while ( <ARGV> ) {
    s/^(LIB_MD5\s*=).*$/$1 $digest/;
    print $_;
}
