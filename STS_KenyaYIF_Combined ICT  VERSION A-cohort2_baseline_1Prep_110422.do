version 11
clear all
macro drop _all
set linesize 80

capture log close
global rawname STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline
global rawnameB STS_KenyaYIF_Combined ICT  VERSION B-cohort2_baseline
log using "${rawname}_1prep", replace text

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	08-03-2011

/*	
	This do-file insheet the data from excel to STATA,
	labels the dataset for Version A and Version B. It fixes
	the variable names in Version B according to Version A.
	Finally, it appends Version B to Version A  and converts
	99 in the strings to missing value.
*/

// Edit 01:		Thomaz Alvares 
//		Date:	04-26-2011


// 1. APPENDING FILES

//	1.1 Version B: Matching varnames to varnames in Version A
display "rawnameB is $rawnameB"
insheet using "${rawnameB}.csv", clear
gen q_version = 2

renvars q1hardwaretoaccessinternet-q9nonmodifiablecomputermemory, predrop(2) /*
	--> Dropping first two characters (q#) so that names match across versions */
renvars q10whatdoespicturerepresent-q45insertarow, predrop(3) /*
	--> Dropping first three characters (q1#) so that names match across versions */

/*	ISSUE:	Several variables in Version B not only had different q# (as expected), 
		but also had different varnames following the q#
	NEED:	Check each of vars with varnames that don't match across the versions 
*/

rename startbutton q1_start
rename whatdoespicturerepresent q2_folder	/*
	--> Version A: Q2: File; In version 
	-->	Version B: Q10: What does picture represent	*/
rename buttontopastetext q3_paste
rename programtowritealetter q4_write
rename time q5_time
rename highlitingawordinworddocument q6_highlight	/*
	--> Version A: Q6: Highlight a word
	--> Version B: Q12: Highliting a word in word document	*/
rename openanewdocumentinword q7_docnew	/*
	--> Version A: Q7: Menu in word
	--> Version B: Q14:  Open a new document in word	*/
rename deleteddocument q8_docdel	/*
	--> Version A: Q8: Delete a document 
	--> Version B: Q7: Deleted document	*/
rename inputdevice q9_keyboard
rename nonmodifiablecomputermemory q10_mem	/*
	--> Version A: Q10: Modifiable Computer Memory 
	--> Version B: Q9: Non modifiable computer memory	*/
rename devicefordatastorage q11_hd
rename hardwaretoaccessinternet q12_wireless	/*
	--> Version A: Q12: Internet hardware 
	--> Version B: Q1: Hardware to access internet	*/
rename outputdevice q13_speaker
rename satacable q14_sata
rename deviceshown q15_scanner
rename deviceshown q16_laptop
rename typeofmonitor q17_monitor
rename datastoragedevice q18_flashdrive
rename typeofprinter q19_printer
rename computerstoreforoperatingsyst q20_system	/*
	--> Version A: Q20: Stores operating system 
	--> Version B: Q21: Computer store for operating system	*/
rename componentnotinterchageable q21_notinterchange	/*
	--> Version A: Q21: Interchangeable computer component 
	--> Version B: Q23: Component not interchageable	*/
rename protocallinkedwithemail q22_email	/*
	--> Version A: Q22: Protocol not linked to email 
	--> Version B: Q19: Protocal Linked with email	*/
rename cleancd q23_cdclean
rename aluminiumladdersetup q24_ladder	/*
	--> Version A: Q24: Aluminum ladder location 
	--> Version B: Q27: Aluminium Ladder set up	*/
rename caringforcomputer q25_compdust	/*
	--> Version A: Q25: Caring for computers 
	--> Version B: Q17: Caring for computer	*/
rename cleaningsolvents q26_compclean
rename screwdriverrepurcussion q27_compscrew	/*
	--> Version A: Q27: Screwdriver repercussion 
	--> Version B: Q18: Screwdriver repurcussion	*/
rename instalationofupgradecalculati q28_multiplication	/*
	--> Version A: Q28: Updgrade installation calculation 
	--> Version B: Q20: Instalation of upgrade calculation	*/
rename antivirusfailurerate q29_percentage
rename graphicsupgradecalculaton q30_division	/*
	--> Version A: Q30: Upgrade graphic cards 
	--> Version B: Q24: Graphics upgrade calculaton	*/
