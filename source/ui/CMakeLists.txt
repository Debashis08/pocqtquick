# REMOVE THIS LINE:
# qt_add_library(UiLib STATIC) 

# USE THIS INSTEAD (Everything in one command):
qt_add_qml_module(UiLib
    STATIC                  # <--- Explicitly state it is a STATIC lib here
    URI "App.Ui"
    VERSION 1.0
    RESOURCE_PREFIX "/qt/qml"  # <--- Standardizes the resource path
    QML_FILES
        Main.qml
        pages/CounterPage.qml
        components/StandardButton.qml
)

target_link_libraries(UiLib PRIVATE Qt6::Quick)