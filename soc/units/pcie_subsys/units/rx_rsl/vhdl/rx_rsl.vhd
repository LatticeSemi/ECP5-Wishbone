--    
--    Copyright Lattice Semiconductor
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: rx_rsl.vhd 17 2021-10-05 18:21:48Z  $
-- Generated  : $LastChangedDate: 2021-10-05 20:21:48 +0200 (Tue, 05 Oct 2021) $
-- Revision   : $LastChangedRevision: 17 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--       Imported from Lattice Product Bulletin FPGA_PB_02001
--       "Workaround for Lattice ECP5(LFE5UM) Known Issue with
--        SerDes Interface COnnections Due to Unstable Reset Soft Logic"
--       June 2021
--
--    Contains update to use IEEE.numeric_std instead of IEEE.std_logic_unsigned and 
--    IEEE.std_logic_arith
--
--    User should import this file into PCIe after Clarity DRC/Generate as
--    described in the document.
--    Template can be found under soc_impl directory system in this project
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

 entity rx_rsl is 
   port ( 
      rstn                 : in std_logic;
      refclk               : in std_logic;
      pll_lol              : in std_logic;
      cdr_lol              : in std_logic;
      cv                   : in std_logic;
      lsm                  : in std_logic;
      los                  : in std_logic;
      disable_rx_pcs_rst   : in std_logic;
      rx_serdes_rst        : out std_logic;
      rx_pcs_rst           : out std_logic
      );
end rx_rsl;
 
library IEEE;
use IEEE.numeric_std.all;
 
 architecture rx_rsl_arc of rx_rsl is 
   attribute syn_keep : boolean;
 ------------------------------------------------------------------------------------------------------
 -- Constants Declaration 
 ------------------------------------------------------------------------------------------------------
   constant Tplol    : unsigned (31 downto 0) := X"00100000";
   constant Tcdr     : unsigned (31 downto 0) := X"00100000";
   constant Tviol    : unsigned (31 downto 0) := X"00100000";
   
 ----------------------------------------------------------------------------------------------------- 
 -- Internal Variables
 ----------------------------------------------------------------------------------------------------- 
   type rx_sm_state is (powerup, apply_cdr_rst, wait_cdr_lock, test_cdr, apply_rxpcs_rst, 
                        wait_rxpcs_lock, test_rxpcs, idle);
                        
   signal pll_lol_s  : std_logic;
   signal cdr_lol_s  : std_logic;
   signal cv_s       : std_logic;
   signal lsm_s      : std_logic;
   signal los_s      : std_logic;
   signal cnt        : unsigned(31 downto 0);
   signal rx_sm      : rx_sm_state;
   
   attribute syn_keep of rx_sm : signal is true;
   
 begin 
   ------------------------------------------------------------------------------------------------------ 
   -- Begin Of The Design 
   ------------------------------------------------------------------------------------------------------
   rx_reset_proc : 
   process (rstn, refclk) 
   begin 
      if rstn = '0' then 
         pll_lol_s      <= '1';
         cdr_lol_s      <= '1';
         cv_s           <= '1';
         lsm_s          <= '0';
         los_s          <= '1';
         rx_serdes_rst  <= '1';
         rx_pcs_rst     <= '1';
         rx_sm          <= powerup;
         cnt            <= (others => '0');
         
      elsif rising_edge(refclk) then 
         pll_lol_s   <= pll_lol;
         cdr_lol_s   <= cdr_lol;
         cv_s        <= cv;
         lsm_s       <= lsm;
         los_s       <= los;
         
         case rx_sm is 
            when powerup => 
               rx_serdes_rst  <= '1';
               rx_pcs_rst     <= '1' AND NOT(disable_rx_pcs_rst);
               
               if (pll_lol_s = '1') or (los_s = '1') then 
                  cnt   <= (others => '0');
               else 
                  if (cnt = Tplol) then 
                     cnt      <= (others => '0');
                     rx_sm    <= apply_cdr_rst;
                  else 
                     cnt   <= cnt + 1;
                  end if;
               end if;

            when apply_cdr_rst => 
               rx_serdes_rst  <= '1';
               rx_pcs_rst     <= '1' AND NOT(disable_rx_pcs_rst);
               
               if (cnt = x"00000007") then 
                  cnt      <= (others => '0');
                  rx_sm    <= wait_cdr_lock;
               else 
                  cnt   <= cnt + 1;
               end if;
               
            when wait_cdr_lock => 
               rx_serdes_rst  <= '0';
               rx_pcs_rst     <= '1' AND NOT(disable_rx_pcs_rst);
               
               if (cnt = Tcdr) then 
                  cnt      <= (others => '0');
                  rx_sm    <= test_cdr;
               else 
                  cnt   <= cnt + 1;
               end if;
               
            when test_cdr => 
               rx_serdes_rst  <= '0';
               rx_pcs_rst     <= '1' AND NOT(disable_rx_pcs_rst);
               
               if (cdr_lol_s = '1') then 
                  cnt      <= (others => '0');
                  rx_sm    <= apply_cdr_rst;
               else 
                  if (cnt = Tcdr) then 
                     cnt      <= (others => '0');
                     rx_sm    <= apply_rxpcs_rst;
                  else 
                     cnt   <= cnt + '1';
                  end if;
               end if;

            when apply_rxpcs_rst => 
               rx_serdes_rst  <= '0';
               rx_pcs_rst     <= '1' AND NOT(disable_rx_pcs_rst);
               
               if (cnt = x"00000007") then 
                  cnt      <= (others => '0');
                  rx_sm    <= wait_rxpcs_lock;
               else 
                  cnt   <= cnt + 1;
               end if;
               
            when wait_rxpcs_lock => 
               rx_serdes_rst  <= '0';
               rx_pcs_rst     <= '0';
               
               if (cnt = Tviol) then 
                  cnt      <= (others => '0');
                  rx_sm    <= test_rxpcs;
               else 
                  cnt <= cnt + 1;
               end if;
 
            when test_rxpcs => 
               rx_serdes_rst  <= '0';
               rx_pcs_rst     <= '0';
               
               if (lsm_s = '0') or (cv_s = '1') then 
                  cnt      <= (others => '0');
                  rx_sm    <= apply_rxpcs_rst;
               else 
                  if (cnt = Tviol) then 
                     cnt      <= (others => '0');
                     rx_sm    <= idle;
                  else 
                     cnt   <= cnt + 1;
                  end if;
               end if;

            when idle => 
               rx_serdes_rst  <= '0';
               rx_pcs_rst     <= '0';
               
               if (lsm_s = '0') or (cv_s = '1') then 
                  rx_sm    <= apply_rxpcs_rst;
                  cnt      <= (others => '0');
               end if;
         end case;
         
         if (pll_lol_s = '1') or (los_s = '1') then 
            rx_sm    <= powerup;
            cnt      <= (others => '0');
         end if;
      end if;
   end process rx_reset_proc;
end rx_rsl_arc;
