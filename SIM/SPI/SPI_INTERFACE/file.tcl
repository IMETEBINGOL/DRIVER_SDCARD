# glob => command is used to retrieve all files matching a pattern.
# -nocomplain => Prevents errors if the directory is empty or if no files match the pattern.
proc collect_verilog_files {dir} {
    set files {}

    # Get all items in the directory
    foreach item [glob -nocomplain -directory $dir *] {
        if {[file isfile $item] && [string match "*.v" $item]} {
            # If it's a .v file, add it to the list
            lappend files $item
        } elseif {[file isdirectory $item]} {
            # If it's a directory, recurse into it
            set subfiles [collect_verilog_files $item]
            set files [concat $files $subfiles]
        }
    }
    
    return $files
}

set GLOBAL_FILE C:/Xilinx/Vivado/2023.2/data/verilog/src/glbl.v
set SPI_INTERFACE_VERILOG_STR [collect_verilog_files "$SPI_INTERFACE_DIRECTORIES"]
set SPI_INTERFACE_VERILOG_TESTBENCHS_STR [collect_verilog_files "$TESTBENCH_DIRECTORIES"]
