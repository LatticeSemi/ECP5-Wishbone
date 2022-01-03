
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
-- File ID     : $Id: tspc_wb_ebr_ctl-a_rtl.vhd 4286 2018-06-17 22:42:23Z  $
-- Generated   : $LastChangedDate: 2018-06-18 00:42:23 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4286 $
--
--------------------------------------------------------------------------------
--
-- Description : Wishbone Interface for Embedded Memory
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.tspc_utils.all;
Use WORK.tspc_wbone_types.all;

Architecture Rtl of tspc_wb_ebr_ctl is
   type t_wb_fsm is (WB_IDLE, WB_DECODE, 
                     WB_MEM_WR,
                     WB_MEM_PIPE_LD, WB_MEM_RD);

   constant c_ram_addr_lsb : natural := f_vec_size(g_word_sz - 1);
      
   signal s_pipe_count_rd  : std_logic_vector(f_vec_msb(g_rd_pipe_sz) downto 0);
   signal s_prescale       : std_logic_vector(f_vec_msb(g_prescale - 1) downto 0);
   signal s_ram_addr       : std_logic_vector(f_vec_msb(g_array_sz - 1) downto 0);
   signal s_ram_addr_out   : std_logic_vector(f_vec_msb(g_array_sz - 1) downto 0);
   signal s_ram_be         : std_logic_vector(g_word_sz - 1 downto 0);
   signal s_ram_wdat       : std_logic_vector((g_word_sz * g_char_sz) - 1 downto 0);
   signal s_ram_we         : std_logic;
   signal s_wb_ack         : std_logic;
   signal s_wb_adr_in      : std_logic_vector(f_vec_msb((g_array_sz * g_word_sz) - 1) downto 0);
   signal s_wb_cyc         : std_logic;
   signal s_wb_fsm         : t_wb_fsm;
   signal s_wb_fsm_next    : t_wb_fsm;
   signal s_wb_rdat        : std_logic_vector((g_word_sz * g_char_sz) - 1 downto 0);
   signal s_wb_rdat_out    : std_logic_vector((g_word_sz * g_char_sz) - 1 downto 0);
   signal s_wb_stb         : std_logic;
   signal s_wb_we          : std_logic;
   
