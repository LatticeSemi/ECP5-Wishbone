
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: pcie_subsys-a_rtl.vhd 29 2021-11-08 22:58:59Z  $
-- Generated  : $LastChangedDate: 2021-11-08 23:58:59 +0100 (Mon, 08 Nov 2021) $
-- Revision   : $LastChangedRevision: 29 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------
Use WORK.pcie_subsys_comps.all;
Use WORK.tspc_utils.all;

Architecture Rtl of pcie_subsys is
   constant c_num_wb_tgts     : positive := i_decode_cyc'length;
   constant c_wbm_adr_sz      : positive := o_wbm_adr'length;
   
   signal s_rtl_rst_n               : std_logic;
   signal s_u1_rst_n                : std_logic;
   signal s_u2_bus_num              : std_logic_vector(7 downto 0);
   signal s_u2_clk_125              : std_logic;
   signal s_u2_cmd_reg_out          : std_logic_vector(5 downto 0);
   signal s_u2_dev_cntl_out         : std_logic_vector(14 downto 0);
   signal s_u2_dev_num              : std_logic_vector(4 downto 0);
   signal s_u2_dl_up                : std_logic;
   signal s_u2_func_num             : std_logic_vector(2 downto 0);
   signal s_u2_lnk_cntl_out         : std_logic_vector(7 downto 0);
   signal s_u2_mm_enable            : std_logic_vector(2 downto 0);
   signal s_u2_msi_enable           : std_logic;
   signal s_u2_phy_ltssm_state      : std_logic_vector(3 downto 0);
   signal s_u2_refclk               : std_logic;
   signal s_u2_rx_bar_hit           : std_logic_vector(6 downto 0);
   signal s_u2_rx_data              : std_logic_vector(15 downto 0);
   signal s_u2_rx_end               : std_logic;
   signal s_u2_rx_st                : std_logic;
   signal s_u2_tx_ca_cpl_recheck    : std_logic;
   signal s_u2_tx_ca_cpld           : std_logic_vector(12 downto 0);
   signal s_u2_tx_ca_cplh           : std_logic_vector(8 downto 0);
   signal s_u2_tx_ca_npd            : std_logic_vector(12 downto 0);
   signal s_u2_tx_ca_nph            : std_logic_vector(8 downto 0);
   signal s_u2_tx_ca_p_recheck      : std_logic;
   signal s_u2_tx_ca_pd             : std_logic_vector(12 downto 0);
   signal s_u2_tx_ca_ph             : std_logic_vector(8 downto 0);
   signal s_u2_tx_rdy               : std_logic;
   signal s_u3_decode_adr           : std_logic_vector(c_wbm_adr_sz - 1 downto 0);
   signal s_u3_decode_bar_hit       : std_logic_vector(6 downto 0);
   signal s_u3_fc_num_npd           : std_logic_vector(7 downto 0);
   signal s_u3_fc_num_pd            : std_logic_vector(7 downto 0);
   signal s_u3_fc_processed_npd     : std_logic;
   signal s_u3_fc_processed_nph     : std_logic;
   signal s_u3_fc_processed_pd      : std_logic;
   signal s_u3_fc_processed_ph      : std_logic;
   signal s_u3_int_req              : std_logic;
   signal s_u3_msi_req              : std_logic_vector(7 downto 0);
   signal s_u3_tx_data              : std_logic_vector(15 downto 0);
   signal s_u3_tx_end               : std_logic;
   signal s_u3_tx_req               : std_logic;
   signal s_u3_tx_st                : std_logic;
   signal s_u3_wbm_adr              : std_logic_vector(c_wbm_adr_sz - 1 downto 0);
   signal s_u3_wbm_bte              : std_logic_vector(1 downto 0);
   signal s_u3_wbm_cti              : std_logic_vector(2 downto 0);
   signal s_u3_wbm_cyc              : std_logic_vector(c_num_wb_tgts - 1 downto 0);
   signal s_u3_wbm_dat              : std_logic_vector(31 downto 0);
   signal s_u3_wbm_sel              : std_logic_vector(3 downto 0);
   signal s_u3_wbm_stb              : std_logic;
   signal s_u3_wbm_we               : std_logic;   
   
