source projects/cfg_test/block_design.tcl

# Create port_slicer
cell pavel-demin:user:port_slicer slice_2 {
  DIN_WIDTH 1024 DIN_FROM 0 DIN_TO 0
} {
  din cfg_0/cfg_data
}

# Create port_slicer
cell pavel-demin:user:port_slicer slice_3 {
  DIN_WIDTH 1024 DIN_FROM 1 DIN_TO 1
} {
  din cfg_0/cfg_data
}

# Create port_slicer
cell pavel-demin:user:port_slicer slice_4 {
  DIN_WIDTH 1024 DIN_FROM 63 DIN_TO 32
} {
  din cfg_0/cfg_data
}

# Create dds_compiler
cell xilinx.com:ip:dds_compiler dds_0 {
  DDS_CLOCK_RATE 125
  SPURIOUS_FREE_DYNAMIC_RANGE 84
  FREQUENCY_RESOLUTION 0.5
  AMPLITUDE_MODE Unit_Circle
  HAS_PHASE_OUT false
  OUTPUT_FREQUENCY1 0.9765625
} {
  aclk pll_0/clk_out1
}

# Create axis_packetizer
cell pavel-demin:user:axis_packetizer pktzr_0 {
  AXIS_TDATA_WIDTH 32
  CNTR_WIDTH 32
  CONTINUOUS FALSE
} {
  S_AXIS dds_0/M_AXIS_DATA
  cfg_data slice_4/dout
  aclk pll_0/clk_out1
  aresetn slice_2/dout
}

# Create axis_dwidth_converter
cell xilinx.com:ip:axis_dwidth_converter conv_0 {
  S_TDATA_NUM_BYTES.VALUE_SRC USER
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 8
} {
  S_AXIS pktzr_0/M_AXIS
  aclk pll_0/clk_out1
  aresetn slice_3/dout
}

# Create xlconstant
cell xilinx.com:ip:xlconstant const_1 {
  CONST_WIDTH 32
  CONST_VAL 503316480
}

# Create axis_ram_writer
cell pavel-demin:user:axis_ram_writer writer_0 {} {
  S_AXIS conv_0/M_AXIS
  M_AXI ps_0/S_AXI_HP0
  cfg_data const_1/dout
  aclk pll_0/clk_out1
  aresetn slice_3/dout
}

assign_bd_address [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM]
