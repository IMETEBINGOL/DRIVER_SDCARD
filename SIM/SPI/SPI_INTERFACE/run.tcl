puts "THE SIMULATION OF SPI INTERFACE IS STARTING..."


# SOURCE DIRECTORIES PARAMETER
set TESTBENCH_DIRECTORIES TESTBENCH
set SPI_INTERFACE_DIRECTORIES ../../../HDL/SPI/SPI_INTERFACE
set INCLUDE_FILES_DIRECTORIES ../../../HDL/PARAMETER

source -notrace file.tcl

source -notrace sim.tcl


