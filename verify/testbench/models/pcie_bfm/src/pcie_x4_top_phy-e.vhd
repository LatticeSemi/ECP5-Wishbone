--------------------------------------------------------------------------------
--
-- File ID     : $Id: pcie_x4_top_phy-e.vhd 33 2021-11-16 22:43:39Z  $
-- Generated   : $LastChangedDate: 2021-11-16 23:43:39 +0100 (Tue, 16 Nov 2021) $
-- Revision    : $LastChangedRevision: 33 $
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity pcie_x4_top_phy is
   Port (
      pll_refclki         :  in std_logic;
      rxrefclk            :  in std_logic;
      RESET_n             :  in std_logic;
      pcie_ip_rstn        :  out std_logic;

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

      hdinp1               : in  std_logic ;
      hdinn1               : in  std_logic ;
      hdoutp1              : out std_logic;
      hdoutn1              : out std_logic;
      RxValid_1            : out std_logic;
      RxElecIdle_1         : out std_logic;
      TxData_1             : in  std_logic_vector(7 downto 0);
      RxData_1             : out std_logic_vector(7 downto 0);
      TxElecIdle_1         : in  std_logic;
      TxCompliance_1       : in  std_logic;
      TxDataK_1            : in  std_logic_vector(0 downto 0);
      RxDataK_1            : out std_logic_vector(0 downto 0);
      RxStatus_1           : out std_logic_vector(2 downto 0);
      RxPolarity_1         : in  std_logic;

      hdinp2               : in  std_logic;
      hdinn2               : in  std_logic;
      hdoutp2              : out std_logic;
      hdoutn2              : out std_logic;
      RxValid_2            : out std_logic;
      RxElecIdle_2         : out std_logic;
      TxData_2             : in  std_logic_vector(7 downto 0);
      RxData_2             : out std_logic_vector(7 downto 0);
      TxElecIdle_2         : in  std_logic;
      TxCompliance_2       : in  std_logic;
      TxDataK_2            : in  std_logic_vector(0 downto 0);
      RxDataK_2            : out std_logic_vector(0 downto 0);
      RxStatus_2           : out std_logic_vector(2 downto 0);
      RxPolarity_2         : in  std_logic;

      hdinp3               : in  std_logic;
      hdinn3               : in  std_logic;
      hdoutp3              : out std_logic;
      hdoutn3              : out std_logic;
      RxValid_3            : out std_logic;
      RxElecIdle_3         : out std_logic;
      TxData_3             : in  std_logic_vector(7 downto 0);
      RxData_3             : out std_logic_vector(7 downto 0);
      TxElecIdle_3         : in  std_logic;
      TxCompliance_3       : in  std_logic;
      TxDataK_3            : in  std_logic_vector(0 downto 0);
      RxDataK_3            : out std_logic_vector(0 downto 0);
      RxStatus_3           : out std_logic_vector(2 downto 0);
      RxPolarity_3         : in  std_logic;

      scisel_0             : in  std_logic;
      scien_0              : in  std_logic;
      scisel_1             : in  std_logic;
      scien_1              : in  std_logic;
      scisel_2             : in  std_logic;
      scien_2              : in  std_logic;
      scisel_3             : in  std_logic;
      scien_3              : in  std_logic;
      sciwritedata        :  in std_logic_vector(7 downto 0);
      sciaddress          :  in std_logic_vector(5 downto 0);
      sciselaux           :  in std_logic;
      scienaux            :  in std_logic;
      scird               :  in std_logic;
      sciwstn             :  in std_logic;
      scireaddata         :  out std_logic_vector(7 downto 0);
      ffs_plol            :  out std_logic;      

      flip_lanes          :  in std_logic;
      PCLK                :  out std_logic;
      PCLK_by_2           :  out std_logic;            
      TxDetectRx_Loopback :  in std_logic;
      PhyStatus           :  out std_logic;      
      PowerDown           :  in std_logic_vector(1 downto 0);

      ctc_disable         :  in std_logic ;
      phy_ltssm_state     :  in std_logic_vector(3 downto 0) := (others => '0');
      phy_l0              :  in std_logic;
      phy_cfgln           :  in std_logic_vector(3 downto 0)

      );
End pcie_x4_top_phy;