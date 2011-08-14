version 11
clear all
macro drop _all
set linesize 80

//	Project:	STS_YIF_Kenya
//	Author:		Thomaz Alvares
// 		Date:	04-22-2011

/*	
	Master do-file
*/

// Edit 01: 
//	Date:

do "STS_KenyaYIF_Combined Demography-cohort2_baseline"

do "STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline_1Prep_110422"
do "STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline_2DC_110422"
do "STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline_3Sc_110422"
do "STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline_4PBis_110426"
do "STS_KenyaYIF_Combined ICT  VERSION A-cohort2_baseline_5Demo_110509"
exit


