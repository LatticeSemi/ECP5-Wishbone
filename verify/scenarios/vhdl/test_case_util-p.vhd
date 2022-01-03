Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Use WORK.bfm_lspcie_rc_constants_pkg.all;
Use WORK.bfm_lspcie_rc_tlm_lib_pkg.all;
Use WORK.bfm_lspcie_rc_types_pkg.all;
Use WORK.bfm_random_data_pkg.all;

Package test_case_util_pkg is
      constant c_all_ones                 : std_logic_vector(31 downto 0) := (others => '0');
      constant c_all_zero                 : std_logic_vector(31 downto 0) := (others => '0');
      constant c_any_value                : std_logic_vector(31 downto 0) := (others => '0');
      
      constant c_pcie_classcode           : t_slv32 := X"11800000";
      constant c_pcie_rev_id              : t_slv32 := X"00000008";
      constant c_pcie_sub_vend_sys_id     : t_slv32 := X"ae531204";                                                                          
      constant c_pcie_vend_dev_id         : t_slv32 := X"ae531204";

      constant c_pcie_rsrc_adr            : t_slv32_array(0 to 5) := (0 => X"12340000",
                                                                      1 => X"00000000",                  
                                                                      2 => X"00000000",                  
                                                                      3 => X"00000000",                  
                                                                      4 => X"00000000",                  
                                                                      5 => X"00000000");       
      constant c_pcie_rsrc_attribs        : t_slv32_array(0 to 5) := (0 => X"0000000C",
                                                                      1 => X"00000000",                  
                                                                      2 => X"00000000",                  
                                                                      3 => X"00000000",                  
                                                                      4 => X"00000000",                  
                                                                      5 => X"00000000");  
      constant c_pcie_rsrc_size           : t_slv32_array(0 to 5) := (0 => X"FFFFE000",
                                                                      1 => X"FFFFFFFF",                  
                                                                      2 => X"00000000",                  
                                                                      3 => X"00000000",                  
                                                                      4 => X"00000000",                  
                                                                      5 => X"00000000");                                                                         

      constant c_pcie_mem_rsrc_0          : t_slv32 := c_pcie_rsrc_adr(0);
End test_case_util_pkg;
