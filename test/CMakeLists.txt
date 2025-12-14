find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 Test)

# === BACKEND TEST ===
add_executable(tst_counter
    backend/counterTest.cpp
    ${CMAKE_SOURCE_DIR}/source/backend/counter.cpp
)

target_include_directories(tst_counter PRIVATE
    ${CMAKE_SOURCE_DIR}/source
)

target_link_libraries(tst_counter PRIVATE
    Qt::Core
    Qt::Test
)

add_test(NAME CounterTest COMMAND tst_counter)

# === UI TEST ===
add_executable(tst_ui
    ui/MainQmlTest.cpp
    ${CMAKE_SOURCE_DIR}/source/backend/counter.cpp
    ${CMAKE_SOURCE_DIR}/source/qml.qrc
)

target_include_directories(tst_ui PRIVATE
    ${CMAKE_SOURCE_DIR}/source
)

target_link_libraries(tst_ui PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    Qt::Test
)

add_test(NAME UiQmlTest COMMAND tst_ui)
