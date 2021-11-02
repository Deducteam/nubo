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
FLAGS       ?=

# Paths
NUBOROOT ?= /usr/local/share/nubo/
PKG_PATH ?= http://logipedia.inria.fr/nubo/
CACHE    ?= ${NUBOROOT}/_cache
BIN      ?= ${NUBOROOT}/bin

# Binaries
FETCH_CMD ?= curl --silent
TAR       ?= tar

.if ${LIB_FLAVOUR}
_NAME =	${LIB_NAME}-${LIB_VERSION}-${LIB_FLAVOUR}
.else
_NAME =	${LIB_NAME}-${LIB_VERSION}
.endif

# The checker is the name of the system used to typecheck files. When
# checking files, a makefile ${CHECKER}.mk is looked for in the mk/ folder
CHECKER ?= dedukti

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

# Library unpacked as a directory
${_NAME}:
	@mkdir -p ${_NAME}
	@printf 'Downloading and unpacking... '
	@${FETCH_CMD} ${PKG_PATH}/${_NAME}.tgz | \
		${TAR} xz -C ${_NAME}/
	@printf '\033[0;32mOK\033[0m\n'

# Cache the library ${_NAME}
_cache: download
	@rm -rf ${CACHE}/${_NAME}
	@mkdir -p ${CACHE}/${_NAME}
	@ln -f ${.CURDIR}/${_NAME}/*.dk ${CACHE}/${_NAME}
	@ln -f ${.CURDIR}/${_NAME}/.depend ${CACHE}/${_NAME}

download: ${_NAME}

check: download _cache
.for dep in ${LIB_DEPENDS}
	@${MAKE} -C ${NUBOROOT}/${dep} _cache
.endfor
.for dep in ${_DEP_NAMES}
	@ln -f ${CACHE}/${dep}/*.dk ${CACHE}/${_NAME}
	# Import .depend file of the dependency to check it correctly
	@ln -f ${CACHE}/${dep}/.depend ${CACHE}/${_NAME}/${dep}.mk
	@echo '.include "${dep}.mk"' >> ${CACHE}/${_NAME}/.depend
.endfor
	@printf 'Checking... '
	@${MAKE} -s -C ${CACHE}/${_NAME} \
-f ${NUBOROOT}/mk/${CHECKER}.mk FLAGS="${FLAGS}" ${MAIN}
	@printf '\033[0;32mOK\033[0m\n'

install:
	# TODO

package:
	(cd ${_NAME} || exit 1; \
	${TAR} czf ${_NAME}.tgz *.dk .depend; \
	mv ${_NAME}.tgz ..)

lint: ${_NAME}.tgz
	${NUBOROOT}/bin/lint.sh ${.ALLSRC}
	echo "${_NAME}.tgz OK"

clean:
	rm -rf ${_NAME} ${CACHE}/${_NAME}
