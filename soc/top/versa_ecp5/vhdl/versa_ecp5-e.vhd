
--    
--    Copyright Ingenieurbuero Gardiner, 2021
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--   
--------------------------------------------------------------------------------
--
-- File ID    : $Id: versa_ecp5-e.vhd 16 2021-10-05 12:33:32Z  $
-- Generated  : $LastChangedDate: 2021-10-05 14:33:32 +0200 (Tue, 05 Oct 2021) $
-- Revision   : $LastChangedRevision: 16 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Entity versa_ecp5 is
   Port (
      REFCLK_P          : in  std_logic;
      REFCLK_N          : in  std_logic;
      PERST_N           : in  std_logic;
      HDIN_P0           : in  std_logic;
      HDIN_N0           : in  std_logic;

      CLK_RESET_N       : out std_logic;
      DL_UP             : out std_logic;
      HDOUT_N0          : out std_logic;
      HDOUT_P0          : out std_logic;
      LTSSM_S3          : out std_logic;
      LTSSM_S2          : out std_logic;
      LTSSM_S1          : out std_logic;
      LTSSM_S0          : out std_logic;
      TICK_CLK          : out std_logic
      );
      
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute DRIVE      : string;   -- 20, 16, 12 (def.), 8, 4
   attribute IO_TYPE    : string;   -- LVTTL33, LVCMOS33
   attribute LOC        : string;
   attribute PULLMODE   : string;   -- UP, DOWN, NONE
   attribute SLEWRATE   : string;   -- FAST, SLOW

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute IO_TYPE of CLK_RESET_N    : signal is "LVCMOS33";
   attribute IO_TYPE of DL_UP          : signal is "LVCMOS25";
   attribute IO_TYPE of LTSSM_S0       : signal is "LVCMOS25";
   attribute IO_TYPE of LTSSM_S1       : signal is "LVCMOS25";
   attribute IO_TYPE of LTSSM_S2       : signal is "LVCMOS25";
   attribute IO_TYPE of LTSSM_S3       : signal is "LVCMOS25";
   attribute IO_TYPE of TICK_CLK       : signal is "LVCMOS25";
   attribute IO_TYPE of PERST_N        : signal is "LVCMOS33";

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute LOC of CLK_RESET_N        : signal is "R1";
   attribute LOC of DL_UP              : signal is "E18";  
   attribute LOC of LTSSM_S0           : signal is "F16";  -- USER0      
   attribute LOC of LTSSM_S1           : signal is "E17";  -- USER1
   attribute LOC of LTSSM_S2           : signal is "F18";  -- USER2 
   attribute LOC of LTSSM_S3           : signal is "F17";  -- USER3    
   attribute LOC of TICK_CLK           : signal is "E16";
   attribute LOC of PERST_N            : signal is "A6";
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   attribute PULLMODE   of PERST_N     : signal is "UP";   
End versa_ecp5;
