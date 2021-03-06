version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline
log using "${rawname}_4PBis", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	04-26-2011

/*	
*	This do-file runs reliability and equality analysis
*	and built matrices	
*/

// Edit 01: 	Thomaz Alvares
//		Date:		05-9-2011
/*	
*	This edits fixed one of the matrices and saved
*	the data set in a new file	
*/


************
// 1. INTRO:
************
display "rawname is $rawname"
use "${rawname}_3Sc.dta", clear

quietly summarize q_s_no
display r(N) " in combined Version A and Versio B"

gen q_item_notmiss = 1
foreach var of varlist q1_start-q45_outlookdraft {
	replace q_item_notmiss = 2 if `var' == ""
}
label var q_item_notmiss "Respondents with no items missing"
label def notmiss 1 "not missing" 2 "missing"
label val q_item_notmiss notmiss
tab q_item_notmiss

foreach var of varlist  S_q1_start-S_q45_outlookdraft {
	clonevar `var'_abbrev = `var'
}
renvars S_q1_start_abbrev-S_q9_keyboard_abbrev,		trim(4)
renvars S_q10_mem_abbrev-S_q45_outlookdraft_abbrev,	trim(5)

local Bvars 																					///
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

local Bvars_abbrev																	///
	S_q1	S_q2	S_q3	S_q4	S_q5	S_q6	S_q7	S_q8	S_q9	S_q10	///
	S_q11	S_q12	S_q13	S_q14	S_q15	S_q16	S_q17	S_q18	S_q19	S_q20	///
	S_q21	S_q22	S_q23	S_q24	S_q25	S_q26	S_q27	S_q28	S_q29	S_q30	///
	S_q31	S_q32	S_q33	S_q34	S_q35	S_q36	S_q37	S_q38	S_q39	S_q40	///
	S_q41	S_q42	S_q43	S_q44	S_q45

local rownames																										///
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
			
local rownames_aggr_kr20coch										///
	N_not_miss				N_items				Avg_Difficulty		///
	Avg_CorrectPB_correl	KR20_coefficient	Cronbach_alpha		///
	Cochran_Q				p-value									


************************************
// 2. Point Biserial with ALL items:
************************************
foreach var of varlist S_q1_start-S_q45_outlookdraft {
	quietly pbis `var' S_q_resp_total
}

local nvars : word count `rownames'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `rownames'
*matrix list item_an

local irow = 0
foreach var in `Bvars' {
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
kr20 `Bvars_abbrev'
local N_items	= $S_5
local avg_diff	= $S_3
local avg_PB	= $S_4
local kr20		= $S_6

alpha `Bvars_abbrev', asis item casewise
local calpha	= "`r(alpha)'"

cochran `Bvars'
local N_not_miss	= r(N)
local cochran		= r(chi2)
local pvalue		= r(p)

local nvars : word count `rownames_aggr_kr20coch'
matrix item_an_aggr = J(`nvars',1,.)
*matrix list item_an_aggr
matrix colnames item_an_aggr = Results 
matrix rownames item_an_aggr = `rownames_aggr_kr20coch'
*matrix list item_an_aggr
matrix item_an_aggr[1,1] = `N_not_miss'
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
*drop S_q1-S_q45


save "${rawname}_4PBis.dta", replace

log close
exit


