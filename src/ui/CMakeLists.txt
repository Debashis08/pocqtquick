# REMOVE THIS LINE:
# qt_add_library(UiLib STATIC) 

# USE THIS INSTEAD (Everything in one command):
qt_add_qml_module(UiLib
    STATIC                  # <--- Explicitly state it is a STATIC lib here
    URI "App.Ui"
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"  # <--- Standardizes the resource path

    # --- ADD THIS LINE ---
    # Redirect build output to a staging folder that matches the URI
    # OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/staging/App/Ui"

    QML_FILES
        Main.qml
        pages/CounterPage.qml
        components/StandardButton.qml
)

target_link_libraries(UiLib PRIVATE Qt6::Quick)
