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

proc collect_constraint_files {dir} {
    set files {}

    # Get all items in the directory
    foreach item [glob -nocomplain -directory $dir *] {
        if {[file isfile $item] && [string match "*.xdc" $item]} {
            # If it's an .xdc file, add it to the list
            lappend files $item
        } elseif {[file isdirectory $item]} {
            # If it's a directory, recurse into it
            set subfiles [collect_constraint_files $item]  ;# Fixed recursive call
            set files [concat $files $subfiles]
        }
    }
    
    return $files
}

proc collect_ip_files {dir} {
    set files {}

    # Get all items in the directory
    foreach item [glob -nocomplain -directory $dir *] {
        if {[file isfile $item] && [string match "*netlist.v" $item]} {
            # If it's a netlist Verilog file, add it to the list
            lappend files $item
        } elseif {[file isdirectory $item]} {
            # If it's a directory, recurse into it
            set subfiles [collect_ip_files $item]  ;# Fixed recursive call
            set files [concat $files $subfiles]
        }
    }
    
    return $files
}

proc collect_header_files {dir} {
    set files {}

    # Get all items in the directory
    foreach item [glob -nocomplain -directory $dir *] {
        if {[file isfile $item] && [string match "*.vh" $item]} {
            # If it's a Verilog header file, add it to the list
            lappend files $item
        } elseif {[file isdirectory $item]} {
            # If it's a directory, recurse into it
            set subfiles [collect_header_files $item]  ;# Corrected recursive call
            set files [concat $files $subfiles]
        }
    }
    
    return $files
}

# Collect files using predefined root directories
set SOURCE_FILES [collect_verilog_files "$HDL_ROOT"]
set CONS_FILES [collect_constraint_files "$CONS_ROOT"]
set IP_FILES [collect_ip_files "$IP_ROOT"]
set HEADER_FILES [collect_header_files "$HDL_ROOT"]
