enable_testing()
file ( GLOB sources ./test_*.F90)
foreach ( UNIT_TEST ${sources} )
    # get the filename and use it for variable name
    get_filename_component ( test_name_ext ${UNIT_TEST} NAME )
    get_filename_component ( test_name ${UNIT_TEST} NAME_WE )
	add_executable(${test_name} ${test_name_ext})
	set_target_properties ( ${test_name}
	  PROPERTIES
  COMPILE_FLAGS "${CMAKE_Fortran_FLAGS} ${MPI_Fortran_COMPILE_FLAGS} ${ADDITIONAL_GCC_FLAGS}"
  LINK_FLAGS " ${MPI_Fortran_LINK_FLAGS}"
# 	  if (CMAKE_BUILD_MODULE_SYSTEM_INDEPENDENT)
# 	        INSTALL_RPATH "${CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES}"
# 	        BUILD_WITH_INSTALL_RPATH ON
# 	  endif()
	)
	target_link_libraries(${test_name} flogging)
	add_test(NAME ${test_name} COMMAND ${test_name})
endforeach ( UNIT_TEST )
