
--
--    
--    Copyright Ingenieurbuero Gardiner, 2014 - 2020
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_rst_gen_yog4-e.vhd 5262 2021-01-23 09:51:13Z  $
-- Generated   : $LastChangedDate: 2021-01-23 10:51:13 +0100 (Sat, 23 Jan 2021) $
-- Revision    : $LastChangedRevision: 5262 $
--
--------------------------------------------------------------------------------
--
-- Description : Autonomous reset generator
--
--    Generates a reset sequence when an external reset is not available or not suitable.
--    Core is a 2-cell (32-bit Words) distributed RAM which is intialised
--    during bit-stream load and therefore contains a known start combination.
--
--    Only the lowest address is used (adr0).
--       Bits 31:28  : FSM -> must be initialised to zero
--       Bits 27:0   : Number of clock cycles to hold the reset active after
--                     the FPGA has been configured (switches to user mode)
--
--    Example :   tspc_rst_gen_yog4 configured for 1 ms reset pulse from a 2.5 MHz 
--                external clock
--       g_rst_count := 16#9C4#
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity tspc_rst_gen_yog4 is
   Generic (
      g_rst_count    : positive := 16#9C4#
      );
   Port (
      i_clk       : in  std_logic;
      i_trip_ev   : in  std_logic;
      
      o_rst_n     : out std_logic
      );
End tspc_rst_gen_yog4;
