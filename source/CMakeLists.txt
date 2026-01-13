# Define the executable target for our application.
# We list all the necessary source and resource files to build it.
# CMake's AUTORCC will handle the qml.qrc file.
# CMake's AUTOMOC will handle the counter.h header.
# Try to load secrets from the root directory (Project Root)
# CMAKE_SOURCE_DIR usually points to 'root' if you build from top level.
include("${CMAKE_SOURCE_DIR}/Secrets.local.cmake" OPTIONAL)

# Read the environment variables (from file OR from CI/CD system)
set(GOOGLE_CLIENT_ID "$ENV{GOOGLE_CLIENT_ID}")
set(GOOGLE_CLIENT_SECRET "$ENV{GOOGLE_CLIENT_SECRET}")

# Verify keys exist (Optional: Warn if missing)
if(NOT GOOGLE_CLIENT_ID OR NOT GOOGLE_CLIENT_SECRET)
    message(WARNING "Google OAuth keys are missing. Auth will not work.")
endif()

# Pass these into the C++ Code as Preprocessor Macros
add_compile_definitions(APP_GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID})
add_compile_definitions(APP_GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET})

add_executable(counter_app WIN32
    main.cpp
    qml.qrc
    backend/counter.cpp
    backend/counter.h
)

# Link our executable against the Qt libraries we found in the root CMake file.
# This ensures our application has access to all the required Qt functionality.
target_link_libraries(counter_app PRIVATE
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
)

# Add the current source directory to the include path. This helps the
# compiler find header files (like "backend/counter.h" from main.cpp).
target_include_directories(counter_app PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)
