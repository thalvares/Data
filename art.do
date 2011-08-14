sjlog using art1, replace
artsurv, method(l) nperiod(8) ngroups(2) edf0(0.3, 3) hratio(1, 0.80) n(842) alpha(0.05) recrt(6)
sjlog close, replace

sjlog using art2, replace
artpep, pts(100) epts(150) eperiods(10) startperiod(1) stoprecruit(6) datestart(01jan2009) $S_ARTPEP
sjlog close, replace

sjlog using art3, replace
display "$S_ARTPEP"
sjlog close, replace

sjlog using art4, replace
artpep, pts(100) edf0(.3, 3) epts(150) eperiods(10) startperiod(1) stoprecruit(6) datestart(01jan2009) hratio(1, .8)
sjlog close, replace

sjlog using art5, replace
artpep, pts(100) edf0(.4, 3) epts(150) eperiods(10) startperiod(1) stoprecruit(6) datestart(01jan2009) hratio(1, .8)
sjlog close, replace

