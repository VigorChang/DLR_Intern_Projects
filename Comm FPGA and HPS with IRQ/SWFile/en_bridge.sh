#!/bin/sh

set_bridge () {
    bridge=$1
    value=$2

    echo $value > "/sys/class/fpga-bridge/$bridge/enable"
}

# Enable the LWHPS2FPGA bridge
set_bridge hps2fpga 1
set_bridge fpga2hps 1
set_bridge lwhps2fpga 1

