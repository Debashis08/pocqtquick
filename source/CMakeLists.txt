# Define the executable target for our application.
# We list all the necessary source and resource files to build it.
# CMake's AUTORCC will handle the qml.qrc file.
# CMake's AUTOMOC will handle the counter.h header.
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
