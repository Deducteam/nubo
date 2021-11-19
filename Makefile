SUBDIR =
SUBDIR += encodings
SUBDIR += libraries

.include "${NUBOROOT}/infrastructure/mk/nubo.subdir.mk"

new:
	@${_PERLSCRIPT}/addlib.pl

.PHONY: new
