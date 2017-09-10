macro(PlatformChecks)

include(CheckCSourceCompiles)
include(CheckConstExists)
include(CheckFileOffsetBits)
include(CheckFunctionExists)
include(CheckFunctionExistsEx)
include(CheckFunctionKeywords)
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckPrototypeDefinition)
include(CheckStructHasMember)
include(CheckSymbolExists)
include(CheckTypeSize)
include(CheckVariableExists)

# Winsock.
if(WIN32)
    set(CMAKE_EXTRA_INCLUDE_FILES winsock2.h ws2tcpip.h)
    set(CMAKE_REQUIRED_LIBRARIES  ws2_32.lib)
    set(CMAKE_REQUIRED_DEFINITIONS -FIwinsock2.h -FIws2tcpip.h)
endif()
if (SOLARIS)
    set(CMAKE_REQUIRED_LIBRARIES socket nsl)
endif()

# Check if _GNU_SOURCE is available.
if (NOT _GNU_SOURCE)
  CHECK_SYMBOL_EXISTS(__GNU_LIBRARY__ "features.h" _GNU_SOURCE)

  if (NOT _GNU_SOURCE)
    unset(_GNU_SOURCE CACHE)
    CHECK_SYMBOL_EXISTS(_GNU_SOURCE "features.h" _GNU_SOURCE)
  endif()
endif()

if (_GNU_SOURCE)
    list(APPEND __DEFINITIONS _GNU_SOURCE)
endif()

CHECK_INCLUDE_FILE(sys/types.h EVENT__HAVE_SYS_TYPES_H)
if(EVENT__HAVE_SYS_TYPES_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES sys/types.h)
endif()

CHECK_INCLUDE_FILE(sys/socket.h EVENT__HAVE_SYS_SOCKET_H)
if(EVENT__HAVE_SYS_SOCKET_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES sys/socket.h)
endif()

CHECK_INCLUDE_FILE(netinet/in.h EVENT__HAVE_NETINET_IN_H)
if(EVENT__HAVE_NETINET_IN_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES netinet/in.h)
endif()

CHECK_INCLUDE_FILE(netinet/in6.h EVENT__HAVE_NETINET_IN6_H)
if(EVENT__HAVE_NETINET_IN6_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES netinet/in6.h)
endif()

