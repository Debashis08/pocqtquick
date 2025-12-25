@echo off
setlocal enabledelayedexpansion

:: ==========================================
:: CONFIGURATION
:: ==========================================

:: 1. Qt Environment
set "QT_ENV_SCRIPT=C:\Qt\6.10.1\msvc2022_64\bin\qtenv2.bat"

:: 2. Project Paths
set "SOURCE_DIR=D:\repositories\pocqtquick"
set "QML_DIR=D:\repositories\pocqtquick\source\ui"
set "APP_NAME=counter_app.exe"

:: 3. Build & Output Paths
set "BUILD_DIR=D:\repositories\pocqtquick-local-build\build"
set "LOCAL_APP_DIR=D:\repositories\pocqtquick-local-build\pocqtquick"

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