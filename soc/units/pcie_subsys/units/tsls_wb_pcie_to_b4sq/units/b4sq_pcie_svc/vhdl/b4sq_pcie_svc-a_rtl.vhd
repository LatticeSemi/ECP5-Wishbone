
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
-- File ID     : $Id: b4sq_pcie_svc-a_rtl.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Utility module as add-on to Lattice PCIe core
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.tspc_utils.all;

Architecture Rtl of b4sq_pcie_svc is         
   signal s_dev_cntl_reg            : std_logic_vector(i_dev_cntl_reg'length - 1 downto 0);
   signal s_dl_up                   : t_edge_sync;
   signal s_en_bus_mst              : std_logic;
   signal s_en_io_space             : std_logic;
   signal s_en_mem_space            : std_logic;
   signal s_func_active_prev        : std_logic;
   signal s_func_active_state       : std_logic;
   signal s_func_active_sync        : std_logic;
   signal s_func_reset_count        : std_logic_vector(3 downto 0);
   signal s_func_reset              : std_logic;
   signal s_hdr_4dw                 : std_logic;
   signal s_header_active           : std_logic;
   signal s_hot_reset_count         : std_logic_vector(3 downto 0);
   signal s_hot_reset               : std_logic;
   signal s_inta_lock_timer         : std_logic_vector(3 downto 0);
   signal s_inta                    : std_logic;
   signal s_inta_state              : std_logic;
   signal s_int_req                 : std_logic_vector(7 downto 0);
   signal s_intx_disable            : std_logic;
   signal s_link_cntl_reg           : std_logic_vector(i_link_cntl_reg'length - 1 downto 0);
   signal s_msi_req                 : std_logic_vector(7 downto 0);
   signal s_payload_active          : std_logic;
   signal s_pci_cmd_reg             : std_logic_vector(i_pci_cmd_reg'length - 1 downto 0);
   signal s_phy_ltssm_state_d1      : std_logic_vector(3 downto 0); 
   signal s_phy_ltssm_state_d2      : std_logic_vector(3 downto 0); 
   signal s_phy_ltssm_substate_d1   : std_logic_vector(2 downto 0); 
   signal s_phy_ltssm_substate_d2   : std_logic_vector(2 downto 0); 
   signal s_synced_rst_n            : std_logic;
   signal s_synced_rst_p1_n         : std_logic;
   signal s_synced_rst_p2_n         : std_logic;
   signal s_tx_data_count           : std_logic_vector(2 downto 0);

Begin
   o_dis_intx           <= s_intx_disable;
   o_dis_link           <= s_link_cntl_reg(4);
   o_dl_up              <= f_synced(s_dl_up);
   o_en_bus_mst         <= s_en_bus_mst;
   o_en_io_space        <= s_en_io_space;
   o_en_mem_space       <= s_en_mem_space;
   o_en_no_snoop        <= s_dev_cntl_reg(11);
   o_en_perr            <= s_pci_cmd_reg(3);
   o_en_serr            <= s_pci_cmd_reg(4);
   o_en_tag_extend      <= s_dev_cntl_reg(8);
   o_func_rst           <= s_func_reset;
   o_header_active      <= s_header_active;
   o_hot_rst            <= s_hot_reset;
   o_inta               <= s_inta;
   o_max_payload_size   <= s_dev_cntl_reg(7 downto 5);
   o_max_read_request   <= s_dev_cntl_reg(14 downto 12);
   o_msi_req            <= s_msi_req;
   o_payload_active     <= s_payload_active;
   o_phy_ltssm_state    <= s_phy_ltssm_state_d2;
   o_phy_ltssm_substate <= s_phy_ltssm_substate_d2;
   o_rcb_128_byte       <= s_link_cntl_reg(3);
   o_synced_rst_n       <= s_synced_rst_n;
     
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_en_bus_mst         <= s_pci_cmd_reg(2);
   s_en_io_space        <= s_pci_cmd_reg(0);
   s_en_mem_space       <= s_pci_cmd_reg(1);
   s_intx_disable       <= s_pci_cmd_reg(5);   

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Capture the pcie_cmd, pcie_device_control and
      --       pcie_link_control registers
   P_REGS:
   process(i_rst_n, i_clk_125)
   begin
      if (i_rst_n = '0') then   
         s_dev_cntl_reg    <= (others => '0');
         s_link_cntl_reg   <= (others => '0');
         s_pci_cmd_reg     <= (others => '0');
      elsif(rising_edge(i_clk_125)) then
         s_dev_cntl_reg    <= i_dev_cntl_reg;
         s_link_cntl_reg   <= i_link_cntl_reg;
         s_pci_cmd_reg     <= i_pci_cmd_reg;
      end if;
   end process;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Interrupt logic
      --          This is a default solution for the interrupt
      --          inputs.
   P_INT:
   process(i_rst_n, i_clk_125)
   begin
      if (i_rst_n = '0') then
         s_int_req         <= (others => '0');
         s_inta            <= '0';
         s_inta_lock_timer <= (others => '0');
         s_inta_state      <= '0';
         s_msi_req         <= (others => '0');
      elsif(rising_edge(i_clk_125)) then
         if (f_synced(s_dl_up) = '1') then
            s_int_req   <= std_logic_vector(resize(unsigned(i_int_req), s_int_req'length ));
         else
            s_int_req   <= (others => '0');
         end if;
         
               --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
               --       INTA Generation. 
               --       The lattice core requires a _minimum_ distance of eight clocks between
               --       interrupt edges. (Document IPUG75, v. 1.9)  
         s_inta_state   <= (s_int_req(7) or
                            s_int_req(6) or
                            s_int_req(5) or
                            s_int_req(4) or
                            s_int_req(3) or
                            s_int_req(2) or
                            s_int_req(1) or
                            s_int_req(0)) and not s_intx_disable
                                          and not i_msi_enable;
                                    
         if (unsigned(s_inta_lock_timer) = 0) then
            s_inta   <= s_inta_state;
            
            if (s_inta /= s_inta_state) then
               s_inta_lock_timer <= (others => '1');                            
            end if;
         else 
            s_inta_lock_timer <= std_logic_vector(unsigned(s_inta_lock_timer) - 1);                            
         end if;

               --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
               --       MSI Generation         
         if ((i_msi_enable = '0') or (s_en_bus_mst = '0')) then
            s_msi_req   <= (others => '0');
         else 
            case i_mm_enable is
               when "000" =>
                  s_msi_req(0)   <= s_int_req(7) or
                                    s_int_req(6) or
                                    s_int_req(5) or
                                    s_int_req(4) or
                                    s_int_req(3) or
                                    s_int_req(2) or
                                    s_int_req(1) or
                                    s_int_req(0);
                  s_msi_req(7 downto 1)   <= (others => '0');
                  
               when "001" =>
                  s_msi_req(1)   <= s_int_req(7) or
                                    s_int_req(6) or
                                    s_int_req(5) or
                                    s_int_req(4);
                                    
                  s_msi_req(0)   <= s_int_req(3) or
                                    s_int_req(2) or
                                    s_int_req(1) or
                                    s_int_req(0);
                  s_msi_req(7 downto 2)   <= (others => '0');
               when "010" =>
                  s_msi_req(3)   <= s_int_req(7) or
                                    s_int_req(6);
                                    
                  s_msi_req(2)   <= s_int_req(5) or
                                    s_int_req(4);
                                    
                  s_msi_req(1)   <= s_int_req(3) or
                                    s_int_req(2);
                                    
                  s_msi_req(0)   <= s_int_req(1) or
                                    s_int_req(0);
                                    
                  s_msi_req(7 downto 4)   <= (others => '0'); 
                                
               when others =>
                  s_msi_req   <= s_int_req;
            end case;
         end if;                               
      end if;
   end process;
         
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Run the LTSSM through flip-flop stages to relax
      --       the timing requirements between the PHY and Pins
   P_LTSSM:
   process(i_rst_n, i_clk_125)
   begin
      if (i_rst_n = '0') then
         s_phy_ltssm_state_d1    <= (others => '0');     
         s_phy_ltssm_state_d2    <= (others => '0');
         
         s_phy_ltssm_substate_d1 <= (others => '0'); 
         s_phy_ltssm_substate_d2 <= (others => '0');     
      elsif (rising_edge(i_clk_125)) then
         s_phy_ltssm_state_d1    <= i_phy_ltssm_state;     
         s_phy_ltssm_state_d2    <= s_phy_ltssm_state_d1;
         
         s_phy_ltssm_substate_d1 <= i_phy_ltssm_substate; 
         s_phy_ltssm_substate_d2 <= s_phy_ltssm_substate_d1;         
      end if;
   end process;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Synchronise the rising (going inactive) edge of the reset
      --       coming from the IP-Core. This is a functional OR of the
      --       physical PCIe reset pin and the 'Warm Reset' optionally 
      --       specified during link training   
   P_SYNC_RST:
   process (i_rst_n, i_clk_125)
   begin
      if (i_rst_n = '0') then
         s_synced_rst_n       <= '0';
         s_synced_rst_p1_n    <= '0';
         s_synced_rst_p2_n    <= '0';
      elsif (rising_edge(i_clk_125)) then
         s_synced_rst_n       <= s_synced_rst_p2_n;
         s_synced_rst_p1_n    <= i_ipcore_rst_n;
         s_synced_rst_p2_n    <= s_synced_rst_p1_n;
      end if;
   end process;
      
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Interpret link-down after link-up as hot reset
      --          (See PCIe Spec)
   P_HOT_RST:
   process(i_rst_n, i_clk_125)
   begin
      if (i_rst_n = '0') then
         s_dl_up              <= (others => '0');
         
         s_hot_reset          <= '0';
         s_hot_reset_count    <= (others => '0');
      elsif (rising_edge(i_clk_125)) then
         s_dl_up           <= f_sync_edge(s_dl_up, i_dl_up);
         
            -- Set hot reset if the counter is not at the maximum value
         if (unsigned(not s_hot_reset_count) = 0) then
            s_hot_reset <= '0';
         else
            s_hot_reset <= '1';
         end if;
         
         if (f_edge_fall(s_dl_up) = '1') then
               -- A falling dl_up edge activates hot reset
            s_hot_reset_count <= (others => '0');
         elsif (unsigned(not s_hot_reset_count) /= 0) then
            s_hot_reset_count <= std_logic_vector(unsigned(s_hot_reset_count) + 1);
         end if;
      end if;
   end process;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Function Reset (Controlled by software)
   P_FUNC_RST:
      -- This is a non-standard solution for device (function) reset.
      --
      -- PCI 2.x uses the MSB of the Dev. Control register as function reset. 
      -- This bit is reserved in PCIe 1.x and is not implemented in the Lattice 
      -- core.
      -- The logic here generates a function reset when both I/O-space enable (bit 0) 
      -- and memory-space enable (bit 1) are turned off after at least one bit 
      -- has previously been active
   process(i_rst_n, i_clk_125)
   begin
      if (i_rst_n = '0') then           
         s_func_active_prev   <= '0';
         s_func_active_state  <= '0';
         s_func_active_sync   <= '0';
         s_func_reset         <= '0';
         s_func_reset_count   <= (others => '0');
      elsif (rising_edge(i_clk_125)) then   
         s_func_active_sync   <= s_en_io_space or s_en_mem_space;      
         
         s_func_active_state  <= s_func_active_sync;
         s_func_active_prev   <= s_func_active_state;

            -- Set function reset if the counter is not at the maximum value
         if (unsigned(not s_func_reset_count) = 0) then
            s_func_reset   <= '0';
         else
            s_func_reset   <= '1';
         end if;

         if ((s_func_active_prev = '1') and (s_func_active_state = '0')) then
               -- A falling 'function active' edge activates function reset
            s_func_reset_count   <= (others => '0');
         elsif (unsigned(not s_func_reset_count) /= 0) then
            s_func_reset_count   <= std_logic_vector(unsigned(s_func_reset_count) + 1);
         end if;
      end if;
   end process;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Perhaps useful for Gating Reveal, tracing etc.
   P_DEBUG:
   process(i_rst_n, i_clk_125)
   begin
      if (i_rst_n = '0') then      
         s_hdr_4dw         <= '0';
         s_header_active   <= '0';
         s_payload_active  <= '0';
         s_tx_data_count   <= (others => '0');
      elsif (rising_edge(i_clk_125)) then   
         if (i_tx_start = '1') then
            s_header_active   <= '1';
            s_hdr_4dw         <= i_hdr_4dw;
         end if;
         
         case to_integer(unsigned(s_tx_data_count)) is
            when 5 =>
               s_header_active   <= s_hdr_4dw;
               s_payload_active  <= s_header_active and not s_hdr_4dw and not i_tx_end; 
               
            when 7 =>
               s_header_active   <= '0';
               s_payload_active  <= s_header_active and s_hdr_4dw and not i_tx_end; 
               
            when others =>
         end case;
                           
         if ((i_tx_end = '1') or (i_tx_nlfy = '1')) then
            s_header_active   <= '0';
            s_hdr_4dw         <= '0';
            s_payload_active  <= '0';
         end if;
         
         if (s_header_active = '1') then
            s_tx_data_count   <= std_logic_vector(unsigned(s_tx_data_count) + 1);
         end if;
      end if;
   end process; 
End Rtl;
