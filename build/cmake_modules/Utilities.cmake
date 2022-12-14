function(target_add_conditional_sources target condition_var)
   if(NOT ${condition_var})
      set_source_files_properties(${ARGN} PROPERTIES HEADER_FILE_ONLY TRUE)
   endif(NOT ${condition_var})
   set_property(TARGET ${target} APPEND PROPERTY SOURCES ${ARGN})
endfunction()

function(install_and_preserve_hierarchy destination)
   foreach(item ${ARGN})
      get_filename_component(item_path "${item}" PATH)
      install(FILES ${item} DESTINATION "${destination}/${item_path}")
   endforeach()
endfunction()

function(test_base target)
   add_executable(${target} ${ARGN})
   add_test(NAME ${target} COMMAND $<TARGET_FILE:${target}>)
endfunction()
