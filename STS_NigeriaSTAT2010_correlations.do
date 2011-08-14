
//	1. SCHOOL
use "STS_NigeriaSTAT2010_sch_names_official.dta", clear
drop if sch_s_no >= 157
drop if sch_schoolname_d3 == "Imam Malik Islamiyya"
drop if sch_schoolname_d3 == "Modaci Model Primary School"

global avgs sch_schavg_literacy sch_schavg_numeracy sch_schavg_lifeskills

label var sch_controlexperimental_d10 "Treatment Group"
label def treat 1 "Treatment" 0 "Control"
label val sch_controlexperimental_d10 treat

global tabs 	STS_NigeriaSTAT2010_Correlation_tabs

* School Treatment
tab sch_controlexperimental_d10
tabout	sch_controlexperimental_d10 using "${tabs}.txt", 	///
			c(freq col) f(0 1) clab(No. Col_%)				///
			replace
			
foreach var of varlist $avgs {
	display "***************"
	tabstat	`var', statistics(n mean semean) col(statistics) by(sch_controlexperimental_d10)
}
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' sch_controlexperimental_d10, sig star(.05)
}
foreach var of varlist $avgs {
	display "**********************************************************************"
	ttest `var', by(sch_controlexperimental_d10)
}

* School Type
tab sch_schooltype
tab sch_controlexperimental_d10 sch_schooltype, row chi
tabout	sch_schooltype sch_controlexperimental_d10 using "${tabs}.txt",	///
			c(freq col) f(0 1) clab(No. Col_%)							///
			append
strrec sch_schooltype ("Public" = 1 "Public")("Public/Islamiyya" = 2 "Public/Islamiyya"), sub gen(R_sch_schooltype)
foreach var of varlist $avgs {
	display "***************"
	tabstat	`var', statistics(n mean semean) col(statistics) by(sch_schooltype)
}
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' R_sch_schooltype, sig star(.05) 
}
foreach var of varlist $avgs {
	display "**********************************************************************"
	ttest `var', by(sch_schooltype)
}

* School Location
tab sch_location
tab sch_controlexperimental_d10 sch_location, row chi
tabout	sch_location sch_controlexperimental_d10 using "${tabs}.txt",	///
			c(freq col) f(0 1) clab(No. Col_%)							///
			append
