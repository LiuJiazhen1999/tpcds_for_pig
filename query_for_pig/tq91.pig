IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q91

CC = call_center();
CR = catalog_returns();
D = date_dim();
C = customer();
CA = customer_address();
CD = customer_demographics();
HD = household_demographics();

FD = FILTER D BY d_year == 1999 AND d_moy == 11;
FCD = FILTER CD BY (cd_marital_status == 'M' AND cd_education_status == 'Unknown') OR (cd_marital_status == 'W' AND cd_education_status == 'Advanced Degree');
FHD = FILTER HD BY STARTSWITH(hd_buy_potential, '0-500');
FCA = FILTER CA BY ca_gmt_offset == -7;

J1 = JOIN CR BY cr_call_center_sk, CC BY cc_call_center_sk;
J2 = JOIN J1 BY cr_returned_date_sk, FD BY d_date_sk;
J3 = JOIN J2 BY cr_returning_customer_sk, C BY c_customer_sk;
J4 = JOIN J3 BY c_current_cdemo_sk, FCD BY cd_demo_sk;
J5 = JOIN J4 BY c_current_hdemo_sk, FHD BY hd_demo_sk;
J6 = JOIN J5 BY c_current_addr_sk, FCA BY ca_address_sk;

G1 = GROUP J6 BY (cc_call_center_id, cc_name, cc_manager, cd_marital_status, cd_education_status);
F1 = FOREACH G1 GENERATE group.cc_call_center_id,
	group.cc_name,
	group.cc_manager,
	SUM(J6.cr_net_loss) AS Returns_Loss;

O1 = ORDER F1 BY Returns_Loss DESC;

L1 = LIMIT O1 100;


STORE L1 INTO '$output_path/Q91' USING PigStorage('|');