IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q84

C = customer();
CA = customer_address();
CD = customer_demographics();
HD = household_demographics();
IB = income_band();
SR = store_returns();

FCA = FILTER CA BY ca_city == 'Hopewell';
FIB = FILTER IB BY ib_lower_bound >= 32287 AND ib_upper_bound <= 82287;

J1 = JOIN C BY c_current_addr_sk, FCA BY ca_address_sk;
J2 = JOIN J1 BY c_current_cdemo_sk, CD BY cd_demo_sk;
J3 = JOIN J2 BY c_current_hdemo_sk, HD BY hd_demo_sk;
J4 = JOIN J3 BY hd_income_band_sk, FIB BY ib_income_band_sk;
J5 = JOIN J4 BY cd_demo_sk, SR BY sr_cdemo_sk;

F1 = FOREACH J5 GENERATE c_customer_id as customer_id,
	CONCAT(coalesce(c_last_name,''), ', ', coalesce(c_first_name,'')) as customername;

O1 = ORDER F1 BY c_customer_id;

L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q84' USING PigStorage('|');