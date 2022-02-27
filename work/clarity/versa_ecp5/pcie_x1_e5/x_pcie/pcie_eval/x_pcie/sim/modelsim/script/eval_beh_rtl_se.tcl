
  #==============================================================================
  # Set up modelsim work library
  #==============================================================================
  cd "C:/project/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/x_pcie/sim/modelsim/rtl"
  vlib                  work
  vmap pcsd_mti_work "C:/lscc/diamond/3.12/cae_library/simulation/blackbox/pcsd_work"
  vmap ecp5u_bb "C:/lscc/diamond/3.12/cae_library/simulation/blackbox/ecp5u_black_boxes"
  vlog -refresh -quiet -work pcsd_mti_work
  vlog -refresh -quiet -work ecp5u_bb
  #==============================================================================
  # Make vlog and vsim commands
  #==============================================================================
  vlog +define+RSL_SIM_MODE +define+SIM_MODE +define+USERNAME_EVAL_TOP=x_pcie_eval_top  +define+DEBUG=0 +define+SIMULATE   +incdir+../../../../x_pcie/testbench/top +incdir+../../../../x_pcie/testbench/tests +incdir+../../../../src/params +incdir+../../../../models/ecp5um +incdir+../../../../x_pcie/src/params  -y C:/lscc/diamond/3.12/cae_library/simulation/verilog/ecp5u +libext+.v -y C:/lscc/diamond/3.12/cae_library/simulation/verilog/pmi +libext+.v  ../../../../x_pcie/src/params/pci_exp_params.v  ../../../../x_pcie/testbench/top/eval_pcie.v  ../../../../x_pcie/testbench/top/eval_tbtx.v  ../../../../x_pcie/testbench/top/eval_tbrx.v ../../../../models/ecp5um/x_pcie_ctc.v  ../../../../models/ecp5um/x_pcie_sync1s.v  ../../../../models/ecp5um/x_pcie_pipe.v  ../../../../models/ecp5um/x_pcie_extref.v  ../../../../models/ecp5um/x_pcie_pcs_softlogic.v  ../../../../models/ecp5um/x_pcie_pcs.v  ../../../../models/ecp5um/x_pcie_phy.v  ../../../../x_pcie/src/top/x_pcie_core.v  ../../../../x_pcie/src/top/x_pcie_beh.v ../../../../x_pcie/src/top/x_pcie_eval_top.v  -work work

  vsim -t 1ps -c work.tb_top  -L work -L ecp5u -L pcsd_mti_work    -l  eval_pcie.log   -wlf eval_pcie.wlf 
  do ../sim.do
  
