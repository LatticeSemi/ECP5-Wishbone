
--
--    Copyright Ingenieurbuero Gardiner, 2007 - 2014
--
--    All Rights Reserved
--
--       This proprietary software may be used only as authorised in a licensing,
--       product development or training agreement.
--
--       Copies may only be made to the extent permitted by such an aforementioned
--       agreement. This entire notice above must be reproduced on
--       all copies.
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: b4sq_pcie_svc-e.vhd 3846 2017-12-27 17:42:58Z  $
-- Generated   : $LastChangedDate: 2017-12-27 18:42:58 +0100 (Wed, 27 Dec 2017) $
-- Revision    : $LastChangedRevision: 3846 $
--
--------------------------------------------------------------------------------
--
-- Description : Utility module as add-on to Lattice PCIe core
--               Provides additional functionality such as MSI/Legacy Interrupt
--               selection
--------------------------------------------------------------------------------

Library IEEE;

Use IEEE.std_logic_1164.all;

Entity b4sq_pcie_svc is
   Port (
      i_clk_125               : in  std_logic;
      i_rst_n                 : in  std_logic;
      
      i_dev_cntl_reg          : in  std_logic_vector(14 downto 0);
      i_dl_up                 : in  std_logic;
      i_hdr_4dw               : in  std_logic;
      i_int_req               : in  std_logic_vector(7 downto 0);
      i_ipcore_rst_n          : in  std_logic;
      i_link_cntl_reg         : in  std_logic_vector(7 downto 0);
      i_mm_enable             : in  std_logic_vector(2 downto 0);
      i_msi_enable            : in  std_logic;
      i_pci_cmd_reg           : in  std_logic_vector(5 downto 0);
      i_phy_ltssm_state       : in  std_logic_vector(3 downto 0);
      i_phy_ltssm_substate    : in  std_logic_vector(2 downto 0);
      i_tx_ca_p_recheck       : in  std_logic;
      i_tx_end                : in  std_logic;
      i_tx_nlfy               : in  std_logic;
      i_tx_start              : in  std_logic;
      
      o_dis_intx              : out std_logic;
      o_dis_link              : out std_logic;
      o_dl_up                 : out std_logic;
      o_en_bus_mst            : out std_logic;
      o_en_io_space           : out std_logic;
      o_en_mem_space          : out std_logic;
      o_en_no_snoop           : out std_logic;
      o_en_perr               : out std_logic;
      o_en_serr               : out std_logic;
      o_en_tag_extend         : out std_logic;
      o_func_rst              : out std_logic;
      o_header_active         : out std_logic;
      o_hot_rst               : out std_logic;
      o_inta                  : out std_logic;
      o_max_payload_size      : out std_logic_vector(2 downto 0);
      o_max_read_request      : out std_logic_vector(2 downto 0);
      o_msi_req               : out std_logic_vector(7 downto 0);
      o_payload_active        : out std_logic;
      o_phy_ltssm_state       : out std_logic_vector(3 downto 0);
      o_phy_ltssm_substate    : out std_logic_vector(2 downto 0);
      o_rcb_128_byte          : out std_logic;
      o_synced_rst_n          : out std_logic
      );
End b4sq_pcie_svc; 
