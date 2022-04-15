%default input_path 's3a://inputtpcds50'

DEFINE customer() RETURNS A {
  $A = LOAD '$input_path/customer.dat' USING PigStorage('|') AS (
    c_customer_sk			:biginteger,
    c_customer_id			:chararray,
    c_current_cdemo_sk		:biginteger,
    c_current_hdemo_sk		:biginteger,
    c_current_addr_sk		:biginteger,
    c_first_shipto_date_sk	:biginteger,
    c_first_sales_date_sk	:biginteger,
    c_salutation			:chararray,
    c_first_name			:chararray,
    c_last_name				:chararray,
    c_preferred_cust_flag	:chararray,
    c_birth_day				:biginteger,
    c_birth_month			:biginteger,
    c_birth_year			:biginteger,
    c_birth_country			:chararray,
    c_login					:chararray,
    c_email_address			:chararray,
    c_last_review_date_sk	:biginteger);
};

DEFINE customer_address() RETURNS A {
  $A = LOAD '$input_path/customer_address.dat' USING PigStorage('|') AS (
    ca_address_sk		:biginteger,
    ca_address_id		:chararray,
    ca_street_number	:chararray,
    ca_street_name		:chararray,
    ca_street_type		:chararray,
    ca_suite_number		:chararray,
    ca_city				:chararray,
    ca_county			:chararray,
    ca_state			:chararray,
    ca_zip				:chararray,
    ca_country			:chararray,
    ca_gmt_offset		:double,
    ca_location_type	:chararray);
};

DEFINE customer_demographics() RETURNS A {
  $A = LOAD '$input_path/customer_demographics.dat' USING PigStorage('|') AS (
    cd_demo_sk				:biginteger,
    cd_gender				:chararray,
    cd_marital_status		:chararray,
    cd_education_status		:chararray,
    cd_purchase_estimate	:biginteger,
    cd_credit_rating		:chararray,
    cd_dep_count			:biginteger,
    cd_dep_employed_count	:biginteger,
    cd_dep_college_count	:biginteger);
};

DEFINE date_dim() RETURNS A {
  $A = LOAD '$input_path/date_dim.dat' USING PigStorage('|') AS (
    d_date_sk			:biginteger,
    d_date_id			:chararray,
    d_date				:chararray,
    d_month_seq			:biginteger,
    d_week_seq			:biginteger,
    d_quarter_seq		:biginteger,
    d_year				:biginteger,
    d_dow				:biginteger,
    d_moy				:biginteger,
    d_dom				:biginteger,
    d_qoy				:biginteger,
    d_fy_year			:biginteger,
    d_fy_quarter_seq	:biginteger,
    d_fy_week_seq		:biginteger,
    d_day_name			:chararray,
    d_quarter_name		:chararray,
    d_holiday			:chararray,
    d_weekend			:chararray,
    d_following_holiday	:chararray,
    d_first_dom			:biginteger,
    d_last_dom			:biginteger,
    d_same_day_ly		:biginteger,
    d_same_day_lq		:biginteger,
    d_current_day		:chararray,
    d_current_week		:chararray,
    d_current_month		:chararray,
    d_current_quarter	:chararray,
    d_current_year		:chararray);
};

DEFINE household_demographics() RETURNS A {
  $A = LOAD '$input_path/household_demographics.dat' USING PigStorage('|') AS (
    hd_demo_sk			:biginteger,
    hd_income_band_sk	:biginteger,
    hd_buy_potential	:chararray,
    hd_dep_count		:biginteger,
    hd_vehicle_count	:biginteger);
};

DEFINE item() RETURNS A {
  $A = LOAD '$input_path/item.dat' USING PigStorage('|') AS (
    i_item_sk			:biginteger,
    i_item_id			:chararray,
    i_rec_start_date	:chararray,
    i_rec_end_date		:chararray,
    i_item_desc			:chararray,
    i_current_price		:double,
    i_wholesale_cost	:double,
    i_brand_id			:biginteger,
    i_brand				:chararray,
    i_class_id			:biginteger,
    i_class				:chararray,
    i_category_id		:biginteger,
    i_category			:chararray,
    i_manufact_id		:biginteger,
    i_manufact			:chararray,
    i_size				:chararray,
    i_formulation		:chararray,
    i_color				:chararray,
    i_units				:chararray,
    i_container			:chararray,
    i_manager_id		:biginteger,
    i_product_name		:chararray);
};

