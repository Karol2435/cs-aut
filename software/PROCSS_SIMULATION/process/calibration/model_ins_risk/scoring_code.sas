data &zbior._score;
set &zbior;
SCORECARD_POINTS = 0;
select;
when ( not missing(ACT_CC) and ACT_CC <= 0.248125937 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,61);
PSC_ACT_CC=61;
end;
when ( 0.248125937 < ACT_CC <= 0.3324658426 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,49);
PSC_ACT_CC=49;
end;
when ( 0.3324658426 < ACT_CC <= 0.857442348 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,40);
PSC_ACT_CC=40;
end;
when ( 0.857442348 < ACT_CC <= 1.0535455861 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,29);
PSC_ACT_CC=29;
end;
when ( 1.0535455861 < ACT_CC ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CC=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CC=-1;
end; end;
select;
when ( 119 < ACT_CINS_MIN_SENIORITY ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,99);
PSC_ACT_CINS_MIN_SENIORITY=99;
end;
when ( 36 < ACT_CINS_MIN_SENIORITY <= 119 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,76);
PSC_ACT_CINS_MIN_SENIORITY=76;
end;
when ( missing(ACT_CINS_MIN_SENIORITY) ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,53);
PSC_ACT_CINS_MIN_SENIORITY=53;
end;
when ( 22 < ACT_CINS_MIN_SENIORITY <= 36 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,50);
PSC_ACT_CINS_MIN_SENIORITY=50;
end;
when ( not missing(ACT_CINS_MIN_SENIORITY) and ACT_CINS_MIN_SENIORITY <= 22 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CINS_MIN_SENIORITY=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CINS_MIN_SENIORITY=-1;
end; end;
select;
when ( not missing(ACT_CINS_N_LOAN) and ACT_CINS_N_LOAN <= 1 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,57);
PSC_ACT_CINS_N_LOAN=57;
end;
when ( 1 < ACT_CINS_N_LOAN ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CINS_N_LOAN=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CINS_N_LOAN=-1;
end; end;
select;
when ( 2 < ACT_CINS_N_STATC ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,87);
PSC_ACT_CINS_N_STATC=87;
end;
when ( 1 < ACT_CINS_N_STATC <= 2 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,54);
PSC_ACT_CINS_N_STATC=54;
end;
when ( missing(ACT_CINS_N_STATC) ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,49);
PSC_ACT_CINS_N_STATC=49;
end;
when ( 0 < ACT_CINS_N_STATC <= 1 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,49);
PSC_ACT_CINS_N_STATC=49;
end;
when ( not missing(ACT_CINS_N_STATC) and ACT_CINS_N_STATC <= 0 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CINS_N_STATC=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_ACT_CINS_N_STATC=-1;
end; end;
select (APP_CHAR_JOB_CODE );
  when ('Permanent')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,81);
PSC_APP_CHAR_JOB_CODE=81;
end;
  when ('Retired')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,76);
PSC_APP_CHAR_JOB_CODE=76;
end;
  when ('Owner company')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,58);
PSC_APP_CHAR_JOB_CODE=58;
end;
  when ('Contract')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_CHAR_JOB_CODE=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_CHAR_JOB_CODE=-1;
end; end;
select (APP_CHAR_MARITAL_STATUS );
  when ('Widowed')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,57);
PSC_APP_CHAR_MARITAL_STATUS=57;
end;
  when ('Maried')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,55);
PSC_APP_CHAR_MARITAL_STATUS=55;
end;
  when ('Divorced')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,40);
PSC_APP_CHAR_MARITAL_STATUS=40;
end;
  when ('Singiel')   do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_CHAR_MARITAL_STATUS=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_CHAR_MARITAL_STATUS=-1;
end; end;
select;
when ( not missing(APP_LOAN_AMOUNT) and APP_LOAN_AMOUNT <= 1920 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,57);
PSC_APP_LOAN_AMOUNT=57;
end;
when ( 1920 < APP_LOAN_AMOUNT <= 4824 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,51);
PSC_APP_LOAN_AMOUNT=51;
end;
when ( 4824 < APP_LOAN_AMOUNT <= 7656 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,35);
PSC_APP_LOAN_AMOUNT=35;
end;
when ( 7656 < APP_LOAN_AMOUNT <= 8880 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,30);
PSC_APP_LOAN_AMOUNT=30;
end;
when ( 8880 < APP_LOAN_AMOUNT <= 11376 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,21);
PSC_APP_LOAN_AMOUNT=21;
end;
when ( 11376 < APP_LOAN_AMOUNT ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_LOAN_AMOUNT=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_LOAN_AMOUNT=-1;
end; end;
select;
when ( 1 < APP_NUMBER_OF_CHILDREN ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,57);
PSC_APP_NUMBER_OF_CHILDREN=57;
end;
when ( 0 < APP_NUMBER_OF_CHILDREN <= 1 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,23);
PSC_APP_NUMBER_OF_CHILDREN=23;
end;
when ( not missing(APP_NUMBER_OF_CHILDREN) and APP_NUMBER_OF_CHILDREN <= 0 ) do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_NUMBER_OF_CHILDREN=-1;
end;
otherwise do;
SCORECARD_POINTS=sum(SCORECARD_POINTS,-1);
PSC_APP_NUMBER_OF_CHILDREN=-1;
end; end;
run;
