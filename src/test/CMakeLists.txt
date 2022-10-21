function(test)
   test_base(${ARGV})
   set_target_properties(${ARGV0} PROPERTIES FOLDER src/Tests)
   target_include_directories(${ARGV0} PUBLIC opensigcomp)
   target_link_libraries(${ARGV0} PUBLIC opensigcomp)
   set_tests_properties(${ARGV0} PROPERTIES WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endfunction()

function(testutility)
   add_executable(${ARGV})
   target_include_directories(${ARGV0} PUBLIC opensigcomp)
   target_link_libraries(${ARGV0} PUBLIC opensigcomp)
endfunction()


test(unit-test 
   inflate.cpp
   main.cpp
   osc_generators.cpp
   sha1_hash_vector.cpp
   TestList.cpp
   test_osc_BitBuffer.cpp
   test_osc_Buffer.cpp
   test_osc_Compartment.cpp
   test_osc_CompartmentMap.cpp
   test_osc_Compressor.cpp
   test_osc_CompressorData.cpp
   test_osc_CrcComputer.cpp
   test_osc_DeflateCompressor.cpp
   test_osc_DeflateData.cpp
   test_osc_DeflateDictionary.cpp
   test_osc_MultiBuffer.cpp
   test_osc_MutexLockable.cpp
   test_osc_NackMap.cpp
   test_osc_ReadWriteLockable.cpp
   test_osc_Sha1Hasher.cpp
   test_osc_SigcompMessage.cpp
   test_osc_SipDictionary.cpp
   test_osc_Stack.cpp
   test_osc_StateChanges.cpp
   test_osc_State.cpp
   test_osc_StateHandler.cpp
   test_osc_StateList.cpp
   test_osc_StateMap.cpp
   test_osc_TcpStream.cpp
   test_osc_Udvm.cpp
   torture_tests.cpp
   )

testutility(speed-test speed_test.cpp)
testutility(sha1-speed-test sha1_speed_test.cpp)
testutility(object-size object_size.cpp)
testutility(pcap-read pcap_read.cpp)
testutility(massive-thread-test massive_thread_test.cpp)

