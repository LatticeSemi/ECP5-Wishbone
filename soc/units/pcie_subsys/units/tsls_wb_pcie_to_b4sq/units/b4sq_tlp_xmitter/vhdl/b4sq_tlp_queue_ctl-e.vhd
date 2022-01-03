
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
-- File ID     : $Id: b4sq_tlp_queue_ctl-e.vhd 3846 2017-12-27 17:42:58Z  $
-- Generated   : $LastChangedDate: 2017-12-27 18:42:58 +0100 (Wed, 27 Dec 2017) $
-- Revision    : $LastChangedRevision: 3846 $
--
--------------------------------------------------------------------------------
--
-- Description : Control unit for TLP ordering Queue 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity b4sq_tlp_queue_ctl is
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
End b4sq_tlp_queue_ctl;
