# scope_0/aresetn

# Create port_slicer
cell pavel-demin:user:port_slicer slice_0 {
  DIN_WIDTH 8 DIN_FROM 0 DIN_TO 0
}

# conv_0/aresetn and writer_0/aresetn

# Create port_slicer
cell pavel-demin:user:port_slicer slice_1 {
  DIN_WIDTH 8 DIN_FROM 1 DIN_TO 1
}

# trig_0/pol_data

# Create port_slicer
cell pavel-demin:user:port_slicer slice_2 {
  DIN_WIDTH 8 DIN_FROM 2 DIN_TO 2
}

# or_0/Op1

# Create port_slicer
cell pavel-demin:user:port_slicer slice_3 {
  DIN_WIDTH 8 DIN_FROM 3 DIN_TO 3
}

# scope_0/run_flag

# Create port_slicer
cell pavel-demin:user:port_slicer slice_4 {
  DIN_WIDTH 8 DIN_FROM 4 DIN_TO 4
}

# scope_0/pre_data

# Create port_slicer
cell pavel-demin:user:port_slicer slice_5 {
  DIN_WIDTH 96 DIN_FROM 31 DIN_TO 0
}

# scope_0/tot_data

# Create port_slicer
cell pavel-demin:user:port_slicer slice_6 {
  DIN_WIDTH 96 DIN_FROM 63 DIN_TO 32
}

# trig_0/lvl_data

# Create port_slicer
cell pavel-demin:user:port_slicer slice_7 {
  DIN_WIDTH 96 DIN_FROM 79 DIN_TO 64
}

# Create axis_switch
cell xilinx.com:ip:axis_switch switch_0 {
  TDATA_NUM_BYTES.VALUE_SRC USER
  TDATA_NUM_BYTES 2
  ROUTING_MODE 1
} {
  aclk /pll_0/clk_out1
  aresetn /rst_0/peripheral_aresetn
}

# Create xlconstant
cell xilinx.com:ip:xlconstant const_0 {
  CONST_WIDTH 16
  CONST_VAL 65535
}

# Create axis_trigger
cell pavel-demin:user:axis_trigger trig_0 {
  AXIS_TDATA_WIDTH 16
  AXIS_TDATA_SIGNED TRUE
} {
  S_AXIS switch_0/M00_AXIS
  pol_data slice_2/dout
  msk_data const_0/dout
  lvl_data slice_7/dout
  aclk /pll_0/clk_out1
}

# Create util_vector_logic
cell xilinx.com:ip:util_vector_logic or_0 {
  C_SIZE 1
  C_OPERATION or
} {
  Op1 slice_3/dout
  Op2 trig_0/trg_flag
}

# Create axis_combiner
cell  xilinx.com:ip:axis_combiner comb_0 {
  TDATA_NUM_BYTES.VALUE_SRC USER
  TDATA_NUM_BYTES 2
} {
  aclk /pll_0/clk_out1
  aresetn /rst_0/peripheral_aresetn
}

# Create axis_oscilloscope
cell pavel-demin:user:axis_oscilloscope scope_0 {
  AXIS_TDATA_WIDTH 32
  CNTR_WIDTH 23
} {
  S_AXIS comb_0/M_AXIS
  run_flag slice_4/dout
  trg_flag or_0/Res
  pre_data slice_5/dout
  tot_data slice_6/dout
  aclk /pll_0/clk_out1
  aresetn slice_0/dout
}

# Create axis_dwidth_converter
cell xilinx.com:ip:axis_dwidth_converter conv_0 {
  S_TDATA_NUM_BYTES.VALUE_SRC USER
  S_TDATA_NUM_BYTES 4
  M_TDATA_NUM_BYTES 8
} {
  S_AXIS scope_0/M_AXIS
  aclk /pll_0/clk_out1
  aresetn slice_1/dout
}

# Create xlconstant
cell xilinx.com:ip:xlconstant const_1 {
  CONST_WIDTH 32
  CONST_VAL 503316480
}

# Create axis_ram_writer
cell pavel-demin:user:axis_ram_writer writer_0 {
  ADDR_WIDTH 22
} {
  S_AXIS conv_0/M_AXIS
  cfg_data const_1/dout
  aclk /pll_0/clk_out1
  aresetn slice_1/dout
}
