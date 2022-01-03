Library IEEE;
Library ieee_proposed ;

Use IEEE.std_logic_1164.all;
Use ieee_proposed.env.all;
Use WORK.bfm_lspcie_rc_types_pkg.all;

Package Body pcie_vhdl_test_case_pkg is
   procedure run_test(signal clk : in    std_logic;
                      signal sv  : inout t_bfm_stim;
                      signal rv  : in    t_bfm_resp;
                             id  : in    natural := 0) is
   begin
      wait;
   end procedure; 

End pcie_vhdl_test_case_pkg;      