CHECK_INCLUDE_FILE(unistd.h EVENT__HAVE_UNISTD_H)
CHECK_INCLUDE_FILE(netdb.h EVENT__HAVE_NETDB_H)
CHECK_INCLUDE_FILE(dlfcn.h EVENT__HAVE_DLFCN_H)
CHECK_INCLUDE_FILE(arpa/inet.h EVENT__HAVE_ARPA_INET_H)
CHECK_INCLUDE_FILE(fcntl.h EVENT__HAVE_FCNTL_H)
if(EVENT__HAVE_FCNTL_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES fcntl.h)
endif()
CHECK_INCLUDE_FILE(inttypes.h EVENT__HAVE_INTTYPES_H)
CHECK_INCLUDE_FILE(memory.h EVENT__HAVE_MEMORY_H)
CHECK_INCLUDE_FILE(poll.h EVENT__HAVE_POLL_H)
CHECK_INCLUDE_FILE(port.h EVENT__HAVE_PORT_H)
if(EVENT__HAVE_PORT_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES port.h)
endif()
CHECK_INCLUDE_FILE(signal.h EVENT__HAVE_SIGNAL_H)
CHECK_INCLUDE_FILE(stdarg.h EVENT__HAVE_STDARG_H)
CHECK_INCLUDE_FILE(stddef.h EVENT__HAVE_STDDEF_H)
CHECK_INCLUDE_FILE(stdint.h EVENT__HAVE_STDINT_H)
CHECK_INCLUDE_FILE(stdlib.h EVENT__HAVE_STDLIB_H)
CHECK_INCLUDE_FILE(strings.h EVENT__HAVE_STRINGS_H)
CHECK_INCLUDE_FILE(string.h EVENT__HAVE_STRING_H)
CHECK_INCLUDE_FILE(sys/devpoll.h EVENT__HAVE_SYS_DEVPOLL_H)
CHECK_INCLUDE_FILE(sys/epoll.h EVENT__HAVE_SYS_EPOLL_H)
CHECK_INCLUDE_FILE(sys/eventfd.h EVENT__HAVE_SYS_EVENTFD_H)
CHECK_INCLUDE_FILE(sys/event.h EVENT__HAVE_SYS_EVENT_H)
CHECK_INCLUDE_FILE(sys/ioctl.h EVENT__HAVE_SYS_IOCTL_H)
CHECK_INCLUDE_FILE(sys/mman.h EVENT__HAVE_SYS_MMAN_H)
CHECK_INCLUDE_FILE(sys/param.h EVENT__HAVE_SYS_PARAM_H)
CHECK_INCLUDE_FILE(sys/queue.h EVENT__HAVE_SYS_QUEUE_H)
CHECK_INCLUDE_FILE(sys/select.h EVENT__HAVE_SYS_SELECT_H)
CHECK_INCLUDE_FILE(sys/sendfile.h EVENT__HAVE_SYS_SENDFILE_H)
CHECK_INCLUDE_FILE(sys/stat.h EVENT__HAVE_SYS_STAT_H)
CHECK_INCLUDE_FILE(sys/time.h EVENT__HAVE_SYS_TIME_H)
if(EVENT__HAVE_SYS_TIME_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES sys/time.h)
endif()
CHECK_INCLUDE_FILE(sys/uio.h EVENT__HAVE_SYS_UIO_H)
CHECK_INCLUDE_FILES("sys/types.h;ifaddrs.h" EVENT__HAVE_IFADDRS_H)
CHECK_INCLUDE_FILE(mach/mach_time.h EVENT__HAVE_MACH_MACH_TIME_H)
CHECK_INCLUDE_FILE(netinet/tcp.h EVENT__HAVE_NETINET_TCP_H)
CHECK_INCLUDE_FILE(sys/wait.h EVENT__HAVE_SYS_WAIT_H)
CHECK_INCLUDE_FILE(sys/resource.h EVENT__HAVE_SYS_RESOURCE_H)
CHECK_INCLUDE_FILE(sys/sysctl.h EVENT__HAVE_SYS_SYSCTL_H)
CHECK_INCLUDE_FILE(sys/timerfd.h EVENT__HAVE_SYS_TIMERFD_H)
CHECK_INCLUDE_FILE(errno.h EVENT__HAVE_ERRNO_H)


CHECK_FUNCTION_EXISTS_EX(epoll_create EVENT__HAVE_EPOLL)
CHECK_FUNCTION_EXISTS_EX(epoll_ctl EVENT__HAVE_EPOLL_CTL)
CHECK_FUNCTION_EXISTS_EX(eventfd EVENT__HAVE_EVENTFD)
if(NOT EVENT__DISABLE_CLOCK_GETTIME)
    CHECK_FUNCTION_EXISTS_EX(clock_gettime EVENT__HAVE_CLOCK_GETTIME)
