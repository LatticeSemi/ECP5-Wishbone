Library IEEE;
 
use IEEE.std_logic_1164.all;
 
use WORK.versa_ecp3_tb_pkg.all;
 
Architecture Bhv of versa_ecp3_tb is
   constant c_clk_init_wait     : time := 100 ns;
   constant c_clk_period        : time := 10 ns;
   constant c_reset_init_wait   : natural := 127;
 
   signal s_clk                 : std_logic := '0';
   signal s_rst_n               : std_logic := '0';
   signal s_stim_end_sim        : std_logic := '0';
 
Begin
   PERST_N     <= s_rst_n;
   
   DUT: versa_ecp3
      Port Map (
         REFCLK_P => REFCLK_P,
         REFCLK_N => REFCLK_N,
         PERST_N  => PERST_N,
         HDIN_P0  => HDIN_P0,
         HDIN_N0  => HDIN_N0,
         
         DL_UP    => DL_UP,
         HDOUT_N0 => HDOUT_N0,
         HDOUT_P0 => HDOUT_P0,
         LTSSM_S3 => LTSSM_S3,
         LTSSM_S2 => LTSSM_S2,
         LTSSM_S1 => LTSSM_S1,
         LTSSM_S0 => LTSSM_S0
         );
    
   --	*****************************************************************
   --    Master clock, reset and stop processes
   --	*****************************************************************
    
   Clock_P:
      -- Clock process
   process
   begin
      wait for c_clk_init_wait;
      while (s_stim_end_sim = '0') loop
         s_clk <= not s_clk;
         wait for c_clk_period / 2;
      end loop;
      wait for c_clk_period;
      assert false report LF & LF &
                          "        +++ Game Over +++" & LF & LF severity note;
      wait;
   end process;
    
   Reset_P:
   process
   begin
      s_rst_n   <= '0';
      for i in 0 to c_reset_init_wait loop
         wait until rising_edge(s_clk);
      end loop;
      s_rst_n   <= '1';
      wait;
   end process;
    
   --	*****************************************************************
    
 
   MAIN:
      -- Main Simulation process
   process
   begin
         -- Put your test-stimuli here
      wait;
   end process;
End Bhv;
