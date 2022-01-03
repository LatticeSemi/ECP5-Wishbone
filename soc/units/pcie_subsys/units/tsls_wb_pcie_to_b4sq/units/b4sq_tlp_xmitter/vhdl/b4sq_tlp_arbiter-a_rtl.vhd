
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
-- File ID     : $Id: b4sq_tlp_arbiter-a_rtl.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Arbitrates between Completion FIFO, Posted FIFO and non-posted FIFO
--               for access to Lattice PCIe core
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.b4sq_tlp_xmitter_globals.all;
Use WORK.tspc_pcisig_types.all;
Use WORK.tspc_utils.all;

Architecture Rtl of b4sq_tlp_arbiter is
   type t_xarb_fsm is (XA_IDLE,
                       XA_TXQ_GET, XA_TXQ_DECODE, XA_TXQ_WT_CA,
                       XA_IPX_REQ, XA_IPX_INIT, XA_IPX_HDRH, XA_IPX_HDRL, XA_IPX_PLOADH, XA_IPX_PLOADL);

   constant c_hdr_count_3  : std_logic_vector(1 downto 0) := "10";
   constant c_hdr_count_4  : std_logic_vector(1 downto 0) := "11";
                       
   signal s_ca_cpld           : std_logic_vector(12 downto 0);
   signal s_ca_pd             : std_logic_vector(12 downto 0);                       
   signal s_cr_ok             : std_logic;
   signal s_has_pload         : std_logic;
   signal s_hdr_4dw           : std_logic;
   signal s_hdr_count         : std_logic_vector(1 downto 0);
   signal s_ipx_data          : std_logic_vector(15 downto 0);
   signal s_ipx_end           : std_logic;
   signal s_ipx_start         : std_logic;
   signal s_pload_count       : std_logic_vector(10 downto 0);
   signal s_pload_ok_cpl      : std_logic;
   signal s_pload_ok_p        : std_logic;
   signal s_req_recheck       : std_logic;
   signal s_tlp_data          : std_logic_vector(31 downto 0);
   signal s_tlp_data_cpl      : std_logic_vector(31 downto 0);
   signal s_tlp_data_np       : std_logic_vector(31 downto 0);
   signal s_tlp_data_p        : std_logic_vector(31 downto 0);
   signal s_tlp_length        : std_logic_vector(9 downto 0);
   signal s_tlp_length_cpl    : std_logic_vector(9 downto 0);
   signal s_tlp_length_p      : std_logic_vector(9 downto 0);
   signal s_tlp_pop_cpl       : std_logic;
   signal s_tlp_pop_np        : std_logic;
   signal s_tlp_pop_p         : std_logic;
   signal s_tlp_rdy_cpl       : std_logic;
   signal s_tlp_rdy_np        : std_logic;
   signal s_tlp_rdy_p         : std_logic;
   signal s_txq_data          : std_logic_vector(1 downto 0);
   signal s_xarb_fsm          : t_xarb_fsm;
   signal s_xarb_fsm_next     : t_xarb_fsm;
   
