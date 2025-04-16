#!/bin/bash

for A in $(ssh droplet '~/projects/fccmysql/bin/show_ips.sh' | sort | uniq)
do
    ipinfo $A | jq ".ip, .city, .country" | tr "\n" ", "
    echo ""
done

