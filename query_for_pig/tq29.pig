IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q29

SS = store_sales();
SR = store_returns();
CS = catalog_sales();
D = date_dim();
S = stores();
I = item();

FD1 = FILTER D BY d_moy == 4 AND d_year == 1999;
FD2 = FILTER D BY d_moy >= 4 AND d_moy <= 7 AND d_year == 1999;
FD3 = FILTER D BY d_year == 1999 OR d_year == 2000 OR d_year == 2001;

J1 = JOIN FD1 BY d_date_sk, SS BY ss_sold_date_sk;
J2 = JOIN J1 BY ss_item_sk, I BY i_item_sk;
J3 = JOIN J2 BY ss_store_sk, S BY s_store_sk;
J4 = JOIN J3 BY (ss_customer_sk, ss_item_sk, ss_ticket_number), SR BY (sr_customer_sk, sr_item_sk, sr_ticket_number);
J5 = JOIN J4 BY sr_ticket_number, FD2 BY d_date_sk;
J6 = JOIN J5 BY (sr_customer_sk, sr_item_sk), CS BY (cs_bill_customer_sk, cs_item_sk);
J7 = JOIN J6 BY cs_sold_date_sk, FD3 BY d_date_sk;

G1 = GROUP J7 BY (i_item_id, i_item_desc, s_store_id, s_store_name);

F1 = FOREACH G1 GENERATE
	group.i_item_id,
	group.i_item_desc,
	group.s_store_id,
	group.s_store_name,
	SUM(J7.ss_quantity) AS store_sales_quantity,
	SUM(J7.sr_return_quantity) AS store_returns_quantity,
	SUM(J7.cs_quantity) AS catalog_sales_quantity;

O1 = ORDER F1 BY i_item_id,
	i_item_desc,
	s_store_id,
	s_store_name;

L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q29' USING PigStorage('|');