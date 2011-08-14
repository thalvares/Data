datajoint1 using sim_cd4,dfile(sim_surv) markerv(sqcd4) markert(cd4_tm) id(id) dropev( AIDS_death) ///
dropt( aids_death_tm) cov(age40plus) clear 

xi: jmre1  _JY  _M   i._Mage40plus*_Mcd4_tm ,rem( _M  _Mcd4_tm) red( _D) ///
drop( AIDS_death  _D i._Dage40plus) time( _Mcd4_tm) l1( _M) id(id) 

predict xb_marker,xb
predict xb_dropout,xb eq(Drop_Out)
predict SE_xb_marker,stdp 
predict SE_xb_dropout,stdp eq(Drop_Out)
predict eb,ref
predict fit, fit
predict res,r

