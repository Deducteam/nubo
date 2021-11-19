CHECK ?= dkcheck 2> /dev/null

.for tg in ${.TARGETS}
${tg}: ${tg}.dko
.endfor

.SUFFIXES: .dk .dko

.dk.dko:
	@${CHECK} ${FLAGS} -e $<

clean:
	rm -rf *.dko
