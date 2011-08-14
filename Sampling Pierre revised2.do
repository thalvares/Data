version 11
clear all
macro drop _all
set linesize 80

capture log close

//	Project:	STS_Burundi
//	Author:		Thomaz Alvares
// 		Date:	04-29-2011

/*	
	This do-file randomly select x% of schools in each region for sample,
	stratified by region and school statut
	It also creates a list of replacement schools
*/

// Edit 01: 
//	Date:

// Dir:	Path where you saved "STS_Burundi_sampling_mock_data.csv"
cd "C:\Data"

log using "STS_Burundi_sampling_data01" , replace text

* Preparing Data

insheet using "STS_Burundi_sampling_data01.csv"

/* Method N°2 */
/* Pierre : I have udpated as the grouping by province was not correct */

drop if statut == "PRIVE"

gen region = 0
replace region = 1 if province == "BUBANZA"
replace region = 1 if province == "BUJUMBURA"
replace region = 1 if province == "CIBITOKE"

replace region = 2 if province == "BURURI"
replace region = 2 if province == "RUTANA"
replace region = 2 if province == "MAKAMBA"

replace region = 3 if province == "CANKUZO"
replace region = 3 if province == "RUYIGI"
replace region = 3 if province == "GITEGA"
replace region = 3 if province == "MWARO"

replace region = 4 if province == "KAYANZA"
replace region = 4 if province == "MURAMVYA"

replace region = 5 if province == "KARUSI"
replace region = 5 if province == "KIRUNDO"
replace region = 5 if province == "MUYINGA"
replace region = 5 if province == "NGOZI"

replace region = 6 if province == "BUJUMBURA Mairie"

gen strate=0
replace strate=1 if region ==1 & statut=="CONVENTION"
replace strate=2 if region ==2 & statut=="CONVENTION"
replace strate=3 if region ==3 & statut=="CONVENTION"
replace strate=4 if region ==4 & statut=="CONVENTION"
replace strate=5 if region ==5 & statut=="CONVENTION"

replace strate=6 if region ==1 & statut=="PUBLIC"
replace strate=7 if region ==2 & statut=="PUBLIC"
replace strate=8 if region ==3 & statut=="PUBLIC"
replace strate=9 if region ==4 & statut=="PUBLIC"
replace strate=10 if region ==5 & statut=="PUBLIC"

replace strate = 11 if province == "BUJUMBURA Mairie"


/* on crée un fichier par strate  */

keep if strate==1
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate1.dta"

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==2
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate2.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==3
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate3.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==4
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate4.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==5
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate5.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==6
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate6.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==7
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate7.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==8
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate8.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==9
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate9.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==10
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate10.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==11
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate11.dta"
clear

/* On prend le nombre d'écoles qu'il faut */

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate1.dta", clear
sample 6, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate2.dta", clear
sample 9, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate3.dta", clear
sample 8, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate4.dta", clear
sample 6, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate5.dta", clear
sample 10, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate6.dta", clear
sample 13, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate7.dta", clear
sample 15, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate8.dta", clear
sample 15, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate9.dta", clear
sample 9, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate10.dta", clear
sample 22, count
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate11.dta", clear
sample 7, count
save, replace
clear

/* On a 11 fichiers avec les écoles de chaque strate, qu'on met ensembme */

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate1.dta", clear
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate2.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate3.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate4.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate5.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate6.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate7.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate8.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate9.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate10.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate11.dta"

save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\sample_Pierre.dta"


/* Method N°3 */

set seed 1926442


/* on crée un fichier par strate  */

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear

keep if strate==1
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate1.dta"

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==2
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate2.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==3
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate3.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==4
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate4.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==5
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate5.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==6
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate6.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==7
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate7.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==8
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate8.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==9
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate9.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==10
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate10.dta"
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\base2.dta", clear
keep if strate==11
save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate11.dta"
clear

/* On prend le nombre d'écoles qu'il faut */

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate1.dta", clear
samplepps select, ncases (6) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate2.dta", clear
samplepps select, ncases (9) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate3.dta", clear
samplepps select, ncases (8) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate4.dta", clear
samplepps select, ncases (6) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate5.dta", clear
samplepps select, ncases (10) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate6.dta", clear
samplepps select, ncases (13) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate7.dta", clear
samplepps select, ncases (15) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate8.dta", clear
samplepps select, ncases (15) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate9.dta", clear
samplepps select, ncases (9) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate10.dta", clear
samplepps select, ncases (22) size ( poids2est)
drop if select==0
save, replace
clear

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate11.dta", clear
samplepps select, ncases (7) size ( poids2est)
drop if select==0
save, replace
clear

/* On a 11 fichiers avec les écoles de chaque strate, qu'on met ensembme */

use "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate1.dta", clear
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate2.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate3.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate4.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate5.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate6.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate7.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate8.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate9.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate10.dta"
append using "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\strate11.dta"

save "C:\VARLYPROJECT\SOFRECO\Burundi\TECHNIK\sampling\Pierre\sample_Pierre2.dta"


* Set up randomization
sort nometab
set seed 1926442

gen rand = runiform()

* Put observations in a random order
sort region statut rand

* Make a new variable that selects 9% of schools of each statut in each region
* (note that 4.5% of the schools are going to be in the replacement list
* When you use the by command with multiple variables, it breaks them up into
* unique groups for each combination of the variables

/* Pierre : this does not allow to select the rigth number of schools per stratum */
/* for each stratum : the number of schools are given in the sample design, see sample design.xls */
/* The number of schools to be selected in each stratum is not given by the number of schools, but by the number of PUPILS of GRADE 2 ( poids2est)*/

by region statut (rand): gen select = cond( _n > .09*_N , 0 , 1) 

* Make a new variable that selects 50% of schools of schools in each stratum
* to be replacement
sort region statut select rand
by region statut select (rand): gen replacement = cond( _n > .5*_N , 1 , 0)
replace replacement = . if select == 0

* Label select and replacement
label def sel 0 "Not Selected" 1 "Selected"
label values select sel

label def repl 0 "Original" 1 "Replacement"
label values replacement repl

* Verify stratification
tab statut
tab region select
tab statut select
table region select , by(statut)

tab replacement select, missing
table region statut if select == 1, by(replacement)

* Save Data
save "STS_Burundi_sampling_data01.dta" , replace

log close