endif()
CHECK_FUNCTION_EXISTS_EX(fcntl EVENT__HAVE_FCNTL)
CHECK_FUNCTION_EXISTS_EX(getaddrinfo EVENT__HAVE_GETADDRINFO)
CHECK_FUNCTION_EXISTS_EX(getnameinfo EVENT__HAVE_GETNAMEINFO)
CHECK_FUNCTION_EXISTS_EX(gettimeofday EVENT__HAVE_GETTIMEOFDAY)
CHECK_FUNCTION_EXISTS_EX(getprotobynumber EVENT__HAVE_GETPROTOBYNUMBER)
CHECK_FUNCTION_EXISTS_EX(getservbyname EVENT__HAVE_GETSERVBYNAME)
CHECK_FUNCTION_EXISTS_EX(inet_ntop EVENT__HAVE_INET_NTOP)
CHECK_FUNCTION_EXISTS_EX(inet_pton EVENT__HAVE_INET_PTON)
CHECK_FUNCTION_EXISTS_EX(kqueue EVENT__HAVE_KQUEUE)
CHECK_FUNCTION_EXISTS_EX(mmap EVENT__HAVE_MMAP)
CHECK_FUNCTION_EXISTS_EX(pipe EVENT__HAVE_PIPE)
CHECK_FUNCTION_EXISTS_EX(pipe2 EVENT__HAVE_PIPE2)
CHECK_FUNCTION_EXISTS_EX(poll EVENT__HAVE_POLL)
CHECK_FUNCTION_EXISTS_EX(port_create EVENT__HAVE_PORT_CREATE)
CHECK_FUNCTION_EXISTS_EX(sendfile EVENT__HAVE_SENDFILE)
CHECK_FUNCTION_EXISTS_EX(sigaction EVENT__HAVE_SIGACTION)
CHECK_FUNCTION_EXISTS_EX(signal EVENT__HAVE_SIGNAL)
CHECK_FUNCTION_EXISTS_EX(splice EVENT__HAVE_SPLICE)
CHECK_FUNCTION_EXISTS_EX(strlcpy EVENT__HAVE_STRLCPY)
CHECK_FUNCTION_EXISTS_EX(strsep EVENT__HAVE_STRSEP)
CHECK_FUNCTION_EXISTS_EX(strtok_r EVENT__HAVE_STRTOK_R)
CHECK_FUNCTION_EXISTS_EX(strtoll EVENT__HAVE_STRTOLL)
CHECK_FUNCTION_EXISTS_EX(vasprintf EVENT__HAVE_VASPRINTF)
CHECK_FUNCTION_EXISTS_EX(sysctl EVENT__HAVE_SYSCTL)
CHECK_FUNCTION_EXISTS_EX(accept4 EVENT__HAVE_ACCEPT4)
CHECK_FUNCTION_EXISTS_EX(arc4random EVENT__HAVE_ARC4RANDOM)
CHECK_FUNCTION_EXISTS_EX(arc4random_buf EVENT__HAVE_ARC4RANDOM_BUF)
CHECK_FUNCTION_EXISTS_EX(arc4random_addrandom EVENT__HAVE_ARC4RANDOM_ADDRANDOM)
CHECK_FUNCTION_EXISTS_EX(epoll_create1 EVENT__HAVE_EPOLL_CREATE1)
CHECK_FUNCTION_EXISTS_EX(getegid EVENT__HAVE_GETEGID)
CHECK_FUNCTION_EXISTS_EX(geteuid EVENT__HAVE_GETEUID)
CHECK_FUNCTION_EXISTS_EX(getifaddrs EVENT__HAVE_GETIFADDRS)
CHECK_FUNCTION_EXISTS_EX(issetugid EVENT__HAVE_ISSETUGID)
CHECK_FUNCTION_EXISTS_EX(mach_absolute_time EVENT__HAVE_MACH_ABSOLUTE_TIME)
CHECK_FUNCTION_EXISTS_EX(nanosleep EVENT__HAVE_NANOSLEEP)
CHECK_FUNCTION_EXISTS_EX(usleep EVENT__HAVE_USLEEP)
CHECK_FUNCTION_EXISTS_EX(timeradd EVENT__HAVE_TIMERADD)
CHECK_FUNCTION_EXISTS_EX(timerclear EVENT__HAVE_TIMERCLEAR)
CHECK_FUNCTION_EXISTS_EX(timercmp EVENT__HAVE_TIMERCMP)
CHECK_FUNCTION_EXISTS_EX(timerfd_create EVENT__HAVE_TIMERFD_CREATE)
CHECK_FUNCTION_EXISTS_EX(timerisset EVENT__HAVE_TIMERISSET)
CHECK_FUNCTION_EXISTS_EX(putenv EVENT__HAVE_PUTENV)
CHECK_FUNCTION_EXISTS_EX(setenv EVENT__HAVE_SETENV)
CHECK_FUNCTION_EXISTS_EX(setrlimit EVENT__HAVE_SETRLIMIT)
CHECK_FUNCTION_EXISTS_EX(umask EVENT__HAVE_UMASK)
CHECK_FUNCTION_EXISTS_EX(unsetenv EVENT__HAVE_UNSETENV)

# Get the gethostbyname_r prototype.
CHECK_FUNCTION_EXISTS_EX(gethostbyname_r EVENT__HAVE_GETHOSTBYNAME_R)

