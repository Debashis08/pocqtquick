@echo off
setlocal enabledelayedexpansion

:: ANSI color setup
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "BLUE=%ESC%[34m"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "RESET=%ESC%[0m"

:: configurations

:: 1. Qt Environment
set "QT_ENV_SCRIPT=C:\Qt\6.10.1\msvc2022_64\bin\qtenv2.bat"


:: path resolution


:: Directory of this script: <repo-root>\scripts
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Repo root: <repo-root>
for %%I in ("%SCRIPT_DIR%\..") do set "REPO_ROOT=%%~fI"

:: Project paths
set "SOURCE_DIR=%REPO_ROOT%"
set "QML_DIR=%SOURCE_DIR%\source\ui"
set "APP_NAME=counter_app.exe"

:: Build & output paths (outside repo root)
for %%I in ("%REPO_ROOT%\..\pocqtquick-local-build") do set "BUILD_ROOT=%%~fI"

set "BUILD_DIR=%BUILD_ROOT%\build"
set "LOCAL_APP_DIR=%BUILD_ROOT%\pocqtquick"

echo.
echo %BLUE%===============================================================%RESET%
echo %BLUE% DYNAMIC PATHS DETECTED%RESET%
echo %BLUE%===============================================================%RESET%
echo %BLUE% Source:      %SOURCE_DIR%%RESET%
echo %BLUE% QML Dir:     %QML_DIR%%RESET%
echo %BLUE% App Name:    %APP_NAME%%RESET%
echo %BLUE% Build Dir:   %BUILD_DIR%%RESET%
echo %BLUE% Output Dir:  %LOCAL_APP_DIR%%RESET%
echo %BLUE%===============================================================%RESET%

:: execution steps

echo.
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%STEP 0: Cleaning previous build artifacts...%RESET%
echo %BLUE%----------------------------------------------------------------%RESET%

if exist "%BUILD_DIR%" (
    echo %BLUE%Removing old build directory...%RESET%
    rmdir /s /q "%BUILD_DIR%"
)

if exist "%LOCAL_APP_DIR%" (
    echo %BLUE%Removing old app directory...%RESET%
    rmdir /s /q "%LOCAL_APP_DIR%"
)

echo.
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%STEP 1: Setting up Qt Environment...%RESET%
echo %BLUE%----------------------------------------------------------------%RESET%
call "%QT_ENV_SCRIPT%"

echo.
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%STEP 2: Setting up MSVC Compiler (vcvars64)...%RESET%
echo %BLUE%----------------------------------------------------------------%RESET%

set "VCVARS_PATH="
if exist "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "VCVARS_PATH=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat"
)

if "%VCVARS_PATH%"=="" (
    echo %RED%[ERROR] Could not find vcvars64.bat!%RESET%
    pause
    exit /b 1
)

call "%VCVARS_PATH%"

echo.
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%STEP 3: Configuring CMake (Ninja)...%RESET%
echo %BLUE%----------------------------------------------------------------%RESET%

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"

cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release "%SOURCE_DIR%"

if %errorlevel% neq 0 (
    echo %RED%[ERROR] CMake configuration failed.%RESET%
    pause
    exit /b %errorlevel%
)

echo.
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%STEP 4: Compiling Application...%RESET%
echo %BLUE%----------------------------------------------------------------%RESET%

cmake --build . --config Release

if %errorlevel% neq 0 (
    echo %RED%[ERROR] Compilation failed.%RESET%
    pause
    exit /b %errorlevel%
)

echo.
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%STEP 5: Creating Runnable App Folder...%RESET%
echo %BLUE%----------------------------------------------------------------%RESET%

if not exist "%LOCAL_APP_DIR%" mkdir "%LOCAL_APP_DIR%"

:: fix: Added "\source\" because CMake places the binary there
if not exist "%BUILD_DIR%\source\%APP_NAME%" (
    echo %RED%[ERROR] File not found:%RESET%
    echo %RED%        %BUILD_DIR%\source\%APP_NAME%%RESET%
    echo %RED%Please verify the output directory or target name.%RESET%
    pause
    exit /b 1
)

copy /Y "%BUILD_DIR%\source\%APP_NAME%" "%LOCAL_APP_DIR%\%APP_NAME%"

echo.
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%STEP 6: Running Windeployqt (Dependency Injection)...%RESET%
echo %BLUE%----------------------------------------------------------------%RESET%
echo %BLUE%Target:  %LOCAL_APP_DIR%\%APP_NAME%%RESET%
echo %BLUE%QML Dir: %QML_DIR%%RESET%

windeployqt --release --qmldir "%QML_DIR%" "%LOCAL_APP_DIR%\%APP_NAME%"

echo.
echo %GREEN%----------------------------------------------------------------%RESET%
echo %GREEN%[SUCCESS] Build Complete.%RESET%
echo %GREEN%Executable located at:%RESET%
echo %GREEN%%LOCAL_APP_DIR%\%APP_NAME%%RESET%
echo %GREEN%----------------------------------------------------------------%RESET%
echo.

pause