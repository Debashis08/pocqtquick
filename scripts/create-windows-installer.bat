@echo off
setlocal

:: ==========================================
:: CONFIGURATION
:: ==========================================

:: 1. Tools Paths
set "QT_ENV_SCRIPT=C:\Qt\6.10.1\msvc2022_64\bin\qtenv2.bat"
set "IFW_BIN=C:\Qt\Tools\QtInstallerFramework\4.10\bin"

:: 2. Input Paths (Where the EXE and QML files are)
set "QML_SOURCE_DIR=D:\repositories\pocqtquick\source\ui"
set "STAGING_EXE=D:\repositories\pocqtquickdeployment\packages\com.pocqtquick\data\counter_app.exe"
set "CONFIG_XML=D:\repositories\pocqtquickdeployment\config\config.xml"
set "PACKAGES_DIR=D:\repositories\pocqtquickdeployment\packages"

:: 3. Output Path (Where you want the final installer to appear)
set "OUTPUT_DIR=D:\repositories\pocqtquick-local-build"
set "INSTALLER_NAME=pocqtquick_installer.exe"

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
echo STEP 2: Running windeployqt (Dependency Injection)...
echo ----------------------------------------------------------------
:: Run deployment tool on the exe sitting in the packages/data folder
windeployqt --release --qmldir "%QML_SOURCE_DIR%" "%STAGING_EXE%"

echo.
echo ----------------------------------------------------------------
echo STEP 3: Generating Installer (binarycreator)...
echo ----------------------------------------------------------------

:: Create the output directory if it doesn't exist
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

"%IFW_BIN%\binarycreator.exe" -c "%CONFIG_XML%" -p "%PACKAGES_DIR%" "%OUTPUT_DIR%\%INSTALLER_NAME%"

echo.
echo ----------------------------------------------------------------
echo [SUCCESS] Installer created at:
echo %OUTPUT_DIR%\%INSTALLER_NAME%
echo ----------------------------------------------------------------

pause