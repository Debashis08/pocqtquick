qt_add_qml_module(UiLib
    # Explicitly state it is a STATIC lib here
    STATIC
    URI "App.Ui"
    VERSION 1.0
    # Standardizes the resource path
    RESOURCE_PREFIX "/qt/qml"

    # Redirect build output to a staging folder that matches the URI
    # OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/staging/App/Ui"

    QML_FILES
        Main.qml
        pages/CounterPage.qml
        components/StandardButton.qml
)

target_link_libraries(UiLib PRIVATE Qt6::Quick)