rename internetcafusage q31_multiplicationadv	/*
	--> Version A: Q31: Internet cafe usage 
	--> Version B: Q37: Internet Café Usage	*/
rename protectcomputerfromvirus q32_antivirus
rename dialogboxes q33_dialogbox
rename renameafile q34_rename
rename closeawordfile q35_wordclose	/*
	--> Version A: Q35: Close word file 
	--> Version B: Q44: Close a word file	*/
rename openadocument q36_wordrecent	/*
	--> Version A: Q36: Open recent document 
	--> Version B: Q43: Open a document	*/
rename wordprocessingcopyingatext q37_wordcopy
rename nameboxdisplay q38_excelcell
rename insertarow q39_excelrow	/*
	--> Version A: Q39: Inserting rows 
	--> Version B: Q45: Insert a row	*/
rename enterformula q40_excelformula
rename url q41_weburl
rename tooltosearchweb q42_webnavigator
rename securityzone q43_websecurity
rename folderbanner q44_outlookbanner
rename savemessagesinoutlook q45_outlookdraft

rename s_no q_s_no
rename date q_date
rename participantid resp_id
rename firstname q_name_f
rename middlename q_name_m
rename lastname q_name_l

quietly summarize q_s_no
display r(N) " cases in Version B"

save "${rawnameB}_1prep.dta", replace


//	1.2 Version A: Simplifying varname for combined dataset
display "rawname is $rawname"
insheet using "${rawname}.csv", clear
gen q_version = 1

rename s_no q_s_no
rename participantid resp_id
rename date q_date
rename firstname q_name_f
rename middlename q_name_m
rename lastname q_name_l
rename q1startbutton q1_start
rename q2file q2_folder
rename q3buttontopastetext q3_paste
rename q4programtowritealetter q4_write
rename q5time q5_time
rename q6highlightaword q6_highlight
rename q7menuinword q7_docnew
rename q8deleteadocument q8_docdel
rename q9inputdevice q9_keyboard
rename q10modifiablecomputermemory q10_mem
rename q11devicefordatastorage q11_hd
rename q12internethardware q12_wireless
rename q13outputdevice q13_speaker
rename q14satacable q14_sata
rename q15deviceshown q15_scanner
rename q16deviceshown q16_laptop
rename q17typeofmonitor q17_monitor
rename q18datastoragedevice q18_flashdrive
rename q19typeofprinter q19_printer
rename q20storesoperatingsystem q20_system
rename q21interchangeablecomputercompon q21_notinterchange
rename q22protocolnotlinkedtoemail q22_email
rename q23cleancd q23_cdclean
rename q24aluminumladderlocation q24_ladder
rename q25caringforcomputers q25_compdust
rename q26cleaningsolvents q26_compclean
rename q27screwdriverrepercussion q27_compscrew
rename q28updgradeinstallationcalculati q28_multiplication
rename q29antivirusfailurerate q29_percentage
rename q30upgradegraphiccards q30_division
rename q31internetcafeusage q31_multiplicationadv
rename q32protectcomputerfromvirus q32_antivirus
rename q33dialogboxes q33_dialogbox
rename q34renameafile q34_rename
rename q35closewordfile q35_wordclose
rename q36openrecentdocument q36_wordrecent
rename q37wordprocessingcopyingatext q37_wordcopy
rename q38nameboxdisplay q38_excelcell
rename q39insertingrows q39_excelrow
rename q40enterformula q40_excelformula
rename q41url q41_weburl
rename q42tooltosearchweb q42_webnavigator
rename q43securityzone q43_websecurity
rename q44folderbanner q44_outlookbanner
rename q45savemessagesinoutlook q45_outlookdraft

quietly summarize q_s_no
display r(N) " cases in Version A"

append using "${rawnameB}_1prep.dta", force
erase "${rawnameB}_1prep.dta"
label var q_s_no "Serial Number in ICT Dataset"
label var q_version "ICT Version (A or B)"
label def ver 1 "Version A" 2 "Version B"
label val q_version ver
table q_version

// 2. CONVERTING STRING "99" TO MISSING VALUE ""
foreach var of varlist q1_start-q45_outlookdraft {
	replace `var' = "" if `var' == "99"
}

quietly summarize q_s_no
display r(N)
display r(N) " cases should equal 109 (Ver A) + 112 (Ver B)"

save "${rawname}_1prep.dta", replace


log close
exit





