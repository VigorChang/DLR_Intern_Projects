# Copyright (C) 1991-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, the Altera Quartus II License Agreement,
# the Altera MegaCore Function License Agreement, or other 
# applicable license agreement, including, without limitation, 
# that your use is for the sole purpose of programming logic 
# devices manufactured by Altera and sold by Altera or its 
# authorized distributors.  Please refer to the applicable 
# agreement for further details.

# Quartus II: Generate Tcl File for Project
# File: rfDemo.tcl
# Generated on: Tue Dec 20 14:24:11 2016

# Load Quartus II Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "rfDemo"]} {
		puts "Project rfDemo is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists rfDemo]} {
		project_open -revision rfDemo rfDemo
	} else {
		project_new -revision rfDemo rfDemo
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_location_assignment PIN_K14 -to clk
	set_location_assignment PIN_AB27 -to RXCLK
	set_location_assignment PIN_D5 -to RXD[11]
	set_location_assignment PIN_C4 -to RXD[10]
	set_location_assignment PIN_D6 -to RXD[9]
	set_location_assignment PIN_C5 -to RXD[8]
	set_location_assignment PIN_G7 -to RXD[7]
	set_location_assignment PIN_F6 -to RXD[6]
	set_location_assignment PIN_E8 -to RXD[5]
	set_location_assignment PIN_D7 -to RXD[4]
	set_location_assignment PIN_A9 -to RXD[3]
	set_location_assignment PIN_A8 -to RXD[2]
	set_location_assignment PIN_C10 -to RXD[1]
	set_location_assignment PIN_C9 -to RXD[0]
	set_location_assignment PIN_E3 -to RXEN
	set_location_assignment PIN_E2 -to RXIQSEL
	set_location_assignment PIN_E6 -to TXCLK
	set_location_assignment PIN_K8 -to TXD[11]
	set_location_assignment PIN_K7 -to TXD[10]
	set_location_assignment PIN_J9 -to TXD[9]
	set_location_assignment PIN_J10 -to TXD[8]
	set_location_assignment PIN_F10 -to TXD[7]
	set_location_assignment PIN_G10 -to TXD[6]
	set_location_assignment PIN_J12 -to TXD[5]
	set_location_assignment PIN_K12 -to TXD[4]
	set_location_assignment PIN_G11 -to TXD[3]
	set_location_assignment PIN_G12 -to TXD[2]
	set_location_assignment PIN_H12 -to TXD[1]
	set_location_assignment PIN_H13 -to TXD[0]
	set_location_assignment PIN_J7 -to TXEN
	set_location_assignment PIN_H7 -to TXIQSEL
	set_location_assignment PIN_AD7 -to LED[3]
	set_location_assignment PIN_AE11 -to LED[2]
	set_location_assignment PIN_AD10 -to LED[1]
	set_location_assignment PIN_AF10 -to LED[0]

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
