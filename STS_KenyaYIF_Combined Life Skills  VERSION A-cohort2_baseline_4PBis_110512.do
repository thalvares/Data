version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined Life Skills  VERSION  A-cohort2_baseline
log using "${rawname}_4PBis", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	05-12-2011

/*	
*	This do-file runs reliability and equality analysis
*	and built matrices	
*/

// Edit 01:
//		Date:
/*	
*/


************
// 1. INTRO:
************
display "rawname is $rawname"
use "${rawname}_3Sc.dta", clear

quietly summarize l_s_no_V2
display r(N) " in combined Version A and Versio B"

gen l_item_notmiss = 1
foreach var of varlist l1_emoint-l41_sex_harass {
	replace l_item_notmiss = 2 if `var' == ""
}
label var l_item_notmiss "Respondents with no items missing"
label def notmiss 1 "not missing" 2 "missing"
label val l_item_notmiss notmiss
tab l_item_notmiss

foreach var of varlist S_l1_emoint-S_l41_sex_harass {
	clonevar `var'_ab = `var'
}

renvars S_l1_emoint_ab-S_l9_listen_ab,				trim(4)
renvars S_l10_motivekaren_ab-S_l41_sex_harass_ab,	trim(5)

local Bvars 																											///
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

local Bvars_abbrev																	///
	S_l1	S_l2	S_l3	S_l4	S_l5	S_l6	S_l7	S_l8	S_l9	S_l10	///
	S_l11	S_l12	S_l13	S_l14	S_l15	S_l16	S_l17	S_l18	S_l19	S_l20	///
	S_l21	S_l22	S_l23	S_l24	S_l25	S_l26	S_l27	S_l28	S_l29	S_l30	///
	S_l31	S_l32	S_l33	S_l34	S_l35	S_l36	S_l37	S_l38	S_l39	S_l40	///
	S_l41

local rownames_aggr_kr20coch										///
	N_not_miss				N_items				Avg_Difficulty		///
	Avg_CorrectPB_correl	KR20_coefficient	Cronbach_alpha		///
	Cochran_Q				p-value									

	
************************************
// 2. Point Biserial with ALL items:
************************************
foreach var of varlist S_l1_emoint-S_l41_sex_harass {
	quietly pbis `var' S_l_resp_total
}

local nvars : word count `Bvars'
matrix item_an = J(`nvars',3,.)
*matrix list item_an
matrix colnames item_an = r_pbis Difficult(%) N 
matrix rownames item_an = `Bvars'
*matrix list item_an

local irow = 0
foreach var in `Bvars' {
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
*drop S_l1-S_l41

save "${rawname}_4PBis.dta", replace

log close
exit


