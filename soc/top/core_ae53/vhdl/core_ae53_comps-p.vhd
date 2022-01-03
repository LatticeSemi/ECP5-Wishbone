
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: core_ae53_comps-p.vhd 16 2021-10-05 12:33:32Z  $
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

Package core_ae53_comps is
   Component pcie_rsrc_decode
      Port (
         i_decode_adr         : in  std_logic_vector;
         i_decode_bar_hit     : in  std_logic_vector(6 downto 0);
         
         o_decode_cyc         : out std_logic_vector
         );
   End Component;
   
   
   Component pcie_subsys
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
   End Component;
   
   
   Component tsls_wb_bmram
      Generic (
         g_array_sz        : positive;
         g_char_sz         : positive := 8;  
         g_mem_reset_mode  : string := "async";  
         g_tech_lib        : string := "ECP3";
         g_word_sz         : positive := 4
         );
      Port (
         i_clk       : in  std_logic;
         i_rst_n     : in  std_logic;
         
         i_wb_adr    : in  std_logic_vector;
         i_wb_bte    : in  std_logic_vector(1 downto 0); 
         i_wb_cti    : in  std_logic_vector(2 downto 0);
         i_wb_cyc    : in  std_logic;
         i_wb_dat    : in  std_logic_vector;
         i_wb_lock   : in  std_logic;
         i_wb_sel    : in  std_logic_vector;
         i_wb_stb    : in  std_logic;
         i_wb_we     : in  std_logic;
            
         o_wb_ack    : out std_logic;      
         o_wb_dat    : out std_logic_vector
         );
   End Component;   
   
   
   Component tspc_rtc
      Generic (
         g_prescale : positive := 16#773_5940#
         );
      Port (
         i_clk       : in  std_logic;
         i_rst_n     : in  std_logic;
         
         o_rtc       : out std_logic_vector;
         o_rtc_ev    : out std_logic;
         o_rtc_tick  : out std_logic
         );
   End Component;   
End core_ae53_comps;
