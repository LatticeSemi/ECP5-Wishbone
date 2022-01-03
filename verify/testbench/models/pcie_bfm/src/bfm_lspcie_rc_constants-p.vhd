
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: bfm_lspcie_rc_constants-p.vhd 33 2021-11-16 22:43:39Z  $
-- Generated   : $LastChangedDate: 2021-11-16 23:43:39 +0100 (Tue, 16 Nov 2021) $
-- Revision    : $LastChangedRevision: 33 $
--
--------------------------------------------------------------------------------
Library IEEE;

Use IEEE.std_logic_1164.all;

Package bfm_lspcie_rc_constants_pkg is
   constant c_all_one            : std_logic_vector(31 downto 0) := (others => '1');
   constant c_all_zero           : std_logic_vector(31 downto 0) := (others => '0');
   
      -- PCI Config. Space: Status / Command Register Bits
   constant c_bsel_bus_mst_en          : std_logic_vector(31 downto 0) := X"00000004";
   constant c_bsel_cap_list_present    : std_logic_vector(31 downto 0) := X"00100000";
   constant c_bsel_intx_disable        : std_logic_vector(31 downto 0) := X"00000400";
   constant c_bsel_intx_pending        : std_logic_vector(31 downto 0) := X"00080000";
   constant c_bsel_io_space_en         : std_logic_vector(31 downto 0) := X"00000001";
   constant c_bsel_mem_space_en        : std_logic_vector(31 downto 0) := X"00000002";
   constant c_bsel_perr_en             : std_logic_vector(31 downto 0) := X"00000040";
   constant c_bsel_serr_en             : std_logic_vector(31 downto 0) := X"00000100";
   
      -- PCI Config. Space: MSI Capability Structure. 
      --                    Enable / Config settings
   constant c_bsel_msi_en              : std_logic_vector(31 downto 0) := X"00010000";
   constant c_bsel_msi_mm_1            : std_logic_vector(31 downto 0) := X"00000000";
   constant c_bsel_msi_mm_2            : std_logic_vector(31 downto 0) := X"00100000";
   constant c_bsel_msi_mm_4            : std_logic_vector(31 downto 0) := X"00200000";
   constant c_bsel_msi_mm_8            : std_logic_vector(31 downto 0) := X"00300000";

      -- PCI Express Completion Status Codes
   constant c_cpl_sta_ca               : std_logic_vector(2 downto 0) := "100";
   constant c_cpl_sta_crs              : std_logic_vector(2 downto 0) := "010";
   constant c_cpl_sta_sc               : std_logic_vector(2 downto 0) := "000";
   constant c_cpl_sta_ur               : std_logic_vector(2 downto 0) := "001";
   
      -- PCI Express Configuration Space Register Addresses
      -- For Type 0 and Type 1 Headers
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
      -- The following will vary for different PCIe Cores
   constant c_csreg_pm_cap             : std_logic_vector(11 downto 0) := X"050";
   constant c_csreg_pmcsr              : std_logic_vector(11 downto 0) := X"054";   
   constant c_csreg_msi_cap            : std_logic_vector(11 downto 0) := X"070";   
   constant c_csreg_msi_control        : std_logic_vector(11 downto 0) := X"072";   
   constant c_csreg_msi_addr_low       : std_logic_vector(11 downto 0) := X"074";   
   constant c_csreg_msi_addr_high      : std_logic_vector(11 downto 0) := X"078";   
   constant c_csreg_msi_msg_data       : std_logic_vector(11 downto 0) := X"07C";   
   constant c_csreg_pcie_cap           : std_logic_vector(11 downto 0) := X"090";   
   constant c_csreg_pcie_dev_cap       : std_logic_vector(11 downto 0) := X"094";
   constant c_csreg_pcie_dev_ctrl      : std_logic_vector(11 downto 0) := X"098";   
   constant c_csreg_pcie_dev_stat      : std_logic_vector(11 downto 0) := X"09A";   
   constant c_csreg_pcie_link_cap      : std_logic_vector(11 downto 0) := X"09C";
   constant c_csreg_pcie_link_ctrl     : std_logic_vector(11 downto 0) := X"0A0";   
   constant c_csreg_pcie_link_stat     : std_logic_vector(11 downto 0) := X"0A2";   

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
   
      -- PCI Express Commands
   constant c_tlp_mrd32                : std_logic_vector(7 downto 0) := X"00";        
   constant c_tlp_mrd64                : std_logic_vector(7 downto 0) := X"20";        
   constant c_tlp_mrdlk32              : std_logic_vector(7 downto 0) := X"01";        
   constant c_tlp_mrdlk64              : std_logic_vector(7 downto 0) := X"21";   
   constant c_tlp_mwr32                : std_logic_vector(7 downto 0) := X"40";        
   constant c_tlp_mwr64                : std_logic_vector(7 downto 0) := X"60";        
   constant c_tlp_iord                 : std_logic_vector(7 downto 0) := X"02";        
   constant c_tlp_iowr                 : std_logic_vector(7 downto 0) := X"42";        
   constant c_tlp_cfgrd0               : std_logic_vector(7 downto 0) := X"04";        
   constant c_tlp_cfgwr0               : std_logic_vector(7 downto 0) := X"44";        
   constant c_tlp_cfgrd1               : std_logic_vector(7 downto 0) := X"05";        
   constant c_tlp_cfgwr1               : std_logic_vector(7 downto 0) := X"45";  
   constant c_tlp_msg                  : std_logic_vector(7 downto 0) := X"30";        
   constant c_tlp_msgd                 : std_logic_vector(7 downto 0) := X"70";      
   constant c_tlp_cpl                  : std_logic_vector(7 downto 0) := X"0A";        
   constant c_tlp_cpld                 : std_logic_vector(7 downto 0) := X"4A";        
   constant c_tlp_cpllk                : std_logic_vector(7 downto 0) := X"0B";        
   constant c_tlp_cpldlk               : std_logic_vector(7 downto 0) := X"4B";   

End bfm_lspcie_rc_constants_pkg;