DEFINE promotion() RETURNS A {
  $A = LOAD '$input_path/promotion.dat' USING PigStorage('|') AS (
    p_promo_sk			:biginteger,
    p_promo_id			:chararray,
    p_start_date_sk		:biginteger,
    p_end_date_sk		:biginteger,
    p_item_sk			:biginteger,
    p_cost				:double,
    p_response_target	:biginteger,
    p_promo_name		:chararray,
    p_channel_dmail		:chararray,
    p_channel_email		:chararray,
    p_channel_catalog	:chararray,
    p_channel_tv		:chararray,
    p_channel_radio		:chararray,
    p_channel_press		:chararray,
    p_channel_event		:chararray,
    p_channel_demo		:chararray,
    p_channel_details	:chararray,
    p_purpose			:chararray,
    p_discount_active	:chararray);
};

DEFINE stores() RETURNS A {
  $A = LOAD '$input_path/store.dat' USING PigStorage('|') AS (
    s_store_sk			:biginteger,
    s_store_id			:chararray,
    s_rec_start_date	:chararray,
    s_rec_end_date		:chararray,
    s_closed_date_sk	:biginteger,
    s_store_name		:chararray,
    s_number_employees	:biginteger,
    s_floor_space		:biginteger,
    s_hours				:chararray,
    s_manager			:chararray,
    s_market_id			:biginteger,
    s_geography_class	:chararray,
    s_market_desc		:chararray,
    s_market_manager	:chararray,
    s_division_id		:biginteger,
    s_division_name		:chararray,
    s_company_id		:biginteger,
    s_company_name		:chararray,
    s_street_number		:chararray,
    s_street_name		:chararray,
    s_street_type		:chararray,
    s_suite_number		:chararray,
    s_city				:chararray,
    s_county			:chararray,
    s_state				:chararray,
    s_zip				:chararray,
    s_country			:chararray,
    s_gmt_offset		:double,
    s_tax_precentage	:double);
};

DEFINE store_sales() RETURNS A {
  $A = LOAD '$input_path/store_sales.dat' USING PigStorage('|') AS (
    ss_sold_date_sk			:biginteger,
    ss_sold_time_sk			:biginteger,
    ss_item_sk				:biginteger,
    ss_customer_sk			:biginteger,
    ss_cdemo_sk				:biginteger,
    ss_hdemo_sk				:biginteger,
    ss_addr_sk				:biginteger,
    ss_store_sk				:biginteger,
    ss_promo_sk				:biginteger,
    ss_ticket_number		:biginteger,
    ss_quantity				:biginteger,
    ss_wholesale_cost		:double,
    ss_list_price			:double,
    ss_sales_price			:double,
    ss_ext_discount_amt		:double,
    ss_ext_sales_price		:double,
    ss_ext_wholesale_cost	:double,
    ss_ext_list_price		:double,
    ss_ext_tax				:double,
    ss_coupon_amt			:double,
    ss_net_paid				:double,
    ss_net_paid_inc_tax		:double,
    ss_net_profit			:double);
};

DEFINE store_returns() RETURNS A {
  $A = LOAD '$input_path/store_returns.dat' USING PigStorage('|') AS (
	  sr_returned_date_sk  	:biginteger,
      sr_return_time_sk    	:biginteger,
      sr_item_sk           	:biginteger,
      sr_customer_sk       	:biginteger,
      sr_cdemo_sk          	:biginteger,
      sr_hdemo_sk          	:biginteger,
      sr_addr_sk           	:biginteger,
      sr_store_sk           :biginteger,
      sr_reason_sk         	:biginteger,
      sr_ticket_number     	:biginteger,
      sr_return_quantity   	:biginteger,
      sr_return_amt        	:double,
      sr_return_tax        	:double,
      sr_return_amt_inc_tax	:double,
      sr_fee               	:double,
      sr_return_ship_cost  	:double,
      sr_refunded_cash     	:double,
      sr_reversed_charge   	:double,
      sr_store_credit      	:double,
      sr_net_loss          	:double);
};

