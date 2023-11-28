# mapbase-gigalib.cmake

include_guard(GLOBAL)

set(GIGALIB_DIR ${CMAKE_CURRENT_LIST_DIR})
set(
	GIGALIB_SOURCE_FILES

	# helpers
	"${GIGALIB_DIR}/src/helpers/steam_helpers.h"
	"${GIGALIB_DIR}/src/helpers/steam_helpers.cpp"
	"${GIGALIB_DIR}/src/helpers/misc_helpers.h"
	"${GIGALIB_DIR}/src/helpers/misc_helpers.cpp"
	"${GIGALIB_DIR}/src/helpers/git_banned.h"

	# memy
	"${GIGALIB_DIR}/src/memy/bytepatch.hpp"
	"${GIGALIB_DIR}/src/memy/detourhook.hpp"
	"${GIGALIB_DIR}/src/memy/memytools.h"
	"${GIGALIB_DIR}/src/memy/memytools.cpp"
	"${GIGALIB_DIR}/src/memy/vtblhook.h"

    # engine hacks
	"${GIGALIB_DIR}/src/engine_hacks/engine_detours.cpp"
	"${GIGALIB_DIR}/src/engine_hacks/bin_patch.cpp"
	"${GIGALIB_DIR}/src/engine_hacks/engine_memutils.cpp"
	"${GIGALIB_DIR}/src/engine_hacks/engine_detours.h"
	"${GIGALIB_DIR}/src/engine_hacks/bin_patch.h"
	"${GIGALIB_DIR}/src/engine_hacks/engine_memutils.h"
 
    # sentry native
	"${GIGALIB_DIR}/src/sdksentry/sdksentry.cpp"
	"${GIGALIB_DIR}/src/sdksentry/sdksentry.h"
	"${GIGALIB_DIR}/src/sdksentry/vendored/sentry.h"

	# qol
	"${GIGALIB_DIR}/src/qol/flush_downloadables.cpp"
	"${GIGALIB_DIR}/src/qol/flush_downloadables.h"
	"${GIGALIB_DIR}/src/qol/blacklists.cpp"
	"${GIGALIB_DIR}/src/qol/blacklists.h"

	# sdkCURL
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/sdkCURL.cpp>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/sdkCURL.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/curl.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/curlver.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/easy.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/header.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/mprintf.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/multi.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/options.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/stdcheaders.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/system.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/typecheck-gcc.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/urlapi.h>"
	"$<$<BOOL:${IS_WINDOWS}>:${GIGALIB_DIR}/src/sdkCURL/vendored/websockets.h>"

    # sdknanopb
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_common.c"
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_decode.c"
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_encode.c"
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_common.h"
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_encode.h"
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb.h"

	# speedykv
	"${GIGALIB_DIR}/src/speedykv/speedykv.cpp"
	"${GIGALIB_DIR}/src/speedykv/speedykv.h"
)

set_source_files_properties(
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_common.c"
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_decode.c"
	"${GIGALIB_DIR}/src/sdknanopb/vendored/pb_encode.c"
	"${GIGALIB_DIR}/src/speedykv/speedykv.cpp"
	PROPERTIES SKIP_PRECOMPILE_HEADERS ON
)

function(target_mapbase_gigalib target)
	if (UNIX AND CMAKE_COMPILER_IS_GNUCC)
	  set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=default" )
	endif ()
	
	configure_file(
		"${GIGALIB_DIR}/gigalib_config.h.in"
		"${CMAKE_BINARY_DIR}/gigalib_config.h"
	)

	target_sources(
		${target} PRIVATE
		${GIGALIB_SOURCE_FILES}
	)

	target_include_directories(
		${target} PRIVATE
		"${GIGALIB_DIR}/src"
		"${GIGALIB_DIR}/src/engine_hacks"
		"${GIGALIB_DIR}/src/helpers"
		"${GIGALIB_DIR}/src/memy"
		"${GIGALIB_DIR}/src/polyhook"
		"${GIGALIB_DIR}/src/qol"
		"${GIGALIB_DIR}/src/sdkCURL"
		"${GIGALIB_DIR}/src/sdknanopb"
		"${GIGALIB_DIR}/src/sdksentry"
		"${GIGALIB_DIR}/src/speedykv"
		"$<$<OR:${SDL},${DEDICATED}>:${SRCDIR}/thirdparty/SDL2>"
	)
	
	target_link_directories(
		${target} PRIVATE
		"${GIGALIB_DIR}/bin"
	)
	
	target_link_libraries(
		${target} PRIVATE

		$<${IS_WINDOWS}:wsock32>
		$<${IS_WINDOWS}:ws2_32>
		$<${IS_WINDOWS}:wldap32>
		#$<${IS_WINDOWS}:msvcrtd>

		#"$<${IS_POSIX}:${LIBCOMMON}/libcrypto${STATIC_LIB_EXT}>"
		#"$<${IS_OSX}:${LIBCOMMON}/curl${STATIC_LIB_EXT}>"
		#"$<${IS_WINDOWS}:${LIBCOMMON}/libcurl${STATIC_LIB_EXT}>"
		"$<$<OR:${IS_WINDOWS},${IS_LINUX}>:${LIBPUBLIC}/libz${STATIC_LIB_EXT}>"
		#"$<${IS_LINUX}:${LIBCOMMON}/libcurl${STATIC_LIB_EXT}>"
		#"$<${IS_LINUX}:${LIBCOMMON}/libcurlssl${STATIC_LIB_EXT}>"
		#"$<${IS_LINUX}:${LIBCOMMON}/libssl${STATIC_LIB_EXT}>"
		
		$<${IS_WINDOWS}:sentry>
		$<${IS_WINDOWS}:libcurl>
		$<${IS_WINDOWS}:fmt>

        # sentry
		$<${IS_LINUX}:libbreakpad_client>
		$<${IS_LINUX}:libsentry>
        # bin patching
		$<${IS_LINUX}:libPolyHook_2>
		$<${IS_LINUX}:libZydis>
        # fmt
		$<${IS_LINUX}:libfmt>
        # sdl
		$<${IS_LINUX}:SDL2>

        # curl
		#$<${IS_LINUX}:libcurl>
		#$<${IS_LINUX}:libbrotlicommon-static>
		#$<${IS_LINUX}:libbrotlidec-static>
		#$<${IS_LINUX}:libbrotlienc-static>
		#$<${IS_LINUX}:libcrypto>
		#$<${IS_LINUX}:libnghttp2>
		#$<${IS_LINUX}:libssh2>
		#$<${IS_LINUX}:libssl>
		#$<${IS_LINUX}:libz>
		#$<${IS_LINUX}:libzstd>
	)

	target_compile_definitions(
		${target} PRIVATE
		$<$<BOOL:${IS_WINDOWS}>:CURL_STATICLIB>
	)
endfunction()