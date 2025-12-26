@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: CONFIGURATION
:: ==========================================

:: 1. Qt Environment
set "QT_ENV_SCRIPT=C:\Qt\6.10.1\msvc2022_64\bin\qtenv2.bat"

:: ==========================================
:: PATH RESOLUTION (NON-HARDCODED)
:: ==========================================

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
echo ================================================================
echo  DYNAMIC PATHS DETECTED
echo ================================================================
echo  Source:      %SOURCE_DIR%
echo  QML Dir:     %QML_DIR%
echo  App Name:    %APP_NAME%
echo  Build Dir:   %BUILD_DIR%
echo  Output Dir:  %LOCAL_APP_DIR%
echo ================================================================


:: ==========================================
:: EXECUTION
:: ==========================================

echo.
echo ----------------------------------------------------------------
echo STEP 0: Cleaning previous build artifacts...
echo ----------------------------------------------------------------
if exist "%BUILD_DIR%" (
    echo Removing old build directory...
    rmdir /s /q "%BUILD_DIR%"
)

if exist "%LOCAL_APP_DIR%" (
    echo Removing old app directory...
    rmdir /s /q "%LOCAL_APP_DIR%"
)

echo.
echo ----------------------------------------------------------------
echo STEP 1: Setting up Qt Environment...
echo ----------------------------------------------------------------
call "%QT_ENV_SCRIPT%"

echo.
echo ----------------------------------------------------------------
echo STEP 2: Setting up MSVC Compiler (vcvars64)...
echo ----------------------------------------------------------------
set "VCVARS_PATH="
if exist "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "VCVARS_PATH=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat"
)

if "%VCVARS_PATH%"=="" (
    echo [ERROR] Could not find vcvars64.bat!
    pause
    exit /b 1
)
call "%VCVARS_PATH%"

echo.
echo ----------------------------------------------------------------
echo STEP 3: Configuring CMake (Ninja)...
echo ----------------------------------------------------------------
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"

cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release "%SOURCE_DIR%"

if %errorlevel% neq 0 (
    echo [ERROR] CMake Configuration failed.
    pause
    exit /b %errorlevel%
)

echo.
echo ----------------------------------------------------------------
echo STEP 4: Compiling Application...
echo ----------------------------------------------------------------
cmake --build . --config Release

if %errorlevel% neq 0 (
    echo [ERROR] Compilation failed.
    pause
    exit /b %errorlevel%
)

echo.
echo ----------------------------------------------------------------
echo STEP 5: Creating Runnable App Folder...
echo ----------------------------------------------------------------
if not exist "%LOCAL_APP_DIR%" mkdir "%LOCAL_APP_DIR%"

:: FIX: Added "\source\" to the path because CMake placed the binary there
if not exist "%BUILD_DIR%\source\%APP_NAME%" (
    echo [ERROR] File not found at: "%BUILD_DIR%\source\%APP_NAME%"
    echo Please check if the 'source' folder name is correct.
    pause
    exit /b 1
)

copy /Y "%BUILD_DIR%\source\%APP_NAME%" "%LOCAL_APP_DIR%\%APP_NAME%"

echo.
echo ----------------------------------------------------------------
echo STEP 6: Running Windeployqt (Dependency Injection)...
echo ----------------------------------------------------------------
echo Target:  %LOCAL_APP_DIR%\%APP_NAME%
echo QML Dir: %QML_DIR%

windeployqt --release --qmldir "%QML_DIR%" "%LOCAL_APP_DIR%\%APP_NAME%"

echo.
echo ----------------------------------------------------------------
echo [SUCCESS] Build Complete.
echo Executable located at:
echo %LOCAL_APP_DIR%\%APP_NAME%
echo ----------------------------------------------------------------

pause