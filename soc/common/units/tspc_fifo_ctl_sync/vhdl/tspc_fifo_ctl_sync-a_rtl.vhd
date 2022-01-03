
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
-- File ID     : $Id: tspc_fifo_ctl_sync-a_rtl.vhd 4353 2018-07-11 08:58:27Z  $
-- Generated   : $LastChangedDate: 2018-07-11 10:58:27 +0200 (Wed, 11 Jul 2018) $
-- Revision    : $LastChangedRevision: 4353 $
--
--------------------------------------------------------------------------------
--
-- Description : Control Logic for Synchronous FIFO
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Architecture Rtl of tspc_fifo_ctl_sync is
   subtype t_mem_count     is std_logic_vector(f_vec_msb(g_mem_words) downto 0);
   subtype t_mem_ptr       is std_logic_vector(f_vec_msb(g_mem_words - 1) downto 0);
   
   type t_frd_state  is (FS_EMPTY, FS_MT_EXIT_1, FS_MT_EXIT_2, FS_RDY);
   
   signal s_adr_pipe_full        : std_logic;
   signal s_dpipe_stall          : std_logic;
   signal s_fc_cnt_pop           : std_logic;
   signal s_fc_cnt_push          : std_logic;
   signal s_fc_data_count        : t_mem_count;
   signal s_fc_gt0               : std_logic;
   signal s_fc_gt1               : std_logic;
   signal s_fc_gt1_prev          : std_logic;
   signal s_frd_state            : t_frd_state;
   signal s_frd_state_next       : t_frd_state;
   signal s_pop                  : std_logic;
   signal s_push                 : std_logic;
   signal s_push_op              : std_logic;
   signal s_push_pipe            : std_logic_vector(g_rd_latency + g_wr_latency - 1 downto 0);
   signal s_rd_adr_step          : std_logic;
   signal s_rd_clken_adr         : std_logic;
   signal s_rd_clken_oreg        : std_logic;
   signal s_rd_cnt_eq_1          : std_logic;
   signal s_rd_cnt_ge_lat        : std_logic;
   signal s_rd_cnt_gt_lat        : std_logic;
   signal s_rd_cnt_push          : std_logic;
   signal s_rd_data_count        : t_mem_count;
   signal s_rd_fifo_aempty       : std_logic;
   signal s_rd_fifo_empty        : std_logic;
   signal s_rd_last              : std_logic;
   signal s_rd_mem_adr           : t_mem_ptr;
   signal s_rd_mem_adr_out       : t_mem_ptr;
   signal s_rd_mem_adr_prev      : t_mem_ptr;
   signal s_wr_data_free         : t_mem_count;
   signal s_wr_en_pipe           : std_logic_vector(g_wr_latency downto 0);
   signal s_wr_fifo_afull        : std_logic;
   signal s_wr_fifo_full         : std_logic;
   signal s_wr_last              : std_logic;
   signal s_wr_mem_adr           : t_mem_ptr;
   
