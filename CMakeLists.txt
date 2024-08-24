cmake_minimum_required(VERSION 3.1)

project(shockolate VERSION 0.7.8)

include(FeatureSummary)

set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB32_PATHS OFF)
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS ON)

# Required for stdbool.h
set(CMAKE_C_STANDARD 99)
# For nullptr in C++
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -static")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g -D__STDC_LIMIT_MACROS -static -static-libstdc++")

option(ENABLE_EXAMPLES "Enable example applications" OFF)
add_feature_info(ENABLE_EXAMPLES ENABLE_EXAMPLES "Enable example application (can be broken!)")

option(ENABLE_DEBUG_BLIT "Enable debugging blitter" OFF)
add_feature_info(ENABLE_DEBUG_BLIT ENABLE_DEBUG_BLIT "Enable debugging blitter")

option(ENABLE_OPENGL "Enable OpenGL support" ON)
add_feature_info(ENABLE_OPENGL ENABLE_OPENGL "Enable OpenGL support")

option(ENABLE_SDL2 "Enable SDL2 support" ON)
add_feature_info(ENABLE_SDL2 ENABLE_SOUND "Enable SDL2 support")

option(ENABLE_SOUND "Enable SDL2_mixer sound support" ON)
add_feature_info(ENABLE_SOUND ENABLE_SOUND "Enable SDL2_mixer sound support")

option(ENABLE_FLUIDSYNTH "Enable FluidSynth MIDI support" ON)
add_feature_info(ENABLE_FLUIDSYNTH ENABLE_FLUIDSYNTH "Enable FluidSynth MIDI support")

# HAAAAX!!
add_definitions(-DSVGA_SUPPORT)

if(ENABLE_DEBUG_BLIT)
	add_definitions(-DDEBUGGING_BLIT)
endif()

add_compile_options(-fsigned-char -fno-strict-aliasing)

# Find OpenGL
if(ENABLE_OPENGL MATCHES ON)
	find_package(OpenGL REQUIRED)
	add_definitions(-DUSE_OPENGL)
	if(WIN32)
		list(APPEND OPENGL_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/external_libs/glew/include)
		list(APPEND OPENGL_LIBRARIES ${CMAKE_SOURCE_DIR}/external_libs/glew_built/lib/libglew32.dll.a winmm)
	endif()
endif()

if(ENABLE_SDL2 MATCHES ON)
	set(SDL2_DIR ${CMAKE_SOURCE_DIR}/external_libs/SDL_built)
	find_library(SDL2_LIBRARY SDL2 PATHS ${SDL2_DIR} NO_DEFAULT_PATH)
	find_library(SDL2MAIN_LIBRARY SDL2main PATHS ${SDL2_DIR} NO_DEFAULT_PATH)
	if (SDL2_LIBRARY AND SDL2MAIN_LIBRARY)
		set(SDL2_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/external_libs/SDL/include)
		set(SDL2_LIBRARIES ${SDL2_LIBRARY} ${SDL2MAIN_LIBRARY})
		set(SDL2_FOUND TRUE)
	else()
		message(STATUS "SDL2 not found in external_libs, searching for package...")
		find_package(SDL2 REQUIRED)
	endif()

	if(SDL2_FOUND)
		message(STATUS "SDL2 found: ${SDL2_INCLUDE_DIRS} ${SDL2_LIBRARIES}")
	endif()
endif()

if(ENABLE_SOUND MATCHES ON)
	set(SDL2_MIXER_DIR ${CMAKE_SOURCE_DIR}/external_libs/SDL_mixer_built)
	find_library(SDL2_MIXER_LIBRARY SDL2_mixer PATHS ${SDL2_MIXER_DIR} NO_DEFAULT_PATH)
	if (SDL2_MIXER_LIBRARY)
		set(SDL2_MIXER_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/external_libs/SDL_mixer/include)
		set(SDL2_MIXER_LIBRARIES ${SDL2_MIXER_LIBRARY})
		set(SDL2_MIXER_FOUND TRUE)
	else()
		message(STATUS "SDL2_mixer not found in external_libs, searching for package...")
		find_package(SDL2_mixer REQUIRED)
	endif()

	if(SDL2_MIXER_FOUND)
		add_definitions(-DUSE_SDL_MIXER)
		message(STATUS "SDL2_mixer found: ${SDL2_MIXER_INCLUDE_DIRS} ${SDL2_MIXER_LIBRARIES}")
	endif()
