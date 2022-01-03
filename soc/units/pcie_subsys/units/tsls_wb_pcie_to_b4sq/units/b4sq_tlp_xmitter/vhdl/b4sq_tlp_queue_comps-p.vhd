
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
-- File ID     : $Id: b4sq_tlp_queue_comps-p.vhd 4263 2018-06-17 22:01:35Z  $
-- Generated   : $LastChangedDate: 2018-06-18 00:01:35 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4263 $
--
--------------------------------------------------------------------------------
--
-- Description : Tracks ordering in which PCIe posted/non-posted and completion
--               transactions were received from enclosing super-structure
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;
Use WORK.tspc_utils.all;

Package b4sq_tlp_queue_comps is
   Component b4sq_tlp_queue_ctl
      Port (
         i_clk             : in  std_logic;
         i_rst_n           : in  std_logic;

         i_txq_full        : in  std_logic;
         i_txq_push_cplx   : in  std_logic;
         i_txq_push_np     : in  std_logic;
         i_txq_push_p      : in  std_logic;

         o_txq_ack_cplx    : out std_logic;
         o_txq_ack_np      : out std_logic;
         o_txq_ack_p       : out std_logic;
         o_txq_wdat        : out std_logic_vector(1 downto 0);
         o_txq_push        : out std_logic
         );
   End Component;


   Component tspc_fifo_sync
      Generic (
         g_mem_dmram    : boolean := false;
         g_mem_words    : positive := 256;
         g_tech_lib     : string := "ECP3";
         g_threshold_rd : positive := 1;
         g_threshold_wr : positive := 1         
         );
      Port (
         i_clk          : in  std_logic;
         i_rst_n        : in  std_logic;
         i_clr          : in  std_logic := '0';

         i_rd_pop       : in  std_logic;
         i_wr_din       : in  std_logic_vector;
         i_wr_push      : in  std_logic;

         o_rd_aempty    : out std_logic;
         o_rd_count     : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
         o_rd_dout      : out std_logic_vector;
         o_rd_empty     : out std_logic;
         o_rd_last      : out std_logic;
         o_wr_afull     : out std_logic;
         o_wr_free      : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
         o_wr_full      : out std_logic;
         o_wr_last      : out std_logic
         );
   End Component;
End b4sq_tlp_queue_comps;
