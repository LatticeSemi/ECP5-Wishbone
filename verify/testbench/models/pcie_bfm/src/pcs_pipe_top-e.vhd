--------------------------------------------------------------------------------
--
-- File ID     : $Id: pcs_pipe_top-e.vhd 33 2021-11-16 22:43:39Z  $
-- Generated   : $LastChangedDate: 2021-11-16 23:43:39 +0100 (Tue, 16 Nov 2021) $
-- Revision    : $LastChangedRevision: 33 $
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity pcs_pipe_top is
   generic (
      g_no_scrambling   : std_logic := '0'
      );
   port(
      refclkp              : in  std_logic;         
      refclkn              : in  std_logic;         
      ffc_quad_rst         : in  std_logic := '0';     
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
                  
      scisel_0             : in  std_logic;         
      scien_0              : in  std_logic;         
      scisel_1             : in  std_logic := '0';         
      scien_1              : in  std_logic := '0';  
      scisel_2             : in  std_logic := '0';         
      scien_2              : in  std_logic := '0';   
      scisel_3             : in  std_logic := '0';         
      scien_3              : in  std_logic := '0';                
      sciwritedata         : in  std_logic_vector(7 downto 0);
      sciaddress           : in  std_logic_vector(5 downto 0);
      scireaddata          : out std_logic_vector(7 downto 0);
      sciselaux            : in  std_logic;
      scienaux             : in  std_logic;
      scird                : in  std_logic;
      sciwstn              : in  std_logic;
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
      phy_cfgln            : in  std_logic_vector(3 downto 0)
    );
End Entity pcs_pipe_top;
