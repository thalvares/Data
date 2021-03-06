/* Table in Hout (1983: 11). Original source: page 49 of            */
/* Featherman D.L., R.M. Hauser. (1978) "Opportunity and Change."   */
/* New York: Academic.                                              */
#delimit ;
tabi
1414  521  302   643   40 \
 724  524  254   703   48 \
 798  648  856  1676  108 \
 756  914  771  3325  237 \
 409  357  441  1611 1832 ,replace;
#delimit cr

rename row father
rename col son
rename pop freq

label var father "Father's occupation"
label var son    "Son's occupation"
#delimit ;
label def occ 1 "Upper nonmanual" 2 "Lower nonmanual" 3 "Upper manual" 
4 "Lower manual" 5 "Farm";
#delimit cr
label val father occ
label val son occ

* structural zeros for quasi independence model
gen wt=(father ~=son )
* variable for quasi-independence;
gen diag=0
quietly replace diag=father if father==son

* a symmetric cross-classification
gen sym=0
quietly replace sym=1  if ((father==1 & son==2) | (father==2 & son==1))
quietly replace sym=2  if ((father==1 & son==3) | (father==3 & son==1))
quietly replace sym=3  if ((father==1 & son==4) | (father==4 & son==1))
quietly replace sym=4  if ((father==1 & son==5) | (father==5 & son==1))
quietly replace sym=5  if ((father==2 & son==3) | (father==3 & son==2))
quietly replace sym=6  if ((father==2 & son==4) | (father==4 & son==2))
quietly replace sym=7  if ((father==2 & son==5) | (father==5 & son==2))
quietly replace sym=8  if ((father==3 & son==4) | (father==4 & son==3))
quietly replace sym=9  if ((father==3 & son==5) | (father==5 & son==3))
quietly replace sym=10 if ((father==4 & son==5) | (father==5 & son==4))

* design vectors for crossings parameter model
gen v1=(father <= 1 & son > 1) | (father > 1 & son <= 1)
gen v2=(father <= 2 & son > 2) | (father > 2 & son <= 2)
gen v3=(father <= 3 & son > 3) | (father > 3 & son <= 3)
gen v4=(father <= 4 & son > 4) | (father > 4 & son <= 4)

tab father son [fw=freq]

* An model of independence 
desmat father son
glm freq _x_*, link(log) family(poisson)
desrep

* save the design matrix of the baseline model
renpfix _x_ _z_

* A quasi-independence loglinear model, using structural zeros 
* (page 23 of "Mobility Tables").
/* 0  1  1  1  1   values of variable "wt"
   1  0  1  1  1
   1  1  0  1  1
   1  1  1  0  1
   1  1  1  1  0  */
glm freq _z_* [iweight=wt], link(log) family(poisson)
desrep

* Quasi-independence using a "dummy factor" to create the design 
* vectors for the diagonal cells (page 23).
/* 1  0  0  0  0   values of variable "diag"
   0  2  0  0  0
   0  0  3  0  0
   0  0  0  4  0
   0  0  0  0  5  */
desmat diag
glm freq  _z_* _x_*, link(log) family(poisson)
desrep

* Quasi-symmetry using the symmetric cross-classification (page 23)
/* 0  1  2  3  4   values of variable "sym"
   1  0  5  6  7
   2  5  0  8  9
   3  6  8  0 10
   4  7  9 10  0  */
desmat sym
glm freq  _z_* _x_*, link(log) family(poisson)
desrep

* Crossings parameter model (page 35)
/* 0  v1 v1 v1 v1 |  0  0  v2 v2 v2 |  0  0  0  v3 v3 |  0  0  0  0  v4
   v1 0  0  0  0  |  0  0  v2 v2 v2 |  0  0  0  v3 v3 |  0  0  0  0  v4
   v1 0  0  0  0  |  v2 v2 0  0  0  |  0  0  0  v3 v3 |  0  0  0  0  v4
   v1 0  0  0  0  |  v2 v2 0  0  0  |  v3 v3 v3 0  0  |  0  0  0  0  v4
   v1 0  0  0  0  |  v2 v2 0  0  0  |  v3 v3 v3 0  0  |  v4 v4 v4 v4 0  */
glm freq  _z_* v*, link(log) family(poisson)
desrep

* Crossings parameter model, specified as a pattern of log odds-ratios
 
/* The set of local log odds-ratio for table F can be defined as   */
/* log((F[i,j]*F[i+1,j+1])/(F[i,j+1]*F[i+1,j]))                    */
/* for i=1 to nrow(F)-1, j=1 to ncol(F)-1                          */
/* Using the difference contrast for interaction means that para-  */
/* meters will correspond with log odds-ratios                     */
/* The crossings parameter model has a pattern of log odds-ratios  */
/* with zeros for all off diagonal cells                           */
/* It is fitted by creating a design for a saturated model using   */
/* the difference contrast for interactions, then deleting all     */
/* columns of the design matrix for off-diagonal cells of the set  */
/* of local log odds-ratios                                        */

*  1  2  3  4       -->          1
*  5  6  7  8                       6
*  9 10 11 12                         11
* 13 14 15 16                            16

desmat father.son=dif.dif
drop _x_2-_x_5 _x_7-_x_10 _x_12-_x_15
glm freq  _z_* _x_*, link(log) family(poisson)
desrep
 
* Uniform association model: linear by linear association (page 58).
desmat father.son=orp(1).orp(1)
glm freq  _z_* _x_*, link(log) family(poisson)
desrep
 
* RC model 1 (unequal row and column effects, page 58)
/* Fits a uniform association parameter and row and column effect  */
/* parameters. Row and column effect parameters have the           */
/* restriction that the first and last categories are zero.        */
/* The column of design for the last category must be deleted      */
/* "manually".                                                     */
#delimit ;
desmat father.son=orp(1).orp(1)   /* uniform association */
       father.son=ind(1).orp(1)   /* row effects 2-5, drop 5 */
       father.son=orp(1).ind(1);  /* col effects 6-9, drop 9 */
#delimit cr
drop _x_5 _x_9
glm freq  _z_* _x_*, link(log) family(poisson)
desrep