DEFINE catalog_sales() RETURNS A {
  $A = LOAD '$input_path/catalog_sales.dat' USING PigStorage('|') AS (
    cs_sold_date_sk 			:biginteger,
	cs_sold_time_sk 			:biginteger,
	cs_ship_date_sk 			:biginteger,
	cs_bill_customer_sk 		:biginteger,
	cs_bill_cdemo_sk 			:biginteger,
	cs_bill_hdemo_sk 			:biginteger,
	cs_bill_addr_sk 			:biginteger,
	cs_ship_customer_sk 		:biginteger,
	cs_ship_cdemo_sk 			:biginteger,
	cs_ship_hdemo_sk 			:biginteger,
	cs_ship_addr_sk 			:biginteger,
	cs_call_center_sk 			:biginteger,
	cs_catalog_page_sk  		:biginteger,
	cs_ship_mode_sk 			:biginteger,
	cs_warehouse_sk 			:biginteger,
	cs_item_sk 					:biginteger,
	cs_promo_sk  				:biginteger,
	cs_order_number 			:biginteger,
	cs_quantity  				:biginteger,
	cs_wholesale_cost 			:double,
	cs_list_price 				:double,
	cs_sales_price  			:double,
	cs_ext_discount_amt 		:double,
	cs_ext_sales_price  		:double,
	cs_ext_wholesale_cost 		:double,
	cs_ext_list_price 			:double,
	cs_ext_tax 					:double,
	cs_coupon_amt 				:double,
	cs_ext_ship_cost 			:double,
	cs_net_paid  				:double,
	cs_net_paid_inc_tax 		:double,
	cs_net_paid_inc_ship  		:double,
	cs_net_paid_inc_ship_tax 	:double,
	cs_net_profit 				:double);
};

DEFINE web_sales() RETURNS A {
  $A = LOAD '$input_path/web_sales.dat' USING PigStorage('|') AS (
     ws_sold_date_sk          :biginteger,
      ws_sold_time_sk          :biginteger,
      ws_ship_date_sk          :biginteger,
      ws_item_sk               :biginteger,
      ws_bill_customer_sk      :biginteger,
      ws_bill_cdemo_sk         :biginteger,
      ws_bill_hdemo_sk         :biginteger,
      ws_bill_addr_sk          :biginteger,
      ws_ship_customer_sk      :biginteger,
      ws_ship_cdemo_sk         :biginteger,
      ws_ship_hdemo_sk         :biginteger,
      ws_ship_addr_sk          :biginteger,
      ws_web_page_sk           :biginteger,
      ws_web_site_sk           :biginteger,
      ws_ship_mode_sk          :biginteger,
      ws_warehouse_sk          :biginteger,
      ws_promo_sk              :biginteger,
      ws_order_number          :biginteger,
      ws_quantity              :biginteger,
      ws_wholesale_cost        :chararray,
      ws_list_price            :chararray,
      ws_sales_price           :double,
      ws_ext_discount_amt      :chararray,
      ws_ext_sales_price       :double,
      ws_ext_wholesale_cost    :chararray,
      ws_ext_list_price        :chararray,
      ws_ext_tax               :chararray,
      ws_coupon_amt            :chararray,
      ws_ext_ship_cost         :chararray,
      ws_net_paid              :chararray,
      ws_net_paid_inc_tax      :chararray,
      ws_net_paid_inc_ship     :chararray,
      ws_net_paid_inc_ship_tax :chararray,
      ws_net_profit            :double);
};

DEFINE time_dim() RETURNS A {
  $A = LOAD '$input_path/time_dim.dat' USING PigStorage('|') AS (
      t_time_sk                 :biginteger,
      t_time_id                 :chararray,
      t_time                    :biginteger,
      t_hour                    :biginteger,
      t_minute                  :biginteger,
      t_second                  :biginteger,
      t_am_pm                   :chararray,
      t_shift                   :chararray,
      t_sub_shift               :chararray,
      t_meal_time               :chararray);
};

DEFINE income_band() RETURNS A {
  $A = LOAD '$input_path/income_band.dat' USING PigStorage('|') AS (
      ib_income_band_sk         :biginteger,
      ib_lower_bound            :biginteger,
      ib_upper_bound            :biginteger);
};

