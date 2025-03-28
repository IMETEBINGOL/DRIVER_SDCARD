set_property BITSTREAM.CONFIG.CONFIGRATE 16 [current_design]
write_bitstream -force output/bitstream.bit
write_cfgmem -format mcs -interface SPIx1 -size 16 -loadbit "up 0x0 output/bitstream.bit" -file output/bitstream.mcs