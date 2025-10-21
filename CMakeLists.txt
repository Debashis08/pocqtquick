cmake_minimum_required(VERSION 3.16)

# Define the project name, version, and language.
project(QtCounterApp VERSION 1.0 LANGUAGES CXX)

# Set the C++ standard to C++17.
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# These settings are crucial for Qt projects with CMake. They automate the
# handling of Qt's meta-object compiler (moc), user interface compiler (uic),
# and resource compiler (rcc).
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Find the required Qt 6 packages. CMake will locate the necessary libraries
# and headers for these components. We also include Test for later.
find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 Test)

# Include the source subdirectory. CMake will process the CMakeLists.txt
# file located in the 'source' folder.
add_subdirectory(source)

# Enable the CTest testing framework for the project.
enable_testing()

# Include the test subdirectory. CMake will process the CMakeLists.txt
# file located in the 'test' folder.
add_subdirectory(test)
