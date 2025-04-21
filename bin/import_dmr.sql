use fcc;

DROP TABLE IF EXISTS dmr;


-- RADIO_ID,CALLSIGN,FIRST_NAME,LAST_NAME,CITY,STATE,COUNTRY


-- Create table: dmr
CREATE TABLE dmr (
    radio_id VARCHAR(20),
    call_sign VARCHAR(20),
    first_name VARCHAR(30),
    last_name VARCHAR(40),
    city VARCHAR(40),
    state VARCHAR(30),
    country VARCHAR(30)
);


CREATE INDEX dmr_call_sign_index ON dmr (call_sign);
CREATE INDEX dmr_first_last_name_index ON dmr (first_name, last_name);
CREATE INDEX dmr_first_last_name_city_index ON dmr (first_name, last_name, city);
CREATE INDEX dmr_first_last_name_city_state_index ON dmr (first_name, last_name, city, state);
CREATE INDEX dmr_last_name_index ON dmr (last_name);
CREATE INDEX dmr_city_state_index ON dmr (city, state);
CREATE INDEX dmr_city ON dmr (city);
CREATE INDEX dmr_state ON dmr(state);


LOAD DATA LOCAL INFILE 'user.csv'
INTO TABLE dmr
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n';



