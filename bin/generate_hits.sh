#!/bin/bash

echo "ip,city,region,country" > temp.csv

for A in $(ssh droplet '~/projects/fccmysql/bin/show_ips.sh' | sort | uniq)
do
    ipinfo $A | jq ".ip, .city, .region, .country" | tr "\n" "," >> temp.csv
    echo "" >> temp.csv
done


sed 's/,\s*$//' temp.csv > hits.csv

rm temp.csv

csvq "select * from hits order by country asc, region asc, city asc"

