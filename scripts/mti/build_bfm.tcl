
#
# sometimes this script fails if the directory containing the BFM is a mount and not a 
# directory on the local machine. Looks like a mentor bug!
#  ** Error: ../../verify/testbench/models/pcie_bfm/src/bfm_lspcie_rc.v(34954): 
#            Cannot open `include file "bfm_lspcie_rc_tlm_lib.v".
# 
# As a workaround just copy the files from verify/testbench/models/pcie_bfm/src to a local directory
# e.g. somewhere under /tmp and change the path in the vlog call below
# It even seems to be sufficient to set an +incdir+ to the local directory in the vlog line below
# and leave unchanged otherwise
#

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
puts "Using $project_root as Project Root Directory"

vlib -dirpath pcie_bfm_lib pcie_bfm_lib
#vlog -sv -work pcie_bfm_lib -L pmi_work -L ovi_ecp5um $project_root/verify/testbench/models/pcie_bfm/src/bfm_lspcie_rc.v 
vlog -sv -work pcie_bfm_lib -L pmi_work -L ovi_ecp5um $project_root/verify/testbench/models/pcie_bfm/src/bfm_lspcie_rc.v +incdir+/tmp/cfgard/src

vcom -2008 -work pcie_bfm_lib $project_root/verify/testbench/models/pcie_bfm/src/bfm_lspcie_rc.vhd
vcom -2008 -work pcie_bfm_lib $project_root/verify/scenarios/vhdl/test_case_util-p.vhd
vcom -2008 -work pcie_bfm_lib $project_root/verify/scenarios/vhdl/smoke_test.vhd
