
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: pcie_subsys-e.vhd 16 2021-10-05 12:33:32Z  $
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

Entity pcie_subsys is
   Generic (
      g_fifo_sz_cpl     : positive := 512;
      g_fifo_sz_np      : positive := 512;
      g_fifo_sz_p       : positive := 512;
      g_fifo_sz_rxq     : positive := 512;
      g_fifo_sz_txseq   : positive := 64;     
      g_ip_rev_id       : string := "V6_x";
      g_pcie_gen2       : boolean := false;
      g_tech_lib        : string := "ECP3"   
      );
   Port (
      o_clk_125            : out std_logic;
      i_rst_n              : in  std_logic;
      o_rst_cdc_n          : out std_logic;
      
      i_hdinn0             : in  std_logic;
      i_hdinp0             : in  std_logic;
      o_hdoutn0            : out std_logic;
      o_hdoutp0            : out std_logic;
      i_refclkn            : in  std_logic;
      i_refclkp            : in  std_logic;   

      i_decode_cyc         : in  std_logic_vector;
      i_int_req            : in  std_logic_vector(7 downto 0);
      i_wbm_ack            : in  std_logic;
      i_wbm_dat            : in  std_logic_vector(31 downto 0);
      
      o_decode_adr         : out std_logic_vector;
      o_decode_bar_hit     : out std_logic_vector(6 downto 0);        
      o_dl_up              : out std_logic;
      o_phy_ltssm_state    : out std_logic_vector(3 downto 0);
      o_wbm_adr            : out std_logic_vector;
      o_wbm_bte            : out std_logic_vector(1 downto 0);
      o_wbm_cti            : out std_logic_vector(2 downto 0);
      o_wbm_cyc            : out std_logic_vector;
      o_wbm_dat            : out std_logic_vector(31 downto 0);
      o_wbm_sel            : out std_logic_vector(3 downto 0);
      o_wbm_stb            : out std_logic;
      o_wbm_we             : out std_logic         
      );
End pcie_subsys;
