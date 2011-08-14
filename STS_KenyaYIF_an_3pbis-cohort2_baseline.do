version 11
clear all
macro drop _all
label drop _all
set linesize 80

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:		07-25-2011

/*	
*	This do-file runs the analysis included in the mid-line
	report with exception of pbis correlations, alpha and KR20
*/

// Edit 01: 	
//		Date:		
/*	
*/

capture log close
global rawname STS_KenyaYIF_Psychometricts
log using "${rawname}", replace text

// Psychometrics-cohort2_baseline
global source	STS_KenyaYIF_Combined Datasets-cohort2_baseline
use "${source}_wide.dta", clear

***************************************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////////////
// OVERALL (TREATMENT + CONTROL)
///////////////////////////////////////////////////////////////////////////////////////////////////
***************************************************************************************************
// Respondents that did not answer all items
* ICT
tab q_item_notmiss, miss
* Life Skills
tab l_item_notmiss, miss

preserve


// ICT
************
// 1. INTRO:
************
foreach var of varlist S_l1_emoint-S_l41_sex_harass {
	clonevar `var'_ab = `var'
}

local Bvars_ICT 																					///
	S_q1_start 				S_q2_folder			S_q3_paste				S_q4_write				///			
	S_q5_time 				S_q6_highlight 		S_q7_docnew				S_q8_docdel				///
	S_q9_keyboard			S_q10_mem 			S_q11_hd 				S_q12_wireless 			///
	S_q13_speaker 			S_q14_sata 			S_q15_scanner 			S_q16_laptop 			///
	S_q17_monitor 			S_q18_flashdrive 	S_q19_printer 			S_q20_system 			///
	S_q21_notinterchange 	S_q22_email 		S_q23_cdclean 			S_q24_ladder 			///
	S_q25_compdust 			S_q26_compclean 	S_q27_compscrew			S_q28_multiplication 	///
	S_q29_percentage 		S_q30_division 		S_q31_multiplicationadv S_q32_antivirus 		///
	S_q33_dialogbox 		S_q34_rename 		S_q35_wordclose 		S_q36_wordrecent 		///
	S_q37_wordcopy 			S_q38_excelcell 	S_q39_excelrow 			S_q40_excelformula 		///
	S_q41_weburl 			S_q42_webnavigator 	S_q43_websecurity 		S_q44_outlookbanner 	///
	S_q45_outlookdraft

local Bvars_abbrev_ICT																	///
	S_q1	S_q2	S_q3	S_q4	S_q5	S_q6	S_q7	S_q8	S_q9	S_q10	///
	S_q11	S_q12	S_q13	S_q14	S_q15	S_q16	S_q17	S_q18	S_q19	S_q20	///
	S_q21	S_q22	S_q23	S_q24	S_q25	S_q26	S_q27	S_q28	S_q29	S_q30	///
	S_q31	S_q32	S_q33	S_q34	S_q35	S_q36	S_q37	S_q38	S_q39	S_q40	///
	S_q41	S_q42	S_q43	S_q44	S_q45

local rownames_ICT																										///
	Q1:_Start_button						Q2:_File								Q3:_Button_to_paste_text		///			
	Q4:Program_to_write_a_letter			Q5:_Time								Q6:_Highlight_a_word			///
	Q7:_Menu_in_word						Q8:_Delete_a_document					Q9:_Input_device				///			
	Q10:_Modifiable_Computer_Memory			Q11:_Device_for_data_storage			Q12:_Internet_hardware			///		
	Q13:_Output_device						Q14:_SATA_cable							Q15:_Device_shown_scanner		///
	Q16:_Device_shown_laptop				Q17:_Type_of_monitor					Q18:_Data_storage_device		///
	Q19:_Type_of_printer					Q20:_Stores_operating_system											///
	Q21:_Interchangeable_component																					///
	Q22:_Protocol_not_linked_to_email																				///
	Q23:_Clean_CD							Q24:_Aluminum_ladder_location			Q25:_Caring_for_computers		///
	Q26:_Cleaning_solvents																							///
	Q27:_Screwdriver_repercussion																					///
	Q28:_Updgrade_installation				Q29:_Antivirus_failure_rate				Q30:_Upgrade_graphic_cards		///
	Q31:_Internet_cafe_usage				Q32:_Protect_computer_from_virus		Q33:_Dialog_boxes				///
	Q34:_Rename_a_file						Q35:_Close_word_file					Q36:_Open_recent_document		///
	Q37:_Word_processing_copying_a_text		Q38:_Name_box_display					Q39:_Inserting_rows				///
	Q40:_Enter_formula						Q41:_URL								Q42:_Tool_to_search_web			///
	Q43:_Security_zone						Q44:_Folder_banner						Q45:_Save_messages_in_outlook
			
