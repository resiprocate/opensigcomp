
set(INCLUDES
   BitBuffer.h
   Buffer.h
   Compartment.h
   CompartmentMap.h
   CompressorData.h
   Compressor.h
   CrcComputer.h
   DeflateCompressor.h
   DeflateData.h
   DeflateDictionary.h
   LeakDebug.h
   Libc.h
   MultiBuffer.h
   MutexLockable.h
   NackCodes.h
   NackMap.h
   ProfileStack.h
   ReadWriteLockable.h
   Sha1Hasher.h
   SigcompMessage.h
   SipDictionary.h
   Stack.h
   StateChanges.h
   State.h
   StateHandler.h
   StateList.h
   StateMap.h
   TcpStream.h
   Types.h
   Udvm.h
   UdvmOpcodes.h
   )

set(INCLUDES_GEN
   DeflateBytecodes.h
   )
set_source_files_properties(DeflateBytecodes.h PROPERTIES GENERATED TRUE)

add_library(opensigcomp
   BitBuffer.cpp
   Buffer.cpp
   Compartment.cpp
   CompartmentMap.cpp
   Compressor.cpp
   CompressorData.cpp
   CrcComputer.cpp
   DeflateBytecodes.cpp
   DeflateCompressor.cpp
   DeflateData.cpp
   DeflateDictionary.cpp
   MultiBuffer.cpp
   NackCodes.cpp
   NackMap.cpp
   Sha1Hasher.cpp
   SigcompMessage.cpp
   SipDictionary.cpp
   Stack.cpp
   StateChanges.cpp
   State.cpp
   StateHandler.cpp
   StateList.cpp
   StateMap.cpp
   TcpStream.cpp
   Udvm.cpp
   ${INCLUDES}
   ${INCLUDES_GEN}
   )

set_target_properties(opensigcomp PROPERTIES SOVERSION 0)

function(run_udvm_asm)
   add_custom_command(
      OUTPUT ${ARGV0}.udo
      COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tools/udvm_asm.pl ${CMAKE_CURRENT_SOURCE_DIR}/${ARGV0}.asm ${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}.udo ${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}.sym
   )
endfunction()
run_udvm_asm(Deflate)

function(run_bytecodes2class)
   add_custom_command(
      DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}.udo
      OUTPUT ${ARGV0}Bytecodes.h ${ARGV0}Bytecodes.cpp
      COMMAND ${PERL_EXECUTABLE} ${CMAKE_SOURCE_DIR}/tools/bytecodes2class.pl ${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}.udo ${ARGV0}Bytecodes ${CMAKE_CURRENT_BINARY_DIR}/${ARGV0}.sym
   )   
endfunction()
run_bytecodes2class(Deflate)

target_include_directories(opensigcomp PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
                                              $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)
target_link_libraries(opensigcomp PUBLIC ${OPENSSL_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

include(CMakePackageConfigHelpers)
configure_package_config_file(opensigcompConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/opensigcompConfig.cmake
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/osc
  )
write_basic_package_version_file(
   ${CMAKE_CURRENT_BINARY_DIR}/opensigcompConfigVersion.cmake
   VERSION ${CMAKE_PROJECT_VERSION}
   COMPATIBILITY SameMajorVersion
   )

install(TARGETS opensigcomp EXPORT opensigcompTargets LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

install(EXPORT opensigcompTargets
        FILE opensigcompTargets.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/opensigcomp
)

install(FILES ${INCLUDES} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/osc)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/opensigcompConfig.cmake
              ${CMAKE_CURRENT_BINARY_DIR}/opensigcompConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/opensigcomp)

add_subdirectory(test)

