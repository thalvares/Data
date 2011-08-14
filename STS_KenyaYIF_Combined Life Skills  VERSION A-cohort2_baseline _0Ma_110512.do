version 11
clear all
macro drop _all
set linesize 80

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	05-11-2011

/*	
	Master do-file
*/

// Edit 01: 
//	Date:

do "STS_KenyaYIF_Combined Demography-cohort2_baseline"

do "STS_KenyaYIF_Combined Life Skills  VERSION A-cohort2_baseline_1prep_110510"
do "STS_KenyaYIF_Combined Life Skills  VERSION A-cohort2_baseline_2DC_110511"
do "STS_KenyaYIF_Combined Life Skills  VERSION A-cohort2_baseline_3Sc_110512"
do "STS_KenyaYIF_Combined Life Skills  VERSION A-cohort2_baseline_4PBis_110512"
do "STS_KenyaYIF_Combined Life Skills  VERSION A-cohort2_baseline_5Demo_110512"

exit


