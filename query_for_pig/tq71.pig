IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q71

I = item();
D = date_dim();
WS = web_sales();
CS = catalog_sales();
SS = store_sales();
TD = time_dim();

FD1 = FILTER D BY d_moy == 12 AND d_year == 2000;
J1 = JOIN FD1 BY d_date_sk, WS BY ws_sold_date_sk;
F1 = FOREACH J1 GENERATE ws_ext_sales_price AS ext_price,
	ws_sold_date_sk AS sold_date_sk,
	ws_item_sk AS sold_item_sk,
	ws_sold_time_sk AS time_sk;

FD2 = FILTER D BY d_moy == 12 AND d_year == 2000;
J2 = JOIN FD2 BY d_date_sk, CS BY cs_sold_date_sk;
F2 = FOREACH J2 GENERATE cs_ext_sales_price AS ext_price,
	cs_sold_date_sk AS sold_date_sk,
	cs_item_sk AS sold_item_sk,
	cs_sold_time_sk AS time_sk;

FD3 = FILTER D BY d_moy == 12 AND d_year == 2000;
J3 = JOIN FD3 BY d_date_sk, SS BY ss_sold_date_sk;
F3 = FOREACH J3 GENERATE ss_ext_sales_price AS ext_price,
	ss_sold_date_sk AS sold_date_sk,
	ss_item_sk AS sold_item_sk,
	ss_sold_time_sk AS time_sk;

U1 = UNION F1, F2;
U2 = UNION U1, F3;

FI = FILTER I BY i_manager_id == 1;
FTD = FILTER TD BY t_meal_time == 'breakfast' OR t_meal_time == 'dinner';

J4 = JOIN U2 BY sold_item_sk, FI BY i_item_sk;
J5 = JOIN J4 BY time_sk, FTD BY t_time_sk;

G1 = GROUP J5 BY (i_brand, i_brand_id, t_hour, t_minute);

F4 = FOREACH G1 GENERATE
	group.i_brand_id,
	group.i_brand,
	group.t_hour,
	group.t_minute,
	SUM(J5.ext_price) AS ext_price;
	
O1 = ORDER F4 BY ext_price DESC,
	i_brand_id;

L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q71' USING PigStorage('|');