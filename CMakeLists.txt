cmake_minimum_required(VERSION 3.0)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake/")

include(HunterGate)
HunterGate(URL "https://github.com/ruslo/hunter/archive/v0.19.89.tar.gz"
           SHA1 "98bf8e401fff1394e8df0a757772265511dd9084")

project(Libevent LANGUAGES C VERSION 2.1.8)

string(REGEX MATCH "SunOS" SOLARIS "${CMAKE_SYSTEM_NAME}")

include(AddCompilerFlags)
include(PlatformChecks)

option(EVENT__DISABLE_DEBUG_MODE
    "Define if libevent should build without support for a debug mode" OFF)

option(EVENT__ENABLE_VERBOSE_DEBUG
    "Enables verbose debugging" OFF)

option(EVENT__DISABLE_MM_REPLACEMENT
    "Define if libevent should not allow replacing the mm functions" OFF)

option(EVENT__DISABLE_THREAD_SUPPORT
    "Define if libevent should not be compiled with thread support" OFF)

option(EVENT__DISABLE_OPENSSL
    "Define if libevent should build without support for OpenSSL encryption" OFF)

option(EVENT__DISABLE_BENCHMARK
    "Defines if libevent should build without the benchmark exectuables" OFF)

option(EVENT__DISABLE_TESTS
    "If tests should be compiled or not" OFF)

option(EVENT__DISABLE_REGRESS
    "Disable the regress tests" OFF)

option(EVENT__DISABLE_SAMPLES
    "Disable sample files" OFF)

option(EVENT__DISABLE_CLOCK_GETTIME
    "Do not use clock_gettime even if it is available" OFF)

option(EVENT__FORCE_KQUEUE_CHECK
    "When crosscompiling forces running a test program that verifies that Kqueue works with pipes. Note that this requires you to manually run the test program on the the cross compilation target to verify that it works. See cmake documentation for try_run for more details" OFF)

# TODO: Add --disable-largefile     omit support for large files
option(EVENT__COVERAGE
"Enable running gcov to get a test coverage report (only works with GCC/CLang). Make sure to enable -DCMAKE_BUILD_TYPE=Debug as well." OFF)

if (EVENT__ENABLE_VERBOSE_DEBUG)
    list(APPEND __DEFINITIONS "USE_DEBUG=1")
endif()

# Setup compiler flags for coverage.
if (EVENT__COVERAGE)
    if (NOT "${CMAKE_BUILD_TYPE_LOWER}" STREQUAL "debug")
        message(FATAL_ERROR "Coverage requires -DCMAKE_BUILD_TYPE=Debug")
    endif()

    message(STATUS "Setting coverage compiler flags")

    set(CMAKE_REQUIRED_LIBRARIES "--coverage")
    add_compiler_flags(-g -O0 --coverage)
    set(CMAKE_REQUIRED_LIBRARIES "")
endif()

# GCC specific options.
if (CMAKE_COMPILER_IS_GNUCC)
    option(EVENT__DISABLE_GCC_WARNINGS "Disable verbose warnings with GCC" OFF)
    option(EVENT__ENABLE_GCC_HARDENING "Enable compiler security checks" OFF)
    option(EVENT__ENABLE_GCC_FUNCTION_SECTIONS "Enable gcc function sections" OFF)
    option(EVENT__ENABLE_GCC_WARNINGS "Make all GCC warnings into errors" OFF)

    list(APPEND __FLAGS -Wall -Wswitch)

    if (EVENT__DISABLE_GCC_WARNINGS)
        list(APPEND __FLAGS -w)
    endif()

    if (EVENT__ENABLE_GCC_HARDENING)
        list(APPEND __FLAGS
             -fstack-protector-all
             -fwrapv
             -fPIE
             -Wstack-protector
             "--param ssp-buffer-size=1")

        list(APPEND __DEFINITIONS _FORTIFY_SOURCE=2)
    endif()

    if (EVENT__ENABLE_GCC_FUNCTION_SECTIONS)
        list(APPEND __FLAGS -ffunction-sections)
        # TODO: Add --gc-sections support. We need some checks for NetBSD to ensure this works.
    endif()

    if (EVENT__ENABLE_GCC_WARNINGS)
        list(APPEND __FLAGS -Werror)
    endif()

    # We need to test for at least gcc 2.95 here, because older versions don't
    # have -fno-strict-aliasing
    list(APPEND __FLAGS -fno-strict-aliasing)

    add_compiler_flags(${__FLAGS})
