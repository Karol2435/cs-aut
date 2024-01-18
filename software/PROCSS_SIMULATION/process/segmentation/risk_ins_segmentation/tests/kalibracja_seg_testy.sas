/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */

/*kalibracja modeli do wyznaczenia cut off by uzyskac oplacalnosc*/

options mprint;
options nomprint;

%let dir=c:\karol\analiza6_poziom_klienta\project\;
%let nr_albumu=11111;

libname data "&dir.students\&nr_albumu.\data1_all\" compress=yes;

%let apr_ins=0.01;
%let apr_css=0.18;
%let lgd_ins=0.45;
%let lgd_css=0.55;
%let provision_ins=0;
%let provision_css=0;



data kal;
set data.abt_app;
if default12 in (0,.i,.d) then default12=0;
if default_cross12 in (0,.i,.d) then default_cross12=0;
where '197501'<=period<='198712' and product='ins';
run;

%let zbior=kal;
%include "&dir.students\&nr_albumu.\kalibracja\model_ins_risk\kod_do_skorowania.sas";

data kal1;
set kal_score;
risk_ins_score=.;
if product='ins' then risk_ins_score=SCORECARD_POINTS;
pd_ins=1/(1+exp(-(-0.032205144*risk_ins_score+9.4025558419)));
drop psc: SCORECARD_POINTS;
run;

%let zbior=kal1;
%include "c:\karol\analiza6_poziom_klienta\project\students\11111\modele\risk_ins_segmentacja\missing\wyj\kod_do_skorowania.sas";

data kal2;
set kal1_score;
risk_ins_score_miss=.;
if product='ins' and missing(Act_cins_seniority) 
	then risk_ins_score_miss=SCORECARD_POINTS;
pd_ins_miss=1/(1+exp(-(-0.031716661*risk_ins_score_miss+9.2010417882)));
drop psc: SCORECARD_POINTS;
run;

/**/
/*proc logistic data=kal2 desc outest=bety;*/
/*model default12=risk_ins_score_miss;*/
/*output out=test p=p;*/
/*run;*/
/*data test2;*/
/*set test;*/
/*pd_ins_miss=1/(1+exp(-(-0.031716661*risk_ins_score_miss+9.2010417882)));*/
/*run;*/

%let zbior=kal2;
%include "c:\karol\analiza6_poziom_klienta\project\students\11111\modele\risk_ins_segmentacja\not_missing\wyj\kod_do_skorowania.sas";

data kal3;
length seg $ 10;
set kal2_score;
risk_ins_score_nmiss=.;
if product='ins' and not missing(Act_cins_seniority) 
	then risk_ins_score_nmiss=SCORECARD_POINTS;
pd_ins_nmiss=1/(1+exp(-(-0.033299698*risk_ins_score_nmiss+9.6892093704)));
pd_ins_seg=max(pd_ins_nmiss,pd_ins_miss);
seg='NMiss'; 
if missing(Act_cins_seniority) then seg='Miss';
drop psc: SCORECARD_POINTS;
run;


ods listing close;
ods output Association(persist=proc)=ass;
proc logistic data=kal3 desc;
model default12=pd_ins;
run;
proc logistic data=kal3 desc;
model default12=pd_ins;
where not missing(Act_cins_seniority);
run;
proc logistic data=kal3 desc;
model default12=pd_ins;
where missing(Act_cins_seniority);
run;

proc logistic data=kal3 desc;
model default12=pd_ins_seg;
run;
proc logistic data=kal3 desc;
model default12=pd_ins_seg;
where not missing(Act_cins_seniority);
run;
proc logistic data=kal3 desc;
model default12=pd_ins_seg;
where missing(Act_cins_seniority);
run;
ods output close;
ods listing;



data ass2;
length des $20 Gini 8 type $10;
set ass;
Gini=nvalue2;
if _n_=1 then do; des='PD'; type='All'; end;
if _n_=2 then do; des='PD'; type='NMiss'; end;
if _n_=3 then do; des='PD'; type='Miss'; end;

if _n_=4 then do; des='PD seg'; type='All'; end;
if _n_=5 then do; des='PD seg'; type='NMiss'; end;
if _n_=6 then do; des='PD seg'; type='Miss'; end;
format gini nlpct12.2;
keep Gini des type;
where label2="Somers' D";
run;



proc format;
picture procent (round)
low- -0.005='00.000.000.009,99%'
(decsep=',' 
dig3sep='.'
fill=' '
prefix='-')
-0.005-high='00.000.000.009,99%'
(decsep=',' 
dig3sep='.'
fill=' ')
;
run;


ods listing close;
ods html path='c:\karol\analiza6_poziom_klienta\project\students\11111\modele\risk_ins_segmentacja\testy\' 
body='testy_segmentacji.html' style=statistical;
title 'Observed - expected risk';
proc tabulate data=kal3;
class seg;
var default12 pd_ins pd_ins_seg;
table all seg='', (n='N'*f=nlnum12. pctn='Pct'*f=procent.)
(default12='Risk' pd_ins='PD' pd_ins_seg='PD Seg')
*mean=''*f=nlpct12.2
 / box='Segments';
run;
title 'Predictive powers';
proc tabulate data=ass2;
class type des;
var gini;
table type='', des=''*max=''*gini=''*f=nlpct12.2
 / box='Segments';
run;
ods html close;
ods listing;
