#-*- mode: Makefile; tab-width: 4; -*-
# ex:ts=4 sw=4 filetype=make:

# Variables that start with an underscore are not part of the API and may change
# without notice.

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

PROGRESS_METER ?= Yes

# Binaries
.if ${PROGRESS_METER:L} == 'yes'
FETCH_CMD ?= curl --progress-bar
.else
FETCH_CMD ?= curl --silent
.endif
TAR       ?= tar
MD5       ?= md5sum
# For BSD:
#MD5       ?= md5 -rq
# or, if coreutils are installed
#MD5       ?= gmd5sum

.if ${LIB_FLAVOUR}
_NAME =	${LIB_NAME}-${LIB_VERSION}-${LIB_FLAVOUR}
.else
_NAME =	${LIB_NAME}-${LIB_VERSION}
.endif

_MK = ${NUBOROOT}/infrastructure/mk
# Used to display messages. Override to turn off display
ECHO_MSG ?= echo

# Variables as targets.

_check = ${check:Udedukti}
_known_checkers = kontroli dedukti
.if !${_known_checkers:M${_check}}
ERRORS += "Fatal: unknown checker: ${_check}.\n(not in ${_known_checkers})"
.endif

_clean_cmds = all build work
.for _w in ${_clean}
.  if !${_clean_cmds:M${_clean}}
ERRORS += "Fatal: unknown clean command ${_w}\n(not in ${_clean_cmds})"
.  endif
.endfor

.if !empty(LIB_FLAVOUR:M[0-9]*)
ERRORS += "Fatal: flavour should never start with a digit"
.endif

_LIBPTH != ${_PERLSCRIPT}/getlibpath.pl ${.CURDIR}

###
### End of variable setup. Only targets now.
###

# Library unpacked as a directory
${_NAME}:
	@${ECHO_MSG} "===> Downloading"
	@${FETCH_CMD} ${PKG_PATH}/${_NAME}.tgz > ${_NAME}.tgz
	@mkdir -p ${_NAME}
	@${ECHO_MSG} "===> Unpacking"
	@(cd ${_NAME} && ${TAR} xzf ../${_NAME}.tgz)
	# NOTE: tar xzf is not POSIX, only tar xf is
	# Checking md5sum with cksum(1) style checksum
	@echo "${LIB_MD5} ${_NAME}.tgz" | ${MD5} --quiet -c -
	@${ECHO_MSG} '\033[0;32mOK\033[0m'

# Cache the library ${_NAME}
_cache: download
	@rm -rf ${CACHE}/${_LIBPTH}
	@mkdir -p ${CACHE}/${_LIBPTH}
	@ln -f ${.CURDIR}/${_NAME}/*.dk ${CACHE}/${_LIBPTH}
	@cp -f ${.CURDIR}/${_NAME}/.depend ${CACHE}/${_LIBPTH}

_internal-check: download _cache
.for dep in ${LIB_DEPENDS}
	@${MAKE} -C ${NUBOROOT}/${dep} _cache
	@ln -f ${CACHE}/${dep}/*.dk ${CACHE}/${_LIBPTH}
	# Import .depend file of the dependency to check it correctly
	@cp -f ${CACHE}/${dep}/.depend ${CACHE}/${_LIBPTH}/${dep:S/\//_/g}.mk
	@echo '.include "${dep:S/\//_/g}.mk"' >> ${CACHE}/${_LIBPTH}/.depend
.endfor
	@${ECHO_MSG} '===> Proof checking'
	@${MAKE} -C ${CACHE}/${_LIBPTH} -f ${_MK}/${_check}.mk \
		FLAGS="${FLAGS}" ${MAIN}
	@${ECHO_MSG} '\033[0;32mOK\033[0m'

_internal-clean:
.if ${_clean:Mwork} || ${_clean:Mall}
	@rm -rf ${_NAME} ${_NAME}.tgz
.endif
.if ${_clean:Mbuild} || ${_clean:Mall}
	@rm -rf ${CACHE}/${_LIBPTH}
.endif

download: ${_NAME}

install:
	# TODO

package: ${_NAME}
	(cd ${_NAME} || exit 1; \
	${TAR} czf ${_NAME}.tgz *.dk .depend; \
	mv ${_NAME}.tgz ..)

lint: ${_NAME}.tgz
	@${ECHO_MSG} "===> Linting ${_NAME}.tgz"
	@${_PERLSCRIPT}/lint.pl ${.ALLSRC}
	@${ECHO_MSG} '\033[0;32mOK\033[0m'

makesum: ${_NAME}.tgz
	${_PERLSCRIPT}/makesum.pl ${.ALLSRC}

clean: _internal-clean

check: _internal-check

.if defined(ERRORS)
.BEGIN:
.  for _m in ${ERRORS}
	@echo 1>&2 ${_m} "(in ${_NAME})"
.  endfor
.  if !empty(ERRORS:M"Fatal\:*") || !empty(ERRORS:M'Fatal\:*')
	@false # Exits with error 1. exit does not work
.  endif
.endif

.PHONY: _internal-check _internal-clean check clean lint package install \
download _cache _dispatch makesum
