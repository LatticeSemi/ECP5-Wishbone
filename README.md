# ECP5-Wishbone
Lattice ECP5 PCIe Gen1 1xLane to Wishbone

Ref Desgin uses
Hardware: ECP5 Versa Board https://www.latticesemi.com/products/developmentboardsandkits/ecp5versadevelopmentkit
Desgin Software: Diamond 3.12 https://www.latticesemi.com/Products/DesignSoftwareAndIP/FPGAandLDS/LatticeDiamond
IP Core: PCI Express Endpoint Core V6.8 https://www.latticesemi.com/products/designsoftwareandip/intellectualproperty/ipcore/ipcores01/pciexpressendpointcore
Software driver : Linux 

FPGA Design Getting started 
Diamond 3.12 
set working directory to <tcl>".../ECP5_Wishbone/work/diamond"

run setup project <tcl>"source ../../scripts/versa_ecp5.tcl

setup PCIe and Clock Ref IP
  in File List viewer double click on ../../clarity/versa_ecp5/pcie_x1_e5 opens Clarity Designer
  Clarity Designer/Catalog/Import IP
    Import PCIe => file in scripts/ecp5um x_pcie.lpc => Target Instance: "x_pcie"
    Import Clock Ref => file in scripts/ecp5um x_cref.lpc => Target Instance: "x_cref"
    move both IP in Channel0
    run "DRC"
    run "Generate"

Implement reset patch
  run scripte <tcl> " source ../../scripte/clarity/patch_versa_e5.tcl"
  
Proejct ready to start synthesize, map design, place/route and export bitstream