Begin
   o_ram_addr  <= std_logic_vector(resize(unsigned(s_ram_addr_out), o_ram_addr'length));
   o_ram_be    <= std_logic_vector(resize(unsigned(s_ram_be), o_ram_be'length));
   o_ram_wdat  <= std_logic_vector(resize(unsigned(s_ram_wdat), o_ram_wdat'length));
   o_ram_we    <= s_ram_we;
   
   o_wb_ack    <= s_wb_ack;
   o_wb_err    <= c_tie_low;
   o_wb_rdat   <= s_wb_rdat_out;
   o_wb_rty    <= c_tie_low;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_wb_adr_in <= std_logic_vector(resize(unsigned(i_wb_adr), s_wb_adr_in'length));
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_DOUT_SEL:
   process (s_wb_ack, s_wb_rdat, i_ram_dq)
   begin
      if (s_wb_ack = '1') then
         if (g_rd_pipe_sz > 0) then
            s_wb_rdat_out  <= std_logic_vector(resize(unsigned(s_wb_rdat), o_wb_rdat'length));
         else
            s_wb_rdat_out  <= std_logic_vector(resize(unsigned(i_ram_dq), o_wb_rdat'length));
         end if;
      else
         s_wb_rdat_out  <= (others => '0');
      end if;
   end process;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_FSM:
   process(s_pipe_count_rd, s_wb_fsm, s_wb_stb, s_wb_we, 
           i_wb_cti, i_wb_cyc, i_wb_stb, i_wb_we)
   begin
      s_wb_fsm_next  <= s_wb_fsm;
      
      case s_wb_fsm is
         when WB_IDLE =>
            if (i_wb_cyc = '1') then
               if (i_wb_stb = '1') then
                  if (i_wb_we = '1') then
                     s_wb_fsm_next  <= WB_MEM_WR;
                  elsif (g_rd_pipe_sz = 0) then
                     s_wb_fsm_next  <= WB_MEM_RD;
                  else
                     s_wb_fsm_next  <= WB_DECODE;
                  end if;
               else
                  s_wb_fsm_next  <= WB_DECODE;
               end if;
            end if;
            
         when WB_DECODE =>
            if (s_wb_stb = '1') then
               if (s_wb_we = '1') then
                  s_wb_fsm_next  <= WB_MEM_WR;
               else
                  if (unsigned(s_pipe_count_rd) = 0) then
                     s_wb_fsm_next  <= WB_MEM_RD;
                  else
                     s_wb_fsm_next  <= WB_MEM_PIPE_LD;
                  end if;
               end if;
            end if;
            
         when WB_MEM_WR =>
            if (i_wb_cyc /= '1') then
               s_wb_fsm_next  <= WB_IDLE;
            elsif (i_wb_stb = '1') then
               case i_wb_cti is
                  when c_wb_cti_classic =>
                     s_wb_fsm_next  <= WB_IDLE;

                  when c_wb_cti_burst_end =>
                     s_wb_fsm_next  <= WB_IDLE;

                  when others => 
               end case;
            end if;
                        
         when WB_MEM_PIPE_LD =>
            if (unsigned(s_pipe_count_rd) = 0) then
               s_wb_fsm_next  <= WB_MEM_RD;
            end if;

         when WB_MEM_RD =>
            if (i_wb_cyc /= '1') then
               s_wb_fsm_next  <= WB_IDLE;
            elsif (i_wb_stb /= '1') then
               if (g_rd_pipe_sz > 1) then
                     -- We must reload the pipeline when the master is
                     -- ready again
                  s_wb_fsm_next  <= WB_DECODE;
               end if;
            else
               case i_wb_cti is
                  when c_wb_cti_classic =>
                     s_wb_fsm_next  <= WB_IDLE;

                  when c_wb_cti_burst_end =>
                     s_wb_fsm_next  <= WB_IDLE;

                  when others => 
               end case;
            end if;
            
         when others =>
      end case;
   end process;
      
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      
   MAIN:
   process (i_clk, i_rst_n)
   begin
      if (i_rst_n = '0') then
         s_pipe_count_rd   <= (others => '0');
         s_prescale        <= (others => '0');
         s_ram_addr        <= (others => '0');
         s_ram_addr_out    <= (others => '0');
         s_ram_be          <= (others => '0');
         s_ram_wdat        <= (others => '0');
         s_ram_we          <= '0';
         s_wb_ack          <= '0';
         s_wb_cyc          <= '0';
         s_wb_fsm          <= WB_IDLE;
         s_wb_rdat         <= (others => '0');
         s_wb_stb          <= '0';
         s_wb_we           <= '0';
      elsif (rising_edge(i_clk)) then
         s_ram_we       <= s_wb_ack and i_wb_stb and i_wb_cyc and i_wb_we;
         s_wb_ack       <= '0';
         s_wb_cyc       <= i_wb_cyc;
         s_wb_fsm       <= s_wb_fsm_next;
         s_wb_rdat      <= (others => '0');
         s_wb_stb       <= i_wb_stb;
         
         if (unsigned(s_prescale) = 0) then
            s_prescale  <= std_logic_vector(to_unsigned((g_prescale - 1), s_prescale'length));
         else
            s_prescale  <= std_logic_vector(unsigned(s_prescale) - 1);
         end if;
         
         case s_wb_fsm is
            when WB_IDLE =>
               s_ram_addr  <= std_logic_vector(resize(unsigned(s_wb_adr_in(s_wb_adr_in'left downto c_ram_addr_lsb)),
                                                      s_ram_addr'length));
                                                      
               s_wb_ack <= i_wb_stb and i_wb_cyc and (i_wb_we or
                                                      f_to_logic(g_rd_pipe_sz = 0));
               s_wb_we  <= i_wb_we;

               if (g_rd_pipe_sz > 0) then
                  s_pipe_count_rd   <= std_logic_vector(to_unsigned(g_rd_pipe_sz - 1, s_pipe_count_rd'length));
               end if;
                           
            when WB_DECODE =>
               s_ram_addr  <= std_logic_vector(resize(unsigned(s_wb_adr_in(s_wb_adr_in'left downto c_ram_addr_lsb)),
                                                      s_ram_addr'length));
               s_wb_ack    <= s_wb_stb and s_wb_cyc and (s_wb_we or
                                                         f_to_logic(g_rd_pipe_sz = 0));
               if (s_wb_we = '0') then
                  s_ram_addr_out <= std_logic_vector(resize(unsigned(s_wb_adr_in(s_wb_adr_in'left downto c_ram_addr_lsb)),
                                                            s_ram_addr'length));
                  s_wb_rdat   <= std_logic_vector(resize(unsigned(i_ram_dq), o_wb_rdat'length));
               else
                  s_ram_addr_out <= s_ram_addr;
                  s_ram_be       <= std_logic_vector(resize(unsigned(i_wb_sel), s_ram_be'length));
                  s_ram_wdat     <= std_logic_vector(resize(unsigned(i_wb_wdat), s_ram_wdat'length));               
               end if;
               
               if (g_rd_pipe_sz > 0) then
                  s_pipe_count_rd   <= std_logic_vector(to_unsigned(g_rd_pipe_sz - 1, s_pipe_count_rd'length));
               end if;
               
            when WB_MEM_RD =>
               if (s_wb_fsm_next = WB_MEM_RD) then
                  s_wb_ack    <= '1';
                  s_wb_rdat   <= std_logic_vector(resize(unsigned(i_ram_dq), o_wb_rdat'length));
               end if;
               
               if (i_wb_stb = '1') then
                  s_ram_addr_out <= std_logic_vector(unsigned(s_ram_addr_out) + 1);
               end if;

            when WB_MEM_PIPE_LD =>
               s_ram_addr_out <= std_logic_vector(unsigned(s_ram_addr_out) + 1);
               s_wb_ack       <= f_to_logic(unsigned(s_pipe_count_rd) = 0);
               s_wb_rdat      <= std_logic_vector(resize(unsigned(i_ram_dq), o_wb_rdat'length));               
               
               if (unsigned(s_pipe_count_rd) > 0) then
                  s_pipe_count_rd   <= std_logic_vector(unsigned(s_pipe_count_rd) - 1);
               end if;
                                          
            when WB_MEM_WR =>
               s_wb_ack    <= f_to_logic(s_wb_fsm_next = WB_MEM_WR);
                
               if ((i_wb_cyc and i_wb_stb) = '1') then
                  s_ram_addr  <= std_logic_vector(unsigned(s_ram_addr) + 1);
                  
                  s_ram_addr_out <= s_ram_addr;
                  s_ram_be       <= std_logic_vector(resize(unsigned(i_wb_sel), s_ram_be'length));
                  s_ram_wdat     <= std_logic_vector(resize(unsigned(i_wb_wdat), s_ram_wdat'length));                    
               end if;
            
            when others =>
         end case;
      end if;
   end process;
End Rtl;
