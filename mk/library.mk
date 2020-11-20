#-*- mode: Makefile; tab-width: 4; -*-
# ex:ts=4 sw=4 filetype=make:

# Targets and meta data specifications, defined by each library
LIB_NAME    ?=
LIB_VERSION ?=
ENCODING    ?=
PKG_URL     ?=
DK_VERSION  ?=
LIB_DEPS    ?=

# Global variables
PREFIX      ?= /usr/local/share/logipedia/

# System binaries
FETCH_CMD = curl -o "${LIB_NAME}-${LIB_VERSION}-${ENCODING}.tgz"

###
### End of variable setup. Only targets now.
###

download:
	${FETCH_CMD} "${PKG_URL}"

install:
	# TODO

check:
	# TODO

package:
	# TODO
