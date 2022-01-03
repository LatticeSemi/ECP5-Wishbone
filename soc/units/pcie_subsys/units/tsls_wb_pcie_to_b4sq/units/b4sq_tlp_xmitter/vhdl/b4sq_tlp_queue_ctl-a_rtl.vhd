
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
-- File ID     : $Id: b4sq_tlp_queue_ctl-a_rtl.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Control unit for TLP ordering Queue
--
--------------------------------------------------------------------------------

Use WORK.b4sq_tlp_xmitter_globals.all;

Architecture Rtl of b4sq_tlp_queue_ctl is
   signal s_txq_ack_cplx      : std_logic;
   signal s_txq_ack_np        : std_logic;
   signal s_txq_ack_p         : std_logic;
   signal s_txq_push          : std_logic;
   signal s_txq_wdat          : std_logic_vector(1 downto 0);
   
Begin
   o_txq_ack_cplx    <= s_txq_ack_cplx;
   o_txq_ack_np      <= s_txq_ack_np;
   o_txq_ack_p       <= s_txq_ack_p;
   o_txq_push        <= s_txq_push;
   o_txq_wdat        <= s_txq_wdat;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_MAIN:
   process (i_clk, i_rst_n)
   begin
      if (i_rst_n = '0') then
         s_txq_ack_cplx    <= '1';
         s_txq_ack_np      <= '0';
         s_txq_ack_p       <= '0';
         s_txq_push        <= '0';
         s_txq_wdat        <= (others => '0');
               
      elsif (rising_edge(i_clk)) then
         s_txq_ack_cplx    <= i_txq_push_cplx and not i_txq_push_p and not (s_txq_push or i_txq_full);
         s_txq_ack_np      <= i_txq_push_np and not i_txq_push_cplx and not i_txq_push_p and not (s_txq_push or i_txq_full);
         s_txq_ack_p       <= i_txq_push_p and not (s_txq_push or i_txq_full);

         s_txq_push        <= (i_txq_push_p or i_txq_push_cplx or i_txq_push_np) and not (i_txq_full or s_txq_push);

         if (i_txq_push_p = '1') then
            s_txq_wdat  <= c_tlp_id_p;
         else
            if (i_txq_push_cplx = '1') then
               s_txq_wdat  <= c_tlp_id_cplx;
            else
               s_txq_wdat  <= c_tlp_id_np;            
            end if;
         end if;
      end if;
   end process;
End Rtl;
