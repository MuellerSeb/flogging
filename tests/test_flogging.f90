#include "flogging.h"
program test_log
  use flogging
#ifdef USE_MPI
  use mpi
#endif

  implicit none
#ifdef USE_MPI
  integer :: ierr
#endif
! This is an example program showing logging with different levels( filenames and mpi )

  log_error(*) "this is an error"
  log_warn(*) "this is a warning"
  log_info(*) "here( have some info"
  log_debug(*) "and this is a debug message"

  log_debug(*) "and this is a debug message 2"
  log_error(*) "this is a warning"

  ! Enable date output
  call log_set_output_date(.true.)
  log_error(*) "Error from thread 0 with date"

#ifdef USE_MPI
  call MPI_Init(ierr)

  log_error(*) "help we had an error"
  log_root_warn(*) "this is a warning with a filename"
  log_root_info(*) "here( have some info with a filename"
  log_root_debug(*) "and this is a debug message"
  log_root_debug(*) "and this is a debug message 2"
  log_root_error(*) "this is a warning"

  ! Enable date output
  call log_set_default_output_date(.true.)
  log_root_error(*) "Error from thread 0 with line-info and mpi id and date"

  call MPI_Finalize(ierr)
#endif

end program
