all:

.SUFFIXES: .dk .dko

.dk.dko:
	${CHECK} ${FLAGS} `tstcdd $< | xargs dkfy`
# Because Kontroli does not produce objects, we just copy the source
	cp $< $@

clean:
	rm -rf *.dko