endif()

if(ENABLE_FLUIDSYNTH MATCHES ON)
	set(FLUIDSYNTH_DIR ${CMAKE_SOURCE_DIR}/external_libs/fluidsynth-lite_built)
	find_library(FLUIDSYNTH_LIBRARY fluidsynth PATHS ${FLUIDSYNTH_DIR}/src NO_DEFAULT_PATH)
	if (FLUIDSYNTH_LIBRARY)
		set(FLUIDSYNTH_INCLUDE_DIRS ${CMAKE_SOURCE_DIR}/external_libs/fluidsynth-lite/include)
		set(FLUIDSYNTH_LIBRARIES ${FLUIDSYNTH_LIBRARY})
		set(FLUIDSYNTH_FOUND TRUE)
	else()
		message(STATUS "FluidSynth not found in external_libs, searching for package...")
		find_package(FLUIDSYNTH REQUIRED)
	endif()

	if(FLUIDSYNTH_FOUND)
		add_definitions(-DUSE_FLUIDSYNTH)
		message(STATUS "FluidSynth found: ${FLUIDSYNTH_INCLUDE_DIRS} ${FLUIDSYNTH_LIBRARIES}")
	endif()
endif()

include_directories(
	${SDL2_INCLUDE_DIRS}
	${SDL2_MIXER_INCLUDE_DIRS}
	${FLUIDSYNTH_INCLUDE_DIRS}
	${OPENGL_INCLUDE_DIRS}
)

if(NOT WIN32)
  # Find ALSA for Linux native MIDI
  # NOTE: this seems to require having 64-bit dev pacakges installed when building
  #  on 64-bit OS, even when building a 32-bit binary
  find_package(ALSA)
  if(ALSA_FOUND)
      message(STATUS "ALSA found")
      include_directories(${ALSA_INCLUDE_DIRS})
      add_definitions(-DUSE_ALSA=1)
  endif(ALSA_FOUND)
endif(NOT WIN32)

# Generate version based on project version
set(PROJECT_REVERSION_STRING "")
find_package(Git)
if(GIT_FOUND)
	execute_process(COMMAND ${GIT_EXECUTABLE} describe --dirty
		WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
		OUTPUT_VARIABLE git_describe_out
		ERROR_VARIABLE git_describe_error
		RESULT_VARIABLE git_describe_result
		)
	string(REGEX MATCH "[a-z|0-9|.]*-[0-9]*-g([a-z|0-9]*)([-|a-z]*)" git_commit "${git_describe_out}")
	set(git_commit ${CMAKE_MATCH_1})
	set(git_dirty ${CMAKE_MATCH_2})
	set(PROJECT_REVERSION_STRING "-g${git_commit}${git_dirty}")
endif(GIT_FOUND)

message(STATUS "Version is ${PROJECT_VERSION}${PROJECT_REVERSION_STRING}")
configure_file("${CMAKE_SOURCE_DIR}/src/GameSrc/Headers/shockolate_version.h.in"
	"${CMAKE_BINARY_DIR}/src/GameSrc/Headers/shockolate_version.h" )

# Configuration done. Print features
feature_summary(WHAT ENABLED_FEATURES DESCRIPTION "Enabled features:")
feature_summary(WHAT DISABLED_FEATURES DESCRIPTION "Disabled features:")

# Sources configuration
add_subdirectory(src/Libraries/)

set(MAC_SRC
	src/MacSrc/ShockBitmap.c
	src/MacSrc/InitMac.c
	src/MacSrc/Shock.c
	src/MacSrc/Prefs.c
	src/MacSrc/MacTune.c
	src/MacSrc/SDLSound.c
	src/MacSrc/Modding.c
	src/MacSrc/OpenGL.cc
	src/MacSrc/Xmi.c
	src/MusicSrc/MusicDevice.c
)

