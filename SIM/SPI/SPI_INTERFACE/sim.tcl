puts "---"
puts "xvlog running"
set cmd_xvlog "xvlog --incr --relax --sv --log ./log_files/xvlog_log.log -i $INCLUDE_FILES_DIRECTORIES --work ./library_generated $GLOBAL_FILE $SPI_INTERFACE_VERILOG_TESTBENCHS_STR $SPI_INTERFACE_VERILOG_STR"
eval exec $cmd_xvlog
puts "xvlog done"
puts "---"

puts "---"
puts "xelab running"
set cmd_xelab "xelab --incr --debug typical --relax --log ./log_files/xelab_log.log -i $INCLUDE_FILES_DIRECTORIES -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot ./snapshot_xsim library_generated.spi_interface_tb library_generated.glbl"
eval exec $cmd_xelab
puts "xelab done"
puts "---"

puts "---"
puts "xsim running"
set cmd_xsim "xsim ./snapshot_xsim -log ./log_files/xsim_log.log -gui -tclbatch wave.tcl"
eval exec $cmd_xsim
puts "xsim done"
puts "---"
