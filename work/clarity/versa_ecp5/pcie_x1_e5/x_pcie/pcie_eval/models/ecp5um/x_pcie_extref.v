// Verilog netlist produced by program ASBGen
// Netlist written on Thu Jul 25 14:04:43 2013
//
// Verilog Description of module pcie_extref
//

`timescale 1ns/1ps
module pcie_extref (refclkp, refclkn, refclko);
    input refclkp;
    input refclkn;
    output refclko;
    
    
    EXTREFB EXTREF0_inst (.REFCLKP(refclkp), .REFCLKN(refclkn), .REFCLKO(refclko)) /* synthesis LOC=EXTREF0 */ ;
    defparam EXTREF0_inst.REFCK_PWDNB = "0b1";
    defparam EXTREF0_inst.REFCK_RTERM = "0b1";
    defparam EXTREF0_inst.REFCK_DCBIAS_EN = "0b0";
    
endmodule

