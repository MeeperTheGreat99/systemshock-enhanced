if ! [[ -d build ]]; then
	mkdir build
fi

cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=Debug ..
cmake --build .