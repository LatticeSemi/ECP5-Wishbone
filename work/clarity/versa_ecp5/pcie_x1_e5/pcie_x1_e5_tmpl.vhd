--VHDL instantiation template

component pcie_x1_e5 is
    port (x_pcie_bus_num: out std_logic_vector(7 downto 0);
        x_pcie_cmd_reg_out: out std_logic_vector(5 downto 0);
        x_pcie_dev_cntl_out: out std_logic_vector(14 downto 0);
        x_pcie_dev_num: out std_logic_vector(4 downto 0);
        x_pcie_func_num: out std_logic_vector(2 downto 0);
        x_pcie_lnk_cntl_out: out std_logic_vector(7 downto 0);
        x_pcie_mm_enable: out std_logic_vector(2 downto 0);
        x_pcie_msi: in std_logic_vector(7 downto 0);
        x_pcie_npd_num_vc0: in std_logic_vector(7 downto 0);
        x_pcie_pd_num_vc0: in std_logic_vector(7 downto 0);
        x_pcie_phy_ltssm_state: out std_logic_vector(3 downto 0);
        x_pcie_pm_power_state: out std_logic_vector(1 downto 0);
        x_pcie_rx_bar_hit: out std_logic_vector(6 downto 0);
        x_pcie_rx_data_vc0: out std_logic_vector(15 downto 0);
        x_pcie_rx_lbk_data: out std_logic_vector(15 downto 0);
        x_pcie_rx_lbk_kcntl: out std_logic_vector(1 downto 0);
        x_pcie_rxdp_dllp_val: out std_logic_vector(1 downto 0);
        x_pcie_rxdp_pmd_type: out std_logic_vector(2 downto 0);
        x_pcie_rxdp_vsd_data: out std_logic_vector(23 downto 0);
        x_pcie_sci_addr: in std_logic_vector(5 downto 0);
        x_pcie_sci_rddata: out std_logic_vector(7 downto 0);
        x_pcie_sci_wrdata: in std_logic_vector(7 downto 0);
        x_pcie_tx_ca_cpld_vc0: out std_logic_vector(12 downto 0);
        x_pcie_tx_ca_cplh_vc0: out std_logic_vector(8 downto 0);
        x_pcie_tx_ca_npd_vc0: out std_logic_vector(12 downto 0);
        x_pcie_tx_ca_nph_vc0: out std_logic_vector(8 downto 0);
        x_pcie_tx_ca_pd_vc0: out std_logic_vector(12 downto 0);
        x_pcie_tx_ca_ph_vc0: out std_logic_vector(8 downto 0);
        x_pcie_tx_data_vc0: in std_logic_vector(15 downto 0);
        x_pcie_tx_dllp_val: in std_logic_vector(1 downto 0);
        x_pcie_tx_lbk_data: in std_logic_vector(15 downto 0);
        x_pcie_tx_lbk_kcntl: in std_logic_vector(1 downto 0);
        x_pcie_tx_pmtype: in std_logic_vector(2 downto 0);
        x_pcie_tx_vsd_data: in std_logic_vector(23 downto 0);
        x_cref_refclkn: in std_logic;
        x_cref_refclko: out std_logic;
        x_cref_refclkp: in std_logic;
        x_pcie_cmpln_tout: in std_logic;
        x_pcie_cmpltr_abort_np: in std_logic;
        x_pcie_cmpltr_abort_p: in std_logic;
        x_pcie_dl_active: out std_logic;
        x_pcie_dl_inactive: out std_logic;
        x_pcie_dl_init: out std_logic;
        x_pcie_dl_up: out std_logic;
        x_pcie_flip_lanes: in std_logic;
        x_pcie_force_disable_scr: in std_logic;
        x_pcie_force_lsm_active: in std_logic;
        x_pcie_force_phy_status: in std_logic;
        x_pcie_force_rec_ei: in std_logic;
        x_pcie_hdinn0: in std_logic;
        x_pcie_hdinp0: in std_logic;
        x_pcie_hdoutn0: out std_logic;
        x_pcie_hdoutp0: out std_logic;
        x_pcie_hl_disable_scr: in std_logic;
        x_pcie_hl_gto_cfg: in std_logic;
        x_pcie_hl_gto_det: in std_logic;
        x_pcie_hl_gto_dis: in std_logic;
        x_pcie_hl_gto_hrst: in std_logic;
        x_pcie_hl_gto_l0stx: in std_logic;
        x_pcie_hl_gto_l0stxfts: in std_logic;
        x_pcie_hl_gto_l1: in std_logic;
        x_pcie_hl_gto_l2: in std_logic;
        x_pcie_hl_gto_lbk: in std_logic;
        x_pcie_hl_gto_rcvry: in std_logic;
        x_pcie_hl_snd_beacon: in std_logic;
        x_pcie_inta_n: in std_logic;
        x_pcie_msi_enable: out std_logic;
        x_pcie_no_pcie_train: in std_logic;
        x_pcie_np_req_pend: in std_logic;
        x_pcie_npd_buf_status_vc0: in std_logic;
        x_pcie_npd_processed_vc0: in std_logic;
        x_pcie_nph_buf_status_vc0: in std_logic;
        x_pcie_nph_processed_vc0: in std_logic;
        x_pcie_pd_buf_status_vc0: in std_logic;
        x_pcie_pd_processed_vc0: in std_logic;
        x_pcie_ph_buf_status_vc0: in std_logic;
        x_pcie_ph_processed_vc0: in std_logic;
        x_pcie_phy_pol_compliance: out std_logic;
        x_pcie_pll_refclki: in std_logic;
        x_pcie_pme_en: out std_logic;
        x_pcie_pme_status: in std_logic;
        x_pcie_rst_n: in std_logic;
        x_pcie_rx_end_vc0: out std_logic;
        x_pcie_rx_malf_tlp_vc0: out std_logic;
        x_pcie_rx_st_vc0: out std_logic;
        x_pcie_rx_us_req_vc0: out std_logic;
        x_pcie_rxrefclk: in std_logic;
        x_pcie_sci_en: in std_logic;
        x_pcie_sci_en_dual: in std_logic;
        x_pcie_sci_int: out std_logic;
        x_pcie_sci_rd: in std_logic;
        x_pcie_sci_sel: in std_logic;
        x_pcie_sci_sel_dual: in std_logic;
        x_pcie_sci_wrn: in std_logic;
        x_pcie_serdes_pdb: out std_logic;
        x_pcie_serdes_rst_dual_c: out std_logic;
        x_pcie_sys_clk_125: out std_logic;
        x_pcie_tx_ca_cpl_recheck_vc0: out std_logic;
        x_pcie_tx_ca_p_recheck_vc0: out std_logic;
        x_pcie_tx_dllp_sent: out std_logic;
        x_pcie_tx_end_vc0: in std_logic;
        x_pcie_tx_lbk_rdy: out std_logic;
        x_pcie_tx_nlfy_vc0: in std_logic;
        x_pcie_tx_pwrup_c: out std_logic;
        x_pcie_tx_rdy_vc0: out std_logic;
        x_pcie_tx_req_vc0: in std_logic;
        x_pcie_tx_serdes_rst_c: out std_logic;
        x_pcie_tx_st_vc0: in std_logic;
        x_pcie_unexp_cmpln: in std_logic;
        x_pcie_ur_np_ext: in std_logic;
        x_pcie_ur_p_ext: in std_logic
    );
    