DEFINE web_returns() RETURNS A {
  $A = LOAD '$input_path/web_returns.dat' USING PigStorage('|') AS (
      wr_returned_date_sk      :biginteger,
      wr_returned_time_sk      :biginteger,
      wr_item_sk               :biginteger,
      wr_refunded_customer_sk  :biginteger,
      wr_refunded_cdemo_sk     :biginteger,
      wr_refunded_hdemo_sk     :biginteger,
      wr_refunded_addr_sk      :biginteger,
      wr_returning_customer_sk :biginteger,
      wr_returning_cdemo_sk    :biginteger,
      wr_returning_hdemo_sk    :biginteger,
      wr_returning_addr_sk     :biginteger,
      wr_web_page_sk           :biginteger,
      wr_reason_sk             :biginteger,
      wr_order_number          :biginteger,
      wr_return_quantity       :biginteger,
      wr_return_amt            :chararray,
      wr_return_tax            :chararray,
      wr_return_amt_inc_tax    :chararray,
      wr_fee                   :biginteger,
      wr_return_ship_cost      :chararray,
      wr_refunded_cash         :biginteger,
      wr_reversed_charge       :chararray,
      wr_account_credit        :chararray,
      wr_net_loss              :chararray);
};

DEFINE web_page() RETURNS A {
  $A = LOAD '$input_path/web_page.dat' USING PigStorage('|') AS (
      wp_web_page_sk           :biginteger,
      wp_web_page_id           :chararray,
      wp_rec_start_date        :chararray,
      wp_rec_end_date          :chararray,
      wp_creation_date_sk      :biginteger,
      wp_access_date_sk        :biginteger,
      wp_autogen_flag          :chararray,
      wp_customer_sk           :biginteger,
      wp_url                   :chararray,
      wp_type                  :chararray,
      wp_char_count            :biginteger,
      wp_link_count            :biginteger,
      wp_image_count           :biginteger,
      wp_max_ad_count          :biginteger);
};

DEFINE reason() RETURNS A {
  $A = LOAD '$input_path/reason.dat' USING PigStorage('|') AS (
	  r_reason_sk               :biginteger,
      r_reason_id               :chararray,
      r_reason_desc             :chararray);
};

DEFINE call_center() RETURNS A {
  $A = LOAD '$input_path/call_center.dat' USING PigStorage('|') AS (
	  cc_call_center_sk        :biginteger,
      cc_call_center_id        :chararray,
      cc_rec_start_date        :chararray,
      cc_rec_end_date          :chararray,
      cc_closed_date_sk        :biginteger,
      cc_open_date_sk          :biginteger,
      cc_name                  :chararray,
      cc_class                 :chararray,
      cc_employees             :biginteger,
      cc_sq_ft                 :biginteger,
      cc_hours                 :chararray,
      cc_manager               :chararray,
      cc_mkt_id                :biginteger,
      cc_mkt_class             :chararray,
      cc_mkt_desc              :chararray,
      cc_market_manager        :chararray,
      cc_division              :biginteger,
      cc_division_name         :chararray,
      cc_company               :biginteger,
      cc_company_name          :chararray,
      cc_street_number         :chararray,
      cc_street_name           :chararray,
      cc_street_type           :chararray,
      cc_suite_number          :chararray,
      cc_city                  :chararray,
      cc_county                :chararray,
      cc_state                 :chararray,
      cc_zip                   :chararray,
      cc_country               :chararray,
      cc_gmt_offset            :double,
      cc_tax_percentage        :double);
};

DEFINE catalog_returns() RETURNS A {
  $A = LOAD '$input_path/catalog_returns.dat' USING PigStorage('|') AS (
	  cr_returned_time_sk      :biginteger,
      cr_item_sk               :biginteger,
      cr_refunded_customer_sk  :biginteger,
      cr_refunded_cdemo_sk     :biginteger,
      cr_refunded_hdemo_sk     :biginteger,
      cr_refunded_addr_sk      :biginteger,
      cr_returning_customer_sk :biginteger,
      cr_returning_cdemo_sk    :biginteger,
      cr_returning_hdemo_sk    :biginteger,
      cr_returning_addr_sk     :biginteger,
      cr_call_center_sk        :biginteger,
      cr_catalog_page_sk       :biginteger,
      cr_ship_mode_sk          :biginteger,
      cr_warehouse_sk          :biginteger,
      cr_reason_sk             :biginteger,
      cr_order_number          :biginteger,
      cr_return_quantity       :biginteger,
      cr_return_amount         :chararray,
      cr_return_tax            :chararray,
      cr_return_amt_inc_tax    :chararray,
      cr_fee                   :chararray,
      cr_return_ship_cost      :chararray,
      cr_refunded_cash         :chararray,
      cr_reversed_charge       :chararray,
      cr_store_credit          :chararray,
      cr_net_loss              :chararray);
};