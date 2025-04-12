CREATE DATABASE IF NOT EXISTS fcc;

use fcc;


-- Drop tables if they exist
DROP TABLE IF EXISTS hd;
DROP TABLE IF EXISTS en;
DROP TABLE IF EXISTS am;

-- Create table: hd
CREATE TABLE hd (
    record_type VARCHAR(10),
    sys_id BIGINT,
    file_number VARCHAR(20),
    ebf_number VARCHAR(20),
    call_sign VARCHAR(20),
    license_status VARCHAR(5),
    radio_service_code VARCHAR(10),
    grant_date VARCHAR(20),
    expired_date VARCHAR(20),
    cancellation_date VARCHAR(20),
    eligibility_rule_num VARCHAR(10),
    reserved1 VARCHAR(10),
    alien VARCHAR(5),
    alien_government VARCHAR(5),
    alien_corporation VARCHAR(5),
    alien_officer VARCHAR(5),
    alien_control VARCHAR(5),
    revoked VARCHAR(5),
    convicted VARCHAR(5),
    adjudged VARCHAR(5),
    reserved2 VARCHAR(10),
    common_carrier VARCHAR(5),
    non_common_carrier VARCHAR(5),
    private_comm VARCHAR(5),
    fixed VARCHAR(5),
    mobile VARCHAR(5),
    radiolocation VARCHAR(5),
    satellite VARCHAR(5),
    dev_sta_demo VARCHAR(5),
    interconnected_service VARCHAR(5),
    certifier_first_name VARCHAR(50),
    certifier_middle_initial VARCHAR(5),
    certifier_last_name VARCHAR(50),
    certifier_suffix VARCHAR(10),
    certifier_title VARCHAR(50),
    female VARCHAR(5),
    black_or_african_american VARCHAR(5),
    native_american VARCHAR(5),
    hawaiian VARCHAR(5),
    asian VARCHAR(5),
    white VARCHAR(5),
    hispanic VARCHAR(5),
    effective_date VARCHAR(20),
    last_action_date VARCHAR(20),
    auction_id INT,
    broadcast_regulatory_status VARCHAR(10),
    band_manager_regulatory_status VARCHAR(10),
    broadcast_services_type VARCHAR(10),
    alien_ruling VARCHAR(10),
    licensee_name_change VARCHAR(10),
    whitespace_indicator VARCHAR(5),
    operation_perf_requirement_choice VARCHAR(10),
    operation_perf_requirement_answer VARCHAR(10),
    discontinuation_of_service VARCHAR(10),
    regulatory_compliance VARCHAR(10),
    _900_mhz_eligibility_cert VARCHAR(10),
    _900_mhz_transition_plan_cert VARCHAR(10),
    _900_mhz_return_spectrum_cert VARCHAR(10),
    _900_mhz_payment_cert VARCHAR(10)
);

-- Create table: en
CREATE TABLE en (
    record_type VARCHAR(10),
    sys_id BIGINT,
    file_number VARCHAR(20),
    ebf_number VARCHAR(20),
    call_sign VARCHAR(20),
    entity_type VARCHAR(10),
    licensee_id VARCHAR(20),
    entity_name VARCHAR(100),
    first_name VARCHAR(50),
    middle_initial VARCHAR(5),
    last_name VARCHAR(50),
    suffix VARCHAR(10),
    phone VARCHAR(20),
    fax VARCHAR(20),
    email VARCHAR(100),
    street_address VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(10),
    zip VARCHAR(20),
    po_box VARCHAR(20),
    attention_line VARCHAR(100),
    sgin VARCHAR(20),
    frn VARCHAR(20),
    app_type_code VARCHAR(10),
    app_type_code_other VARCHAR(10),
    status_code VARCHAR(10),
    status_date VARCHAR(20),
    _37_ghz_lic_type VARCHAR(10),
    linked_sys_id BIGINT,
    linked_call_sign VARCHAR(20)
);

-- Create table: am
CREATE TABLE am (
    record_type VARCHAR(10),
    sys_id BIGINT,
    file_number VARCHAR(20),
    ebf_number VARCHAR(20),
    call_sign VARCHAR(20),
    operator_class VARCHAR(5),
    group_code VARCHAR(5),
    region_code VARCHAR(10),
    trustee_call_sign VARCHAR(20),
    trustee_indicator VARCHAR(5),
    physician_cert VARCHAR(5),
    ve_signature VARCHAR(5),
    systematic_call_sign_change VARCHAR(5),
    vanity_call_sign_change VARCHAR(5),
    vanity_relationship VARCHAR(10),
    previous_call_sign VARCHAR(20),
    previous_operator_class VARCHAR(5),
    trustee_name VARCHAR(100)
);

-- Create indexes
CREATE INDEX en_sys_id_index ON en (sys_id);
CREATE INDEX en_call_sign_index ON en (call_sign);
CREATE INDEX en_first_name_last_name_index ON en (first_name, last_name);
CREATE INDEX en_first_name_last_name_city_index ON en (first_name, last_name, city);
CREATE INDEX en_first_name_last_name_city_state_index ON en (first_name, last_name, city, state);
CREATE INDEX en_last_name_index ON en (last_name);
CREATE INDEX en_city_state_index ON en (city, state);
CREATE INDEX en_city ON en (city);
CREATE INDEX en_state ON en(state);
CREATE INDEX en_frn_index ON en (frn);

CREATE INDEX hd_sys_id_index ON hd (sys_id);
CREATE INDEX hd_call_sign_index ON hd (call_sign);
CREATE INDEX hd_license_status_index ON hd (license_status);
CREATE INDEX hd_certifier_first_name_certifier_last_name_index ON hd (certifier_first_name, certifier_last_name);
CREATE INDEX hd_grant_date_index ON hd (grant_date);

CREATE INDEX am_sys_id_index ON am (sys_id);
CREATE INDEX am_call_sign_index ON am (call_sign);
CREATE INDEX am_operator_class_index ON am (operator_class);


LOAD DATA LOCAL INFILE 'HD.dat'
INTO TABLE hd
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';


LOAD DATA LOCAL INFILE 'EN.dat'
INTO TABLE en
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';


LOAD DATA LOCAL INFILE 'AM.dat'
INTO TABLE am
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n';



SELECT en.call_sign,
       hd.license_status,
       am.operator_class,
       am.region_code,
       en.first_name,
       en.last_name
FROM en
     JOIN hd ON hd.sys_id = en.sys_id
     JOIN am ON am.sys_id = en.sys_id
WHERE en.call_sign in ("W7DNS", "KE7HT", "W6EPW", "KJ7MNO", "N7LRW", "KJ7ZMZ")
      AND license_status = "A"
      ORDER BY en.last_name ASC, en.first_name ASC
;