set(GAME_SRC
	src/GameSrc/ai.c
	src/GameSrc/airupt.c
	src/GameSrc/amap.c
	src/GameSrc/amaploop.c
	src/GameSrc/ammomfd.c
	src/GameSrc/anim.c
	src/GameSrc/archiveformat.c
	src/GameSrc/audiolog.c
	src/GameSrc/automap.c
	src/GameSrc/bark.c
	src/GameSrc/biohelp.c
	src/GameSrc/cardmfd.c
	src/GameSrc/citres.c
	src/GameSrc/combat.c
	src/GameSrc/cone.c
	src/GameSrc/criterr.c
	src/GameSrc/cyber.c
	src/GameSrc/cybermfd.c
	src/GameSrc/cybmem.c
	src/GameSrc/cybrnd.c
	src/GameSrc/cutsloop.c
	src/GameSrc/damage.c
	src/GameSrc/digifx.c
	src/GameSrc/drugs.c
	src/GameSrc/effect.c
	src/GameSrc/email.c
	src/GameSrc/faceobj.c
	src/GameSrc/fixtrmfd.c
	src/GameSrc/frcamera.c
	src/GameSrc/frclip.c
	src/GameSrc/frcompil.c
	src/GameSrc/frmain.c
	src/GameSrc/frobj.c
	src/GameSrc/froslew.c
	src/GameSrc/frpipe.c
	src/GameSrc/frpts.c
	src/GameSrc/frsetup.c
	src/GameSrc/frtables.c
	src/GameSrc/frterr.c
	src/GameSrc/frutil.c
	src/GameSrc/FrUtils.c
	src/GameSrc/fullamap.c
	src/GameSrc/fullscrn.c
	src/GameSrc/gameloop.c
	src/GameSrc/gameobj.c
	src/GameSrc/gamesort.c
	src/GameSrc/gamestrn.c
	src/GameSrc/gamesys.c
	src/GameSrc/gametime.c
	src/GameSrc/gamewrap.c
	src/GameSrc/gearmfd.c
	src/GameSrc/gr2ss.c
	src/GameSrc/grenades.c
	src/GameSrc/hand.c
	src/GameSrc/hflip.c
	src/GameSrc/hkeyfunc.c
	src/GameSrc/hud.c
	src/GameSrc/hudobj.c
	src/GameSrc/init.c
	src/GameSrc/input.c
	src/GameSrc/invent.c
	src/GameSrc/leanmetr.c
	src/GameSrc/mainloop.c
	src/GameSrc/map.c
	src/GameSrc/mfdfunc.c
	src/GameSrc/mfdgadg.c
	src/GameSrc/mfdgames.c
	src/GameSrc/mfdgump.c
	src/GameSrc/mfdpanel.c
	src/GameSrc/minimax.c
	src/GameSrc/mlimbs.c
	src/GameSrc/movekeys.c
	src/GameSrc/musicai.c
	src/GameSrc/newai.c
	src/GameSrc/newmfd.c
	src/GameSrc/objapp.c
	src/GameSrc/objects.c
	src/GameSrc/objload.c
	src/GameSrc/objprop.c
	src/GameSrc/objsim.c
	src/GameSrc/objuse.c
	src/GameSrc/olh.c
	src/GameSrc/olhscan.c
	src/GameSrc/palfx.c
	src/GameSrc/pathfind.c
	src/GameSrc/physics.c
	src/GameSrc/player.c
	src/GameSrc/plotware.c
	src/GameSrc/popups.c
	src/GameSrc/render.c
	src/GameSrc/rendtool.c
	src/GameSrc/saveload.c
	src/GameSrc/schedule.c
	src/GameSrc/screen.c
	src/GameSrc/setup.c
	src/GameSrc/shodan.c
	src/GameSrc/sideicon.c
	src/GameSrc/sndcall.c
	src/GameSrc/star.c
	src/GameSrc/statics.c
	src/GameSrc/status.c
	src/GameSrc/target.c
	src/GameSrc/textmaps.c
	src/GameSrc/tickcount.c
	src/GameSrc/tfdirect.c
	src/GameSrc/tfutil.c
	src/GameSrc/tools.c
	src/GameSrc/trigger.c
	src/GameSrc/view360.c
	src/GameSrc/viewhelp.c
	src/GameSrc/vitals.c
	src/GameSrc/vmail.c
	src/GameSrc/wares.c
	src/GameSrc/weapons.c
	src/GameSrc/wrapper.c
	src/GameSrc/gamerend.c
	src/GameSrc/mouselook.c
	src/GameSrc/keypad.c
)

