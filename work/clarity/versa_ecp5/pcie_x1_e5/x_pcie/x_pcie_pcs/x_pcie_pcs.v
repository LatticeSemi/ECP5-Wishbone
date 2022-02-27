// Verilog netlist produced by program ASBGen: Ports rev. 2.32, Attr. rev. 2.76
// Netlist written on Sun Feb 27 17:22:23 2022
//
// Verilog Description of module x_pcie_pcs
//

`timescale 1ns/1ps
module x_pcie_pcs (hdoutp, hdoutn, hdinp, hdinn, 
            rxrefclk, rx_pclk, txi_clk, tx_pclk, txdata, tx_k, tx_force_disp, 
            tx_disp_sel, pci_ei_en, rxdata, rx_k, rxstatus0, tx_idle_c, 
            pcie_det_en_c, pcie_ct_c, rx_invert_c, signal_detect_c, 
            fb_loopback_c, pcie_done_s, pcie_con_s, rx_los_low_s, lsm_status_s, 
            rx_cdr_lol_s, sli_rst, sli_pcie_mode, tx_pwrup_c, rx_pwrup_c, 
            sci_wrdata, sci_addr, sci_rddata, sci_en_dual, sci_sel_dual, 
            sci_en, sci_sel, sci_rd, sci_wrn, sci_int, cyawstn, 
            serdes_pdb, pll_refclki, rsl_disable, rsl_rst, serdes_rst_dual_c, 
            rst_dual_c, tx_serdes_rst_c, tx_pcs_rst_c, pll_lol, rsl_tx_rdy, 
            rx_serdes_rst_c, rx_pcs_rst_c, rsl_rx_rdy);
    output hdoutp;
    output hdoutn;
    input hdinp;
    input hdinn;
    input rxrefclk;
    output rx_pclk;
    input txi_clk;
    output tx_pclk;
    input [7:0]txdata;
    input [0:0]tx_k;
    input [0:0]tx_force_disp;
    input [0:0]tx_disp_sel;
    input [0:0]pci_ei_en;
    output [7:0]rxdata;
    output [0:0]rx_k;
    output [2:0]rxstatus0;
    input tx_idle_c;
    input pcie_det_en_c;
    input pcie_ct_c;
    input rx_invert_c;
    input signal_detect_c;
    input fb_loopback_c;
    output pcie_done_s;
    output pcie_con_s;
    output rx_los_low_s;
    output lsm_status_s;
    output rx_cdr_lol_s;
    input sli_rst;
    input sli_pcie_mode;
    input tx_pwrup_c;
    input rx_pwrup_c;
    input [7:0]sci_wrdata;
    input [5:0]sci_addr;
    output [7:0]sci_rddata;
    input sci_en_dual;
    input sci_sel_dual;
    input sci_en;
    input sci_sel;
    input sci_rd;
    input sci_wrn;
    output sci_int;
    input cyawstn;
    input serdes_pdb;
    input pll_refclki;
    input rsl_disable;
    input rsl_rst;
    input serdes_rst_dual_c;
    input rst_dual_c;
    input tx_serdes_rst_c;
    input tx_pcs_rst_c;
    output pll_lol;
    output rsl_tx_rdy;
    input rx_serdes_rst_c;
    input rx_pcs_rst_c;
    output rsl_rx_rdy;
    
    
    wire n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, rsl_tx_pcs_rst_c, 
        rsl_rx_pcs_rst_c, rsl_rx_serdes_rst_c, rsl_rst_dual_c, rsl_serdes_rst_dual_c, 
        rsl_tx_serdes_rst_c, n11, n12, n13, n14, n15, n16, n17, 
        n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, 
        n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, 
        n38, n41, n42, n43, n44, n45, n46, n47, n48, n49, 
        n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, 
        n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, 
        n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, 
        n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, 
        n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, 
        n100, n101, n112, n113, n114, n115, n116, n117, n118, 
        n119, n120, _Z;
    
    DCUA DCU0_inst (.CH0_HDINP(hdinp), .CH1_HDINP(1'b0), .CH0_HDINN(hdinn), 
         .CH1_HDINN(1'b0), .D_TXBIT_CLKP_FROM_ND(1'b0), .D_TXBIT_CLKN_FROM_ND(1'b0), 
         .D_SYNC_ND(1'b0), .D_TXPLL_LOL_FROM_ND(1'b0), .CH0_RX_REFCLK(rxrefclk), 
         .CH1_RX_REFCLK(1'b0), .CH0_FF_RXI_CLK(rx_pclk), .CH1_FF_RXI_CLK(1'b1), 
         .CH0_FF_TXI_CLK(txi_clk), .CH1_FF_TXI_CLK(1'b1), .CH0_FF_EBRD_CLK(1'b1), 
         .CH1_FF_EBRD_CLK(1'b1), .CH0_FF_TX_D_0(txdata[0]), .CH1_FF_TX_D_0(1'b0), 
         .CH0_FF_TX_D_1(txdata[1]), .CH1_FF_TX_D_1(1'b0), .CH0_FF_TX_D_2(txdata[2]), 
         .CH1_FF_TX_D_2(1'b0), .CH0_FF_TX_D_3(txdata[3]), .CH1_FF_TX_D_3(1'b0), 
         .CH0_FF_TX_D_4(txdata[4]), .CH1_FF_TX_D_4(1'b0), .CH0_FF_TX_D_5(txdata[5]), 
         .CH1_FF_TX_D_5(1'b0), .CH0_FF_TX_D_6(txdata[6]), .CH1_FF_TX_D_6(1'b0), 
         .CH0_FF_TX_D_7(txdata[7]), .CH1_FF_TX_D_7(1'b0), .CH0_FF_TX_D_8(tx_k[0]), 
         .CH1_FF_TX_D_8(1'b0), .CH0_FF_TX_D_9(tx_force_disp[0]), .CH1_FF_TX_D_9(1'b0), 
         .CH0_FF_TX_D_10(tx_disp_sel[0]), .CH1_FF_TX_D_10(1'b0), .CH0_FF_TX_D_11(pci_ei_en[0]), 
         .CH1_FF_TX_D_11(1'b0), .CH0_FF_TX_D_12(1'b0), .CH1_FF_TX_D_12(1'b0), 
         .CH0_FF_TX_D_13(1'b0), .CH1_FF_TX_D_13(1'b0), .CH0_FF_TX_D_14(1'b0), 
         .CH1_FF_TX_D_14(1'b0), .CH0_FF_TX_D_15(1'b0), .CH1_FF_TX_D_15(1'b0), 
         .CH0_FF_TX_D_16(1'b0), .CH1_FF_TX_D_16(1'b0), .CH0_FF_TX_D_17(1'b0), 
         .CH1_FF_TX_D_17(1'b0), .CH0_FF_TX_D_18(1'b0), .CH1_FF_TX_D_18(1'b0), 
         .CH0_FF_TX_D_19(1'b0), .CH1_FF_TX_D_19(1'b0), .CH0_FF_TX_D_20(1'b0), 
         .CH1_FF_TX_D_20(1'b0), .CH0_FF_TX_D_21(1'b0), .CH1_FF_TX_D_21(1'b0), 
         .CH0_FF_TX_D_22(1'b0), .CH1_FF_TX_D_22(1'b0), .CH0_FF_TX_D_23(1'b0), 
         .CH1_FF_TX_D_23(1'b0), .CH0_FFC_EI_EN(tx_idle_c), .CH1_FFC_EI_EN(1'b0), 
         .CH0_FFC_PCIE_DET_EN(pcie_det_en_c), .CH1_FFC_PCIE_DET_EN(1'b0), 
         .CH0_FFC_PCIE_CT(pcie_ct_c), .CH1_FFC_PCIE_CT(1'b0), .CH0_FFC_SB_INV_RX(rx_invert_c), 
         .CH1_FFC_SB_INV_RX(1'b0), .CH0_FFC_ENABLE_CGALIGN(1'b0), .CH1_FFC_ENABLE_CGALIGN(1'b0), 
         .CH0_FFC_SIGNAL_DETECT(signal_detect_c), .CH1_FFC_SIGNAL_DETECT(1'b0), 
         .CH0_FFC_FB_LOOPBACK(fb_loopback_c), .CH1_FFC_FB_LOOPBACK(1'b0), 
         .CH0_FFC_SB_PFIFO_LP(1'b0), .CH1_FFC_SB_PFIFO_LP(1'b0), .CH0_FFC_PFIFO_CLR(1'b0), 
         .CH1_FFC_PFIFO_CLR(1'b0), .CH0_FFC_RATE_MODE_RX(1'b0), .CH1_FFC_RATE_MODE_RX(1'b0), 
         .CH0_FFC_RATE_MODE_TX(1'b0), .CH1_FFC_RATE_MODE_TX(1'b0), .CH0_FFC_DIV11_MODE_RX(1'b0), 
         .CH1_FFC_DIV11_MODE_RX(1'b0), .CH0_FFC_DIV11_MODE_TX(1'b0), .CH1_FFC_DIV11_MODE_TX(1'b0), 
         .CH0_FFC_RX_GEAR_MODE(1'b0), .CH1_FFC_RX_GEAR_MODE(1'b0), .CH0_FFC_TX_GEAR_MODE(1'b0), 
         .CH1_FFC_TX_GEAR_MODE(1'b0), .CH0_FFC_LDR_CORE2TX_EN(1'b0), .CH1_FFC_LDR_CORE2TX_EN(1'b0), 
         .CH0_FFC_LANE_TX_RST(rsl_tx_pcs_rst_c), .CH1_FFC_LANE_TX_RST(1'b0), 
         .CH0_FFC_LANE_RX_RST(rsl_rx_pcs_rst_c), .CH1_FFC_LANE_RX_RST(1'b0), 
         .CH0_FFC_RRST(rsl_rx_serdes_rst_c), .CH1_FFC_RRST(1'b0), .CH0_FFC_TXPWDNB(tx_pwrup_c), 
         .CH1_FFC_TXPWDNB(1'b0), .CH0_FFC_RXPWDNB(rx_pwrup_c), .CH1_FFC_RXPWDNB(1'b0), 
         .CH0_LDR_CORE2TX(1'b0), .CH1_LDR_CORE2TX(1'b0), .D_SCIWDATA0(sci_wrdata[0]), 
         .D_SCIWDATA1(sci_wrdata[1]), .D_SCIWDATA2(sci_wrdata[2]), .D_SCIWDATA3(sci_wrdata[3]), 
         .D_SCIWDATA4(sci_wrdata[4]), .D_SCIWDATA5(sci_wrdata[5]), .D_SCIWDATA6(sci_wrdata[6]), 
         .D_SCIWDATA7(sci_wrdata[7]), .D_SCIADDR0(sci_addr[0]), .D_SCIADDR1(sci_addr[1]), 
         .D_SCIADDR2(sci_addr[2]), .D_SCIADDR3(sci_addr[3]), .D_SCIADDR4(sci_addr[4]), 
         .D_SCIADDR5(sci_addr[5]), .D_SCIENAUX(sci_en_dual), .D_SCISELAUX(sci_sel_dual), 
         .CH0_SCIEN(sci_en), .CH1_SCIEN(1'b0), .CH0_SCISEL(sci_sel), .CH1_SCISEL(1'b0), 
         .D_SCIRD(sci_rd), .D_SCIWSTN(sci_wrn), .D_CYAWSTN(cyawstn), .D_FFC_SYNC_TOGGLE(1'b0), 
         .D_FFC_DUAL_RST(rsl_rst_dual_c), .D_FFC_MACRO_RST(rsl_serdes_rst_dual_c), 
         .D_FFC_MACROPDB(serdes_pdb), .D_FFC_TRST(rsl_tx_serdes_rst_c), 
         .CH0_FFC_CDR_EN_BITSLIP(1'b0), .CH1_FFC_CDR_EN_BITSLIP(1'b0), .D_SCAN_ENABLE(1'b0), 
         .D_SCAN_IN_0(1'b0), .D_SCAN_IN_1(1'b0), .D_SCAN_IN_2(1'b0), .D_SCAN_IN_3(1'b0), 
         .D_SCAN_IN_4(1'b0), .D_SCAN_IN_5(1'b0), .D_SCAN_IN_6(1'b0), .D_SCAN_IN_7(1'b0), 
         .D_SCAN_MODE(1'b0), .D_SCAN_RESET(1'b0), .D_CIN0(1'b0), .D_CIN1(1'b0), 
         .D_CIN2(1'b0), .D_CIN3(1'b0), .D_CIN4(1'b0), .D_CIN5(1'b0), 
         .D_CIN6(1'b0), .D_CIN7(1'b0), .D_CIN8(1'b0), .D_CIN9(1'b0), 
         .D_CIN10(1'b0), .D_CIN11(1'b0), .CH0_HDOUTP(hdoutp), .CH1_HDOUTP(n42), 
         .CH0_HDOUTN(hdoutn), .CH1_HDOUTN(n43), .D_TXBIT_CLKP_TO_ND(n1), 
         .D_TXBIT_CLKN_TO_ND(n2), .D_SYNC_PULSE2ND(n3), .D_TXPLL_LOL_TO_ND(n4), 
         .CH0_FF_RX_F_CLK(n5), .CH1_FF_RX_F_CLK(n44), .CH0_FF_RX_H_CLK(n6), 
         .CH1_FF_RX_H_CLK(n45), .CH0_FF_TX_F_CLK(n7), .CH1_FF_TX_F_CLK(n46), 
         .CH0_FF_TX_H_CLK(n8), .CH1_FF_TX_H_CLK(n47), .CH0_FF_RX_PCLK(rx_pclk), 
         .CH1_FF_RX_PCLK(n48), .CH0_FF_TX_PCLK(tx_pclk), .CH1_FF_TX_PCLK(n49), 
         .CH0_FF_RX_D_0(rxdata[0]), .CH1_FF_RX_D_0(n50), .CH0_FF_RX_D_1(rxdata[1]), 
         .CH1_FF_RX_D_1(n51), .CH0_FF_RX_D_2(rxdata[2]), .CH1_FF_RX_D_2(n52), 
         .CH0_FF_RX_D_3(rxdata[3]), .CH1_FF_RX_D_3(n53), .CH0_FF_RX_D_4(rxdata[4]), 
         .CH1_FF_RX_D_4(n54), .CH0_FF_RX_D_5(rxdata[5]), .CH1_FF_RX_D_5(n55), 
         .CH0_FF_RX_D_6(rxdata[6]), .CH1_FF_RX_D_6(n56), .CH0_FF_RX_D_7(rxdata[7]), 
         .CH1_FF_RX_D_7(n57), .CH0_FF_RX_D_8(rx_k[0]), .CH1_FF_RX_D_8(n58), 
         .CH0_FF_RX_D_9(rxstatus0[0]), .CH1_FF_RX_D_9(n59), .CH0_FF_RX_D_10(rxstatus0[1]), 
         .CH1_FF_RX_D_10(n60), .CH0_FF_RX_D_11(rxstatus0[2]), .CH1_FF_RX_D_11(n61), 
         .CH0_FF_RX_D_12(n62), .CH1_FF_RX_D_12(n63), .CH0_FF_RX_D_13(n64), 
         .CH1_FF_RX_D_13(n65), .CH0_FF_RX_D_14(n66), .CH1_FF_RX_D_14(n67), 
         .CH0_FF_RX_D_15(n68), .CH1_FF_RX_D_15(n69), .CH0_FF_RX_D_16(n70), 
         .CH1_FF_RX_D_16(n71), .CH0_FF_RX_D_17(n72), .CH1_FF_RX_D_17(n73), 
         .CH0_FF_RX_D_18(n74), .CH1_FF_RX_D_18(n75), .CH0_FF_RX_D_19(n76), 
         .CH1_FF_RX_D_19(n77), .CH0_FF_RX_D_20(n78), .CH1_FF_RX_D_20(n79), 
         .CH0_FF_RX_D_21(n80), .CH1_FF_RX_D_21(n81), .CH0_FF_RX_D_22(n82), 
         .CH1_FF_RX_D_22(n83), .CH0_FF_RX_D_23(n84), .CH1_FF_RX_D_23(n85), 
         .CH0_FFS_PCIE_DONE(pcie_done_s), .CH1_FFS_PCIE_DONE(n86), .CH0_FFS_PCIE_CON(pcie_con_s), 
         .CH1_FFS_PCIE_CON(n87), .CH0_FFS_RLOS(rx_los_low_s), .CH1_FFS_RLOS(n88), 
         .CH0_FFS_LS_SYNC_STATUS(lsm_status_s), .CH1_FFS_LS_SYNC_STATUS(n89), 
         .CH0_FFS_CC_UNDERRUN(n90), .CH1_FFS_CC_UNDERRUN(n91), .CH0_FFS_CC_OVERRUN(n92), 
         .CH1_FFS_CC_OVERRUN(n93), .CH0_FFS_RXFBFIFO_ERROR(n9), .CH1_FFS_RXFBFIFO_ERROR(n94), 
         .CH0_FFS_TXFBFIFO_ERROR(n10), .CH1_FFS_TXFBFIFO_ERROR(n95), .CH0_FFS_RLOL(rx_cdr_lol_s), 
         .CH1_FFS_RLOL(n96), .CH0_FFS_SKP_ADDED(n97), .CH1_FFS_SKP_ADDED(n98), 
         .CH0_FFS_SKP_DELETED(n99), .CH1_FFS_SKP_DELETED(n100), .CH0_LDR_RX2CORE(n101), 
         .CH1_LDR_RX2CORE(n112), .D_SCIRDATA0(sci_rddata[0]), .D_SCIRDATA1(sci_rddata[1]), 
         .D_SCIRDATA2(sci_rddata[2]), .D_SCIRDATA3(sci_rddata[3]), .D_SCIRDATA4(sci_rddata[4]), 
         .D_SCIRDATA5(sci_rddata[5]), .D_SCIRDATA6(sci_rddata[6]), .D_SCIRDATA7(sci_rddata[7]), 
         .D_SCIINT(sci_int), .D_SCAN_OUT_0(n11), .D_SCAN_OUT_1(n12), .D_SCAN_OUT_2(n13), 
         .D_SCAN_OUT_3(n14), .D_SCAN_OUT_4(n15), .D_SCAN_OUT_5(n16), .D_SCAN_OUT_6(n17), 
         .D_SCAN_OUT_7(n18), .D_COUT0(n19), .D_COUT1(n20), .D_COUT2(n21), 
         .D_COUT3(n22), .D_COUT4(n23), .D_COUT5(n24), .D_COUT6(n25), 
         .D_COUT7(n26), .D_COUT8(n27), .D_COUT9(n28), .D_COUT10(n29), 
         .D_COUT11(n30), .D_COUT12(n31), .D_COUT13(n32), .D_COUT14(n33), 
         .D_COUT15(n34), .D_COUT16(n35), .D_COUT17(n36), .D_COUT18(n37), 
         .D_COUT19(n38), .D_REFCLKI(pll_refclki), .D_FFS_PLOL(n41)) /* synthesis LOC=DCU0 CHAN=CH0 */ ;
    defparam DCU0_inst.D_MACROPDB = "0b1";
    defparam DCU0_inst.D_IB_PWDNB = "0b1";
    defparam DCU0_inst.D_XGE_MODE = "0b0";
    defparam DCU0_inst.D_LOW_MARK = "0d4";
    defparam DCU0_inst.D_HIGH_MARK = "0d12";
    defparam DCU0_inst.D_BUS8BIT_SEL = "0b0";
    defparam DCU0_inst.D_CDR_LOL_SET = "0b00";
    defparam DCU0_inst.D_TXPLL_PWDNB = "0b1";
    defparam DCU0_inst.D_BITCLK_LOCAL_EN = "0b1";
    defparam DCU0_inst.D_BITCLK_ND_EN = "0b0";
    defparam DCU0_inst.D_BITCLK_FROM_ND_EN = "0b0";
    defparam DCU0_inst.D_SYNC_LOCAL_EN = "0b1";
    defparam DCU0_inst.D_SYNC_ND_EN = "0b0";
    defparam DCU0_inst.CH0_UC_MODE = "0b0";
    defparam DCU0_inst.CH0_PCIE_MODE = "0b1";
    defparam DCU0_inst.CH0_RIO_MODE = "0b0";
    defparam DCU0_inst.CH0_WA_MODE = "0b0";
    defparam DCU0_inst.CH0_INVERT_RX = "0b0";
    defparam DCU0_inst.CH0_INVERT_TX = "0b0";
    defparam DCU0_inst.CH0_PRBS_SELECTION = "0b0";
    defparam DCU0_inst.CH0_GE_AN_ENABLE = "0b0";
    defparam DCU0_inst.CH0_PRBS_LOCK = "0b0";
    defparam DCU0_inst.CH0_PRBS_ENABLE = "0b0";
    defparam DCU0_inst.CH0_ENABLE_CG_ALIGN = "0b1";
    defparam DCU0_inst.CH0_TX_GEAR_MODE = "0b0";
    defparam DCU0_inst.CH0_RX_GEAR_MODE = "0b0";
    defparam DCU0_inst.CH0_PCS_DET_TIME_SEL = "0b00";
    defparam DCU0_inst.CH0_PCIE_EI_EN = "0b0";
    defparam DCU0_inst.CH0_TX_GEAR_BYPASS = "0b0";
    defparam DCU0_inst.CH0_ENC_BYPASS = "0b0";
    defparam DCU0_inst.CH0_SB_BYPASS = "0b0";
    defparam DCU0_inst.CH0_RX_SB_BYPASS = "0b0";
    defparam DCU0_inst.CH0_WA_BYPASS = "0b0";
    defparam DCU0_inst.CH0_DEC_BYPASS = "0b0";
    defparam DCU0_inst.CH0_CTC_BYPASS = "0b1";
    defparam DCU0_inst.CH0_RX_GEAR_BYPASS = "0b0";
    defparam DCU0_inst.CH0_LSM_DISABLE = "0b0";
    defparam DCU0_inst.CH0_MATCH_2_ENABLE = "0b0";
    defparam DCU0_inst.CH0_MATCH_4_ENABLE = "0b1";
    defparam DCU0_inst.CH0_MIN_IPG_CNT = "0b11";
    defparam DCU0_inst.CH0_CC_MATCH_1 = "0x1BC";
    defparam DCU0_inst.CH0_CC_MATCH_2 = "0x11C";
    defparam DCU0_inst.CH0_CC_MATCH_3 = "0x11C";
    defparam DCU0_inst.CH0_CC_MATCH_4 = "0x11C";
    defparam DCU0_inst.CH0_UDF_COMMA_MASK = "0x3ff";
    defparam DCU0_inst.CH0_UDF_COMMA_A = "0x283";
    defparam DCU0_inst.CH0_UDF_COMMA_B = "0x17C";
    defparam DCU0_inst.CH0_RX_DCO_CK_DIV = "0b000";
    defparam DCU0_inst.CH0_RCV_DCC_EN = "0b0";
    defparam DCU0_inst.CH0_TPWDNB = "0b1";
    defparam DCU0_inst.CH0_RATE_MODE_TX = "0b0";
    defparam DCU0_inst.CH0_RTERM_TX = "0d19";
    defparam DCU0_inst.CH0_TX_CM_SEL = "0b00";
    defparam DCU0_inst.CH0_TDRV_PRE_EN = "0b0";
    defparam DCU0_inst.CH0_TDRV_SLICE0_SEL = "0b01";
    defparam DCU0_inst.CH0_TDRV_SLICE1_SEL = "0b00";
    defparam DCU0_inst.CH0_TDRV_SLICE2_SEL = "0b01";
    defparam DCU0_inst.CH0_TDRV_SLICE3_SEL = "0b01";
    defparam DCU0_inst.CH0_TDRV_SLICE4_SEL = "0b01";
    defparam DCU0_inst.CH0_TDRV_SLICE5_SEL = "0b00";
    defparam DCU0_inst.CH0_TDRV_SLICE0_CUR = "0b011";
    defparam DCU0_inst.CH0_TDRV_SLICE1_CUR = "0b000";
    defparam DCU0_inst.CH0_TDRV_SLICE2_CUR = "0b11";
    defparam DCU0_inst.CH0_TDRV_SLICE3_CUR = "0b11";
    defparam DCU0_inst.CH0_TDRV_SLICE4_CUR = "0b11";
    defparam DCU0_inst.CH0_TDRV_SLICE5_CUR = "0b00";
    defparam DCU0_inst.CH0_TDRV_DAT_SEL = "0b00";
    defparam DCU0_inst.CH0_TX_DIV11_SEL = "0b0";
    defparam DCU0_inst.CH0_RPWDNB = "0b1";
    defparam DCU0_inst.CH0_RATE_MODE_RX = "0b0";
    defparam DCU0_inst.CH0_RX_DIV11_SEL = "0b0";
    defparam DCU0_inst.CH0_SEL_SD_RX_CLK = "0b1";
    defparam DCU0_inst.CH0_FF_RX_H_CLK_EN = "0b0";
    defparam DCU0_inst.CH0_FF_RX_F_CLK_DIS = "0b0";
    defparam DCU0_inst.CH0_FF_TX_H_CLK_EN = "0b0";
    defparam DCU0_inst.CH0_FF_TX_F_CLK_DIS = "0b0";
    defparam DCU0_inst.CH0_TDRV_POST_EN = "0b0";
    defparam DCU0_inst.CH0_TX_POST_SIGN = "0b0";
    defparam DCU0_inst.CH0_TX_PRE_SIGN = "0b0";
    defparam DCU0_inst.CH0_REQ_LVL_SET = "0b00";
    defparam DCU0_inst.CH0_REQ_EN = "0b1";
    defparam DCU0_inst.CH0_RTERM_RX = "0d22";
    defparam DCU0_inst.CH0_RXTERM_CM = "0b11";
    defparam DCU0_inst.CH0_PDEN_SEL = "0b1";
    defparam DCU0_inst.CH0_RXIN_CM = "0b11";
    defparam DCU0_inst.CH0_LEQ_OFFSET_SEL = "0b0";
    defparam DCU0_inst.CH0_LEQ_OFFSET_TRIM = "0b000";
    defparam DCU0_inst.CH0_RLOS_SEL = "0b1";
    defparam DCU0_inst.CH0_RX_LOS_LVL = "0b100";
    defparam DCU0_inst.CH0_RX_LOS_CEQ = "0b11";
    defparam DCU0_inst.CH0_RX_LOS_HYST_EN = "0b0";
    defparam DCU0_inst.CH0_RX_LOS_EN = "0b1";
    defparam DCU0_inst.CH0_LDR_RX2CORE_SEL = "0b0";
    defparam DCU0_inst.CH0_LDR_CORE2TX_SEL = "0b0";
    defparam DCU0_inst.D_TX_MAX_RATE = "2.5";
    defparam DCU0_inst.CH0_CDR_MAX_RATE = "2.5";
    defparam DCU0_inst.CH0_TXAMPLITUDE = "0d1000";
    defparam DCU0_inst.CH0_TXDEPRE = "DISABLED";
    defparam DCU0_inst.CH0_TXDEPOST = "DISABLED";
    defparam DCU0_inst.CH0_PROTOCOL = "PCIE";
    defparam DCU0_inst.D_ISETLOS = "0d0";
    defparam DCU0_inst.D_SETIRPOLY_AUX = "0b00";
    defparam DCU0_inst.D_SETICONST_AUX = "0b00";
    defparam DCU0_inst.D_SETIRPOLY_CH = "0b00";
    defparam DCU0_inst.D_SETICONST_CH = "0b00";
    defparam DCU0_inst.D_REQ_ISET = "0b000";
    defparam DCU0_inst.D_PD_ISET = "0b00";
    defparam DCU0_inst.D_DCO_CALIB_TIME_SEL = "0b00";
    defparam DCU0_inst.CH0_CDR_CNT4SEL = "0b00";
    defparam DCU0_inst.CH0_CDR_CNT8SEL = "0b00";
    defparam DCU0_inst.CH0_DCOATDCFG = "0b00";
    defparam DCU0_inst.CH0_DCOATDDLY = "0b00";
    defparam DCU0_inst.CH0_DCOBYPSATD = "0b1";
    defparam DCU0_inst.CH0_DCOCALDIV = "0b001";
    defparam DCU0_inst.CH0_DCOCTLGI = "0b010";
    defparam DCU0_inst.CH0_DCODISBDAVOID = "0b0";
    defparam DCU0_inst.CH0_DCOFLTDAC = "0b01";
    defparam DCU0_inst.CH0_DCOFTNRG = "0b111";
    defparam DCU0_inst.CH0_DCOIOSTUNE = "0b000";
    defparam DCU0_inst.CH0_DCOITUNE = "0b00";
    defparam DCU0_inst.CH0_DCOITUNE4LSB = "0b111";
    defparam DCU0_inst.CH0_DCOIUPDNX2 = "0b1";
    defparam DCU0_inst.CH0_DCONUOFLSB = "0b101";
    defparam DCU0_inst.CH0_DCOSCALEI = "0b00";
    defparam DCU0_inst.CH0_DCOSTARTVAL = "0b000";
    defparam DCU0_inst.CH0_DCOSTEP = "0b00";
    defparam DCU0_inst.CH0_BAND_THRESHOLD = "0d0";
    defparam DCU0_inst.CH0_AUTO_FACQ_EN = "0b1";
    defparam DCU0_inst.CH0_AUTO_CALIB_EN = "0b1";
    defparam DCU0_inst.CH0_CALIB_CK_MODE = "0b0";
    defparam DCU0_inst.CH0_REG_BAND_OFFSET = "0d0";
    defparam DCU0_inst.CH0_REG_BAND_SEL = "0d0";
    defparam DCU0_inst.CH0_REG_IDAC_SEL = "0d0";
    defparam DCU0_inst.CH0_REG_IDAC_EN = "0b0";
    defparam DCU0_inst.D_CMUSETISCL4VCO = "0b000";
    defparam DCU0_inst.D_CMUSETI4VCO = "0b00";
    defparam DCU0_inst.D_CMUSETINITVCT = "0b00";
    defparam DCU0_inst.D_CMUSETZGM = "0b000";
    defparam DCU0_inst.D_CMUSETP2AGM = "0b000";
    defparam DCU0_inst.D_CMUSETP1GM = "0b000";
    defparam DCU0_inst.D_CMUSETI4CPZ = "0d3";
    defparam DCU0_inst.D_CMUSETI4CPP = "0d3";
    defparam DCU0_inst.D_CMUSETICP4Z = "0b101";
    defparam DCU0_inst.D_CMUSETICP4P = "0b01";
    defparam DCU0_inst.D_CMUSETBIASI = "0b00";
    defparam DCU0_inst.D_SETPLLRC = "0d1";
    defparam DCU0_inst.CH0_RX_RATE_SEL = "0d8";
    defparam DCU0_inst.D_REFCK_MODE = "0b100";
    defparam DCU0_inst.D_TX_VCO_CK_DIV = "0b000";
    defparam DCU0_inst.D_PLL_LOL_SET = "0b01";
    defparam DCU0_inst.D_RG_EN = "0b0";
    defparam DCU0_inst.D_RG_SET = "0b00";
    assign n1 = 1'bz;
    assign n2 = 1'bz;
    assign n3 = 1'bz;
    assign n4 = 1'bz;
    assign n5 = 1'bz;
    assign n6 = 1'bz;
    assign n7 = 1'bz;
    assign n8 = 1'bz;
    assign n9 = 1'bz;
    assign n10 = 1'bz;
    assign n11 = 1'bz;
    assign n12 = 1'bz;
    assign n13 = 1'bz;
    assign n14 = 1'bz;
    assign n15 = 1'bz;
    assign n16 = 1'bz;
    assign n17 = 1'bz;
    assign n18 = 1'bz;
    assign n19 = 1'bz;
    assign n20 = 1'bz;
    assign n21 = 1'bz;
    assign n22 = 1'bz;
    assign n23 = 1'bz;
    assign n24 = 1'bz;
    assign n25 = 1'bz;
    assign n26 = 1'bz;
    assign n27 = 1'bz;
    assign n28 = 1'bz;
    assign n29 = 1'bz;
    assign n30 = 1'bz;
    assign n31 = 1'bz;
    assign n32 = 1'bz;
    assign n33 = 1'bz;
    assign n34 = 1'bz;
    assign n35 = 1'bz;
    assign n36 = 1'bz;
    assign n37 = 1'bz;
    assign n38 = 1'bz;
    assign n41 = 1'bz;
    assign n42 = 1'bz;
    assign n43 = 1'bz;
    assign n44 = 1'bz;
    assign n45 = 1'bz;
    assign n46 = 1'bz;
    assign n47 = 1'bz;
    assign n48 = 1'bz;
    assign n49 = 1'bz;
    assign n50 = 1'bz;
    assign n51 = 1'bz;
    assign n52 = 1'bz;
    assign n53 = 1'bz;
    assign n54 = 1'bz;
    assign n55 = 1'bz;
    assign n56 = 1'bz;
    assign n57 = 1'bz;
    assign n58 = 1'bz;
    assign n59 = 1'bz;
    assign n60 = 1'bz;
    assign n61 = 1'bz;
    assign n62 = 1'bz;
    assign n63 = 1'bz;
    assign n64 = 1'bz;
    assign n65 = 1'bz;
    assign n66 = 1'bz;
    assign n67 = 1'bz;
    assign n68 = 1'bz;
    assign n69 = 1'bz;
    assign n70 = 1'bz;
    assign n71 = 1'bz;
    assign n72 = 1'bz;
    assign n73 = 1'bz;
    assign n74 = 1'bz;
    assign n75 = 1'bz;
    assign n76 = 1'bz;
    assign n77 = 1'bz;
    assign n78 = 1'bz;
    assign n79 = 1'bz;
    assign n80 = 1'bz;
    assign n81 = 1'bz;
    assign n82 = 1'bz;
    assign n83 = 1'bz;
    assign n84 = 1'bz;
    assign n85 = 1'bz;
    assign n86 = 1'bz;
    assign n87 = 1'bz;
    assign n88 = 1'bz;
    assign n89 = 1'bz;
    assign n90 = 1'bz;
    assign n91 = 1'bz;
    assign n92 = 1'bz;
    assign n93 = 1'bz;
    assign n94 = 1'bz;
    assign n95 = 1'bz;
    assign n96 = 1'bz;
    assign n97 = 1'bz;
    assign n98 = 1'bz;
    assign n99 = 1'bz;
    assign n100 = 1'bz;
    assign n101 = 1'bz;
    assign n112 = 1'bz;
    x_pcie_pcsrsl_core rsl_inst (.rui_rst(rsl_rst), .rui_serdes_rst_dual_c(serdes_rst_dual_c), 
            .rui_rst_dual_c(rst_dual_c), .rui_rsl_disable(rsl_disable), 
            .rui_tx_ref_clk(pll_refclki), .rui_tx_serdes_rst_c(tx_serdes_rst_c), 
            .rui_tx_pcs_rst_c({3'b000, tx_pcs_rst_c}), .rdi_pll_lol(pll_lol), 
            .rui_rx_ref_clk(rxrefclk), .rui_rx_serdes_rst_c({3'b000, rx_serdes_rst_c}), 
            .rui_rx_pcs_rst_c({3'b000, rx_pcs_rst_c}), .rdi_rx_los_low_s({3'b000, 
            rx_los_low_s}), .rdi_rx_cdr_lol_s({3'b000, rx_cdr_lol_s}), 
            .rdo_serdes_rst_dual_c(rsl_serdes_rst_dual_c), .rdo_rst_dual_c(rsl_rst_dual_c), 
            .ruo_tx_rdy(rsl_tx_rdy), .rdo_tx_serdes_rst_c(rsl_tx_serdes_rst_c), 
            .rdo_tx_pcs_rst_c({n113, n114, n115, rsl_tx_pcs_rst_c}), 
            .ruo_rx_rdy(rsl_rx_rdy), .rdo_rx_serdes_rst_c({n116, n117, 
            n118, rsl_rx_serdes_rst_c}), .rdo_rx_pcs_rst_c({n119, n120, 
            _Z, rsl_rx_pcs_rst_c}));
    defparam rsl_inst.pnum_channels = 1;
    defparam rsl_inst.pprotocol = "PCIE";
    defparam rsl_inst.pserdes_mode = "RX AND TX";
    defparam rsl_inst.pport_tx_rdy = "ENABLED";
    defparam rsl_inst.pwait_tx_rdy = 3000;
    defparam rsl_inst.pport_rx_rdy = "ENABLED";
    defparam rsl_inst.pwait_rx_rdy = 3000;
    assign n113 = 1'bz;
    assign n114 = 1'bz;
    assign n115 = 1'bz;
    assign n116 = 1'bz;
    assign n117 = 1'bz;
    assign n118 = 1'bz;
    assign n119 = 1'bz;
    assign n120 = 1'bz;
    assign _Z = 1'bz;
    x_pcie_pcssll_core sll_inst (.sli_rst(sli_rst), .sli_refclk(pll_refclki), 
            .sli_pclk(tx_pclk), .sli_div2_rate(1'b0), .sli_div11_rate(1'b0), 
            .sli_gear_mode(1'b0), .sli_cpri_mode({3'b000}), .sli_pcie_mode(sli_pcie_mode), 
            .slo_plol(pll_lol));
    defparam sll_inst.PPROTOCOL = "PCIE";
    defparam sll_inst.PLOL_SETTING = 1;
    defparam sll_inst.PDYN_RATE_CTRL = "DISABLED";
    defparam sll_inst.PPCIE_MAX_RATE = "2.5";
    defparam sll_inst.PDIFF_VAL_LOCK = 49;
    defparam sll_inst.PDIFF_VAL_UNLOCK = 328;
    defparam sll_inst.PPCLK_TC = 163840;
    defparam sll_inst.PDIFF_DIV11_VAL_LOCK = 0;
    defparam sll_inst.PDIFF_DIV11_VAL_UNLOCK = 0;
    defparam sll_inst.PPCLK_DIV11_TC = 0;
    
endmodule



