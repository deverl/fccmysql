#!/bin/bash

if [ ! -f l_amat.zip ]
then
    echo "No zip file found!"
    exit 1
fi


echo "Extracting..."

unzip -o l_amat.zip

echo "Creating DB..."

mysql -u fccuser -pfccuser < bin/mkdbs.sql


