IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q19

D = date_dim();
SS = store_sales();
I = item();
C = customer();
CA = customer_address();
S = stores();

FI = FILTER I BY i_manager_id == 7;
FD = FILTER D BY d_moy == 11 AND d_year == 1999;

J1 = JOIN FD BY d_date_sk, SS BY ss_sold_date_sk;
J2 = JOIN J1 BY ss_item_sk, FI BY i_item_sk;
J3 = JOIN J2 BY ss_customer_sk, C BY c_customer_sk;
J4 = JOIN J3 BY c_current_addr_sk, CA BY ca_address_sk;
J5 = JOIN J4 BY ss_store_sk, S BY s_store_sk;

FJ5 = FILTER J5 BY SUBSTRING(ca_zip, 1, 5) != SUBSTRING(s_zip, 1, 5);

G1 = GROUP FJ5 BY (i_brand, i_brand_id, i_manufact_id, i_manufact);

F1 = FOREACH G1 GENERATE
	group.i_brand_id,
	group.i_brand,
	group.i_manufact_id,
	group.i_manufact,
	SUM(FJ5.ss_ext_sales_price) AS ext_price;

O1 = ORDER F1 BY ext_price desc,
	i_brand,
	i_brand_id,
	i_manufact_id,
	i_manufact;

L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q19' USING PigStorage('|');
