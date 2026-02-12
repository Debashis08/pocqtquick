function(add_backend_test test_name file_path)
    add_executable(${test_name} ${file_path})

    target_link_libraries(${test_name} 
        PRIVATE 
        Qt6::Test
        Qt6::Qml
        BackendLib 
        BackendLibplugin
    )

    target_include_directories(${test_name} 
        PRIVATE 
        ${CMAKE_SOURCE_DIR}/src/backend
    )

    add_test(NAME ${test_name} COMMAND ${test_name})
endfunction()
