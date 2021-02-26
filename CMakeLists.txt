# This cmake file is not meant to be edited for a special setup.
# For special setups use cache line files or command line options, as described a few
# lines ahead concerning module INDEPENDENT builds
cmake_minimum_required(VERSION 3.5)

project(flogging Fortran)

# automatically enables testing
include(CTest)

# library module specific settings
add_subdirectory(./src)

