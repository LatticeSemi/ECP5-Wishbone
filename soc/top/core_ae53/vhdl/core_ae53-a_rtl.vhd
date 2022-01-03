
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: core_ae53-a_rtl.vhd 27 2021-10-06 13:09:29Z  $
-- Generated  : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
-- Revision   : $LastChangedRevision: 27 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------
Use WORK.core_ae53_comps.all;
use WORK.core_ae53_config.all;
Use WORK.tspc_utils.all;

Architecture Rtl of core_ae53 is
   constant c_num_wb_tgts     : positive := 2;
   constant c_u3_bmram_sz     : positive := 1024;
   constant c_u4_bmram_sz     : positive := 1024;
   constant c_wbm_adr_sz      : positive := 13;
   
   signal s_rtl_wbm_ack          : std_logic;
   signal s_rtl_wbm_rdat         : t_dword;
   signal s_u1_clk_125           : std_logic;
   signal s_u1_decode_adr        : std_logic_vector(c_wbm_adr_sz - 1 downto 0);
   signal s_u1_decode_bar_hit    : std_logic_vector(6 downto 0);
   signal s_u1_dl_up             : std_logic;
   signal s_u1_phy_ltssm_state   : std_logic_vector(3 downto 0);
   signal s_u1_rst_cdc_n         : std_logic;
   signal s_u1_wbm_adr           : std_logic_vector(c_wbm_adr_sz - 1 downto 0);
   signal s_u1_wbm_bte           : std_logic_vector(1 downto 0);
   signal s_u1_wbm_cti           : std_logic_vector(2 downto 0);
   signal s_u1_wbm_cyc           : std_logic_vector(c_num_wb_tgts - 1 downto 0);
   signal s_u1_wbm_dat           : std_logic_vector(31 downto 0);
   signal s_u1_wbm_sel           : std_logic_vector(3 downto 0);
   signal s_u1_wbm_stb           : std_logic;
   signal s_u1_wbm_we            : std_logic;
   signal s_u2_rtc_ev            : std_logic;
   signal s_u2_rtc_nc            : t_dword;
   signal s_u3_decode_cyc        : std_logic_vector(c_num_wb_tgts - 1 downto 0);
   signal s_u4_wbm_ack           : std_logic;
   signal s_u4_wbm_dat           : t_dword;
   signal s_u5_wbm_ack           : std_logic;
   signal s_u5_wbm_dat           : t_dword;
   
Begin
   o_dl_up           <= s_u1_dl_up;
   o_ltssm_state     <= s_u1_phy_ltssm_state;
   o_rtc_ev          <= s_u2_rtc_ev;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_rtl_wbm_ack     <= s_u4_wbm_ack   or s_u5_wbm_ack;
   s_rtl_wbm_rdat    <= s_u4_wbm_dat   or s_u5_wbm_dat;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   U1_PCIE: 
      -- PCI Express subsystem w/ Wishbone adapter
      -- Generally no need to change anything here
   pcie_subsys
      Generic Map (
         g_ip_rev_id       => c_pcie_ip_rev_id,
         g_pcie_gen2       => c_pcie_gen2,
         g_tech_lib        => c_tech_lib
         )
      Port Map (
         o_clk_125            => s_u1_clk_125,
         i_rst_n              => i_rst_n,
         o_rst_cdc_n          => s_u1_rst_cdc_n,

         i_hdinn0             => i_hdinn0,
         i_hdinp0             => i_hdinp0,
         o_hdoutn0            => o_hdoutn0,
         o_hdoutp0            => o_hdoutp0,
         i_refclkn            => i_refclkn,
         i_refclkp            => i_refclkp,
         i_decode_cyc         => s_u3_decode_cyc,
         i_int_req            => c_tie_low_byte,
         i_wbm_ack            => s_rtl_wbm_ack,
         i_wbm_dat            => s_rtl_wbm_rdat,

         o_decode_adr         => s_u1_decode_adr,
         o_decode_bar_hit     => s_u1_decode_bar_hit,
         o_dl_up              => s_u1_dl_up,
         o_phy_ltssm_state    => s_u1_phy_ltssm_state,
         o_wbm_adr            => s_u1_wbm_adr,
         o_wbm_bte            => s_u1_wbm_bte,
         o_wbm_cti            => s_u1_wbm_cti,
         o_wbm_cyc            => s_u1_wbm_cyc,
         o_wbm_dat            => s_u1_wbm_dat,
         o_wbm_sel            => s_u1_wbm_sel,
         o_wbm_stb            => s_u1_wbm_stb,
         o_wbm_we             => s_u1_wbm_we
         );

   U2_RTC:
   tspc_rtc
      Port Map (
         i_clk       => s_u1_clk_125,
         i_rst_n     => s_u1_rst_cdc_n,
         
         o_rtc       => s_u2_rtc_nc,
         o_rtc_ev    => s_u2_rtc_ev,
         o_rtc_tick  => open
         );
         
   U3_DEC:
      -- Defines the mapping from BAR + Address-region to Wishbone client
   pcie_rsrc_decode
      Port Map (
         i_decode_adr         => s_u1_decode_adr,
         i_decode_bar_hit     => s_u1_decode_bar_hit,
         
         o_decode_cyc         => s_u3_decode_cyc
         );         
         
   U4_MEM:
   tsls_wb_bmram
      Generic Map (
         g_array_sz     => c_u3_bmram_sz,
         g_tech_lib     => c_tech_lib
         )
      Port Map (
         i_clk       => s_u1_clk_125,
         i_rst_n     => s_u1_rst_cdc_n,
         
         i_wb_adr    => s_u1_wbm_adr,
         i_wb_bte    => s_u1_wbm_bte, 
         i_wb_cti    => s_u1_wbm_cti,
         i_wb_cyc    => s_u1_wbm_cyc(0),
         i_wb_dat    => s_u1_wbm_dat,
         i_wb_lock   => c_tie_low,
         i_wb_sel    => s_u1_wbm_sel,
         i_wb_stb    => s_u1_wbm_stb,
         i_wb_we     => s_u1_wbm_we,
            
         o_wb_ack    => s_u4_wbm_ack,      
         o_wb_dat    => s_u4_wbm_dat
         );         
         
   U5_MEM:
   tsls_wb_bmram
      Generic Map (
         g_array_sz     => c_u4_bmram_sz,
         g_tech_lib     => c_tech_lib
         )
      Port Map (
         i_clk       => s_u1_clk_125,
         i_rst_n     => s_u1_rst_cdc_n,
         
         i_wb_adr    => s_u1_wbm_adr,
         i_wb_bte    => s_u1_wbm_bte, 
         i_wb_cti    => s_u1_wbm_cti,
         i_wb_cyc    => s_u1_wbm_cyc(1),
         i_wb_dat    => s_u1_wbm_dat,
         i_wb_lock   => c_tie_low,
         i_wb_sel    => s_u1_wbm_sel,
         i_wb_stb    => s_u1_wbm_stb,
         i_wb_we     => s_u1_wbm_we,
            
         o_wb_ack    => s_u5_wbm_ack,      
         o_wb_dat    => s_u5_wbm_dat
         );             
End Rtl;
