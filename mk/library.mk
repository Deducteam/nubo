#-*- mode: Makefile; tab-width: 4; -*-
# ex:ts=4 sw=4 filetype=make:

# Targets and meta data specifications, defined by each library
LIB_NAME    ?=
LIB_VERSION ?=
ENCODING    ?=
DK_VERSION  ?=
LIB_DEPS    ?=
LIB_ORIGIN  ?=
TOOLING     ?=

# Global variables
PREFIX      = /usr/local/share/logipedia/
LIB_PATH    = http://www.lsv.fr/~hondet/nubo/

# Binaries
FETCH_CMD = curl
TAR       = tar

###
### End of variable setup. Only targets now.
###

download:
	${FETCH_CMD} ${LIB_PATH}/${LIB_NAME}-${LIB_VERSION}-${ENCODING}.tgz | \
${TAR} xz

install:
	# TODO

check:
	# TODO

package:
	# TODO
