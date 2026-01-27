add_executable(tst_ui
    MainQmlTest.cpp
)

target_link_libraries(tst_ui
    PRIVATE
    Qt6::QuickTest
    BackendLib
    BackendLibplugin
    UiLib
    UiLibplugin
)

# Tell the runner to scan the current directory for .qml test files
target_compile_definitions(tst_ui PRIVATE 
    QUICK_TEST_SOURCE_DIR="${CMAKE_CURRENT_SOURCE_DIR}"
)

add_test(NAME UiTest COMMAND tst_ui)