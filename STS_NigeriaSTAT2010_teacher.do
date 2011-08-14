version 11
clear all
macro drop _all
set linesize 120

capture log close

//	Project:	STS_NigeriaSTAT_2010
//	Author:		Thomaz Alvares
// 		Date:	07-19-2011
/*	
	This do-file tabs data from the teacher data set
*/


log using "STS_NigeriaSTAT2010_Teacher.txt" , replace text

use "STS_NigeriaSTAT2010_TEACHER_NEI_STAT_2010_May19_2011_official.dta"


// Fix numeric var that due to bad DE were coded as non-numeric data 
tab howrankmathsskills1verystrong2st
* howrankmathsskills1verystrong2st
replace howrankmathsskills1verystrong2st = "" 	///
	if howrankmathsskills1verystrong2st == "Lack of effectuive learning materials"
tab howrankmathsskills1verystrong2st

* turn vars into numeric
destring howrankmathsskills1verystrong2st, replace

// code missing valus
/* 
Diff than the Headteacher data, in this data set the missing values were left
blank instead of being coded 99 or 999

mvdecode 	namedataentryspecialist nameofadministratorconductingint		///
			sexofteacher1male2female-ifnotmaterialsgetsomewhere1yes2n  		///
			receivetrainingreading1yes2no-howrankreadingskills1verystrong2	///
			howrankmathsskills1verystrong2st 								///
			visitfromsubeborlgeainspector1ye 								///
			ifyeshowmanytimes1once2twice3mor								///
			, mv(99  = .a)
mvdecode 	namedataentryspecialist nameofadministratorconductingint		///
			sexofteacher1male2female-ifnotmaterialsgetsomewhere1yes2n  		///
			receivetrainingreading1yes2no-howrankreadingskills1verystrong2	///
			howrankmathsskills1verystrong2st 								///
			visitfromsubeborlgeainspector1ye 								///
			ifyeshowmanytimes1once2twice3mor								///
			, mv(999  = .b)
*/

// duplicates 
tab sch_schoolname
*	Duplicates in Terms of all vars
duplicates drop
*1.	Schools with multiple teachers
duplicates report sch_schoolname, table
*1.1. Tag
duplicates tag sch_schoolname, gen(dup_schoolname)
checkvar sch_schoolname dup_schoolname if dup_schoolname > 0
*2. Classrooms with multiple teachers
duplicates report sch_schoolname anumberpupilsboys bnumberpupilsgirls cnumberpupilstotal, table
*2.1. Tag
duplicates tag sch_schoolname anumberpupilsboys bnumberpupilsgirls cnumberpupilstotal, gen (dup_class)
*3. Summarize
duplicates list sch_uniqid sch_schoolname anumberpupilsboys						/// 
				bnumberpupilsgirls cnumberpupilstotal 							///
					if dup_schoolname > 0 & dup_class > 0,						/// 
					compress sepby(sch_schoolname)
*4. Identify cases of same class within the school
bysort sch_schoolname cnumberpupilstotal: gen classID = _n
list classID dup_class dup_schoolname sch_schoolname

// logic checks
/*
q8 is a bit ambiguous. 
	The way it was recorded was that if the resp't did not have
		acess to at least one of the materials, could s/he obtain it somewhere.
	In case we would like to know if the resp't did not have access to none of the
		materials, then we would use the following syntax:
replace ifnotmaterialsgetsomewhere1yes2n = 0 if v17 == 1 | v18 == 1 | v19 == 1 | ///
												v20 == 1 | v21 == 1 | v22 == 1 | ///
												v23	== 1 | v24 == 1 | v25 == 1
*/
*q8  and q8.1 --> if yes only
/* string */
*q9  and 9.1,  9.2,  9.3  --> if yes only
replace receivetrainingreading1yes2no	 = 1 if v29 == 1 | v30 == 1 | v31 == 1
*q10 and 10.1, 10.2, 10.3 --> if yes only
replace receivetrainingmaths1yes2no		 = 1 if v33 == 1 | v34 == 1 | v35 == 1
*q10 and 10.1, 10.2, 10.3 --> if yes only
replace receivetraininglifeskills1yes2no = 1 if v37 == 1 | v38 == 1 | v39 == 1
*q16 and q17 --> if yes only
replace visitfromsubeborlgeainspector1ye = 1 if ifyeshowmanytimes1once2twice3mor != .