include_directories(
	BEFORE
	src/Libraries/2D/Source
	src/Libraries/3D/Source
	src/Libraries/AFILE/Source
	src/Libraries/DSTRUCT/Source
	src/Libraries/EDMS/Source
	src/Libraries/FIXPP/Source
	src/Libraries/INPUT/Source
	src/Libraries/PALETTE/Source
	src/Libraries/RES/Source
	src/Libraries/UI/Source
	src/Libraries/RND/Source
	src/Libraries/VOX/Source
	src/Libraries/FIX/Source
	src/Libraries/SND/Source
	src/Libraries/H
	src/Libraries/LG/Source
	src/Libraries/LG/Source/LOG/src
	src/Libraries/adlmidi/include
	src/GameSrc/Headers
	src/MacSrc
	src/MusicSrc
	${CMAKE_BINARY_DIR}/src/GameSrc/Headers
)

if(ENABLE_EXAMPLES)

add_executable(playmov
	src/Libraries/AFILE/Tests/playmov.c
)
add_executable(movinfo
	src/Libraries/AFILE/Tests/movinfo.c
)

target_link_libraries(playmov
	AFILE_LIB
	FIX_LIB
	${SDL2_LIBRARIES}
	${SDL2_MIXER_LIBRARIES}
)

target_link_libraries(movinfo
	AFILE_LIB
	FIX_LIB
)

add_executable(TestSimpleMain
	src/Libraries/2D/TestSource/SimpleMain.c
)

target_link_libraries(TestSimpleMain
	2D_LIB
	GR_LIB
	3D_LIB
	RES_LIB
	FIX_LIB
	LG_LIB
	${SDL2_LIBRARIES}
)

add_executable(BoxTest
	src/Libraries/3D/Tests/BoxTest.c
)

target_link_libraries(BoxTest
	2D_LIB
	GR_LIB
	3D_LIB
	RES_LIB
	FIX_LIB
	LG_LIB
	${SDL2_LIBRARIES}
)

add_executable(BitmapTest
	src/Libraries/3D/Tests/BitmapTest.c
)

target_link_libraries(BitmapTest
	2D_LIB
	GR_LIB
	3D_LIB
	RES_LIB
	FIX_LIB
	LG_LIB
	${SDL2_LIBRARIES}
)

add_executable(FixTest
	src/Libraries/FIX/Tests/FixTest/fixtest.c
)

target_link_libraries(FixTest
	FIX_LIB
	LG_LIB
)

endif()

# Include magic header file, set struct packing size
add_definitions(
	-include precompiled.h
)

add_executable(systemshock
	${MAC_SRC}
)
set_target_properties(systemshock PROPERTIES
	RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}
)

add_library(GAME_LIB ${GAME_SRC})

# MINGW additional linker options
if(MINGW)
	set(WINDOWS_LIBRARIES "mingw32 -mwindows")
endif(MINGW)

target_link_libraries(systemshock
	${WINDOWS_LIBRARIES} # Set it before any linker options! Beware WinMain@16 error!!
	GAME_LIB
	UI_LIB
	2D_LIB
	LG_LIB
	GR_LIB
	3D_LIB
	RND_LIB
	AFILE_LIB
	DSTRUCT_LIB
	FIX_LIB
	INPUT_LIB
	PALETTE_LIB
	RES_LIB
#	SND_LIB
	VOX_LIB
	EDMS_LIB
	FIXPP_LIB
	ADLMIDI_LIB
	${SDL2_LIBRARIES}
	${SDL2_MIXER_LIBRARIES}
	${FLUIDSYNTH_LIBRARIES}
	${OPENGL_LIBRARIES}
	${ALSA_LIBRARIES}
)

# Turn on address sanitizing if wanted
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/externals/sanitizers/cmake" ${CMAKE_MODULE_PATH})
find_package(Sanitizers)
add_sanitizers(systemshock)
