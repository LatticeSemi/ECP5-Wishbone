Library IEEE;
 
use IEEE.std_logic_1164.all;

Package versa_ecp3_tb_pkg is
   signal REFCLK_P: std_logic := '0';
   signal REFCLK_N: std_logic := '0';
   signal PERST_N : std_logic := '0';
   signal HDIN_P0 : std_logic := '1';
   signal HDIN_N0 : std_logic := '0';
   signal DL_UP   : std_logic;
   signal HDOUT_N0: std_logic;
   signal HDOUT_P0: std_logic;
   signal LTSSM_S3: std_logic;
   signal LTSSM_S2: std_logic;
   signal LTSSM_S1: std_logic;
   signal LTSSM_S0: std_logic;

   Component versa_ecp3
      Port (
         REFCLK_P : in std_logic;
         REFCLK_N : in std_logic;
         PERST_N  : in std_logic;
         HDIN_P0  : in std_logic;
         HDIN_N0  : in std_logic;
         
         DL_UP    : out std_logic;
         HDOUT_N0 : out std_logic;
         HDOUT_P0 : out std_logic;
         LTSSM_S3 : out std_logic;
         LTSSM_S2 : out std_logic;
         LTSSM_S1 : out std_logic;
         LTSSM_S0 : out std_logic
         );
   End Component;
End versa_ecp3_tb_pkg;
