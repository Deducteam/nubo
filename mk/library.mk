#-*- mode: Makefile; tab-width: 4; -*-
# ex:ts=4 sw=4 filetype=make:

# Targets and meta data specifications, defined by each library
LIB_NAME    ?=
LIB_VERSION ?=
LIB_FLAVOUR ?=
LIB_MD5     ?=
DK_VERSION  ?=
LIB_DEPENDS ?=
LIB_ORIGIN  ?=
TOOLING     ?=
ENCODING    ?=

# Global variables
PREFIX   ?= /usr/local/share/nubo/
PKG_PATH ?= http://logipedia.inria.fr/nubo/

# Binaries
FETCH_CMD ?= curl
TAR       ?= tar

###
### End of variable setup. Only targets now.
###

download:
.if ${LIB_FLAVOUR}
	mkdir -p ${LIB_NAME}-${LIB_VERSION}-${LIB_FLAVOUR}/
	${FETCH_CMD} ${PKG_PATH}/${LIB_NAME}-${LIB_VERSION}-${LIB_FLAVOUR}.tgz | \
${TAR} xz -C ${LIB_NAME}-${LIB_VERSION}-${LIB_FLAVOUR}/
.else
	mkdir -p ${LIB_NAME}-${LIB_VERSION}/
	${FETCH_CMD} ${PKG_PATH}/${LIB_NAME}-${LIB_VERSION}.tgz | \
${TAR} xz -C ${LIB_NAME}-${LIB_VERSION}/
.endif

check:
	# TODO

install:
	# TODO

package:
	# TODO
