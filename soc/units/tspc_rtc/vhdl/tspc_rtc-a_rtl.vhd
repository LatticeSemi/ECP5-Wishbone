
--
--    Copyright Ing. Buero Gardiner 2008 - 2012
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_rtc-a_rtl.vhd 4977 2019-10-18 18:18:15Z  $
-- Generated   : $LastChangedDate: 2019-10-18 20:18:15 +0200 (Fri, 18 Oct 2019) $
-- Revision    : $LastChangedRevision: 4977 $
--
--------------------------------------------------------------------------------
--
-- Description :
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.tspc_utils.all;

Architecture Rtl of tspc_rtc is
   constant c_prescale_sz  : natural := f_vec_size(g_prescale);
   constant c_rtc_time_sz  : natural := o_rtc'length;
   
   constant c_prescale_load   : std_logic_vector(c_prescale_sz - 1 downto 0) :=
                                    std_logic_vector(to_unsigned(g_prescale - 1, c_prescale_sz));
                                    
   signal s_gate           : std_logic;
   signal s_prescale       : std_logic_vector(c_prescale_sz - 1 downto 0);
   signal s_prescale_eq0   : std_logic;
   signal s_rtc_ev         : std_logic;
   signal s_rtc_time       : std_logic_vector(c_rtc_time_sz - 1 downto 0);
   
Begin
   o_rtc       <= s_rtc_time;
   
   o_rtc_ev    <= s_rtc_ev;
   o_rtc_tick  <= s_gate;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_MAIN:
   process (i_clk, i_rst_n) is
   begin
      if (i_rst_n = '0') then
         s_gate            <= '0';
         s_prescale        <= (others => '0');
         s_prescale_eq0    <= '0';
         s_rtc_ev          <= '0';
         s_rtc_time        <= (others => '0');
         
      elsif (rising_edge(i_clk)) then
         s_gate            <= s_prescale_eq0;
         s_prescale_eq0    <= f_to_logic(unsigned(s_prescale) = 1) or
                              f_to_logic(g_prescale = 0);

         if (s_prescale_eq0 = '1') then
            s_prescale  <= c_prescale_load;       
         else
            s_prescale  <= std_logic_vector(unsigned(s_prescale) - 1);
         end if;
         
         if (s_gate = '1') then
            s_rtc_ev    <= not s_rtc_ev;
            s_rtc_time  <= std_logic_vector(unsigned(s_rtc_time) + 1);
         end if;
      end if;
   end process;
End Rtl;
