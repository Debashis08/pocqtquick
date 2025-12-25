@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: CONFIGURATION
:: ==========================================

:: 1. Qt Environment
set "QT_ENV_SCRIPT=C:\Qt\6.10.1\msvc2022_64\bin\qtenv2.bat"

:: 2. Project Paths
set "SOURCE_DIR=D:\repositories\pocqtquick"
set "BUILD_DIR=D:\repositories\pocqtquick-local-build\build"
set "DEPLOYMENT_DATA_DIR=D:\repositories\pocqtquickdeployment\packages\com.pocqtquick\data"
set "APP_NAME=counter_app.exe"

:: ==========================================
:: EXECUTION
:: ==========================================

echo.
echo ----------------------------------------------------------------
echo STEP 0: Cleaning previous build...
echo ----------------------------------------------------------------
:: We must remove old VS-generated build files to switch to Ninja
if exist "%BUILD_DIR%" (
    echo Removing old build artifacts...
    rmdir /s /q "%BUILD_DIR%"
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

:: Using the path found in your logs:
if exist "C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat" (
    set "VCVARS_PATH=C:\Program Files\Microsoft Visual Studio\18\Community\VC\Auxiliary\Build\vcvars64.bat"
)

if "%VCVARS_PATH%"=="" (
    echo [ERROR] Could not find vcvars64.bat!
    echo Please manually set the path to vcvars64.bat in this script.
    pause
    exit /b 1
)

echo Found compiler setup script at:
echo "%VCVARS_PATH%"
call "%VCVARS_PATH%"

echo.
echo ----------------------------------------------------------------
echo STEP 3: Configuring CMake (Ninja)...
echo ----------------------------------------------------------------
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"

:: Ninja will work because vcvars64 is active
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
echo STEP 5: Copying Executable...
echo ----------------------------------------------------------------
:: NOTE: Ninja puts the file in BUILD_DIR directly, NOT in a Release subfolder
copy /Y "%BUILD_DIR%\%APP_NAME%" "%DEPLOYMENT_DATA_DIR%\%APP_NAME%"

echo.
echo [SUCCESS] App built and copied to:
echo %DEPLOYMENT_DATA_DIR%\%APP_NAME%
echo ----------------------------------------------------------------

pause