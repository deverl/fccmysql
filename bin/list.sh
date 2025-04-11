#!/bin/bash

if [ "$(uname)" = "Darwin" ]
then
    ncftp wirelessftp.fcc.gov < bin/script_ls.ftp | grep l_amat.zip
else
    ftp -a wirelessftp.fcc.gov < bin/script_ls.ftp | grep l_amat.zip 
fi