Begin
   o_clk_125            <= s_u2_clk_125;
   
   o_decode_adr         <= s_u3_decode_adr;
   o_decode_bar_hit     <= s_u3_decode_bar_hit;  
   
   o_dl_up              <= s_u2_dl_up;
   o_phy_ltssm_state    <= s_u2_phy_ltssm_state;
   
   o_rst_cdc_n          <= s_u1_rst_n;
   
   o_wbm_adr            <= s_u3_wbm_adr;
   o_wbm_bte            <= s_u3_wbm_bte;
   o_wbm_cti            <= s_u3_wbm_cti;
   o_wbm_cyc            <= s_u3_wbm_cyc;
   o_wbm_dat            <= s_u3_wbm_dat;
   o_wbm_sel            <= s_u3_wbm_sel;
   o_wbm_stb            <= s_u3_wbm_stb;
   o_wbm_we             <= s_u3_wbm_we;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_rtl_rst_n          <= i_rst_n and s_u2_dl_up;
 --s_rtl_rst_n          <= i_rst_n;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   U1_RST_CDC:
   tspc_cdc_sig
      Port Map ( 
         i_clk       => s_u2_clk_125,
         i_rst_n     => s_rtl_rst_n,
         
         i_cdc_in    => c_tie_high,
         
         o_cdc_out   => s_u1_rst_n
         );
         
   U2_PCIE_IP: 
   lscc_pcie_x1_ip
      Generic Map (
         g_ip_rev_id => g_ip_rev_id,
         g_pcie_gen2 => g_pcie_gen2,
         g_tech_lib  => g_tech_lib
         )
      Port Map (
         ox_clk_125              => s_u2_clk_125,
         ix_rst_n                => i_rst_n,
         
         ix_hdinn0               => i_hdinn0,
         ix_hdinp0               => i_hdinp0,
         ox_hdoutn0              => o_hdoutn0,
         ox_hdoutp0              => o_hdoutp0,
         ix_refclkn              => i_refclkn,
         ix_refclkp              => i_refclkp,
         
         ix_fc_num_npd           => s_u3_fc_num_npd,
         ix_fc_num_pd            => s_u3_fc_num_pd,
         ix_fc_processed_npd     => s_u3_fc_processed_npd,
         ix_fc_processed_nph     => s_u3_fc_processed_nph,
         ix_fc_processed_pd      => s_u3_fc_processed_pd,
         ix_fc_processed_ph      => s_u3_fc_processed_ph,
         ix_int_req              => s_u3_int_req,
         ix_msi_req              => s_u3_msi_req,
         ix_tx_data              => s_u3_tx_data,
         ix_tx_end               => s_u3_tx_end,
         ix_tx_req               => s_u3_tx_req,
         ix_tx_st                => s_u3_tx_st,

         ox_bus_num              => s_u2_bus_num,
         ox_cmd_reg_out          => s_u2_cmd_reg_out,
         ox_dev_cntl_out         => s_u2_dev_cntl_out,
         ox_dev_num              => s_u2_dev_num,
         ox_dl_up                => s_u2_dl_up,
         ox_func_num             => s_u2_func_num,
         ox_lnk_cntl_out         => s_u2_lnk_cntl_out,
         ox_mm_enable            => s_u2_mm_enable,
         ox_msi_enable           => s_u2_msi_enable,
         ox_phy_ltssm_state      => s_u2_phy_ltssm_state,
         ox_rx_bar_hit           => s_u2_rx_bar_hit,
         ox_rx_data              => s_u2_rx_data,
         ox_rx_end               => s_u2_rx_end,
         ox_rx_st                => s_u2_rx_st,
         ox_tx_ca_cpl_recheck    => s_u2_tx_ca_cpl_recheck,
         ox_tx_ca_cpld           => s_u2_tx_ca_cpld,
         ox_tx_ca_cplh           => s_u2_tx_ca_cplh,
         ox_tx_ca_npd            => s_u2_tx_ca_npd,
         ox_tx_ca_nph            => s_u2_tx_ca_nph,
         ox_tx_ca_p_recheck      => s_u2_tx_ca_p_recheck,
         ox_tx_ca_pd             => s_u2_tx_ca_pd,
         ox_tx_ca_ph             => s_u2_tx_ca_ph,
         ox_tx_rdy               => s_u2_tx_rdy
         );

   U3_WB_ADAPT:
   tsls_wb_pcie_to_b4sq
      Generic Map (
         g_tech_lib        => g_tech_lib
         )
      Port Map (
         i_clk_125                  => s_u2_clk_125,
         i_rst_n                    => s_u1_rst_n,
      
         i_csp_bus_num              => s_u2_bus_num,
         i_csp_dev_num              => s_u2_dev_num,
         i_csp_func_num             => s_u2_func_num,
         i_csp_msi_enable           => s_u2_msi_enable,
         i_csp_msi_mm_enable        => s_u2_mm_enable,
         i_csp_reg_dev_ctl          => s_u2_dev_cntl_out,
         i_csp_reg_link_ctl         => s_u2_lnk_cntl_out,
         i_csp_reg_pci_cmd          => s_u2_cmd_reg_out,
         i_decode_cyc               => i_decode_cyc,
         i_decode_cyc_local         => c_tie_low,      
         i_fc_ca_cpld               => s_u2_tx_ca_cpld,
         i_fc_ca_cplh               => s_u2_tx_ca_cplh,
         i_fc_ca_npd                => s_u2_tx_ca_npd,
         i_fc_ca_nph                => s_u2_tx_ca_nph,
         i_fc_ca_pd                 => s_u2_tx_ca_pd,
         i_fc_ca_ph                 => s_u2_tx_ca_ph,    
         i_fc_cpl_recheck           => s_u2_tx_ca_cpl_recheck,
         i_fc_p_recheck             => s_u2_tx_ca_p_recheck,
         i_int_req                  => i_int_req,
         i_ipx_dl_up                => s_u2_dl_up,
         i_ipx_ltssm_state          => s_u2_phy_ltssm_state,
         i_ipx_ltssm_substate       => c_tie_low_byte(2 downto 0),
         i_ipx_rst_n                => c_tie_high,
         i_rx_bar_hit               => s_u2_rx_bar_hit,
         i_rx_data                  => s_u2_rx_data,
         i_rx_end                   => s_u2_rx_end,
         i_rx_st                    => s_u2_rx_st,
         i_tx_rdy                   => s_u2_tx_rdy,
         i_wbm_ack                  => i_wbm_ack,
         i_wbm_dat                  => i_wbm_dat,

         o_decode_adr               => s_u3_decode_adr,
         o_decode_bar_hit           => s_u3_decode_bar_hit,      
         o_fc_num_npd               => s_u3_fc_num_npd,
         o_fc_num_pd                => s_u3_fc_num_pd,
         o_fc_processed_npd         => s_u3_fc_processed_npd,
         o_fc_processed_nph         => s_u3_fc_processed_nph,
         o_fc_processed_pd          => s_u3_fc_processed_pd,
         o_fc_processed_ph          => s_u3_fc_processed_ph,      
         o_int_req                  => s_u3_int_req,
         o_msi_req                  => s_u3_msi_req,
         o_tx_data                  => s_u3_tx_data,
         o_tx_end                   => s_u3_tx_end,
         o_tx_req                   => s_u3_tx_req,
         o_tx_st                    => s_u3_tx_st,
         o_wbm_adr                  => s_u3_wbm_adr,
         o_wbm_bte                  => s_u3_wbm_bte,
         o_wbm_cti                  => s_u3_wbm_cti,
         o_wbm_cyc                  => s_u3_wbm_cyc,
         o_wbm_dat                  => s_u3_wbm_dat,
         o_wbm_lock                 => open,    
         o_wbm_sel                  => s_u3_wbm_sel,
         o_wbm_stb                  => s_u3_wbm_stb,
         o_wbm_we                   => s_u3_wbm_we
         );   
End Rtl;