end component pcie_x1_e5; -- sbp_module=true 
_inst: pcie_x1_e5 port map (x_cref_refclkn => __,x_cref_refclko => __,x_cref_refclkp => __,
            x_pcie_bus_num => __,x_pcie_cmd_reg_out => __,x_pcie_dev_cntl_out => __,
            x_pcie_dev_num => __,x_pcie_func_num => __,x_pcie_lnk_cntl_out => __,
            x_pcie_mm_enable => __,x_pcie_msi => __,x_pcie_npd_num_vc0 => __,
            x_pcie_pd_num_vc0 => __,x_pcie_phy_ltssm_state => __,x_pcie_pm_power_state => __,
            x_pcie_rx_bar_hit => __,x_pcie_rx_data_vc0 => __,x_pcie_rx_lbk_data => __,
            x_pcie_rx_lbk_kcntl => __,x_pcie_rxdp_dllp_val => __,x_pcie_rxdp_pmd_type => __,
            x_pcie_rxdp_vsd_data => __,x_pcie_sci_addr => __,x_pcie_sci_rddata => __,
            x_pcie_sci_wrdata => __,x_pcie_tx_ca_cpld_vc0 => __,x_pcie_tx_ca_cplh_vc0 => __,
            x_pcie_tx_ca_npd_vc0 => __,x_pcie_tx_ca_nph_vc0 => __,x_pcie_tx_ca_pd_vc0 => __,
            x_pcie_tx_ca_ph_vc0 => __,x_pcie_tx_data_vc0 => __,x_pcie_tx_dllp_val => __,
            x_pcie_tx_lbk_data => __,x_pcie_tx_lbk_kcntl => __,x_pcie_tx_pmtype => __,
            x_pcie_tx_vsd_data => __,x_pcie_cmpln_tout => __,x_pcie_cmpltr_abort_np => __,
            x_pcie_cmpltr_abort_p => __,x_pcie_dl_active => __,x_pcie_dl_inactive => __,
            x_pcie_dl_init => __,x_pcie_dl_up => __,x_pcie_flip_lanes => __,
            x_pcie_force_disable_scr => __,x_pcie_force_lsm_active => __,x_pcie_force_phy_status => __,
            x_pcie_force_rec_ei => __,x_pcie_hdinn0 => __,x_pcie_hdinp0 => __,
            x_pcie_hdoutn0 => __,x_pcie_hdoutp0 => __,x_pcie_hl_disable_scr => __,
            x_pcie_hl_gto_cfg => __,x_pcie_hl_gto_det => __,x_pcie_hl_gto_dis => __,
            x_pcie_hl_gto_hrst => __,x_pcie_hl_gto_l0stx => __,x_pcie_hl_gto_l0stxfts => __,
            x_pcie_hl_gto_l1 => __,x_pcie_hl_gto_l2 => __,x_pcie_hl_gto_lbk => __,
            x_pcie_hl_gto_rcvry => __,x_pcie_hl_snd_beacon => __,x_pcie_inta_n => __,
            x_pcie_msi_enable => __,x_pcie_no_pcie_train => __,x_pcie_np_req_pend => __,
            x_pcie_npd_buf_status_vc0 => __,x_pcie_npd_processed_vc0 => __,
            x_pcie_nph_buf_status_vc0 => __,x_pcie_nph_processed_vc0 => __,
            x_pcie_pd_buf_status_vc0 => __,x_pcie_pd_processed_vc0 => __,x_pcie_ph_buf_status_vc0 => __,
            x_pcie_ph_processed_vc0 => __,x_pcie_phy_pol_compliance => __,
            x_pcie_pll_refclki => __,x_pcie_pme_en => __,x_pcie_pme_status => __,
            x_pcie_rst_n => __,x_pcie_rx_end_vc0 => __,x_pcie_rx_malf_tlp_vc0 => __,
            x_pcie_rx_st_vc0 => __,x_pcie_rx_us_req_vc0 => __,x_pcie_rxrefclk => __,
            x_pcie_sci_en => __,x_pcie_sci_en_dual => __,x_pcie_sci_int => __,
            x_pcie_sci_rd => __,x_pcie_sci_sel => __,x_pcie_sci_sel_dual => __,
            x_pcie_sci_wrn => __,x_pcie_serdes_pdb => __,x_pcie_serdes_rst_dual_c => __,
            x_pcie_sys_clk_125 => __,x_pcie_tx_ca_cpl_recheck_vc0 => __,x_pcie_tx_ca_p_recheck_vc0 => __,
            x_pcie_tx_dllp_sent => __,x_pcie_tx_end_vc0 => __,x_pcie_tx_lbk_rdy => __,
            x_pcie_tx_nlfy_vc0 => __,x_pcie_tx_pwrup_c => __,x_pcie_tx_rdy_vc0 => __,
            x_pcie_tx_req_vc0 => __,x_pcie_tx_serdes_rst_c => __,x_pcie_tx_st_vc0 => __,
            x_pcie_unexp_cmpln => __,x_pcie_ur_np_ext => __,x_pcie_ur_p_ext => __);
