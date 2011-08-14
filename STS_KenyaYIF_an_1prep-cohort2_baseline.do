version 11
clear all
macro drop _all
label drop _all
set linesize 80

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:		05-16-2011

/*	
*	This do-file runs reshapes the data in long
		form
*/

// Edit 01: 	
//		Date:		
/*	
*/

capture log close
global rawname STS_KenyaYIF_Combined Datasets-cohort2_baseline
global source STS_KenyaYIF_Combined Datasets-cohort2_baseline
log using "${rawname}_long", replace text


// 1. Data Source and Prep
use "${source}_wide.dta", clear

duplicates tag resp_id, gen(dup)
duplicates list
duplicates drop resp_id, force
drop dup

rename d_date date1
rename q_date date2
rename l_date date3
rename r_date date4

rename d_name_f name_f1
rename q_name_f name_f2
rename l_name_f name_f3
rename r_name_f name_f4

rename d_name_m name_m1
rename q_name_m name_m2
rename l_name_m name_m3
rename r_name_m name_m4

rename d_name_l name_l1
rename q_name_l name_l2
rename l_name_l name_l3
rename r_name_l name_l4

rename d_dataset dataset1
rename q_dataset dataset2
rename l_dataset dataset3
rename r_dataset dataset4

clonevar S_q_resp_t_V2 = S_q_resp_total 
clonevar S_l_resp_t_V2 = S_l_resp_total 

rename S_q_resp_total S_resp_total2
rename S_l_resp_total S_resp_total3

clonevar S_q_resp_z_V2 = S_q_resp_zscore
clonevar S_l_resp_z_V2 = S_l_resp_zscore

rename S_q_resp_zscore S_resp_zscore2
rename S_l_resp_zscore S_resp_zscore3

drop 	d_s_no			ICTdemo_V2			q_s_no		q1_start-S_q45_outlookdraft ///
		S_q_resp_mean 	S_q_resp_missing 	q_s_no_V2 	q_item_notmiss 				///
		ICTdemo 		LSdemo_V2 			l_s_no 		l1_emoint-S_l41_sex_harass 	///
		S_l_resp_mean 	S_l_resp_missing 	l_s_no_V2 	l_item_notmiss 		LSdemo

		
// 2. Reshape
tostring name_m4 name_l4, replace
reshape long date name_f name_m name_l dataset S_resp_total S_resp_zscore			///
	, i(resp_id) j(datasource)

label var date "Date"
label var name_f "First Name"
label var name_m "Middle Name"
label var name_l "Last Name"
label var S_resp_total "Number of Correct Answers"
label var S_resp_zscore "Z-score"
label var dataset "Data Source (original)"
label def dsetv2 1 "Demographics" 2 "ICT" 3 "Life Skills" 4 "Treat Group"
label val dataset dsetv2
label var datasource "Data Source (from Reshaping)"
label def dsource 1 "Demographics" 2 "ICT" 3 "Life Skills" 4 "Participant Group"
label val datasource dsource

// 3. Check Data Sets
checkvar dataset datasource
/*	Missing obs shows that the var existed in one dataset but not
		in the other	*/
save "${rawname}_long.dta", replace

log close
exit


