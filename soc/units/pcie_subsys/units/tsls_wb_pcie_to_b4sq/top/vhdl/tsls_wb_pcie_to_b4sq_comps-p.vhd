
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
-- File ID     : $Id: tsls_wb_pcie_to_b4sq_comps-p.vhd 4275 2018-06-17 22:24:08Z  $
-- Generated   : $LastChangedDate: 2018-06-18 00:24:08 +0200 (Mon, 18 Jun 2018) $
-- Revision    : $LastChangedRevision: 4275 $
--
--------------------------------------------------------------------------------
--
-- Description : 
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;
Use WORK.tspc_utils.all;

Package tsls_wb_pcie_to_b4sq_comps is
   Component b4sq_credit_config
      Port (
         o_fc_cpld_infinite   : out std_logic;
         o_fc_cplh_infinite   : out std_logic;
         o_fc_npd_infinite    : out std_logic;
         o_fc_nph_infinite    : out std_logic;
         o_fc_pd_infinite     : out std_logic;
         o_fc_ph_infinite     : out std_logic;
         o_io_space_sel       : out std_logic_vector(6 downto 0);
         o_hw_rev             : out std_logic_vector(7 downto 0);
         o_subsys_id          : out std_logic_vector(15 downto 0)
         );
   End Component;
   
   
   Component b4sq_pcie_svc
      Port (
         i_clk_125            : in  std_logic;
         i_rst_n              : in  std_logic;

         i_dev_cntl_reg       : in  std_logic_vector(14 downto 0);
         i_dl_up              : in  std_logic;
         i_hdr_4dw            : in  std_logic;
         i_int_req            : in  std_logic_vector(7 downto 0);
         i_ipcore_rst_n       : in  std_logic;
         i_link_cntl_reg      : in  std_logic_vector(7 downto 0);
         i_mm_enable          : in  std_logic_vector(2 downto 0);
         i_msi_enable         : in  std_logic;
         i_pci_cmd_reg        : in  std_logic_vector(5 downto 0);
         i_phy_ltssm_state    : in  std_logic_vector(3 downto 0);
         i_phy_ltssm_substate : in  std_logic_vector(2 downto 0);
         i_tx_ca_p_recheck    : in  std_logic;
         i_tx_end             : in  std_logic;
         i_tx_nlfy            : in  std_logic;
         i_tx_start           : in  std_logic;

         o_dis_intx           : out std_logic;
         o_dis_link           : out std_logic;
         o_dl_up              : out std_logic;
         o_en_bus_mst         : out std_logic;
         o_en_io_space        : out std_logic;
         o_en_mem_space       : out std_logic;
         o_en_no_snoop        : out std_logic;
         o_en_perr            : out std_logic;
         o_en_serr            : out std_logic;
         o_en_tag_extend      : out std_logic;
         o_func_rst           : out std_logic;
         o_header_active      : out std_logic;
         o_hot_rst            : out std_logic;
         o_inta               : out std_logic;
         o_max_payload_size   : out std_logic_vector(2 downto 0);
         o_max_read_request   : out std_logic_vector(2 downto 0);
         o_msi_req            : out std_logic_vector(7 downto 0);
         o_payload_active     : out std_logic;
         o_phy_ltssm_state    : out std_logic_vector(3 downto 0);
         o_phy_ltssm_substate : out std_logic_vector(2 downto 0);
         o_rcb_128_byte       : out std_logic;
         o_synced_rst_n       : out std_logic
         );
   End Component;
   
   
   Component b4sq_pkt_decode
      Port (
         i_clk                   : in  std_logic;
         i_rst_n                 : in  std_logic;

         i_ca_npd_infinite       : in  std_logic;
         i_ca_nph_infinite       : in  std_logic;
         i_ca_pd_infinite        : in  std_logic;
         i_ca_ph_infinite        : in  std_logic;
         i_cid_bus_nr            : in  std_logic_vector(7 downto 0);
         i_cid_dev_nr            : in  std_logic_vector(4 downto 0);
         i_cid_func_nr           : in  std_logic_vector(2 downto 0);
         i_cfg_io_space_en       : in  std_logic;
         i_cfg_io_space_sel      : in  std_logic_vector(6 downto 0);
         i_cfg_mem_space_en      : in  std_logic;
         i_ctl_max_payload_size  : in  std_logic_vector(2 downto 0);
         i_cplx_tx_free          : in  std_logic_vector;
         i_cplx_txq_ack          : in  std_logic;
         i_dec_cyc               : in  std_logic_vector;
         i_dec_cyc_local         : in  std_logic;
         i_tlp_rx_bar_hit        : in  std_logic_vector(2 downto 0);
         i_tlp_rx_count          : in  std_logic_vector;
         i_tlp_rx_data           : in  std_logic_vector(31 downto 0);
         i_tlp_rx_empty          : in  std_logic;
         i_wb_ack                : in  std_logic;
         i_wb_ack_local          : in  std_logic;
         i_wb_rdat               : in  std_logic_vector(31 downto 0);
         i_wb_rdat_local         : in  std_logic_vector(31 downto 0);

         o_cc_npd_num            : out std_logic_vector(7 downto 0);
         o_cc_pd_num             : out std_logic_vector(7 downto 0);
         o_cc_processed_npd      : out std_logic;
         o_cc_processed_nph      : out std_logic;
         o_cc_processed_pd       : out std_logic;
         o_cc_processed_ph       : out std_logic;
         o_cpld_rx_data          : out std_logic_vector(31 downto 0);
         o_cpld_rx_push          : out std_logic;
         o_cpld_rx_sta_err       : out std_logic;
         o_cpld_rx_tag           : out std_logic_vector(7 downto 0);
         o_cplx_tx_data          : out std_logic_vector(31 downto 0);
         o_cplx_tx_last          : out std_logic;
         o_cplx_tx_push          : out std_logic;
         o_cplx_txq_push         : out std_logic;
         o_dec_adr               : out std_logic_vector;
         o_dec_bar_hit           : out std_logic_vector(6 downto 0);
         o_tlp_rx_pop            : out std_logic;
         o_wb_adr                : out std_logic_vector;
         o_wb_bte                : out std_logic_vector(1 downto 0);
         o_wb_cti                : out std_logic_vector(2 downto 0);
         o_wb_cyc                : out std_logic_vector;
         o_wb_cyc_local          : out std_logic;
         o_wb_sel                : out std_logic_vector(3 downto 0);
         o_wb_stb                : out std_logic;
         o_wb_wdat               : out std_logic_vector(31 downto 0);
         o_wb_we                 : out std_logic;
         o_wb_we_local           : out std_logic
         );
   End Component;
   
      
   Component b4sq_pkt_rx_fifo
      Generic (
         g_mem_words    : positive;
         g_tech_lib     : string := "ECP3"
         );
      Port (
         i_clk                : in  std_logic;
         i_rst_n              : in  std_logic;

         i_dl_up              : in  std_logic;
         i_rx_bar_hit         : in  std_logic_vector(6 downto 0);
         i_rx_data            : in  std_logic_vector;
         i_rx_end             : in  std_logic;
         i_rx_pop             : in  std_logic;
         i_rx_st              : in  std_logic;

         o_cpld_rx_data       : out std_logic_vector(31 downto 0);
         o_cpld_rx_push       : out std_logic;
         o_cpld_rx_sta_err    : out std_logic;
         o_cpld_rx_tag        : out std_logic_vector(7 downto 0);
         o_rx_aempty          : out std_logic;
         o_rx_bar_hit         : out std_logic_vector(2 downto 0);
         o_rx_count           : out std_logic_vector(f_vec_msb(g_mem_words) downto 0);
         o_rx_data            : out std_logic_vector(31 downto 0);
         o_rx_empty           : out std_logic;
         o_rx_sof             : out std_logic
         );
   End Component;
   
   
   Component b4sq_tlp_xmitter
      Generic (
         g_fifo_sz_cpl        : positive := 512;
         g_fifo_sz_np         : positive := 512;
         g_fifo_sz_p          : positive := 512;
         g_fifo_sz_txseq      : positive := 64;
         g_tech_lib           : string := "ECP3"
         );
      Port (
         i_clk             : in  std_logic;
         i_rst_n           : in  std_logic;

         i_ca_cpld         : in  std_logic_vector(12 downto 0);
         i_ca_cplh         : in  std_logic_vector(8 downto 0);
         i_ca_npd          : in  std_logic_vector(12 downto 0);
         i_ca_nph          : in  std_logic_vector(8 downto 0);
         i_ca_pd           : in  std_logic_vector(12 downto 0);
         i_ca_ph           : in  std_logic_vector(8 downto 0);
         i_ctl_bus_mst_en  : in  std_logic;
         i_dl_up           : in  std_logic;
         i_fc_cpl_recheck  : in  std_logic;
         i_fc_p_recheck    : in  std_logic;      
         i_ipx_rdy         : in  std_logic;
         i_tlp_data_cpl    : in  std_logic_vector(31 downto 0);
         i_tlp_data_np     : in  std_logic_vector(31 downto 0);
         i_tlp_data_p      : in  std_logic_vector(31 downto 0);
         i_tlp_push_cpl    : in  std_logic;
         i_tlp_push_np     : in  std_logic;
         i_tlp_push_p      : in  std_logic;
         i_txq_push_cplx   : in  std_logic;
         i_txq_push_np     : in  std_logic;
         i_txq_push_p      : in  std_logic;

         o_free_count_cpl  : out std_logic_vector(f_vec_msb(g_fifo_sz_cpl) downto 0);
         o_free_count_np   : out std_logic_vector(f_vec_msb(g_fifo_sz_np) downto 0);
         o_free_count_p    : out std_logic_vector(f_vec_msb(g_fifo_sz_p) downto 0);
         o_ipx_data        : out std_logic_vector(15 downto 0);
         o_ipx_end         : out std_logic;
         o_ipx_req         : out std_logic;
         o_ipx_start       : out std_logic;
         o_txq_ack_cplx    : out std_logic;
         o_txq_ack_np      : out std_logic;
         o_txq_ack_p       : out std_logic
         );   
   End Component;
End tsls_wb_pcie_to_b4sq_comps;
