# vim:ts=4 sw=4 filetype=make:
# definitions common to nubo.library.mk and nubo.subdir.mk

PERL       ?= /usr/bin/perl
_PERLSCRIPT = ${PERL} ${NUBOROOT}/infrastructure/bin
TMPDIR     ?= /tmp

_clean = ${clean:Uall}

# Define main target depending on the invocation: if make check=kontroli is
# invoked, check is declared as main target.
.for t in check clean
.  if defined($t)
.MAIN: $t
.  endif
.endfor
