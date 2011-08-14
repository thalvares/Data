version 11
clear all
macro drop _all
set linesize 120

capture log close
global rawname STS_KenyaYIF_Combined Life Skills  VERSION  A-cohort2_baseline
global demo STS_KenyaYIF_Combined Demography-cohort2_baseline
log using "${rawname}_5Demo", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

/*	
*	This do-file merges the ICT and Demographics	
*/

// Edit 01:
//	Date:
/*	
*/


***********************
// 1. PROBLEM MATCHING:
***********************
display "rawname is $rawname"
use "${rawname}_4PBis.dta", clear

joinby  resp_id using "${demo}", unmatched(both) _merge(LSdemo)
tab LSdemo
label var LSdemo "Joinby Life Skills and Demographics"

drop if LSdemo == 2
list resp_id if LSdemo == 1
list resp_id if LSdemo == 3
sort resp_id
list resp_id

* 1.1 - Looking for Miscoded ID
list	resp_id l_s_no d_s_no l_name_f l_name_m l_name_l d_name_f d_name_m 	///
			d_name_l if LSdemo == 2, string(8) noobs

* 1.2 - ID Duplicates
duplicates tag resp_id, gen(resp_id_dup)
list	resp_id l_s_no d_s_no l_name_f l_name_m l_name_l d_name_f d_name_m 	///
			d_name_l if resp_id_dup == 1, string(8) noobs
/* 
*/

**********
// 4. END:
**********
drop resp_id_dup
save "${rawname}_5Demo.dta", replace

log close
exit
