# 1. Define the executable (Use qt_add_executable for Qt 6)
qt_add_executable(tst_ui
    TestSetup.cpp
    # MainQmlTest.cpp <--- REMOVE THIS. You already have a main() in TestSetup.cpp
)

# 2. Link Dependencies
target_link_libraries(tst_ui
    PRIVATE
    Qt6::Quick
    Qt6::QuickTest # Required for QML Testing
    Qt6::Qml
    BackendLib
    BackendLibplugin  # <-- Usually not needed if linking the Lib directly, but keep if strict
    UiLib
    UiLibplugin       # <-- Same as above
)

# 3. Fix: Use the correct target name "tst_ui"
target_include_directories(tst_ui PRIVATE
    ${CMAKE_SOURCE_DIR}/src/backend
    ${CMAKE_SOURCE_DIR}/src/backend/interfaces
    ${CMAKE_SOURCE_DIR}/src/backend/core
)

# 4. Copy the QML file to the build folder
target_compile_definitions(tst_ui PRIVATE
    QUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
)

# 5. Register the test
# Fix: The COMMAND must match the executable name defined at the top (tst_ui)
add_test(NAME tst_ui COMMAND tst_ui)
