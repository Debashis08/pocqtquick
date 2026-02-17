cmake_minimum_required(VERSION 3.16)

# Load Secrets & Environment Variables
include("${CMAKE_SOURCE_DIR}/Secrets.local.cmake" OPTIONAL)

set(GOOGLE_CLIENT_ID "$ENV{GOOGLE_CLIENT_ID}")
set(GOOGLE_CLIENT_SECRET "$ENV{GOOGLE_CLIENT_SECRET}")

if(NOT GOOGLE_CLIENT_ID OR NOT GOOGLE_CLIENT_SECRET)
    message(WARNING "BackendLib: Google OAuth keys are missing. Auth will not work.")
endif()

find_package(Qt6 REQUIRED COMPONENTS Quick Qml)

# Define Source Files
set(BACKEND_SOURCES
    interfaces/ICounterService.h
    
    core/LoggerService.h
    core/LoggerService.cpp
    
    core/ServiceProvider.h         
    core/ServiceProvider.cpp       
    core/ServiceInitializer.h     
    core/ServiceInitializer.cpp   
    
    services/CounterService.cpp
    services/CounterService.h
    
    viewmodels/CounterViewModel.cpp
    viewmodels/CounterViewModel.h
)

# Create QML Module
qt_add_qml_module(BackendLib
    STATIC
    URI "App.Backend"
    VERSION 1.0
    SOURCES ${BACKEND_SOURCES}
)

# Inject Secrets into C++
target_compile_definitions(BackendLib PRIVATE
    CLIENT_ID="${GOOGLE_CLIENT_ID}"
    CLIENT_SECRET="${GOOGLE_CLIENT_SECRET}"
)

# Include Directories
target_include_directories(BackendLib PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/interfaces
    ${CMAKE_CURRENT_SOURCE_DIR}/core
    ${CMAKE_CURRENT_SOURCE_DIR}/services
    ${CMAKE_CURRENT_SOURCE_DIR}/viewmodels
)

target_link_libraries(BackendLib 
    PRIVATE
    Qt6::Quick
    Qt6::Qml
)
