/*analizy koncowe modeli w RJ*/

proc format;
picture procent (round)
low- -0.005='00 000 000 009,99%'
(decsep=',' 
dig3sep=' '
fill=' '
prefix='-')
-0.005-high='00 000 000 009,99%'
(decsep=',' 
dig3sep=' '
fill=' ')
;
run;




%let kat_kody=c:\karol\analiza6_poziom_klienta\project\students\11111\modelowanie_rj\4_analizy_koncowe\;

libname inlib "c:\karol\analiza6_poziom_klienta\project\students\11111\data_st3_low\" compress=yes;
libname wej "&kat_kody.data\" compress=yes;

%let dir_index=&kat_kody;
%let dir=&dir_index.reports\;

/*proc sql noprint;*/
/*select 'inlib.'||memname into :sets separated by " " */
/*from dictionary.tables where*/
/*libname=upcase("INLIB") and memname like "ABT_%"; */
/*quit; */
%let in_abt=inlib.abt_app;
%let sets=&in_abt;
%put &sets;


data wej.abt;
	set &sets;
	if _error_ then _error_=0;
/*	z dodatkowe zmienne*/
	outstanding=app_loan_amount;
	credit_limit=app_loan_amount;
/*	if Default3 in (.i,.d) then Default3=0;*/
/*	if Default6 in (.i,.d) then Default6=0;*/
/*	if Default9 in (.i,.d) then Default9=0;*/
/*	if Default12 in (.i,.d) then Default12=0;*/

	where '197501'<=period<='199812' and product='ins'
/*	and decision='A'*/
	and default12 in (0,1,.i,.d)
	;
run;

/*kodowanie nowym modelem*/
%let zbior=wej.abt;
%include "c:\karol\analiza6_poziom_klienta\project\students\11111\modelowanie_rj\1_model_ngb\validacja\data\kod_do_skorowania.sas" / source2;

data wej.abt;
set wej.abt_score;
rename SCORECARD_POINTS=score_new;
drop psc:;
run;


/*kodowanie starym modelem*/
%let zbior=wej.abt;
%include "c:\karol\analiza6_poziom_klienta\project\students\11111\kalibracja\model_ins_risk\kod_do_skorowania.sas" / source2;

data wej.abt;
set wej.abt_score;
rename SCORECARD_POINTS=score_old;
drop psc:;
run;

/*kodowanie nowym modelem rj*/
%let zbior=wej.abt;
%include "c:\karol\analiza6_poziom_klienta\project\students\11111\modelowanie_rj\3_model_all\validacja\data\kod_do_skorowania.sas" / source2;

data wej.abt;
set wej.abt_score;
rename SCORECARD_POINTS=score_new_rj;
drop psc:;
run;


proc sql noprint;
select distinct 'GRP_'||compress(upcase(zmienna)),compress(upcase(zmienna))
into :zmienne_grp separated by ' ',
:zmienne separated by ' '
from wej.Karta_duza;
quit;
%let il_zm=&sqlobs;
%put &il_zm;
%put &zmienne;
%put &zmienne_grp;

/*kodowanie zmiennych dla nowego modelu*/
%let zbior=wej.abt;
%let keep=&zmienne_grp &zmienne app_loan_amount score: default: decision period cid aid;
%include "&kat_kody.data\kod_do_kodowania.sas" / source2;

proc delete data=wej.abt_score;
run;


data gini;
set wej.abt;
default12_ind=default12;
if Default12 in (.i,.d) then Default12=0;
keep score: decision default12 default12_ind;
run;

