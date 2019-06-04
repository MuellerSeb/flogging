# message(STATUS "Testing enabled")
# include(CTest)
#
# add_custom_target(check COMMAND ${CMAKE_CTEST_COMMAND} -C $<CONFIG> --output-on-failure)
# add_custom_target(build_tests) # Make target to build all tests
# add_dependencies(build_tests flogging)
#
# #file ( COPY ./files
# #DESTINATION ${CMAKE_BINARY_DIR}/bin )
# # add_subdirectory(../src ${CMAKE_CURRENT_BINARY_DIR}/flogging)
#
# #set ( UNIT_TESTS '' )
# file ( GLOB sources ./test_*.f90)
# foreach ( UNIT_TEST ${sources} )
#     # get the filename and use it for variable name
#     get_filename_component ( test_name ${UNIT_TEST} NAME_WE )
#     message(STATUS "Testing enabled" ${UNIT_TEST})
#     add_executable ( ${test_name} EXCLUDE_FROM_ALL ${UNIT_TEST} )
#     target_link_libraries ( ${test_name} flogging)
#     add_dependencies ( check ${test_name} )
#     add_dependencies ( build_tests ${test_name} )
#     set_target_properties ( ${test_name}
#       PROPERTIES
#       RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
# 	  COMPILE_FLAGS "${CMAKE_Fortran_FLAGS} ${NETCDF_CFLAGS_OTHER} ${MPI_Fortran_COMPILE_FLAGS} ${OpenMP_Fortran_FLAGS} ${ADDITIONAL_GCC_FLAGS}"
# 	  PROPERTY LINK_FLAGS "${NETCDF_LDFLAGS_OTHER} ${MPI_Fortran_LINK_FLAGS}"
# 	  if (CMAKE_BUILD_MODULE_SYSTEM_INDEPENDENT)
# 	        INSTALL_RPATH "${CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES}"
# 	        BUILD_WITH_INSTALL_RPATH ON
# 	  endif()
# 	  )
#
#     add_test( NAME ${test_name}
#       WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/bin
#       COMMAND ./${test_name})
#     # list ( APPEND UNIT_TESTS ${test_name} )
# endforeach ( UNIT_TEST )
#
enable_testing()
file ( GLOB sources ./test_*.f90)
foreach ( UNIT_TEST ${sources} )
    # get the filename and use it for variable name
    get_filename_component ( test_name_ext ${UNIT_TEST} NAME )
    get_filename_component ( test_name ${UNIT_TEST} NAME_WLE )
	add_executable(${test_name} ${test_name_ext})
	set_target_properties ( ${test_name}
	  PROPERTIES
  COMPILE_FLAGS "${CMAKE_Fortran_FLAGS} ${MPI_Fortran_COMPILE_FLAGS} ${ADDITIONAL_GCC_FLAGS}"
  LINK_FLAGS " ${MPI_Fortran_LINK_FLAGS}"
	)
	target_link_libraries(${test_name} flogging)
	add_test(NAME ${test_name} COMMAND ${test_name})
endforeach ( UNIT_TEST )

#enable_testing()
#add_executable(test_flogging test_flogging.f90)
#set_target_properties ( test_flogging
#  PROPERTIES
#  COMPILE_FLAGS "${CMAKE_Fortran_FLAGS} ${MPI_Fortran_COMPILE_FLAGS} ${ADDITIONAL_GCC_FLAGS}"
#  LINK_FLAGS " ${MPI_Fortran_LINK_FLAGS}"
#)
#target_link_libraries(test_flogging flogging)
#add_test(NAME test_flogging COMMAND test_flogging)
