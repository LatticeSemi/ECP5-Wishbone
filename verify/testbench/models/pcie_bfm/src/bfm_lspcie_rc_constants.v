
   // Predefined parameter Settings for Verilog BFM API
localparam  [3:0]  c_be_all      = 4'hf;
localparam  [3:0]  c_be_none     = 4'h0;
localparam         c_no_wait_cpl = 1'b0;
localparam         c_wait_cpl    = 1'b1;

   // PCI Config. Space: Status / Command Register Bits
localparam  [31:0] c_bsel_bus_mst_en         = 32'h00000004;
localparam  [31:0] c_bsel_cap_list_present   = 32'h00100000;
localparam  [31:0] c_bsel_intx_disable       = 32'h00000400;
localparam  [31:0] c_bsel_intx_pending       = 32'h00080000;
localparam  [31:0] c_bsel_io_space_en        = 32'h00000001;
localparam  [31:0] c_bsel_mem_space_en       = 32'h00000002;

   // PCI Config. Space: MSI Capability Structure. 
   //                    Enable / Config settings
localparam  [31:0] c_bsel_msi_en             = 32'h00010000;
localparam  [31:0] c_bsel_msi_mm_1           = 32'h00000000;
localparam  [31:0] c_bsel_msi_mm_2           = 32'h00100000;
localparam  [31:0] c_bsel_msi_mm_4           = 32'h00200000;
localparam  [31:0] c_bsel_msi_mm_8           = 32'h00300000;

   // PCI Express Completion Status Codes
localparam  [2:0]  c_cpl_sta_ca              = 3'b100;
localparam  [2:0]  c_cpl_sta_crs             = 3'b010;
localparam  [2:0]  c_cpl_sta_sc              = 3'b000;
localparam  [2:0]  c_cpl_sta_ur              = 3'b001;

   // PCI Express Configuration Space Register Addresses
localparam  [11:0] c_csreg_vend_id           = 12'h000;               
localparam  [11:0] c_csreg_dev_id            = 12'h002;              
localparam  [11:0] c_csreg_command           = 12'h004;              
localparam  [11:0] c_csreg_status            = 12'h006;              
localparam  [11:0] c_csreg_rev_id            = 12'h008;              
localparam  [11:0] c_csreg_class_code_high   = 12'h00a;  
localparam  [11:0] c_csreg_bar0              = 12'h010;                  
localparam  [11:0] c_csreg_bar1              = 12'h014;                  
localparam  [11:0] c_csreg_bar2              = 12'h018;                  
localparam  [11:0] c_csreg_bar3              = 12'h01c;                  
localparam  [11:0] c_csreg_bar4              = 12'h020;                  
localparam  [11:0] c_csreg_bar5              = 12'h024;                  
localparam  [11:0] c_csreg_cis_ptr           = 12'h028;                  
localparam  [11:0] c_csreg_subs_vend_id      = 12'h02c;                  
localparam  [11:0] c_csreg_subs_dev_id       = 12'h02e;                  
localparam  [11:0] c_csreg_expansion_rom     = 12'h030;                  
localparam  [11:0] c_csreg_cap_ptr           = 12'h034; 
localparam  [11:0] c_csreg_int_line          = 12'h03c;
localparam  [11:0] c_csreg_int_pin           = 12'h03d;
   // The following will vary for different PCIe Cores
localparam  [11:0] c_csreg_pmcsr             = 12'h054;   
localparam  [11:0] c_csreg_msi_cap           = 12'h070;   
localparam  [11:0] c_csreg_msi_control       = 12'h072;   
localparam  [11:0] c_csreg_msi_addr_low      = 12'h074;   
localparam  [11:0] c_csreg_msi_addr_high     = 12'h078;   
localparam  [11:0] c_csreg_msi_msg_data      = 12'h07c;   
localparam  [11:0] c_csreg_pcie_cap          = 12'h090;   
localparam  [11:0] c_csreg_pcie_dev_ctrl     = 12'h098;   
localparam  [11:0] c_csreg_pcie_dev_stat     = 12'h09a;   
localparam  [11:0] c_csreg_pcie_link_ctrl    = 12'h0a0;   
localparam  [11:0] c_csreg_pcie_link_stat    = 12'h0a2;   
   
   // PCI Express permissible values for Max. Payload Size
