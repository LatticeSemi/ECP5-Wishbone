
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
-- File ID     : $Id: b4sq_pkt_rx_fifo_istage-a_rtl.vhd 4261 2018-06-17 21:56:32Z  $
-- Generated   : $LastChangedDate: 2018-06-17 23:56:32 +0200 (Sun, 17 Jun 2018) $
-- Revision    : $LastChangedRevision: 4261 $
--
--------------------------------------------------------------------------------
--
-- Description : Accepts packets from Lattice PCIe core and forwards these to
--               32-bit bus for further processing
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Use WORK.tspc_pcisig_types.all;
Use WORK.tspc_utils.all;

Architecture Rtl of b4sq_pkt_rx_fifo_istage is
   signal s_cpld_push      : std_logic;
   signal s_cplx_sta_err   : std_logic;
   signal s_cplx_status    : std_logic_vector(2 downto 0);
   signal s_cplx_tag       : std_logic_vector(7 downto 0);
   signal s_has_payload    : std_logic;
   signal s_hdr_3dw        : std_logic;
   signal s_hdr_count      : std_logic_vector(f_vec_size(8) - 1 downto 0);
   signal s_hdr_end        : std_logic;
   signal s_is_completion  : std_logic;
   signal s_is_cpld        : std_logic;
   signal s_is_header      : std_logic;
   signal s_is_payload     : std_logic;
   signal s_pload_count    : std_logic_vector(f_vec_size(2048) - 1 downto 0);
   signal s_rx_bar_hit     : std_logic_vector(6 downto 0);
   signal s_rx_bar_hit_out : std_logic_vector(2 downto 0);
   signal s_rx_data        : std_logic_vector(i_rx_data'length - 1  downto 0);
   signal s_rx_data_prev   : std_logic_vector(i_rx_data'length - 1  downto 0);
   signal s_rx_end         : std_logic;
   signal s_rx_push        : std_logic;
   signal s_rx_sof         : std_logic;
   signal s_rx_st          : std_logic;
   signal s_tlp_cmd        : std_logic_vector(7 downto 0);
   signal s_tlp_status     : std_logic_vector(2 downto 0);
   signal s_tlp_tag        : std_logic_vector(7 downto 0);
      
Begin
   o_cpld_rx_data       <= f_swap_endian(s_rx_data_prev & s_rx_data) when (s_is_cpld = '1') else (others => '0');
   o_cpld_rx_push       <= s_cpld_push;
   o_cpld_rx_sta_err    <= s_cplx_sta_err;
   o_cpld_rx_tag        <= f_cp_resize(s_cplx_tag, o_cpld_rx_tag'length );

   o_rx_bar_hit   <= s_rx_bar_hit_out;
   
   o_rx_data      <= f_swap_endian(s_rx_data_prev & s_rx_data) when (s_is_payload = '1') else
                     s_rx_data_prev & s_rx_data;

   o_rx_push      <= s_rx_push;

   o_rx_sof       <= s_rx_sof;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   s_tlp_cmd      <= i_rx_data(15 downto 8);
   s_tlp_status   <= s_rx_data(15 downto 13);
   s_tlp_tag      <= s_rx_data(15 downto 8);
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   process (i_clk, i_rst_n)
      variable v_hdr_count    : natural;
   begin
      if (i_rst_n = '0') then
         s_cpld_push       <= '0';
         s_cplx_sta_err    <= '0';
         s_cplx_status     <= (others => '0');
         s_cplx_tag        <= (others => '0');
         s_has_payload     <= '0';
         s_hdr_3dw         <= '0';
         s_hdr_count       <= (others => '0');
         s_hdr_end         <= '0';
         s_is_completion   <= '0';
         s_is_cpld         <= '0';
         s_is_header       <= '0';
         s_is_payload      <= '0';
         s_pload_count     <= (others => '0');
         s_rx_bar_hit      <= (others => '0');
         s_rx_bar_hit_out  <= (others => '0');
         s_rx_data         <= (others => '0');
         s_rx_data_prev    <= (others => '0');
         s_rx_end          <= '0';
         s_rx_push         <= '0';
         s_rx_sof          <= '0';
         s_rx_st           <= '0';
      elsif (rising_edge(i_clk)) then
         s_cpld_push       <= s_is_cpld and not s_pload_count(0);
               
         s_hdr_end         <= '0';
         s_is_header       <= (i_rx_st and i_dl_up) or (s_is_header and not s_hdr_end);

         s_rx_bar_hit      <= i_rx_bar_hit;
         s_rx_data         <= i_rx_data;
         s_rx_data_prev    <= s_rx_data;
         s_rx_end          <= i_rx_end;
         s_rx_sof          <= (i_rx_st and i_dl_up) or (s_rx_sof and not s_rx_push);
         s_rx_st           <= (i_rx_st and i_dl_up);

         s_rx_push   <= (s_is_header and not s_is_completion and not s_hdr_count(0)) or (s_is_payload and not s_pload_count(0));

         if ((i_rx_st and i_dl_up) = '1') then
            s_is_completion   <= f_to_logic(s_tlp_cmd = c_tlp_cpl) or f_to_logic(s_tlp_cmd = c_tlp_cpld);
         end if;

         if ((s_is_header = '1') and (s_rx_end = '0')) then
            s_hdr_count <= std_logic_vector(unsigned(s_hdr_count) + 1);

            v_hdr_count := to_integer(unsigned(s_hdr_count));
            case v_hdr_count is
               when 0 =>
                  s_rx_bar_hit_out  <= s_rx_bar_hit(2 downto 0);
                  
               when 1 =>
                  s_pload_count(s_pload_count'length - 1 downto 1)
                              <= std_logic_vector(resize(unsigned(s_rx_data(9 downto 0)), s_pload_count'length - 1));
                  s_pload_count(0)  <= '0';
                  
               when 2 =>
                  s_rx_bar_hit_out  <= s_rx_bar_hit(5 downto 3);
               
                  if (unsigned(s_pload_count) = 0) then
                     s_pload_count(s_pload_count'length - 1)   <= '1';
                  end if;

               when 3 =>
                  if (s_is_completion = '1') then
                     s_cplx_sta_err <= f_to_logic(s_tlp_status /= c_cpl_sta_sc);
                     s_cplx_status  <= s_tlp_status;
                  else
                     s_cplx_sta_err <= '0';
                     s_cplx_status  <= (others => '0');
                  end if;
                                 
               when 4 =>
                  s_hdr_end         <= s_hdr_3dw;
                  s_rx_bar_hit_out  <= std_logic_vector(to_unsigned(0, 2)) & s_rx_bar_hit(6);
                                                      
               when 5 =>
                  if (s_is_completion = '1') then
                     s_cplx_tag  <= s_tlp_tag;
                  else
                     s_cplx_tag  <= (others => '0');
                  end if;
                  
                  if (s_hdr_3dw = '1') then
                     s_is_cpld      <= s_has_payload and s_is_completion;
                     s_is_payload   <= s_has_payload and not s_is_completion;
                  end if;

               when 6 =>
                  s_hdr_end   <= '1';
                     
               when 7 =>
                  s_is_payload   <= s_has_payload and not s_is_completion;
                  
               when others =>
            end case;
         end if;

         if ((s_is_payload = '1') or (s_is_cpld = '1')) then
            s_pload_count <= std_logic_vector(unsigned(s_pload_count) -  1);

            if (unsigned(s_pload_count) = 1) then
               s_is_cpld      <= '0';
               s_is_payload   <= '0';
            end if;
         end if;

         if (s_rx_st = '1') then
            s_has_payload     <= s_rx_data(14);
            s_hdr_3dw         <= not s_rx_data(13);
            s_hdr_count       <= std_logic_vector(to_unsigned(1, s_hdr_count'length));
            s_rx_bar_hit_out  <= s_rx_bar_hit(2 downto 0);            
         end if;

         if (s_rx_end = '1') then
            s_hdr_count    <= (others => '0');
            s_is_cpld      <= '0';
            s_is_header    <= '0';
            s_is_payload   <= '0';
         end if;         
      end if;
   end process;
End Rtl;
