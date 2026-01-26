cmake_minimum_required(VERSION 3.16)

project(CounterApp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 COMPONENTS Quick Test REQUIRED)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)

# Add Source Code
add_subdirectory(source)

# Add Tests (Only if testing is enabled)
# enable_testing()
# add_subdirectory(tests)
