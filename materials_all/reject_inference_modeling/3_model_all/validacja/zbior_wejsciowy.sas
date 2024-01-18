/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */




libname inlib "c:\karol\analiza6_poziom_klienta\project\students\11111\modelowanie_rj\2_analizy\data\" compress=yes;
libname wyj "c:\karol\analiza6_poziom_klienta\project\students\11111\modelowanie_rj\3_model_all\validacja\data\" compress=yes;


%let kat_kodowanie=%sysfunc(pathname(wyj));

proc sql noprint;
select distinct _variable_,'GRP_'||trim(_variable_) 
into :zmienne separated by ' ',
:zmienne_grp separated by ' '
from wyj.Scorecard_scorecard1;
quit;
%put &zmienne;
%put &zmienne_grp;

/*proc sql noprint;*/
/*select 'inlib.'||memname into :sets separated by " " */
/*from dictionary.tables where*/
/*libname=upcase("INLIB") and memname like "ABT_%"; */
/*quit; */
%let in_abt=inlib.abt_score;
%let sets=&in_abt;
%put &sets;


%macro dodatkowe_zmienne;
outstanding=app_loan_amount;
credit_limit=app_loan_amount;
%mend;


data wyj.abt;
	set &sets;
	if _error_ then _error_=0;
	%dodatkowe_zmienne;
	keep &zmienne default: outstanding: credit_limit 
	period ;
run;


%let zbior=wyj.abt;
%include "&kat_kodowanie.\kod_do_skorowania.sas" / source2;

proc delete data=wyj.abt;
run;