Begin
   o_rd_count     <= f_cp_resize(s_rd_data_count, o_rd_count'length );
   o_rd_adr       <= f_cp_resize(s_rd_mem_adr_out, o_rd_adr'length );
   o_rd_aempty    <= s_rd_fifo_aempty;
   o_rd_empty     <= s_rd_fifo_empty;
   o_rd_en        <= s_rd_clken_adr or s_rd_clken_oreg;
   o_rd_last      <= s_rd_last;
   
   o_wr_adr       <= f_cp_resize(s_wr_mem_adr, o_wr_adr'length );
   o_wr_afull     <= s_wr_fifo_afull;
   o_wr_en        <= s_push;
   o_wr_free      <= f_cp_resize(s_wr_data_free, o_wr_free'length );
   o_wr_full      <= s_wr_fifo_full;
   o_wr_last      <= s_wr_last;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
   R_DPS_EQ1:
   if (g_rd_latency = 1) generate
      s_dpipe_stall     <= '0';

      s_frd_state_next  <= FS_EMPTY;
      
      s_rd_mem_adr_out  <= s_rd_mem_adr;
      
      s_rd_adr_step     <= (s_rd_cnt_gt_lat and s_pop) or
                           (s_rd_cnt_eq_1 and s_pop and s_rd_cnt_push) or
                           (s_rd_fifo_empty and s_rd_cnt_push);
                           
      s_rd_clken_adr    <= (s_rd_cnt_gt_lat and s_pop) or
                           (s_rd_cnt_eq_1 and s_pop and s_rd_cnt_push) or
                           (s_rd_fifo_empty and s_rd_cnt_push);
      
      s_rd_clken_oreg   <= '0';
      
      s_rd_cnt_push     <= s_fc_gt0;

   end generate;

   R_DPS_EQ2:
   if (g_rd_latency = 2) generate     
      s_rd_mem_adr_out  <= s_rd_mem_adr_prev when ((s_dpipe_stall = '1') and (s_frd_state = FS_RDY)) 
                                             else s_rd_mem_adr;
      
      s_rd_clken_oreg   <= (s_pop and (s_rd_cnt_ge_lat or s_rd_cnt_push)) or
                           (s_rd_fifo_empty and s_rd_cnt_push);   
                           
      s_rd_cnt_push     <= s_fc_gt0 and not s_dpipe_stall;
      
      R_FSM:
      process (all)
      begin
         s_frd_state_next  <= s_frd_state;
         
         case s_frd_state is
            when FS_EMPTY =>
               s_dpipe_stall     <= '1';
               s_rd_adr_step     <= '0';
               s_rd_clken_adr    <= '0';
               
               if (s_fc_gt0 = '1') then
                  s_frd_state_next  <= FS_MT_EXIT_1;
               end if;
               
            when FS_MT_EXIT_1 => 
               s_dpipe_stall     <= '1';
               s_rd_adr_step     <= s_fc_gt1;
               s_rd_clken_adr    <= '1';
            
               s_frd_state_next  <= FS_MT_EXIT_2;
               
            when FS_MT_EXIT_2 => 
               s_dpipe_stall     <= '0';
               s_rd_adr_step     <= '1';
               s_rd_clken_adr    <= s_fc_gt1;

               s_frd_state_next  <= FS_RDY;
               
            when FS_RDY =>
               s_dpipe_stall     <= s_pop and not s_rd_cnt_gt_lat;
               s_rd_adr_step     <= (s_rd_cnt_gt_lat and s_pop) or
                                    (s_rd_cnt_ge_lat and s_pop and s_rd_cnt_push) or
                                    (s_rd_cnt_eq_1 and s_rd_cnt_push and (not s_adr_pipe_full));
               s_rd_clken_adr    <= (s_pop and s_rd_cnt_ge_lat) or
                                    (s_rd_cnt_eq_1 and s_rd_cnt_push and (not s_adr_pipe_full));   
               
               if ((s_rd_cnt_eq_1 = '1') and (s_pop = '1') and (s_rd_cnt_push = '0')) then
                  s_frd_state_next  <= FS_EMPTY;
               end if;
               
            when others =>
         end case;
      end process;
   end generate;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~    
   s_fc_cnt_pop      <= s_rd_cnt_push;
   
   s_fc_cnt_push     <= s_push_pipe(s_push_pipe'left );
   
   s_pop             <= i_rd_en and not s_rd_fifo_empty;
   
   s_push            <= i_wr_en and not s_wr_fifo_full;
   s_push_op         <= s_push_pipe(g_wr_latency - 1);
   
   s_wr_en_pipe      <= s_push_pipe(g_wr_latency - 1 downto 0) & s_push;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_MAIN :
   process (i_clk, i_rst_n)
      constant c_aempty_clr      : natural := g_flag_rd_threshold + 1;
      constant c_aempty_set      : natural := g_flag_rd_threshold;
      constant c_afull_clr       : natural := g_flag_wr_threshold;
      constant c_afull_set       : natural := g_flag_wr_threshold + 1;
      constant c_fifo_one_free   : natural := g_mem_words - 1;
            
      variable v_fp_op           : std_logic_vector(1 downto 0);
      variable v_rd_op           : std_logic_vector(1 downto 0);
      variable v_wr_op           : std_logic_vector(1 downto 0);
      
      procedure p_fifo_clear is
      begin
         s_adr_pipe_full         <= '0';
         s_fc_data_count         <= (others => '0');
         s_fc_gt0                <= '0';
         s_fc_gt1                <= '0';
         s_fc_gt1_prev           <= '0';
         s_frd_state             <= FS_EMPTY;
         s_push_pipe             <= (others => '0');
         s_rd_cnt_eq_1           <= '0';
         s_rd_cnt_ge_lat         <= '0';
         s_rd_cnt_gt_lat         <= '0';
         s_rd_data_count         <= (others => '0');
         s_rd_fifo_aempty        <= '0';
         s_rd_fifo_empty         <= '1';
         s_rd_last               <= '0';
         s_rd_mem_adr            <= (others => '0');
         s_rd_mem_adr_prev       <= (others => '0');
         s_wr_data_free          <= f_reg_load(g_mem_words, s_wr_data_free'length );
         s_wr_fifo_afull         <= '0';
         s_wr_fifo_full          <= '0';
         s_wr_last               <= '0';
         s_wr_mem_adr            <= (others => '0');      
      end procedure;
      
   begin
      if (i_rst_n = '0') then
         p_fifo_clear;
      elsif (rising_edge(i_clk)) then
         if (i_clr = '1') then      
            p_fifo_clear;
            
         else            
            s_fc_gt1_prev           <= s_fc_gt1;
            s_frd_state             <= s_frd_state_next;
         
            s_push_pipe             <= f_shin_lsb(s_push_pipe, s_push);
            
            if (s_rd_adr_step = '1') then
               s_rd_mem_adr      <= f_incr(s_rd_mem_adr);
               s_rd_mem_adr_prev <= s_rd_mem_adr;
            end if;
            
            if (s_push = '1') then
               s_wr_mem_adr   <= f_incr(s_wr_mem_adr);
            end if;
            
                  --    ~~~~~~~~~~~~~~~~~~
                  --       Count up on wr, count down on push to rd_count domain
            v_fp_op  := s_fc_cnt_pop & s_fc_cnt_push;

            case v_fp_op is
               when "01" =>
                  s_fc_data_count   <= f_incr(s_fc_data_count);
                  s_fc_gt0          <= '1';
                  s_fc_gt1          <= s_fc_gt0 or s_fc_gt1;
                  
               when "10" =>
                  s_fc_data_count   <= f_decr(s_fc_data_count);
                  s_fc_gt0          <= s_fc_gt1;
                  s_fc_gt1          <= f_to_logic(unsigned(s_fc_data_count) > 2);
               
               when others =>
            end case;
            
                  --    ~~~~~~~~~~~~~~~~~~
                  --       Design is synchronous, so read-count can only incr/decr by 
                  --       one per clock cycle
                  --       count up only when mem output-data/next-data available 
            v_rd_op  := s_pop & s_rd_cnt_push;

            case v_rd_op is
               when "01" =>
                  s_adr_pipe_full      <= s_adr_pipe_full or s_rd_cnt_eq_1 or (s_rd_fifo_empty and s_fc_gt1_prev);
                  s_rd_cnt_eq_1        <= f_to_logic(s_rd_fifo_empty = '1');
                  s_rd_cnt_ge_lat      <= s_rd_cnt_ge_lat or f_to_logic(unsigned(s_rd_data_count) = (g_rd_latency - 1));
                  s_rd_cnt_gt_lat      <= s_rd_cnt_ge_lat;
                  s_rd_data_count      <= f_incr(s_rd_data_count);
                  s_rd_fifo_aempty     <= s_rd_fifo_aempty and not
                                          f_to_logic(unsigned(s_rd_data_count) = (c_aempty_clr - 1));
                  s_rd_fifo_empty      <= '0';
                  s_rd_last            <= f_to_logic(unsigned(s_rd_data_count) = 0);
                  
               when "10" =>
                  s_adr_pipe_full      <= s_rd_cnt_gt_lat;
                  s_rd_cnt_eq_1        <= f_to_logic(unsigned(s_rd_data_count) = 2);
                  s_rd_cnt_ge_lat      <= s_rd_cnt_gt_lat;
                  s_rd_cnt_gt_lat      <= f_to_logic(unsigned(s_rd_data_count) > (g_rd_latency + 1));
                  s_rd_data_count      <= f_decr(s_rd_data_count);
                  s_rd_fifo_aempty     <= f_to_logic(unsigned(s_rd_data_count) = (c_aempty_set + 1)) or
                                          s_rd_fifo_aempty;
                  s_rd_fifo_empty      <= f_to_logic(unsigned(s_rd_data_count) = 1) or s_rd_fifo_empty;
                  s_rd_last            <= f_to_logic(unsigned(s_rd_data_count) = 2);
               when others =>
            end case;
            
                  --    ~~~~~~~~~~~~~~~~~~
            v_wr_op  := s_pop & s_push;

            case v_wr_op is
               when "01" =>
                  s_wr_fifo_afull   <= f_to_logic(unsigned(s_wr_data_free) = c_afull_set) or
                                       s_wr_fifo_afull;
                  s_wr_fifo_full    <= f_to_logic(unsigned(s_wr_data_free) = 1) or
                                       s_wr_fifo_full;
                  s_wr_data_free    <= std_logic_vector(unsigned(s_wr_data_free) - 1);
                  s_wr_last         <= f_to_logic(unsigned(s_wr_data_free) = 2);
               when "10" =>
                  s_wr_fifo_afull   <= s_wr_fifo_afull and not
                                       f_to_logic(unsigned(s_wr_data_free) = c_afull_clr);
                  s_wr_fifo_full    <= '0';
                  s_wr_data_free    <= std_logic_vector(unsigned(s_wr_data_free) + 1);
                  s_wr_last         <= f_to_logic(unsigned(s_wr_data_free) = 0);
               when others =>
            end case;
               
         end if;
      end if;
   end process;

End Rtl;

