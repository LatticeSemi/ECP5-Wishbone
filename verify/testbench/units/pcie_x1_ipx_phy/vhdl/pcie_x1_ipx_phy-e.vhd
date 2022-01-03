--------------------------------------------------------------------------------
--
-- File ID     : $Id: pcie_x1_ipx_phy-e.vhd 46 2021-11-18 22:45:40Z  $
-- Generated   : $LastChangedDate: 2021-11-18 23:45:40 +0100 (Thu, 18 Nov 2021) $
-- Revision    : $LastChangedRevision: 46 $
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity pcie_x1_ipx_phy is
   generic (
      g_no_scrambling   : std_logic := '0'
      );
   port(
      refclkp              : in  std_logic;
      refclkn              : in  std_logic;
      RESET_n              : in  std_logic;
      pcie_ip_rstn         : out std_logic;

      hdinp0               : in  std_logic;
      hdinn0               : in  std_logic;
      hdoutp0              : out std_logic;
      hdoutn0              : out std_logic;
      RxValid_0            : out std_logic;
      RxElecIdle_0         : out std_logic;
      TxData_0             : in  std_logic_vector(7 downto 0);
      RxData_0             : out std_logic_vector(7 downto 0);
      TxElecIdle_0         : in  std_logic;
      TxCompliance_0       : in  std_logic;
      TxDataK_0            : in  std_logic_vector(0 downto 0);
      RxDataK_0            : out std_logic_vector(0 downto 0);
      RxStatus_0           : out std_logic_vector(2 downto 0);
      RxPolarity_0         : in  std_logic;

      hdinp1               : in  std_logic := '0';
      hdinn1               : in  std_logic := '0';
      hdoutp1              : out std_logic;
      hdoutn1              : out std_logic;
      RxValid_1            : out std_logic;
      RxElecIdle_1         : out std_logic;
      TxData_1             : in  std_logic_vector(7 downto 0) := "00000000";
      RxData_1             : out std_logic_vector(7 downto 0);
      TxElecIdle_1         : in  std_logic := '0';
      TxCompliance_1       : in  std_logic := '0';
      TxDataK_1            : in  std_logic_vector(0 downto 0) := "0";
      RxDataK_1            : out std_logic_vector(0 downto 0);
      RxStatus_1           : out std_logic_vector(2 downto 0);
      RxPolarity_1         : in  std_logic := '0';

      hdinp2               : in  std_logic := '0';
      hdinn2               : in  std_logic := '0';
      hdoutp2              : out std_logic;
      hdoutn2              : out std_logic;
      RxValid_2            : out std_logic;
      RxElecIdle_2         : out std_logic;
      TxData_2             : in  std_logic_vector(7 downto 0):= "00000000";
      RxData_2             : out std_logic_vector(7 downto 0);
      TxElecIdle_2         : in  std_logic := '0';
      TxCompliance_2       : in  std_logic := '0';
      TxDataK_2            : in  std_logic_vector(0 downto 0) := "0";
      RxDataK_2            : out std_logic_vector(0 downto 0);
      RxStatus_2           : out std_logic_vector(2 downto 0);
      RxPolarity_2         : in  std_logic := '0';

      hdinp3               : in  std_logic := '0';
      hdinn3               : in  std_logic := '0';
      hdoutp3              : out std_logic;
      hdoutn3              : out std_logic;
      RxValid_3            : out std_logic;
      RxElecIdle_3         : out std_logic;
      TxData_3             : in  std_logic_vector(7 downto 0):= "00000000";
      RxData_3             : out std_logic_vector(7 downto 0);
      TxElecIdle_3         : in  std_logic := '0';
      TxCompliance_3       : in  std_logic := '0';
      TxDataK_3            : in  std_logic_vector(0 downto 0) := "0";
      RxDataK_3            : out std_logic_vector(0 downto 0);
      RxStatus_3           : out std_logic_vector(2 downto 0);
      RxPolarity_3         : in  std_logic := '0';

      sci_addr             : in  std_logic_vector(5 downto 0) := (others => '0');
      sci_en               : in  std_logic := '0';
      sci_en_ch0           : in  std_logic := '0';
      sci_en_ch1           : in  std_logic := '0';
      sci_en_ch2           : in  std_logic := '0';
      sci_en_ch3           : in  std_logic := '0';
      sci_rd               : in  std_logic := '0';
      sci_sel              : in  std_logic := '0';
      sci_sel_ch0          : in  std_logic := '0';      
      sci_sel_ch1          : in  std_logic := '0';      
      sci_sel_ch2          : in  std_logic := '0';      
      sci_sel_ch3          : in  std_logic := '0';      
      sci_wrdata           : in  std_logic_vector(7 downto 0) := (others => '0');
      sci_wrn              : in  std_logic := '0';
      sci_rddata           : out std_logic_vector(7 downto 0);

      ffs_plol             : out std_logic;
      ffs_rlol_ch0         : out std_logic;

      flip_lanes           : in  std_logic := '0';
      PCLK                 : out std_logic;
      PCLK_by_2            : out std_logic;
      TxDetectRx_Loopback  : in  std_logic;
      PhyStatus            : out std_logic;
      PowerDown            : in  std_logic_vector(1 downto 0);

      ctc_disable          : in  std_logic;
      phy_ltssm_state      : in  std_logic_vector(3 downto 0) := (others => '0');
      phy_l0               : in  std_logic := '0';
      phy_cfgln            : in  std_logic_vector(3 downto 0);
      
      sli_rst              : in  std_logic := '0';
      tx_pwrup_c           : out std_logic;
      serdes_pdb           : out std_logic;
      serdes_rst_dual_c    : out std_logic;
      tx_serdes_rst_c      : out std_logic
    );
End Entity pcie_x1_ipx_phy;
