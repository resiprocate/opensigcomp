
set(INCLUDES
   Disassembler.h
   )

add_executable(udvm_dasm
   Disassembler.cpp
   udvm_dasm.cpp
   ${INCLUDES}
   )

target_include_directories(udvm_dasm PUBLIC opensigcomp)
target_link_libraries(udvm_dasm PUBLIC opensigcomp)

# FIXME - run dot for svg / gif

add_subdirectory(test)

