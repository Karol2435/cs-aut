/*przyk³adowy dodatkowy w³asny kod*/
/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */

/*opis kodu*/
/*Kod rysuje krzyw¹ ROC w oparciu o listê zmiennych WoE*/
/*na zbiorze treningowym*/

%let prefix_dir=c:\karol\oferta_zajec\sas_css\asb_szybkie\;
%let tar=default12;
libname abt "&prefix_dir.abt" compress=yes;


proc logistic data=abt.train_woe desc;
model &tar=
WOE_ACT12_N_ARREARS 
WOE_ACT_CC 
WOE_ACT_CCSS_DUEUTL 
WOE_ACT_CCSS_MIN_LNINST 
WOE_ACT_CCSS_N_STATC 
WOE_APP_CHAR_JOB_CODE / outroc=roc
;
run;

data roc;
set roc;
random=_SENSIT_;
label random='Random model sensitivity';
run;

ods listing close;
ods html path="&prefix_dir.\modele\"
body='ROC.html' style=statistical;
goptions reset=all device=activex;
title "ROC Courve";
symbol v=dot i=join;
proc gplot data=roc;
plot _SENSIT_*(_1MSPEC_ random) / overlay;
run;
quit;
ods html close;
ods listing;
goptions reset=all device=win;

