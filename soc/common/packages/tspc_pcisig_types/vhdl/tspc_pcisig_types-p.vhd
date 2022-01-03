
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
-- File ID     : $Id: tspc_pcisig_types-p.vhd 5031 2020-02-23 11:02:51Z  $
-- Generated   : $LastChangedDate: 2020-02-23 12:02:51 +0100 (Sun, 23 Feb 2020) $
-- Revision    : $LastChangedRevision: 5031 $
--
--------------------------------------------------------------------------------
--
-- Description : Utility package for PCI(e) designs
--
--------------------------------------------------------------------------------

Library IEEE;
 
use IEEE.std_logic_1164.all;

Package tspc_pcisig_types is
   constant c_bfsz_pcie_cmd            : natural := 8;
   
   subtype t_pcie_hdr_adr_lower     is std_logic_vector(6 downto 0);
   subtype t_pcie_hdr_adr_part      is std_logic_vector(31 downto 0);
   subtype t_pcie_hdr_be_spec       is std_logic_vector(3 downto 0);
   subtype t_pcie_hdr_bus_num       is std_logic_vector(7 downto 0);
   subtype t_pcie_hdr_byte_count    is std_logic_vector(11 downto 0);
   subtype t_pcie_hdr_cmd           is std_logic_vector(7 downto 0);
   subtype t_pcie_hdr_cpl_status    is std_logic_vector(2 downto 0);
   subtype t_pcie_hdr_dvc_num       is std_logic_vector(4 downto 0);
   subtype t_pcie_hdr_func_num      is std_logic_vector(2 downto 0);
   subtype t_pcie_hdr_length        is std_logic_vector(9 downto 0);
   subtype t_pcie_hdr_pcie_id       is std_logic_vector(15 downto 0);
   subtype t_pcie_hdr_tag           is std_logic_vector(7 downto 0);
   
      -- Bit Positions, absolute position in Dword
   constant c_bpos_has_payload         : natural := 30;
   constant c_bpos_hdr_4dw             : natural := 29;
   constant c_bpos_pcie_cmd_lsb        : natural := 24;
   constant c_bpos_pcie_tag_lsb        : natural := 8;
   
      -- Bit Positions, absolute position in Byte
   constant c_oct_pos_has_payload      : natural := 6;
   constant c_oct_pos_hdr_4dw          : natural := 5;
   
      -- Bit Positions, relative positions from vector MSB (Byte or Dword)
   constant c_brel_has_payload         : natural := 1;
   constant c_brel_hdr_4dw             : natural := 2;
   
      -- PCI Config. Space: Status / Command Register Bits
   constant c_bsel_bus_mst_en          : std_logic_vector(31 downto 0) := X"00000004";
   constant c_bsel_cap_list_present    : std_logic_vector(31 downto 0) := X"00100000";
   constant c_bsel_intx_disable        : std_logic_vector(31 downto 0) := X"00000400";
   constant c_bsel_intx_pending        : std_logic_vector(31 downto 0) := X"00080000";
   constant c_bsel_io_space_en         : std_logic_vector(31 downto 0) := X"00000001";
   constant c_bsel_mem_space_en        : std_logic_vector(31 downto 0) := X"00000002";
   
      -- PCI Config. Space: MSI Capability Structure. 
      --                    Enable / Config settings
   constant c_bsel_msi_en              : std_logic_vector(31 downto 0) := X"00010000";
   constant c_bsel_msi_mm_1            : std_logic_vector(31 downto 0) := X"00000000";
   constant c_bsel_msi_mm_2            : std_logic_vector(31 downto 0) := X"00100000";
   constant c_bsel_msi_mm_4            : std_logic_vector(31 downto 0) := X"00200000";
   constant c_bsel_msi_mm_8            : std_logic_vector(31 downto 0) := X"00300000";
   constant c_bsel_msi_mm_16           : std_logic_vector(31 downto 0) := X"00400000";
   constant c_bsel_msi_mm_32           : std_logic_vector(31 downto 0) := X"00500000";

      -- Multi-function device Flag in Header-Type Field
   constant c_bsel_mf_dev              : std_logic_vector(31 downto 0) := X"00800000";
   
      -- PCI Express Completion Status Codes
   constant c_cpl_sta_ca               : t_pcie_hdr_cpl_status := "100";
   constant c_cpl_sta_crs              : t_pcie_hdr_cpl_status := "010";
   constant c_cpl_sta_sc               : t_pcie_hdr_cpl_status := "000";
   constant c_cpl_sta_ur               : t_pcie_hdr_cpl_status := "001";
   
      -- PCI Express Configuration Space Register Addresses
   constant c_csreg_bar0               : std_logic_vector(11 downto 0) := X"010";                  
   constant c_csreg_bar1               : std_logic_vector(11 downto 0) := X"014";                  
   constant c_csreg_bar2               : std_logic_vector(11 downto 0) := X"018";                  
   constant c_csreg_bar3               : std_logic_vector(11 downto 0) := X"01C";                  
   constant c_csreg_bar4               : std_logic_vector(11 downto 0) := X"020";                  
   constant c_csreg_bar5               : std_logic_vector(11 downto 0) := X"024";                  
   constant c_csreg_bist               : std_logic_vector(11 downto 0) := X"00F";  
   constant c_csreg_bridge_ctrl        : std_logic_vector(11 downto 0) := X"03E";  
   constant c_csreg_bus_num_primary    : std_logic_vector(11 downto 0) := X"018";
   constant c_csreg_bus_num_secondary  : std_logic_vector(11 downto 0) := X"019";
   constant c_csreg_bus_num_subord     : std_logic_vector(11 downto 0) := X"01A";
   constant c_csreg_cache_line_size    : std_logic_vector(11 downto 0) := X"00C";  
   constant c_csreg_cap_ptr            : std_logic_vector(11 downto 0) := X"034";                  
   constant c_csreg_cis_ptr            : std_logic_vector(11 downto 0) := X"028";  
   constant c_csreg_class_code_high    : std_logic_vector(11 downto 0) := X"00A";  
   constant c_csreg_command            : std_logic_vector(11 downto 0) := X"004";              
   constant c_csreg_dev_id             : std_logic_vector(11 downto 0) := X"002";              
   constant c_csreg_expansion_rom      : std_logic_vector(11 downto 0) := X"030";                  
   constant c_csreg_header_type        : std_logic_vector(11 downto 0) := X"00E";  
   constant c_csreg_int_line           : std_logic_vector(11 downto 0) := X"03C";                  
   constant c_csreg_int_pin            : std_logic_vector(11 downto 0) := X"03D";                  
   constant c_csreg_io_base            : std_logic_vector(11 downto 0) := X"01C"; 
   constant c_csreg_io_limit           : std_logic_vector(11 downto 0) := X"01D";  
   constant c_csreg_io_upper_base      : std_logic_vector(11 downto 0) := X"030"; 
   constant c_csreg_io_upper_limit     : std_logic_vector(11 downto 0) := X"032";                           
   constant c_csreg_master_lat_timer   : std_logic_vector(11 downto 0) := X"00D";  
   constant c_csreg_max_latency        : std_logic_vector(11 downto 0) := X"03F";   
   constant c_csreg_mem_base           : std_logic_vector(11 downto 0) := X"020"; 
   constant c_csreg_mem_limit          : std_logic_vector(11 downto 0) := X"022";   
   constant c_csreg_min_grant          : std_logic_vector(11 downto 0) := X"03E";  
   constant c_csreg_pref_base          : std_logic_vector(11 downto 0) := X"024"; 
   constant c_csreg_pref_limit         : std_logic_vector(11 downto 0) := X"026"; 
   constant c_csreg_pref_upper_base    : std_logic_vector(11 downto 0) := X"028"; 
   constant c_csreg_pref_upper_limit   : std_logic_vector(11 downto 0) := X"02C";                            
   constant c_csreg_rev_id             : std_logic_vector(11 downto 0) := X"008";              
   constant c_csreg_status             : std_logic_vector(11 downto 0) := X"006";              
   constant c_csreg_subs_dev_id        : std_logic_vector(11 downto 0) := X"02E";                  
   constant c_csreg_subs_vend_id       : std_logic_vector(11 downto 0) := X"02C";                  
   constant c_csreg_vend_id            : std_logic_vector(11 downto 0) := X"000";                           

   constant c_hdr_4dw                  : std_logic_vector(7 downto 0) := X"20";
   constant c_hdr_has_pload            : std_logic_vector(7 downto 0) := X"40";
   
   constant c_hdr_pos_adr_lwr          : natural := 11;
   constant c_hdr_pos_bcount           : natural :=  7;
   constant c_hdr_pos_be               : natural :=  7;
   constant c_hdr_pos_cmd              : natural :=  0;
   constant c_hdr_pos_cpl_sta          : natural :=  6;
   constant c_hdr_pos_length           : natural :=  3;
   constant c_hdr_pos_tag_cpl          : natural := 10;
   constant c_hdr_pos_tag_req          : natural :=  6;
   constant c_hdr_pos_msg_code         : natural :=  7;
   
      -- PCI Express permissible values for Max. Payload Size
   constant c_max_payload_128          : std_logic_vector(2 downto 0) := "000";   
   constant c_max_payload_256          : std_logic_vector(2 downto 0) := "001";   
   constant c_max_payload_512          : std_logic_vector(2 downto 0) := "010";   
   constant c_max_payload_1024         : std_logic_vector(2 downto 0) := "011";   
   constant c_max_payload_2048         : std_logic_vector(2 downto 0) := "100";   
   constant c_max_payload_4096         : std_logic_vector(2 downto 0) := "101";   

      -- PCI Express permissible values for Max. Read-Request Size
   constant c_max_read_req_128         : std_logic_vector(2 downto 0) := "000";   
   constant c_max_read_req_256         : std_logic_vector(2 downto 0) := "001";   
   constant c_max_read_req_512         : std_logic_vector(2 downto 0) := "010";   
   constant c_max_read_req_1024        : std_logic_vector(2 downto 0) := "011";   
   constant c_max_read_req_2048        : std_logic_vector(2 downto 0) := "100";   
   constant c_max_read_req_4096        : std_logic_vector(2 downto 0) := "101";   

      -- PCI Express Pre-defined Message Codes
   constant c_msg_err_corr             : std_logic_vector(7 downto 0) := X"30";   
   constant c_msg_err_fatal            : std_logic_vector(7 downto 0) := X"33";   
   constant c_msg_err_non_fatal        : std_logic_vector(7 downto 0) := X"31";   
   constant c_msg_inta_assert          : std_logic_vector(7 downto 0) := X"20";
   constant c_msg_inta_deassert        : std_logic_vector(7 downto 0) := X"24";
   constant c_msg_intb_assert          : std_logic_vector(7 downto 0) := X"21";
   constant c_msg_intb_deassert        : std_logic_vector(7 downto 0) := X"25";
   constant c_msg_intc_assert          : std_logic_vector(7 downto 0) := X"22";
   constant c_msg_intc_deassert        : std_logic_vector(7 downto 0) := X"26";
   constant c_msg_intd_assert          : std_logic_vector(7 downto 0) := X"23";
   constant c_msg_intd_deassert        : std_logic_vector(7 downto 0) := X"27";
   constant c_msg_pm_as_nak            : std_logic_vector(7 downto 0) := X"14";
   constant c_msg_pm_pme               : std_logic_vector(7 downto 0) := X"18";
   constant c_msg_pm_pme_to            : std_logic_vector(7 downto 0) := X"19";
   constant c_msg_pm_pme_to_ack        : std_logic_vector(7 downto 0) := X"1B";
   constant c_msg_set_slot_pwr_limit   : std_logic_vector(7 downto 0) := X"50";
   constant c_msg_unlock               : std_logic_vector(7 downto 0) := X"00";
   constant c_msg_vendor_defined_0     : std_logic_vector(7 downto 0) := X"7E";
   constant c_msg_vendor_defined_1     : std_logic_vector(7 downto 0) := X"7F";

   constant c_pci_cap_msi              : std_logic_vector(7 downto 0) := X"05";
   constant c_pci_cap_msi_x            : std_logic_vector(7 downto 0) := X"11";
   constant c_pci_cap_pcie_reg_set     : std_logic_vector(7 downto 0) := X"10";
   constant c_pci_cap_pm               : std_logic_vector(7 downto 0) := X"01";

   constant c_pcie_cap_aer             : std_logic_vector(15 downto 0) := X"0001";
   constant c_pcie_cap_dvc_snum        : std_logic_vector(15 downto 0) := X"0003";
   
         -- Routing Method Specifiers
   constant c_route_broadcast_from_rc  : std_logic_vector(7 downto 0) := "00000011";
   constant c_route_by_address         : std_logic_vector(7 downto 0) := "00000001";
   constant c_route_by_id              : std_logic_vector(7 downto 0) := "00000010";
   constant c_route_forward_to_rc      : std_logic_vector(7 downto 0) := "00000000";
   constant c_route_gathered_to_rc     : std_logic_vector(7 downto 0) := "00000101";
   constant c_route_local_rcv_term     : std_logic_vector(7 downto 0) := "00000100";
   
   constant c_tlp_byte_count_default   : t_pcie_hdr_byte_count := X"004";
   
      -- PCI Express Commands
   constant c_tlp_mrd32                : t_pcie_hdr_cmd := X"00";        
   constant c_tlp_mrd64                : t_pcie_hdr_cmd := X"20";        
   constant c_tlp_mrdlk32              : t_pcie_hdr_cmd := X"01";        
   constant c_tlp_mrdlk64              : t_pcie_hdr_cmd := X"21";   
   constant c_tlp_mwr32                : t_pcie_hdr_cmd := X"40";        
   constant c_tlp_mwr64                : t_pcie_hdr_cmd := X"60";        
   constant c_tlp_iord                 : t_pcie_hdr_cmd := X"02";        
   constant c_tlp_iowr                 : t_pcie_hdr_cmd := X"42";        
   constant c_tlp_cfgrd0               : t_pcie_hdr_cmd := X"04";        
   constant c_tlp_cfgwr0               : t_pcie_hdr_cmd := X"44";        
   constant c_tlp_cfgrd1               : t_pcie_hdr_cmd := X"05";        
   constant c_tlp_cfgwr1               : t_pcie_hdr_cmd := X"45";  
   constant c_tlp_msg                  : t_pcie_hdr_cmd := X"30";        
   constant c_tlp_msgd                 : t_pcie_hdr_cmd := X"70";      
   constant c_tlp_cpl                  : t_pcie_hdr_cmd := X"0A";        
   constant c_tlp_cpld                 : t_pcie_hdr_cmd := X"4A";        
   constant c_tlp_cpllk                : t_pcie_hdr_cmd := X"0B";        
   constant c_tlp_cpldlk               : t_pcie_hdr_cmd := X"4B";   
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_has_pload(vin : std_logic_vector) return boolean;
   function f_has_pload(vin : std_logic_vector) return std_logic;
   
   function f_is_cplx(vin : std_logic_vector) return boolean;
   function f_is_cplx(vin : std_logic_vector) return std_logic;
   
   function f_is_hdr_4dw(vin : std_logic_vector) return boolean;
   function f_is_hdr_4dw(vin : std_logic_vector) return std_logic;  

   function f_is_mem_wr(vin : std_logic_vector) return boolean;
   function f_is_mem_wr(vin : std_logic_vector) return std_logic;
   
   function f_is_np_req(vin : std_logic_vector) return boolean;
   function f_is_np_req(vin : std_logic_vector) return std_logic;      
   
   function f_set_hdr_byte_count(nin : natural) return std_logic_vector;
   
   function f_set_hdr_byte_count(vin : std_logic_vector) return std_logic_vector;
   
   function f_set_hdr_length(nin : natural) return std_logic_vector;

   function f_set_hdr_length(vin : std_logic_vector) return std_logic_vector;
   
   function f_to_bytecount(v_dwords : std_logic_vector; v_first : std_logic_vector; v_last : std_logic_vector) return std_logic_vector;
End tspc_pcisig_types;
