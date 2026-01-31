@echo off
setlocal enabledelayedexpansion

:: ANSI color setup
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "BLUE=%ESC%[34m"
set "GREEN=%ESC%[32m"
set "RED=%ESC%[31m"
set "RESET=%ESC%[0m"

:: configurations
:: 1. Tools Paths
set "QT_ENV_SCRIPT=C:\Qt\6.10.1\msvc2022_64\bin\qtenv2.bat"

:: [CHANGED] Point to Inno Setup Compiler
set "INNO_COMPILER=C:\Program Files (x86)\Inno Setup 6\ISCC.exe"

:: path resolution
:: Directory of this script: <repo-root>\scripts
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Repo root: <repo-root>
for %%I in ("%SCRIPT_DIR%\..") do set "REPO_ROOT=%%~fI"

:: Project paths
set "SOURCE_DIR=%REPO_ROOT%"
set "QML_DIR=%SOURCE_DIR%\src\ui"
set "APP_NAME=appCounterApp.exe"

:: [CHANGED] Inno Setup output filename (No .exe extension here, Inno adds it)
set "INSTALLER_BASENAME=pocqtquick-installer-Windows-x64"

:: [CHANGED] Path to your new .iss file
set "ISS_SCRIPT=%SOURCE_DIR%\installer\windows-setup.iss"

:: Build & output paths (outside repo root)
for %%I in ("%REPO_ROOT%\..\pocqtquick-local-build") do set "BUILD_ROOT=%%~fI"

set "BUILD_DIR=%BUILD_ROOT%\build"
set "INSTALLER_DIR=%BUILD_ROOT%"
set "LOCAL_APP_DIR=%BUILD_ROOT%\pocqtquick"

echo.
echo %BLUE% Dynamic Paths Detected%RESET%
echo %BLUE% Source:         %SOURCE_DIR%%RESET%
echo %BLUE% QML Dir:        %QML_DIR%%RESET%
echo %BLUE% ISS Script:     %ISS_SCRIPT%%RESET%
echo %BLUE% App Name:       %APP_NAME%%RESET%
echo %BLUE% Build Dir:      %BUILD_DIR%%RESET%
echo %BLUE% Staging Dir:    %LOCAL_APP_DIR%%RESET%
echo %BLUE% Installer Dir:  %INSTALLER_DIR%%RESET%

:: execution steps
echo.
echo %BLUE%Step 0: Cleaning previous build artifacts%RESET%

if exist "%BUILD_DIR%" (
    echo Removing old build directory
    rmdir /s /q "%BUILD_DIR%"
)

if exist "%LOCAL_APP_DIR%" (
    echo Removing old app directory
    rmdir /s /q "%LOCAL_APP_DIR%"
)

echo.
echo %BLUE%Step 1: Setting up Qt Environment%RESET%

call "%QT_ENV_SCRIPT%"

echo.
echo %BLUE%Step 2: Setting up MSVC Compiler (vcvars64)%RESET%

:: NOTE: Keeping your specific VS path logic
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
echo %BLUE%Step 3: Configuring CMake (Ninja)%RESET%

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"

cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release "%SOURCE_DIR%"

if %errorlevel% neq 0 (
    echo %RED%[ERROR] CMake configuration failed.%RESET%
    pause
    exit /b %errorlevel%
)

echo.
echo %BLUE%Step 4: Compiling Application%RESET%

cmake --build . --config Release

if %errorlevel% neq 0 (
    echo %RED%[ERROR] Compilation failed.%RESET%
    pause
    exit /b %errorlevel%
)

echo.
echo %BLUE%Step 5: Creating Runnable App Folder%RESET%

if not exist "%LOCAL_APP_DIR%" mkdir "%LOCAL_APP_DIR%"

:: fix: Added "\src\" because CMake places the binary there
if not exist "%BUILD_DIR%\src\%APP_NAME%" (
    echo %RED%[ERROR] File not found:%RESET%
    echo %RED%        %BUILD_DIR%\src\%APP_NAME%%RESET%
    echo %RED%Please verify the output directory or target name.%RESET%
    pause
    exit /b 1
)

copy /Y "%BUILD_DIR%\src\%APP_NAME%" "%LOCAL_APP_DIR%\%APP_NAME%"

echo.
echo %BLUE%Step 6: Running Windeployqt (Dependency Injection)%RESET%

echo %BLUE%Target:  %LOCAL_APP_DIR%\%APP_NAME%%RESET%
echo %BLUE%QML Dir: %QML_DIR%%RESET%

windeployqt --release --compiler-runtime --no-translations --no-opengl-sw --qmldir "%QML_DIR%" "%LOCAL_APP_DIR%\%APP_NAME%"

:: Cleanup unnecessary files (matches your YAML logic)
del "%LOCAL_APP_DIR%\*.obj" "%LOCAL_APP_DIR%\*.cpp" "%LOCAL_APP_DIR%\*.h" "%LOCAL_APP_DIR%\*.cmake" 2>nul

echo.
echo %BLUE%Step 7: Generating Installer (Inno Setup)%RESET%

:: [FIX] Use !INNO_COMPILER! (with exclamation marks) to safely handle (x86) parentheses
if not exist "!INNO_COMPILER!" (
    echo %RED%[ERROR] Inno Setup Compiler not found at: !INNO_COMPILER!%RESET%
    echo %RED%Please install Inno Setup or fix the path.%RESET%
    pause
    exit /b 1
)

:: Ensure output directory exists
if not exist "%INSTALLER_DIR%" mkdir "%INSTALLER_DIR%"

:: Run ISCC
:: /O -> Output Path
:: /F -> Output Filename (no extension)
:: /D -> Define constants (SourceDir, ExeName)
"!INNO_COMPILER!" "/O%INSTALLER_DIR%" "/F%INSTALLER_BASENAME%" "/DMyAppSourceDir=%LOCAL_APP_DIR%" "/DMyAppExeName=%APP_NAME%" "/DMyOutputFilename=%INSTALLER_BASENAME%" "%ISS_SCRIPT%"

if %errorlevel% neq 0 (
    echo %RED%[ERROR] Installer generation failed.%RESET%
    pause
    exit /b %errorlevel%
)

echo.
echo %GREEN%[SUCCESS] Build Complete.%RESET%
echo %GREEN%Installer created at:%RESET%
echo %GREEN%%INSTALLER_DIR%\%INSTALLER_BASENAME%.exe%RESET%
echo.

pause