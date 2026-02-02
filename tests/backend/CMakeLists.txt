# Load the helper file (CMake finds it because of Step 3)
include(TestUtils)

# Now just list your tests!
add_backend_test(tst_CounterService services/tst_CounterService.cpp)
add_backend_test(tst_CounterViewModel viewmodels/tst_CounterViewModel.cpp)