if(EVENT__HAVE_GETHOSTBYNAME_R)
    CHECK_PROTOTYPE_DEFINITION(gethostbyname_r
        "int gethostbyname_r(const char *name, struct hostent *hp, struct hostent_data *hdata)"
        "0"
        "netdb.h"
        EVENT__HAVE_GETHOSTBYNAME_R_3_ARG)

    CHECK_PROTOTYPE_DEFINITION(gethostbyname_r
        "struct hostent *gethostbyname_r(const char *name, struct hostent *hp, char *buf, size_t buflen, int *herr)"
        "NULL"
        "netdb.h"
        EVENT__HAVE_GETHOSTBYNAME_R_5_ARG)

    CHECK_PROTOTYPE_DEFINITION(gethostbyname_r
        "int gethostbyname_r(const char *name, struct hostent *hp, char *buf, size_t buflen, struct hostent **result, int *herr)"
        "0"
        "netdb.h"
        EVENT__HAVE_GETHOSTBYNAME_R_6_ARG)
endif()

if(HAVE_PORT_H AND HAVE_PORT_CREATE)
    set(EVENT__HAVE_EVENT_PORTS 1)
endif()

if(NOT WIN32)
    CHECK_FUNCTION_EXISTS_EX(select EVENT__HAVE_SELECT)
endif()

CHECK_TYPE_SIZE("uint8_t" EVENT__HAVE_UINT8_T)
CHECK_TYPE_SIZE("uint16_t" EVENT__HAVE_UINT16_T)
CHECK_TYPE_SIZE("uint32_t" EVENT__HAVE_UINT32_T)
CHECK_TYPE_SIZE("uint64_t" EVENT__HAVE_UINT64_T)
CHECK_TYPE_SIZE("short" EVENT__SIZEOF_SHORT BUILTIN_TYPES_ONLY)
CHECK_TYPE_SIZE("int" EVENT__SIZEOF_INT BUILTIN_TYPES_ONLY)
CHECK_TYPE_SIZE("unsigned" EVENT__SIZEOF_UNSIGNED BUILTIN_TYPES_ONLY)
CHECK_TYPE_SIZE("unsigned int" EVENT__SIZEOF_UNSIGNED_INT BUILTIN_TYPES_ONLY)
CHECK_TYPE_SIZE("long" EVENT__SIZEOF_LONG BUILTIN_TYPES_ONLY)
CHECK_TYPE_SIZE("long long" EVENT__SIZEOF_LONG_LONG BUILTIN_TYPES_ONLY)

if(WIN32)
    # These aren't available until Windows Vista.
    # But you can still link them. They just won't be found when running the exe.
    set(EVENT__HAVE_INET_NTOP 0)
    set(EVENT__HAVE_INET_PTON 0)
endif()

# Check for different inline keyword versions.
check_function_keywords("inline" "__inline" "__inline__")

if (HAVE_INLINE)
    set (EVENT__inline inline)
elseif (HAVE___INLINE)
    set(EVENT__inline __inline)
elseif(HAVE___INLINE__)
    set(EVENT__inline __inline__)
else()
    set(EVENT__inline)
endif()

CHECK_SYMBOL_EXISTS(TAILQ_FOREACH sys/queue.h EVENT__HAVE_TAILQFOREACH)
CHECK_CONST_EXISTS(CTL_KERN sys/sysctl.h EVENT__HAVE_DECL_CTL_KERN)
CHECK_CONST_EXISTS(KERN_ARND sys/sysctl.h EVENT__HAVE_DECL_KERN_ARND)
CHECK_CONST_EXISTS(KERN_RANDOM sys/sysctl.h EVENT__HAVE_DECL_KERN_RANDOM)
CHECK_CONST_EXISTS(RANDOM_UUID sys/sysctl.h EVENT__HAVE_DECL_RANDOM_UUID)
CHECK_SYMBOL_EXISTS(F_SETFD fcntl.h EVENT__HAVE_SETFD)

CHECK_TYPE_SIZE(fd_mask EVENT__HAVE_FD_MASK)

