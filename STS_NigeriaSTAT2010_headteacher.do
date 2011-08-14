version 11
clear all
macro drop _all
set linesize 120

capture log close

//	Project:	STS_NigeriaSTAT_2010
//	Author:		Thomaz Alvares
// 		Date:	07-14-2011
/*	
	This do-file tabs data from the headteacher data set
*/


log using "STS_NigeriaSTAT2010_Headteacher.txt" , replace text

use "STS_NigeriaSTAT2010_Head Teacher Questionnaire_mathching25May_official.dta"

foreach	var of varlist											///
	cnumberpupilstotal	_p3numberofgroups	_p4numberofgroups	/// 
	_p6numberofgroups 	_p1numberofblocks 	_p2numberofblocks	/// 
	_p3numberofblocks 	_p4numberofblocks 	_p5numberofblocks 	///
	_p6numberofblocks 	v28										{
	tab `var'
}		

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
tab sch_schoolname
list sch_schoolname school highestqualification1juniorislam							///
		if	sch_schoolname == "Ahmad Rufai Nurul Islam" | 							/// 
			sch_schoolname == 														///
				"Ahmadu Rufai Model Pri. Sch.(STAT)- Model Primary School, Silame"

duplicates report sch_schoolname
duplicates drop sch_schoolname, force
tab school if school == "Sardauna Primary School Isa"
* Note: pilot school; long ago was informed that it wouldn't be included in the final data
drop if school == "Sardauna Primary School Isa" 

// logic checks
foreach var of varlist v28 v29 v30 {
	tab `var' schoolhasalibrary1yes2no, miss
}
* Note: One school w/o lib had 33 Literacy books
* Note: One school w/o lib had 56 numeracy books
replace schoolhasalibrary1yes2no = 1 if v28 == 33
replace schoolhasalibrary1yes2no = 1 if v29 == 56
foreach var of varlist v28 v29 v30 {
	tab `var' schoolhasalibrary1yes2no 
}
tab schoolhasalibrary1yes2no

// Analysis
global tabs 	STS_NigeriaSTAT2010_Headteacher_tabs

label var sch_controlexperimental_d10 "Treatment Group"
label def treat 0 "Control" 1 "Treatment"
label val sch_controlexperimental_d10 treat

/* In q 8, a total of 97 schools say they have SMC but in q8.1, a total of 100 schools answered the q*/
replace schoolhasaschoolbasedmanagementc = 1 if v32 >= 1 & v32 <= 3

tabout	sch_controlexperimental_d10 		using "${tabs}.txt", replace

foreach var of varlist																									///
	sexofheadteachermaster1male2fema		highestqualification1juniorislam		howlongasaheadmaster1lessthan1ye	///
	schoolhasalibrary1yes2no 				schoolhasaschoolbasedmanagementc 		v32 								///
	fundsfromsubeborlgea1yes2no				howoftenvisitfromsubeborlgeainsp 		howoftensubeborlgeaprovidecpd1ne 	///
	schoolhasapta1yes2no					v37 howrankreadingskills1verystrong2 	howrankmathsskills1verystrong2st	{
		tab 	`var' sch_controlexperimental_d10,	col miss
		tabout	`var' sch_controlexperimental_d10 	using "${tabs}.txt",			///
			c(freq col) f(0 1) clab(No. Col_%)	stats(chi2)							///
			append
}

foreach var of varlist																									///
	anumberteachersmen						bnumberteacherswomen 					cnumberteacherstotal 				///
	anumberpupilsboys 						bnumberpupilsgirls 						cnumberpupilstotal 					///
	_p1numberofgroups 						_p2numberofgroups 						_p3numberofgroups 					///
	_p4numberofgroups 						_p5numberofgroups 						_p6numberofgroups 					/// 
	_p1numberofblocks 						_p2numberofblocks 						_p3numberofblocks  					///
	_p4numberofblocks 						_p5numberofblocks 						_p6numberofblocks  					///
	v28 									v29 									v30									{
		tabstat	`var', statistics(n mean semean) col(statistics) by(sch_controlexperimental_d10)
}

