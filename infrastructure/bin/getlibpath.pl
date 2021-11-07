#!/usr/bin/perl

use strict;
use warnings;
use autodie;
use Env qw(NUBOROOT);
use Cwd qw(abs_path);
use English;

my $usage = <<EOT;
Usage: getlibpath.pl DIR
Return the path going from environment variable \$NUBOROOT to DIR. DIR
must be below \$NUBOROOT.
EOT

my $dir = shift;
defined($NUBOROOT) or die 'NUBOROOT not defined';
die $usage unless $dir;

my $real_dir = abs_path($dir);
my $realnubo = abs_path($NUBOROOT);
if ($real_dir =~ m/\Q$realnubo\E\//) {
    print $POSTMATCH, "\n";
} else { die "Can't resolve library path" }
exit 0;