CHECK_TYPE_SIZE(size_t EVENT__SIZEOF_SIZEE_T)
if(NOT EVENT__SIZEOF_SIZE_T)
  set(EVENT__size_t "unsigned")
  set(EVENT__SIZEOF_SIZE_T ${EVENT__SIZEOF_UNSIGNED})
else()
    set(EVENT__size_t size_t)
endif()

CHECK_TYPE_SIZE("off_t" EVENT__SIZEOF_OFF_T LANGUAGE C)


# XXX we should functionalize these size and type sets. --elley

# Winssck.
if (_MSC_VER)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES BaseTsd.h)
endif()
CHECK_TYPE_SIZE("ssize_t" EVENT__SIZEOF_SSIZE_T_LOWER LANGUAGE C)
CHECK_TYPE_SIZE("SSIZE_T" EVENT__SIZEOF_SSIZE_T_UPPER LANGUAGE C)

if (EVENT__SIZEOF_SSIZE_T_LOWER)
    set(EVENT__ssize_t "ssize_t")
    set(EVENT__SIZEOF_SSIZE_T ${EVENT__SIZEOF_SSIZE_T_LOWER})
elseif (EVENT__SIZEOF_SSIZE_T_UPPER)
    set(EVENT__ssize_t "SSIZE_T")
    set(EVENT__SIZEOF_SSIZE_T ${EVENT__SIZEOF_SSIZE_T_UPPER})
else()
    set(EVENT__ssize_t "int")
    set(EVENT__SIZEOF_SSIZE_T ${EVENT__SIZEOF_INT})
endif()


CHECK_TYPE_SIZE(socklen_t EVENT__SIZEOF_SOCKLEN_T)
if(NOT EVENT__SIZEOF_SOCKLEN_T)
  set(EVENT__socklen_t "unsigned int")
  set(EVENT__SIZEOF_SOCKLEN_T ${EVENT__SIZEOF_UNSIGNED_INT})
else()
    set(EVENT__socklen_t "socklen_t")
endif()

CHECK_TYPE_SIZE(pid_t EVENT__SIZEOF_PID_T)
if(NOT EVENT__SIZEOF_PID_T)
  set(EVENT__pid_t "int")
  set(EVENT__SIZEOF_PID_T ${EVENT__SIZEOF_INT})
else()
	set(EVENT__pid_t "pid_t")
	set(EVENT__SIZEOF_PID_T EVENT__SIZEOF_PID_T)
endif()

if (NOT EVENT__DISABLE_THREAD_SUPPORT)
    if (NOT WIN32)
        list(APPEND CMAKE_EXTRA_INCLUDE_FILES pthread.h)
    endif()
    CHECK_TYPE_SIZE(pthread_t EVENT__SIZEOF_PTHREAD_T)
endif()

if(EVENT__HAVE_CLOCK_GETTIME)
  set(EVENT__DNS_USE_CPU_CLOCK_FOR_ID 1)
endif()

# we're just getting lazy now.
CHECK_TYPE_SIZE("uintptr_t" EVENT__HAVE_UINTPTR_T)
CHECK_TYPE_SIZE("void *" EVENT__SIZEOF_VOID_P)

# Tests file offset bits.
# TODO: Add AIX test for if -D_LARGE_FILES is needed.

# XXX: Why is this here? we don't even use it. Well, we don't even use it
#      on top of that, why is it set in the config.h?! IT_MAKES_NO_SENSE
#      I'm commenting it out for now.
#      - ellzey

#CHECK_FILE_OFFSET_BITS()

# Verify kqueue works with pipes.
if (EVENT__HAVE_KQUEUE)
    if (CMAKE_CROSSCOMPILING AND NOT EVENT__FORCE_KQUEUE_CHECK)
        message(WARNING "Cannot check if kqueue works with pipes when crosscompiling, use EVENT__FORCE_KQUEUE_CHECK to be sure (this requires manually running a test program on the cross compilation target)")
        set(EVENT__HAVE_WORKING_KQUEUE 1)
    else()
        message(STATUS "Checking if kqueue works with pipes...")
        include(CheckWorkingKqueue)
    endif()
endif()

