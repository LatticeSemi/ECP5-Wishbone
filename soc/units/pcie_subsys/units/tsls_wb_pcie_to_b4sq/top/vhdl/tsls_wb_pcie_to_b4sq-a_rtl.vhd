
Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.tsls_wb_pcie_to_b4sq_comps.all;
Use WORK.tspc_utils.all;

Architecture Rtl of tsls_wb_pcie_to_b4sq is
   signal s_u1_cpld_rx_data            : std_logic_vector(31 downto 0);
   signal s_u1_cpld_rx_push            : std_logic;
   signal s_u1_cpld_rx_sta_err         : std_logic;
   signal s_u1_cpld_rx_tag             : std_logic_vector(7 downto 0);
   signal s_u1_rx_aempty               : std_logic;
   signal s_u1_rx_bar_hit              : std_logic_vector(2 downto 0);
   signal s_u1_rx_count                : std_logic_vector(f_vec_msb(g_fifo_sz_rxq) downto 0);
   signal s_u1_rx_data                 : std_logic_vector(31 downto 0);
   signal s_u1_rx_empty                : std_logic;
   signal s_u1_rx_sof                  : std_logic;
   signal s_u2_cplx_tx_data            : std_logic_vector(31 downto 0);
   signal s_u2_cplx_tx_push            : std_logic;
   signal s_u2_cplx_txq_push           : std_logic;
   signal s_u2_cc_npd_num              : std_logic_vector(7 downto 0);
   signal s_u2_cc_pd_num               : std_logic_vector(7 downto 0);
   signal s_u2_cc_processed_npd        : std_logic;
   signal s_u2_cc_processed_nph        : std_logic;
   signal s_u2_cc_processed_pd         : std_logic;
   signal s_u2_cc_processed_ph         : std_logic;
   signal s_u2_dec_adr                 : std_logic_vector(o_decode_adr'length - 1 downto 0);
   signal s_u2_dec_bar_hit             : std_logic_vector(6 downto 0);
   signal s_u2_tlp_rx_pop              : std_logic;
   signal s_u2_wb_adr                  : std_logic_vector(o_wbm_adr'length -1 downto 0);
   signal s_u2_wb_bte                  : std_logic_vector(1 downto 0);
   signal s_u2_wb_cti                  : std_logic_vector(2 downto 0);
   signal s_u2_wb_cyc                  : std_logic_vector(o_wbm_cyc'length - 1 downto 0);
   signal s_u2_wb_cyc_local            : std_logic;
   signal s_u2_wb_sel                  : std_logic_vector(3 downto 0);
   signal s_u2_wb_stb                  : std_logic;
   signal s_u2_wb_wdat                 : std_logic_vector(31 downto 0);
   signal s_u2_wb_we                   : std_logic;
   signal s_u2_wb_we_local             : std_logic;
   signal s_u3_cplx_tx_free            : std_logic_vector(9 downto 0);
   signal s_u3_ipx_data                : std_logic_vector(15 downto 0);
   signal s_u3_ipx_end                 : std_logic;
   signal s_u3_ipx_req                 : std_logic;
   signal s_u3_ipx_start               : std_logic;
   signal s_u3_txq_ack_cplx            : std_logic; 
   signal s_u4_dis_intx                : std_logic;
   signal s_u4_dis_link                : std_logic;
   signal s_u4_dl_up                   : std_logic;
   signal s_u4_en_bus_mst              : std_logic;
   signal s_u4_en_io_space             : std_logic;
   signal s_u4_en_mem_space            : std_logic;
   signal s_u4_en_no_snoop             : std_logic;
   signal s_u4_en_perr                 : std_logic;
   signal s_u4_en_serr                 : std_logic;
   signal s_u4_en_tag_extend           : std_logic;
   signal s_u4_func_reset              : std_logic;
   signal s_u4_header_active           : std_logic;
   signal s_u4_hot_reset               : std_logic;
   signal s_u4_inta                    : std_logic;
   signal s_u4_max_payload_size        : std_logic_vector(2 downto 0);
   signal s_u4_max_read_request        : std_logic_vector(2 downto 0);
   signal s_u4_msi_req                 : std_logic_vector(7 downto 0);
   signal s_u4_payload_active          : std_logic;
   signal s_u4_phy_ltssm_state         : std_logic_vector(3 downto 0);
   signal s_u4_phy_ltssm_substate      : std_logic_vector(2 downto 0);
   signal s_u4_rcb_128_byte            : std_logic;
   signal s_u4_synced_rst_n            : std_logic;   
   signal s_u5_npd_infinite            : std_logic;
   signal s_u5_nph_infinite            : std_logic;
   signal s_u5_pd_infinite             : std_logic;
   signal s_u5_ph_infinite             : std_logic;
   signal s_u5_io_space_sel            : std_logic_vector(6 downto 0);   
   
Begin
   o_decode_adr            <= s_u2_dec_adr;
   o_decode_bar_hit        <= s_u2_dec_bar_hit;
   
   o_fc_num_npd            <= s_u2_cc_npd_num;
   o_fc_num_pd             <= s_u2_cc_pd_num;
   o_fc_processed_npd      <= s_u2_cc_processed_npd;
   o_fc_processed_nph      <= s_u2_cc_processed_nph;
   o_fc_processed_pd       <= s_u2_cc_processed_pd;
   o_fc_processed_ph       <= s_u2_cc_processed_ph;

   o_int_req               <= s_u4_inta;
   o_msi_req               <= s_u4_msi_req;
   
   o_tx_data               <= s_u3_ipx_data;
   o_tx_end                <= s_u3_ipx_end;
   o_tx_req                <= s_u3_ipx_req;
   o_tx_st                 <= s_u3_ipx_start;

   o_wbm_adr               <= s_u2_wb_adr;
   o_wbm_bte               <= s_u2_wb_bte;
   o_wbm_cti               <= s_u2_wb_cti;
   o_wbm_cyc               <= s_u2_wb_cyc;
   o_wbm_dat               <= std_logic_vector(resize(unsigned(s_u2_wb_wdat), o_wbm_dat'length ));
   o_wbm_lock              <= c_tie_low;
   o_wbm_sel               <= std_logic_vector(resize(unsigned(s_u2_wb_sel), o_wbm_sel'length ));
   o_wbm_stb               <= s_u2_wb_stb;
   o_wbm_we                <= s_u2_wb_we;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   U1_PRXF:
      -- Receives Transactions from Lattice Core
   b4sq_pkt_rx_fifo
      Generic Map (
         g_mem_words    => g_fifo_sz_rxq
         )
      Port Map (
         i_clk                => i_clk_125,
         i_rst_n              => i_rst_n,

         i_dl_up              => s_u4_dl_up,
         i_rx_bar_hit         => i_rx_bar_hit,
         i_rx_data            => i_rx_data,
         i_rx_end             => i_rx_end,
         i_rx_pop             => s_u2_tlp_rx_pop,
         i_rx_st              => i_rx_st,

         o_cpld_rx_data       => s_u1_cpld_rx_data,
         o_cpld_rx_push       => s_u1_cpld_rx_push,
         o_cpld_rx_sta_err    => s_u1_cpld_rx_sta_err,
         o_cpld_rx_tag        => s_u1_cpld_rx_tag,
         o_rx_aempty          => s_u1_rx_aempty,
         o_rx_bar_hit         => s_u1_rx_bar_hit,
         o_rx_count           => s_u1_rx_count,
         o_rx_data            => s_u1_rx_data,
         o_rx_empty           => s_u1_rx_empty,
         o_rx_sof             => s_u1_rx_sof
         );
         
   U2_DEC:
      -- Decodes Transactions from Lattice Core
   b4sq_pkt_decode 
      Port Map (
         i_clk                   => i_clk_125,
         i_rst_n                 => i_rst_n,

         i_ca_npd_infinite       => s_u5_npd_infinite,
         i_ca_nph_infinite       => s_u5_nph_infinite,
         i_ca_pd_infinite        => s_u5_pd_infinite,
         i_ca_ph_infinite        => s_u5_ph_infinite,
         i_cid_bus_nr            => i_csp_bus_num,
         i_cid_dev_nr            => i_csp_dev_num,
         i_cid_func_nr           => i_csp_func_num,
         i_cfg_io_space_en       => s_u4_en_io_space,
         i_cfg_io_space_sel      => s_u5_io_space_sel,
         i_cfg_mem_space_en      => s_u4_en_mem_space,
         i_ctl_max_payload_size  => s_u4_max_payload_size,
         i_cplx_tx_free          => s_u3_cplx_tx_free,
         i_cplx_txq_ack          => s_u3_txq_ack_cplx,
         i_dec_cyc               => i_decode_cyc,
         i_dec_cyc_local         => c_tie_low,
         i_tlp_rx_bar_hit        => s_u1_rx_bar_hit,
         i_tlp_rx_count          => s_u1_rx_count,
         i_tlp_rx_data           => s_u1_rx_data,
         i_tlp_rx_empty          => s_u1_rx_empty,
         i_wb_ack                => i_wbm_ack,
         i_wb_ack_local          => c_tie_low,
         i_wb_rdat               => i_wbm_dat,
         i_wb_rdat_local         => c_tie_low_dword,

         o_cc_npd_num            => s_u2_cc_npd_num,
         o_cc_pd_num             => s_u2_cc_pd_num,
         o_cc_processed_npd      => s_u2_cc_processed_npd,
         o_cc_processed_nph      => s_u2_cc_processed_nph,
         o_cc_processed_pd       => s_u2_cc_processed_pd,
         o_cc_processed_ph       => s_u2_cc_processed_ph,
         o_cpld_rx_data          => open,
         o_cpld_rx_push          => open,
         o_cpld_rx_sta_err       => open,
         o_cpld_rx_tag           => open,
         o_cplx_tx_data          => s_u2_cplx_tx_data,
         o_cplx_tx_last          => open,
         o_cplx_tx_push          => s_u2_cplx_tx_push,
         o_cplx_txq_push         => s_u2_cplx_txq_push,
         o_dec_adr               => s_u2_dec_adr,
         o_dec_bar_hit           => s_u2_dec_bar_hit,
         o_tlp_rx_pop            => s_u2_tlp_rx_pop,
         o_wb_adr                => s_u2_wb_adr,
         o_wb_bte                => s_u2_wb_bte,
         o_wb_cti                => s_u2_wb_cti,
         o_wb_cyc                => s_u2_wb_cyc,
         o_wb_cyc_local          => open,
         o_wb_sel                => s_u2_wb_sel,
         o_wb_stb                => s_u2_wb_stb,
         o_wb_wdat               => s_u2_wb_wdat,
         o_wb_we                 => s_u2_wb_we,
         o_wb_we_local           => open
         );         
         
   U3_TXM:
      -- Generates PCIe Response, as well as posted/non-posted Request Packets
   b4sq_tlp_xmitter
      Generic Map (
         g_fifo_sz_cpl     => g_fifo_sz_cpl,
         g_fifo_sz_np      => g_fifo_sz_np,
         g_fifo_sz_p       => g_fifo_sz_p,
         g_fifo_sz_txseq   => g_fifo_sz_txseq,     
         g_tech_lib        => g_tech_lib
         )
      Port Map (
         i_clk             => i_clk_125,
         i_rst_n           => i_rst_n,

         i_ca_cpld         => i_fc_ca_cpld,
         i_ca_cplh         => i_fc_ca_cplh,
         i_ca_npd          => i_fc_ca_npd,
         i_ca_nph          => i_fc_ca_nph,
         i_ca_pd           => i_fc_ca_pd,
         i_ca_ph           => i_fc_ca_ph,
         i_ctl_bus_mst_en  => s_u4_en_bus_mst,
         i_dl_up           => s_u4_dl_up,
         i_fc_cpl_recheck  => i_fc_cpl_recheck,
         i_fc_p_recheck    => i_fc_p_recheck,         
         i_ipx_rdy         => i_tx_rdy,
         i_tlp_data_cpl    => s_u2_cplx_tx_data,
         i_tlp_data_np     => c_tie_low_dword,
         i_tlp_data_p      => c_tie_low_dword,
         i_tlp_push_cpl    => s_u2_cplx_tx_push,
         i_tlp_push_np     => c_tie_low,
         i_tlp_push_p      => c_tie_low,
         i_txq_push_cplx   => s_u2_cplx_txq_push,
         i_txq_push_np     => c_tie_low,
         i_txq_push_p      => c_tie_low,

         o_free_count_cpl  => s_u3_cplx_tx_free,
         o_free_count_np   => open,
         o_free_count_p    => open,
         o_ipx_data        => s_u3_ipx_data,
         o_ipx_end         => s_u3_ipx_end,
         o_ipx_req         => s_u3_ipx_req,
         o_ipx_start       => s_u3_ipx_start,
         o_txq_ack_cplx    => s_u3_txq_ack_cplx,
         o_txq_ack_np      => open,
         o_txq_ack_p       => open
         );        
         
   U4_PCIE_SVC:
   b4sq_pcie_svc
      Port Map (
         i_clk_125            => i_clk_125,
         i_rst_n              => i_rst_n,

         i_dev_cntl_reg       => i_csp_reg_dev_ctl,
         i_dl_up              => i_ipx_dl_up,
         i_hdr_4dw            => s_u3_ipx_data(13),
         i_int_req            => i_int_req,
         i_ipcore_rst_n       => i_ipx_rst_n,
         i_link_cntl_reg      => i_csp_reg_link_ctl,
         i_mm_enable          => i_csp_msi_mm_enable,
         i_msi_enable         => i_csp_msi_enable,
         i_pci_cmd_reg        => i_csp_reg_pci_cmd,
         i_phy_ltssm_state    => i_ipx_ltssm_state,
         i_phy_ltssm_substate => i_ipx_ltssm_substate,
         i_tx_ca_p_recheck    => i_fc_p_recheck,
         i_tx_end             => s_u3_ipx_end,
         i_tx_nlfy            => c_tie_low,
         i_tx_start           => s_u3_ipx_start,

         o_dis_intx           => s_u4_dis_intx,
         o_dis_link           => s_u4_dis_link,
         o_dl_up              => s_u4_dl_up,
         o_en_bus_mst         => s_u4_en_bus_mst,
         o_en_io_space        => s_u4_en_io_space,
         o_en_mem_space       => s_u4_en_mem_space,
         o_en_no_snoop        => s_u4_en_no_snoop,
         o_en_perr            => s_u4_en_perr,
         o_en_serr            => s_u4_en_serr,
         o_en_tag_extend      => s_u4_en_tag_extend,
         o_func_rst           => s_u4_func_reset,
         o_header_active      => s_u4_header_active,
         o_hot_rst            => s_u4_hot_reset,
         o_inta               => s_u4_inta,
         o_max_payload_size   => s_u4_max_payload_size,
         o_max_read_request   => s_u4_max_read_request,
         o_msi_req            => s_u4_msi_req,
         o_payload_active     => s_u4_payload_active,
         o_phy_ltssm_state    => s_u4_phy_ltssm_state,
         o_phy_ltssm_substate => s_u4_phy_ltssm_substate,
         o_rcb_128_byte       => s_u4_rcb_128_byte,
         o_synced_rst_n       => s_u4_synced_rst_n
         );            
         
   U5_CC:
   b4sq_credit_config
      Port Map (
         o_fc_cpld_infinite   => open,
         o_fc_cplh_infinite   => open,
         o_fc_npd_infinite    => s_u5_npd_infinite,
         o_fc_nph_infinite    => s_u5_nph_infinite,
         o_fc_pd_infinite     => s_u5_pd_infinite,
         o_fc_ph_infinite     => s_u5_ph_infinite,
         o_io_space_sel       => s_u5_io_space_sel,
         o_hw_rev             => open,
         o_subsys_id          => open
         );         
End Rtl;