data ass;
label2="Somers' D"; nvalue2=0;
do i=1 to 18;
output;
end;
drop i;
run;
ods listing close;
ods output Association(persist=proc)=ass;
/*old */
proc logistic data=gini;
model default12=score_old;
run;
proc logistic data=gini;
model default12=score_old;
where decision='A';
run;
proc logistic data=gini;
model default12=score_old;
where decision='D';
run;
/*old ind*/
proc logistic data=gini;
model default12_ind=score_old;
run;
proc logistic data=gini;
model default12_ind=score_old;
where decision='A';
run;
proc logistic data=gini;
model default12_ind=score_old;
where decision='D';
run;
/*new*/
proc logistic data=gini;
model default12=score_new;
run;
proc logistic data=gini;
model default12=score_new;
where decision='A';
run;
proc logistic data=gini;
model default12=score_new;
where decision='D';
run;
/*new ind*/
proc logistic data=gini;
model default12_ind=score_new;
run;
proc logistic data=gini;
model default12_ind=score_new;
where decision='A';
run;
proc logistic data=gini;
model default12_ind=score_new;
where decision='D';
run;
/*new rj*/
proc logistic data=gini;
model default12=score_new_rj;
run;
proc logistic data=gini;
model default12=score_new_rj;
where decision='A';
run;
proc logistic data=gini;
model default12=score_new_rj;
where decision='D';
run;
/*new rj ind*/
proc logistic data=gini;
model default12_ind=score_new_rj;
run;
proc logistic data=gini;
model default12_ind=score_new_rj;
where decision='A';
run;
proc logistic data=gini;
model default12_ind=score_new_rj;
where decision='D';
run;
ods output close;
ods listing;

data ass2;
length des $20 Gini 8 type dataset $15;
set ass;
Gini=nvalue2;
if _n_=1 then do; des='Old score'; type='default12'; dataset='All'; end;
if _n_=2 then do; des='Old score'; type='default12'; dataset='Accepted'; end;
if _n_=3 then do; des='Old score'; type='default12'; dataset='Rejected'; end;

if _n_=4 then do; des='Old score'; type='default12_ind'; dataset='All'; end;
if _n_=5 then do; des='Old score'; type='default12_ind'; dataset='Accepted'; end;
if _n_=6 then do; des='Old score'; type='default12_ind'; dataset='Rejected'; end;



if _n_=7 then do; des='New score'; type='default12'; dataset='All'; end;
if _n_=8 then do; des='New score'; type='default12'; dataset='Accepted'; end;
if _n_=9 then do; des='New score'; type='default12'; dataset='Rejected'; end;

if _n_=10 then do; des='New score'; type='default12_ind'; dataset='All'; end;
if _n_=11 then do; des='New score'; type='default12_ind'; dataset='Accepted'; end;
if _n_=12 then do; des='New score'; type='default12_ind'; dataset='Rejected'; end;


if _n_=13 then do; des='New score rj'; type='default12'; dataset='All'; end;
if _n_=14 then do; des='New score rj'; type='default12'; dataset='Accepted'; end;
if _n_=15 then do; des='New score rj'; type='default12'; dataset='Rejected'; end;

if _n_=16 then do; des='New score rj'; type='default12_ind'; dataset='All'; end;
if _n_=17 then do; des='New score rj'; type='default12_ind'; dataset='Accepted'; end;
if _n_=18 then do; des='New score rj'; type='default12_ind'; dataset='Rejected'; end;



format gini nlpct12.2;
keep Gini des type dataset;
where label2="Somers' D";
run;



ods listing close;
ods html path="&dir" body='Gini.html' style=statistical;
title 'Gini on various datasets and models';
proc tabulate data=ass2;
class des type dataset;
var gini;
table type=''*dataset='', des=''*gini='Gini'*sum=''*f=nlpct12.2;
run;
ods html close;
ods listing;

/*kalibracje*/
libname kal 'c:\karol\analiza6_poziom_klienta\project\students\11111\modelowanie_rj\3_model_all\validacja\data\';
proc logistic data=kal.abt_score desc outest=b;
model default12new=SCORECARD_POINTS;
output out=test p=p;
run;
data test2;
set test;
pd_ins_new_rj=1/(1+exp(-(-0.034811574*SCORECARD_POINTS+10.438105393)));
run;


data kal;
set wej.abt_woe;
if Default12 in (.i,.d) then Default12=0;
pd_ins_new=1/(1+exp(-(-0.032397939*score_new+9.5756814988)));
pd_ins_old=1/(1+exp(-(-0.037844597*score_old+11.929922366)));
pd_ins=1/(1+exp(-(-0.032205144*score_old+9.4025558419)));
pd_ins_new_rj=1/(1+exp(-(-0.034811574*score_new_rj+10.438105393)));
if decision='A' then do;
	naive_rj_new=Default12;
	naive_rj_old=Default12;
	naive_rj=Default12;
	correct_rj_new=Default12;
