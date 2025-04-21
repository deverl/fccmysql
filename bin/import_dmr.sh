#!/bin/bash

curl -s -o user.csv https://radioid.net/static/user.csv

RET=$?

if [ $RET -ne 0 ]; then
    echo "Error downloading user.csv"
    exit 1
fi

echo "Updating DB with DMR data..."

mysql -u fccuser -pfccuser < bin/import_dmr.sql
