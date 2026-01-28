qt_add_executable(appCounterApp
    main.cpp
)

set_target_properties(appCounterApp PROPERTIES WIN32_EXECUTABLE ON)

add_subdirectory(backend)
add_subdirectory(ui)

target_link_libraries(appCounterApp
    PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    BackendLib
    BackendLibplugin   # <--- CRITICAL: Must be here
    UiLib
    UiLibplugin        # <--- CRITICAL: Must be here
)
