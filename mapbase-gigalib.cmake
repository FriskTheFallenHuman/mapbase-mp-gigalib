# mapbase-gigalib.cmake

include_guard(GLOBAL)

# It's important to include $GAMENAME in the generated_proto directory
# to avoid race conditions when multiple games are in one solution.
#set(GENERATED_PROTO_DIR	"${SRCDIR}/thirdparty/gigalib/src/networking")

#Built a .proto file and add the resulting C++ to the target.
macro( TargetBuildAndAddProto TARGET_NAME PROTO_FILE PROTO_OUTPUT_FOLDER )
    set(PROTO_FILENAME)

	set(PROTO_COMPILER ${SRCDIR}/thirdparty/gigalib/bin/protobuf/protoc.exe)

	#This is a target added in /thirdparty/protobuf-2.3.0
	if( UNIX AND NOT APPLE )
		set(PROTO_COMPILER ${SRCDIR}/thirdparty/gigalib/bin/protobuf/protoc)
	endif()
	
	target_link_libraries( ${TARGET_NAME} PRIVATE
		"$<IF:$<CONFIG:Debug>,$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libprotobuf.a>$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/bin/libprotobufd.lib>,$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libprotobuf.a>$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/bin/libprotobuf.lib>>"
	)
	
	target_include_directories(${TARGET_NAME} PRIVATE ${SRCDIR}/thirdparty/gigalib/src/networking)
	target_include_directories(${TARGET_NAME} PRIVATE ${SRCDIR}/thirdparty/gigalib/src/protobuf/src)
	target_include_directories(${TARGET_NAME} PRIVATE ${SRCDIR}/thirdparty/gigalib/src/networking)

	target_compile_definitions(${TARGET_NAME} PRIVATE "_HAS_EXCEPTIONS=0")

    get_filename_component(PROTO_FILENAME ${PROTO_FILE} NAME_WLE) #name without any extensions

    add_custom_command(
            OUTPUT "${PROTO_OUTPUT_FOLDER}/${PROTO_FILENAME}.pb.cc"
                   "${PROTO_OUTPUT_FOLDER}/${PROTO_FILENAME}.pb.h"
            COMMAND ${PROTO_COMPILER} --cpp_out=. --proto_path=${SRCDIR}/thirdparty/gigalib/src/protobuf/src --proto_path=${SRCDIR}/thirdparty/gigalib/src/networking ${PROTO_FILE}
            DEPENDS ${PROTO_FILE} ${PROTO_COMPILER}
            WORKING_DIRECTORY ${PROTO_OUTPUT_FOLDER}
            COMMENT "Running protoc compiler on ${PROTO_FILE} - output (${PROTO_OUTPUT_FOLDER}/${PROTO_FILENAME}.pb.cc)"
            VERBATIM
    )

    #add the output folder in the include path.
    target_include_directories(${TARGET_NAME} PRIVATE ${PROTO_OUTPUT_FOLDER})
    target_sources(${TARGET_NAME} PRIVATE ${PROTO_OUTPUT_FOLDER}/${PROTO_FILENAME}.pb.cc ${PROTO_OUTPUT_FOLDER}/${PROTO_FILENAME}.pb.h)
	set_source_files_properties(${PROTO_OUTPUT_FOLDER}/${PROTO_FILENAME}.pb.cc ${PROTO_OUTPUT_FOLDER}/${PROTO_FILENAME}.pb.h PROPERTIES SKIP_PRECOMPILE_HEADERS ON)
endmacro()

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
	
    # networking
	"${GIGALIB_DIR}/src/networking/networking.cpp"
	"${GIGALIB_DIR}/src/networking/networking.h"
	"${GIGALIB_DIR}/src/networking/messages.cpp"
	"${GIGALIB_DIR}/src/networking/messages.h"

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

	# speedykv
	"${GIGALIB_DIR}/src/speedykv/speedykv.cpp"
	"${GIGALIB_DIR}/src/speedykv/speedykv.h"
)

function(target_mapbase_gigalib target)
	if (UNIX AND CMAKE_COMPILER_IS_GNUCC)
	  set ( CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fvisibility=default" )
	endif ()

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
		"${GIGALIB_DIR}/src/sdksentry"
		"${GIGALIB_DIR}/src/speedykv"
		#"$<$<OR:${SDL},${DEDICATED}>:${SRCDIR}/thirdparty/SDL2>"
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

        # sentry
		"$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libbreakpad_client.a>"
		"$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libsentry.a>"		
		"$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/bin/sentry.lib>"

        # curl
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libcurl.a>
		"$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/bin/libcurl.lib>"

        # fmt
		"$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libfmt.a>"
		"$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/bin/fmt.lib>"

        # bin patching
		"$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libPolyHook_2.a>"
		"$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libZydis.a>"
		"$<IF:$<CONFIG:Debug>,$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/src/polyhook/bin/debug/PolyHook_2.lib>,$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/src/polyhook/bin/release/PolyHook_2.lib>>"
		"$<IF:$<CONFIG:Debug>,$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/src/polyhook/bin/debug/Zydis.lib>,$<${IS_WINDOWS}:${SRCDIR}/thirdparty/gigalib/src/polyhook/bin/release/Zydis.lib>>"

        # sdl
		"$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libSDL2.a>"

		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libbrotlicommon-static.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libbrotlidec-static.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libbrotlienc-static.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libcrypto.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libnghttp2.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libssh2.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libssl.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libz.a>
		#$<${IS_LINUX}:${SRCDIR}/thirdparty/gigalib/bin/libzstd.a>
	)

	target_compile_definitions(
		${target} PRIVATE
		
		# Enables the Mapbase integration
		$<$<BOOL:${MAPBASE_GIGALIB}>:MAPBASE_GIGALIB>
		
		# Enable modern CURL
		$<$<BOOL:${IS_WINDOWS}>:CURL_STATICLIB>
		
        # Net stuff
        # PROTOBUF_USE_DLLS
        _SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING
	)
endfunction()