endif()

if (APPLE)
    # Get rid of deprecated warnings for OpenSSL on OSX 10.7 and greater.
    add_compiler_flags(
        -Wno-error=deprecated-declarations
        -Qunused-arguments
    )
endif()

PlatformChecks()

set(EVENT_NUMERIC_VERSION 0x02020001)

set(HDR_PRIVATE
    bufferevent-internal.h
    changelist-internal.h
    defer-internal.h
    epolltable-internal.h
    evbuffer-internal.h
    event-internal.h
    evmap-internal.h
    evrpc-internal.h
    evsignal-internal.h
    evthread-internal.h
    ht-internal.h
    http-internal.h
    iocp-internal.h
    ipv6-internal.h
    log-internal.h
    minheap-internal.h
    mm-internal.h
    ratelim-internal.h
    strlcpy-internal.h
    util-internal.h
    evconfig-private.h
    compat/sys/queue.h)

set(HDR_COMPAT
    include/evdns.h
    include/evrpc.h
    include/event.h
    include/evhttp.h
    include/evutil.h)

set(HDR_PUBLIC
    include/event2/buffer.h
    include/event2/bufferevent.h
    include/event2/bufferevent_compat.h
    include/event2/bufferevent_struct.h
    include/event2/buffer_compat.h
    include/event2/dns.h
    include/event2/dns_compat.h
    include/event2/dns_struct.h
    include/event2/event.h
    include/event2/event_compat.h
    include/event2/event_struct.h
    include/event2/http.h
    include/event2/http_compat.h
    include/event2/http_struct.h
    include/event2/keyvalq_struct.h
    include/event2/listener.h
    include/event2/rpc.h
    include/event2/rpc_compat.h
    include/event2/rpc_struct.h
    include/event2/tag.h
    include/event2/tag_compat.h
    include/event2/thread.h
    include/event2/util.h
    include/event2/visibility.h
    ${PROJECT_BINARY_DIR}/include/event2/event-config.h)

set(SRC_CORE
    buffer.c
    bufferevent.c
    bufferevent_filter.c
    bufferevent_pair.c
    bufferevent_ratelim.c
    bufferevent_sock.c
    event.c
    evmap.c
    evthread.c
    evutil.c
    evutil_rand.c
    evutil_time.c
    listener.c
    log.c
    signal.c
    strlcpy.c)

if(EVENT__HAVE_SELECT)
    list(APPEND SRC_CORE select.c)
endif()

if(EVENT__HAVE_POLL)
    list(APPEND SRC_CORE poll.c)
endif()

if(EVENT__HAVE_KQUEUE)
    list(APPEND SRC_CORE kqueue.c)
endif()

if(EVENT__HAVE_DEVPOLL)
    list(APPEND SRC_CORE devpoll.c)
endif()

if(EVENT__HAVE_EPOLL)
    list(APPEND SRC_CORE epoll.c)
endif()

if(EVENT__HAVE_EVENT_PORTS)
    list(APPEND SRC_CORE evport.c)
endif()

if (NOT EVENT__DISABLE_OPENSSL)
    hunter_add_package(OpenSSL)
    find_package(OpenSSL REQUIRED)

    set(EVENT__HAVE_OPENSSL 1)

    message(STATUS "OpenSSL include: ${OPENSSL_INCLUDE_DIR}")
    message(STATUS "OpenSSL lib: ${OPENSSL_LIBRARIES}")

    list(APPEND SRC_OPENSSL bufferevent_openssl.c)
    list(APPEND HDR_PUBLIC include/event2/bufferevent_ssl.h)
    list(APPEND LIB_APPS ${OPENSSL_LIBRARIES})
endif()

if (NOT EVENT__DISABLE_THREAD_SUPPORT)
    if (WIN32)
        list(APPEND SRC_CORE evthread_win32.c)
    else()
        find_package(Threads REQUIRED)
        if (NOT CMAKE_USE_PTHREADS_INIT)
            message(FATAL_ERROR
                    "Failed to find Pthreads, set EVENT__DISABLE_THREAD_SUPPORT to disable")
        endif()

        set(EVENT__HAVE_PTHREADS 1)
    endif()
