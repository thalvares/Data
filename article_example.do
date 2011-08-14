cap drop _all
clear mata
set mem 100m

sjlog using list_des1, replace
use cd4
describe
list in 1/32, ab(10) noobs sepby(study_id patient_id)
sjlog close, replace

sjlog using list_des2, replace
use surv
describe
list in 1/3, ab(15) noobs sep(0)
label list agesero
label list expo
sjlog close, replace

sjlog using list_des3, replace
datajoint1 using cd4, dfile(surv) markervalue(sqrt_cd4) markertime(time) ///
id(study_id patient_id) dropevent(AD) droptime(ADtime) ///
 covariates(agesero expo) saving(jointdata) clear replace
sjlog close, replace

sjlog using list_des4, replace
list patient_id _M _D _JY _Mtime _Magesero /// 
_Dagesero in 1/35, ab(10) noobs sepby(study_id patient_id)
sjlog close, replace

sjlog using list_des5, replace
xi: jmre1 _JY _M i._Magesero*_Mtime i._Mexpo*_Mtime, ///
 remark(_M _Mtime) dropout(AD _D i._Dagesero i._Dexpo) ///
 timevar(_Mtime) id(study_id patient_id) restr
sjlog close, replace

sjlog using list_des6, replace
matrix list e(corr_re)
sjlog close, replace

sjlog using list_des7, replace
estimates store FullModel
sjlog close, replace

estimates save FullModel

sjlog using list_des8, replace
xi: jmre1 _JY _M i._Magesero*_Mtime i._Mexpo*_Mtime, ///
 remark(_M _Mtime) dropout(AD _D i._Dagesero ///
 i._Dexpo) timevar(_Mtime) id(study_id patient_id) restr ///
 corr0(_D _M _D _Mtime)
sjlog close, replace
estimates store ConstrModel
estimates save ConstrModel

estimates restore ConstrModel
sjlog using list_des9, replace
estimates store ConstrModel
estimates restore FullModel
local FMll = e(ll)
estimates restore ConstrModel
local CMll = e(ll)
di -2*(`CMll'-`FMll')
di chi2tail(2, -2*(`CMll'-`FMll'))
sjlog close, replace


sjlog using list_des10, replace
xi: jmre1 _JY _M  i._Magesero*_Mtime i._Mexpo*_Mtime, ///
 remark(_M _Mtime) dropout(AD _D i._Dagesero ///
 i._Dexpo) timevar(_Mtime) id(study_id patient_id) restr ///
 mi(5)
sjlog close, replace

estimates use FullModel
estimates store FullModel

estimates use ConstrModel
estimates store ConstrModel

sjlog using list_des11, replace
estimates restore FullModel
predict eb, ref
des eb*
sjlog close, replace

sjlog using list_des12, replace
preserve
by study_id patient_id: keep if _n==1
histogram eb_M, scheme(s2mono)
restore
sjlog close, replace
gr export hist_eb_M.eps,replace

sjlog using list_des13, replace
preserve
by study_id patient_id: keep if _n==1
histogram eb_Mtime, scheme(s2mono)
restore
sjlog close, replace

sjlog using list_des14, replace
predict resid, residuals
histogram resid, scheme(s2mono)
sjlog close, replace


sjlog using list_des15, replace
preserve
drop _I*
replace _Mtime = round(_Mtime, 0.5)
fillin _M _Mexpo _Magesero _Mtime
xi i._Magesero*_Mtime i._Mexpo*_Mtime
estimates restore FullModel
predict fe_fitted_full, xb
replace fe_fitted_full = fe_fitted_full^2
label var fe_fitted_full "Full model"
estimates restore ConstrModel
predict fe_fitted_constr, xb
replace fe_fitted_constr = fe_fitted_constr^2
label var fe_fitted_constr "Constrained model"
sort _Mexpo _Magesero _Mtime
scatter fe_fitted_full _Mtime if _Mexpo==2 & _M, msymbol(i) connect(l) lpattern(solid) lcolor(gs0)|| scatter fe_fitted_constr _Mtime if _Mexpo==2 & _M, msymbol(i) connect(l) lpattern(solid) lcolor(gs10) by(_Magesero) ytitle("Predicted CD4 cell count" "(cells/microL)") xtitle("Years since Seroconversion") ylabel(0(100)600, angle(hori)) scheme(s2mono)
restore
sjlog close, replace
gr export fitted.eps,replace

