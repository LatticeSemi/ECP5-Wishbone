
--
--    Copyright Ingenieurbuero Gardiner, 2007 - 2014
--
--    All Rights Reserved
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
-- File ID     : $Id: b4sq_pkt_rx_fifo-a_rtl.vhd 4311 2018-06-18 01:14:22Z  $
-- Generated   : $LastChangedDate: 2018-06-18 03:14:22 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4311 $
--
--------------------------------------------------------------------------------
--
-- Description : Accepts packets from Lattice PCIe core and forwards these to
--               32-bit bus for further processing
--
--------------------------------------------------------------------------------

Library PMI_WORK;
Use PMI_WORK.all;
Use WORK.b4sq_pkt_rx_fifo_comps.all;

Architecture Rtl of b4sq_pkt_rx_fifo is
   signal s_rtl_mem_din          : std_logic_vector(35 downto 0);
   signal s_rtl_rst              : std_logic;
   signal s_u1_mem_rd_adr        : std_logic_vector(f_vec_msb(g_mem_words - 1) downto 0);
   signal s_u1_mem_wr_adr        : std_logic_vector(f_vec_msb(g_mem_words - 1) downto 0);
   signal s_u1_mem_wr_en         : std_logic;
   signal s_u1_rd_aempty         : std_logic;
   signal s_u1_rd_count          : std_logic_vector(o_rx_count'length - 1  downto 0);
   signal s_u1_rd_empty          : std_logic;
   signal s_u1_rd_en             : std_logic;
   signal s_u2_cpld_rx_data      : std_logic_vector(31 downto 0);
   signal s_u2_cpld_rx_push      : std_logic;
   signal s_u2_cpld_rx_sta_err   : std_logic;
   signal s_u2_cpld_rx_tag       : std_logic_vector(o_cpld_rx_tag'length - 1 downto 0);
   signal s_u2_data              : std_logic_vector(31 downto 0);
   signal s_u2_push              : std_logic;
   signal s_u2_rx_bar_hit        : std_logic_vector(2 downto 0);
   signal s_u2_rx_sof            : std_logic;
   signal s_u3_mem_dout          : std_logic_vector(35 downto 0);

   Component pmi_ram_dp is
      Generic (
         pmi_wr_addr_depth    : integer := 512;
         pmi_wr_addr_width    : integer := 9;
         pmi_wr_data_width    : integer := 18;
         pmi_rd_addr_depth    : integer := 512;
         pmi_rd_addr_width    : integer := 9;
         pmi_rd_data_width    : integer := 18;
         pmi_regmode          : string := "reg";
         pmi_gsr              : string := "disable";
         pmi_resetmode        : string := "sync";
         pmi_optimization     : string := "speed";
         pmi_init_file        : string := "none";
         pmi_init_file_format : string := "binary";
         pmi_family           : string := "EC";
         module_type          : string := "pmi_ram_dp"
         );
      Port (
         Data        : in std_logic_vector((pmi_wr_data_width-1) downto 0);
         RdAddress   : in std_logic_vector((pmi_rd_addr_width-1) downto 0);
         RdClockEn   : in std_logic;
         RdClock     : in std_logic;
         Reset       : in std_logic;
         WE          : in std_logic;
         WrAddress   : in std_logic_vector((pmi_wr_addr_width-1) downto 0);
         WrClockEn   : in std_logic;
         WrClock     : in std_logic;
         Q           : out std_logic_vector((pmi_rd_data_width-1) downto 0)
         );
   End Component pmi_ram_dp;
      
Begin
   o_cpld_rx_data       <= s_u2_cpld_rx_data;
   o_cpld_rx_push       <= s_u2_cpld_rx_push;
   o_cpld_rx_sta_err    <= s_u2_cpld_rx_sta_err;
   o_cpld_rx_tag        <= s_u2_cpld_rx_tag;
         
   o_rx_aempty          <= s_u1_rd_aempty;
   o_rx_bar_hit         <= s_u3_mem_dout(34 downto 32);
   o_rx_data            <= s_u3_mem_dout(31 downto 0);
   o_rx_count           <= s_u1_rd_count;
   o_rx_empty           <= s_u1_rd_empty;
   o_rx_sof             <= s_u3_mem_dout(35);

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_rtl_mem_din  <= s_u2_rx_sof & s_u2_rx_bar_hit & s_u2_data;
   s_rtl_rst      <= not i_rst_n;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~         
   U1_CTL:
   tspc_fifo_ctl_sync
      Generic Map (
         g_rd_latency         => 2,
         g_mem_words          => g_mem_words,
         g_wr_latency         => 1
         )
      Port Map (
         i_rst_n        => i_rst_n,
         i_clk          => i_clk,
         i_clk_en       => c_tie_high,
         i_clr          => c_tie_low,
         
         i_rd_en        => i_rx_pop,
         i_wr_en        => s_u2_push,

         o_rd_adr       => s_u1_mem_rd_adr,
         o_rd_aempty    => s_u1_rd_aempty,
         o_rd_count     => s_u1_rd_count,
         o_rd_empty     => s_u1_rd_empty,
         o_rd_en        => s_u1_rd_en,
         o_rd_last      => open,
         o_wr_adr       => s_u1_mem_wr_adr,
         o_wr_afull     => open,
         o_wr_free      => open,
         o_wr_en        => s_u1_mem_wr_en,
         o_wr_full      => open,
         o_wr_last      => open
         );

   U2_ISTG:
   b4sq_pkt_rx_fifo_istage
      Port Map (
         i_clk                => i_clk,
         i_rst_n              => i_rst_n,

         i_dl_up              => i_dl_up,
         i_rx_bar_hit         => i_rx_bar_hit,
         i_rx_data            => i_rx_data,
         i_rx_end             => i_rx_end,
         i_rx_st              => i_rx_st,

         o_cpld_rx_data       => s_u2_cpld_rx_data,
         o_cpld_rx_push       => s_u2_cpld_rx_push,
         o_cpld_rx_sta_err    => s_u2_cpld_rx_sta_err,
         o_cpld_rx_tag        => s_u2_cpld_rx_tag,
         o_rx_bar_hit         => s_u2_rx_bar_hit,
         o_rx_data            => s_u2_data,
         o_rx_push            => s_u2_push,
         o_rx_sof             => s_u2_rx_sof
         );

   U3_MEM:
   pmi_ram_dp
      Generic Map (
         pmi_wr_addr_depth    => g_mem_words,
         pmi_wr_addr_width    => s_u1_mem_wr_adr'length,
         pmi_wr_data_width    => 36,
         pmi_rd_addr_depth    => g_mem_words,
         pmi_rd_addr_width    => s_u1_mem_rd_adr'length,
         pmi_rd_data_width    => 36,
         pmi_regmode          => "reg",
         pmi_family           => g_tech_lib
         )
      Port Map (
         Data        => s_rtl_mem_din,
         RdAddress   => s_u1_mem_rd_adr,
         RdClockEn   => s_u1_rd_en,
         RdClock     => i_clk,
         Reset       => s_rtl_rst,
         WE          => s_u1_mem_wr_en,
         WrAddress   => s_u1_mem_wr_adr,
         WrClockEn   => c_tie_high,
         WrClock     => i_clk,
         Q           => s_u3_mem_dout
         );
End Rtl;
