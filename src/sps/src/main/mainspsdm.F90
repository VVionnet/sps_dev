program sps
   use app
   use iso_fortran_env
   implicit none

#include <sps_build_info.h>

   app_ptr=app_init(0,PROJECT_NAME_STRING,VERSION,PROJECT_DESCRIPTION_STRING,BUILD_TIMESTAMP)
   call app_logstream("stdout")
   call app_libregister(APP_LIBVGRID,HAVE_VGRID//c_null_char)
   call app_libregister(APP_LIBTDPACK,HAVE_TDPACK//c_null_char)
   call app_libregister(APP_LIBPHY,phy_VERSION//c_null_char)
   call app_libregister(APP_LIBMDLUTIL,modelutils_VERSION//c_null_char)

   call spsdm
end program sps

