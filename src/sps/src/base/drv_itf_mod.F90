!---------------------------------- LICENCE BEGIN -------------------------------
! GEM - Library of kernel routines for the GEM numerical atmospheric model
! Copyright (C) 1990-2010 - Division de Recherche en Prevision Numerique
!                       Environnement Canada
! This library is free software; you can redistribute it and/or modify it 
! under the terms of the GNU Lesser General Public License as published by
! the Free Software Foundation, version 2.1 of the License. This library is
! distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
! without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
! PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
! You should have received a copy of the GNU Lesser General Public License
! along with this library; if not, write to the Free Software Foundation, Inc.,
! 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
!---------------------------------- LICENCE END ---------------------------------

!/@*
module drv_itf_mod
   use, intrinsic :: iso_fortran_env, only: REAL64, INT64
   use iso_c_binding
   use rpn_comm_itf_mod
   use clib_itf_mod, only: clib_tolower, clib_getenv
   use wb_itf_mod
   use env_utils
   use str_mod
   use rmn_gmm
   use config_mod, only: config_init
   use drv_ptopo_mod, only: drv_ptopo_init,drv_ptopo_terminate
   use drv_path_mod, only: drv_path_config_dir0_S
   use drv_time_mod, only: drv_time_config,drv_time_init,drv_time_info,drv_time_increment
   use drv_grid_mod, only: drv_grid_config,drv_grid_init
   use drv_levels_mod, only: drv_levels_config,drv_levels_init
   implicit none
   private
   !@objective Main Driver API
   !@author  Stephane Chamberland, 2012-03
   ! Public functions
   public :: drv_config,drv_init,drv_verbosity, &
        drv_ptopo_init,drv_ptopo_terminate, &
        drv_time_info,drv_time_increment
   ! 
   ! Public constants
   ! 
   ! Public var
   !@Description
   !*@/
!!!#include <arch_specific.hf>
#include <rmnlib_basics.hf>

contains

   !/@*
   function drv_config(F_cfg_basename_S) result(F_istat)
      use App
      implicit none
      !@arguments
      character(len=*),intent(out) :: F_cfg_basename_S
      !@return
      integer :: F_istat
      !*@/
      !---------------------------------------------------------------------
      F_istat = clib_getenv('UM_EXEC_CONFIG_BASENAME',F_cfg_basename_S)
      if (.not.RMN_IS_OK(F_istat)) then
         call Lib_Log(APP_LIBSPSDYN,APP_WARNING,'(drv_config) UM_EXEC_CONFIG_BASENAME not defined, trying with default settings file, model_settings')
         F_cfg_basename_S = './model_settings'
      endif
      call config_init(drv_path_config_dir0_S)
      F_istat = drv_grid_config(F_cfg_basename_S)
      F_istat = min(drv_levels_config(F_cfg_basename_S),F_istat)
      F_istat = min(drv_time_config(F_cfg_basename_S),F_istat)
      !---------------------------------------------------------------------
      return
   end function drv_config


   !/@*
   function drv_init(F_dateo_S,F_dt_8,F_stepno,F_ntimelevels) result(F_istat)
      implicit none
      !@arguments
      character(len=*),intent(out) :: F_dateo_S
      real(REAL64),intent(out) :: F_dt_8
      integer,intent(out) :: F_stepno
      integer,intent(in) :: F_ntimelevels
      !@return
      integer :: F_istat
      !*@/
      logical :: is_chkpt,is_last
      !---------------------------------------------------------------------
      F_istat = drv_grid_init()
      F_istat = min(drv_levels_init(),F_istat)
      F_istat = min(drv_time_init(F_dateo_S,F_dt_8,F_stepno,is_chkpt,is_last,F_ntimelevels),F_istat)
      !---------------------------------------------------------------------
      return
   end function drv_init


   !/@*
   subroutine drv_verbosity(F_prefix_S)
      use App
      implicit none
      !@objective Set verbosity
      !@argument
      character(len=*),intent(in) :: F_prefix_S
      !@author  Stephane Chamberland, 2011-09
      !*@/
      integer :: istat
      character(len=256) :: tmp_S,prefix_S
      logical :: debug_L
      !---------------------------------------------------------------------
      prefix_S = F_prefix_S
      if (len_trim(prefix_S) > 0) prefix_S = trim(prefix_S)//'_'

      istat = clib_getenv(trim(prefix_S)//'VERBOSITY',tmp_S)
      if (RMN_IS_OK(istat)) then
         call str_tab2space(tmp_S)
         tmp_S = adjustl(tmp_S)
         istat = clib_tolower(tmp_S)
         select case(tmp_S(1:1))
         case('d')
            tmp_S='debug'
            istat = App_LogLevelNo(APP_DEBUG)

            call handle_error_setdebug(debug_L)
         case('p')
            tmp_S='plus'
            istat = App_LogLevelNo(APP_TRIVIAL)
            istat = Lib_LogLevelNo(APP_LIBFST,APP_INFO);
            istat = Lib_LogLevelNo(APP_LIBWB,APP_WARNING);
            istat = Lib_LogLevelNo(APP_LIBGMM,APP_ERROR);
         case('w')
            tmp_S='warn'
            istat = App_LogLevelNo(APP_WARNING)
            istat = Lib_LogLevelNo(APP_LIBFST,APP_ERROR);
            istat = Lib_LogLevelNo(APP_LIBWB,APP_WARNING);
            istat = Lib_LogLevelNo(APP_LIBGMM,APP_ERROR);
         case('e')
            tmp_S='error'
            istat = App_LogLevelNo(APP_ERROR)
         case('c')
            tmp_S='critical'
            istat = App_LogLevelNo(APP_FATAL)
         case('i')
            tmp_S='info'
            istat = App_LogLevelNo(APP_INFO)
            istat = Lib_LogLevelNo(APP_LIBFST,APP_ERROR);
            istat = Lib_LogLevelNo(APP_LIBWB,APP_WARNING);
            istat = Lib_LogLevelNo(APP_LIBGMM,APP_ERROR);
         end select
         call Lib_Log(APP_LIBSPSDYN,APP_INFO,'(drv) Set Verbosity Level='//trim(tmp_S))
      endif
      !---------------------------------------------------------------------
      return
   end subroutine drv_verbosity


end module drv_itf_mod