strrec sch_location ("RURAL" = 1 "RURAL")("SEMI-URBAN" = 2 "SEMI-URBAN") ("URBAN" = 3 "URBAN"), sub gen(R_sch_location)
foreach var of varlist $avgs {
	display "***************"
	tabstat	`var', statistics(n mean semean) col(statistics) by(sch_location)
}
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' R_sch_location, sig star(.05) 
}
foreach var of varlist $avgs {
	display "**********************************************************************"
	anova `var'
}
foreach var of varlist $avgs {
	oneway `var' R_sch_location, bonferroni
}


//	2. HEADTEACHER
use "STS_NigeriaSTAT2010_Head Teacher Questionnaire_mathching25May_official.dta", clear
global avgs sch_schavg_literacy sch_schavg_numeracy sch_schavg_lifeskills


** / CLEANING

// Fix numeric vars that due to bad DE were coded as non-numeric data 
* cnumberpupilstotal
replace cnumberpupilstotal = "1158" if cnumberpupilstotal == "1,158" 
replace cnumberpupilstotal = "1163" if cnumberpupilstotal == "1,163"
replace cnumberpupilstotal = "1246" if cnumberpupilstotal == "1,246"
* _p3numberofgroups
replace _p3numberofgroups = ""  if  _p3numberofgroups == "A & B"
* _p4numberofgroups
replace _p4numberofgroups = ""  if  _p4numberofgroups == "A & B"
* _p6numberofblocks
replace _p6numberofgroups = ""  if  _p6numberofgroups == "A & B"
* _p1numberofblocks
replace _p1numberofblocks = "0" if  _p1numberofblocks == "-"
replace _p1numberofblocks = ""  if  _p1numberofblocks == "1B"
* _p1numberofblocks
replace _p2numberofblocks = ""  if  _p2numberofblocks == "1B"
* _p3numberofblocks
replace _p3numberofblocks = ""  if  _p3numberofblocks == "1B"
* _p4numberofblocks
replace _p4numberofblocks = ""  if  _p4numberofblocks == "1B"
* _p5numberofblocks
replace _p5numberofblocks = ""  if  _p5numberofblocks == "1B"
* _p6numberofblocks
replace _p6numberofblocks = ""  if  _p6numberofblocks == "1B"
* v28
replace v28 = ""  if  v28 == "(-)"
replace v28 = ""   if  v28 == "yes"

* turn vars into numeric
destring 	cnumberpupilstotal	_p3numberofgroups	_p4numberofgroups	/// 
			_p6numberofgroups 	_p1numberofblocks 	_p2numberofblocks	/// 
			_p3numberofblocks 	_p4numberofblocks 	_p5numberofblocks 	///
			_p6numberofblocks 	v28, replace

// code missing valus
mvdecode namedataentryspecialist dateofinterview-othercomments, mv(99  = .a)
mvdecode namedataentryspecialist dateofinterview-othercomments, mv(999 = .b)

// duplicates 
duplicates drop sch_schoolname, force
drop if school == "Sardauna Primary School Isa" 

// logic checks
replace schoolhasalibrary1yes2no = 1 if v28 == 33
replace schoolhasalibrary1yes2no = 1 if v29 == 56

** / CORRELATIONS

* Funds from SUBEB or LGEA
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' fundsfromsubeborlgea1yes2no, sig star(.05) 
}

* Inspectors from SUBEB or LGEA visit
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howoftenvisitfromsubeborlgeainsp, sig star(.05) 
}
 
* CPD from SUBEB or LGEA
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howoftensubeborlgeaprovidecpd1ne, sig star(.05) 
}

* PTA
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' schoolhasapta1yes2no, sig star(.05) 
}

 * SMC
 foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' schoolhasaschoolbasedmanagementc, sig star(.05) 
}
table schoolhasaschoolbasedmanagementc, ///
	contents(count sch_schavg_literacy mean sch_schavg_literacy semean sch_schavg_literacy )
table schoolhasaschoolbasedmanagementc, ///
	contents(count sch_schavg_literacy mean sch_schavg_numeracy semean sch_schavg_numeracy )
table schoolhasaschoolbasedmanagementc, ///
	contents(count sch_schavg_literacy mean sch_schavg_lifeskills semean sch_schavg_lifeskills )
foreach var of varlist sch_schavg_literacy sch_schavg_numeracy sch_schavg_lifeskills {
	ttest `var', by(schoolhasaschoolbasedmanagementc)
}
a
 * Lib
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' schoolhasalibrary1yes2no, sig star(.05) 
}

* Books
foreach book of varlist v28 v29 v30 {
	foreach score of varlist $avgs {
		display "**********************************************************************"
		pwcorr `score' `book', sig star(.05)
		}
}

* Perception Reading
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howrankreadingskills1verystrong2, sig star(.05) 
}
 
* Perception Math
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howrankmathsskills1verystrong2st, sig star(.05) 
}

 * Gender
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' sexofheadteachermaster1male2fema, sig star(.05) 
}

 * Degree
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' highestqualification1juniorislam, sig star(.05) 
}
foreach var of varlist $avgs {
	oneway `var' highestqualification1juniorislam, bonferroni
}

 * Experience
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howlongasaheadmaster1lessthan1ye, sig star(.05) 
}

// 3. TEACHER
use "STS_NigeriaSTAT2010_TEACHER_NEI_STAT_2010_May19_2011_official.dta", clear
global avgs sch_schavg_literacy sch_schavg_numeracy sch_schavg_lifeskills

** / Cleaning

* Fix numeric var that due to bad DE were coded as non-numeric data 
replace howrankmathsskills1verystrong2st = "" 	///
	if howrankmathsskills1verystrong2st == "Lack of effectuive learning materials"
* turn vars into numeric
destring howrankmathsskills1verystrong2st, replace

** / Correlations

* Gender
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' sexofteacher1male2female, sig star(.05) 
}

* Experience
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howlongasp4teacher1lessthan1year, sig star(.05) 
}

* Degree
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' highestqualification1juniorislam, sig star(.05) 
}

* Training Reading
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' receivetrainingreading1yes2no, sig star(.05) 
}

* Training Math
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' receivetrainingmaths1yes2no, sig star(.05) 
}

* Training Life Skills
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' receivetraininglifeskills1yes2no, sig star(.05) 
}

* Rank Reading
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howrankreadingskills1verystrong2, sig star(.05) 
}

* Rank Math
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' howrankmathsskills1verystrong2st, sig star(.05) 
}

* Class Size
bysort sch_schoolname cnumberpupilstotal: gen classID = _n
foreach var of varlist $avgs {
	display "**********************************************************************"
	pwcorr `var' cnumberpupilstotal if classID == 1, sig star(.05) 
}