Begin
   o_ipx_data        <= s_ipx_data;
   o_ipx_end         <= s_ipx_end;
   o_ipx_req         <= f_to_logic(s_xarb_fsm = XA_IPX_REQ);
   o_ipx_start       <= s_ipx_start;

   o_tlp_pop_cpl     <= s_tlp_pop_cpl;
   o_tlp_pop_np      <= s_tlp_pop_np;
   o_tlp_pop_p       <= s_tlp_pop_p;

   o_txq_pop         <= f_to_logic(s_xarb_fsm = XA_TXQ_GET);
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_tlp_length      <= s_tlp_data(9 downto 0);
   s_tlp_length_cpl  <= s_tlp_data_cpl(9 downto 0);
   s_tlp_length_p    <= s_tlp_data_p(9 downto 0);
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_FSM:
   process (all)
   begin
      s_xarb_fsm_next   <= s_xarb_fsm;

      case s_xarb_fsm is
         when XA_IDLE =>
            if ((i_txq_empty = '0') and (i_dl_up = '1')) then
               s_xarb_fsm_next   <= XA_TXQ_GET;
            end if;

         when XA_TXQ_GET =>
            s_xarb_fsm_next   <= XA_TXQ_DECODE;

         when XA_TXQ_DECODE =>
            s_xarb_fsm_next   <= XA_TXQ_WT_CA;

         when XA_TXQ_WT_CA =>
            if (s_cr_ok = '1') then
               s_xarb_fsm_next   <= XA_IPX_REQ;
            end if;

         when XA_IPX_REQ =>
            if (s_req_recheck = '1') then
               s_xarb_fsm_next   <= XA_TXQ_DECODE;            
            elsif (i_ipx_rdy = '1') then
               s_xarb_fsm_next   <= XA_IPX_INIT;
            end if;

         when XA_IPX_INIT =>
            s_xarb_fsm_next   <= XA_IPX_HDRH;

         when XA_IPX_HDRH =>
            s_xarb_fsm_next   <= XA_IPX_HDRL;

         when XA_IPX_HDRL =>
            if (unsigned(s_hdr_count) /= 0) then
               s_xarb_fsm_next   <= XA_IPX_HDRH;
            else
               if (s_has_pload = '1') then
                  s_xarb_fsm_next   <= XA_IPX_PLOADH;
               else
                  s_xarb_fsm_next   <= XA_IDLE;
               end if;
            end if;

         when XA_IPX_PLOADH =>
            s_xarb_fsm_next   <= XA_IPX_PLOADL;

         when XA_IPX_PLOADL =>
            if (unsigned(s_pload_count) > 1) then
               s_xarb_fsm_next   <= XA_IPX_PLOADH;
            else
               s_xarb_fsm_next   <= XA_IDLE;
            end if;
         when others =>
      end case;
   end process;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_DMUX:
   process(all)
   begin
      case s_txq_data is
         when c_tlp_id_cplx =>
            s_req_recheck  <= i_fc_cpl_recheck;
            s_tlp_data     <= s_tlp_data_cpl;

         when c_tlp_id_np =>
            s_req_recheck  <= '0';
            s_tlp_data     <= s_tlp_data_np;

         when c_tlp_id_p =>
            s_req_recheck  <= i_fc_p_recheck;
            s_tlp_data     <= s_tlp_data_p;
            
         when others =>
            s_req_recheck  <= '0';
            s_tlp_data     <= (others => '0');
      end case;
   end process;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_MAIN:
   process (i_clk, i_rst_n)
   begin
      if (i_rst_n = '0') then
         s_ca_cpld         <= (others => '0');
         s_ca_pd           <= (others => '0');
         s_cr_ok           <= '0';
         s_has_pload       <= '0';
         s_hdr_4dw         <= '0';
         s_hdr_count       <= (others => '0');
         s_ipx_data        <= (others => '0');
         s_ipx_end         <= '0';
         s_ipx_start       <= '0';
         s_tlp_data_cpl    <= (others => '0');
         s_tlp_data_np     <= (others => '0');
         s_tlp_data_p      <= (others => '0');
         s_tlp_pop_cpl     <= '0';
         s_tlp_pop_np      <= '0';
         s_tlp_pop_p       <= '0';
         s_tlp_rdy_cpl     <= '0';
         s_tlp_rdy_np      <= '0';
         s_tlp_rdy_p       <= '0';
         s_pload_count     <= (others => '0');
         s_pload_ok_cpl    <= '0';
         s_pload_ok_p      <= '0';
         s_txq_data        <= (others => '0');      
         s_xarb_fsm        <= XA_IDLE;
         
      elsif (rising_edge(i_clk)) then
         s_ca_cpld         <= i_ca_cpld;
         s_ca_pd           <= i_ca_pd;

         s_ipx_end         <= '0';
         s_ipx_start       <= '0';

         s_pload_ok_cpl <= f_to_logic(unsigned(s_ca_cpld) > to_01(unsigned(s_tlp_length_cpl(s_tlp_length_cpl'left downto 2)), '0'));
         s_pload_ok_p   <= f_to_logic(unsigned(s_ca_pd)   > to_01(unsigned(s_tlp_length_p(s_tlp_length_p'left downto 2)), '0'));
         
         s_tlp_data_cpl    <= i_tlp_data_cpl;
         s_tlp_data_np     <= i_tlp_data_np;
         s_tlp_data_p      <= i_tlp_data_p;

         s_tlp_pop_cpl     <= '0';
         s_tlp_pop_np      <= '0';
         s_tlp_pop_p       <= '0';

         s_tlp_rdy_cpl     <= not i_tlp_empty_cpl;
         s_tlp_rdy_np      <= not i_tlp_empty_np;
         s_tlp_rdy_p       <= not i_tlp_empty_p;
                                                      
         s_xarb_fsm        <= s_xarb_fsm_next;

            
         case s_xarb_fsm is
            when XA_TXQ_GET   =>
               s_cr_ok     <= '0';
               s_txq_data  <= i_txq_data;

            when XA_TXQ_DECODE =>
               case s_txq_data is
                  when c_tlp_id_cplx =>
                     s_has_pload    <= s_tlp_data(c_bpos_has_payload);
                     s_hdr_4dw      <= '0';
                     
                  when c_tlp_id_np  =>
                     s_has_pload    <= '0';
                     s_hdr_4dw      <= s_tlp_data(c_bpos_hdr_4dw);
                                    
                  when c_tlp_id_p   =>
                     s_has_pload    <= '1';
                     s_hdr_4dw      <= s_tlp_data(c_bpos_hdr_4dw);
                     
                  when others =>
                     s_has_pload    <= '0';
                     s_hdr_4dw      <= '0';
               end case;

            when XA_TXQ_WT_CA =>
               case s_txq_data is
                  when c_tlp_id_cplx =>
                     s_cr_ok  <= f_to_logic(unsigned(i_ca_cplh) /= 0) and (s_pload_ok_cpl or not s_has_pload);
                     
                  when c_tlp_id_np =>
                     s_cr_ok  <= f_to_logic(unsigned(i_ca_nph) /= 0) and i_ctl_bus_mst_en;

                  when c_tlp_id_p =>
                     s_cr_ok  <= f_to_logic(unsigned(i_ca_ph) /= 0) and i_ctl_bus_mst_en and (s_pload_ok_p or not s_has_pload);
                     
                  when others =>
                     s_cr_ok  <= '0';
               end case;

            when XA_IPX_REQ =>
               if (i_ipx_rdy = '1') then
                  s_tlp_pop_cpl  <= f_to_logic(s_txq_data = c_tlp_id_cplx);
                  s_tlp_pop_np   <= f_to_logic(s_txq_data = c_tlp_id_np);
                  s_tlp_pop_p    <= f_to_logic(s_txq_data = c_tlp_id_p);
               end if;

            when XA_IPX_INIT =>
               s_ipx_data     <= s_tlp_data(31 downto 16);
               s_ipx_start    <= '1';
               s_pload_count  <= f_to_logic(unsigned(s_tlp_length) = 0) & s_tlp_length;

               if (s_hdr_4dw = '1') then
                  s_hdr_count <= c_hdr_count_4;
               else
                  s_hdr_count <= c_hdr_count_3;
               end if;
                              
            when XA_IPX_HDRH =>
               s_ipx_data     <= s_tlp_data(15 downto 0);
               s_ipx_end      <= f_to_logic(unsigned(s_hdr_count) = 0) and not s_has_pload;
               
               s_tlp_pop_cpl  <= f_to_logic(s_txq_data = c_tlp_id_cplx) and (f_to_logic(unsigned(s_hdr_count) /= 0) or s_has_pload);
               s_tlp_pop_np   <= f_to_logic(s_txq_data = c_tlp_id_np) and f_to_logic(unsigned(s_hdr_count) /= 0);
               s_tlp_pop_p    <= f_to_logic(s_txq_data = c_tlp_id_p) and (f_to_logic(unsigned(s_hdr_count) /= 0) or s_has_pload);

            when XA_IPX_HDRL =>
               s_hdr_count    <= f_decr(s_hdr_count);
               s_ipx_data     <= s_tlp_data(31 downto 16);

            when XA_IPX_PLOADH =>
               s_ipx_data     <= s_tlp_data(15 downto 0);
               s_ipx_end      <= f_to_logic(unsigned(s_pload_count) = 1);
               s_tlp_pop_cpl  <= f_to_logic(s_txq_data = c_tlp_id_cplx) and f_to_logic(unsigned(s_pload_count) > 1);
               s_tlp_pop_p    <= f_to_logic(s_txq_data = c_tlp_id_p) and f_to_logic(unsigned(s_pload_count) > 1);

            when XA_IPX_PLOADL =>
               s_ipx_data     <= s_tlp_data(31 downto 16);
               s_pload_count  <= f_decr(s_pload_count);
               
            when others =>
         end case;
      end if;
   end process;
End Rtl;
