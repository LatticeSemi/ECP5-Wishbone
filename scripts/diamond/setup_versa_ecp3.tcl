# ------------------------------------------------------------------------------
# 
#  File ID     : $Id: setup_versa_ecp3.tcl 46 2021-11-18 22:45:40Z  $
#  Generated   : $LastChangedDate: 2021-11-18 23:45:40 +0100 (Thu, 18 Nov 2021) $
#  Revision    : $LastChangedRevision: 46 $
# 
# ------------------------------------------------------------------------------

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     C o n f i g u r a t i o n   S e t t i n g s
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set FPGA_TECH "ECP3";
set project_name "versa_ecp3"
set project_impl "ae53"
set project_tech "ecp3"
set target_name "versa_ecp3"
set fpga_device "LFE3-35EA-8FN484C"

   # set to 'lse' or 'synplify'
set syn_tool "synplify"

set soc_flist_prepend {}

   #  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      # bd_hw_eval : ["Disable", "Enable"]
set bd_hw_eval          "Disable"

set mpar_cores(linux)   12
set mpar_cores(win)     3

   #  ==========================================================================

   #  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   #     TfReadFileList
   #  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
proc TfReadFileList {fname_flist} {
   global env
   global prj_fnames
   global project_root
   
   set fname_list {}
   
   puts "Reading File List from $fname_flist ..."     
   if [catch {open "$project_root/flow/file_lists/$fname_flist" r} fh_fnames] {
      puts "could not open file $project_root/flow/file_lists/$fname_flist for reading"
      return -1
      }   
   
   set fname_list [split [read $fh_fnames] \n]
   close $fh_fnames 
   
   foreach fname $fname_list {
      set fname [string trim $fname]
      if {[string length $fname] > 0} {
         set fncmd [split $fname ]
         
            # Search for
            #     Keywords : [file, include, unit]
            #     Comments : ["// ", "# "], must be followed by space or eol
            #     Default  : Single file-name string
         switch [lindex $fncmd 0] {
            file {lappend prj_fnames [lindex $fncmd 1]}
            
            include {TfReadFileList [lindex $fncmd 1]}

            unit {lappend prj_fnames [lindex $fncmd 1]}
            
            \# { }            
            \/\/ { }
            
            default {lappend prj_fnames [lindex $fncmd 0]}
            }
         }
      }
   }
   
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     M a i n        M a i n        M a i n        M a i n        M a i n
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

if {! [info exists project_name]} {
   set project_name [file tail $project_root]
   }

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Create Project
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puts "Project = $project_name"

cd $project_root/work/diamond
if {! ([file exists $target_name] && [file isdirectory $target_name])} {
   file mkdir $target_name
   }
cd $target_name

if {[file exists $project_impl] && [file isdirectory $project_impl]} {
   puts "Removing existing directory $project_impl"
   file delete -force $project_impl
   }
   
set prj_cmd "prj_project new -name $project_name -dev $fpga_device -impl $project_impl"
puts $prj_cmd
prj_project new -name $project_name -dev $fpga_device -impl $project_impl

   # Set Verilog include Path(s)
prj_impl option {include path}  "$project_root/work/ip_express/versa_ecp3/pcie_x1_v6/pcie_eval/pcie_x1_ipx/src/params"
   
   # Load strategy 
puts "Loading strategy ..."  
prj_strgy import -name "Default" -file "$project_root/scripts/diamond/default_${project_tech}.sty"
prj_strgy set "Default"

   # Setup the preferences file
puts "Loading preferences ..."  
prj_src add -exclude "$project_root/scripts/diamond/$project_name.lpf"
prj_src enable "$project_root/scripts/diamond/$project_name.lpf"

puts "Selecting and Configuring $syn_tool as synthesis Tool ..."
prj_syn set $syn_tool
prj_strgy set_value -strategy "Default" bd_hardware_eval=$bd_hw_eval
prj_strgy set_value -strategy "Default" syn_vhdl2008=True

puts [concat "project_root : " $project_root]

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Get Project Files
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set prj_fnames {}

if {! ([file exists $project_root/flow/file_lists/${target_name}_files.lst] && [file isfile $project_root/flow/file_lists/${target_name}_files.lst])} {
   puts "could not open file $project_root/flow/file_lists/${target_name}_files.lst for reading"
   return -1
   }

TfReadFileList ${target_name}_files.lst   

puts [concat [llength $prj_fnames] " files found"]

set prj_fnames [concat $soc_flist_prepend $prj_fnames]
puts [concat [llength $prj_fnames] " files found"]

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Add files to project
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
puts "Adding Files to Project ..."   
foreach fname $prj_fnames {
   puts [concat "examining " $fname]
   
   if [regexp -nocase -- {.vhd[\s]?$} $fname] {
      if [regexp {^\s*\/} $fname] {
            # This is an absolute path
         set prj_cmd [concat "prj_src add -format VHDL" $fname] 
         puts $prj_cmd
         prj_src add -format VHDL $fname
         } else {
            # This is a relative path
         set prj_cmd [concat "prj_src add -format VHDL" $project_root/$fname] 
         puts $prj_cmd
         prj_src add -format VHDL $project_root/$fname
         }
      }
      
   if [regexp -nocase -- {.v[\s]?$} $fname] {
      if [regexp {^\s*\/} $fname] {
            # This is an absolute path
         prj_src add -format VERILOG $fname 
         } else {
            # This is a relative path
         prj_src add -format VERILOG $project_root/$fname 
         }   
      }   

   if [regexp -nocase -- {.ipx[\s]?$} $fname] {   
      if [regexp {^\s*\/} $fname] {
            # This is an absolute path
         prj_src add $fname 
         } else {
            # This is a relative path
         prj_src add $project_root/$fname 
         }         
      }
      
   if [regexp -nocase -- {.sbx[\s]?$} $fname] {   
      if [regexp {^\s*\/} $fname] {
            # This is an absolute path
         prj_src add $fname 
         } else {
            # This is a relative path
         prj_src add $project_root/$fname 
         }         
      }
   } 
   
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Create Multi-Par Control Files
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
puts "Setting up MPAR Control Files ..."
set this_host [info hostname]
set this_host [lindex [split $this_host "\."] 0]

if [catch {open "$project_root/work/diamond/synth_nodes_linux.txt" w} fh_mpar_lx] {
   puts "could not open file $project_root/work/diamond/synth_nodes_linux.txt for writing"
   } else {
   puts $fh_mpar_lx "\[$this_host\]"
   puts $fh_mpar_lx "SYSTEM = linux"
   puts $fh_mpar_lx "CORENUM = $mpar_cores(linux)"
   
   close $fh_mpar_lx
   }
   
if [catch {open "$project_root/work/diamond/synth_nodes_win.txt" w} fh_mpar_pc] {
   puts "could not open file $project_root/work/diamond/synth_nodes_win.txt for writing"
   } else {
   puts $fh_mpar_pc "\[$this_host\]"
   puts $fh_mpar_pc "SYSTEM = PC"
   puts $fh_mpar_pc "CORENUM = $mpar_cores(win)"
   
   close $fh_mpar_pc
   }

set this_os $::tcl_platform(platform)
regsub {windows} $this_os  {win} this_os
regsub {unix} $this_os  {linux} this_os

prj_strgy set_value -strategy "Default" par_multi_node_list=${project_root}/work/diamond/synth_nodes_${this_os}.txt
   # Important! Otherwise there may be reset issues with PCIe IP
prj_strgy set_value -strategy "Default" syn_force_gsr=False

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Clean the Clarity project
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


cd "${project_root}/work/diamond"

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Finalise
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
prj_project save

puts "Build Project done."
