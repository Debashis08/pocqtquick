cmake_minimum_required(VERSION 3.16)

project(CounterApp VERSION 0.1 LANGUAGES CXX)

# Tell CMake to look for .cmake files in the "cmake" folder
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS Quick Test QuickTest QuickControls2 REQUIRED)

# --- ADD THESE LINES ---
# QTP0001: Use the modern resource path ":/qt/qml/" by default
qt_policy(SET QTP0001 NEW)

# QTP0004: Automatically generate qmldir files for subfolders (pages, components)
qt_policy(SET QTP0004 NEW)
# -----------------------

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

set(QT_QML_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/qml")

# Add Source Code
add_subdirectory(src)

# Old way: list(APPEND QML_IMPORT_PATH "${CMAKE_BINARY_DIR}/staging")

# -----------------------------------------------------------------------------
# FIX: Explicitly add the staging root AND force it into the Cache
# -----------------------------------------------------------------------------
set(QML_IMPORT_PATH "${CMAKE_BINARY_DIR}/staging" CACHE STRING "Qt Creator QML Path" FORCE)


# Add Tests (Only if testing is enabled)
enable_testing()
add_subdirectory(tests)
