IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q76

SS = store_sales();
I = item();
D = date_dim();
WS = web_sales();
CS = catalog_sales();

FSS = FILTER SS BY ss_addr_sk IS NULL;
J1 = JOIN FSS BY ss_sold_date_sk, D BY d_date_sk;
J2 = JOIN J1 BY ss_item_sk, I BY i_item_sk;
F1 =  FOREACH J2 GENERATE 'store' AS channel,
	'ss_addr_sk' AS col_name,
	d_year,
	d_qoy,
	i_category,
	ss_ext_sales_price AS ext_sales_price;
	
FWS = FILTER WS BY ws_web_page_sk IS NULL;
J3 = JOIN FWS BY ws_sold_date_sk, D BY d_date_sk;
J4 = JOIN J3 BY ws_item_sk, I BY i_item_sk;
F2 = FOREACH J4 GENERATE 'web' AS channel,
	'ws_web_page_sk' AS col_name,
	d_year,
	d_qoy,
	i_category,
	ws_ext_sales_price AS ext_sales_price;
	
FCS = FILTER CS BY cs_warehouse_sk IS NULL;
J5 = JOIN FCS BY cs_sold_date_sk, D BY d_date_sk;
J6 = JOIN J5 BY cs_item_sk, I BY i_item_sk;
F3 = FOREACH J6 GENERATE 'catalog' AS channel,
	'cs_warehouse_sk' AS col_name,
	d_year,
	d_qoy,
	i_category,
	cs_ext_sales_price AS ext_sales_price;

U1 = UNION F1, F2;
U2 = UNION U1, F3;

G1 = GROUP U2 BY (channel, col_name, d_year, d_qoy, i_category);

F4 = FOREACH G1 GENERATE group.channel,
	group.col_name,
	group.d_year,
	group.d_qoy,
	group.i_category,
	COUNT_STAR(U2) AS sales_cnt,
	SUM(U2.ext_sales_price) AS sales_amt;
	
O1 = ORDER F4 BY channel,
	col_name,
	d_year,
	d_qoy,
	i_category;
	
L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q76' USING PigStorage('|');