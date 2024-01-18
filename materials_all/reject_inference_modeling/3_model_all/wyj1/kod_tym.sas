data grp;
set abt.train;
select;
when ( not missing(ACT_CINS_N_STATB) and ACT_CINS_N_STATB <= 0 ) do;
GRP_ACT_CINS_N_STATB  = 1 ;
end;
when ( 0 < ACT_CINS_N_STATB ) do;
GRP_ACT_CINS_N_STATB  = 2 ;
end;
when ( missing(ACT_CINS_N_STATB) ) do;
GRP_ACT_CINS_N_STATB  = 3 ;
end;
otherwise GRP_ACT_CINS_N_STATB  = 4 ; end;
select;
when ( not missing(ACT_CINS_N_STATC) and ACT_CINS_N_STATC <= 0 ) do;
GRP_ACT_CINS_N_STATC  = 1 ;
end;
when ( 0 < ACT_CINS_N_STATC <= 1 ) do;
GRP_ACT_CINS_N_STATC  = 2 ;
end;
when ( 1 < ACT_CINS_N_STATC <= 2 ) do;
GRP_ACT_CINS_N_STATC  = 3 ;
end;
when ( 2 < ACT_CINS_N_STATC ) do;
GRP_ACT_CINS_N_STATC  = 4 ;
end;
when ( missing(ACT_CINS_N_STATC) ) do;
GRP_ACT_CINS_N_STATC  = 5 ;
end;
otherwise GRP_ACT_CINS_N_STATC  = 6 ; end;
select;
when ( not missing(ACT_CINS_SENIORITY) and ACT_CINS_SENIORITY <= 73 ) do;
GRP_ACT_CINS_SENIORITY  = 1 ;
end;
when ( 73 < ACT_CINS_SENIORITY <= 103 ) do;
GRP_ACT_CINS_SENIORITY  = 2 ;
end;
when ( 103 < ACT_CINS_SENIORITY <= 140 ) do;
GRP_ACT_CINS_SENIORITY  = 3 ;
end;
when ( 140 < ACT_CINS_SENIORITY <= 227 ) do;
GRP_ACT_CINS_SENIORITY  = 4 ;
end;
when ( 227 < ACT_CINS_SENIORITY ) do;
GRP_ACT_CINS_SENIORITY  = 5 ;
end;
when ( missing(ACT_CINS_SENIORITY) ) do;
GRP_ACT_CINS_SENIORITY  = 6 ;
end;
otherwise GRP_ACT_CINS_SENIORITY  = 7 ; end;
select (APP_CHAR_GENDER );
  when ('Female')   do;
GRP_APP_CHAR_GENDER  = 1 ;
end;
  when ('Male')   do;
GRP_APP_CHAR_GENDER  = 2 ;
end;
otherwise GRP_APP_CHAR_GENDER  = 3 ; end;
select (APP_CHAR_JOB_CODE );
  when ('Owner company')   do;
GRP_APP_CHAR_JOB_CODE  = 1 ;
end;
  when ('Retired')   do;
GRP_APP_CHAR_JOB_CODE  = 2 ;
end;
  when ('Permanent')   do;
GRP_APP_CHAR_JOB_CODE  = 3 ;
end;
  when ('Contract')   do;
GRP_APP_CHAR_JOB_CODE  = 4 ;
end;
otherwise GRP_APP_CHAR_JOB_CODE  = 5 ; end;
select;
when ( not missing(APP_INCOME) and APP_INCOME <= 636 ) do;
GRP_APP_INCOME  = 1 ;
end;
when ( 636 < APP_INCOME <= 1503 ) do;
GRP_APP_INCOME  = 2 ;
end;
when ( 1503 < APP_INCOME <= 1972 ) do;
GRP_APP_INCOME  = 3 ;
end;
when ( 1972 < APP_INCOME <= 4923 ) do;
GRP_APP_INCOME  = 4 ;
end;
when ( 4923 < APP_INCOME <= 6743 ) do;
GRP_APP_INCOME  = 5 ;
end;
when ( 6743 < APP_INCOME ) do;
GRP_APP_INCOME  = 6 ;
end;
when ( missing(APP_INCOME) ) do;
GRP_APP_INCOME  = 7 ;
end;
otherwise GRP_APP_INCOME  = 8 ; end;
select;
when ( not missing(APP_LOAN_AMOUNT) and APP_LOAN_AMOUNT <= 1956 ) do;
GRP_APP_LOAN_AMOUNT  = 1 ;
end;
when ( 1956 < APP_LOAN_AMOUNT <= 4824 ) do;
GRP_APP_LOAN_AMOUNT  = 2 ;
end;
when ( 4824 < APP_LOAN_AMOUNT <= 5316 ) do;
GRP_APP_LOAN_AMOUNT  = 3 ;
end;
when ( 5316 < APP_LOAN_AMOUNT <= 8880 ) do;
GRP_APP_LOAN_AMOUNT  = 4 ;
end;
when ( 8880 < APP_LOAN_AMOUNT <= 11376 ) do;
GRP_APP_LOAN_AMOUNT  = 5 ;
end;
when ( 11376 < APP_LOAN_AMOUNT ) do;
GRP_APP_LOAN_AMOUNT  = 6 ;
end;
when ( missing(APP_LOAN_AMOUNT) ) do;
GRP_APP_LOAN_AMOUNT  = 7 ;
end;
otherwise GRP_APP_LOAN_AMOUNT  = 8 ; end;
select;
when ( not missing(APP_SPENDINGS) and APP_SPENDINGS <= 200 ) do;
GRP_APP_SPENDINGS  = 1 ;
end;
when ( 200 < APP_SPENDINGS <= 240 ) do;
GRP_APP_SPENDINGS  = 2 ;
end;
when ( 240 < APP_SPENDINGS <= 400 ) do;
GRP_APP_SPENDINGS  = 3 ;
end;
when ( 400 < APP_SPENDINGS <= 2220 ) do;
GRP_APP_SPENDINGS  = 4 ;
end;
when ( 2220 < APP_SPENDINGS ) do;
GRP_APP_SPENDINGS  = 5 ;
end;
when ( missing(APP_SPENDINGS) ) do;
GRP_APP_SPENDINGS  = 6 ;
end;
otherwise GRP_APP_SPENDINGS  = 7 ; end;
run;
