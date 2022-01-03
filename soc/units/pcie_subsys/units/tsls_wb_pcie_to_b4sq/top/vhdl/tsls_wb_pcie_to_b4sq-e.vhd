
--
--       This proprietary software may be used only as authorised in a licensing,
--       product development or training agreement.
--
--       Copies may only be made to the extent permitted by such an aforementioned
--       agreement. This entire notice above must be reproduced on
--       all copies.
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tsls_wb_pcie_to_b4sq-e.vhd 3886 2018-01-05 16:57:26Z  $
-- Generated   : $LastChangedDate: 2018-01-05 17:57:26 +0100 (Fri, 05 Jan 2018) $
-- Revision    : $LastChangedRevision: 3886 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--    Module namespace ID  : b4sq
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity tsls_wb_pcie_to_b4sq is
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
End tsls_wb_pcie_to_b4sq;
