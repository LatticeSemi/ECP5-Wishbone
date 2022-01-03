
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
-- File ID     : $Id: b4sq_pkt_decode-a_rtl.vhd 4366 2018-07-29 07:23:03Z  $
-- Generated   : $LastChangedDate: 2018-07-29 09:23:03 +0200 (Sun, 29 Jul 2018) $
-- Revision    : $LastChangedRevision: 4366 $
--
--------------------------------------------------------------------------------
--
-- Description : Decodes transaction from Lattice PCIe core
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.tspc_pcisig_types.all;
Use WORK.tspc_utils.all;
Use WORK.tspc_wbone_types.all;

Architecture Rtl of b4sq_pkt_decode is
   type t_pkt_dec_fsm   is (PD_IDLE, PD_FETCH, PD_HDR0, PD_HDR1, PD_HDR2, PD_HDR3,
                            PD_DECODE_WAIT, PD_DECODE_EXEC, PD_PLOAD_WAIT,
                            PD_XFER_START_INIT, PD_XFER_START, PD_PLOAD_RD, PD_PLOAD_RD_FLUSH, PD_PLOAD_WR, PD_PLOAD_WR_WAIT,
                            PD_FC_UPDATE_INIT, PD_FC_UPDATE,
                            PD_UR_CHK_PLOAD, PD_UR_POP,
                            PD_CPL_WT_HDR, PD_CPL_WT_PLOAD,
                            PD_CPL_INIT, PD_CPL_0, PD_CPL_1, PD_CPL_2,
                            PD_TXQ_PUSH,
                            PD_CPLD_INIT, PD_CPLD_PLOAD_START, PD_CPLD_PLOAD, PD_CPLD_STA);

   constant c_dec_wt_count       : natural := 2;
   constant c_dec_wt_count_sz    : natural := f_vec_size(c_dec_wt_count);
   constant c_dec_wt_count_load  : std_logic_vector(c_dec_wt_count_sz - 1 downto 0) :=
                                             std_logic_vector(to_unsigned(c_dec_wt_count, c_dec_wt_count_sz));
   constant c_wb_adr_sz          : natural    := maximum(13, o_wb_adr'length );
   
   signal s_cc_npd_num           : std_logic_vector(o_cc_npd_num'length - 1 downto 0);
   signal s_cc_pd_num            : std_logic_vector(o_cc_pd_num'length - 1 downto 0);
   signal s_cc_processed_npd     : std_logic;
   signal s_cc_processed_nph     : std_logic;
   signal s_cc_processed_pd      : std_logic;
   signal s_cc_processed_ph      : std_logic;
   signal s_cpld_rx_data         : std_logic_vector(31 downto 0);
   signal s_cpld_rx_push         : std_logic;
   signal s_cpld_rx_sta_err      : std_logic;
   signal s_cpld_rx_tag          : std_logic_vector(7 downto 0);
   signal s_cplx_tx_byte_count   : std_logic_vector(12 downto 0);
   signal s_cplx_tx_data         : std_logic_vector(31 downto 0);
   signal s_cplx_tx_free         : std_logic_vector(i_cplx_tx_free'length - 1 downto 0);
   signal s_cplx_tx_last         : std_logic;
   signal s_cplx_tx_pload_ok     : std_logic;
   signal s_cplx_tx_push         : std_logic;
   signal s_cplx_tx_sta          : std_logic_vector(3 downto 0);
   signal s_cplx_txq_push        : std_logic;
   signal s_dec_bar_hit          : std_logic_vector(6 downto 0);
   signal s_dec_cyc              : std_logic_vector(i_dec_cyc'length - 1 downto 0);
   signal s_dec_cyc_local        : std_logic;
   signal s_dec_wt_count         : std_logic_vector(1 downto 0);
   signal s_pkt_dec_fsm          : t_pkt_dec_fsm;
   signal s_pkt_dec_fsm_next     : t_pkt_dec_fsm;
   signal s_req_adr              : std_logic_vector(7 downto 0);
   signal s_req_bus_nr           : std_logic_vector(7 downto 0);
   signal s_req_dev_nr           : std_logic_vector(4 downto 0);
   signal s_req_func_nr          : std_logic_vector(2 downto 0);
   signal s_req_length           : std_logic_vector(9 downto 0);
   signal s_req_tag              : std_logic_vector(7 downto 0);
   signal s_short_first          : std_logic_vector(1 downto 0);
   signal s_short_last           : std_logic_vector(1 downto 0);   
   signal s_tlp_adr              : std_logic_vector(63 downto 0);
   signal s_tlp_attribs          : std_logic_vector(13 downto 0);
   signal s_tlp_be_first         : std_logic_vector(3 downto 0);
   signal s_tlp_be_last          : std_logic_vector(3 downto 0);
   signal s_tlp_cc_pload         : std_logic_vector(7 downto 0);
   signal s_tlp_cmd              : std_logic_vector(c_bfsz_pcie_cmd - 1 downto 0);
   signal s_tlp_data_phase       : std_logic;
   signal s_tlp_has_payload      : std_logic;
   signal s_tlp_hdr_4dw          : std_logic;
   signal s_tlp_is_cpllkx        : std_logic;   
   signal s_tlp_is_cplx          : std_logic;
   signal s_tlp_is_io_space      : std_logic;
   signal s_tlp_is_mem_space     : std_logic;
   signal s_tlp_is_np_req        : std_logic;
   signal s_tlp_length           : std_logic_vector(10 downto 0);
   signal s_tlp_rsrc_hit         : std_logic;
   signal s_tlp_rx_bar_hit       : std_logic_vector(6 downto 0);
   signal s_tlp_rx_bar_hit_in    : std_logic_vector(2 downto 0);
   signal s_tlp_rx_count         : std_logic_vector(i_tlp_rx_count'length - 1 downto 0);
   signal s_tlp_rx_din           : std_logic_vector(31 downto 0);
   signal s_tlp_rx_pload_ok      : std_logic;
   signal s_tlp_rx_pop           : std_logic;
   signal s_tlp_status_ur        : std_logic;
   signal s_wb_ack               : std_logic;
   signal s_wb_adr               : std_logic_vector(c_wb_adr_sz - 1 downto 0);
   signal s_wb_bte               : std_logic_vector(c_wb_bte_burst_linear'length - 1 downto 0);
   signal s_wb_cti               : std_logic_vector(c_wb_cti_burst_incr'length - 1 downto 0);
   signal s_wb_cyc               : std_logic_vector(o_wb_cyc'length -1 downto 0);
   signal s_wb_cyc_local         : std_logic;
   signal s_wb_din               : std_logic_vector(31 downto 0);
   signal s_wb_din_pull          : std_logic;
   signal s_wb_dout              : std_logic_vector(31 downto 0);
   signal s_wb_dout_shadow       : std_logic_vector(31 downto 0);
   signal s_wb_rdat              : std_logic_vector(31 downto 0);
   signal s_wb_req_length        : std_logic_vector(10 downto 0);
   signal s_wb_sel               : std_logic_vector(3 downto 0);
   signal s_wb_stb               : std_logic;
   signal s_wb_we                : std_logic;   
   
Begin
   o_cc_npd_num            <= s_cc_npd_num;
   o_cc_pd_num             <= s_cc_pd_num;
   o_cc_processed_npd      <= s_cc_processed_npd;
   o_cc_processed_nph      <= s_cc_processed_nph;
   o_cc_processed_pd       <= s_cc_processed_pd;
   o_cc_processed_ph       <= s_cc_processed_ph;
   o_cpld_rx_data          <= s_cpld_rx_data;
   o_cpld_rx_push          <= s_cpld_rx_push;
   o_cpld_rx_sta_err       <= s_cpld_rx_sta_err;
   o_cpld_rx_tag           <= s_cpld_rx_tag;
   o_cplx_tx_data          <= s_cplx_tx_data;
   o_cplx_tx_last          <= s_cplx_tx_last;
   o_cplx_tx_push          <= s_cplx_tx_push;
   o_cplx_txq_push         <= s_cplx_txq_push;
   o_dec_adr               <= f_cp_resize(s_tlp_adr, o_dec_adr'length );
   o_dec_bar_hit           <= s_dec_bar_hit;
   o_tlp_rx_pop            <= s_tlp_rx_pop;
   o_wb_adr                <= f_cp_resize(s_wb_adr, o_wb_adr'length );
   o_wb_bte                <= s_wb_bte;
   o_wb_cti                <= s_wb_cti;
   o_wb_cyc                <= s_wb_cyc;
   o_wb_cyc_local          <= s_wb_cyc_local;
   o_wb_sel                <= s_wb_sel;
   o_wb_stb                <= s_wb_stb;
   o_wb_wdat               <= s_wb_dout;
   o_wb_we                 <= s_wb_we and not s_dec_cyc_local;
   o_wb_we_local           <= s_wb_we and s_dec_cyc_local;
  
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_tlp_cmd      <= s_tlp_rx_din(c_bpos_pcie_cmd_lsb + c_bfsz_pcie_cmd -1 downto c_bpos_pcie_cmd_lsb);
   s_wb_ack       <= (s_wb_cyc_local and i_wb_ack_local) or (i_wb_ack and not s_wb_cyc_local);

   s_wb_rdat      <= i_wb_rdat_local when (s_wb_cyc_local = '1') else i_wb_rdat;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~       
   R_FSM:
   process (all)
   begin
      s_pkt_dec_fsm_next   <= s_pkt_dec_fsm;

      case s_pkt_dec_fsm is
         when PD_IDLE =>
            if (unsigned(i_tlp_rx_count) > 2) then
               s_pkt_dec_fsm_next   <= PD_FETCH;
            end if;

         when PD_FETCH =>
            s_pkt_dec_fsm_next   <= PD_HDR0;
         
         when PD_HDR0 =>
            s_pkt_dec_fsm_next   <= PD_HDR1;

         when PD_HDR1 =>
            s_pkt_dec_fsm_next   <= PD_HDR2;

         when PD_HDR2 =>
            if (s_tlp_hdr_4dw = '1') then
               s_pkt_dec_fsm_next   <= PD_HDR3;
            else
               s_pkt_dec_fsm_next   <= PD_DECODE_WAIT;
            end if;

         when PD_HDR3 =>
            s_pkt_dec_fsm_next   <= PD_DECODE_WAIT;
                        
         when PD_DECODE_WAIT =>
            if (unsigned(s_dec_wt_count) = 0) then
               s_pkt_dec_fsm_next   <= PD_DECODE_EXEC;
            end if;

         when PD_DECODE_EXEC =>
            if (s_tlp_rsrc_hit = '1') then
               if (s_tlp_is_np_req = '1') then
                  s_pkt_dec_fsm_next   <= PD_CPL_WT_HDR;
               else
                  if (s_tlp_has_payload = '1') then
                     s_pkt_dec_fsm_next   <= PD_PLOAD_WAIT;
                  else
                     s_pkt_dec_fsm_next   <= PD_XFER_START_INIT;
                  end if;
               end if;
            elsif ((s_tlp_is_cplx = '1') or (s_tlp_is_cpllkx = '1')) then
               if (s_tlp_has_payload = '1') then
                  s_pkt_dec_fsm_next   <= PD_PLOAD_WAIT;               
               else
                  s_pkt_dec_fsm_next   <= PD_CPLD_INIT;
               end if;
            else
               s_pkt_dec_fsm_next   <= PD_UR_CHK_PLOAD;
            end if;

         when PD_PLOAD_WAIT =>
            if (s_tlp_rx_pload_ok = '1') then
               if ((s_tlp_is_cplx = '1') or (s_tlp_is_cpllkx = '1')) then
                  s_pkt_dec_fsm_next   <= PD_CPLD_INIT;               
               else
                  s_pkt_dec_fsm_next   <= PD_XFER_START_INIT;
               end if;
            end if;

         when PD_XFER_START_INIT =>
            s_pkt_dec_fsm_next   <= PD_XFER_START;

         when PD_XFER_START =>
            if (s_tlp_has_payload = '1') then
               s_pkt_dec_fsm_next   <= PD_PLOAD_WR;
            else
               s_pkt_dec_fsm_next   <= PD_PLOAD_RD;
            end if;

         when PD_PLOAD_RD =>
            if ((s_wb_ack = '1') and (unsigned(s_wb_req_length) = 1)) then
               s_pkt_dec_fsm_next   <= PD_PLOAD_RD_FLUSH;
            end if;

         when PD_PLOAD_RD_FLUSH =>
            if (unsigned(s_tlp_length) = 0) then
               s_pkt_dec_fsm_next   <= PD_FC_UPDATE_INIT;
            end if;
            
         when PD_PLOAD_WR  =>
            if (s_wb_ack = '1') then
               if (unsigned(s_wb_req_length) = 1) then
                  s_pkt_dec_fsm_next   <= PD_FC_UPDATE_INIT;
               end if;
            else
               if (unsigned(s_wb_req_length) > 1) then
                  s_pkt_dec_fsm_next   <= PD_PLOAD_WR_WAIT;
               end if;
            end if;

         when PD_PLOAD_WR_WAIT =>
            if (s_wb_ack = '1') then
               if (unsigned(s_wb_req_length) = 1) then
                  s_pkt_dec_fsm_next   <= PD_FC_UPDATE_INIT;
               else
                  s_pkt_dec_fsm_next   <= PD_PLOAD_WR; 
               end if;
            end if;
               
         when PD_FC_UPDATE_INIT =>
            s_pkt_dec_fsm_next   <= PD_FC_UPDATE;

         when PD_FC_UPDATE =>
            if (s_tlp_is_np_req = '1') then
               s_pkt_dec_fsm_next   <= PD_TXQ_PUSH;
            else
               s_pkt_dec_fsm_next   <= PD_IDLE;
            end if;

         when PD_TXQ_PUSH  =>
            if (i_cplx_txq_ack = '1') then
               s_pkt_dec_fsm_next   <= PD_IDLE;
            end if;

         when PD_UR_CHK_PLOAD =>
            if (s_tlp_has_payload = '1') then
               s_pkt_dec_fsm_next   <= PD_UR_POP;
            else
               if (s_tlp_is_np_req = '1') then
                  s_pkt_dec_fsm_next   <= PD_CPL_INIT;
               else
                  s_pkt_dec_fsm_next   <= PD_FC_UPDATE_INIT;
               end if;
            end if;

         when PD_UR_POP =>
            if ((s_tlp_rx_pop = '1') and (unsigned(s_tlp_length) = 1)) then
               if (s_tlp_is_np_req = '1') then
                  s_pkt_dec_fsm_next   <= PD_CPL_INIT;
               else
                  s_pkt_dec_fsm_next   <= PD_FC_UPDATE_INIT;
               end if;
            end if;

         when PD_CPL_WT_HDR   =>
            if (unsigned(i_cplx_tx_free) > 2) then
               s_pkt_dec_fsm_next   <= PD_CPL_INIT;
            end if;

         when PD_CPL_WT_PLOAD =>
            if (s_cplx_tx_pload_ok = '1') then
               s_pkt_dec_fsm_next   <= PD_XFER_START_INIT;
            end if;

         when PD_CPL_INIT  =>
            s_pkt_dec_fsm_next   <= PD_CPL_0;

         when PD_CPL_0  =>
            s_pkt_dec_fsm_next   <= PD_CPL_1;

         when PD_CPL_1 =>
            s_pkt_dec_fsm_next   <= PD_CPL_2;

         when PD_CPL_2 =>
            if (s_tlp_status_ur = '1') then
               s_pkt_dec_fsm_next   <= PD_FC_UPDATE_INIT;
            else
               if (s_tlp_has_payload = '1') then
                  s_pkt_dec_fsm_next  <= PD_PLOAD_WAIT;
               else
                  s_pkt_dec_fsm_next   <= PD_CPL_WT_PLOAD;
               end if;
            end if;

         when PD_CPLD_INIT =>
            if (s_tlp_has_payload = '1') then
               s_pkt_dec_fsm_next   <= PD_CPLD_PLOAD_START;
            else
               s_pkt_dec_fsm_next   <= PD_CPLD_STA;
            end if;

         when PD_CPLD_PLOAD_START =>
            s_pkt_dec_fsm_next   <= PD_CPLD_PLOAD;
            
         when PD_CPLD_PLOAD =>
            if ((s_cpld_rx_push = '1') and (unsigned(s_tlp_length) = 0)) then
               s_pkt_dec_fsm_next   <= PD_IDLE;
            end if;
            
         when PD_CPLD_STA =>
            s_pkt_dec_fsm_next   <= PD_IDLE;
                  
         when others =>
      end case;
      
   end process;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_MAIN:
   process (i_clk, i_rst_n)
   begin
      if (i_rst_n = '0') then
         s_cc_npd_num            <= (others => '0');
         s_cc_pd_num             <= (others => '0');
         s_cc_processed_npd      <= '0';
         s_cc_processed_nph      <= '0';
         s_cc_processed_pd       <= '0';
         s_cc_processed_ph       <= '0';
         s_cpld_rx_data          <= (others => '0');
         s_cpld_rx_push          <= '0';
         s_cpld_rx_sta_err       <= '0';
         s_cpld_rx_tag           <= (others => '0');
         s_cplx_tx_byte_count    <= (others => '0');
         s_cplx_tx_data          <= (others => '0');
         s_cplx_tx_free          <= (others => '0');
         s_cplx_tx_last          <= '0';
         s_cplx_tx_pload_ok      <= '0';
         s_cplx_tx_push          <= '0';
         s_cplx_tx_sta           <= (others => '0');
         s_cplx_txq_push         <= '0';
         s_dec_bar_hit           <= (others => '0');
         s_dec_cyc               <= (others => '0');
         s_dec_cyc_local         <= '0';
         s_dec_wt_count          <= (others => '0');
         s_pkt_dec_fsm           <= PD_IDLE;
         s_req_adr               <= (others => '0');
         s_req_bus_nr            <= (others => '0');
         s_req_dev_nr            <= (others => '0');
         s_req_func_nr           <= (others => '0');
         s_req_length            <= (others => '0');
         s_req_tag               <= (others => '0');
         s_short_first           <= (others => '0');
         s_short_last            <= (others => '0');
         s_tlp_adr               <= (others => '0');
         s_tlp_attribs           <= (others => '0');
         s_tlp_be_first          <= (others => '0');
         s_tlp_be_last           <= (others => '0');
         s_tlp_cc_pload          <= (others => '0');
         s_tlp_data_phase        <= '0';
         s_tlp_has_payload       <= '0';
         s_tlp_hdr_4dw           <= '0';
         s_tlp_is_cpllkx         <= '0';
         s_tlp_is_cplx           <= '0';
         s_tlp_is_io_space       <= '0';
         s_tlp_is_mem_space      <= '0';
         s_tlp_is_np_req         <= '0';
         s_tlp_length            <= (others => '0');
         s_tlp_rsrc_hit          <= '0';
         s_tlp_rx_bar_hit        <= (others => '0');
         s_tlp_rx_bar_hit_in     <= (others => '0');
         s_tlp_rx_count          <= (others => '0');
         s_tlp_rx_din            <= (others => '0');
         s_tlp_rx_pload_ok       <= '0';
         s_tlp_rx_pop            <= '0';
         s_tlp_status_ur         <= '0';
         s_wb_adr                <= (others => '0');
         s_wb_bte                <= (others => '0');
         s_wb_cti                <= (others => '0');
         s_wb_cyc                <= (others => '0');
         s_wb_cyc_local          <= '0';
         s_wb_din                <= (others => '0');
         s_wb_din_pull           <= '0';
         s_wb_dout               <= (others => '0');
         s_wb_dout_shadow        <= (others => '0');
         s_wb_req_length         <= (others => '0');
         s_wb_sel                <= (others => '0');
         s_wb_stb                <= '0';
         s_wb_we                 <= '0';
      elsif (rising_edge(i_clk)) then
         s_cpld_rx_push       <= '0';
         s_cplx_tx_free       <= i_cplx_tx_free;
         s_cplx_tx_pload_ok   <= f_to_logic(unsigned(s_cplx_tx_free) >= unsigned(s_req_length));
         s_cplx_tx_push       <= '0';
         s_pkt_dec_fsm        <= s_pkt_dec_fsm_next;
         s_tlp_rx_count       <= i_tlp_rx_count;
         s_tlp_rx_pload_ok    <= f_to_logic(unsigned(s_tlp_rx_count) >= unsigned(s_req_length));
         s_tlp_rx_pop         <= '0';
         s_wb_din_pull        <= '0';

         s_dec_bar_hit(6)     <= s_tlp_rx_bar_hit(6);
         for ix in 0 to 5 loop
            s_dec_bar_hit(ix) <= s_tlp_rx_bar_hit(ix) and ((s_tlp_is_io_space and i_cfg_io_space_sel(ix) and i_cfg_io_space_en) or
                                                           (s_tlp_is_mem_space and not i_cfg_io_space_sel(ix) and i_cfg_mem_space_en));
         end loop;
         
         case s_pkt_dec_fsm is
            when PD_IDLE =>
               s_tlp_rx_pop   <= f_to_logic(unsigned(i_tlp_rx_count) > 2);

            when PD_FETCH =>
               s_cplx_tx_last       <= '0';            
               s_dec_wt_count       <= c_dec_wt_count_load;
               s_tlp_adr            <= (others => '0');
               s_tlp_rx_bar_hit_in  <= i_tlp_rx_bar_hit;
               s_tlp_rx_din         <= i_tlp_rx_data;
               s_tlp_rx_pop         <= '1';

            when PD_HDR0 =>
               s_tlp_attribs                 <= f_cp_resize(s_tlp_rx_din(c_bpos_pcie_cmd_lsb - 1 downto 10), s_tlp_attribs'length );            
               s_tlp_has_payload             <= s_tlp_rx_din(c_bpos_has_payload);
               s_tlp_hdr_4dw                 <= s_tlp_rx_din(c_bpos_hdr_4dw);
               s_tlp_length                  <= f_cp_resize(s_tlp_rx_din(9 downto 0), s_tlp_length'length );
               s_tlp_rx_bar_hit(2 downto 0)  <= s_tlp_rx_bar_hit_in;
               s_tlp_rx_bar_hit_in           <= i_tlp_rx_bar_hit;               
               s_tlp_rx_din                  <= i_tlp_rx_data;
               s_tlp_rx_pop                  <= '1';

               s_tlp_is_cplx        <= f_to_logic(s_tlp_cmd = c_tlp_cpl) or f_to_logic(s_tlp_cmd = c_tlp_cpld);
               s_tlp_is_cpllkx      <= f_to_logic(s_tlp_cmd = c_tlp_cpllk) or f_to_logic(s_tlp_cmd = c_tlp_cpldlk);
               s_tlp_is_io_space    <= f_to_logic(s_tlp_cmd = c_tlp_iord) or f_to_logic(s_tlp_cmd = c_tlp_iowr);
               s_tlp_is_mem_space   <= f_to_logic(s_tlp_cmd = c_tlp_mrd32) or f_to_logic(s_tlp_cmd = c_tlp_mrd64) or
                                       f_to_logic(s_tlp_cmd = c_tlp_mwr32) or f_to_logic(s_tlp_cmd = c_tlp_mwr64);
               s_tlp_is_np_req      <= f_to_logic(s_tlp_cmd = c_tlp_iord) or f_to_logic(s_tlp_cmd = c_tlp_iowr) or
                                       f_to_logic(s_tlp_cmd = c_tlp_mrd32) or f_to_logic(s_tlp_cmd = c_tlp_mrd64) or
                                       f_to_logic(s_tlp_cmd = c_tlp_mrdlk32) or f_to_logic(s_tlp_cmd = c_tlp_mrdlk64) or
                                       f_to_logic(s_tlp_cmd = c_tlp_cfgrd0) or f_to_logic(s_tlp_cmd = c_tlp_cfgwr0) or
                                       f_to_logic(s_tlp_cmd = c_tlp_cfgrd1) or f_to_logic(s_tlp_cmd = c_tlp_cfgwr1);

            when PD_HDR1 =>
               s_cplx_tx_byte_count             <= std_logic_vector(resize(shift_left(unsigned(s_tlp_length), 2), s_cplx_tx_byte_count'length ));
               s_req_bus_nr                     <= s_tlp_rx_din(31 downto 24);
               s_req_dev_nr                     <= s_tlp_rx_din(23 downto 19);
               s_req_func_nr                    <= s_tlp_rx_din(18 downto 16);
               s_req_tag                        <= f_cp_resize(s_tlp_rx_din(c_bpos_pcie_tag_lsb + 7 downto c_bpos_pcie_tag_lsb), s_req_tag'length );
               s_tlp_be_first                   <= s_tlp_rx_din(3 downto 0);
               s_tlp_be_last                    <= s_tlp_rx_din(7 downto 4);
               s_tlp_cc_pload                   <= f_cp_resize(s_tlp_length(s_tlp_length'left downto 2), s_tlp_cc_pload'length );
               s_tlp_length(s_tlp_length'left)  <= f_to_logic(unsigned(s_tlp_length) = 0) and s_tlp_is_mem_space;
               s_tlp_rx_bar_hit(5 downto 3)     <= s_tlp_rx_bar_hit_in;
               s_tlp_rx_bar_hit_in              <= i_tlp_rx_bar_hit;               
               s_tlp_rx_din                     <= i_tlp_rx_data;
               s_tlp_rx_pop                     <= s_tlp_hdr_4dw;

            when PD_HDR2 =>
               s_cpld_rx_tag        <= f_cp_resize(s_tlp_rx_din(c_bpos_pcie_tag_lsb + 7 downto c_bpos_pcie_tag_lsb), s_req_tag'length );
               s_req_length         <= f_cp_resize(s_tlp_length, s_req_length'length );
               s_tlp_adr            <= f_cp_resize(s_tlp_rx_din, s_tlp_adr'length );
               s_tlp_data_phase     <= not s_tlp_hdr_4dw;
               s_tlp_rx_bar_hit(6)  <= s_tlp_rx_bar_hit_in(0);
               s_tlp_rx_din         <= i_tlp_rx_data;
               s_wb_adr             <= (others => '0');

               if (s_tlp_length(1 downto 0) /= "00") then
                  s_tlp_cc_pload    <= f_incr(s_tlp_cc_pload);
               end if;

               case s_tlp_be_last is
                  when "0100" | "0101" | "0110" | "0111" =>
                     s_short_last   <= std_logic_vector(to_unsigned(1, s_short_last'length ));

                     case s_tlp_be_first is
                        when "0010" | "0110" | "1010" | "1110" =>
                           s_short_first  <= std_logic_vector(to_unsigned(1, s_short_first'length ));

                        when "0100" | "1100" =>
                           s_short_first  <= std_logic_vector(to_unsigned(2, s_short_first'length ));

                        when "1000" =>
                           s_short_first  <= std_logic_vector(to_unsigned(3, s_short_first'length ));

                        when others =>
                           s_short_first  <= (others => '0');
                     end case;
                                          
                  when "0010" | "0011" =>
                     s_short_last   <= std_logic_vector(to_unsigned(2, s_short_last'length ));

                     case s_tlp_be_first is
                        when "0010" | "0110" | "1010" | "1110" =>
                           s_short_first  <= std_logic_vector(to_unsigned(1, s_short_first'length ));

                        when "0100" | "1100" =>
                           s_short_first  <= std_logic_vector(to_unsigned(2, s_short_first'length ));

                        when "1000" =>
                           s_short_first  <= std_logic_vector(to_unsigned(3, s_short_first'length ));

                        when others =>
                           s_short_first  <= (others => '0');
                     end case;
                                          
                  when "0001"  =>
                     s_short_last   <= std_logic_vector(to_unsigned(3, s_short_last'length ));

                     case s_tlp_be_first is
                        when "0010" | "0110" | "1010" | "1110" =>
                           s_short_first  <= std_logic_vector(to_unsigned(1, s_short_first'length ));

                        when "0100" | "1100" =>
                           s_short_first  <= std_logic_vector(to_unsigned(2, s_short_first'length ));

                        when "1000" =>
                           s_short_first  <= std_logic_vector(to_unsigned(3, s_short_first'length ));
                           
                        when others =>
                           s_short_first  <= (others => '0');      
                     end case;
                                          
                  when "0000" =>
                    s_short_last   <= (others => '0');

                     case s_tlp_be_first is
                        when "0000" | "0001" | "0010" | "0100" | "1000" =>
                           s_short_first  <= std_logic_vector(to_unsigned(3, s_short_first'length ));

                        when "0011" | "0110" | "1100" =>
                           s_short_first  <= std_logic_vector(to_unsigned(2, s_short_first'length ));

                        when "0101" | "0111" | "1010" | "1110" =>
                           s_short_first  <= std_logic_vector(to_unsigned(1, s_short_first'length ));

                        when others =>
                           s_short_first  <= (others => '0');                                                                                                                                    
                     end case;
                                       
                  when others =>
                    s_short_last   <= (others => '0');

                     case s_tlp_be_first is
                        when "0010" | "0110" | "1010" | "1110" =>
                           s_short_first  <= std_logic_vector(to_unsigned(1, s_short_first'length ));

                        when "0100" | "1100" =>
                           s_short_first  <= std_logic_vector(to_unsigned(2, s_short_first'length ));

                        when "1000" =>
                           s_short_first  <= std_logic_vector(to_unsigned(3, s_short_first'length ));

                        when others =>
                           s_short_first  <= (others => '0');
                     end case;                  
               end case;
               
            when PD_HDR3 =>
               s_tlp_adr         <= f_cp_resize(s_tlp_adr(31 downto 0) & s_tlp_rx_din, s_tlp_adr'length );
               s_tlp_data_phase  <= '1';

            when PD_DECODE_WAIT =>
               s_dec_cyc         <= i_dec_cyc;
               s_dec_cyc_local   <= i_dec_cyc_local;
               s_dec_wt_count    <= f_decr(s_dec_wt_count);
               s_tlp_rsrc_hit    <= f_to_logic(unsigned(i_dec_cyc) /= 0) or i_dec_cyc_local;

            when PD_DECODE_EXEC =>
               s_cplx_tx_byte_count    <= std_logic_vector(unsigned(s_cplx_tx_byte_count) - unsigned(s_short_first) - unsigned(s_short_last));
               s_tlp_status_ur         <= not s_tlp_rsrc_hit and not s_tlp_is_cplx and not s_tlp_is_cpllkx;

            when PD_XFER_START_INIT =>
               s_tlp_rx_pop      <= s_tlp_has_payload;
               s_wb_req_length   <= s_tlp_length; 

            when PD_XFER_START =>
               s_tlp_rx_pop         <= f_to_logic(unsigned(s_tlp_length) > 1) and s_tlp_has_payload;
               s_wb_adr             <= f_cp_resize(s_tlp_adr, s_wb_adr'length );
               s_wb_bte             <= c_wb_bte_burst_linear;
               s_wb_cyc_local       <= s_dec_cyc_local and s_tlp_rsrc_hit;
               s_wb_sel             <= s_tlp_be_first;
               s_wb_stb             <= s_tlp_rsrc_hit;
               s_wb_we              <= s_tlp_rsrc_hit and s_tlp_has_payload;

               if (unsigned(s_tlp_length) = 1) then
                  s_wb_cti    <= c_wb_cti_burst_end;
               else
                  s_wb_cti    <= c_wb_cti_burst_incr;
               end if;

               for ix in s_dec_cyc'range loop
                  s_wb_cyc(ix)   <= s_dec_cyc(ix) and not s_dec_cyc_local;
               end loop;

               if (s_tlp_rx_pop = '1') then
                  s_tlp_length      <= f_decr(s_tlp_length);
                  s_wb_dout         <= i_tlp_rx_data;
                  s_wb_dout_shadow  <= i_tlp_rx_data;                  
               end if;

            when PD_PLOAD_RD =>
               s_wb_din_pull     <= s_wb_ack;
               s_cplx_tx_push    <= s_wb_din_pull;
               
               if (s_wb_din_pull = '1') then
                  s_cplx_tx_data    <= s_wb_din;
                  s_tlp_length      <= f_decr(s_tlp_length);
               end if;
               
               if (s_wb_ack = '1') then
                  s_wb_din          <= f_swap_endian(s_wb_rdat);
                  s_wb_req_length   <= f_decr(s_wb_req_length);

                  if (unsigned(s_wb_req_length) < 3) then
                     s_wb_cti    <= c_wb_cti_burst_end;
                     s_wb_sel    <= s_tlp_be_last;
                  else
                     s_wb_sel    <= (others => '1');
                  end if;

                  if (s_wb_cti = c_wb_cti_burst_end) then
                     s_wb_adr             <= (others => '0');
                     s_wb_bte             <= (others => '0');
                     s_wb_cti             <= (others => '0');
                     s_wb_cyc             <= (others => '0');
                     s_wb_cyc_local       <= '0';
                     s_wb_dout            <= (others => '0');
                     s_wb_sel             <= (others => '0');
                     s_wb_stb             <= '0';
                     s_wb_we              <= '0';
                  else
                     s_wb_adr    <= s_wb_adr(s_wb_adr'left downto 12) & f_incr(s_wb_adr(11 downto 2)) & "00";
                  end if;
               end if;

            when PD_PLOAD_RD_FLUSH =>
               s_cplx_tx_push    <= s_wb_din_pull;
                           
               if (s_wb_din_pull = '1') then
                  s_cplx_tx_data    <= s_wb_din;
                  s_tlp_length      <= f_decr(s_tlp_length);
               end if;
                           
            when PD_PLOAD_WR =>
               s_tlp_rx_pop   <= ((f_to_logic(unsigned(s_tlp_length) > 1) and s_tlp_rx_pop) or
                                  (f_to_logic(unsigned(s_tlp_length) > 0) and not s_tlp_rx_pop)) and s_tlp_has_payload and s_wb_ack;

               if (s_tlp_rx_pop = '1') then
                  s_tlp_length      <= f_decr(s_tlp_length);
                  s_wb_dout         <= i_tlp_rx_data;
                  s_wb_dout_shadow  <= i_tlp_rx_data;

                  if (s_wb_ack = '1') then
                     s_wb_dout   <= i_tlp_rx_data;
                  else
                     s_wb_dout   <= s_wb_dout_shadow;
                  end if;
               end if;
               
               if (s_wb_ack = '1') then
                  s_wb_req_length   <= f_decr(s_wb_req_length);

                  if (unsigned(s_wb_req_length) < 3) then
                     s_wb_cti    <= c_wb_cti_burst_end;
                     s_wb_sel    <= s_tlp_be_last;                     
                  end if;
                  
                  if (s_wb_cti = c_wb_cti_burst_end) then
                     s_wb_adr             <= (others => '0');
                     s_wb_bte             <= (others => '0');
                     s_wb_cti             <= (others => '0');
                     s_wb_cyc             <= (others => '0');
                     s_wb_cyc_local       <= '0';
                     s_wb_dout            <= (others => '0');
                     s_wb_sel             <= (others => '0');
                     s_wb_stb             <= '0';
                     s_wb_we              <= '0';
                  else
                     s_wb_adr    <= s_wb_adr(s_wb_adr'left downto 12) & f_incr(s_wb_adr(11 downto 2)) & "00";
                  end if;               
               end if;

            when PD_PLOAD_WR_WAIT =>
               if (s_wb_ack = '1') then
                  if (unsigned(s_wb_req_length) < 3) then
                     s_wb_cti    <= c_wb_cti_burst_end;
                     s_wb_sel    <= s_tlp_be_last;
                  else
                     s_wb_sel    <= (others => '1');
                  end if;
                                 
                  s_tlp_rx_pop      <= f_to_logic(unsigned(s_tlp_length) > 0) and s_tlp_has_payload;
                  s_wb_adr          <= s_wb_adr(s_wb_adr'left downto 12) & f_incr(s_wb_adr(11 downto 2)) & "00";
                  s_wb_dout         <= s_wb_dout_shadow;
                  s_wb_req_length   <= f_decr(s_wb_req_length);
               end if;

            when PD_FC_UPDATE_INIT =>
               if (s_tlp_is_np_req = '1') then
                  if (i_ca_nph_infinite = '0') then
                     s_cc_processed_nph   <= '1';
                  end if;

                  if ((s_tlp_has_payload = '1') and (i_ca_npd_infinite = '0')) then
                     s_cc_npd_num         <= f_cp_resize(s_tlp_cc_pload, s_cc_npd_num'length );
                     s_cc_processed_npd   <= '1';
                  end if;
               else
                  if (s_tlp_is_cplx = '0') then
                     if (i_ca_ph_infinite = '0') then
                        s_cc_processed_ph    <= '1';
                     end if;

                     if ((s_tlp_has_payload = '1') and (i_ca_pd_infinite = '0')) then
                        s_cc_pd_num          <= f_cp_resize(s_tlp_cc_pload, s_cc_pd_num'length );
                        s_cc_processed_pd    <= '1';
                     end if;
                  end if;
               end if;

            when PD_FC_UPDATE =>
               s_cc_npd_num         <= (others => '0');
               s_cc_pd_num          <= (others => '0');
               s_cc_processed_npd   <= '0';
               s_cc_processed_nph   <= '0';
               s_cc_processed_pd    <= '0';
               s_cc_processed_ph    <= '0';
               s_tlp_data_phase     <= '0';

            when PD_TXQ_PUSH =>
               s_cplx_txq_push   <= (not s_cplx_txq_push) or (s_cplx_txq_push and not i_cplx_txq_ack);

            when PD_UR_CHK_PLOAD =>
               s_tlp_rx_pop   <= s_tlp_has_payload;

            when PD_UR_POP =>
               s_tlp_rx_pop   <= f_to_logic(unsigned(s_tlp_length) > 1);
               
               if (s_tlp_rx_pop = '1') then
                  s_tlp_length   <= f_decr(s_tlp_length);
               end if;

            when PD_CPL_INIT =>
               s_cplx_tx_push          <= '1';
               s_req_adr(7 downto 2)   <= f_cp_resize(s_tlp_adr(7 downto 2), s_req_adr'length - 2);

               case s_tlp_be_first is
                  when "0010" | "0110" | "1010" | "1110" =>
                     s_req_adr(1 downto 0) <= "01";
                  when "0100" | "1100" =>
                     s_req_adr(1 downto 0) <= "10";
                  when "1000" =>
                     s_req_adr(1 downto 0) <= "11";
                  when others =>
                     s_req_adr(1 downto 0) <= "00";
               end case;

               if (s_tlp_status_ur = '1') then
                  s_cplx_tx_sta  <= c_cpl_sta_ur & c_tie_low;
               else
                  s_cplx_tx_sta  <= c_cpl_sta_sc & c_tie_low;
               end if;
                                             
               if ((s_tlp_has_payload = '1') or (s_tlp_status_ur = '1')) then
                  s_cplx_tx_data    <= c_tlp_cpl & s_tlp_attribs & c_tie_low_dword(9 downto 0);               
               else
                  if (s_tlp_is_mem_space = '1') then
                     s_cplx_tx_data    <= c_tlp_cpld & s_tlp_attribs & s_req_length;
                  else
                     s_cplx_tx_data    <= c_tlp_cpld & s_tlp_attribs & std_logic_vector(to_unsigned(1, 10));
                  end if;
               end if;
               
            when PD_CPL_0 =>
               s_cplx_tx_push <= '1';

               if ((s_tlp_is_mem_space = '1') and (s_tlp_is_np_req = '1')) then
                  s_cplx_tx_data    <= i_cid_bus_nr & i_cid_dev_nr & i_cid_func_nr & s_cplx_tx_sta &
                                       std_logic_vector(resize(unsigned(s_cplx_tx_byte_count), 12));
               else
                  s_cplx_tx_data    <= i_cid_bus_nr & i_cid_dev_nr & i_cid_func_nr & s_cplx_tx_sta & std_logic_vector(to_unsigned(4, 12));
               end if;

            when PD_CPL_1  =>
               s_cplx_tx_last    <= '1';
               s_cplx_tx_push    <= '1';

               if ((s_tlp_is_mem_space = '1') and (s_tlp_is_np_req = '1')) then
                  s_cplx_tx_data    <= s_req_bus_nr & s_req_dev_nr & s_req_func_nr & s_req_tag & c_tie_low & s_req_adr(6 downto 0);
               else
                  s_cplx_tx_data    <= s_req_bus_nr & s_req_dev_nr & s_req_func_nr & s_req_tag & c_tie_low_dword(7 downto 0);               
               end if;

            when PD_CPL_2 =>
               s_cplx_tx_data    <= (others => '0');
               s_cplx_tx_last    <= '0';
               s_cplx_tx_push    <= '0';

            when PD_CPLD_INIT =>
               s_cpld_rx_sta_err    <= s_tlp_is_cpllkx or (not s_tlp_has_payload);
               s_tlp_rx_pop         <= s_tlp_has_payload;

            when PD_CPLD_PLOAD_START =>
               s_cpld_rx_data    <= i_tlp_rx_data;
               s_cpld_rx_push    <= '1';
               s_tlp_length      <= f_decr(s_tlp_length);
               s_tlp_rx_pop      <= f_to_logic(unsigned(s_tlp_length) > 1);
               
            when PD_CPLD_PLOAD =>
               s_tlp_length         <= f_decr(s_tlp_length);
               s_tlp_rx_pop         <= f_to_logic(unsigned(s_tlp_length) > 1);

               if (s_tlp_rx_pop = '1') then
                  s_cpld_rx_data    <= i_tlp_rx_data;
                  s_cpld_rx_push    <= '1';               
               end if;
               
               if (unsigned(s_tlp_length) = 1) then
                  s_cpld_rx_sta_err <= '0';
               end if;

            when PD_CPLD_STA =>
               s_cpld_rx_sta_err <= '0';
                  
            when others =>
         end case;
      end if;
   end process;            
End Rtl;
