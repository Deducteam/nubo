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
MAIN 		?=

# Paths
NUBOROOT ?= /usr/local/share/nubo/
PKG_PATH ?= http://logipedia.inria.fr/nubo/
CACHE    ?= ${NUBOROOT}/_cache
BIN      ?= ${NUBOROOT}/bin

# Binaries
FETCH_CMD ?= curl
TAR       ?= tar

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

# Get the name of dependencies (from their path)
_DEP_NAMES =
.for dep in ${LIB_DEPENDS}
.  if ${dep:M*/*/*,*} # Does the libpath contain a flavour?
_DEP_NAMES += ${dep:C/[^\/]+\/([^\/]+)\/([^,]+),(.+)$\)/\1-\3-\2/g}
.  else
_DEP_NAMES += ${dep:C/[^\/]+\/([^\/]+)\/(.+)$/\1-\2/g}
.  endif
.endfor

###
### End of variable setup. Only targets now.
###

download:
	mkdir -p ${_NAME}
	${FETCH_CMD} ${PKG_PATH}/${_NAME}.tgz | \
	${TAR} xz -C ${_NAME}/

check: download
	rm -rf ${CACHE}/${_NAME}
	mkdir -p ${CACHE}/${_NAME}
	ln -f ${.CURDIR}/${_NAME}/*.dk ${CACHE}/${_NAME}
	ln -f ${.CURDIR}/${_NAME}/.depend ${CACHE}/${_NAME}
#.for dep in ${LIB_DEPENDS}
#	${MAKE} -C ${NUBOROOT}/${dep} check
#.endfor
.for dep in ${_DEP_NAMES}
	ln -f ${CACHE}/${dep}/*.dk ${CACHE}/${_NAME}
.endfor
	${MAKE} -C ${CACHE}/${_NAME} \
-f ${NUBOROOT}/mk/${CHECKER}.mk CHECK="${_CHECK}" ${MAIN}

install:
	# TODO

package: download
	(cd ${_NAME} || exit 1; \
	${TAR} czf ${_NAME}.tgz *.dk .depend; \
	mv ${_NAME}.tgz ..)
