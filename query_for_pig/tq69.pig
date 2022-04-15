IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q69

SS = store_sales();
D = date_dim();
S = stores();
HD = household_demographics();
CA = customer_address();
CD = customer_demographics();
C = customer();
WS = web_sales();

----------------------------------------------------------------------------------------





----------------------------------------------------------------------------------------
c.c_current_addr_sk = ca.ca_address_sk and
  ca_state in ('CO','IL','MN') and
  cd_demo_sk = c.c_current_cdemo_sk and

J1 = join C by c_current_addr_sk, CA by ca_address_sk;
J1F1 = filter J1 by ca_state == 'CO' or ca_state == 'IL' or ca_state == 'MN';
R1 = join J1F1 by c_current_cdemo_sk, DA by cd_demo_sk;



-------------------

E1_J1 = join SS by ss_customer_sk, C by c_customer_sk;
E1_J2 = join E1J1 by ss_sold_date_sk, DD by d_date_sk;

E1_J_F1 = filter E1J2 by (
                        d_year == 1999
                        and d_moy >= 1
                        and d_moy <= 1+2
                        );

---------------------

E2_J1 = join WS by ws_bill_customer_sk, C by c_customer_sk;
E2_J2 = join E2J1 by ws_sold_date_sk, DD by d_date_sk;

E2_J_F1 = filter E2_J2 by (
                        d_year > 1999
                        or d_year < 1999
                        or d_moy < 1
                        or d_moy > 1+2
                        );

---------------------

E3_J1 = join CS by cs_ship_customer_sk, C by cs_ship_customer_sk;
E3_J2 = join E3_J1 by cs_sold_date_sk, DD by d_date_sk;

E3_J_F1 = filter E3_J2 by (
                        d_year > 1999
                        or d_year < 1999
                        or d_moy < 1
                        or d_moy > 1+2
                        );

-----------------------


R2 = join E1_J_F1 by d_date_sk, E2_J_F1 by d_date_sk;
R3 = join E2_J_F1 by d_date_sk, E3_J_F1 by d_date_sk;

R4 = join R1 by d_date_sk, R3 by d_date_sk;


G1 = GROUP R4 BY (cd_gender,
          cd_marital_status,
          cd_education_status,
          cd_purchase_estimate,
          cd_credit_rating);

R5 = foreach G1 generate group as cd_gender,
                                  cd_marital_status,
                                  cd_education_status,
                                  cd_purchase_estimate,
                                  cd_credit_rating,
                                  COUNT($1) as cnt1,
                                  count($1) as cnt2,
                                  count($1) as cnt3;

OR5 = order R5 by cd_gender,
                  cd_marital_status,
                  cd_education_status,
                  cd_purchase_estimate,
                  cd_credit_rating;

LR5 = limit OR5 100;

STORE LR5 INTO '$output_path/Q69' USING PigStorage('|');













