
    cd "C:/project/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/x_pcie/sim/aldec/rtl"
    workspace create pcie_space
    design create pcie_design .
    design open pcie_design
    cd "C:/project/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/x_pcie/sim/aldec/rtl"
    set sim_working_folder .
    #==============================================================================
    # Compile
    #==============================================================================
    vlog -v2k5 +define+RSL_SIM_MODE +define+SIM_MODE +define+USERNAME_EVAL_TOP=x_pcie_eval_top  +define+DEBUG=0 +define+SIMULATE   +incdir+../../../../x_pcie/testbench/top +incdir+../../../../x_pcie/testbench/tests +incdir+../../../../src/params +incdir+../../../../models/ecp5um +incdir+../../../../x_pcie/src/params ../../../../x_pcie/src/params/pci_exp_params.v  ../../../../x_pcie/testbench/top/eval_pcie.v  ../../../../x_pcie/testbench/top/eval_tbtx.v  ../../../../x_pcie/testbench/top/eval_tbrx.v ../../../../models/ecp5um/x_pcie_ctc.v  ../../../../models/ecp5um/x_pcie_sync1s.v  ../../../../models/ecp5um/x_pcie_pipe.v  ../../../../models/ecp5um/x_pcie_extref.v  ../../../../models/ecp5um/x_pcie_pcs_softlogic.v  ../../../../models/ecp5um/x_pcie_pcs.v  ../../../../models/ecp5um/x_pcie_phy.v  ../../../../x_pcie/src/top/x_pcie_core.v  ../../../../x_pcie/src/top/x_pcie_beh.v ../../../../x_pcie/src/top/x_pcie_eval_top.v  

    #==============================================================================
    # Run
    #==============================================================================
    vsim -o2 +access +r -t 1ps pcie_design.tb_top -lib pcie_design  -L ovi_ecp5um  -L pmi_work -L pcsd_aldec_work 
    
add wave {sim:/tb_top/u1_top/rst_n}
add wave {sim:/tb_top/u1_top/sys_clk_125}
add wave {sim:/tb_top/u_tbtx[0]/tx_st}
add wave {sim:/tb_top/u_tbtx[0]/tx_end}
add wave {sim:/tb_top/u_tbtx[0]/tx_data}
add wave {sim:/tb_top/u_tbtx[0]/tx_val}
add wave {sim:/tb_top/u_tbtx[0]/tx_req}
add wave {sim:/tb_top/u_tbtx[0]/tx_rdy}
add wave {sim:/tb_top/u_tbrx[0]/rx_us_req}
add wave {sim:/tb_top/u_tbrx[0]/rx_st}
add wave {sim:/tb_top/u_tbrx[0]/rx_end}
add wave {sim:/tb_top/u_tbrx[0]/rx_data}
add wave {sim:/tb_top/u_tbrx[0]/rx_malf_tlp}
add wave sim:/tb_top/u1_top/hdoutp*
add wave sim:/tb_top/u1_top/hdoutn*
add wave sim:/tb_top/u1_top/hdinp*
add wave sim:/tb_top/u1_top/hdinn*
run -all
