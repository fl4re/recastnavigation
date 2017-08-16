#!/bin/sh -e
CMAKE_GENERATOR="Xcode"
CMAKE_FLAGS="-DCMAKE_CXX_COMPILER=clang++ \
             -DCMAKE_C_COMPILER=clang \
             -DCMAKE_CXX_FLAGS=\"-std=c++11 -stdlib=libc++ \" \
             -DCMAKE_OSX_ARCHITECTURES=\"x86_64\" \
             -DCMAKE_OSX_DEPLOYMENT_TARGET=10.11 \
             -DCMAKE_DEBUG_POSTFIX=d"
ITS_APPLE=1

ROOT_DIR=$PWD
BUILD_DIR=$ROOT_DIR/"build_XCode"
INSTALL_DIR=$ROOT_DIR/binary_distrib

cmake -E make_directory "$BUILD_DIR"
cmake -E make_directory "$INSTALL_DIR"

cmake -E chdir "$BUILD_DIR" cmake -G "$CMAKE_GENERATOR" -DCMAKE_INSTALL_PREFIX="$INSTALL_DIR" "$ROOT_DIR"

echo "Installing Recast in $INSTALL_DIR"
cmake --build "$BUILD_DIR" --config Release --target install

cmake -E copy_directory $ROOT_DIR/Recast/Include $INSTALL_DIR/include
cmake -E copy_directory $ROOT_DIR/Detour/Include $INSTALL_DIR/include
cmake -E copy_directory $ROOT_DIR/DetourCrowd/Include $INSTALL_DIR/include
cmake -E copy_directory $ROOT_DIR/DetourTileCache/Include $INSTALL_DIR/include
cmake -E copy_directory $ROOT_DIR/DebugUtils/Include $INSTALL_DIR/include

exit 0
