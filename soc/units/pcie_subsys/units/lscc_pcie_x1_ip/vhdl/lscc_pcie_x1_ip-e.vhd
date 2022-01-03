
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: lscc_pcie_x1_ip-e.vhd 6 2021-09-30 10:31:08Z  $
-- Generated  : $LastChangedDate: 2021-09-30 12:31:08 +0200 (Thu, 30 Sep 2021) $
-- Revision   : $LastChangedRevision: 6 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity lscc_pcie_x1_ip is
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
End lscc_pcie_x1_ip;