// value cleaning
replace howlongasp4teacher1lessthan1year = . if howlongasp4teacher1lessthan1year == 6

// Analysis
global tabs 	STS_NigeriaSTAT2010_Teacher_tabs

label var sch_controlexperimental_d10 "Treatment Group"
label def treat 0 "Control" 1 "Treatment"
label val sch_controlexperimental_d10 treat

tabout	sch_controlexperimental_d10 		using "${tabs}.txt", replace

foreach var of varlist																							///
	sexofteacher1male2female			howlongasp4teacher1lessthan1year	highestqualification1juniorislam 	///
	accessalibrary1never2oncemonth3o	v14	v15	v16	v17	v18	v19	v20			v21	v22	v23	v24	v25 				///
	ifnotmaterialsgetsomewhere1yes2n 	receivetrainingreading1yes2no		v29	v30	v31 						///
	receivetrainingmaths1yes2no 		v33	v34	v35							receivetraininglifeskills1yes2no 	///
	v37	v38	v39							howrankreadingskills1verystrong2 	howrankmathsskills1verystrong2st 	///
	visitfromsubeborlgeainspector1ye 	ifyeshowmanytimes1once2twice3mor										{
		tab 	`var' sch_controlexperimental_d10,	col miss
		tabout	`var' sch_controlexperimental_d10 	using "${tabs}.txt",			///
			c(freq col) f(0 1) clab(No. Col_%)	stats(chi2)							///
			append
}

foreach var of varlist												///
	 anumberpupilsboys bnumberpupilsgirls cnumberpupilstotal		{
		tabstat	`var' if classID == 1, statistics(n mean semean)	///
		col(statistics) by(sch_controlexperimental_d10)
}

foreach var of varlist														///
	 anumberpupilsboys bnumberpupilsgirls cnumberpupilstotal				{
		ttest 	`var' if classID == 1, by(sch_controlexperimental_d10)
}

* PUPILS
foreach var of varlist 										///
	anumberpupilsboys bnumberpupilsgirls cnumberpupilstotal	{
		egen totalsum`var'_c		= total(`var') if sch_controlexperimental_d10 == 0 & classID == 1
		egen totalsum`var'_t		= total(`var') if sch_controlexperimental_d10 == 1 & classID == 1
		egen totalsum`var'_total	= total(`var') if classID == 1
}

foreach var of varlist 										///
	anumberpupilsboys bnumberpupilsgirls cnumberpupilstotal	{
		codebook totalsum`var'_c	totalsum`var'_t totalsum`var'_total, compact
}

* Number of classes
bysort sch_controlexperimental_d10: tab sch_schoolname if classID == 1, miss
* Number of teachers
bysort sch_controlexperimental_d10: tab sch_schoolname if totalsumanumberpupilsboys_c != .

table /*sch_controlexperimental_d10*/ highestqualification1juniorislam, ///
	contents(count sch_schavg_literacy mean sch_schavg_literacy semean sch_schavg_literacy )
table /*sch_controlexperimental_d10*/ highestqualification1juniorislam, ///
	contents(count sch_schavg_numeracy mean sch_schavg_numeracy semean sch_schavg_numeracy )
table /*sch_controlexperimental_d10*/ highestqualification1juniorislam, ///
	contents(count sch_schavg_lifeskills mean sch_schavg_lifeskills semean sch_schavg_lifeskills )
foreach var of varlist  sch_schavg_literacy sch_schavg_numeracy sch_schavg_lifeskills {
	oneway `var' highestqualification1juniorislam, bonferroni tabulate
}

