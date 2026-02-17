cmake_minimum_required(VERSION 3.16)

project(UiTests LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickTest Test)

# Define the executable
qt_add_executable(tst_ui
    TestSetup.cpp
)

# 2. Link Dependencies
target_link_libraries(tst_ui
    PRIVATE
    Qt6::Quick
    Qt6::QuickTest
    Qt6::Test
    # C++ Backend Library
    BackendLib
    # QML UI Library
    UiLib
)

# Include Directories
target_include_directories(tst_ui PRIVATE
    ${CMAKE_SOURCE_DIR}/src/backend
    ${CMAKE_SOURCE_DIR}/src/backend/interfaces
    ${CMAKE_SOURCE_DIR}/src/backend/core
)

# Define Source Dir for QML engine
target_compile_definitions(tst_ui PRIVATE
    QUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
)



# Register the test using standard CMake
add_test(NAME tst_ui COMMAND tst_ui)

# Optional: If on Windows, you might need to ensure the test finds DLLs.
# This helper (available in Qt 6.3+) sets the environment.
# If this fails, just stick to the plain add_test line above.
if(COMMAND qt_add_test_helper)
    qt_add_test_helper(tst_ui)
endif()
