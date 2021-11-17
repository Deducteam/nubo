# vim:ts=4 sw=4 filetype=make:

.include "${NUBOROOT}/infrastructure/mk/nubo.common.mk"

list:
.for s in ${SUBDIR}
	@(cd $s && ${MAKE} list)
.endfor

clean:
.for s in ${SUBDIR}
.  if defined(clean)
	${MAKE} -C $s clean="${clean}"
.  else
	${MAKE} -C $s clean
.  endif
.endfor
