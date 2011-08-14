version 11
clear all
macro drop _all
set linesize 160

capture log close
global rawname STS_KenyaYIF_Combined Datasets-cohort2_baseline
global demo STS_KenyaYIF_Combined Demography-cohort2_baseline
global ICT STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline
global LS STS_KenyaYIF_Combined Life Skills  VERSION  A-cohort2_baseline
global PG STS_KenyaYIF_Participants per group-cohort2_baseline

log using "${rawname}_wide", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	05-13-2011

/*	
*	This do-file merges the ICT, Demographics
	and Life Skills Datasets
*/

// Edit 01:
//	Date:
/*	
*/


****************
// 1. COMBINING:
****************
display "rawname is $rawname"
display "demo is $demo"
display "ICT is $ICT"
display "LS is $LS"
display "PG is $PG"

use "${demo}.dta", clear

joinby resp_id using "${ICT}_5Demo", unmatch(both) _merge(ICTdemo_V2)
tab ICTdemo_V2

joinby resp_id using "${LS}_5Demo", unmatch(both) _merge(LSdemo_V2)
tab LSdemo_V2

joinby resp_id using "${PG}", unmatch(both) _merge(PGdemo_V2)
tab PGdemo_V2

***********************
//	2. PROBLEM MATCHING:
***********************
//		2.1 - Looking for Miscoded ID
* 			2.1.1 - ICT
list	resp_id		d_s_no	d_name_f	d_name_l	///
					q_s_no	q_name_f	q_name_l	///
					l_s_no	l_name_f	l_name_l	///
		if ICTdemo_V2 == 1, string(8) noobs
list	resp_id		d_s_no	d_name_f	d_name_l	///
					q_s_no	q_name_f	q_name_l	///
					l_s_no	l_name_f	l_name_l	///
		if ICTdemo_V2 == 2, string(8) noobs

*			2.1.2 - Life Skills
list	resp_id		d_s_no	d_name_f	d_name_l	///
					q_s_no	q_name_f	q_name_l	///
					l_s_no	l_name_f	l_name_l	///
		if LSdemo_V2 == 1, string(8) noobs
list	resp_id		d_s_no	d_name_f	d_name_l	///
					q_s_no	q_name_f	q_name_l	///
					l_s_no	l_name_f	l_name_l	///
		if LSdemo_V2 == 2, string(8) noobs		

*			2.1.2 - Life Skills
list	resp_id		d_s_no	d_name_f	d_name_l	///
					q_s_no	q_name_f	q_name_l	///
					l_s_no	l_name_f	l_name_l	///
					r_s_no	r_name_f	r_name_l	///
		if PGdemo_V2 == 1, string(8) noobs
list	resp_id		d_s_no	d_name_f	d_name_l	///
					q_s_no	q_name_f	q_name_l	///
					r_s_no	r_name_f	r_name_l	///
		if PGdemo_V2 == 2, string(8) noobs		
		
//		2.2 - ID Duplicates
duplicates tag resp_id, gen(resp_id_dup)
tab resp_id_dup
list	resp_id		d_s_no	d_name_f	d_name_l	///
					q_s_no	q_name_f	q_name_l	///
					l_s_no	l_name_f	l_name_l	///
					r_s_no	r_name_f	r_name_l	///
		if resp_id_dup > 0, string(8) noobs		


**********
// 4. END:
**********
drop resp_id_dup
label var ICTdemo_V2 "Joinby Demographics and ICT"
label var LSdemo_V2 "Joinby Demographics and Life Skills"
label var PGdemo_V2 "Joinby Demographics and Participant Group"
save "${rawname}_wide.dta", replace

log close
exit
