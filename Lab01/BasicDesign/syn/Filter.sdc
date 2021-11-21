###################################################################

# Created by write_sdc on Sat Nov 20 12:57:28 2021

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
create_clock [get_ports clk]  -name my_clk  -period 8  -waveform {0 4}
