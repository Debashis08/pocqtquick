# -----------------------------------------------------------------------------
# 1. NEW: Load Secrets & Environment Variables
# -----------------------------------------------------------------------------
# Try to load local secrets file from the Project Root
include("${CMAKE_SOURCE_DIR}/Secrets.local.cmake" OPTIONAL)

# Read environment variables (set by file above or CI/CD)
set(GOOGLE_CLIENT_ID "$ENV{GOOGLE_CLIENT_ID}")
set(GOOGLE_CLIENT_SECRET "$ENV{GOOGLE_CLIENT_SECRET}")

# Check if keys are missing
if(NOT GOOGLE_CLIENT_ID OR NOT GOOGLE_CLIENT_SECRET)
    message(WARNING "BackendLib: Google OAuth keys are missing. Auth will not work.")
endif()


# -----------------------------------------------------------------------------
# Define Source Files
# -----------------------------------------------------------------------------
set(BACKEND_SOURCES
    core/LoggerService.h
    core/LoggerService.cpp
    services/CounterService.cpp
    services/CounterService.h
    viewmodels/CounterViewModel.cpp
    viewmodels/CounterViewModel.h
)

# -----------------------------------------------------------------------------
# Create QML Module (This creates the library 'BackendLib')
# -----------------------------------------------------------------------------
qt_add_qml_module(BackendLib
    STATIC
    URI "App.Backend"
    VERSION 1.0
    SOURCES ${BACKEND_SOURCES}

    # Redirect build output (Optional, as per your setup)
    # OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/staging/App/Backend"
)

# -----------------------------------------------------------------------------
# 2. NEW: Inject Secrets into C++ Code
# -----------------------------------------------------------------------------
# This passes the variables to the compiler specifically for this library.
# We wrap them in escaped quotes so C++ treats them as string literals ("...").
target_compile_definitions(BackendLib PRIVATE
    CLIENT_ID="${GOOGLE_CLIENT_ID}"
    CLIENT_SECRET="${GOOGLE_CLIENT_SECRET}"
)

# -----------------------------------------------------------------------------
# Explicitly add Subdirectories to Include Path
# -----------------------------------------------------------------------------
target_include_directories(BackendLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}           # Allows #include "viewmodels/CounterViewModel.h"
    ${CMAKE_CURRENT_SOURCE_DIR}/core
    ${CMAKE_CURRENT_SOURCE_DIR}/services  # Allows #include "CounterService.h"
    ${CMAKE_CURRENT_SOURCE_DIR}/viewmodels   # Allows #include "CounterViewModel.h"
)

# -----------------------------------------------------------------------------
# Link Dependencies
# -----------------------------------------------------------------------------
target_link_libraries(BackendLib PRIVATE Qt6::Quick)
