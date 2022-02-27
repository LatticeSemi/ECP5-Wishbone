--
-- Synopsys
-- Vhdl wrapper for top level design, written on Sun Feb 27 17:28:22 2022
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity wrapper_for_rx_rsl is
   port (
      rstn : in std_logic;
      refclk : in std_logic;
      pll_lol : in std_logic;
      cdr_lol : in std_logic;
      cv : in std_logic;
      lsm : in std_logic;
      los : in std_logic;
      disable_rx_pcs_rst : in std_logic;
      rx_serdes_rst : out std_logic;
      rx_pcs_rst : out std_logic
   );
end wrapper_for_rx_rsl;

architecture rx_rsl_arc of wrapper_for_rx_rsl is

component rx_rsl
 port (
   rstn : in std_logic;
   refclk : in std_logic;
   pll_lol : in std_logic;
   cdr_lol : in std_logic;
   cv : in std_logic;
   lsm : in std_logic;
   los : in std_logic;
   disable_rx_pcs_rst : in std_logic;
   rx_serdes_rst : out std_logic;
   rx_pcs_rst : out std_logic
 );
end component;

signal tmp_rstn : std_logic;
signal tmp_refclk : std_logic;
signal tmp_pll_lol : std_logic;
signal tmp_cdr_lol : std_logic;
signal tmp_cv : std_logic;
signal tmp_lsm : std_logic;
signal tmp_los : std_logic;
signal tmp_disable_rx_pcs_rst : std_logic;
signal tmp_rx_serdes_rst : std_logic;
signal tmp_rx_pcs_rst : std_logic;

begin

tmp_rstn <= rstn;

tmp_refclk <= refclk;

tmp_pll_lol <= pll_lol;

tmp_cdr_lol <= cdr_lol;

tmp_cv <= cv;

tmp_lsm <= lsm;

tmp_los <= los;

tmp_disable_rx_pcs_rst <= disable_rx_pcs_rst;

rx_serdes_rst <= tmp_rx_serdes_rst;

rx_pcs_rst <= tmp_rx_pcs_rst;



u1:   rx_rsl port map (
		rstn => tmp_rstn,
		refclk => tmp_refclk,
		pll_lol => tmp_pll_lol,
		cdr_lol => tmp_cdr_lol,
		cv => tmp_cv,
		lsm => tmp_lsm,
		los => tmp_los,
		disable_rx_pcs_rst => tmp_disable_rx_pcs_rst,
		rx_serdes_rst => tmp_rx_serdes_rst,
		rx_pcs_rst => tmp_rx_pcs_rst
       );
end rx_rsl_arc;
