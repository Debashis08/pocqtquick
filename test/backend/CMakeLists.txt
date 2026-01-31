# --- Test 1: Counter Service (Pure Logic) ---
add_executable(tst_CounterService
    services/tst_CounterService.cpp
)
target_link_libraries(tst_CounterService PRIVATE Qt6::Test BackendLib BackendLibplugin)
target_include_directories(tst_CounterService PRIVATE ${CMAKE_SOURCE_DIR}/source/backend)
add_test(NAME CounterServiceTest COMMAND tst_CounterService)

# --- Test 2: Counter Bridge (QML Integration) ---
add_executable(tst_CounterViewModel
    viewmodels/tst_CounterViewModel.cpp
)
target_link_libraries(tst_CounterViewModel PRIVATE Qt6::Test Qt6::Quick BackendLib BackendLibplugin)
target_include_directories(tst_CounterViewModel PRIVATE ${CMAKE_SOURCE_DIR}/source/backend)
add_test(NAME CounterViewModelTest COMMAND tst_CounterViewModel)