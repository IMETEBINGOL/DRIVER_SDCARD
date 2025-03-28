source -notrace file.tcl

# CREATE PROJECT 
create_project $PROJET_NAME ./vivado_project -in_memory -part $FPGA_PART -force
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property XPM_LIBRARIES {XPM_FIFO XPM_MEMORY} [current_project]
auto_detect_xpm


set_msg_config -suppress -severity INFO
#set_msg_config -suppress -severity WARNING

if {[info exists SOURCE_FILES] && [llength $SOURCE_FILES] > 0} {
    foreach file $SOURCE_FILES {
        read_verilog $file
    }
}

if {[info exists CONS_FILES] && [llength $CONS_FILES] > 0} {
    foreach file $CONS_FILES {
        read_xdc $file
    }
}

if {[info exists IP_FILES] && [llength $IP_FILES] > 0} {
    foreach file $IP_FILES {
        read_verilog -mode funcsim $file
    }
}

if {[info exists HEADER_FILES] && [llength $HEADER_FILES] > 0} {
    foreach file $HEADER_FILES {
        read_verilog -sv $file
    }
}


source -notrace elaborate.tcl

source -notrace implementation.tcl

source -notrace generate_bitstream.tcl