Library IEEE;

Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;     -- provides e.g. add for std_logic_vector + constant 

Use WORK.test_case_util_pkg.all;

Package Body pcie_vhdl_test_case_pkg is
       
   procedure run_test(signal clk : in    std_logic;
                      signal sv  : inout t_bfm_stim;
                      signal rv  : in    t_bfm_resp;
                             id  : in    natural := 0) is

      variable v_be_mask      : std_logic_vector(3 downto 0);
      variable v_bus_nr       : natural := 0;
      variable v_dev_nr       : natural := 0;
      variable v_int_count    : natural := 0;
      variable v_int_line     : std_logic_vector(31 downto 0);
      variable v_reg_val      : std_logic_vector(31 downto 0);
                             
   begin
      wait for 0 ns;

         -- useful for checking in the console window that the correct language 
         -- is on use
      wait for 5 ns;
      report LF & "Running VHDL Test Case smoke_test" & LF & LF;

         -- Set up the bus no, func no. and device no in the DUT
         -- The function no. should always be set to zero 
         -- (no multi-function device)
         -- This should be varied when running multiple tests to check that
         -- the user hardware is picking up the correct values from the Lattice
         -- core
      set_dut_id(sv, 2, 1, 0);
      v_bus_nr := 3;
      v_dev_nr := 0;

         -- increase the default values for credit-based flow control in the BFM
         -- (More on this in session 3. For session 2, these lines can be omitted)
      svc_ca_p(clk, sv, 7, 56);
      svc_ca_np(clk, sv, 7, 0);
      svc_ca_cplx(clk, sv, 7, 56);
            
         -- Get a bit of distance from link up   
      idle(clk, 128);
      cfgrd0(clk, sv, rv, c_csreg_bar0,      X"00101204", no_compare => true);

         -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         --    Smoke Test
         -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      report LF & " --- checking Configuration Space headers ---" & LF;
                     
         -- To communicate with an end-point, the end-point resources (e.g. registers)
         -- must be mapped into PCI Express memory or I/O space
         -- This will be discussed in more detail in session 5
         -- To summarise the initialisation scenario as it runs in the real world,
         -- First, all Base address registers are written with all ones
         -- Note: the very first PCI Express communication to a device MUST be a
         -- configuration space write (sets Bus no, dev no, funcno in device)
      cfgwr0(clk, sv, rv, c_csreg_bar0, X"FFFFFFFF", cpl_wait => true);
      cfgwr0(clk, sv, rv, c_csreg_bar1, X"FFFFFFFF", cpl_wait => true);
      cfgwr0(clk, sv, rv, c_csreg_bar2, X"FFFFFFFF", cpl_wait => true);
      cfgwr0(clk, sv, rv, c_csreg_bar3, X"FFFFFFFF", cpl_wait => true);
      cfgwr0(clk, sv, rv, c_csreg_bar4, X"FFFFFFFF", cpl_wait => true);
      cfgwr0(clk, sv, rv, c_csreg_bar5, X"FFFFFFFF", cpl_wait => true);

         -- Typically, the BIOS /System SW would try and identify the device
      cfgrd0(clk, sv, rv, c_csreg_vend_id,      c_pcie_vend_dev_id);
      cfgrd0(clk, sv, rv, c_csreg_subs_vend_id, c_pcie_sub_vend_sys_id);
      cfgrd0(clk, sv, rv, c_csreg_rev_id,       c_pcie_classcode or c_pcie_rev_id);

         -- Typically, the BIOS /System SW would read back the Base Address registers
         -- written above to determine the resource window size (again, more on this in
         -- session 5)
      cfgrd0(clk, sv, rv, c_csreg_bar0, c_pcie_rsrc_size(0) or c_pcie_rsrc_attribs(0));
      cfgrd0(clk, sv, rv, c_csreg_bar1, c_pcie_rsrc_size(1) or c_pcie_rsrc_attribs(1));
      cfgrd0(clk, sv, rv, c_csreg_bar2, c_pcie_rsrc_size(2) or c_pcie_rsrc_attribs(2));
      cfgrd0(clk, sv, rv, c_csreg_bar3, c_pcie_rsrc_size(3) or c_pcie_rsrc_attribs(3));
      cfgrd0(clk, sv, rv, c_csreg_bar4, c_pcie_rsrc_size(4) or c_pcie_rsrc_attribs(4));
      cfgrd0(clk, sv, rv, c_csreg_bar5, c_pcie_rsrc_size(5) or c_pcie_rsrc_attribs(5));

         -- BIOS or system sw must then locate the device within the system memory map
         -- by writing a base address to the base-address register.
         -- In this program, the base address is a constant assigned at the head of the
         -- test program. To rerun the test with different BAR settings, you only need
         -- to modify the constant above.
      cfgwr0(clk, sv, rv, c_csreg_bar0, c_pcie_rsrc_adr(0));
      cfgrd0(clk, sv, rv, c_csreg_bar0, c_pcie_rsrc_adr(0) or c_pcie_rsrc_attribs(0));

      cfgwr0(clk, sv, rv, c_csreg_bar1, c_pcie_rsrc_adr(1));
      cfgrd0(clk, sv, rv, c_csreg_bar1, c_pcie_rsrc_adr(1) or c_pcie_rsrc_attribs(1));

      cfgwr0(clk, sv, rv, c_csreg_bar2, c_pcie_rsrc_adr(2));
      cfgrd0(clk, sv, rv, c_csreg_bar2, c_pcie_rsrc_adr(2) or c_pcie_rsrc_attribs(2));

      cfgwr0(clk, sv, rv, c_csreg_bar3, c_pcie_rsrc_adr(3));
      cfgrd0(clk, sv, rv, c_csreg_bar3, c_pcie_rsrc_adr(3) or c_pcie_rsrc_attribs(3));
      
         -- Modern Bioses /operating systems send the Set Slot Power Limit message after
         -- initial configuration is complete. (More on this in session 3 and 4)
      msgd_set_slot_power_limit(clk, sv, rv, value => X"02", scale => "01");

         -- Test that access on non-enabled address spaces result in UR
      iowr(clk, sv, rv, c_pcie_mem_rsrc_0, X"2468_ACE0", cpl_sta => c_cpl_sta_ur);
      iord(clk, sv, rv, c_pcie_mem_rsrc_0, X"2468_ACE0", cpl_sta => c_cpl_sta_ur);
      memwr(clk, sv, rv, c_pcie_mem_rsrc_0, X"DEAD_BEEF");
      memrd(clk, sv, rv, c_pcie_mem_rsrc_0, X"9999_99EF", cpl_sta => c_cpl_sta_ur);
      wait_all_cplx_pending(clk, rv);

      report LF & "    --- Checking Capability Structures ---";
      cfgrd0(clk, sv, rv, c_csreg_command, X"00000000", no_compare => true);
      v_reg_val   := get_cpl_buffer(rv);
      assert ((v_reg_val and c_bsel_cap_list_present) = c_bsel_cap_list_present) report "*** Error: Capability list present indicator not set" severity error;

      cfgrd0(clk, sv, rv, c_csreg_int_line, X"00000000", no_compare => true);
      v_int_count := to_integer(unsigned(get_cpl_buffer(rv)(15 downto 8)));
      
      if ((v_reg_val and c_bsel_cap_list_present) = c_bsel_cap_list_present) then
         cfgrd0(clk, sv, rv, c_csreg_cap_ptr, X"00000000", no_compare => true);
         v_reg_val   := get_cpl_buffer(rv) and X"0000_00FF";

         cfgrd0(clk, sv, rv, v_reg_val, X"00000000", no_compare => true);
         v_reg_val   := get_cpl_buffer(rv) and X"0000_00FF";
         assert (v_reg_val(7 downto 0) = c_pci_cap_pm) report "*** Error: PM Capability identifier not found" severity error;

         v_reg_val   := get_cpl_buffer(rv) and X"0000_FF00";
         cfgrd0(clk, sv, rv, X"00" & v_reg_val(31 downto 8), X"00000000", no_compare => true);
         v_reg_val   := get_cpl_buffer(rv) and X"0000_FFFF";
         
         if (v_int_count = 0) then
            assert (v_reg_val(7 downto 0)  = c_pci_cap_pcie_reg_set) report "*** Error: PCIe Capability Expected" severity error;
            assert (v_reg_val(15 downto 8) = X"00") report "*** Error: End of Capability List Expected" severity error;
         else
            assert (v_reg_val(7 downto 0) = c_pci_cap_msi) report "*** Error: MSI Capability Expected" severity error;

            cfgrd0(clk, sv, rv, X"00" & v_reg_val(31 downto 8), X"00000000", no_compare => true);
            v_reg_val   := get_cpl_buffer(rv) and X"0000_FFFF";

            assert (v_reg_val(7 downto 0)  = c_pci_cap_pcie_reg_set) report "*** Error: PCIe Capability Expected" severity error;
            assert (v_reg_val(15 downto 8) = X"00") report "*** Error: End of Capability List Expected" severity error;
         end if;
      end if;

      report LF & "    --- Checking Capability Structures in PCIe Space ---";
      cfgrd0(clk, sv, rv, X"100", X"00000000", no_compare => true);
      cfgwr0(clk, sv, rv, X"100", X"00000000");
               
      report LF & "    --- Enabling Device ---";
      cfgwr0(clk, sv, rv, c_csreg_pmcsr, X"0000_0000");
      cfgwr0(clk, sv, rv, c_csreg_command, c_bsel_mem_space_en or c_bsel_io_space_en or c_bsel_bus_mst_en);

         -- Test Null / Byte / Word Access to Configuration Space
      report " --- Null / Byte / Word accesses to configuration space ...";
      cfgrd0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"0");
      cfgrd0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"1");
      cfgrd0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"2");
      cfgrd0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"4");
      cfgrd0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"8");
      cfgrd0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"3");
      cfgrd0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"C");

      cfgwr0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"0");
      cfgwr0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"1");
      cfgwr0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"2");
      cfgwr0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"4");
      cfgwr0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"8");
      cfgwr0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"3");
      cfgwr0(clk, sv, rv, c_csreg_vend_id, c_pcie_vend_dev_id, be_first => X"C");
                  
         -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         --    Memory Test
         --       The BFM defines 16 blocks of random data @ 4K byte named
         --       c_membg_4kb_0 to c_membg_4kb_15. A DWord in a block can be 
         --       accessed by c_membg_4kb_<n> (for the entire block),  
         --       c_membg_4kb_<n>(x) or c_membg_4kb_<n>(x to y)
         --
         --       Datatype of a block is t_tlp_payload, which is define as
         --       array (natural range <>) of t_slv32.
         --       t_slv32 being defined as
         --       subtype t_slv32   is std_logic_vector(31 downto 0);
         -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      report LF & " --- Starting Memory Test ---" & LF;

      memwr(clk, sv, rv, c_pcie_mem_rsrc_0, c_membg_4kb_2(0));
      memrd(clk, sv, rv, c_pcie_mem_rsrc_0, c_membg_4kb_2(0));
      
      report LF & LF & "    --> Increasing block size, immediate read-back" & LF;
      for ix in 0 to 15 loop
         memwr(clk, sv, rv, c_pcie_mem_rsrc_0, c_membg_4kb_3(0 to ix));
         memrd(clk, sv, rv, c_pcie_mem_rsrc_0, c_membg_4kb_3(0 to ix));
      end loop;

      report LF & LF & "    --> Increasing block size, all write before read" & LF;
      for ix in 0 to 15 loop
         memwr(clk, sv, rv, std_logic_vector(unsigned(c_pcie_mem_rsrc_0) + (64 * ix)), c_membg_4kb_3(ix to (2 * ix)));
      end loop;
      for ix in 0 to 15 loop
         memrd(clk, sv, rv, std_logic_vector(unsigned(c_pcie_mem_rsrc_0) + (64 * ix)), c_membg_4kb_3(ix to (2 * ix)));
      end loop;

      report LF & LF & "    --> Increasing block size, single accesses" & LF;
      for ix in 0 to 15 loop
         for jx in 0 to ix loop
            memwr(clk, sv, rv, std_logic_vector(unsigned(c_pcie_mem_rsrc_0) + (jx * 4)), c_membg_4kb_3(jx * 4));
         end loop;
         for jx in 0 to ix loop
            memrd(clk, sv, rv, std_logic_vector(unsigned(c_pcie_mem_rsrc_0) + (jx * 4)), c_membg_4kb_3(jx * 4));
         end loop;         
      end loop;
   
         -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         --    Test Completion
         -- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      report LF & " --- Waiting for Test Completion ---" & LF;
      wait_all_cplx_pending(clk, rv);
      
         -- Wait for Credit updates
      wait for 45 us;
         
      show_credits(rv);
      idle(clk, 128);
   end procedure; 

End pcie_vhdl_test_case_pkg; 
