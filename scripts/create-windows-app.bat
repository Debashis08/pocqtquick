@echo off
setlocal

:: ==========================================
:: CONFIGURATION
:: ==========================================

:: 1. Qt Environment (Adjust path if needed)
set "QT_ENV_SCRIPT=C:\Qt\6.10.1\msvc2022_64\bin\qtenv2.bat"

:: 2. Project Paths
set "SOURCE_DIR=D:\repositories\pocqtquick"
set "BUILD_DIR=D:\repositories\pocqtquick-local-build\build"

:: 3. Destination for the compiled EXE (The "data" folder in your deployment repo)
set "DEPLOYMENT_DATA_DIR=D:\repositories\pocqtquickdeployment\packages\com.pocqtquick\data"
set "APP_NAME=counter_app.exe"

:: ==========================================
:: EXECUTION
:: ==========================================

echo.
echo ----------------------------------------------------------------
echo STEP 1: Setting up Qt Environment...
echo ----------------------------------------------------------------
call "%QT_ENV_SCRIPT%"

echo.
echo ----------------------------------------------------------------
echo STEP 2: Configuring CMake...
echo ----------------------------------------------------------------
if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
cd /d "%BUILD_DIR%"

:: Configure using Ninja (faster) or "Visual Studio 17 2022"
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Release "%SOURCE_DIR%"

echo.
echo ----------------------------------------------------------------
echo STEP 3: Compiling Application...
echo ----------------------------------------------------------------
cmake --build . --config Release

echo.
echo ----------------------------------------------------------------
echo STEP 4: Copying Executable to Deployment Staging Area...
echo ----------------------------------------------------------------
:: Copy the built exe to the folder where Qt Installer Framework expects it
copy /Y "%BUILD_DIR%\%APP_NAME%" "%DEPLOYMENT_DATA_DIR%\%APP_NAME%"

if %errorlevel% neq 0 (
    echo [ERROR] Could not copy the executable. Check if the build succeeded.
    pause
    exit /b %errorlevel%
)

echo.
echo [SUCCESS] App built and copied to:
echo %DEPLOYMENT_DATA_DIR%\%APP_NAME%
echo ----------------------------------------------------------------

pause