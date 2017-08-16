setlocal EnableDelayedExpansion

@echo off

set TOOLCHAIN=msvc2015

if %TOOLCHAIN% equ msvc2015 (
    set CMAKE_GENERATOR=Visual Studio 14 2015 Win64
    call "%VS140COMNTOOLS%..\..\VC\bin\amd64\vcvars64.bat"
    if !errorlevel! neq 0 exit /b !errorlevel!
) else (
    echo Failure: unknown msvc version: %TOOLCHAIN%
    exit /b 1
)

set ROOT_DIR=%cd%
set BUILD_DIR=%ROOT_DIR%/build_%CMAKE_GENERATOR%
set INSTALL_DIR=%ROOT_DIR%/binary_distrib

cmake -E make_directory "%BUILD_DIR%"
if !errorlevel! neq 0 exit /b !errorlevel!

cmake -E chdir "%BUILD_DIR%" cmake -G "%CMAKE_GENERATOR%" -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" "%ROOT_DIR%"
if !errorlevel! neq 0 exit /b !errorlevel!

echo "Installing Recast in %INSTALL_DIR%"
cmake --build "%BUILD_DIR%" --config Release --target install -- "/m"
if !errorlevel! neq 0 exit /b !errorlevel!

cmake -E copy_directory %ROOT_DIR%/Recast/Include %INSTALL_DIR%/include
if !errorlevel! neq 0 exit /b !errorlevel!

cmake -E copy_directory %ROOT_DIR%/Detour/Include %INSTALL_DIR%/include
if !errorlevel! neq 0 exit /b !errorlevel!

cmake -E copy_directory %ROOT_DIR%/DetourCrowd/Include %INSTALL_DIR%/include
if !errorlevel! neq 0 exit /b !errorlevel!

cmake -E copy_directory %ROOT_DIR%/DetourTileCache/Include %INSTALL_DIR%/include
if !errorlevel! neq 0 exit /b !errorlevel!

cmake -E copy_directory %ROOT_DIR%/DebugUtils/Include %INSTALL_DIR%/include
if !errorlevel! neq 0 exit /b !errorlevel!

set PATH=%OLDPATH%

exit /b 0