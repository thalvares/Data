version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined Life Skills  VERSION  A-cohort2_baseline
log using "${rawname}_2dc", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

/*	
	This do-file replaces typos in the answers for the
	multiple choice questions
*/

// Edit 01: 
//	Date:

display "rawname is $rawname"
use "${rawname}_1prep.dta", clear

quietly summarize l_s_no
display r(N) " in combined Version A and Versio B"

foreach var of varlist l1_emoint-l41_sex_harass {
	replace `var' = "" if `var' == "99 "
	replace `var' = "A" if `var' == "A "
	replace `var' = "B" if `var' == "B "
	replace `var' = "C" if `var' == "C "
	replace `var' = "D" if `var' == "D "
}

foreach var of varlist l1_emoint-l41_sex_harass {
	replace `var' = "" if `var' == " 99"
	replace `var' = "A" if `var' == " A"
	replace `var' = "B" if `var' == " B"
	replace `var' = "C" if `var' == " C"
	replace `var' = "D" if `var' == " D"
}

foreach var of varlist l1_emoint-l41_sex_harass {
	replace `var' = "" if `var' == " 99 "
	replace `var' = "A" if `var' == " A "
	replace `var' = "B" if `var' == " B "
	replace `var' = "C" if `var' == " C "
	replace `var' = "D" if `var' == " D "
}
   
save "${rawname}_2dc.dta", replace

log close
exit

