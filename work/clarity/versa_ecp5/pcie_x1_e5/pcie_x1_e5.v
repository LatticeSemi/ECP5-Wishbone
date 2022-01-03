/* synthesis translate_off*/
`define SBP_SIMULATION
/* synthesis translate_on*/
`ifndef SBP_SIMULATION
`define SBP_SYNTHESIS
`endif

//
// Verific Verilog Description of module pcie_x1_e5
//
module pcie_x1_e5 (x_pcie_bus_num, x_pcie_cmd_reg_out, x_pcie_dev_cntl_out, 
            x_pcie_dev_num, x_pcie_func_num, x_pcie_lnk_cntl_out, x_pcie_mm_enable, 
            x_pcie_msi, x_pcie_npd_num_vc0, x_pcie_pd_num_vc0, x_pcie_phy_ltssm_state, 
            x_pcie_pm_power_state, x_pcie_rx_bar_hit, x_pcie_rx_data_vc0, 
            x_pcie_rx_lbk_data, x_pcie_rx_lbk_kcntl, x_pcie_rxdp_dllp_val, 
            x_pcie_rxdp_pmd_type, x_pcie_rxdp_vsd_data, x_pcie_sci_addr, 
            x_pcie_sci_rddata, x_pcie_sci_wrdata, x_pcie_tx_ca_cpld_vc0, 
            x_pcie_tx_ca_cplh_vc0, x_pcie_tx_ca_npd_vc0, x_pcie_tx_ca_nph_vc0, 
            x_pcie_tx_ca_pd_vc0, x_pcie_tx_ca_ph_vc0, x_pcie_tx_data_vc0, 
            x_pcie_tx_dllp_val, x_pcie_tx_lbk_data, x_pcie_tx_lbk_kcntl, 
            x_pcie_tx_pmtype, x_pcie_tx_vsd_data, x_cref_refclkn, x_cref_refclko, 
            x_cref_refclkp, x_pcie_cmpln_tout, x_pcie_cmpltr_abort_np, 
            x_pcie_cmpltr_abort_p, x_pcie_dl_active, x_pcie_dl_inactive, 
            x_pcie_dl_init, x_pcie_dl_up, x_pcie_flip_lanes, x_pcie_force_disable_scr, 
            x_pcie_force_lsm_active, x_pcie_force_phy_status, x_pcie_force_rec_ei, 
            x_pcie_hdinn0, x_pcie_hdinp0, x_pcie_hdoutn0, x_pcie_hdoutp0, 
            x_pcie_hl_disable_scr, x_pcie_hl_gto_cfg, x_pcie_hl_gto_det, 
            x_pcie_hl_gto_dis, x_pcie_hl_gto_hrst, x_pcie_hl_gto_l0stx, 
            x_pcie_hl_gto_l0stxfts, x_pcie_hl_gto_l1, x_pcie_hl_gto_l2, 
            x_pcie_hl_gto_lbk, x_pcie_hl_gto_rcvry, x_pcie_hl_snd_beacon, 
            x_pcie_inta_n, x_pcie_msi_enable, x_pcie_no_pcie_train, x_pcie_np_req_pend, 
            x_pcie_npd_buf_status_vc0, x_pcie_npd_processed_vc0, x_pcie_nph_buf_status_vc0, 
            x_pcie_nph_processed_vc0, x_pcie_pd_buf_status_vc0, x_pcie_pd_processed_vc0, 
            x_pcie_ph_buf_status_vc0, x_pcie_ph_processed_vc0, x_pcie_phy_pol_compliance, 
            x_pcie_pll_refclki, x_pcie_pme_en, x_pcie_pme_status, x_pcie_rst_n, 
            x_pcie_rx_end_vc0, x_pcie_rx_malf_tlp_vc0, x_pcie_rx_st_vc0, 
            x_pcie_rx_us_req_vc0, x_pcie_rxrefclk, x_pcie_sci_en, x_pcie_sci_en_dual, 
            x_pcie_sci_int, x_pcie_sci_rd, x_pcie_sci_sel, x_pcie_sci_sel_dual, 
            x_pcie_sci_wrn, x_pcie_serdes_pdb, x_pcie_serdes_rst_dual_c, 
            x_pcie_sys_clk_125, x_pcie_tx_ca_cpl_recheck_vc0, x_pcie_tx_ca_p_recheck_vc0, 
            x_pcie_tx_dllp_sent, x_pcie_tx_end_vc0, x_pcie_tx_lbk_rdy, 
            x_pcie_tx_nlfy_vc0, x_pcie_tx_pwrup_c, x_pcie_tx_rdy_vc0, 
            x_pcie_tx_req_vc0, x_pcie_tx_serdes_rst_c, x_pcie_tx_st_vc0, 
            x_pcie_unexp_cmpln, x_pcie_ur_np_ext, x_pcie_ur_p_ext) /* synthesis sbp_module=true */ ;
    output [7:0]x_pcie_bus_num;
    output [5:0]x_pcie_cmd_reg_out;
    output [14:0]x_pcie_dev_cntl_out;
    output [4:0]x_pcie_dev_num;
    output [2:0]x_pcie_func_num;
    output [7:0]x_pcie_lnk_cntl_out;
    output [2:0]x_pcie_mm_enable;
    input [7:0]x_pcie_msi;
    input [7:0]x_pcie_npd_num_vc0;
    input [7:0]x_pcie_pd_num_vc0;
    output [3:0]x_pcie_phy_ltssm_state;
    output [1:0]x_pcie_pm_power_state;
    output [6:0]x_pcie_rx_bar_hit;
    output [15:0]x_pcie_rx_data_vc0;
    output [15:0]x_pcie_rx_lbk_data;
    output [1:0]x_pcie_rx_lbk_kcntl;
    output [1:0]x_pcie_rxdp_dllp_val;
    output [2:0]x_pcie_rxdp_pmd_type;
    output [23:0]x_pcie_rxdp_vsd_data;
    input [5:0]x_pcie_sci_addr;
    output [7:0]x_pcie_sci_rddata;
    input [7:0]x_pcie_sci_wrdata;
    output [12:0]x_pcie_tx_ca_cpld_vc0;
    output [8:0]x_pcie_tx_ca_cplh_vc0;
    output [12:0]x_pcie_tx_ca_npd_vc0;
    output [8:0]x_pcie_tx_ca_nph_vc0;
    output [12:0]x_pcie_tx_ca_pd_vc0;
    output [8:0]x_pcie_tx_ca_ph_vc0;
    input [15:0]x_pcie_tx_data_vc0;
    input [1:0]x_pcie_tx_dllp_val;
    input [15:0]x_pcie_tx_lbk_data;
    input [1:0]x_pcie_tx_lbk_kcntl;
    input [2:0]x_pcie_tx_pmtype;
    input [23:0]x_pcie_tx_vsd_data;
    input x_cref_refclkn;
    output x_cref_refclko;
    input x_cref_refclkp;
    input x_pcie_cmpln_tout;
    input x_pcie_cmpltr_abort_np;
    input x_pcie_cmpltr_abort_p;
    output x_pcie_dl_active;
    output x_pcie_dl_inactive;
    output x_pcie_dl_init;
    output x_pcie_dl_up;
    input x_pcie_flip_lanes;
    input x_pcie_force_disable_scr;
    input x_pcie_force_lsm_active;
    input x_pcie_force_phy_status;
    input x_pcie_force_rec_ei;
    input x_pcie_hdinn0;
    input x_pcie_hdinp0;
    output x_pcie_hdoutn0;
    output x_pcie_hdoutp0;
    input x_pcie_hl_disable_scr;
    input x_pcie_hl_gto_cfg;
    input x_pcie_hl_gto_det;
    input x_pcie_hl_gto_dis;
    input x_pcie_hl_gto_hrst;
    input x_pcie_hl_gto_l0stx;
    input x_pcie_hl_gto_l0stxfts;
    input x_pcie_hl_gto_l1;
    input x_pcie_hl_gto_l2;
    input x_pcie_hl_gto_lbk;
    input x_pcie_hl_gto_rcvry;
    input x_pcie_hl_snd_beacon;
    input x_pcie_inta_n;
    output x_pcie_msi_enable;
    input x_pcie_no_pcie_train;
    input x_pcie_np_req_pend;
    input x_pcie_npd_buf_status_vc0;
    input x_pcie_npd_processed_vc0;
    input x_pcie_nph_buf_status_vc0;
    input x_pcie_nph_processed_vc0;
    input x_pcie_pd_buf_status_vc0;
    input x_pcie_pd_processed_vc0;
    input x_pcie_ph_buf_status_vc0;
    input x_pcie_ph_processed_vc0;
    output x_pcie_phy_pol_compliance;
    input x_pcie_pll_refclki;
    output x_pcie_pme_en;
    input x_pcie_pme_status;
    input x_pcie_rst_n;
    output x_pcie_rx_end_vc0;
    output x_pcie_rx_malf_tlp_vc0;
    output x_pcie_rx_st_vc0;
    output x_pcie_rx_us_req_vc0;
    input x_pcie_rxrefclk;
    input x_pcie_sci_en;
    input x_pcie_sci_en_dual;
    output x_pcie_sci_int;
    input x_pcie_sci_rd;
    input x_pcie_sci_sel;
    input x_pcie_sci_sel_dual;
    input x_pcie_sci_wrn;
    output x_pcie_serdes_pdb;
    output x_pcie_serdes_rst_dual_c;
    output x_pcie_sys_clk_125;
    output x_pcie_tx_ca_cpl_recheck_vc0;
    output x_pcie_tx_ca_p_recheck_vc0;
    output x_pcie_tx_dllp_sent;
    input x_pcie_tx_end_vc0;
    output x_pcie_tx_lbk_rdy;
    input x_pcie_tx_nlfy_vc0;
    output x_pcie_tx_pwrup_c;
    output x_pcie_tx_rdy_vc0;
    input x_pcie_tx_req_vc0;
    output x_pcie_tx_serdes_rst_c;
    input x_pcie_tx_st_vc0;
    input x_pcie_unexp_cmpln;
    input x_pcie_ur_np_ext;
    input x_pcie_ur_p_ext;
    
    
    wire x_pcie_serdes_pdb, x_pcie_serdes_rst_dual_c, x_pcie_tx_pwrup_c, 
        x_pcie_tx_serdes_rst_c, sli_rst_wire0, pcs_clkdiv0_CDIV1_sig, 
        pcs_clkdiv0_CDIVX_sig, pcs_clkdiv0_CLKI_sig, n1;
    
    assign x_pcie_serdes_pdb = x_pcie_serdes_pdb;
    assign x_pcie_serdes_rst_dual_c = x_pcie_serdes_rst_dual_c;
    assign x_pcie_tx_pwrup_c = x_pcie_tx_pwrup_c;
    assign x_pcie_tx_serdes_rst_c = x_pcie_tx_serdes_rst_c;
    assign sli_rst_wire0 = x_pcie_serdes_rst_dual_c ||  x_pcie_tx_serdes_rst_c ||  (!x_pcie_serdes_pdb) ||  (!x_pcie_tx_pwrup_c);
    x_cref x_cref_inst (.refclkn(x_cref_refclkn), .refclko(x_cref_refclko), 
           .refclkp(x_cref_refclkp));
    x_pcie x_pcie_inst (.bus_num({x_pcie_bus_num}), .cmd_reg_out({x_pcie_cmd_reg_out}), 
           .dev_cntl_out({x_pcie_dev_cntl_out}), .dev_num({x_pcie_dev_num}), 
           .func_num({x_pcie_func_num}), .lnk_cntl_out({x_pcie_lnk_cntl_out}), 
           .mm_enable({x_pcie_mm_enable}), .msi({x_pcie_msi}), .npd_num_vc0({x_pcie_npd_num_vc0}), 
           .pd_num_vc0({x_pcie_pd_num_vc0}), .phy_ltssm_state({x_pcie_phy_ltssm_state}), 
           .pm_power_state({x_pcie_pm_power_state}), .rx_bar_hit({x_pcie_rx_bar_hit}), 
           .rx_data_vc0({x_pcie_rx_data_vc0}), .rx_lbk_data({x_pcie_rx_lbk_data}), 
           .rx_lbk_kcntl({x_pcie_rx_lbk_kcntl}), .rxdp_dllp_val({x_pcie_rxdp_dllp_val}), 
           .rxdp_pmd_type({x_pcie_rxdp_pmd_type}), .rxdp_vsd_data({x_pcie_rxdp_vsd_data}), 
           .sci_addr({x_pcie_sci_addr}), .sci_rddata({x_pcie_sci_rddata}), 
           .sci_wrdata({x_pcie_sci_wrdata}), .tx_ca_cpld_vc0({x_pcie_tx_ca_cpld_vc0}), 
           .tx_ca_cplh_vc0({x_pcie_tx_ca_cplh_vc0}), .tx_ca_npd_vc0({x_pcie_tx_ca_npd_vc0}), 
           .tx_ca_nph_vc0({x_pcie_tx_ca_nph_vc0}), .tx_ca_pd_vc0({x_pcie_tx_ca_pd_vc0}), 
           .tx_ca_ph_vc0({x_pcie_tx_ca_ph_vc0}), .tx_data_vc0({x_pcie_tx_data_vc0}), 
           .tx_dllp_val({x_pcie_tx_dllp_val}), .tx_lbk_data({x_pcie_tx_lbk_data}), 
           .tx_lbk_kcntl({x_pcie_tx_lbk_kcntl}), .tx_pmtype({x_pcie_tx_pmtype}), 
           .tx_vsd_data({x_pcie_tx_vsd_data}), .cmpln_tout(x_pcie_cmpln_tout), 
           .cmpltr_abort_np(x_pcie_cmpltr_abort_np), .cmpltr_abort_p(x_pcie_cmpltr_abort_p), 
           .dl_active(x_pcie_dl_active), .dl_inactive(x_pcie_dl_inactive), 
           .dl_init(x_pcie_dl_init), .dl_up(x_pcie_dl_up), .flip_lanes(x_pcie_flip_lanes), 
           .force_disable_scr(x_pcie_force_disable_scr), .force_lsm_active(x_pcie_force_lsm_active), 
           .force_phy_status(x_pcie_force_phy_status), .force_rec_ei(x_pcie_force_rec_ei), 
           .hdinn0(x_pcie_hdinn0), .hdinp0(x_pcie_hdinp0), .hdoutn0(x_pcie_hdoutn0), 
           .hdoutp0(x_pcie_hdoutp0), .hl_disable_scr(x_pcie_hl_disable_scr), 
           .hl_gto_cfg(x_pcie_hl_gto_cfg), .hl_gto_det(x_pcie_hl_gto_det), 
           .hl_gto_dis(x_pcie_hl_gto_dis), .hl_gto_hrst(x_pcie_hl_gto_hrst), 
           .hl_gto_l0stx(x_pcie_hl_gto_l0stx), .hl_gto_l0stxfts(x_pcie_hl_gto_l0stxfts), 
           .hl_gto_l1(x_pcie_hl_gto_l1), .hl_gto_l2(x_pcie_hl_gto_l2), .hl_gto_lbk(x_pcie_hl_gto_lbk), 
           .hl_gto_rcvry(x_pcie_hl_gto_rcvry), .hl_snd_beacon(x_pcie_hl_snd_beacon), 
           .inta_n(x_pcie_inta_n), .msi_enable(x_pcie_msi_enable), .no_pcie_train(x_pcie_no_pcie_train), 
           .np_req_pend(x_pcie_np_req_pend), .npd_buf_status_vc0(x_pcie_npd_buf_status_vc0), 
           .npd_processed_vc0(x_pcie_npd_processed_vc0), .nph_buf_status_vc0(x_pcie_nph_buf_status_vc0), 
           .nph_processed_vc0(x_pcie_nph_processed_vc0), .pd_buf_status_vc0(x_pcie_pd_buf_status_vc0), 
           .pd_processed_vc0(x_pcie_pd_processed_vc0), .ph_buf_status_vc0(x_pcie_ph_buf_status_vc0), 
           .ph_processed_vc0(x_pcie_ph_processed_vc0), .phy_pol_compliance(x_pcie_phy_pol_compliance), 
           .pll_refclki(x_pcie_pll_refclki), .pme_en(x_pcie_pme_en), .pme_status(x_pcie_pme_status), 
           .rst_n(x_pcie_rst_n), .rx_end_vc0(x_pcie_rx_end_vc0), .rx_malf_tlp_vc0(x_pcie_rx_malf_tlp_vc0), 
           .rx_st_vc0(x_pcie_rx_st_vc0), .rx_us_req_vc0(x_pcie_rx_us_req_vc0), 
           .rxrefclk(x_pcie_rxrefclk), .sci_en(x_pcie_sci_en), .sci_en_dual(x_pcie_sci_en_dual), 
           .sci_int(x_pcie_sci_int), .sci_rd(x_pcie_sci_rd), .sci_sel(x_pcie_sci_sel), 
           .sci_sel_dual(x_pcie_sci_sel_dual), .sci_wrn(x_pcie_sci_wrn), 
           .serdes_pdb(x_pcie_serdes_pdb), .serdes_rst_dual_c(x_pcie_serdes_rst_dual_c), 
           .sli_rst(sli_rst_wire0), .sys_clk_125(x_pcie_sys_clk_125), .tx_ca_cpl_recheck_vc0(x_pcie_tx_ca_cpl_recheck_vc0), 
           .tx_ca_p_recheck_vc0(x_pcie_tx_ca_p_recheck_vc0), .tx_dllp_sent(x_pcie_tx_dllp_sent), 
           .tx_end_vc0(x_pcie_tx_end_vc0), .tx_lbk_rdy(x_pcie_tx_lbk_rdy), 
           .tx_nlfy_vc0(x_pcie_tx_nlfy_vc0), .tx_pwrup_c(x_pcie_tx_pwrup_c), 
           .tx_rdy_vc0(x_pcie_tx_rdy_vc0), .tx_req_vc0(x_pcie_tx_req_vc0), 
           .tx_serdes_rst_c(x_pcie_tx_serdes_rst_c), .tx_st_vc0(x_pcie_tx_st_vc0), 
           .unexp_cmpln(x_pcie_unexp_cmpln), .ur_np_ext(x_pcie_ur_np_ext), 
           .ur_p_ext(x_pcie_ur_p_ext));
    PCSCLKDIV pcs_clkdiv0 (.CLKI(pcs_clkdiv0_CLKI_sig), .RST(n1), .SEL2(1'b0), 
            .SEL1(1'b1), .SEL0(1'b0), .CDIV1(pcs_clkdiv0_CDIV1_sig), .CDIVX(pcs_clkdiv0_CDIVX_sig));
    not (n1, x_pcie_rst_n) ;
    
endmodule

