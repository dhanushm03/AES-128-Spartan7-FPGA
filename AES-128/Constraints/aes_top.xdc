## =========================================================
## Custom Pinout Based on Your I/O Ports Screenshot
## Part: xc7s50csga324-1
## =========================================================

## -------------------------
## Clock Signal
## -------------------------
## Based on your image: clk is assigned to Pin F14
set_property PACKAGE_PIN F14 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

## -------------------------
## Control Signals
## -------------------------
## Reset Button (rst_btn) -> Pin K1
set_property PACKAGE_PIN K1 [get_ports rst_btn]
set_property IOSTANDARD LVCMOS33 [get_ports rst_btn]

## Start Switch (start_sw) -> Pin K2
set_property PACKAGE_PIN K2 [get_ports start_sw]
set_property IOSTANDARD LVCMOS33 [get_ports start_sw]

## Done LED (done_led) -> Pin A4
set_property PACKAGE_PIN A4 [get_ports done_led]
set_property IOSTANDARD LVCMOS33 [get_ports done_led]

## =========================================================
## 7-Segment Display Segments (seg[0] to seg[7])
## =========================================================

## seg[0] -> A6
## seg[1] -> B5
## seg[2] -> D6
## seg[3] -> A7
## seg[4] -> B7
set_property PACKAGE_PIN A7 [get_ports {seg[4]}]
## seg[5] -> A5
set_property PACKAGE_PIN D6 [get_ports {seg[5]}]
## seg[6] -> C5
set_property PACKAGE_PIN B5 [get_ports {seg[6]}]
## seg[7] -> D7
set_property PACKAGE_PIN A6 [get_ports {seg[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {seg[*]}]

## =========================================================
## 7-Segment Display Anodes (an[0] to an[3])
## =========================================================

## an[0] -> A8
## an[1] -> C7
## an[2] -> C4
set_property PACKAGE_PIN C7 [get_ports {an[2]}]
## an[3] -> D5
set_property PACKAGE_PIN A8 [get_ports {an[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {an[*]}]

## =========================================================
## Configuration Settings
## =========================================================
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

set_property PACKAGE_PIN C4 [get_ports {an[1]}]
set_property PACKAGE_PIN D5 [get_ports {an[0]}]
set_property PACKAGE_PIN B7 [get_ports {seg[3]}]
set_property PACKAGE_PIN A5 [get_ports {seg[2]}]
set_property PACKAGE_PIN C5 [get_ports {seg[1]}]
set_property PACKAGE_PIN D7 [get_ports {seg[0]}]
