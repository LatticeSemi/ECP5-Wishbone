// Verilog netlist produced by program ASBGen: Ports rev. 2.30, Attr. rev. 2.65
// Netlist written on Wed Dec 29 14:25:28 2021
//
// Verilog Description of module x_cref
//

`timescale 1ns/1ps
module x_cref (refclkp, refclkn, refclko);
    input refclkp;
    input refclkn;
    output refclko;
    
    
    EXTREFB EXTREF0_inst (.REFCLKP(refclkp), .REFCLKN(refclkn), .REFCLKO(refclko)) /* synthesis LOC=EXTREF0 */ ;
    defparam EXTREF0_inst.REFCK_PWDNB = "0b1";
    defparam EXTREF0_inst.REFCK_RTERM = "0b1";
    defparam EXTREF0_inst.REFCK_DCBIAS_EN = "0b0";
    
endmodule

