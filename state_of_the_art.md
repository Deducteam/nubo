# State of the art

Most formal proof collections are tied to a proof assistant,
in which all proofs have been checked.
We can mention _Metamath_ [@metamath] and its 23,000 proofs;
_Isabelle_'s [@DBLP:journals/corr/cs-LO-9301106]
"Archive of formal proofs" and its 198,100 lemmas or
_MML_, the _Mizar_ [@DBLP:conf/ijcai/TrybulecB85] Mathematical Library.
The initiative _Q.E.D._ [@DBLP:conf/cade/Anonymous94]
promoted a checker-agnostic (or rather liberal) database of formalised mathematics.
Unfortunately, the project has been quickly abandoned.
_Logipedia_ [@logipedia] intends to become a multi-system encyclopedia
fostering proof exchange between formal systems.
It uses the logical framework _Dedukti_ [@expressing]
as back-end in which proofs
from other proof assistants are encoded.
Following the works of F. Thiré [@thire20phd],
_Logipedia_ allows to export the arithmetic library of _Matita_
to four other proof assistants:
_PVS_, _Lean_ [@leansysdesc],
and _Coq_ as well as the language
_OpenTheory_ [@DBLP:conf/nfm/Hurd11]
(handled by _HOL-Light_ [@DBLP:conf/fmcad/Harrison96] and
_HOL4_ [@DBLP:conf/tphol/SlindN08]).
Proofs fed to _Logipedia_ are not developed
in the logical framework _Dedukti_,
they are transpiled from other formal systems to _Dedukti_.
[@DBLP:conf/icdcit/Miller20] offers a broader view on the distribution
of proofs over the web.
_Nubo_ can certainly be relevant regarding the challenges
exposed, either as a solution or just as a framework for collections of formal proofs.
