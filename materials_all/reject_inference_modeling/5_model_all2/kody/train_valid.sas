/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */



/*proc sql noprint;*/
/*select 'inlib.'||memname into :sets separated by " " */
/*from dictionary.tables where*/
/*libname=upcase("INLIB") and (memname like "ABT_1%" */
/*or memname like "ABT_2%"); */
/*quit; */
%let sets=&in_abt;
%put &sets;

data abt.train abt.valid;
	set &sets;

%dodatkowe_zmienne;
/*output*/
	if &tar in (0,1,.i,.d) and ranuni(1)<&prop
	then do;
		if ranuni(1)<0.4 then output abt.valid;
		else output abt.train;
	end;
	if _error_ then _error_=0;

/*ten keep to dla drugiego podej�cia*/
keep default: outstanding credit_limit cid aid period waga
ACT_CC 
ACT_CINS_MIN_SENIORITY 
ACT_CINS_N_STATC 
APP_CHAR_JOB_CODE 
APP_CHAR_MARITAL_STATUS 
APP_LOAN_AMOUNT 
APP_NUMBER_OF_CHILDREN
;




/*	keep */
/*	&tar aid cid outstanding period */
/*	default:*/
/*	app: agr: ags: act:*/
/*;*/
run;


