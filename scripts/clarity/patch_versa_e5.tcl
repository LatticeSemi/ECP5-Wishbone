global env

if {! [info exists project_root]} {
   set scriptname    [file normalize [info script]]
   set scriptdir     [file dirname $scriptname]
   set scriptdir     [file normalize $scriptdir]

   if {[string length $scriptname] == 0} {
      puts "Cannot determine project root directory"
      puts "Enter path or type return to accept"
      puts [concat "(" [pwd] "?)\n"]

      set project_root [gets stdin]

      if {([regexp "^\[ \t]*$" $project_root] == 1) ||
          ([string length $project_root] == 0)} {
         set project_root [pwd]
         puts "Using $project_root as Project Root Directory"
         }
      } else {
      set project_root [file dirname [file dirname [file dirname $scriptname]]]
      }
   regsub {\/[ \t]*$} $project_root  {} project_root

   if {! [file isdirectory $project_root]} {
      puts "Directory $project_root not found. Exiting\n"
      exit
      }
   }
   
set project_root [file normalize $project_root]

puts "**  Applying patch from Product Bulletin FPGA-PB-02001 (Jun. 2021) to PCIe Core"
puts "copy -force $project_root/soc_impl/x_pcie_pcs/ecp5_ip6v4/vlog/x_pcie_pcs.v $project_root/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/"

file copy -force $project_root/soc_impl/x_pcie_pcs/ecp5_ip6v4/vlog/x_pcie_pcs.v $project_root/work/clarity/versa_ecp5/pcie_x1_e5/x_pcie/pcie_eval/models/ecp5um/