end; else do;
	naive_rj_new=pd_ins_new;
	naive_rj_old=pd_ins_old;
	naive_rj=pd_ins;
	correct_rj_new=pd_ins_new_rj;
end;
run;


%macro rap_var;
%let zm=ACT_CINS_N_STATB;
%do i=1 %to &il_zm;
%let zm=%scan(&zmienne,&i,%str( ));
proc sort data=kal out=kal_sub;
by grp_&zm;
run;
proc sort data=wej.karta_duza out=karta;
by grp;
where zmienna="&zm";
run;
data kal_war;
merge kal_sub(in=z) karta(rename=(grp=grp_&zm) keep=war grp);
by grp_&zm;
if z;
run;
title "Variable &zm";
proc tabulate data=kal_war;
class grp_&zm war decision;
var default12 naive_rj_new naive_rj_old naive_rj correct_rj_new;
table grp_&zm=''*war='' all, 
colpctn='Pct'*f=procent.*(decision='' all)
(default12='Risk' 
naive_rj_new='RJ new' 
naive_rj_old='RJ old'
naive_rj='RJ all'
correct_rj_new='Correct RJ new'
)*mean=''*f=nlpct12.2*(decision='' all)
/ box='Group - Condition'
;
run;
%end;
%mend;


ods listing close;
ods html path="&dir" body='Variables.html' style=statistical;
%rap_var;
ods html close;
ods listing;


proc rank data=kal out=kal_ranks groups=12;
var score_new score_old score_new_rj;
ranks score_nband score_oband score_nrjband;
run;

ods listing close;
ods html path="&dir" body='Score_bands.html' style=statistical;
title "Score bands based on new scroe";
proc tabulate data=kal_ranks;
class score_nband decision;
var score_new default12 naive_rj_new naive_rj_old naive_rj
correct_rj_new pd_ins_new_rj;
table score_nband='' all, 
score_new='Score limits'*(min='Min' mean='Avg' max='Max')*f=12.
colpctn='Pct'*f=procent.*(decision='' all)
(default12='Risk' 
naive_rj_new='RJ new' 
naive_rj_old='RJ old'
naive_rj='RJ all'
correct_rj_new='RJ correct'
pd_ins_new_rj='PD correct'
)*mean=''*f=nlpct12.2*(decision='' all)
/ box='New score bands '
;
run;
title "Score bands based on old scroe";
proc tabulate data=kal_ranks;
class score_oband decision;
var score_old default12 naive_rj_new naive_rj_old naive_rj
correct_rj_new pd_ins_new_rj;
table score_oband='' all, 
score_old='Score limits'*(min='Min' mean='Avg' max='Max')*f=12.
colpctn='Pct'*f=procent.*(decision='' all)
(default12='Risk' 
naive_rj_new='RJ new' 
naive_rj_old='RJ old'
naive_rj='RJ all'
correct_rj_new='RJ correct'
pd_ins_new_rj='PD correct'
)*mean=''*f=nlpct12.2*(decision='' all)
/ box='Old score bands '
;
run;

title "Score bands based on new rj scroe";
proc tabulate data=kal_ranks;
class score_nrjband decision;
var score_new_rj default12 naive_rj_new naive_rj_old naive_rj
correct_rj_new pd_ins_new_rj;
table score_nrjband='' all, 
score_new_rj='Score limits'*(min='Min' mean='Avg' max='Max')*f=12.
colpctn='Pct'*f=procent.*(decision='' all)
(default12='Risk' 
naive_rj_new='RJ new' 
naive_rj_old='RJ old'
naive_rj='RJ all'
correct_rj_new='RJ correct'
pd_ins_new_rj='PD correct'
)*mean=''*f=nlpct12.2*(decision='' all)
/ box='New rj score bands '
;
run;
ods html close;
ods listing;

