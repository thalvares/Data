version 11
clear all
macro drop _all
set linesize 80

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

/*	
	Master do-file
*/

// Edit 01: 
//	Date:

do "STS_KenyaYIF_Participants per group-cohort2_baseline"
do "STS_KenyaYIF_Combined Demography-cohort2_baseline"
do "STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline_0Ma_110422"
do "STS_KenyaYIF_Combined Life Skills  VERSION A-cohort2_baseline _0Ma_110512"
do "STS_KenyaYIF_Combined Datasets-cohort2_baseline"

// Final check (should not be in the master file)
sort d_name_f

duplicates tag resp_id, gen(resp_id_dup)
tab resp_id_dup
list resp_id if resp_id_dup == 1

list  resp_id d_name_f d_name_l q_name_f q_name_l l_name_f l_name_l r_name_f r_name_l

exit


