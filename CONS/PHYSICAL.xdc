set_property PACKAGE_PIN W5 [get_ports clk_ref]						
set_property IOSTANDARD LVCMOS33 [get_ports clk_ref]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_ref]
set_property PACKAGE_PIN U18 [get_ports rst]						
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property PACKAGE_PIN B18 [get_ports cac_uart_rx]						
set_property IOSTANDARD LVCMOS33 [get_ports cac_uart_rx]
set_property PACKAGE_PIN A18 [get_ports cac_uart_tx]						
set_property IOSTANDARD LVCMOS33 [get_ports cac_uart_tx]


##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {spi_sclk}]					
set_property IOSTANDARD LVCMOS33 [get_ports {spi_sclk}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {spi_csb}]					
set_property IOSTANDARD LVCMOS33 [get_ports {spi_csb}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {spi_sdo}]					
set_property IOSTANDARD LVCMOS33 [get_ports {spi_sdo}]
##Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {spi_sdi}]					
set_property IOSTANDARD LVCMOS33 [get_ports {spi_sdi}]


set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