endif()

if (NOT EVENT__DISABLE_TESTS)
    # Zlib is only used for testing.
    hunter_add_package(ZLIB)
    find_package(ZLIB REQUIRED)

    set(EVENT__HAVE_LIBZ 1)
endif()

if(WIN32)
    list(APPEND SRC_CORE
        buffer_iocp.c
        bufferevent_async.c
        event_iocp.c
        win32select.c)

    list(APPEND HDR_PRIVATE WIN32-Code/getopt.h)
    set(EVENT__DNS_USE_FTIME_FOR_ID 1)
endif()

if (SOLARIS)
    list(APPEND LIB_PLATFORM socket nsl)
endif()

source_group("Headers Private"  FILES ${HDR_PRIVATE})
source_group("Header Compat"    FILES ${HDR_COMPAT})
source_group("Headers Public"   FILES ${HDR_PUBLIC})
source_group("Source Core"      FILES ${SRC_CORE})
source_group("Source Extra"     FILES ${SRC_EXTRA})

# Generate the configure headers.
# (Place them in the build dir so we don't polute the source tree with generated
#  files).

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/event-config.h.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/include/event2/event-config.h
        NEWLINE_STYLE UNIX)

configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/evconfig-private.h.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/include/evconfig-private.h)

include_directories(BEFORE ${CMAKE_CURRENT_BINARY_DIR}/include)

if ((CMAKE_COMPILER_IS_GNUCC) OR
    ("${CMAKE_C_COMPILER_ID}" STREQUAL "Clang") OR
    ("${CMAKE_C_COMPILER_ID}" STREQUAL "AppleClang"))
    set(EVENT_SHARED_FLAGS -fvisibility=hidden)
elseif ("${CMAKE_C_COMPILER_ID}" STREQUAL "SunPro")
    set(EVENT_SHARED_FLAGS -xldscope=hidden)
endif()

add_library(event_core ${SRC_CORE})

