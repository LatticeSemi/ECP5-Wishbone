
--
--    Copyright Ingenieurbuero Gardiner, 2013 - 2014
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
-- File ID     : $Id: tspc_fifo_sync_mem-a_rtl.vhd 4196 2018-05-22 13:08:18Z  $
-- Generated   : $LastChangedDate: 2018-05-22 15:08:18 +0200 (Tue, 22 May 2018) $
-- Revision    : $LastChangedRevision: 4196 $
--
--------------------------------------------------------------------------------
--
-- Description : Memory Wrapper for Lattice PMI Memories
--
--------------------------------------------------------------------------------

Library IEEE;
Library PMI_WORK;

Use IEEE.numeric_std.all;
Use PMI_WORK.all;

Architecture Rtl of tspc_fifo_sync_mem is
   constant c_tie_high  : std_logic := '1';
   
   signal s_reset       : std_logic;
   signal s_u1_q        : std_logic_vector(i_wr_din'length - 1 downto 0);

   Component pmi_distributed_dpram is
      Generic (
         pmi_addr_depth       : integer := 32; 
         pmi_addr_width       : integer := 5;                   
         pmi_data_width       : integer := 8;                   
         pmi_regmode          : string := "reg";                   
         pmi_init_file        : string := "none";                
         pmi_init_file_format : string := "binary";       
         pmi_family           : string := "EC";                     
         module_type          : string := "pmi_distributed_dpram"  
         );
      Port (
         Data        : in std_logic_vector((pmi_data_width-1) downto 0);
         RdAddress   : in std_logic_vector((pmi_addr_width-1) downto 0);
         RdClockEn   : in std_logic;
         RdClock     : in std_logic;
         Reset       : in std_logic;
         WE          : in std_logic;
         WrAddress   : in std_logic_vector((pmi_addr_width-1) downto 0);
         WrClockEn   : in std_logic;
         WrClock     : in std_logic;
         Q           : out std_logic_vector((pmi_data_width-1) downto 0)
         );
  End Component pmi_distributed_dpram;
  
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
   o_rd_dout   <= std_logic_vector(resize(unsigned(s_u1_q), o_rd_dout'length ));

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_reset     <= not i_rst_n;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   U1_DSRAM:
   if g_mem_dmram  generate
      U_RAM:   
      pmi_distributed_dpram
         Generic Map (
            pmi_addr_depth    => g_mem_words,
            pmi_addr_width    => i_wr_adr'length,
            pmi_data_width    => o_rd_dout'length,
            pmi_regmode       => "reg",
            pmi_family        => g_tech_lib 
            )
         Port Map (
            Data        => i_wr_din,
            RdAddress   => i_rd_adr,
            RdClockEn   => i_rd_clk_en,
            RdClock     => i_clk,
            Reset       => s_reset,
            WE          => i_wr_en,
            WrAddress   => i_wr_adr,
            WrClockEn   => i_wr_clk_en,
            WrClock     => i_clk,
            Q           => s_u1_q
            );
   end generate;
   
   
   U1_BMRAM:
   if not g_mem_dmram generate
      U_RAM:   
      pmi_ram_dp
         Generic Map (
            pmi_wr_addr_depth    => g_mem_words,
            pmi_wr_addr_width    => i_wr_adr'length,
            pmi_wr_data_width    => i_wr_din'length, 
            pmi_rd_addr_depth    => g_mem_words,
            pmi_rd_addr_width    => i_rd_adr'length,
            pmi_rd_data_width    => i_wr_din'length, 
            pmi_regmode          => "noreg", 
            pmi_family           => g_tech_lib 
            )
         Port Map (
            Data        => i_wr_din,
            RdAddress   => i_rd_adr,
            RdClockEn   => i_rd_clk_en,
            RdClock     => i_clk,
            Reset       => s_reset,
            WE          => i_wr_en,
            WrAddress   => i_wr_adr,
            WrClockEn   => i_wr_clk_en,
            WrClock     => i_clk,
            Q           => s_u1_q
            );
   end generate;   
End Rtl;
