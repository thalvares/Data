version 11
clear all
macro drop _all
set linesize 120

capture log close
global rawname STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline
global demo STS_KenyaYIF_Combined Demography-cohort2_baseline
log using "${rawname}_5Demo", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	05-09-2011

/*	
*	This do-file merges the ICT and Demographics	
*/

// Edit 01: 	Thomaz Alvares
//	Date:		04-26-2011


***********************
// 1. PROBLEM MATCHING:
***********************
display "rawname is $rawname"
use "${rawname}_4PBis.dta", clear

joinby  resp_id using "${demo}", unmatched(both) _merge(ICTdemo)
tab ICTdemo
label var ICTdemo "Joinby ICT and Demographics"
/* 
All 157 in ICT are in Demo. 
There are 64 in Demo that are not in ICT-cohort2_baseline (Attrition)
*/
drop if ICTdemo == 2

* 1.1 - Looking for Miscoded ID
list	resp_id q_s_no d_s_no q_name_f q_name_m q_name_l d_name_f d_name_m	///
			d_name_l if ICTdemo == 1, string(8) noobs
list	resp_id q_s_no d_s_no q_name_f q_name_m q_name_l d_name_f d_name_m 	///
			d_name_l if ICTdemo == 2, string(8) noobs

* 1.2 - ID Duplicates
duplicates tag resp_id, gen(resp_id_dup)
list	resp_id q_s_no d_s_no q_name_f q_name_m q_name_l d_name_f d_name_m 	///
			d_name_l if resp_id_dup == 1, string(8) noobs
/* ICT:	Duplicate ID
		resp_id = 2-1-070
			When listed the names:
				s_no = 44 "Hilda    Andaye   Satsiro"
					recevied version A of ICT test
				s_no = 63 "hilda   satsiro    andaye"
					received version B of ICT test
			Most likely, one is: 
				d_s_no = 114 "Blanyce     Amahwa    Khavere"
				resp_id =  1-1-022
			Will need to check the paper trail */

**********
// 4. END:
**********
drop resp_id_dup
save "${rawname}_5Demo.dta", replace

log close
exit
