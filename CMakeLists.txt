cmake_minimum_required(VERSION 3.8)
project(aubio C)

include(CheckIncludeFile)

add_definitions(
	-DHAVE_STDLIB_H=1
	-DHAVE_STDIO_H=1
	-DHAVE_MATH_H=1
	-DHAVE_STRING_H=1
	-DHAVE_LIMITS_H=1
	-DHAVE_STDARG_H=1
	-DHAVE_C99_VARARGS_MACROS=1
)
if (WIN32)
	if (MSVC)
		add_definitions(
			-D_CRT_SECURE_NO_WARNINGS=1
		)
	endif()
	add_definitions(
		-DHAVE_WIN_HACKS
	)
endif()

if (APPLE)
	set_property(GLOBAL PROPERTY BLA_VENDOR Apple)
	set(BLAS_FLAG -DHAVE_ACCELERATE=1)
else()
	set_property(GLOBAL PROPERTY BLA_VENDOR OpenBLAS)
	set(BLAS_FLAG -DHAVE_BLAS=1)
endif()

find_package(BLAS REQUIRED MODULE)
find_package(FFTW3 COMPONENTS single REQUIRED MODULE)

if(NOT FFTW3_FOUND OR NOT BLAS_FOUND)
	message(ERROR "fftw3 and BLAS required to build aubio, but one or both of them cannot be found.")
else()
	CHECK_INCLUDE_FILE(openblas/cblas.h OPENBLAS_HEADER QUIET)
	
	if (OPENBLAS_HEADER)
		set(BLAS_FLAG ${BLAS_FLAG} -DHAVE_OPENBLAS_CBLAS_H=1)	
	else()
		CHECK_INCLUDE_FILE(cblas.h OPENBLAS_HEADER QUIET)
		set(BLAS_FLAG ${BLAS_FLAG} -DHAVE_CBLAS_H=1)
	endif()

	add_definitions(
		-DHAVE_FFTW3F=1
		${BLAS_FLAG}
	)
endif()

set(CMAKE_DEBUG_POSTFIX d)

file(GLOB_RECURSE SOURCES src/*.c)

add_library(aubio STATIC)

include_directories(
	src
	${FFTW3_INCLUDE_DIR}
)

target_sources(aubio PRIVATE
	${SOURCES}
)

target_link_libraries(aubio PUBLIC
	${BLAS_LIBRARIES}
	${FFTW3F_LIBRARY}
)

#install(
#	TARGETS aubio
#	RUNTIME DESTINATION bin
#	LIBRARY DESTINATION lib
#	ARCHIVE DESTINATION lib
#)
#
#if(NOT DISABLE_INSTALL_HEADERS)
#	install(
#		DIRECTORY src/
#		DESTINATION include/aubio
#		FILES_MATCHING
#		PATTERN "*.h"
#		PATTERN "*_priv.h" EXCLUDE
#		PATTERN "config.h" EXCLUDE
#	)
#endif()
