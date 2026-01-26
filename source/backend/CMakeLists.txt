# -----------------------------------------------------------------------------
# Define Source Files
# -----------------------------------------------------------------------------
set(BACKEND_SOURCES
    services/CounterService.cpp
    services/CounterService.h
    bridges/CounterBridge.cpp
    bridges/CounterBridge.h
)

# -----------------------------------------------------------------------------
# Create QML Module (This creates the library 'BackendLib')
# -----------------------------------------------------------------------------
qt_add_qml_module(BackendLib
    STATIC
    URI "App.Backend"
    VERSION 1.0
    SOURCES ${BACKEND_SOURCES}

    # --- ADD THIS LINE ---
    # Redirect build output to a staging folder that matches the URI
    OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/staging/App/Backend"
)

# -----------------------------------------------------------------------------
# FIX: Explicitly add Subdirectories to Include Path
# -----------------------------------------------------------------------------
target_include_directories(BackendLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}           # Allows #include "bridges/CounterBridge.h"
    ${CMAKE_CURRENT_SOURCE_DIR}/bridges   # Allows #include "CounterBridge.h"
    ${CMAKE_CURRENT_SOURCE_DIR}/services  # Allows #include "CounterService.h"
)

# -----------------------------------------------------------------------------
# Link Dependencies
# -----------------------------------------------------------------------------
target_link_libraries(BackendLib PRIVATE Qt6::Quick)