target_compile_definitions(event_core PUBLIC HAVE_CONFIG_H ${__DEFINITIONS})
target_include_directories(event_core PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/compat>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/include>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>")

if(WIN32)
    target_compile_definitions(event_core PUBLIC _CRT_SECURE_NO_WARNINGS
                                                 _CRT_NONSTDC_NO_DEPRECATE)
    target_include_directories(event_core PRIVATE WIN32-Code)
    target_link_libraries(event_core ws2_32)
endif()

set(SRC_EXTRA
    event_tagging.c
    http.c
    evdns.c
    evrpc.c)
add_library(event_extra ${SRC_EXTRA})

target_link_libraries(event_extra PUBLIC event_core)

if (NOT EVENT__DISABLE_OPENSSL)
    add_library(event_openssl ${SRC_OPENSSL})
    target_link_libraries(event_openssl PUBLIC event_core
                                               OpenSSL::SSL
                                               OpenSSL::Crypto)
endif()

if (CMAKE_USE_PTHREADS_INIT)
    set(SRC_PTHREADS evthread_pthread.c)
    add_library(event_pthreads ${SRC_PTHREADS})
    target_link_libraries(event_pthreads PUBLIC event_core
                                                ${CMAKE_THREAD_LIBS_INIT})
endif()

####
# Installation (https://github.com/forexample/package-example)

# Layout. This works for all platforms:
#   * <prefix>/lib/cmake/<PROJECT-NAME>
#   * <prefix>/lib/
#   * <prefix>/include/
set(config_install_dir "lib/cmake/${PROJECT_NAME}")
set(include_install_dir "include")

set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

# Configuration
set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
set(targets_export_name "${PROJECT_NAME}Targets")
set(namespace "${PROJECT_NAME}::")

# Include module with fuction 'write_basic_package_version_file'
include(CMakePackageConfigHelpers)

# Configure '<PROJECT-NAME>ConfigVersion.cmake'
# Note: PROJECT_VERSION is used as a VERSION
write_basic_package_version_file(
    "${version_config}" COMPATIBILITY SameMajorVersion
)

# Configure '<PROJECT-NAME>Config.cmake'
# Use variables:
#   * targets_export_name
#   * PROJECT_NAME
configure_package_config_file(
    "cmake/Config.cmake.in"
    "${project_config}"
    INSTALL_DESTINATION "${config_install_dir}"
)

list(APPEND EVENT_LIBS event_core event_extra)
if(NOT EVENT__DISABLE_OPENSSL)
    list(APPEND EVENT_LIBS event_openssl)
endif()
if (CMAKE_USE_PTHREADS_INIT)
    list(APPEND EVENT_LIBS event_pthreads)
endif()

# Targets:
#   * <prefix>/lib/libevent_core.a
#   * <prefix>/lib/libevent_extra.a
#   * <prefix>/lib/libevent_openssl.a
#   * <prefix>/lib/libevent_pthreads.a
#   * header location after install: <prefix>/include
#   * headers can be included by C/C++ code `#include <...>`
install(
    TARGETS ${EVENT_LIBS}
    EXPORT "${targets_export_name}"
    LIBRARY DESTINATION "lib"
    ARCHIVE DESTINATION "lib"
    RUNTIME DESTINATION "bin"
    INCLUDES DESTINATION "${include_install_dir}"
)

# Headers:
#   * Source/foo/Bar.hpp -> <prefix>/include/foo/Bar.hpp
#   * Source/foo/Baz.hpp -> <prefix>/include/foo/Baz.hpp
install(
    FILES ${HDR_PUBLIC}
    DESTINATION "${include_install_dir}/event2"
)

install(
    FILES ${HDR_COMPAT}
    DESTINATION "${include_install_dir}"
)

# Config
#   * <prefix>/lib/cmake/Libevent/LibeventConfig.cmake
#   * <prefix>/lib/cmake/Libevent/LibeventConfigVersion.cmake
install(
    FILES "${project_config}" "${version_config}"
    DESTINATION "${config_install_dir}"
)

# Config
#   * <prefix>/lib/cmake/Libevent/LibeventTargets.cmake
install(
    EXPORT "${targets_export_name}"
    NAMESPACE "${namespace}"
    DESTINATION "${config_install_dir}"
)

set(WIN32_GETOPT)
if (WIN32)
    list(APPEND WIN32_GETOPT
         WIN32-Code/getopt.c
         WIN32-Code/getopt_long.c)
endif()

#
# Samples.
#
macro(add_sample_prog ssl name)
    add_executable(${name} ${ARGN})
    target_link_libraries(${name} PUBLIC ${EVENT_LIBS})
endmacro()
if (NOT EVENT__DISABLE_SAMPLES)
    set(SAMPLES
        event-read-fifo
        hello-world
        signal-test
        http-server
        http-connect
        time-test)

    foreach(SAMPLE ${SAMPLES})
        add_sample_prog(OFF ${SAMPLE} sample/${SAMPLE}.c)
    endforeach()

    if (NOT EVENT__DISABLE_OPENSSL)
        add_sample_prog(ON https-client
                        sample/https-client.c
                        sample/openssl_hostname_validation.c
                        sample/hostcheck.c)
        add_sample_prog(ON le-proxy
                        sample/le-proxy.c)
    endif()

    add_sample_prog(OFF dns-example sample/dns-example.c ${WIN32_GETOPT})
endif()

#
# Benchmarks
#
macro(add_bench_prog prog)
    add_executable(${prog} ${ARGN})
    target_link_libraries(${prog} ${EVENT_LIBS})
endmacro()

if (NOT EVENT__DISABLE_BENCHMARK)
    foreach (BENCHMARK bench_http bench_httpclient)
        add_bench_prog(${BENCHMARK} test/${BENCHMARK}.c)
    endforeach()

    add_bench_prog(bench test/bench.c ${WIN32_GETOPT})
    add_bench_prog(bench_cascade test/bench_cascade.c ${WIN32_GETOPT})
endif()

#
# Tests
#
macro(add_test_prog prog)
    add_executable(${prog} test/${prog}.c)
    target_link_libraries(${prog}
                          PUBLIC
                          ${EVENT_LIBS}
                          ${ZLIB_LIBRARIES}
                          ${ARGN})
endmacro()

if (NOT EVENT__DISABLE_TESTS)
    #
    # Generate Regress tests.
    #
    if (NOT EVENT__DISABLE_REGRESS)
        # (We require python2 to generate the regress tests)
        foreach (PY python2.6 python2.7 python2)
            unset(FIND_PYTHON2 CACHE)
            find_program(FIND_PYTHON2 ${PY})
            if (FIND_PYTHON2)
                set(PYTHON_EXECUTABLE "${PY}")
                break()
            endif()
        endforeach()
        find_package(PythonInterp)

        if (PYTHONINTERP_FOUND AND PYTHON_VERSION_STRING VERSION_LESS "3.0.0")
            set(__FOUND_USABLE_PYTHON 1)
        endif()

        if (__FOUND_USABLE_PYTHON)
            message(STATUS "Generating regress tests...")

            add_custom_command(
                OUTPUT
                    ${CMAKE_CURRENT_SOURCE_DIR}/test/regress.gen.c
                    ${CMAKE_CURRENT_SOURCE_DIR}/test/regress.gen.h
                DEPENDS
                    event_rpcgen.py
                    test/regress.rpc
                COMMAND ${PYTHON_EXECUTABLE} ../event_rpcgen.py regress.rpc
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/test)

            list(APPEND SRC_REGRESS
                 test/regress.c
                 test/regress.gen.c
                 test/regress.gen.h
                 test/regress_buffer.c
                 test/regress_bufferevent.c
                 test/regress_dns.c
                 test/regress_et.c
                 test/regress_finalize.c
                 test/regress_http.c
                 test/regress_listener.c
                 test/regress_main.c
                 test/regress_minheap.c
                 test/regress_rpc.c
                 test/regress_testutils.c
                 test/regress_testutils.h
                 test/regress_util.c
                 test/tinytest.c)

            if (WIN32)
                list(APPEND SRC_REGRESS test/regress_iocp.c)
                if (NOT EVENT__DISABLE_THREAD_SUPPORT)
                    list(APPEND SRC_REGRESS test/regress_thread.c)
                endif()
            elseif (CMAKE_USE_PTHREADS_INIT)
                list(APPEND SRC_REGRESS test/regress_thread.c)
            endif()

            list(APPEND SRC_REGRESS test/regress_zlib.c)

            if (NOT EVENT__DISABLE_OPENSSL)
                list(APPEND SRC_REGRESS test/regress_ssl.c)
            endif()

            add_executable(regress ${SRC_REGRESS})
            target_compile_definitions(regress PUBLIC TINYTEST_LOCAL)
            target_link_libraries(regress PUBLIC ${EVENT_LIBS} ${ZLIB_LIBRARIES})
        else()
            message(WARNING "No suitable Python interpreter found, cannot generate regress tests!")
        endif()
    endif()

    #
    # Test programs.
    #
    # all of these, including the CMakeLists.txt should be moved
    # into the directory 'tests' first.
    #
    # doing this, we can remove all the DISABLE_TESTS stuff, and simply
    # do something like:
    #
    # add_custom_targets(tests)
    # add_executable(... EXCLUDE_FROM_ALL ...c)
    # add_dependencies(tests testa testb testc)
    # add_test(....)
    #
    # then you can just run 'make tests' instead of them all
    # auto-compile|running
    # - ellzey
    set(TESTPROGS test-changelist
                  test-eof
                  test-fdleak
                  test-init
                  test-time
                  test-weof)

    foreach (TESTPROG ${TESTPROGS} test-dumpevents)
        add_test_prog(${TESTPROG})
    endforeach()
    if (UNIX)
        add_test_prog(test-ratelim m)
    else()
        add_test_prog(test-ratelim)
    endif()

    set(ALL_TESTPROGS
        ${TESTPROGS}
        test-dumpevents
        test-ratelim
    )

    #
    # We run all tests with the different backends turned on one at a time.
    #

    # Add event backends based on system introspection result.
    set(BACKENDS "")

    if (EVENT__HAVE_EPOLL)
        list(APPEND BACKENDS EPOLL)
    endif()

    if (EVENT__HAVE_SELECT)
        list(APPEND BACKENDS SELECT)
    endif()

    if (EVENT__HAVE_POLL)
        list(APPEND BACKENDS POLL)
    endif()

    if (EVENT__HAVE_KQUEUE)
        list(APPEND BACKENDS KQUEUE)
    endif()

    if (EVENT__HAVE_EVENT_PORTS)
        list(APPEND BACKENDS EVPORT)
    endif()

    if (EVENT__HAVE_DEVPOLL)
        list(APPEND BACKENDS DEVPOLL)
    endif()

    if (WIN32)
        list(APPEND BACKENDS WIN32)
    endif()


    # Default environment variables turns off all event systems,
    # then we enable each one, one at a time when creating the tests.
    set(DEFAULT_TEST_ENV_VARS "EVENT_SHOW_METHOD=1;")
    foreach(BACKEND ${BACKENDS})
        set(BACKEND_ENV_VAR "EVENT_NO${BACKEND}=1")
        list(APPEND DEFAULT_TEST_ENV_VARS "${BACKEND_ENV_VAR}")
    endforeach()

    # Macro that creates the ctest test for a backend.
    macro(add_backend_test BACKEND_TEST_NAME ENV_VARS)
        set(TEST_NAMES "")

        foreach (TESTPROG ${TESTPROGS})
            set(TEST_NAME ${TESTPROG}__${BACKEND_TEST_NAME})

            add_test(${TEST_NAME}
                     ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/${TESTPROG})

            list(APPEND TEST_NAMES ${TEST_NAME})

            set_tests_properties(${TEST_NAME}
                                 PROPERTIES ENVIRONMENT "${ENV_VARS}")
        endforeach()

        # Dump events test.
        if (__FOUND_USABLE_PYTHON)
            set(TEST_NAME test-dumpevents__${BACKEND_TEST_NAME})

            add_test(${TEST_NAME}
                     ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test-dumpevents |
                     ${PYTHON_EXECUTABLE}
                     ${CMAKE_CURRENT_SOURCE_DIR}/test/check-dumpevents.py)

            set_tests_properties(${TEST_NAME}
                                 PROPERTIES ENVIRONMENT "${ENV_VARS}")
        else()
            message(WARNING "test-dumpevents will be run without output check since python was not found!")
            set(TEST_NAME test-dumpevents__${BACKEND_TEST_NAME}_no_check)

            add_test(${TEST_NAME}
                     ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test-dumpevents)

            set_tests_properties(${TEST_NAME}
                                 PROPERTIES ENVIRONMENT "${ENV_VARS}")
        endif()

        # Regress tests.
        if (NOT EVENT__DISABLE_REGRESS AND __FOUND_USABLE_PYTHON)
            set(TEST_NAME regress__${BACKEND_TEST_NAME})

            add_test(${TEST_NAME}
                     ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/regress)

            set_tests_properties(${TEST_NAME}
                                 PROPERTIES ENVIRONMENT "${ENV_VARS}")

            add_test(${TEST_NAME}_debug
                     ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/regress)

            set_tests_properties(${TEST_NAME}_debug
                                 PROPERTIES ENVIRONMENT "${ENV_VARS};EVENT_DEBUG_MODE=1")
        endif()
    endmacro()

    # Add the tests for each backend.
    foreach(BACKEND ${BACKENDS})
        # Enable this backend only.
        set(BACKEND_ENV_VARS ${DEFAULT_TEST_ENV_VARS})
        list(REMOVE_ITEM BACKEND_ENV_VARS EVENT_NO${BACKEND}=1)

        # Epoll has some extra settings.
        if (${BACKEND} STREQUAL "EPOLL")
            add_backend_test(timerfd_${BACKEND}
                            "${BACKEND_ENV_VARS};EVENT_PRECISE_TIMER=1")

            add_backend_test(changelist_${BACKEND}
                            "${BACKEND_ENV_VARS};EVENT_EPOLL_USE_CHANGELIST=yes")

            add_backend_test(timerfd_changelist_${BACKEND}
                            "${BACKEND_ENV_VARS};EVENT_EPOLL_USE_CHANGELIST=yes;EVENT_PRECISE_TIMER=1")
        else()
            add_backend_test(${BACKEND} "${BACKEND_ENV_VARS}")
        endif()
    endforeach()

    #
    # Rate limiter tests.
    #

    # Group limits, no connection limit.
    set(RL_BIN ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/test-ratelim)

    add_test(test-ratelim__group_lim
             ${RL_BIN}
             -g 30000
             -n 30
             -t 100
             --check-grouplimit 1000
             --check-stddev 100)

    # Connection limit, no group limit.
    add_test(test-ratelim__con_lim
             ${RL_BIN}
             -c 1000
             -n 30
             -t 100
             --check-connlimit 50
             --check-stddev 50)

    # Connection limit and group limit.
    add_test(test-ratelim__group_con_lim
             ${RL_BIN}
             -c 1000
             -g 30000
             -n 30
             -t 100
             --check-grouplimit 1000
             --check-connlimit 50
             --check-stddev 50)

    # Connection limit and group limit with independent drain.
    add_test(test-ratelim__group_con_lim_drain
             ${RL_BIN}
             -c 1000
             -g 35000
             -n 30
             -t 100
             -G 500
             --check-grouplimit 1000
             --check-connlimit 50
             --check-stddev 50)

    # Add a "make verify" target, same as for autoconf.
    # (Important! This will unset all EVENT_NO* environment variables.
    #  If they are set in the shell the tests are running using simply "ctest" or "make test" will fail)
    if (WIN32)
        # Windows doesn't have "unset". But you can use "set VAR=" instead.
        # We need to guard against the possibility taht EVENT_NOWIN32 is set, and all test failing
        # since no event backend being available.
        file(TO_NATIVE_PATH ${CMAKE_CTEST_COMMAND} WINDOWS_CTEST_COMMAND)

        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/tmp/verify_tests.bat
            "
            set EVENT_NOWIN32=
            \"${WINDOWS_CTEST_COMMAND}\"
            ")

        message(STATUS "${WINDOWS_CTEST_COMMAND}")

        file(COPY ${CMAKE_CURRENT_BINARY_DIR}/tmp/verify_tests.bat
             DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
             FILE_PERMISSIONS
                             OWNER_READ
                             OWNER_WRITE
                             OWNER_EXECUTE
                             GROUP_READ
                             GROUP_EXECUTE
                             WORLD_READ WORLD_EXECUTE)

        file(TO_NATIVE_PATH
                    "${CMAKE_CURRENT_BINARY_DIR}/verify_tests.bat" VERIFY_PATH)

        add_custom_target(verify COMMAND "${VERIFY_PATH}"
                          DEPENDS event ${ALL_TESTPROGS})
    else()
        # On some platforms doing exec(unset) as CMake does won't work, so make sure
        # we run the unset command in a shell instead.
        # First we write the script contents.
        file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/tmp/verify_tests.sh
            "
            #!/bin/bash
            unset EVENT_NOEPOLL; unset EVENT_NOPOLL; unset EVENT_NOSELECT; unset EVENT_NOWIN32; unset EVENT_NOEVPORT; unset EVENT_NOKQUEUE; unset EVENT_NODEVPOLL
            ${CMAKE_CTEST_COMMAND}
            ")

        # Then we copy the file (this allows us to set execute permission on it)
        file(COPY ${CMAKE_CURRENT_BINARY_DIR}/tmp/verify_tests.sh
             DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
             FILE_PERMISSIONS
                             OWNER_READ
                             OWNER_WRITE
                             OWNER_EXECUTE
                             GROUP_READ
                             GROUP_EXECUTE
                             WORLD_READ
                             WORLD_EXECUTE)

        # Create the target that runs the script.
        add_custom_target(verify
                          COMMAND ${CMAKE_CURRENT_BINARY_DIR}/verify_tests.sh
                          DEPENDS event ${ALL_TESTPROGS})
    endif()

    if (NOT EVENT__DISABLE_REGRESS AND __FOUND_USABLE_PYTHON)
        add_dependencies(verify regress)
    endif()

    if (EVENT__COVERAGE)
        include(CodeCoverage)

        setup_target_for_coverage(
            verify_coverage # Coverage target name "make verify_coverage"
            make            # Test runner.
            coverage        # Output directory.
            verify)         # Arguments passed to test runner. "make verify"
    endif()

    enable_testing()

    include(CTest)
endif()

