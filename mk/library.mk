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

# Paths
PREFIX   ?= /usr/local/share/nubo/
PKG_PATH ?= http://logipedia.inria.fr/nubo/
CACHE    ?= ${PREFIX}/_cache

# Binaries
FETCH_CMD ?= curl
TAR       ?= tar

#_SOURCES != cat ${.CURDIR}/PLIST

.if ${LIB_FLAVOUR}
_NAME =	${LIB_NAME}-${LIB_VERSION}-${LIB_FLAVOUR}
.else
_NAME =	${LIB_NAME}-${LIB_VERSION}
.endif

# The checker is the name of the system used to typecheck files. When
# checking files, a makefile ${CHECKER}.mk is looked for in the mk/ folder
CHECKER ?= dedukti

# Binary name for the checker
.if "${CHECKER}" == dedukti
_CHECK = dkcheck
.elif "${CHECKER}" == kontroli
_CHECK = kocheck
.endif

# Set up checker flags to include other libraries
.for dep in ${LIB_DEPENDS}
# Transform a libpath into a library name
# REVIEW: provide more precise regular expressions
.  if ${dep:M*/*/*,*} # Does the libpath contain a flavour?
_FLAGS += -I ${CACHE}/${dep:C/[^\/]+\/([^\/]+)\/([^,]+),(.+)$\)/\1-\3-\2/g}
.  else
_FLAGS += -I ${CACHE}/${dep:C/[^\/]+\/([^\/]+)\/(.+)$/\1-\2/g}
.  endif
.endfor

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

check: download
	rm -rf ${CACHE}/${_NAME}
	mkdir -p ${CACHE}/${_NAME}
	ln -f ${.CURDIR}/${_NAME}/*.dk ${CACHE}/${_NAME}
	ln -f ${.CURDIR}/${_NAME}/.depend ${CACHE}/${_NAME}
.for dep in ${LIB_DEPENDS}
	${MAKE} -C ${PREFIX}/${dep} check
.endfor
	${MAKE} -C ${CACHE}/${_NAME} -f ${PREFIX}/mk/${CHECKER}.mk \
FLAGS="${_FLAGS}" CHECK="${_CHECK}" all

install:
	# TODO

package:
	# TODO
