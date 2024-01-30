#!/bin/bash

# link to SPS database at CMC

SPS_DBASE=/fs/ssm/eccc/mrd/rpn/models/sps/sps-data/dfiles

if [ ! -d ${SPS_DBASE} ] ; then
    echo "${SPS_DBASE} not found: don't know where database is."
    exit 1
fi

# remove possible existing link or file, and create symbolic link, 
# or display an error message (for example if a directory named sps_dbase already exists)
\rm -f sps_dbase && ln -s ${SPS_DBASE} sps_dbase || ( echo "sps_dbase cannot be removed" && exit 2)
