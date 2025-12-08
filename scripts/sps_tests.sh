#!/bin/bash
date
#export SPS_MODEL_DFILES=/home/viv001/site6/SPS_DATA/dfiles
echo "(1) testing tape1_grid (1min)" `date`
sps.sh --dircfg configurations/tape1_grid --ptopo=1x1x1 --btopo=1x1 --inorder > vlist_tape1_grid 2>&1
grep -ia "Status              :" vlist_tape1_grid
echo "(2) testing SPS_cfgs (svs) (1min)" `date`
sps.sh --dircfg configurations/SPS_cfgs --ptopo=2x2x1 --btopo=1x1 --inorder > vlist_SPS_cfgs_2x2 2>&1
grep -ia "Status              :" vlist_SPS_cfgs_2x2
echo "(3) testing SPS_isba_cfgs (isba) (1min)" `date`
sps.sh --dircfg configurations/SPS_isba_cfgs --ptopo=2x2x1 --btopo=1x1 --inorder > vlist_SPS_isba_cfgs_2x2 2>&1
grep -ia "Status              :" vlist_SPS_isba_cfgs_2x2
echo "(4) testing hrdlps (isba) (8min)" `date`
sps.sh --dircfg configurations/hrdlps --ptopo=4x20 --btopo=1x1 --inorder > vlist_hrdlps_4x20 2>&1
grep -ia "Status              :" vlist_hrdlps_4x20
echo "(5) testing caldas_hrdps_isba (2min)" `date`
sps.sh --dircfg configurations/caldas_hrdps_isba --ptopo=6x1 --btopo=1x1 --inorder > vlist_caldas_hrdps_isba_6x1 2>&1
grep -ia "Status              :" vlist_caldas_hrdps_isba_6x1
echo "(6) testing TEB_national (3min)" `date`
sps.sh --dircfg configurations/TEB_national --ptopo=8x10 --btopo=1x1 --inorder > vlist_TEB_national_8x10 2>&1
grep -ia "Status              :" vlist_TEB_national_8x10
echo "(7) testing CSLM_cfgs (3min)" `date`
sps.sh --dircfg configurations/CSLM_cfgs --ptopo=8x10 --btopo=1x1 --inorder > vlist_CSLM_cfgs_8x10 2>&1
grep -ia "Status              :" vlist_CSLM_cfgs_8x10
echo "(8) testing SVS2_cfgs (3min)" `date`
sps.sh --dircfg configurations/SVS2_cfgs --ptopo=6x6 --btopo=1x1 --inorder > vlist_SVS2_cfgs_6x6 2>&1
grep -ia "Status              :" vlist_SVS2_cfgs_6x6
echo "(9) testing svs1_freezing (3min)" `date`
sps.sh --dircfg configurations/svs1_freezing --ptopo=8x10 --btopo=1x1 --inorder > vlist_svs1_freezing_8x10 2>&1
grep -ia "Status              :" vlist_svs1_freezing_8x10
echo "(10) testing svs1_mosa (3min)" `date`
sps.sh --dircfg configurations/svs1_mosa --ptopo=4x20 --btopo=1x1 --inorder > vlist_svs1_mosa_4x20 2>&1
grep -ia "Status              :" vlist_svs1_mosa_4x20
date
ckstat=`grep "status=END" vlist_* | wc -l`
echo "$ckstat tests out of 10 succeeded"
