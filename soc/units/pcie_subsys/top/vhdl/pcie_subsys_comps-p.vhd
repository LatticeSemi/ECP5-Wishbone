
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: pcie_subsys_comps-p.vhd 16 2021-10-05 12:33:32Z  $
-- Generated  : $LastChangedDate: 2021-10-05 14:33:32 +0200 (Tue, 05 Oct 2021) $
-- Revision   : $LastChangedRevision: 16 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Package pcie_subsys_comps is
   Component lscc_pcie_x1_ip
         -- g_ip_rev_id    : [V5_x, V6_x], for ECP3 only
         -- g_pcie_gen2    : [true, false], for ECP5UM only
         -- g_tech_lib     : [ECP3, ECP5UM]
      Generic (
         g_ip_rev_id       : string := "V6_x";
         g_pcie_gen2       : boolean := false;
         g_tech_lib        : string := "ECP3"
         );

      Port (
         ox_clk_125              : out std_logic;
         ix_rst_n                : in  std_logic;
         
         ix_hdinn0               : in  std_logic;
         ix_hdinp0               : in  std_logic;
         ox_hdoutn0              : out std_logic;
         ox_hdoutp0              : out std_logic;
         ix_refclkn              : in  std_logic;
         ix_refclkp              : in  std_logic;
         
         ix_fc_num_npd           : in  std_logic_vector(7 downto 0);
         ix_fc_num_pd            : in  std_logic_vector(7 downto 0);
         ix_fc_processed_npd     : in  std_logic;
         ix_fc_processed_nph     : in  std_logic;
         ix_fc_processed_pd      : in  std_logic;
         ix_fc_processed_ph      : in  std_logic;
         ix_int_req              : in  std_logic;
         ix_msi_req              : in  std_logic_vector(7 downto 0);
         ix_tx_data              : in  std_logic_vector(15 downto 0);
         ix_tx_end               : in  std_logic;
         ix_tx_req               : in  std_logic;
         ix_tx_st                : in  std_logic;
               
         ox_bus_num              : out std_logic_vector(7 downto 0);
         ox_cmd_reg_out          : out std_logic_vector(5 downto 0);
         ox_dev_cntl_out         : out std_logic_vector(14 downto 0);
         ox_dev_num              : out std_logic_vector(4 downto 0);
         ox_dl_up                : out std_logic;
         ox_func_num             : out std_logic_vector(2 downto 0);
         ox_lnk_cntl_out         : out std_logic_vector(7 downto 0);
         ox_mm_enable            : out std_logic_vector(2 downto 0);
         ox_msi_enable           : out std_logic;
         ox_phy_ltssm_state      : out std_logic_vector(3 downto 0);
         ox_rx_bar_hit           : out std_logic_vector(6 downto 0);
         ox_rx_data              : out std_logic_vector(15 downto 0);
         ox_rx_end               : out std_logic;
         ox_rx_st                : out std_logic;
         ox_tx_ca_cpl_recheck    : out std_logic;
         ox_tx_ca_cpld           : out std_logic_vector(12 downto 0);
         ox_tx_ca_cplh           : out std_logic_vector(8 downto 0);
         ox_tx_ca_npd            : out std_logic_vector(12 downto 0);
         ox_tx_ca_nph            : out std_logic_vector(8 downto 0);
         ox_tx_ca_p_recheck      : out std_logic;
         ox_tx_ca_pd             : out std_logic_vector(12 downto 0);
         ox_tx_ca_ph             : out std_logic_vector(8 downto 0);
         ox_tx_rdy               : out std_logic   
         );
   End Component;
   
   
   Component tsls_wb_pcie_to_b4sq
      Generic (
         g_fifo_sz_cpl     : positive := 512;
         g_fifo_sz_np      : positive := 512;
         g_fifo_sz_p       : positive := 512;
         g_fifo_sz_rxq     : positive := 512;
         g_fifo_sz_txseq   : positive := 64;         
         g_tech_lib        : string := "ECP3"
         );
      Port (
         i_clk_125                  : in  std_logic;
         i_rst_n                    : in  std_logic;
      
         i_csp_bus_num              : in  std_logic_vector(7 downto 0);
         i_csp_dev_num              : in  std_logic_vector(4 downto 0);
         i_csp_func_num             : in  std_logic_vector(2 downto 0);
         i_csp_msi_enable           : in  std_logic;
         i_csp_msi_mm_enable        : in  std_logic_vector(2 downto 0);
         i_csp_reg_dev_ctl          : in  std_logic_vector(14 downto 0);
         i_csp_reg_link_ctl         : in  std_logic_vector(7 downto 0);
         i_csp_reg_pci_cmd          : in  std_logic_vector(5 downto 0);
         i_decode_cyc               : in  std_logic_vector;
         i_decode_cyc_local         : in  std_logic;      
         i_fc_ca_cpld               : in  std_logic_vector(12 downto 0);
         i_fc_ca_cplh               : in  std_logic_vector(8 downto 0);
         i_fc_ca_npd                : in  std_logic_vector(12 downto 0);
         i_fc_ca_nph                : in  std_logic_vector(8 downto 0);
         i_fc_ca_pd                 : in  std_logic_vector(12 downto 0);
         i_fc_ca_ph                 : in  std_logic_vector(8 downto 0);    
         i_fc_cpl_recheck           : in  std_logic;
         i_fc_p_recheck             : in  std_logic;
         i_int_req                  : in  std_logic_vector;
         i_ipx_dl_up                : in  std_logic;
         i_ipx_ltssm_state          : in  std_logic_vector(3 downto 0);
         i_ipx_ltssm_substate       : in  std_logic_vector(2 downto 0);
         i_ipx_rst_n                : in  std_logic;
         i_rx_bar_hit               : in  std_logic_vector(6 downto 0);
         i_rx_data                  : in  std_logic_vector(15 downto 0);
         i_rx_end                   : in  std_logic;
         i_rx_st                    : in  std_logic;
         i_tx_rdy                   : in  std_logic;
         i_wbm_ack                  : in  std_logic;
         i_wbm_dat                  : in  std_logic_vector;

         o_decode_adr               : out std_logic_vector;
         o_decode_bar_hit           : out std_logic_vector(6 downto 0);      
         o_fc_num_npd               : out std_logic_vector(7 downto 0);
         o_fc_num_pd                : out std_logic_vector(7 downto 0);
         o_fc_processed_npd         : out std_logic;
         o_fc_processed_nph         : out std_logic;
         o_fc_processed_pd          : out std_logic;
         o_fc_processed_ph          : out std_logic;      
         o_int_req                  : out std_logic;
         o_msi_req                  : out std_logic_vector(7 downto 0);
         o_tx_data                  : out std_logic_vector(15 downto 0);
         o_tx_end                   : out std_logic;
         o_tx_req                   : out std_logic;
         o_tx_st                    : out std_logic;
         o_wbm_adr                  : out std_logic_vector;
         o_wbm_bte                  : out std_logic_vector(1 downto 0);
         o_wbm_cti                  : out std_logic_vector(2 downto 0);
         o_wbm_cyc                  : out std_logic_vector;
         o_wbm_dat                  : out std_logic_vector;
         o_wbm_lock                 : out std_logic;    
         o_wbm_sel                  : out std_logic_vector;
         o_wbm_stb                  : out std_logic;
         o_wbm_we                   : out std_logic
         );   
   End Component;   
   
   
   Component tspc_cdc_sig
      Generic (
         g_stages    : positive := 1
         );
      Port ( 
         i_clk       : in  std_logic;
         i_rst_n     : in  std_logic;
         
         i_cdc_in    : in  std_logic;
         
         o_cdc_out   : out std_logic
         );   
   End Component;     
End pcie_subsys_comps;
