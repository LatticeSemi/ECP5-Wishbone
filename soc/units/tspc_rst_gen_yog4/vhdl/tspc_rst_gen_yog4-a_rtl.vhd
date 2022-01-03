
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
-- File ID     : $Id: tspc_rst_gen_yog4-a_rtl.vhd 5292 2021-03-07 01:02:25Z  $
-- Generated   : $LastChangedDate: 2021-03-07 02:02:25 +0100 (Sun, 07 Mar 2021) $
-- Revision    : $LastChangedRevision: 5292 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------
Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.tspc_utils.all;

Architecture Rtl of tspc_rst_gen_yog4 is
   constant c_seq_flow_num_ops   : positive := 4;
   
   type t_opcode  is (opc_init_t0, opc_init, opc_rst_wait, opc_rst_clr, opc_rst_done);

   subtype t_rst_count  is std_logic_vector(f_num_bits(g_rst_count - 1) - 1 downto 0);
   subtype t_seq_ptr    is std_logic_vector(f_num_bits(t_opcode'pos(t_opcode'high) ) - 1 downto 0);
   
   type t_seq_instr is
      record
         op_code     : t_opcode;
         rst_active  : std_logic;
         seq_ptr     : t_seq_ptr;
      end record;
      
   type t_seq_flow   is array (natural range <>) of t_seq_instr;
      
   constant c_count_init      : t_rst_count := std_logic_vector(to_unsigned(g_rst_count - 1, t_rst_count'length ));                                                  
   
   constant c_seq_init        : t_seq_instr := (op_code => opc_init, rst_active => '1', 
                                                seq_ptr => std_logic_vector(to_unsigned(0, t_seq_ptr'length )));
   constant c_seq_init_t0     : t_seq_instr := (op_code => opc_init, rst_active => '1', 
                                                seq_ptr => std_logic_vector(to_unsigned(0, t_seq_ptr'length )));
   constant c_seq_rst_clr     : t_seq_instr := (op_code => opc_rst_clr, rst_active => '0', 
                                                seq_ptr => std_logic_vector(to_unsigned(2, t_seq_ptr'length )));
   constant c_seq_rst_done    : t_seq_instr := (op_code => opc_rst_done, rst_active => '0', 
                                                seq_ptr => std_logic_vector(to_unsigned(3, t_seq_ptr'length )));
   constant c_seq_rst_wait    : t_seq_instr := (op_code => opc_rst_wait, rst_active => '1', 
                                                seq_ptr => std_logic_vector(to_unsigned(1, t_seq_ptr'length )));
  
   constant c_seq_flow_init   : t_seq_flow   := (0 => c_seq_init_t0,
                                                 1 => c_seq_rst_wait,
                                                 2 => c_seq_rst_clr,
                                                 3 => c_seq_rst_done);

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   signal s_instr          : t_seq_instr;
   signal s_instr_next     : t_seq_instr;  
   signal s_rst_count      : t_rst_count;
   signal s_rst_out        : std_logic;
   signal s_seq_flow       : t_seq_flow(c_seq_flow_init'range ) := c_seq_flow_init;
   signal s_seq_ptr        : t_seq_ptr;
   signal s_trip_ev        : std_logic;
   signal s_trip_guard     : std_logic_vector(1 downto 0);
   signal s_trip_sync      : std_logic;   
   
Begin
   o_rst_n     <= not s_rst_out;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_instr        <= s_seq_flow(0);      
      
   s_trip_ev      <= s_trip_guard(s_trip_guard'left - 1) and not s_trip_guard(s_trip_guard'left );
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_COMB:
   process (all)
   begin
      s_instr_next   <= s_seq_flow(to_integer(unsigned(s_seq_ptr)));
      
      case s_instr.op_code is
         when opc_init =>
            s_seq_ptr      <= f_incr(s_instr.seq_ptr);
            
         when opc_rst_wait =>            
            if (unsigned(s_rst_count) = 0) then
               s_seq_ptr      <= f_incr(s_instr.seq_ptr);
            else
               s_seq_ptr      <= s_instr.seq_ptr;
            end if;
         
         when opc_rst_clr =>
            s_seq_ptr      <= f_incr(s_instr.seq_ptr);
            
         when opc_rst_done =>            
            if (s_trip_ev = '1') then
               s_instr_next   <= c_seq_init;
               s_seq_ptr      <= (others => '0');
            else
               s_seq_ptr   <= s_instr.seq_ptr;
            end if;
            
         when others =>
            s_instr_next   <= c_seq_init;
            s_seq_ptr      <= (others => '0');
            
      end case;
   end process;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_MAIN:
   process (i_clk)
   begin
      if (rising_edge(i_clk)) then
         s_seq_flow(0)  <= s_instr_next;
         
         s_trip_sync    <= i_trip_ev;
         s_trip_guard   <= s_trip_guard(s_trip_guard'left - 1 downto 0) & s_trip_sync;      
         
         case s_instr.op_code is
            when opc_init =>
               s_rst_count    <= c_count_init;
               
            when opc_rst_wait =>
               s_rst_count    <= f_decr(s_rst_count);
               
            when others =>
               null;
         end case;
      end if;
   end process;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_RST:
   process (i_clk, s_instr.rst_active)
   begin
      if (s_instr.rst_active = '1') then
         s_rst_out   <= '1';
      elsif (rising_edge(i_clk)) then
         s_rst_out   <= '0';
      end if;
   end process;   
End Rtl;
