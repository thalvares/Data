local st_dir: sysdir STATA
use `st_dir'auto

* the "@" prefix flags "length" as a continous variable,
* "rep78" will be treated as categorical by default
* the results will be written to "coeff.out" 
* through the use of the "using" option
desmat: regress weight @length rep78 using coeff
