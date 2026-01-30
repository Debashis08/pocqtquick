qt_add_executable(appCounterApp
    main.cpp
)

# --- ADD THIS BLOCK ---
# This embeds the file at the root path ":/" which is where Qt looks for it.
qt_add_resources(appCounterApp "configuration"
    PREFIX "/"
    FILES "pocqtquick-qtquickcontrols2.conf"
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
