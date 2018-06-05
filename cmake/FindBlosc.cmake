# FindBlosc
# =========
#
# Locate the Blosc.
#
# Imported targets
# ----------------
#
# This module defines the following `IMPORTED` targets:
#
# `Blosc::Blosc`
#  The Blosc library, if found
#
# Result variables
# ----------------
#
# This module will set the following variables in your project:
#
# `BLOSC_FOUND`
#  Found Blosc
# `BLOSC_INCLUDE_DIRS`
#  The directory containing the Blosc headers
# `BLOSC_LIBRARY`
#  The Blosc library
#
# Cache variables
# ---------------
#
# The following cache variables may also be set:
#
# `BLOSC_ROOT`
#  The root directory of the Google Test installation (may also be
#  set as an environment variable)
#
# Example usage
# -------------
#
# ```
# find_package(Blosc REQUIRED)
#
# add_executable(foo foo.cc)
# target_link_libraries(foo Blosc::Blosc)
# ```

find_path(BLOSC_INCLUDE_DIR 
    NAMES blosc.h
    HINTS
        $ENV{BLOSC_ROOT}/include
        ${BLOSC_ROOT}/include
        ${CMAKE_CURRENT_BINARY_DIR}/${THIRD_PARTY}/include
)

find_library(BLOSC_LIBRARY
    NAMES blosc
    HINTS
        $ENV{BLOSC_ROOT}
        ${BLOSC_ROOT}
        ${CMAKE_CURRENT_BINARY_DIR}/${THIRD_PARTY}/lib
)

mark_as_advanced(BLOSC_INCLUDE_DIR BLOSC_LIBRARY)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Blosc DEFAULT_MSG BLOSC_LIBRARY BLOSC_INCLUDE_DIR)

if(BLOSC_FOUND)
    if(NOT TARGET Blosc::Blosc)
        add_library(Blosc::Blosc INTERFACE IMPORTED)
        set_target_properties(Blosc::Blosc PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES ${BLOSC_INCLUDE_DIR}
        )
    endif()
else()
    include(ExternalProject)
    ExternalProject_Add(blosc
        GIT_REPOSITORY    https://github.com/Blosc/c-blosc.git
        GIT_TAG           v1.14.3
        PREFIX            ${THIRD_PARTY}
        CONFIGURE_COMMAND ${CMAKE_COMMAND}
                          -G "${CMAKE_GENERATOR}"
                          -DCMAKE_INSTALL_PREFIX=<INSTALL_DIR>
                          -DCMAKE_BUILD_TYPE=Release
                          -DBUILD_SHARED_LIBS=ON
                          <SOURCE_DIR>
        BUILD_COMMAND     ${CMAKE_COMMAND} --build .
        TEST_COMMAND      ""
        UPDATE_COMMAND    ""
        EXCLUDE_FROM_ALL  TRUE
        )

    ExternalProject_Get_Property(blosc INSTALL_DIR)

    add_library(Blosc::Blosc SHARED IMPORTED)
    set_target_properties(Blosc::Blosc PROPERTIES 
        IMPORTED_LOCATION ${INSTALL_DIR}/lib/libblosc${CMAKE_SHARED_LIBRARY_SUFFIX}
    )
    add_dependencies(Blosc::Blosc blosc)
endif()

