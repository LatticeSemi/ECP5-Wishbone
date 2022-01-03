#!/usr/bin/tclsh

global env

if {$argc == 0} {
   puts "Parameters required, at least file name"
   
   return 0
   }

#  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#     Subroutines
#  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
   #  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
   #     TfReadFileList
   #  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    
proc TfReadFileList {fname_flist} {
   global env
   global params
   global prj_fnames
   global project_root
   
   set fname_list {}
   
   puts "Reading File List from $fname_flist ..."     
   if [catch {open "$params(UNIT)/flow/file_lists/$fname_flist" r} fh_fnames] {
      puts "could not open file $params(UNIT)/flow/file_lists/$fname_flist for reading"
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
            file {set fspec "";
                  for {set ix 1} {$ix < [llength $fncmd]} {incr ix} {
                     set fspec [concat $fspec [lindex $fncmd $ix]]}
                  lappend prj_fnames $fspec}
            
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
   #     Get Default and Environment variables
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
set db_cursor 0   
set prj_fnames {}

if {! [info exists env(TF_HOME)]} {
   set env(TF_HOME) [file dirname [file dirname [pwd]]]
   }

set project_root $env(TF_HOME)   
set params(VLOG_LIBS) ""
set params(TF_TOOLKIT) "Aldec"

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Allow specifying parameter values from the work environment
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
if {[info exists env(TF_TOOLKIT]} {
   set params(TF_TOOLKIT)  "$env(TF_TOOLKIT)" 
   }
   
if {[info exists env(TF_UNIT)]} {
   set params(UNIT)  "$env(TF_UNIT)" 
   } else {
   set params(UNIT) $project_root
   }
   
if {[info exists env(TF_VLOG_LIBS)]} {
   set vlog_lib_list [split $env(TF_VLOG_LIBS) {:,}]
   
   foreach lname $vlog_lib_list {
      set params(VLOG_LIBS) [concat "-l $lname " $params(VLOG_LIBS)]
      }
   puts [concat "Using verilog libraries " $params(VLOG_LIBS)]
   }
   
if {[info exists env(TF_WORK_LIB)]} {
   set params(WORK_LIB)  "$env(TF_WORK_LIB)" 
   }
   
if {[info exists env(TF_WORK_LIB_PHYS)]} {
   set params(WORK_LIB_PHYS)  "$env(TF_WORK_LIB_PHYS)" 
   }

puts "Project Root is $project_root"
   
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Parse the command line
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
set ix 0
while {$ix < $argc} {
      # Look for parameters beginning with a '-'
   if {[regexp -nocase -- {^\s*\-} [lindex $argv $ix]]} {   
         # Handle '-l' for target library
      if {[regexp -nocase -- {^\s*\-l} [lindex $argv $ix]]} {
         set ix [expr $ix + 1] 
         if {$ix < $argc} {
            set param_val [lindex $argv $ix] 
            set lib_list [split $param_val {;:,}]
            if {[llength $lib_list] > 1} {
               set params(WORK_LIB)       [lindex $lib_list 0]
               set params(WORK_LIB_PHYS)  [lindex $lib_list 1]
               } else {
                  set params(WORK_LIB)       [lindex $lib_list 0]
                  set params(WORK_LIB_PHYS)  [lindex $lib_list 0]               
                  }
            }
            
            # Handle '-u' for alternative unit root
         } elseif {[regexp -nocase -- {^\s*\-u} [lindex $argv $ix]]} {
            set ix [expr $ix + 1] 
            if {$ix < $argc} {
               set params(UNIT) [lindex $argv $ix] 
               }
            }
         
      } else {
         set task_name [lindex $argv $ix]
         }

   set ix [expr $ix + 1] 
   }
   
if {! [info exists task_name]} {
   puts "Parameters required, task name missing"
   
   return 0
   }
   
if {! [info exists params(WORK_LIB)]} {
   set params(WORK_LIB)  "${task_name}_lib"
   }
   
if {! [info exists params(WORK_LIB_PHYS)]} {
   set params(WORK_LIB_PHYS)  $params(WORK_LIB)
   }

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Create the Work Library
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
cd $project_root/work/mti
set hdl_cmd "vlib $params(WORK_LIB)"
puts $hdl_cmd
puts [eval exec $hdl_cmd]
   
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Get the file-list
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
TfReadFileList ${task_name}_files.lst   

puts [concat [llength $prj_fnames] " files found"]

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Parse the file-names and file-specific parameters
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
foreach fline $prj_fnames {
   if {! ([regexp -nocase -- {^\s*#} $fline] || [regexp -nocase -- {^\s*//} $fline])} {
      set imf_fields [regexp -all -inline {\S+} $fline ]
      
      foreach fval $imf_fields {
            # Look for the file name
         if {! [regexp -nocase -- {^\s*-} $fval]} {
            dict set flist_DB $db_cursor dbf_fname $fval 
            dict set flist_DB $db_cursor dbf_inc_dir " "        
            dict set flist_DB $db_cursor dbf_lib_name " "   
            dict set flist_DB $db_cursor dbf_lang_std " "

            if [regexp -nocase -- {\.sv[\s]?$} $fval] {
               dict set flist_DB $db_cursor dbf_lang_std "-sv2k12"        
               }
               
            if [regexp -nocase -- {\.vhd[\s]?$} $fval] {
               dict set flist_DB $db_cursor dbf_lang_std "-2008"        
               }
               
            if [regexp -nocase -- {_vlog\.lst[\s]?$} $fval] {
               dict set flist_DB $db_cursor dbf_lang_std " "             
               }
               
            if [regexp -nocase -- {\.v[\s]?$} $fval] {
               dict set flist_DB $db_cursor dbf_lang_std "-sv"              
               }                           
            }
         }
      
      foreach fval $imf_fields {
            # Update file-specific parameters
            # e.g. <path_to_file>/<file_name>.vhd  -std:2002
         if {[regexp -nocase -- {^\s*\-} $fval]} {         
            set fparams [split $fval :] 
               
            if [regexp -nocase -- "-inc" [lindex $fparams 0]] {
               set inc_dir [lindex $fparams 1]

               if {! [regexp {^\s*\/} $inc_dir]} {
                     # Include PATH is a relative path
                  set inc_dir $params(UNIT)/$inc_dir
                  }
      
               set inc_dir "+incdir+$inc_dir"
               dict set flist_DB $db_cursor dbf_inc_dir [concat [dict get $flist_DB $db_cursor dbf_inc_dir] $inc_dir]
               }        
               
            if [regexp -nocase -- "-lib" [lindex $fparams 0]] {
               set vlog_lib [lindex $fparams 1]
               set vlog_lib "-l $vlog_lib"
               dict set flist_DB $db_cursor dbf_lib_name [concat [dict get $flist_DB $db_cursor dbf_lib_name] $vlog_lib]
               }        
               
            if [regexp -nocase -- "-std" [lindex $fparams 0]] {
               set lang_std [lindex $fparams 1]
               set lang_std "-$lang_std"
               dict set flist_DB $db_cursor dbf_lang_std $lang_std   
               }
               
            if [regexp -nocase -- "-work" [lindex $fparams 0]] {
               set work_lib [lindex $fparams 1]
               set work_lib "$work_lib"
               dict set flist_DB $db_cursor dbf_work_lib $work_lib   
               }               
            }
         }  
      
      set db_cursor [expr $db_cursor + 1]
      }
   }

   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   #     Build the target
   #  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
foreach key [dict keys $flist_DB] {
   set fname [dict get $flist_DB $key dbf_fname]
   set params(LANG_STD) [dict get $flist_DB $key dbf_lang_std]
   set params(INC_DIR) [dict get $flist_DB $key dbf_inc_dir]
   set params(COMP_LIB) [dict get $flist_DB $key dbf_lib_name]
   set params(TGT_LIB) $params(WORK_LIB)
   
   if {[dict exists $flist_DB $key dbf_work_lib]} {
      set params(TGT_LIB) [dict get $flist_DB $key dbf_work_lib]
      }
      
   if {! [regexp {^\s*\/} $fname]} {
         # File name is a relative path
      set fname $params(UNIT)/$fname
      }
   
   if {[file exists $fname] && [file isfile $fname]} {
      if [regexp -nocase -- {\.sv[\s]?$} $fname] {
         set hdl_cmd "vlog $params(LANG_STD) $params(COMP_LIB) $params(INC_DIR) -work $params(TGT_LIB) $fname"
         puts $hdl_cmd
         puts [eval exec $hdl_cmd]         
         }
         
      if [regexp -nocase -- {\.vhd[\s]?$} $fname] {
         set hdl_cmd "vcom $params(LANG_STD) -work $params(TGT_LIB) $fname"
         puts $hdl_cmd
         puts [eval exec $hdl_cmd]         
         }
         
      if [regexp -nocase -- {_vlog\.lst[\s]?$} $fname] {
         set hdl_cmd "vlog $params(LANG_STD) $params(COMP_LIB) $params(INC_DIR) -work $params(TGT_LIB)"
         set hdl_cmd [concat $hdl_cmd $params(VLOG_LIBS) " -f " $fname]
         puts $hdl_cmd
         puts [eval exec $hdl_cmd]          
         }
         
      if [regexp -nocase -- {\.v[\s]?$} $fname] {
         set hdl_cmd "vlog $params(LANG_STD) $params(COMP_LIB) $params(INC_DIR) -work $params(TGT_LIB)"
         set hdl_cmd [concat $hdl_cmd $params(VLOG_LIBS) $fname]
         puts $hdl_cmd
         puts [eval exec $hdl_cmd]    
         }   
      puts " "   
      
      } else {
         puts [concat "File" $fname "not found"]
         puts " "   
         }
   }
