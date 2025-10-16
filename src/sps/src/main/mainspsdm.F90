program sps
   use App
   use iso_fortran_env
   use rpn_comm
   implicit none

#include <sps_build_info.h>

   integer :: ierror

   ! Initialisation
   app_ptr=app_init(0,PROJECT_NAME_STRING,VERSION,PROJECT_DESCRIPTION_STRING,BUILD_TIMESTAMP)
   call app_libregister(APP_LIBVGRID,HAVE_VGRID//c_null_char)
   call app_libregister(APP_LIBTDPACK,HAVE_TDPACK//c_null_char)
   call app_libregister(APP_LIBPHY,phy_VERSION//c_null_char)
   call app_libregister(APP_LIBMDLUTIL,modelutils_VERSION//c_null_char)

   call MPI_INIT(ierror)
   call app_start()

   ! Run
   call spsdm

   ! Finalisation
   app_status=app_end(0)

   call rpn_comm_barrier(RPN_COMM_WORLD, ierror)
   call rpn_comm_finalize(ierror)
end program sps

