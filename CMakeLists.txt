cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/build/cmake_modules")

# FIXME - necessary for compiling the unit tests
add_definitions(-DDEBUG)

if(POLICY CMP0042)
  CMAKE_POLICY(SET CMP0042 NEW)
endif(POLICY CMP0042)
if(POLICY CMP0077)
   CMAKE_POLICY(SET CMP0077 NEW)
endif(POLICY CMP0077)

project(opensigcomp VERSION 0.9.4)

include(CheckSymbolExists)
include(GNUInstallDirs)
include(Utilities)

enable_testing()

# https://cmake.org/cmake/help/latest/module/FindThreads.html
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
find_package(Threads)
if(Threads_FOUND)
   add_definitions(-DUSE_POSIX_LOCKING)
else()
   if(WIN32)
      add_definitions(-DUSE_WINDOWS_LOCKING)
   else()
      exit()
   endif()
endif()
if(CMAKE_USE_PTHREADS_INIT)
   add_compile_definitions(_REENTRANT)
   add_compile_options(-pthread)
endif()

check_symbol_exists(realloc stdlib.h HAVE_REALLOC)
if(HAVE_REALLOC)
   add_definitions(-DHAVE_REALLOC)
endif()

option(OPENSSL_SHA1 "Use Open SSL SHA-1 implementation" TRUE)
option(RISC_OPTIMIZED "Optimize native SHA-1 implementation for RISC processors" FALSE)

if(WIN32)
   set(BUILD_SHARED_LIBS_DEFAULT OFF)
else()
   set(BUILD_SHARED_LIBS_DEFAULT ON)
endif()
option(BUILD_SHARED_LIBS "Build libraries as shared" ${BUILD_SHARED_LIBS_DEFAULT})

find_package(Perl REQUIRED)


if(OPENSSL_SHA1)
   find_package(OpenSSL REQUIRED)
   if(OPENSSL_FOUND)
      add_definitions(-DUSE_OPENSSL_SHA1)
      include_directories(${OPENSSL_INCLUDE_DIR})
   endif()
endif()

if(RISC_OPTIMIZED)
   add_definitions(-DRISC_OPTIMIZED)
endif()

add_subdirectory(src)
add_subdirectory(tools)


