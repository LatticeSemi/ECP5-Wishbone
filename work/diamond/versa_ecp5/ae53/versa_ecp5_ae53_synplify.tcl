#-- Lattice Semiconductor Corporation Ltd.
#-- Synplify OEM project file

#device options
set_option -technology ECP5UM
set_option -part LFE5UM_45F
set_option -package BG381C
set_option -speed_grade -8

#compilation/mapping options
set_option -symbolic_fsm_compiler true
set_option -resource_sharing true

#use verilog 2001 standard option
set_option -vlog_std v2001

#map options
set_option -frequency 280
set_option -maxfan 200
set_option -auto_constrain_io 1
set_option -disable_io_insertion false
set_option -retiming false; set_option -pipe false
set_option -force_gsr false
set_option -compiler_compatible 0
set_option -dup true

set_option -default_enum_encoding default

#simulation options


#timing analysis options
set_option -num_critical_paths 32


#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#synplifyPro options
set_option -fix_gated_and_generated_clocks 1
set_option -update_models_cp 0
set_option -resolve_multiple_driver 0
set_option -vhdl2008 1

set_option -seqshift_no_replicate 0

#-- add_file options
set_option -hdl_define -set SBP_SYNTHESIS
set_option -include_path {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/x_pcie/src/params}
set_option -include_path {C:/Projects/ECP5_Wishbone/work/diamond/versa_ecp5}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_cref/x_cref.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/x_pcie/src/params/pci_exp_params.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/x_pcie.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/x_pcie_core_bb.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/x_pcie_sync1s.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/x_pcie_ctc.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/x_pcie_pcs_softlogic.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/x_pcie_pcs.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/x_pcie_pipe.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/x_pcie_phy.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/work/clarity/versa_ecp5/pcie_x1_e5/pcie_x1_e5.v}
add_file -verilog -vlog_std v2001 {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_credit_config/vlog/b4sq_credit_config.v}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/rx_rsl/vhdl/rx_rsl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/config/vhdl/config_ae53_ecp5-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/top/core_ae53/vhdl/core_ae53_comps-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/packages/tspc_utils/vhdl/tspc_utils-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/packages/tspc_utils/vhdl/tspc_utils-pb.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/top/vhdl/pcie_subsys_comps-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/top/vhdl/tsls_wb_pcie_to_b4sq_comps-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/packages/tspc_wbone_types/vhdl/tspc_wbone_types-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc_impl/common/packages/tspc_wbone_types/mti/tspc_wbone_types-pb.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pkt_rx_fifo/vhdl/b4sq_pkt_rx_fifo_comps-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/packages/tspc_pcisig_types/vhdl/tspc_pcisig_types-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/packages/tspc_pcisig_types/vhdl/tspc_pcisig_types-pb.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_xmitter_comps-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_xmitter_globals-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_queue_comps-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_fifo_sync/top/vhdl/tspc_fifo_sync_comps-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/tspc_rtc/vhdl/tspc_rtc-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/tspc_rtc/vhdl/tspc_rtc-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_rsrc_decode/vhdl/pcie_rsrc_decode-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_rsrc_decode/vhdl/pcie_rsrc_decode-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_cdc_sig/vhdl/tspc_cdc_sig-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_cdc_sig/vhdl/tspc_cdc_sig-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/tsls_wb_bmram/units/tspc_wb_ebr_ctl/vhdl/tspc_wb_ebr_ctl-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/tsls_wb_bmram/units/tspc_wb_ebr_ctl/vhdl/tspc_wb_ebr_ctl-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/tsls_wb_bmram/top/vhdl/tsls_wb_bmram-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/tsls_wb_bmram/top/vhdl/tsls_wb_bmram-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/lscc_pcie_x1_ip/vhdl/lscc_pcie_x1_ip-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/lscc_pcie_x1_ip/vhdl/lscc_pcie_x1_ip-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pkt_decode/vhdl/b4sq_pkt_decode-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pkt_decode/vhdl/b4sq_pkt_decode-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pcie_svc/vhdl/b4sq_pcie_svc-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pcie_svc/vhdl/b4sq_pcie_svc-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_fifo_ctl_sync/vhdl/tspc_fifo_ctl_sync-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_fifo_ctl_sync/vhdl/tspc_fifo_ctl_sync-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pkt_rx_fifo/vhdl/b4sq_pkt_rx_fifo_istage-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pkt_rx_fifo/vhdl/b4sq_pkt_rx_fifo_istage-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pkt_rx_fifo/vhdl/b4sq_pkt_rx_fifo-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_pkt_rx_fifo/vhdl/b4sq_pkt_rx_fifo-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_arbiter-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_arbiter-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_queue_ctl-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_queue_ctl-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_fifo_sync/tech/vhdl/tspc_fifo_sync_mem-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_fifo_sync/tech/vhdl/tspc_fifo_sync_mem-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_fifo_sync/top/vhdl/tspc_fifo_sync-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/common/units/tspc_fifo_sync/top/vhdl/tspc_fifo_sync-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_queue-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_queue-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_xmitter-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/units/b4sq_tlp_xmitter/vhdl/b4sq_tlp_xmitter-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/top/vhdl/tsls_wb_pcie_to_b4sq-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/units/tsls_wb_pcie_to_b4sq/top/vhdl/tsls_wb_pcie_to_b4sq-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/top/vhdl/pcie_subsys-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/units/pcie_subsys/top/vhdl/pcie_subsys-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/top/core_ae53/vhdl/core_ae53-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/top/core_ae53/vhdl/core_ae53-a_rtl.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/top/core_ae53/vhdl/core_ae53_exports-p.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/top/versa_ecp5/vhdl/versa_ecp5-e.vhd}
add_file -vhdl -lib "work" {C:/Projects/ECP5_Wishbone/soc/top/versa_ecp5/vhdl/versa_ecp5-a_rtl.vhd}

#-- top module name
set_option -top_module versa_ecp5

#-- set result format/file last
project -result_file {C:/Projects/ECP5_Wishbone/work/diamond/versa_ecp5/ae53/versa_ecp5_ae53.edi}

#-- error message log file
project -log_file {versa_ecp5_ae53.srf}

#-- set any command lines input by customer


#-- run Synplify with 'arrange HDL file'
project -run hdl_info_gen -fileorder
project -run -clean
