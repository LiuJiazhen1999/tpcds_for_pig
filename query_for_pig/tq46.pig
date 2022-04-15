IMPORT 'tablesPlaintext.pig';
%default output_path '/tpcds/output'
RMF $output_path/Q46

SS = store_sales();
D = date_dim();
S = stores();
HD = household_demographics();
CA = customer_address();
C = customer();

FHD = FILTER HD BY hd_dep_count == 5 OR hd_vehicle_count == 3;
FD = FILTER D BY (d_dow == 6 OR d_dow == 0) AND (d_year == 1999 OR d_year == 2000 OR d_year == 2001);
FS = FILTER S BY s_city == 'Midway' OR s_city == 'Fairview' OR s_city == 'Fairview' OR s_city == 'Midway' OR s_city == 'Fairview';

J1 = JOIN SS BY ss_sold_date_sk, FD BY d_date_sk;
J2 = JOIN J1 BY ss_store_sk, FS BY s_store_sk;
J3 = JOIN J2 BY ss_hdemo_sk, FHD BY hd_demo_sk;
J4 = JOIN J3 BY ss_addr_sk, CA BY ca_address_sk;

G1 = GROUP J4 BY (ss_ticket_number, ss_customer_sk, ss_addr_sk, ca_city);


F1 = FOREACH G1 GENERATE
	group.ss_ticket_number,
	group.ss_customer_sk,
	group.ca_city AS bought_city,
	SUM(J4.ss_coupon_amt) AS amt,
	SUM(J4.ss_net_profit) AS profit;
	
J5 = JOIN F1 BY ss_customer_sk, C BY c_customer_sk;
J6 = JOIN J5 BY c_current_addr_sk, CA BY ca_address_sk;
C1 = CROSS F1, J6;


FJ6 = FILTER C1 BY ca_city != bought_city;

F2 = FOREACH FJ6 GENERATE
	c_last_name,
	c_first_name,
	ca_city,
	bought_city,
	ss_ticket_number,
	amt,
	profit;

O1 = ORDER F2 BY c_last_name,
	c_first_name,
	ca_city,
	bought_city,
	ss_ticket_number;

L1 = LIMIT O1 100;

STORE L1 INTO '$output_path/Q46' USING PigStorage('|');