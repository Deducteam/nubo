# vim:ts=4 sw=4 filetype=make:

.include "${NUBOROOT}/infrastructure/mk/nubo.common.mk"

clean:
.for s in ${SUBDIR}
.  if defined(clean)
	${MAKE} -C $s clean="${clean}"
.  else
	${MAKE} -C $s clean
.  endif
.endfor
