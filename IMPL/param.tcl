# COMPILATION HLD IS STARTING ...
puts "VIVADO COMPILATION IS STARTING..."

# PARAMETER DECLERATION 
set PROJET_NAME GENERAL_DRIVER_FPGA
set FPGA_PART xc7a35t-1cpg236
set HDL_ROOT ../HDL
set CONS_ROOT ../CONS
set IP_ROOT ../IP
set PARAMETER_ROOT ../HDL/PARAMETER
if {![file isdirectory "output"]} {
    file mkdir "output"
}

source -notrace run.tcl
