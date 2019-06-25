set (LIB_NAME flogging)
file(GLOB sources ./*.f90)
add_library ( ${LIB_NAME} ${sources})
target_include_directories(${LIB_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/../include)

set(CMAKE_WITH_MPI OFF CACHE STRING "build the module with MPI, so it can be executed using mpirun")
# if cmake provides a findLIBRARY module, this gets invoked via find_package(LIBRARY)
if (CMAKE_WITH_MPI)
        # find if there is an MPI setup on the system and if so, set corresponding variables
        find_package(MPI)
        if (NOT ${MPI_Fortran_FOUND})
                message(FATAL_ERROR "MPI required but not found")
        else()
                message(STATUS "found MPI_Fortran_COMPILER ${MPI_Fortran_COMPILER}")
                # set the preprocessor
                target_compile_definitions(${LIB_NAME} PRIVATE "-DUSE_MPI")
				# add the link to mpi if existing
                target_link_libraries(${LIB_NAME} ${MPI_Fortran_LIBRARIES} )
                target_include_directories(${LIB_NAME} PUBLIC ${MPI_Fortran_INCLUDE_PATH} )
        endif()
endif()
# add some compiler flags based on ${LIB_NAME} module
set(MY_DEBUG_OPTIONS "-DENABLE_LOG_TRACE")
set(MY_RELEASE_OPTIONS "-DDISABLE_LOG_DEBUG")
target_compile_options(${LIB_NAME} PUBLIC "$<$<CONFIG:DEBUG>:${MY_DEBUG_OPTIONS}>")
target_compile_options(${LIB_NAME} PUBLIC "$<$<CONFIG:RELEASE>:${MY_RELEASE_OPTIONS}>")

# ifort and gfortran need the flag -cpp to interpret definitions like -DMRM2MHM
# the nag compiler is not able to interpret the flag -cpp but can interpret these definitions anyway
# so we check whether the compiler is able to use the flag -cpp
# for that we need the module CheckFortranCompilerFlag
include(CheckFortranCompilerFlag)
CHECK_Fortran_COMPILER_FLAG("-cpp" CPP_FLAG)
# if the flag exists, we add it to the compilation flags
if (CPP_FLAG)
	target_compile_options(${LIB_NAME} PUBLIC "-cpp")
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
	target_compile_options(${LIB_NAME} PUBLIC "-ffree-line-length-none")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "NAG")
	target_compile_definitions(${LIB_NAME} PRIVATE "-DNAG")
	target_compile_options(${LIB_NAME} PUBLIC "-kind=byte")
endif()

set_target_properties ( ${LIB_NAME}
  PROPERTIES
  LINK_FLAGS " ${MPI_Fortran_LINK_FLAGS}"
  #Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
)

target_include_directories( ${LIB_NAME} PUBLIC ${CMAKE_CURRENT_BINARY_DIR})

enable_testing()
add_subdirectory(./tests)