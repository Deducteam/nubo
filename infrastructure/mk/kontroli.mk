CHECK ?= kocheck

_MK = ${NUBOROOT}/infrastructure/mk

.for tg in ${.TARGETS}
${tg}:
	@${MAKE} -f ${_MK}/tc.mk ${tg}.dko | xargs ${CHECK} ${FLAGS}
.endfor

clean:
