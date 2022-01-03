Library IEEE;
Use IEEE.std_logic_1164.all;

Package versa_ecp5_tb_pkg is
   signal REFCLK_P      : std_logic := '0';
   signal REFCLK_N      : std_logic := '0';
   signal PERST_N       : std_logic := '0';
   signal HDIN_P0       : std_logic := '1';
   signal HDIN_N0       : std_logic := '0';
   signal CLK_RESET_N   : std_logic;
   signal DL_UP         : std_logic;
   signal HDOUT_N0      : std_logic;
   signal HDOUT_P0      : std_logic;
   signal LTSSM_S3      : std_logic;
   signal LTSSM_S2      : std_logic;
   signal LTSSM_S1      : std_logic;
   signal LTSSM_S0      : std_logic;
   signal TICK_CLK      : std_logic;

   Component versa_ecp5
      Port (
         REFCLK_P       : in std_logic;
         REFCLK_N       : in std_logic;
         PERST_N        : in std_logic;
         HDIN_P0        : in std_logic;
         HDIN_N0        : in std_logic;
         
         CLK_RESET_N    : out std_logic;
         DL_UP          : out std_logic;
         HDOUT_N0       : out std_logic;
         HDOUT_P0       : out std_logic;
         LTSSM_S3       : out std_logic;
         LTSSM_S2       : out std_logic;
         LTSSM_S1       : out std_logic;
         LTSSM_S0       : out std_logic;
         TICK_CLK       : out std_logic
         );
   End Component;
End versa_ecp5_tb_pkg;
