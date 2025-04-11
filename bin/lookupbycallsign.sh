#!/bin/bash 

SQL="use fcc; select en.call_sign, hd.license_status, am.operator_class, en.first_name, en.last_name, en.city, en.state from en join hd on hd.sys_id = en.sys_id join am on am.sys_id = en.sys_id where (en.call_sign like"

FIRST=1
while [ $# -gt 0 ]
do
    if [ $FIRST -ne 1 ]
    then
        SQL="$SQL or en.call_sign like"
    fi
    SQL="$SQL \"$1\""
    shift
    FIRST=0
done

SQL="$SQL) and license_status = \"A\";"

echo $SQL > /tmp/fcc.sql

mysql -u fccuser -pfccuser < /tmp/fcc.sql

