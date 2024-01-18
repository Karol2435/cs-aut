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
1968 < APP_LOAN_AMOUNT <= 4824
not missing(APP_LOAN_AMOUNT) and APP_LOAN_AMOUNT <= 1968
;
run;

data adj.ACT_CINS_MIN_SENIORITY;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CINS_MIN_SENIORITY";
input;
war=_infile_;
grp=_n_;
cards;
missing(ACT_CINS_MIN_SENIORITY) or ACT_CINS_MIN_SENIORITY <= 22
22 < ACT_CINS_MIN_SENIORITY
;
run;



data adj.APP_CHAR_MARITAL_STATUS;
length grp 8 war $300 zmienna $32;
zmienna="APP_CHAR_MARITAL_STATUS";
input;
war=_infile_;
grp=_n_;
cards;
when ('Singiel','Divorced')
when ('Maried','Widowed')
;
run;





data adj.ACT_CC;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CC";
input;
war=_infile_;
grp=_n_;
cards;
1.00 < ACT_CC
0.85 < ACT_CC <= 1.00
0.25 < ACT_CC <= 0.85
not missing(ACT_CC) and ACT_CC <= 0.25
;
run;





data adj.ACT_CINS_N_STATC;
length grp 8 war $300 zmienna $32;
zmienna="ACT_CINS_N_STATC";
input;
war=_infile_;
grp=_n_;
cards;
not missing(ACT_CINS_N_STATC) and ACT_CINS_N_STATC <= 0
missing(ACT_CINS_N_STATC)
0 < ACT_CINS_N_STATC <= 2
2 < ACT_CINS_N_STATC
;
run;
