/*  (c) Karol Przanowski   */
/*    kprzan@sgh.waw.pl    */


/*poprwaki dla zmiennych*/


/*data adj.;*/
/*length grp 8 war $300 zmienna $32;*/
/*zmienna="";*/
/*input;*/
/*war=_infile_;*/
/*grp=_n_;*/
/*cards;*/
/*;*/
/*run;*/

data adj.ACT_CINS_SENIORITY;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CINS_SENIORITY";
input;
war=_infile_;
grp=_n_;
cards;
missing(ACT_CINS_SENIORITY)
not missing(ACT_CINS_SENIORITY)
;
run;



data adj.APP_INCOME;
length grp 8 war $300 zmienna $32;
zmienna="APP_INCOME";
input;
war=_infile_;
grp=_n_;
cards;
4923 < APP_INCOME
not missing(APP_INCOME) and APP_INCOME <= 539
1500 < APP_INCOME <= 4923
539 < APP_INCOME <= 1500
;
run;

data adj.APP_SPENDINGS;
length grp 8 war $300 zmienna $32;
zmienna="APP_SPENDINGS";
input;
war=_infile_;
grp=_n_;
cards;
960 < APP_SPENDINGS
not missing(APP_SPENDINGS) and APP_SPENDINGS <= 960
;
run;



data adj.ACT_CINS_N_STATC;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CINS_N_STATC";
input;
war=_infile_;
grp=_n_;
cards;
missing(ACT_CINS_N_STATC)
not missing(ACT_CINS_N_STATC) and ACT_CINS_N_STATC <= 1
1 < ACT_CINS_N_STATC
;
run;


