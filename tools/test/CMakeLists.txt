function(test)
   test_base(${ARGV})
   set_target_properties(${ARGV0} PROPERTIES FOLDER tools/Tests)
   target_include_directories(${ARGV0} PUBLIC opensigcomp)
   target_link_libraries(${ARGV0} PUBLIC opensigcomp)
   set_tests_properties(${ARGV0} PROPERTIES WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
endfunction()

function(run_comparison)
   add_test(NAME ${ARGV0}-1 COMMAND ${PERL_EXECUTABLE} ../udvm_asm.pl ${ARGV0}.asm ${ARGV0}.udo)
   add_test(NAME ${ARGV0}-2 COMMAND ../udvm_dasm ${ARGV0}.udo ${ARGV0}.1.asm)
   add_test(NAME ${ARGV0}-3 COMMAND ${PERL_EXECUTABLE} ../udvm_asm.pl ${ARGV0}.1.asm ${ARGV0}.1.udo)
   add_test(NAME ${ARGV0}-diff1 COMMAND diff ${ARGV0}.udo ${ARGV0}.1.udo)
   add_test(NAME ${ARGV0}-4 COMMAND ../udvm_dasm ${ARGV0}.1.udo ${ARGV0}.2.asm)
   add_test(NAME ${ARGV0}-diff2 COMMAND diff ${ARGV0}.2.asm ${ARGV0}.1.asm)
endfunction()

run_comparison(deflate)
run_comparison(epic)
run_comparison(lz77)
run_comparison(lzjh)
run_comparison(lzss)
run_comparison(lzw)



