cmake_minimum_required(VERSION 2.8.7)

MACRO(SETUP_COMPILER)

    IF(APPLE)
        SET(CMAKE_CXX_COMPILER clang++)
        SET(CMAKE_C_COMPILER clang)
        ADD_DEFINITIONS(-DITS_PLATFORM_APPLE=1)

        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-delete-non-virtual-dtor -Werror -std=c++1y -stdlib=libc++")
        SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2 -g")
        SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g")
    ENDIF(APPLE)

    IF(LINUX)
        SET(CMAKE_CXX_COMPILER clang++)
        SET(CMAKE_C_COMPILER clang)
        # ADD_DEFINITIONS( -ggdb -m64 )
        ADD_DEFINITIONS(-DITS_PLATFORM_LINUX=1)

        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-delete-non-virtual-dtor -ggdb -m64 -std=c++1y -stdlib=libc++")

        SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O2 -g")
        SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0 -g -D_DEBUG")

        find_package (PkgConfig REQUIRED)
        pkg_check_modules (GTK2 REQUIRED gtk+-2.0)

        include_directories (${GTK2_INCLUDE_DIRS})

        ADD_DEFINITIONS(-DITS_NO_FMOD=1)
        ADD_DEFINITIONS(-DITS_GAPI_OPENGL=1)
    ENDIF()

    IF(WIN32)
        ADD_DEFINITIONS(-DITS_PLATFORM_WIN32=1)
        SET(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Zi /W3 /we4189 /EHsc /RTC1 /DEBUG /bigobj /WX /D_ITERATOR_DEBUG_LEVEL=1")
        SET(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi /O2 /Oi /GS- /bigobj /WX")
        SET(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} /Zi /Od /Oi /bigobj /WX")

        set(CMAKE_EXE_LINKER_FLAGS_DEBUG "${CMAKE_EXE_LINKER_FLAGS_DEBUG} /DEBUG:FASTLINK /time ")
        set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG")
        set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /INCREMENTAL:NO /DEBUG ")
        set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} /INCREMENTAL:NO")

        LINK_DIRECTORIES( ${BOOST_LIBS_PATH}/stage/lib ${AGS_LIB_PATH} )

        # workaround for websocket and msvc2015
        IF(LOW_GENERATOR MATCHES "visual studio 14.*")
            ADD_DEFINITIONS(-D_WEBSOCKETPP_NOEXCEPT_)
            ADD_DEFINITIONS(-D_WEBSOCKETPP_CPP11_CHRONO_)
        ENDIF()

        ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS)
        ADD_DEFINITIONS(-DCURL_STATICLIB)
    ENDIF(WIN32)

    ADD_DEFINITIONS(-DFTGL_LIBRARY_STATIC=1)                #
    ADD_DEFINITIONS(-DGLEW_STATIC=1)                        #

    if(TOBII_STREAM_DLLS)
        ADD_DEFINITIONS(-DITS_HAS_TOBII_STREAM_ENGINE)
    endif()

    INCLUDE_DIRECTORIES(${CORE_ADDITIONAL_INCLUDES} ${ENGINE_ADDITIONAL_INCLUDES} )

ENDMACRO()

MACRO(SETUP_CPP11 _targetName)
    IF(APPLE)
        SET_TARGET_PROPERTIES(${_targetName} PROPERTIES XCODE_ATTRIBUTE_CLANG_CXX_LANGUAGE_STANDARD "c++1y")
        SET_TARGET_PROPERTIES(${_targetName} PROPERTIES XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
        SET_TARGET_PROPERTIES(${_targetName} PROPERTIES XCODE_ATTRIBUTE_ARCHS "$(ARCHS_STANDARD_64_BIT)")
        SET_TARGET_PROPERTIES(${_targetName} PROPERTIES XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH "YES")
    ENDIF()
    IF (UNIX AND NOT APPLE)
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-delete-non-virtual-dtor -ggdb -m64 -std=c++1y -stdlib=libc++")
    ENDIF()
ENDMACRO()

MACRO(OUTPUT_TEXTMATE _targetName)
    GET_TARGET_PROPERTY(SOURCE_FILES ${_targetName} "SOURCES")
    GET_TARGET_PROPERTY(TARGET_GROUP ${_targetName} "FOLDER")

    GET_PROPERTY(DIRS DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR} PROPERTY INCLUDE_DIRECTORIES)
    FOREACH( sourceFile ${SOURCE_FILES})
        GET_SOURCE_FILE_PROPERTY(_groupName ${sourceFile} "MY_GROUP_NAME" )
        GET_SOURCE_FILE_PROPERTY(_fullPath ${sourceFile} "LOCATION" )
        FILE(APPEND "${CMAKE_BINARY_DIR}/textmate.txt" "${_targetName}\n${_fullPath}\n${_groupName}\n${DIRS}\n${TARGET_GROUP}\n" )
    ENDFOREACH( sourceFile )

    GET_TARGET_PROPERTY(TARGET_TYPE ${_targetName} "TYPE")
    IF ( ${TARGET_TYPE} STREQUAL EXECUTABLE)
        IF( NOT CMAKE_BUILD_TYPE )
                get_property(_tempLocation TARGET ${_targetName} PROPERTY LOCATION_RELEASE)
        ELSE()
            IF( ${CMAKE_BUILD_TYPE} STREQUAL "DEBUG")
                get_property(_tempLocation TARGET ${_targetName} PROPERTY LOCATION_DEBUG)
            ELSE()
                get_property(_tempLocation TARGET ${_targetName} PROPERTY LOCATION_RELEASE)
            ENDIF()
        ENDIF()

        FILE(APPEND "${CMAKE_BINARY_DIR}/textmate_targets.txt" "${_tempLocation}\n${_targetName}\n" )
    ENDIF()
ENDMACRO(OUTPUT_TEXTMATE)