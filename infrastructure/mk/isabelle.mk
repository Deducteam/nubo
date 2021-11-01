FETCH ?= wget

.PRECIOUS: Isabelle2020_linux.tar.gz
Isabelle2020_linux.tar.gz:
	${FETCH} https://isabelle.in.tum.de/website-Isabelle2020/dist/$@

.PRECIOUS: Isabelle2020
Isabelle2020: Isabelle2020_linux.tar.gz
	tar xzf $<

isabelle_dedukti:
	git clone https://github.com/Deducteam/isabelle_dedukti
	cd $@ && git checkout -q 6be79cb262eb418fef22a4940bfa84d5f8a90493

ISA ?= Isabelle2020/bin/isabelle

_DKJAR = isabelle_dedukti/lib/classes/dedukti.jar
${_DKJAR}: isabelle_dedukti
	# ${ISA} components -u isabelle_dedukti
	mkdir -p ${HOME}/.isabelle/Isabelle2020/etc
	echo ${PWD}/isabelle_dedukti > ${HOME}/.isabelle/Isabelle2020/etc/components
	${ISA} dedukti_build

.SUFFIXES: .dk

.for tg in ${.TARGETS}
${tg}.dk: ${_DKJAR}
	${ISA} dedukti_import -O $@ $*
.endfor

clean:
	rm -rf Isabelle2020_linux.tar.gz Isabelle2020 isabelle_dedukti ${HOME}/.isabelle/Isabelle2020