CHECK_SYMBOL_EXISTS(_MINIX "stdio.h" EVENT___MINIX)
CHECK_SYMBOL_EXISTS(_POSIX_1_SOURCE "stdio.h" EVENT___POSIX_1_SOURCE)
CHECK_SYMBOL_EXISTS(_POSIX_SOURCE "stdio.h" EVENT___POSIX_SOURCE)

if(EVENT__HAVE_NETDB_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES netdb.h)
    CHECK_TYPE_SIZE("struct addrinfo" EVENT__HAVE_STRUCT_ADDRINFO)
elseif(WIN32)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES ws2tcpip.h)
    CHECK_TYPE_SIZE("struct addrinfo" EVENT__HAVE_STRUCT_ADDRINFO)
endif()

# Check for sockaddr structure sizes.
set(SOCKADDR_HEADERS)
if (WIN32)
    set(CMAKE_REQUIRED_DEFINITIONS "-DWIN32_LEAN_AND_MEAN")
    if (_MSC_VER LESS 1300)
        set(SOCKADDR_HEADERS winsock.h)
    else()
        set(SOCKADDR_HEADERS winsock2.h ws2tcpip.h)
    endif()
else()
    if (EVENT__HAVE_NETINET_IN_H)
        set(SOCKADDR_HEADERS ${SOCKADDR_HEADERS} netinet/in.h)
    endif()

    if (EVENT__HAVE_NETINET_IN6_H)
        set(SOCKADDR_HEADERS ${SOCKADDR_HEADERS} netinet/in6.h)
    endif()

    if (EVENT__HAVE_SYS_SOCKET_H)
        set(SOCKADDR_HEADERS ${SOCKADDR_HEADERS} sys/socket.h)
    endif()

    if (EVENT__HAVE_NETDB_H)
        set(SOCKADDR_HEADERS ${SOCKADDR_HEADERS} netdb.h)
    endif()
endif()

CHECK_TYPE_SIZE("struct in6_addr" EVENT__HAVE_STRUCT_IN6_ADDR)
if(EVENT__HAVE_STRUCT_IN6_ADDR)
    CHECK_STRUCT_HAS_MEMBER("struct in6_addr"
            s6_addr16 "${SOCKADDR_HEADERS}"
            EVENT__HAVE_STRUCT_IN6_ADDR_S6_ADDR16)

    CHECK_STRUCT_HAS_MEMBER("struct in6_addr"
            s6_addr32 "${SOCKADDR_HEADERS}"
            EVENT__HAVE_STRUCT_IN6_ADDR_S6_ADDR32)
endif()

CHECK_TYPE_SIZE("sa_family_t" EVENT__HAVE_SA_FAMILY_T)
CHECK_TYPE_SIZE("struct sockaddr_in6" EVENT__HAVE_STRUCT_SOCKADDR_IN6)

if(EVENT__HAVE_STRUCT_SOCKADDR_IN6)
    CHECK_STRUCT_HAS_MEMBER("struct sockaddr_in6"
            sin6_len "${SOCKADDR_HEADERS}"
            EVENT__HAVE_STRUCT_SOCKADDR_IN6_SIN6_LEN)

    CHECK_STRUCT_HAS_MEMBER("struct sockaddr_in6"
            sin_len "${SOCKADDR_HEADERS}"
            EVENT__HAVE_STRUCT_SOCKADDR_IN_SIN_LEN)
endif()

CHECK_TYPE_SIZE("struct sockaddr_storage" EVENT__HAVE_STRUCT_SOCKADDR_STORAGE)
if(EVENT__HAVE_STRUCT_SOCKADDR_STORAGE)
    CHECK_STRUCT_HAS_MEMBER("struct sockaddr_storage"
            ss_family "${SOCKADDR_HEADERS}"
            EVENT__HAVE_STRUCT_SOCKADDR_STORAGE_SS_FAMILY)

    CHECK_STRUCT_HAS_MEMBER("struct sockaddr_storage"
            __ss_family "${SOCKADDR_HEADERS}" EVENT__HAVE_STRUCT_SOCKADDR_STORAGE___SS_FAMILY)
endif()

CHECK_TYPE_SIZE("struct linger" EVENT__HAVE_STRUCT_LINGER)

endmacro()
