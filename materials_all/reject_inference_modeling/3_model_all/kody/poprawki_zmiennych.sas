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

data adj.APP_LOAN_AMOUNT;
length grp 8 war $300 zmienna $32;
zmienna="APP_LOAN_AMOUNT";
input;
war=_infile_;
grp=_n_;
cards;
11376 < APP_LOAN_AMOUNT
8880 < APP_LOAN_AMOUNT <= 11376
4824 < APP_LOAN_AMOUNT <= 8880
1956 < APP_LOAN_AMOUNT <= 4824
not missing(APP_LOAN_AMOUNT) and APP_LOAN_AMOUNT <= 1956
;
run;


data adj.APP_INCOME;
length grp 8 war $300 zmienna $32;
zmienna="APP_INCOME";
input;
war=_infile_;
grp=_n_;
cards;
(not missing(APP_INCOME) and APP_INCOME <= 1503) or 4923 < APP_INCOME
1503 < APP_INCOME <= 4923
;
run;


data adj.APP_SPENDINGS;
length grp 8 war $300 zmienna $32;
zmienna="APP_SPENDINGS";
input;
war=_infile_;
grp=_n_;
cards;
(not missing(APP_SPENDINGS) and APP_SPENDINGS <= 240) or 2220 < APP_SPENDINGS
240 < APP_SPENDINGS <= 2220
;
run;



data adj.ACT_CINS_N_STATB;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CINS_N_STATB";
input;
war=_infile_;
grp=_n_;
cards;
0 < ACT_CINS_N_STATB or missing(ACT_CINS_N_STATB)
not missing(ACT_CINS_N_STATB) and ACT_CINS_N_STATB <= 0
;
run;




data adj.ACT_CINS_SENIORITY;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CINS_SENIORITY";
input;
war=_infile_;
grp=_n_;
cards;
missing(ACT_CINS_SENIORITY) or ACT_CINS_SENIORITY <= 103
103 < ACT_CINS_SENIORITY
;
run;


data adj.ACT_CINS_N_STATC;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CINS_N_STATC";
input;
war=_infile_;
grp=_n_;
cards;
missing(ACT_CINS_N_STATC) or ACT_CINS_N_STATC <= 0
0 < ACT_CINS_N_STATC <= 2
2 < ACT_CINS_N_STATC
;
run;


