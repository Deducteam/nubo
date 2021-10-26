.for tg in ${.TARGETS}
${tg}:
	${MAKE} -f ${PREFIX}/mk/tc.mk ${tg}.dko | xargs ${CHECK} ${FLAGS}
.endfor

clean:
