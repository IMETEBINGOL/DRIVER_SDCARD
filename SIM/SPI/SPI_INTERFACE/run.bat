@echo off
REM CLEAR STAGE
rd /Q /S log_files
rd /Q /S .Xil
rd /Q /S xsim.dir
erase /Q /S *.jou
erase /Q /S *.pb
erase /Q /S *.pb
erase /Q /S vivado*
erase /Q /S snapshot*
REM ADDING XLINX 
call C:\Xilinx\Vivado\2023.2\settings64.bat

mkdir log_files
vivado -mode tcl -nojournal -source ./run.tcl -log ./log_files/vivado_log.log 
