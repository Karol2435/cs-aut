data &zbior._woe;
set &zbior;
select;
when ( not missing(ACT_CINS_N_STATB) and ACT_CINS_N_STATB <= 0 ) do;
GRP_ACT_CINS_N_STATB  = 3 ;
WOE_ACT_CINS_N_STATB  = -4.234356348 ;
end;
when ( missing(ACT_CINS_N_STATB) ) do;
GRP_ACT_CINS_N_STATB  = 2 ;
WOE_ACT_CINS_N_STATB  = -2.825730192 ;
end;
when ( 0 < ACT_CINS_N_STATB ) do;
GRP_ACT_CINS_N_STATB  = 1 ;
WOE_ACT_CINS_N_STATB  = -2.22427249 ;
end;
otherwise do;
GRP_ACT_CINS_N_STATB  = 1 ;
WOE_ACT_CINS_N_STATB  = -2.22427249 ;
end; end;
select;
when ( 1 < ACT_CINS_N_STATC ) do;
GRP_ACT_CINS_N_STATC  = 3 ;
WOE_ACT_CINS_N_STATC  = -3.771587367 ;
end;
when ( not missing(ACT_CINS_N_STATC) and ACT_CINS_N_STATC <= 1 ) do;
GRP_ACT_CINS_N_STATC  = 2 ;
WOE_ACT_CINS_N_STATC  = -3.403520263 ;
end;
when ( missing(ACT_CINS_N_STATC) ) do;
GRP_ACT_CINS_N_STATC  = 1 ;
WOE_ACT_CINS_N_STATC  = -2.825730192 ;
end;
otherwise do;
GRP_ACT_CINS_N_STATC  = 1 ;
WOE_ACT_CINS_N_STATC  = -2.825730192 ;
end; end;
select;
when ( not missing(ACT_CINS_SENIORITY) ) do;
GRP_ACT_CINS_SENIORITY  = 2 ;
WOE_ACT_CINS_SENIORITY  = -3.553229417 ;
end;
when ( missing(ACT_CINS_SENIORITY) ) do;
GRP_ACT_CINS_SENIORITY  = 1 ;
WOE_ACT_CINS_SENIORITY  = -2.825730192 ;
end;
otherwise do;
GRP_ACT_CINS_SENIORITY  = 1 ;
WOE_ACT_CINS_SENIORITY  = -2.825730192 ;
end; end;
select (APP_CHAR_GENDER );
  when ('Female')   do;
GRP_APP_CHAR_GENDER  = 2 ;
WOE_APP_CHAR_GENDER  = -3.371000645 ;
end;
  when ('Male')   do;
GRP_APP_CHAR_GENDER  = 1 ;
WOE_APP_CHAR_GENDER  = -2.68608329 ;
end;
otherwise do;
GRP_APP_CHAR_GENDER  = 1 ;
WOE_APP_CHAR_GENDER  = -2.68608329 ;
end; end;
select (APP_CHAR_JOB_CODE );
  when ('Retired')   do;
GRP_APP_CHAR_JOB_CODE  = 3 ;
WOE_APP_CHAR_JOB_CODE  = -3.480789392 ;
end;
  when ('Permanent')   do;
GRP_APP_CHAR_JOB_CODE  = 2 ;
WOE_APP_CHAR_JOB_CODE  = -2.721673095 ;
end;
  when ('Owner company')   do;
GRP_APP_CHAR_JOB_CODE  = 1 ;
WOE_APP_CHAR_JOB_CODE  = -2.499628262 ;
end;
otherwise do;
GRP_APP_CHAR_JOB_CODE  = 1 ;
WOE_APP_CHAR_JOB_CODE  = -2.499628262 ;
end; end;
select;
when ( 539 < APP_INCOME <= 1500 ) do;
GRP_APP_INCOME  = 4 ;
WOE_APP_INCOME  = -3.495688225 ;
end;
when ( 1500 < APP_INCOME <= 4923 ) do;
GRP_APP_INCOME  = 3 ;
WOE_APP_INCOME  = -2.88411522 ;
end;
when ( not missing(APP_INCOME) and APP_INCOME <= 539 ) do;
GRP_APP_INCOME  = 2 ;
WOE_APP_INCOME  = -2.848832239 ;
end;
when ( 4923 < APP_INCOME ) do;
GRP_APP_INCOME  = 1 ;
WOE_APP_INCOME  = -2.419825976 ;
end;
otherwise do;
GRP_APP_INCOME  = 1 ;
WOE_APP_INCOME  = -2.419825976 ;
end; end;
select;
when ( not missing(APP_SPENDINGS) and APP_SPENDINGS <= 960 ) do;
GRP_APP_SPENDINGS  = 2 ;
WOE_APP_SPENDINGS  = -3.152832413 ;
end;
when ( 960 < APP_SPENDINGS ) do;
GRP_APP_SPENDINGS  = 1 ;
WOE_APP_SPENDINGS  = -2.543804291 ;
end;
otherwise do;
GRP_APP_SPENDINGS  = 1 ;
WOE_APP_SPENDINGS  = -2.543804291 ;
end; end;
keep &keep;
if _error_=1 then _error_=0;
run;