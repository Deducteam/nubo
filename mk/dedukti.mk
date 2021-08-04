all:

.SUFFIXES: .dk .dko

.dk.dko:
	${CHECK} ${FLAGS} -e $<

clean:
	rm -rf *.dko
