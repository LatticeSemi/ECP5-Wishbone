--------------------------------------------------------------------------------
--
-- File ID     : $Id: pcie_x1_top_phy-e.vhd 17 2021-10-05 18:21:48Z  $
-- Generated   : $LastChangedDate: 2021-10-05 20:21:48 +0200 (Tue, 05 Oct 2021) $
-- Revision    : $LastChangedRevision: 17 $
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity x_pcie_phy is
   Port(
      pll_refclki          : in  std_logic;
      rxrefclk             : in  std_logic;
      RESET_n              : in  std_logic;

      PowerDown            : in  std_logic_vector(1 downto 0);
      TxDetectRx_Loopback  : in  std_logic;

      pcie_ip_rstn         : out std_logic;
      PCLK                 : out std_logic;
      PCLK_by_2            : out std_logic;
      PhyStatus            : out std_logic;
      ffs_plol             : out std_logic;
                              
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

      ffs_rlol_ch0         : out std_logic;
      
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

      tx_pwrup_c           : out std_logic;
      serdes_pdb           : out std_logic;
      serdes_rst_dual_c    : out std_logic;
      tx_serdes_rst_c      : out std_logic;
      sli_rst              : in  std_logic;
      
      sci_wrdata           : in  std_logic_vector(7 downto 0);
      sci_addr             : in  std_logic_vector(5 downto 0);
      sci_rddata           : out std_logic_vector(7 downto 0);
      sci_en_dual          : in  std_logic;
      sci_sel_dual         : in  std_logic;
      sci_wrn              : in  std_logic;
      sci_rd               : in  std_logic;
      sci_int              : out std_logic;
      sci_sel              : in  std_logic;
      sci_en               : in  std_logic;
            
      phy_l0               : in  std_logic := '0';
      phy_cfgln            : in  std_logic_vector(3 downto 0);
      ctc_disable          : in  std_logic;
      flip_lanes           : in  std_logic := '0'
    );
End Entity x_pcie_phy;
