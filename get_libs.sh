glew_version=2.2.0

function download_glew {
	glew_filename=glew-${glew_version}
	glew_url=https://github.com/nigels-com/glew/releases/download/${glew_filename}/${glew_filename}.tgz
	
	cd external_libs
	mkdir glew
	curl -L ${glew_url} > ${glew_filename}.tgz
	tar xvf ${glew_filename}.tgz
	rm ${glew_filename}.tgz
	mv ${glew_filename}/* glew
	rmdir ${glew_filename}
	cd ..
}

function build_glew {
	cd external_libs
	if ! [[ -d glew_built ]]; then
		mkdir glew_built
	fi
	cd glew_built
	cmake -G Ninja -DCMAKE_C_COMPILER=clang ../glew/build/cmake
	cmake --build .
	cd ../..
	cp external_libs/glew_built/bin/*.dll . 2>/dev/null
}

function get_glew {
	if ! [[ -d external_libs/glew ]]; then
		echo glew was not found - downloading...
		download_glew
	fi

	if [[ -d external_libs/glew ]]; then
		echo found glew - building...
		build_glew
	fi
}

function download_sdl {
	cd external_libs
	git clone -b SDL2 https://github.com/libsdl-org/SDL.git
	cd ..
}

function build_sdl {
	cd external_libs
	if ! [[ -d SDL_built ]]; then
		mkdir SDL_built
	fi
	cd SDL_built
	cmake -G Ninja -DCMAKE_C_COMPILER=clang ../SDL
	cmake --build .
	cd ../..
	cp external_libs/SDL_built/*.dll . 2>/dev/null
}

function get_sdl {
	if ! [[ -d external_libs/SDL ]]; then
		echo SDL was not found - downloading...
		download_sdl
	fi

	if [[ -d external_libs/SDL ]]; then
		echo found SDL - building...
		build_sdl
	fi
}

function download_sdl_mixer {
	cd external_libs
	git clone -b SDL2 https://github.com/libsdl-org/SDL_mixer.git
	sh SDL_mixer/external/download.sh
	cd ..
}

function build_sdl_mixer {
	cd external_libs
	if ! [[ -d SDL_mixer_built ]]; then
		mkdir SDL_mixer_built
	fi
	cd SDL_mixer_built
	cmake -G Ninja -DCMAKE_C_COMPILER=clang -DSDL2MIXER_VENDORED=ON -DSDL2MIXER_SAMPLES=OFF ../SDL_mixer
	cmake --build .
	cd ../..
	cp external_libs/SDL_mixer_built/*.dll . 2>/dev/null
}

function get_sdl_mixer {
	if ! [[ -d external_libs/SDL_mixer ]]; then
		echo SDL_mixer was not found - downloading...
		download_sdl_mixer
	fi

	if [[ -d external_libs/SDL_mixer ]]; then
		echo found SDL_mixer - building...
		build_sdl_mixer
	fi
}

function download_fluidsynth {
	cd external_libs
	git clone https://github.com/EtherTyper/fluidsynth-lite.git
	cd ..
	curl -o res/music.sf2 http://rancid.kapsi.fi/windows.sf2
}

function build_fluidsynth {
	cd external_libs
	if ! [[ -d fluidsynth-lite_built ]]; then
		mkdir fluidsynth-lite_built
	fi
	cd fluidsynth-lite_built
	# this is an absolutely despicable hack to stop the silly errors without changing FluidSynth's CMakeLists.txt
	cmake -G Ninja -DCMAKE_C_COMPILER=clang -DBUILD_SHARED_LIBS=YES -DMSVC=1 -DCMAKE_C_FLAGS="-Wno-error" ../fluidsynth-lite
	cmake --build .
	cp ../fluidsynth-lite_built/include/fluidsynth/version.h ../fluidsynth-lite/include/fluidsynth/version.h
	cd ../..
	cp external_libs/fluidsynth-lite_built/src/*.dll . 2>/dev/null
}

function get_fluidsynth {
	if ! [[ -d external_libs/fluidsynth-lite ]]; then
		echo FluidSynth was not found - downloading...
		download_fluidsynth
	fi

	if [[ -d external_libs/fluidsynth-lite ]]; then
		echo found FluidSynth - building...
		build_fluidsynth
	fi
}

if ! [[ -d external_libs ]]; then
	mkdir external_libs
fi

if [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
	get_glew
fi

get_sdl
get_sdl_mixer
get_fluidsynth