IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q85

WS = web_sales();
WR = web_returns();
WP = web_page();
CD = customer_demographics();
CA = customer_address();
D = date_dim();
R = reason();

FD = FILTER D BY d_year == 1998;
FCA = FILTER CA BY ca_country == 'United States' AND (ca_state == 'KY'
	OR ca_state == 'GA'
	OR ca_state == 'NM'
	OR ca_state == 'MT'
	OR ca_state == 'OR'
	OR ca_state == 'IN'
	OR ca_state == 'WI'
	OR ca_state == 'MO'
	OR ca_state == 'WV'
	);
FWS = FILTER WS BY ws_sales_price >= 50.00 AND ws_sales_price <= 200.00 AND ws_net_profit >= 50 AND ws_net_profit <= 250;
FCD1 = FOREACH CD GENERATE cd_demo_sk AS cd1_demo_sk,
	cd_marital_status AS cd1_marital_status,
	cd_education_status AS cd1_education_status;
FCD2 = FOREACH CD GENERATE cd_demo_sk AS cd2_demo_sk,
	cd_marital_status AS cd2_marital_status,
	cd_education_status AS cd2_education_status;



J1 = JOIN FWS BY ws_web_page_sk, WP BY wp_web_page_sk;
J2 = JOIN J1 BY (ws_item_sk, ws_order_number), WR BY (wr_item_sk, wr_order_number);
J3 = JOIN J2 BY ws_sold_date_sk, FD BY d_date_sk;
J4 = JOIN J3 BY wr_refunded_cdemo_sk, FCD1 BY cd1_demo_sk;
J5 = JOIN J4 BY wr_returning_cdemo_sk, FCD2 BY cd2_demo_sk;
J6 = JOIN J5 BY wr_refunded_addr_sk, FCA BY ca_address_sk;
J7 = JOIN J6 BY wr_reason_sk, R BY r_reason_sk;

FJ7 = FILTER J7 BY cd1_marital_status == cd2_marital_status
	AND cd1_education_status == cd2_education_status
	AND ( (cd1_marital_status == 'M' AND cd1_education_status == '4 yr Degree' AND ws_sales_price >= 100.00 AND ws_sales_price <= 150.00)
		OR (cd1_marital_status == 'D' AND cd1_education_status == 'Primary' AND ws_sales_price >= 50.00 AND ws_sales_price <= 100.00)
		OR (cd1_marital_status == 'U' AND cd1_education_status == 'Advanced Degree' AND ws_sales_price >= 150.00 AND ws_sales_price <= 200.00))
	AND ( (ws_net_profit >= 100 AND ws_net_profit <= 200 AND (ca_state == 'KY' OR ca_state == 'GA' OR ca_state == 'NM'))
		OR (ws_net_profit >= 150 AND ws_net_profit <= 300 AND (ca_state == 'MT' OR ca_state == 'OR' OR ca_state == 'IN'))
		OR (ws_net_profit >= 50 AND ws_net_profit <= 250 AND (ca_state == 'WI' OR ca_state == 'MO' OR ca_state == 'MV')));

G1 = GROUP FJ7 BY r_reason_desc;

F1 = FOREACH G1 GENERATE
	group.r_reason_desc,
	SUBSTRING(group.r_reason_desc, 1, 20) AS sub_r_reason_desc,
	AVG(FJ7.ws_quantity) AS avg_ws_quantity,
	AVG(FJ7.wr_refunded_cash) AS avg_wr_refunded_cash,
	AVG(FJ7.wr_fee) AS avg_wr_fee;


O1 = ORDER F1 BY sub_r_reason_desc,
	avg_ws_quantity,
	avg_wr_refunded_cash,
	avg_wr_fee;

L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q85' USING PigStorage('|');