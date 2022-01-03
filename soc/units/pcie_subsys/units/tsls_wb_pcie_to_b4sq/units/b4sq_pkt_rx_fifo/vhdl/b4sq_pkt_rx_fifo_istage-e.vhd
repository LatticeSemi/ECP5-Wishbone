
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
-- File ID     : $Id: b4sq_pkt_rx_fifo_istage-e.vhd 3881 2018-01-05 16:50:29Z  $
-- Generated   : $LastChangedDate: 2018-01-05 17:50:29 +0100 (Fri, 05 Jan 2018) $
-- Revision    : $LastChangedRevision: 3881 $
--
--------------------------------------------------------------------------------
--
-- Description : Accepts packets from Lattice PCIe core and forwards these to
--               32-bit bus for further processing
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity b4sq_pkt_rx_fifo_istage is
   Port (
      i_clk                : in  std_logic;
      i_rst_n              : in  std_logic;

      i_dl_up              : in  std_logic;
      i_rx_bar_hit         : in  std_logic_vector(6 downto 0);
      i_rx_data            : in  std_logic_vector(15 downto 0);
      i_rx_end             : in  std_logic;
      i_rx_st              : in  std_logic;

      o_cpld_rx_data       : out std_logic_vector(31 downto 0);
      o_cpld_rx_push       : out std_logic;
      o_cpld_rx_sta_err    : out std_logic;
      o_cpld_rx_tag        : out std_logic_vector(7 downto 0);
      o_rx_bar_hit         : out std_logic_vector(2 downto 0);      
      o_rx_data            : out std_logic_vector(31 downto 0);
      o_rx_push            : out std_logic;
      o_rx_sof             : out std_logic      
      );
End b4sq_pkt_rx_fifo_istage;
