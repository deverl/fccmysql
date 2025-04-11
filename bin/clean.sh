#!/bin/bash

CLEAN_ALL=0

while [ $# -gt 0 ]
do
    if [ "$1" = "-a" -o "$1" = "--clean-all" ]
    then
        CLEAN_ALL=1
    else
        echo "Unrecognized argument: $1"
        exit 1
    fi
    shift
done

rm -f *.dat *.csv counts fcculs.db

if [ $CLEAN_ALL -gt 0 ]
then
    rm -f l_amat.zip
fi
