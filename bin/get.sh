#!/bin/bash

bin/clean.sh

if [ "$(uname)" = "Darwin" ]
then
    ncftp wirelessftp.fcc.gov < bin/script_get.ftp
else
    ftp -a wirelessftp.fcc.gov < bin/script_get.ftp
fi

