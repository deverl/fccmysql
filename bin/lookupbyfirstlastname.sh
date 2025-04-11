#!/bin/bash 

SQL="select en.call_sign, hd.license_status, am.operator_class, en.first_name, en.last_name, en.city, en.state from en left join hd on hd.sys_id = en.sys_id left join am on am.sys_id = en.sys_id where en.first_name like \"$1%\" and en.last_name like \"$2%\""

echo $SQL > /tmp/fcc.sql

sqlite3 fcculs.db < /tmp/fcc.sql

