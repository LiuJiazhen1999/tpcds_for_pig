IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q50

SS = store_sales();
SR = store_returns();
S = stores();
D = date_dim();

FD2 = FILTER D BY d_year == 2000 AND d_moy == 9;

J1 = JOIN SS BY (ss_ticket_number, ss_item_sk, ss_customer_sk), SR BY (sr_ticket_number, sr_item_sk, sr_customer_sk);
J2 = JOIN J1 BY ss_store_sk, S BY s_store_sk;
J3 = JOIN J2 BY ss_sold_date_sk, D BY d_date_sk;
J4 = JOIN J3 BY sr_returned_date_sk, FD2 BY d_date_sk;

G1 = GROUP J4 BY (s_store_name, s_company_id, s_street_number, s_street_name, s_street_type, s_suite_number, s_city, s_county, s_state, s_zip);

F1 = FOREACH G1 GENERATE
	group.s_store_name,
	group.s_company_id,
	group.s_street_number,
	group.s_street_name,
	group.s_street_type,
	group.s_suite_number,
	group.s_city,
	group.s_county,
	group.s_state,
	group.s_zip,
	SUM((J4.sr_returned_date_sk - J4.ss_sold_date_sk <= 30) ? 1 : 0) AS day0,
	SUM(CASE WEHN ((J4.sr_returned_date_sk - J4.ss_sold_date_sk > 30) AND (J4.sr_returned_date_sk - J4.ss_sold_date_sk <= 60)) THEN 1 ELSE 0 END) AS day30,
	SUM(CASE WEHN ((J4.sr_returned_date_sk - J4.ss_sold_date_sk > 60) AND (J4.sr_returned_date_sk - J4.ss_sold_date_sk <= 90)) THEN 1 ELSE 0 END) AS day60,
	SUM(CASE WEHN ((J4.sr_returned_date_sk - J4.ss_sold_date_sk > 90) AND (J4.sr_returned_date_sk - J4.ss_sold_date_sk <= 120)) THEN 1 ELSE 0 END) AS day90,
	SUM(CASE WEHN (J4.sr_returned_date_sk - J4.ss_sold_date_sk > 120 ) THEN 1 ELSE 0 END) AS day120;

O1 = ORDER F1 BY s_store_name,
	s_company_id,
	s_street_number,
	s_street_name,
	s_street_type,
	s_suite_number,
	s_city,
	s_county,
	s_state,
	s_zip;

L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q50' USING PigStorage('|');