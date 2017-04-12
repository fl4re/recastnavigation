setlocal EnableDelayedExpansion

@echo OFF

set OLDPATH=%PATH%
set OLDINCLUDE = INCLUDE%;

call "%VS140COMNTOOLS%../../VC/bin/amd64/vcvars64.bat"
if !errorlevel! neq 0 exit /b !errorlevel!
set TOOLSVERSION=14.0

set ROOT_DIR=%cd%
set BUILD_DIR=%ROOT_DIR%\binary_distrib
set RECAST_DIR=%BUILD_DIR%\itsRecast.dir
set RECAST_RELEASE_DIR=%RECAST_DIR%\Release
set RECAST_DEBUG_DIR=%RECAST_DIR%\Debug
set RELEASE_DIR=%BUILD_DIR%\Release
set DEBUG_DIR=%BUILD_DIR%\Debug

set DETOUR_DIR[0]=%ROOT_DIR%\Detour\Source
set DETOUR_DIR[1]=%ROOT_DIR%\DetourCrowd\Source
set DETOUR_DIR[2]=%ROOT_DIR%\DetourTileCache\Source
set DETOUR_DIR[3]=%ROOT_DIR%\Recast\Source
set DETOUR_DIR[4]=%ROOT_DIR%\DebugUtils\Source

if not exist "%BUILD_DIR%" md "%BUILD_DIR%"
if not exist "%RECAST_DIR%" md "%RECAST_DIR%"
if not exist "%RELEASE_DIR%" md "%RELEASE_DIR%"
if not exist "%DEBUG_DIR%" md "%DEBUG_DIR%"
if not exist "%RECAST_RELEASE_DIR%" md "%RECAST_RELEASE_DIR%"
if not exist "%RECAST_DEBUG_DIR%" md "%RECAST_DEBUG_DIR%"

set INCLUDE=%INCLUDE%;%ROOT_DIR%/Detour/Include;%ROOT_DIR%/DetourCrowd/Include;%ROOT_DIR%/DetourTileCache/Include;%ROOT_DIR%/Recast/Include;%ROOT_DIR%/DebugUtils/Include

for /F "tokens=2 delims==" %%s in ('set DETOUR_DIR[') DO (
	cd %%s
	for %%a in (*.cpp) do (		
	    cl /c /Zi /nologo /W3 /WX /O2 /Ob2 /Oi /D WIN32 /D _WINDOWS /D _CONSOLE /D NDEBUG /D _CRT_SECURE_NO_WARNINGS /D _MBCS /Gm- /EHsc /MD /GS- /fp:precise /Zc:wchar_t /Zc:forScope /Zc:inline /GR /I"%%INCLUDE%%" /Fo"%RECAST_RELEASE_DIR%\%%~na.obj" %%a /Fd"%RECAST_RELEASE_DIR%\itsRecast.pdb" /Gd /TP /errorReport:prompt  /bigobj
	    cl /c /Zi /nologo /W3 /WX /Od /Ob0 /D WIN32 /D _WINDOWS /D _DEBUG /D EBUG /D _ITERATOR_DEBUG_LEVEL=1 /D _CRT_SECURE_NO_WARNINGS /D _MBCS /Gm- /EHsc /RTC1 /MDd /GS /fp:precise /Zc:wchar_t /Zc:forScope /Zc:inline /GR /I"%%INCLUDE%%" /Fo"%RECAST_DEBUG_DIR%\%%~na.obj" %%a /Fd"%RECAST_DEBUG_DIR%\itsRecast.pdb" /Gd /TP /errorReport:prompt /we4189  /bigobj
	    if !errorlevel! neq 0 exit /b !errorlevel!
	)
	cd %ROOT_DIR%
)

lib /OUT:"%DEBUG_DIR%\itsRecast_d.lib" /NOLOGO /MACHINE:X64  /machine:x64 %RECAST_DEBUG_DIR%\Recast.obj
if !errorlevel! neq 0 exit /b !errorlevel!
lib /OUT:"%RELEASE_DIR%\itsRecast.lib" /NOLOGO /MACHINE:X64  /machine:x64 %RECAST_RELEASE_DIR%\Recast.obj
if !errorlevel! neq 0 exit /b !errorlevel!

set PATH=%OLDPATH%
set INCLUDE= %OLDINCLUDE%
exit /b 0
