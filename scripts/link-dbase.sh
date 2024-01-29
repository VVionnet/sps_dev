#!/bin/bash

# link to SPS database at CMC


SPS_DBASE=/fs/ssm/eccc/mrd/rpn/models/sps/sps-data/dfiles

if [ -e ${SPS_DBASE} ] ; then
    if  [ ! -e sps_dbase ] ; then
        ln -sf ${SPS_DBASE} sps_dbase
    else
        echo "There is already a link to a database: please make sure it's the correct link:"
        ls -al sps_dbase
    fi
else
    echo "Database not found: don't know where database is."
fi