foreach var of varlist																									///
	anumberteachersmen						bnumberteacherswomen 					cnumberteacherstotal 				///
	anumberpupilsboys 						bnumberpupilsgirls 						cnumberpupilstotal 					///
	_p1numberofgroups 						_p2numberofgroups 						_p3numberofgroups 					///
	_p4numberofgroups 						_p5numberofgroups 						_p6numberofgroups 					/// 
	_p1numberofblocks 						_p2numberofblocks 						_p3numberofblocks  					///
	_p4numberofblocks 						_p5numberofblocks 						_p6numberofblocks  					///
	v28 									v29 									v30									{
		ttest 	`var', by(sch_controlexperimental_d10)
}

* TEACHERS
* 	Total number of teachers
egen totalsum_teacher_m = total(anumberteachersmen)
egen totalsum_teacher_f = total(bnumberteacherswomen)
egen totalsum_teacher_t = total(cnumberteacherstotal)
*	Total number of teachers per treatment group
* 		control
egen totalsum_teacher_m_c = total(anumberteachersmen)	if	sch_controlexperimental_d10 == 0
egen totalsum_teacher_f_c = total(bnumberteacherswomen)	if	sch_controlexperimental_d10 == 0
egen totalsum_teacher_t_c = total(cnumberteacherstotal)	if	sch_controlexperimental_d10 == 0
*		treatment
egen totalsum_teacher_m_t = total(anumberteachersmen)	if	sch_controlexperimental_d10 == 1
egen totalsum_teacher_f_t = total(bnumberteacherswomen)	if	sch_controlexperimental_d10 == 1
egen totalsum_teacher_t_t = total(cnumberteacherstotal)	if	sch_controlexperimental_d10 == 1

codebook totalsum_teacher_m	totalsum_teacher_m_c totalsum_teacher_m_t, compact
codebook totalsum_teacher_f	totalsum_teacher_f_c totalsum_teacher_f_t, compact
codebook totalsum_teacher_t	totalsum_teacher_t_c totalsum_teacher_t_t, compact

* PUPILS
*	Total number of pupils
egen totalsum_pupil_m = total(anumberpupilsboys)
egen totalsum_pupil_f = total(bnumberpupilsgirls)
egen totalsum_pupil_t = total(cnumberpupilstotal)
* 	Total number of pupils per treatment group
* 		control
egen totalsum_pupil_m_c = total(anumberpupilsboys)	if	sch_controlexperimental_d10 == 0
egen totalsum_pupil_f_c = total(bnumberpupilsgirls)	if	sch_controlexperimental_d10 == 0
egen totalsum_pupil_t_c = total(cnumberpupilstotal)	if	sch_controlexperimental_d10 == 0
*		treatment
egen totalsum_pupil_m_t = total(anumberpupilsboys)	if	sch_controlexperimental_d10 == 1
egen totalsum_pupil_f_t = total(bnumberpupilsgirls)	if	sch_controlexperimental_d10 == 1
egen totalsum_pupil_t_t = total(cnumberpupilstotal)	if	sch_controlexperimental_d10 == 1

codebook totalsum_pupil_m	totalsum_pupil_m_c totalsum_pupil_m_t, compact
codebook totalsum_pupil_f	totalsum_pupil_f_c totalsum_pupil_f_t, compact
codebook totalsum_pupil_t	totalsum_pupil_t_c totalsum_pupil_t_t, compact

* GROUPS
foreach var of varlist 										///
	_p1numberofgroups _p2numberofgroups _p3numberofgroups 	///
	_p4numberofgroups _p5numberofgroups _p6numberofgroups	{
		egen totalsum`var'_c		= total(`var') if sch_controlexperimental_d10 == 0
		egen totalsum`var'_t		= total(`var') if sch_controlexperimental_d10 == 1
		egen totalsum`var'_total	= total(`var')
}

foreach var of varlist 										///
	_p1numberofgroups _p2numberofgroups _p3numberofgroups 	///
	_p4numberofgroups _p5numberofgroups _p6numberofgroups	{
		codebook totalsum`var'_c	totalsum`var'_t totalsum`var'_total, compact
}

* BLOCKS
foreach var of varlist 										///
	_p1numberofblocks _p2numberofblocks _p3numberofblocks	/// 
	_p4numberofblocks _p5numberofblocks _p6numberofblocks	{
		egen totalsum`var'_c		= total(`var') if sch_controlexperimental_d10 == 0
		egen totalsum`var'_t		= total(`var') if sch_controlexperimental_d10 == 1
		egen totalsum`var'_total	= total(`var')
}

foreach var of varlist 										///
	_p1numberofblocks _p2numberofblocks _p3numberofblocks	/// 
	_p4numberofblocks _p5numberofblocks _p6numberofblocks	{
		codebook totalsum`var'_c	totalsum`var'_t totalsum`var'_total, compact
}

* BOOKS
foreach var of varlist 										///
	v28 v29 v30												{
		egen totalsum`var'_c		= total(`var') if sch_controlexperimental_d10 == 0
		egen totalsum`var'_t		= total(`var') if sch_controlexperimental_d10 == 1
		egen totalsum`var'_total	= total(`var')
}

foreach var of varlist 										///
	v28 v29 v30												{
		codebook totalsum`var'_c	totalsum`var'_t totalsum`var'_total, compact
}

table /*sch_controlexperimental_d10*/ highestqualification1juniorislam, ///
	contents(count sch_schavg_literacy mean sch_schavg_literacy semean sch_schavg_literacy )
table /*sch_controlexperimental_d10*/ highestqualification1juniorislam, ///
	contents(count sch_schavg_numeracy mean sch_schavg_numeracy semean sch_schavg_numeracy )
table /*sch_controlexperimental_d10*/ highestqualification1juniorislam, ///
	contents(count sch_schavg_lifeskills mean sch_schavg_lifeskills semean sch_schavg_lifeskills )
foreach var of varlist  sch_schavg_literacy sch_schavg_numeracy sch_schavg_lifeskills {
	oneway `var' highestqualification1juniorislam, bonferroni tabulate
}