local rownames_aggr_kr20coch_ICT										///
	N_people				N_items				Avg_Difficulty		///
	Avg_CorrectPB_correl	KR20_coefficient	Cronbach_alpha		///
	Cochran_Q				p-value									

************************************
// 2. Point Biserial with ALL items:
************************************
foreach var of varlist S_q1_start-S_q45_outlookdraft {
	quietly pbis `var' S_q_resp_total
}

local nvars : word count `rownames_ICT'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `rownames_ICT'
*matrix list item_an

local irow = 0
foreach var in `Bvars_ICT' {
	local ++irow
	quietly pbis `var' S_q_resp_total	/* if q_item_notmiss == 1 */
	local r_pbis = $S_1
	local correct = $S_4/$S_3
	local samplesize = $S_3
	matrix item_an[`irow',1] = `r_pbis'
	matrix item_an[`irow',2] = `correct'
	matrix item_an[`irow',3] = `samplesize'
}

matrix list item_an, format(%9.2f)

*******************************************
// 3. 	Kuder-Richardson Formula 20, 
*		Cronbach's Alpha,
*		Cochran's Q
*******************************************
kr20 `Bvars_abbrev_ICT'
local N_items	= $S_5
local avg_diff	= $S_3
local avg_PB	= $S_4
local kr20		= $S_6

alpha `Bvars_abbrev_ICT', asis item casewise
local calpha	= "`r(alpha)'"

cochran `Bvars_ICT'
local N_people	= r(N)
local cochran		= r(chi2)
local pvalue		= r(p)

local nvars : word count `rownames_aggr_kr20coch_ICT'
matrix item_an_aggr = J(`nvars',1,.)
*matrix list item_an_aggr
matrix colnames item_an_aggr = Results 
matrix rownames item_an_aggr = `rownames_aggr_kr20coch_ICT'
*matrix list item_an_aggr
matrix item_an_aggr[1,1] = `N_people'
matrix item_an_aggr[2,1] = `N_items'
matrix item_an_aggr[3,1] = `avg_diff'
matrix item_an_aggr[4,1] = `avg_PB'
matrix item_an_aggr[5,1] = `kr20'
matrix item_an_aggr[6,1] = `calpha'
matrix item_an_aggr[7,1] = `cochran'
matrix item_an_aggr[8,1] = `pvalue'
matrix list item_an_aggr, format(%9.2f)


// Life Skills
************
// 1. INTRO:
************
local Bvars_LS																											///
	S_l1_emoint					S_l2_lifeskillmary				S_l3_criticthink			S_l4_humanemo				///
	S_l5_emoeliz				S_l6_lifeskilleliz 				S_l7_sad 					S_l8_anger 					///
	S_l9_listen 				S_l10_motivekaren 				S_l11_motivebio 			S_l12_selfaware 			///
	S_l13_feedback 				S_l14_emobehavior 				S_l15_educgoal 				S_l16_marriagegoal 			///
	S_l17_workworld_forcenot 	S_l18_workworld_force 			S_l19_workplace_deviance	S_l20_hhchorus 				///
	S_l21_probsolving 			S_l22_personalatt 				S_l23_job_ideal 			S_l24_job_searchgood		/// 
	S_l25_job_searchbest 		S_l26_job_searchinfo 			S_l27_job_searchintv 		S_l28_job_searchresume 		///
	S_l29_personalvalues 		S_l30_emocontrol 				S_l31_pregnancy_system 		S_l32_infections_genital 	///
	S_l33_pregnancy_unwanted 	S_l34_pregnancy_contraceptive	S_l35_infections_HIVprotec	S_l36_infections_HIVtrans	/// 
	S_l37_infections_HIVnAIDS 	S_l38_smoking 					S_l39_sex_gnd 				S_l40_sex_harassprotec 		///
	S_l41_sex_harass

local Bvars_abbrev_LS																	///
	S_l1	S_l2	S_l3	S_l4	S_l5	S_l6	S_l7	S_l8	S_l9	S_l10	///
	S_l11	S_l12	S_l13	S_l14	S_l15	S_l16	S_l17	S_l18	S_l19	S_l20	///
	S_l21	S_l22	S_l23	S_l24	S_l25	S_l26	S_l27	S_l28	S_l29	S_l30	///
	S_l31	S_l32	S_l33	S_l34	S_l35	S_l36	S_l37	S_l38	S_l39	S_l40	///
	S_l41

local rownames_aggr_kr20coch_LS										///
	N_people				N_items				Avg_Difficulty		///
	Avg_CorrectPB_correl	KR20_coefficient	Cronbach_alpha		///
	Cochran_Q				p-value									
	
************************************
// 2. Point Biserial with ALL items:
************************************
foreach var of varlist S_l1_emoint-S_l41_sex_harass {
	quietly pbis `var' S_l_resp_total
}

local nvars : word count `Bvars_LS'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `Bvars_LS'
*matrix list item_an

local irow = 0
foreach var in `Bvars_LS' {
	local ++irow
	quietly pbis `var' S_l_resp_total	/* if l_item_notmiss == 1 */
	local r_pbis = $S_1
	local correct = $S_4/$S_3
	local samplesize = $S_3
	matrix item_an[`irow',1] = `r_pbis'
	matrix item_an[`irow',2] = `correct'
	matrix item_an[`irow',3] = `samplesize'
}

matrix list item_an, format(%9.2f)

*******************************************
// 3. 	Kuder-Richardson Formula 20, 
*		Cronbach's Alpha,
*		Cochran's Q
*******************************************
kr20 `Bvars_abbrev_LS'
local N_items	= $S_5
local avg_diff	= $S_3
local avg_PB	= $S_4
local kr20		= $S_6

alpha `Bvars_abbrev_LS', asis item casewise
local calpha	= "`r(alpha)'"

cochran `Bvars_LS'
local N_people	= r(N)
local cochran		= r(chi2)
local pvalue		= r(p)

local nvars : word count `rownames_aggr_kr20coch_LS'
matrix item_an_aggr = J(`nvars',1,.)
*matrix list item_an_aggr
matrix colnames item_an_aggr = Results 
matrix rownames item_an_aggr = `rownames_aggr_kr20coch_LS'
*matrix list item_an_aggr
matrix item_an_aggr[1,1] = `N_people'
matrix item_an_aggr[2,1] = `N_items'
matrix item_an_aggr[3,1] = `avg_diff'
matrix item_an_aggr[4,1] = `avg_PB'
matrix item_an_aggr[5,1] = `kr20'
matrix item_an_aggr[6,1] = `calpha'
matrix item_an_aggr[7,1] = `cochran'
matrix item_an_aggr[8,1] = `pvalue'
matrix list item_an_aggr, format(%9.2f)


***************************************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////////////
// TREATMENT
///////////////////////////////////////////////////////////////////////////////////////////////////
***************************************************************************************************
drop if treatment == 0
tab treatment

// ICT
******************************************
// 2. Point Biserial with TREATMENT items:
******************************************
foreach var of varlist S_q1_start-S_q45_outlookdraft {
	quietly pbis `var' S_q_resp_total
}

local nvars : word count `rownames_ICT'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `rownames_ICT'
*matrix list item_an

local irow = 0
foreach var in `Bvars_ICT' {
	local ++irow
	quietly pbis `var' S_q_resp_total	/* if q_item_notmiss == 1 */
	local r_pbis = $S_1
	local correct = $S_4/$S_3
	local samplesize = $S_3
	matrix item_an[`irow',1] = `r_pbis'
	matrix item_an[`irow',2] = `correct'
	matrix item_an[`irow',3] = `samplesize'
}

matrix list item_an, format(%9.2f)

*******************************************
// 3. 	Kuder-Richardson Formula 20, 
*		Cronbach's Alpha,
*		Cochran's Q
*******************************************
kr20 `Bvars_abbrev_ICT'
local N_items	= $S_5
local avg_diff	= $S_3
local avg_PB	= $S_4
local kr20		= $S_6

alpha `Bvars_abbrev_ICT', asis item casewise
local calpha	= "`r(alpha)'"

cochran `Bvars_ICT'
local N_people	= r(N)
local cochran		= r(chi2)
local pvalue		= r(p)

local nvars : word count `rownames_aggr_kr20coch_ICT'
matrix item_an_aggr = J(`nvars',1,.)
*matrix list item_an_aggr
matrix colnames item_an_aggr = Results 
matrix rownames item_an_aggr = `rownames_aggr_kr20coch_ICT'
*matrix list item_an_aggr
matrix item_an_aggr[1,1] = `N_people'
matrix item_an_aggr[2,1] = `N_items'
matrix item_an_aggr[3,1] = `avg_diff'
matrix item_an_aggr[4,1] = `avg_PB'
matrix item_an_aggr[5,1] = `kr20'
matrix item_an_aggr[6,1] = `calpha'
matrix item_an_aggr[7,1] = `cochran'
matrix item_an_aggr[8,1] = `pvalue'
matrix list item_an_aggr, format(%9.2f)


// Life Skills
******************************************
// 2. Point Biserial with TREATMENT items:
******************************************
foreach var of varlist S_l1_emoint-S_l41_sex_harass {
	quietly pbis `var' S_l_resp_total
}

local nvars : word count `Bvars_LS'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `Bvars_LS'
*matrix list item_an

local irow = 0
foreach var in `Bvars_LS' {
	local ++irow
	quietly pbis `var' S_l_resp_total	/* if l_item_notmiss == 1 */
	local r_pbis = $S_1
	local correct = $S_4/$S_3
	local samplesize = $S_3
	matrix item_an[`irow',1] = `r_pbis'
	matrix item_an[`irow',2] = `correct'
	matrix item_an[`irow',3] = `samplesize'
}

matrix list item_an, format(%9.2f)

*******************************************
// 3. 	Kuder-Richardson Formula 20, 
*		Cronbach's Alpha,
*		Cochran's Q
*******************************************
kr20 `Bvars_abbrev_LS'
local N_items	= $S_5
local avg_diff	= $S_3
local avg_PB	= $S_4
local kr20		= $S_6

alpha `Bvars_abbrev_LS', asis item casewise
local calpha	= "`r(alpha)'"

cochran `Bvars_LS'
local N_people	= r(N)
local cochran		= r(chi2)
local pvalue		= r(p)

local nvars : word count `rownames_aggr_kr20coch_LS'
matrix item_an_aggr = J(`nvars',1,.)
*matrix list item_an_aggr
matrix colnames item_an_aggr = Results 
matrix rownames item_an_aggr = `rownames_aggr_kr20coch_LS'
*matrix list item_an_aggr
matrix item_an_aggr[1,1] = `N_people'
matrix item_an_aggr[2,1] = `N_items'
matrix item_an_aggr[3,1] = `avg_diff'
matrix item_an_aggr[4,1] = `avg_PB'
matrix item_an_aggr[5,1] = `kr20'
matrix item_an_aggr[6,1] = `calpha'
matrix item_an_aggr[7,1] = `cochran'
matrix item_an_aggr[8,1] = `pvalue'
matrix list item_an_aggr, format(%9.2f)

***************************************************************************************************
///////////////////////////////////////////////////////////////////////////////////////////////////
// CONTROL
///////////////////////////////////////////////////////////////////////////////////////////////////
***************************************************************************************************
restore
preserve
drop if treatment == 1
tab treatment

// ICT
****************************************
// 2. Point Biserial with CONTROL items:
****************************************
foreach var of varlist S_q1_start-S_q45_outlookdraft {
	quietly pbis `var' S_q_resp_total
}

local nvars : word count `rownames_ICT'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `rownames_ICT'
*matrix list item_an

local irow = 0
foreach var in `Bvars_ICT' {
	local ++irow
	quietly pbis `var' S_q_resp_total	/* if q_item_notmiss == 1 */
	local r_pbis = $S_1
	local correct = $S_4/$S_3
	local samplesize = $S_3
	matrix item_an[`irow',1] = `r_pbis'
	matrix item_an[`irow',2] = `correct'
	matrix item_an[`irow',3] = `samplesize'
}

matrix list item_an, format(%9.2f)

*******************************************
// 3. 	Kuder-Richardson Formula 20, 
*		Cronbach's Alpha,
*		Cochran's Q
*******************************************
kr20 `Bvars_abbrev_ICT'
local N_items	= $S_5
local avg_diff	= $S_3
local avg_PB	= $S_4
local kr20		= $S_6

alpha `Bvars_abbrev_ICT', asis item casewise
local calpha	= "`r(alpha)'"

cochran `Bvars_ICT'
local N_people	= r(N)
local cochran		= r(chi2)
local pvalue		= r(p)

local nvars : word count `rownames_aggr_kr20coch_ICT'
matrix item_an_aggr = J(`nvars',1,.)
*matrix list item_an_aggr
matrix colnames item_an_aggr = Results 
matrix rownames item_an_aggr = `rownames_aggr_kr20coch_ICT'
*matrix list item_an_aggr
matrix item_an_aggr[1,1] = `N_people'
matrix item_an_aggr[2,1] = `N_items'
matrix item_an_aggr[3,1] = `avg_diff'
matrix item_an_aggr[4,1] = `avg_PB'
matrix item_an_aggr[5,1] = `kr20'
matrix item_an_aggr[6,1] = `calpha'
matrix item_an_aggr[7,1] = `cochran'
matrix item_an_aggr[8,1] = `pvalue'
matrix list item_an_aggr, format(%9.2f)


// Life Skills
****************************************
// 2. Point Biserial with CONTROL items:
****************************************
foreach var of varlist S_l1_emoint-S_l41_sex_harass {
	quietly pbis `var' S_l_resp_total
}

local nvars : word count `Bvars_LS'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `Bvars_LS'
*matrix list item_an

local irow = 0
foreach var in `Bvars_LS' {
	local ++irow
	quietly pbis `var' S_l_resp_total	/* if l_item_notmiss == 1 */
	local r_pbis = $S_1
	local correct = $S_4/$S_3
	local samplesize = $S_3
	matrix item_an[`irow',1] = `r_pbis'
	matrix item_an[`irow',2] = `correct'
	matrix item_an[`irow',3] = `samplesize'
}

matrix list item_an, format(%9.2f)

*******************************************
// 3. 	Kuder-Richardson Formula 20, 
*		Cronbach's Alpha,
*		Cochran's Q
*******************************************
kr20 `Bvars_abbrev_LS'
local N_items	= $S_5
local avg_diff	= $S_3
local avg_PB	= $S_4
local kr20		= $S_6

alpha `Bvars_abbrev_LS', asis item casewise
local calpha	= "`r(alpha)'"

cochran `Bvars_LS'
local N_people	= r(N)
local cochran		= r(chi2)
local pvalue		= r(p)

local nvars : word count `rownames_aggr_kr20coch_LS'
matrix item_an_aggr = J(`nvars',1,.)
*matrix list item_an_aggr
matrix colnames item_an_aggr = Results 
matrix rownames item_an_aggr = `rownames_aggr_kr20coch_LS'
*matrix list item_an_aggr
matrix item_an_aggr[1,1] = `N_people'
matrix item_an_aggr[2,1] = `N_items'
matrix item_an_aggr[3,1] = `avg_diff'
matrix item_an_aggr[4,1] = `avg_PB'
matrix item_an_aggr[5,1] = `kr20'
matrix item_an_aggr[6,1] = `calpha'
matrix item_an_aggr[7,1] = `cochran'
matrix item_an_aggr[8,1] = `pvalue'
matrix list item_an_aggr, format(%9.2f)


**********
// 4. END:
**********
restore
log close
exit

