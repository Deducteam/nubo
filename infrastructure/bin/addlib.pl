#!/usr/bin/perl

# addlib: a utility to add libraries to Nubo

use 5.012;
use strict;
use warnings;
use autodie;
use English;

use Env qw($NUBOROOT);
if (! defined $NUBOROOT) {
    die "NUBOROOT not defined."
}
use File::Path qw(make_path);
use File::Spec::Functions;
use Text::Wrap qw(wrap);

sub ask {
    # Read a string from standard input and return it. If an argument is given,
    # it stands as a default value
    my $default = shift;
    my $x = <STDIN>;
    chomp $x;
    return ($x eq q{} && defined $default) ? $default : $x;
}

my $approved = 0; # Has the user approved the input?
my ($cat, $name, $flavour, $version, $syntax);

while (! $approved) {
    # Prompt for data
    print 'Category: ';
    $cat = ask();
    $cat =~ /\w+/ or die "Invalid category";

    print 'Library name: ';
    $name = ask();
    $name =~ /\w+/ or die "Invalid name";

    print 'Flavour []: ';
    $flavour = ask();
    $flavour =~ /\w+/ or die "Invalid flavour";

    print 'Library version [1.0]: ';
    $version = ask('1.0');
    $version =~ /[^- ]+/ or die "Invalid version";

    print 'Syntax [dk]: ';
    $syntax = ask('dk');
    $syntax =~ /\w+(\s(\+|-)\w+)*/ or die "Invalid syntax specifier \"$syntax\"";

    print 'Is the information correct? [Y/n] ';
    $approved = ask ne 'n';
}

my $flav_vers =
  ( $flavour eq q{} ) ? $version : "${flavour},${version}" ;

my $libpath = catdir( $NUBOROOT, $cat, $name, $flav_vers );
make_path $libpath;
my $makefile = catfile( $libpath, 'Makefile' );

open my $fh, '>', $makefile;
print $fh <<"EOT";
LIB_NAME    = $name
LIB_VERSION = $version
LIB_FLAVOUR = $flavour
LIB_MD5     = # FILL
SYNTAX      = $syntax
LIB_DEPENDS = # TODO
ENCODING    = # TODO
MAIN        = # TODO

.include \"\${NUBOROOT}\"/infrastructure/mk/nubo.library.mk
EOT
close $fh;

say "Makefile created at ${makefile}.";
my $libname =
    "${name}-${version}" . ( $flavour eq "" ) ? "-${flavour}" : "" ;
say wrap(q{}, q{}, <<"EOT");
To finish, (a) package your library as ${libname}.tgz, (b) fill the LIB_MD5
field with its MD5 checksum and (c) submit the whole to Nubo!
EOT
