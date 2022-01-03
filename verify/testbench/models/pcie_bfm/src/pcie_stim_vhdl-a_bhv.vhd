
--
--------------------------------------------------------------------------------
--
-- File ID     : $Id: pcie_stim_vhdl-a_bhv.vhd 33 2021-11-16 22:43:39Z  $
-- Generated   : $LastChangedDate: 2021-11-16 23:43:39 +0100 (Tue, 16 Nov 2021) $
-- Revision    : $LastChangedRevision: 33 $
--
--------------------------------------------------------------------------------
--    To interact with other BFMs or for more complex verification scenarios
--    for instance, the user can modify this file
--
--    Normally, this file just calls the test-case through the 'run_test' call
--    below.
--------------------------------------------------------------------------------

Use WORK.pcie_vhdl_test_case_pkg.all;

Architecture Bhv of pcie_stim_vhdl is

Begin

   R_MAIN:
   process
      variable v_line   : line;
   begin      
      wait for 0 ns;
      wait until (i_rst_n = '1');
      idle(i_clk_125, 8);
         
      wait until (i_dl_up = '1');
      idle(i_clk_125);
      msgd_set_slot_power_limit(i_clk_125, o_bfm_stim, i_bfm_resp, value => X"02", scale => "01");

         -- Call the Test Case
      run_test(i_clk_125, o_bfm_stim, i_bfm_resp); 

      idle(i_clk_125, 128);
      
      assert false report LF & LF & "        +++ Game Over +++" & LF & LF severity note;             
      wait for 5 ns;
      stop(0);
   end process;   

End Bhv;
