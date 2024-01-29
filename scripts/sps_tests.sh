#!/bin/bash
date
echo "(1) testing tape1_grid (1min)" 
sps.sh --dircfg configurations/tape1_grid --ptopo=1x1x1 --btopo=1x1 > vlist_tape1_grid 2>&1
echo "(2) testing SPS_cfgs (svs) (1min)"
sps.sh --dircfg configurations/SPS_cfgs --ptopo=2x2x1 --btopo=1x1 > vlist_SPS_cfgs_2x2 2>&1
echo "(3) testing SPS_isba_cfgs (isba) (1min)"
sps.sh --dircfg configurations/SPS_isba_cfgs --ptopo=2x2x1 --btopo=1x1 > vlist_SPS_isba_cfgs_2x2 2>&1
echo "(4) testing hrdlps (isba) (8min)"
sps.sh --dircfg configurations/hrdlps --ptopo=4x20 --btopo=1x1 > vlist_hrdlps_4x20 2>&1
echo "(5) testing yin15 (isba) (10min)"
sps.sh --dircfg configurations/yin15 --ptopo=4x10 --btopo=1x1 > vlist_yin15_4x10 2>&1
echo "(6) testing yan15 (isba) (10min)"
sps.sh --dircfg configurations/yan15 --ptopo=4x10 --btopo=1x1 > vlist_yan15_4x10 2>&1
echo "(7) testing caldas_hrdps_isba (2min)"
sps.sh --dircfg configurations/caldas_hrdps_isba --ptopo=6x1 --btopo=1x1 > vlist_caldas_hrdps_isba_6x1 2>&1
date
ckstat=`grep "status=END" vlist_* | wc -l`
echo "$ckstat tests out of 7 succeeded"
