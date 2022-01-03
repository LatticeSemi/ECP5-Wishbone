
--
--    Copyright Ing. Buero Gardiner 2008 - 2012
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_rtc-e.vhd 4977 2019-10-18 18:18:15Z  $
-- Generated   : $LastChangedDate: 2019-10-18 20:18:15 +0200 (Fri, 18 Oct 2019) $
-- Revision    : $LastChangedRevision: 4977 $
--
--------------------------------------------------------------------------------
--
-- Description :
--       Default: Counts ms, runs on 125 MHz clock
--
-- constant c_rtc_res_1s      : natural := 16#773_5940#;
-- constant c_rtc_res_100ms   : natural := 16#be_bc20#;
-- constant c_rtc_res_10ms    : natural := 16#13_12d0#;
-- constant c_rtc_res_1ms     : natural := 16#01_e848#;
-- constant c_rtc_res_100us   : natural := 16#00_30d4#;
-- constant c_rtc_res_10us    : natural := 16#00_04e2#;
-- constant c_rtc_res_1us     : natural := 16#00_007d#;
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity tspc_rtc is
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
End tspc_rtc;
