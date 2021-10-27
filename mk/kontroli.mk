.for tg in ${.TARGETS}
${tg}:
	${MAKE} -f ${NUBOROOT}/mk/tc.mk ${tg}.dko | xargs ${CHECK} ${FLAGS}
.endfor

clean:
