
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
-- File ID     : $Id: tsls_wb_bmram-a_rtl.vhd 4284 2018-06-17 22:40:47Z  $
-- Generated   : $LastChangedDate: 2018-06-18 00:40:47 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4284 $
--
--------------------------------------------------------------------------------
--
-- Description : Wishbone Interface around Lattice PMI memory
--
--------------------------------------------------------------------------------

Library PMI_WORK;

Use PMI_WORK.all;
Use WORK.tspc_utils.all;

Architecture Rtl of tsls_wb_bmram is
   attribute syn_black_box : boolean;

   constant c_addr_width   : positive := f_vec_size(g_array_sz - 1);
   constant c_data_sz      : positive := g_char_sz * g_word_sz;
   constant c_rd_pipe_sz   : natural := 3;
      
   signal s_rtl_rst        : std_logic;
   signal s_u1_ram_addr    : std_logic_vector(c_addr_width - 1 downto 0);
   signal s_u1_ram_be      : std_logic_vector(g_word_sz - 1 downto 0);
   signal s_u1_ram_wdat    : std_logic_vector(c_data_sz - 1 downto 0);
   signal s_u1_ram_we      : std_logic;
   signal s_u2_q           : std_logic_vector(c_data_sz - 1 downto 0);

   Component pmi_ram_dq_be
      Generic (
         pmi_addr_depth       : integer := 512; 
         pmi_addr_width       : integer := 9; 
         pmi_data_width       : integer := 18; 
         pmi_regmode          : string := "reg"; 
         pmi_gsr              : string := "disable"; 
         pmi_resetmode        : string := "sync"; 
         pmi_optimization     : string := "speed";
         pmi_init_file        : string := "none"; 
         pmi_init_file_format : string := "binary"; 
         pmi_write_mode       : string := "normal"; 
         pmi_byte_size        : integer := 9;
         pmi_family           : string := "ECP2"; 
         module_type          : string := "pmi_ram_dq_be" 
         );
      Port (
         Data     : in std_logic_vector((pmi_data_width-1) downto 0);
         Address  : in std_logic_vector((pmi_addr_width-1) downto 0);
         Clock    : in std_logic;
         ClockEn  : in std_logic;
         WE       : in std_logic;
         Reset    : in std_logic;
         ByteEn   : in std_logic_vector(((pmi_data_width+pmi_byte_size-1)/pmi_byte_size-1) downto 0);
         Q        : out std_logic_vector((pmi_data_width-1) downto 0)
         );
   End Component;

  component pmi_ram_dp_true_be is
     generic (
       pmi_addr_depth_a : integer := 512; 
       pmi_addr_width_a : integer := 9; 
       pmi_data_width_a : integer := 18; 
       pmi_addr_depth_b : integer := 512; 
       pmi_addr_width_b : integer := 9; 
       pmi_data_width_b : integer := 18; 
       pmi_regmode_a : string := "reg"; 
       pmi_regmode_b : string := "reg"; 
       pmi_gsr : string := "disable"; 
       pmi_resetmode : string := "sync"; 
       pmi_optimization : string := "speed";
       pmi_init_file : string := "none"; 
       pmi_init_file_format : string := "binary"; 
       pmi_write_mode_a : string := "normal"; 
       pmi_write_mode_b : string := "normal"; 
       pmi_byte_size : integer := 9;
       pmi_family : string := "ECP2"; 
       module_type : string := "pmi_ram_dp_true_be" 
    );
    port (
     DataInA : in std_logic_vector((pmi_data_width_a-1) downto 0);
     DataInB : in std_logic_vector((pmi_data_width_b-1) downto 0);
     AddressA : in std_logic_vector((pmi_addr_width_a-1) downto 0);
     AddressB : in std_logic_vector((pmi_addr_width_b-1) downto 0);
     ClockA: in std_logic;
     ClockB: in std_logic;
     ClockEnA: in std_logic;
     ClockEnB: in std_logic;
     WrA: in std_logic;
     WrB: in std_logic;
     ResetA: in std_logic;
     ResetB: in std_logic;
     ByteEnA : in std_logic_vector(((pmi_data_width_a+pmi_byte_size-1)/pmi_byte_size-1) downto 0);
     ByteEnB : in std_logic_vector(((pmi_data_width_b+pmi_byte_size-1)/pmi_byte_size-1) downto 0);
     QA : out std_logic_vector((pmi_data_width_a-1) downto 0);
     QB : out std_logic_vector((pmi_data_width_b-1) downto 0)
   );
  end component pmi_ram_dp_true_be;


   Component tspc_wb_ebr_ctl
      Generic (
         g_array_sz     : positive;
         g_char_sz      : positive := 8;    
         g_rd_pipe_sz   : natural;
         g_word_sz      : positive := 4
         );
      Port (
         i_rst_n     : in  std_logic;
         i_clk       : in  std_logic;

         i_ram_dq    : in  std_logic_vector;
         i_ram_err   : in  std_logic := '0';
         i_ram_rty   : in  std_logic := '0';
         i_wb_adr    : in  std_logic_vector;
         i_wb_bte    : in  std_logic_vector(1 downto 0); 
         i_wb_cti    : in  std_logic_vector(2 downto 0);
         i_wb_cyc    : in  std_logic;
         i_wb_wdat   : in  std_logic_vector;
         i_wb_lock   : in  std_logic := '0';
         i_wb_sel    : in  std_logic_vector;
         i_wb_stb    : in  std_logic;
         i_wb_we     : in  std_logic;

         o_ram_addr  : out std_logic_vector;
         o_ram_be    : out std_logic_vector;
         o_ram_wdat  : out std_logic_vector;
         o_ram_we    : out std_logic;
         o_wb_ack    : out std_logic;
         o_wb_err    : out std_logic;
         o_wb_rdat   : out std_logic_vector;
         o_wb_rty    : out std_logic   
         );
   End Component;
   
Begin
   s_rtl_rst   <= not i_rst_n;
   
   U1_MCTL:
   tspc_wb_ebr_ctl
      Generic Map (
         g_array_sz     => g_array_sz,
         g_char_sz      => g_char_sz,
         g_rd_pipe_sz   => c_rd_pipe_sz,
         g_word_sz      => g_word_sz
         )
      Port Map(
         i_rst_n     => i_rst_n,
         i_clk       => i_clk,

         i_ram_dq    => s_u2_q,
         i_wb_adr    => i_wb_adr,
         i_wb_bte    => i_wb_bte,
         i_wb_cti    => i_wb_cti,
         i_wb_cyc    => i_wb_cyc,
         i_wb_wdat   => i_wb_dat,
         i_wb_lock   => i_wb_lock,
         i_wb_sel    => i_wb_sel,
         i_wb_stb    => i_wb_stb,
         i_wb_we     => i_wb_we,

         o_ram_addr  => s_u1_ram_addr,
         o_ram_be    => s_u1_ram_be,
         o_ram_wdat  => s_u1_ram_wdat,
         o_ram_we    => s_u1_ram_we,
         o_wb_ack    => o_wb_ack,
         o_wb_err    => open,
         o_wb_rdat   => o_wb_dat,
         o_wb_rty    => open
         );

   U2_MEM:
   pmi_ram_dp_true_be
      Generic Map (
         pmi_addr_depth_a  => g_array_sz,
         pmi_addr_depth_b  => g_array_sz,
         pmi_addr_width_a  => c_addr_width,
         pmi_addr_width_b  => c_addr_width,
         pmi_byte_size     => g_char_sz,
         pmi_data_width_a  => c_data_sz,
         pmi_data_width_b  => c_data_sz,
         pmi_family        => g_tech_lib,
         pmi_gsr           => "enable"
         )
      Port Map (
         ClockA      => i_clk,
         ClockEnA    => c_tie_high,
         ResetA      => s_rtl_rst,
         AddressA    => s_u1_ram_addr, 
         ByteEnA     => s_u1_ram_be,
         DataInA     => s_u1_ram_wdat,
         WrA         => s_u1_ram_we,
         QA          => s_u2_q,

         ClockB      => c_tie_low,
         ClockEnB    => c_tie_low,
         ResetB      => c_tie_low,
         AddressB    => s_u1_ram_addr, 
         ByteEnB     => s_u1_ram_be,
         DataInB     => s_u1_ram_wdat,
         WrB         => s_u1_ram_we,
         QB          => open
         );
       
       -- Simulation Model seems Broken  
-- U2_MEM:
-- pmi_ram_dq_be
--    Generic Map (
--       pmi_addr_depth    => g_array_sz,
--       pmi_addr_width    => c_addr_width,
--       pmi_byte_size     => g_char_sz,
--       pmi_data_width    => c_data_sz,
--       pmi_family        => g_tech_lib,
--       pmi_gsr           => "enable"
--       )
--    Port Map (
--       Clock    => i_clk,
--       ClockEn  => c_tie_high,
--       Reset    => s_rtl_rst,
--       Address  => s_rtl_ram_addr, 
--       ByteEn   => s_rtl_ram_be,
--       Data     => s_rtl_ram_wdat,
--       WE       => s_rtl_ram_we,
--       Q        => s_u2_q
--       );
End Rtl;