localparam  [2:0] c_max_payload_128 = 3'b000;
localparam  [2:0] c_max_payload_256 = 3'b001;
localparam  [2:0] c_max_payload_512 = 3'b010;
localparam  [2:0] c_max_payload_1024 = 3'b011;
localparam  [2:0] c_max_payload_2048 = 3'b100;
localparam  [2:0] c_max_payload_4096 = 3'b101;

   // PCI Express permissible values for Max. Read-Request Size
localparam  [2:0] c_max_read_req_128 = 3'b000;
localparam  [2:0] c_max_read_req_256 = 3'b001;
localparam  [2:0] c_max_read_req_512 = 3'b010;
localparam  [2:0] c_max_read_req_1024 = 3'b011;
localparam  [2:0] c_max_read_req_2048 = 3'b100;
localparam  [2:0] c_max_read_req_4096 = 3'b101;
   
   // PCI Express Pre-defined Message Codes
localparam  [7:0] c_msg_err_corr             = 8'h30;   
localparam  [7:0] c_msg_err_fatal            = 8'h33;   
localparam  [7:0] c_msg_err_non_fatal        = 8'h31;   
localparam  [7:0] c_msg_inta_assert          = 8'h20;
localparam  [7:0] c_msg_inta_deassert        = 8'h24;
localparam  [7:0] c_msg_intb_assert          = 8'h21;
localparam  [7:0] c_msg_intb_deassert        = 8'h25;
localparam  [7:0] c_msg_intc_assert          = 8'h22;
localparam  [7:0] c_msg_intc_deassert        = 8'h26;
localparam  [7:0] c_msg_intd_assert          = 8'h23;
localparam  [7:0] c_msg_intd_deassert        = 8'h27;
localparam  [7:0] c_msg_pm_as_nak            = 8'h14;
localparam  [7:0] c_msg_pm_pme               = 8'h18;
localparam  [7:0] c_msg_pm_pme_to            = 8'h19;
localparam  [7:0] c_msg_pm_pme_to_ack        = 8'h1b;
localparam  [7:0] c_msg_set_slot_pwr_limit   = 8'h50;
localparam  [7:0] c_msg_unlock               = 8'h00;
localparam  [7:0] c_msg_vendor_defined_0     = 8'h7e;
localparam  [7:0] c_msg_vendor_defined_1     = 8'h7f;

localparam [7:0]  c_pci_cap_msi           = 8'h05;
localparam [7:0]  c_pci_cap_msi_x         = 8'h11;
localparam [7:0]  c_pci_cap_pcie_reg_set  = 8'h10;
localparam [7:0]  c_pci_cap_pm            = 8'h01;

localparam [15:0] c_pcie_cap_aer          = 16'h0001;
localparam [15:0] c_pcie_cap_dvc_snum     = 16'h0003;

   // Routing method specifiers
localparam [2:0] c_route_broadcast_from_rc  = 3'h3;
localparam [2:0] c_route_by_address         = 3'h1;
localparam [2:0] c_route_by_id              = 3'h2;
localparam [2:0] c_route_forward_to_rc      = 3'h0;
localparam [2:0] c_route_gathered_to_rc     = 3'h5;
localparam [2:0] c_route_local_rcv_term     = 3'h4;
      
   // PCI Express Commands
localparam  [7:0] c_tlp_mrd32    = 8'h00;             
localparam  [7:0] c_tlp_mrd64    = 8'h20;             
localparam  [7:0] c_tlp_mrdlk32  = 8'h01;             
localparam  [7:0] c_tlp_mrdlk64  = 8'h21;   
localparam  [7:0] c_tlp_mwr32    = 8'h40;             
localparam  [7:0] c_tlp_mwr64    = 8'h60;             
localparam  [7:0] c_tlp_iord     = 8'h02;             
localparam  [7:0] c_tlp_iowr     = 8'h42;             
localparam  [7:0] c_tlp_cfgrd0   = 8'h04;             
localparam  [7:0] c_tlp_cfgwr0   = 8'h44;             
localparam  [7:0] c_tlp_cfgrd1   = 8'h05;             
localparam  [7:0] c_tlp_cfgwr1   = 8'h45;  
localparam  [7:0] c_tlp_msg      = 8'h30;             
localparam  [7:0] c_tlp_msgd     = 8'h70;      
localparam  [7:0] c_tlp_cpl      = 8'h0a;             
localparam  [7:0] c_tlp_cpld     = 8'h4a;             
localparam  [7:0] c_tlp_cpllk    = 8'h0b;             
localparam  [7:0] c_tlp_cpldlk   = 8'h4b;   
