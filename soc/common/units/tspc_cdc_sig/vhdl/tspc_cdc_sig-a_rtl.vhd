
--    
--    Copyright Ing. Buero Gardiner, 2007 - 2021
--     
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_cdc_sig-a_rtl.vhd 5254 2021-01-18 09:21:05Z  $
-- Generated   : $LastChangedDate: 2021-01-18 10:21:05 +0100 (Mon, 18 Jan 2021) $
-- Revision    : $LastChangedRevision: 5254 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--    
--------------------------------------------------------------------------------

Architecture Rtl of tspc_cdc_sig is
   signal s_cdc_guard   : std_logic_vector(g_stages - 1 downto 0);
   signal s_cdc_sync    : std_logic;
   signal s_rst_done    : std_logic_vector(1 downto 0);
   signal s_rst_sync_n  : std_logic;
   
Begin
   o_cdc_out   <= s_cdc_guard(s_cdc_guard'left );

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_rst_sync_n   <= i_rst_n and s_rst_done(s_rst_done'left);
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_RST:
   process (i_clk, i_rst_n)
   begin
      if (i_rst_n = '0') then
         s_rst_done     <= (others => '0');
      elsif (rising_edge(i_clk)) then
         s_rst_done        <= s_rst_done(s_rst_done'left - 1 downto 0) & '1';
      end if;
   end process;         
      
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   R_MAIN:
   process (i_clk, s_rst_sync_n)
   begin
      if (s_rst_sync_n = '0') then
         s_cdc_guard    <= (others => '0');
         s_cdc_sync     <= '0';
      elsif (rising_edge(i_clk)) then
         s_cdc_guard(0)    <= s_cdc_sync;
         s_cdc_sync        <= i_cdc_in;        
         
         if (g_stages > 1) then
            for ix in 1 to g_stages loop
               s_cdc_guard(ix)   <= s_cdc_guard(ix - 1);
            end loop;
         end if;
      end if;
   end process;   
End Rtl;
      
