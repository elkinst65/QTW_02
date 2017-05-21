/*
Case Study, Unit 2
Baldree, Brock, Elkins, Kelly
*/

/*switching mpg and eng_type to clear the null missing data issue*/
proc import datafile = 'C:\Users\austi\Documents\GitHub\Quantifying the World\QTW_02\carmpg.txt'
	out = carmpg
	dbms = dlm
	replace;
	datarow = 2;
	delimiter = '09'x;
run;

proc print data = carmpg (obs = 10); run;

/* Descriptive statistics */
proc means data = carmpg;
var mpg cylinders size hp weight accel eng_type;
run;


/* applying the initial proc reg which automatically applies listwise deletion*/
proc reg data = carmpg;
	model mpg = cylinders size hp weight accel eng_type; 
	title 'Regression Analysis with Listwise Deletion';
run;


/* Run this code separately to exclude MPGs from PROC MI*/
/*------------------------------------------------------*/
ods select misspattern;
proc mi data = carmpg nimpute=0;
	var mpg cylinders size hp weight accel eng_type;
run;


proc MI data = carmpg
out = miout seed = 35399;
var mpg cylinders size hp weight accel eng_type;
run;
/*------------------------------------------------------*/


ods select misspattern;
proc mi data = carmpg nimpute=0;
	var mpg cylinders size hp weight accel eng_type;
run;


proc MI data = carmpg
out = miout seed = 35399;
var mpg cylinders size hp weight accel eng_type;
run;

/* Performing regression on the result of PROC MI*/
proc reg data = miout outest = outreg 
			covout;
	model mpg = cylinders size hp weight accel eng_type;
	by _Imputation_; 
	title 'Regression Analysis of PROC MI results';
run;

/* Analyzing the effects*/
proc mianalyze data=outreg;
modeleffects cylinders size hp weight accel eng_type Intercept;
run;

/*
ERROR: Within-imputation COV missing for _Imputation_= 1 in the input DATA= data set.

This error is thrown when the above code is run. This is because size is included when 
it is what we are trying to model. 
*/

