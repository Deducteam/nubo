#-*- mode: Makefile; tab-width: 4; -*-
# ex:ts=4 sw=4 filetype=make:

.include "nubo.common.mk"

# Targets and meta data specifications, defined by each library
LIB_NAME    ?=
LIB_VERSION ?=
LIB_FLAVOUR ?=
LIB_MD5     ?=
SYNTAX      ?=
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

# Binaries
FETCH_CMD ?= curl --silent
TAR       ?= tar
MD5       ?= md5sum --quiet
# For BSD:
#MD5       ?= md5 -rq
# or, if coreutils are installed
#MD5       ?= gmd5sum --quiet

.if ${LIB_FLAVOUR}
_NAME =	${LIB_NAME}-${LIB_VERSION}-${LIB_FLAVOUR}
.else
_NAME =	${LIB_NAME}-${LIB_VERSION}
.endif

_MK  = ${NUBOROOT}/infrastructure/mk

# Variables as targets.

_check = ${check:Udedukti}

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
	@printf 'Downloading and unpacking... '
	@${FETCH_CMD} ${PKG_PATH}/${_NAME}.tgz > ${_NAME}.tgz
	@mkdir -p ${_NAME}
	@(cd ${_NAME} && ${TAR} xzf ../${_NAME}.tgz)
	# NOTE: tar xzf is not POSIX, only tar xf is
	# Checking md5sum with cksum(1) style checksum
	@echo "${LIB_MD5} ${_NAME}.tgz" | ${MD5} -c -
	@printf '\033[0;32mOK\033[0m\n'

# Cache the library ${_NAME}
_cache: download
	@rm -rf ${CACHE}/${_NAME}
	@mkdir -p ${CACHE}/${_NAME}
	@ln -f ${.CURDIR}/${_NAME}/*.dk ${CACHE}/${_NAME}
	@ln -f ${.CURDIR}/${_NAME}/.depend ${CACHE}/${_NAME}

_internal-check: download _cache
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
	@${MAKE} -s -C ${CACHE}/${_NAME} -f ${_MK}/${_check}.mk \
		FLAGS="${FLAGS}" ${MAIN}
	@printf '\033[0;32mOK\033[0m\n'

_internal-clean:
.if ${_clean:Mwork} || ${_clean:Mall}
	@rm -rf ${_NAME} ${_NAME}.tgz
.endif
.if ${_clean:Mbuild} || ${_clean:Mall}
	@rm -rf ${CACHE}/${_NAME}
.endif

download: ${_NAME}

install:
	# TODO

package: ${_NAME}
	(cd ${_NAME} || exit 1; \
	${TAR} czf ${_NAME}.tgz *.dk .depend; \
	mv ${_NAME}.tgz ..)

lint: ${_NAME}.tgz
	${NUBOROOT}/bin/lint.sh ${.ALLSRC}
	echo "${_NAME}.tgz OK"

clean: _internal-clean

check: _internal-check

.PHONY: _internal-check _internal-clean check clean lint package install \
download _cache _dispatch
