// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.12.1.454
// Netlist written on Wed Dec 29 12:06:50 2021
//
// Verilog Description of module x_cref
//

module x_cref (refclkp, refclkn, refclko) /* synthesis syn_module_defined=1 */ ;   // c:/projects/ecp5_wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_cref/x_cref.v(8[8:14])
    input refclkp /* synthesis black_box_pad_pin=1 */ ;   // c:/projects/ecp5_wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_cref/x_cref.v(9[11:18])
    input refclkn /* synthesis black_box_pad_pin=1 */ ;   // c:/projects/ecp5_wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_cref/x_cref.v(10[11:18])
    output refclko;   // c:/projects/ecp5_wishbone/work/clarity/versa_ecp5/pcie_x1_e5/x_cref/x_cref.v(11[12:19])
    
    
    wire GND_net, VCC_net;
    
    GSR GSR_INST (.GSR(VCC_net));
    VLO i26 (.Z(GND_net));
    EXTREFB EXTREF1_inst (.REFCLKP(refclkp), .REFCLKN(refclkn), .REFCLKO(refclko)) /* synthesis LOC="EXTREF1", syn_instantiated=1 */ ;
    defparam EXTREF1_inst.REFCK_PWDNB = "0b1";
    defparam EXTREF1_inst.REFCK_RTERM = "0b1";
    defparam EXTREF1_inst.REFCK_DCBIAS_EN = "0b0";
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VHI i27 (.Z(VCC_net));
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

