/*
MSDS7333-401: Quantifying the World 

Case Study 2
- Use PROC MI to discover the missing values patterns and to decide what 
	MI options to use. (Assume no tranformations.)
- Use PROC MI to create multiple imputed data sets.
- Use PROC REG to analyze the multiple data sets while outputting information
	to be used in MIANALYZE.
- Use PROC MIANALYZE to summarize the imputed analyses.
- Compare these results to the listwise deltion results.
*/

* load dataset;
data cars;
	infile "e:\qtw_02\carmpg_2_2_2_2.csv" firstobs=2 delimiter=',';
	input auto :$23. mpg cylinders size hp weight accel engtype;
run;

* print out entries;
title 'MPG Dataset';
proc print data=cars;
run;

* contents of dataset;
title 'MPG Dataset Contents';
proc datasets;
   contents data=_all_;
run;

* what data is missing from dataset?;
* use PROC REG with listwise deletion;
title 'Predicting MPG (initial)';
proc reg data=cars;
	model mpg = cylinders size hp weight;
run;
quit;

* is the missing data monotone or non-monotone?;
* the data is non-monotone;
title 'MI Pattern';
ods select misspattern;
proc mi data=cars nimpute=0;
	var mpg cylinders size hp weight;
run;

* create mi data using default MCMC for non-monotone;
title 'MI with MCMC';
proc mi data=cars out=miout seed=35399 nimpute=5;
	var mpg cylinders size hp weight;
run;

* run reg with mi data;
title 'Predicting MPG with MI (final)';
proc reg data=miout outest=outreg covout;
	model mpg = cylinders size hp weight;
	by _Imputation_;
run;

* combine results;
title 'Predicting MPG (combined)';
proc mianalyze data=outreg;
	modeleffects Intercept cylinders size hp weight;
run;
