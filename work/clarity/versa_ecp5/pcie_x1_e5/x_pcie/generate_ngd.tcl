#!/usr/local/bin/wish

set cpu  $tcl_platform(machine)

switch $cpu {
 intel -
 i*86* {
     set cpu ix86
 }
 x86_64 {
     if {$tcl_platform(wordSize) == 4} {
     set cpu ix86
     }
 }
}

switch $tcl_platform(platform) {
    windows {
        set Para(os_platform) windows
   if {$cpu == "amd64"} {
     # Do not check wordSize, win32-x64 is an IL32P64 platform.
     set cpu x86_64
     }
    }
    unix {
        if {$tcl_platform(os) == "Linux"}  {
            set Para(os_platform) linux
        } else  {
            set Para(os_platform) unix
        }
    }
}

if {$cpu == "x86_64"} {
 set NTPATH nt64
 set LINPATH lin64
} else {
 set NTPATH nt
 set LINPATH lin
}

if {$Para(os_platform) == "linux" } {
    set os $LINPATH
} else {
    set os $NTPATH
}
set Para(ProjectPath) [file dirname [info script]]
set Para(install_dir) $env(TOOLRTF)
set Para(design) "verilog"
set Para(Bin) "[file join $Para(install_dir) bin $os]"
set Para(FPGAPath) "[file join $Para(install_dir) ispfpga bin $os]"
lappend auto_path "$Para(install_dir)/tcltk/lib/ipwidgets/ispipbuilder/../runproc"
package require runcmd

set Para(ModuleName) "x_pcie"
set Para(Family) "sa5p00m"
set Para(tech) ecp5um
set Para(caelib) ecp5um
set Para(PartType) "LFE5UM-45F"
set Para(PartName) "LFE5UM-45F-8BG381C"
set Para(SpeedGrade) "8"
set retdir [pwd]
cd $Para(ProjectPath)
set synpwrap_cmd "$Para(Bin)/synpwrap"
if {[file exist syn_results]} {
} else {
file mkdir syn_results
}

cd "$Para(ProjectPath)/syn_results"

    if [catch {open $Para(ModuleName)_lattice.synproj w} rspFile] {
      puts stderr "Cannot create response file $Para(ModuleName)_lattice.synproj: $rspFile"
      return -1
   } else {
     puts $rspFile "-a \"$Para(family)\"
-d $Para(PartType)
-t $Para(Package)
-s $Para(SpeedGrade)
-frequency 100
-optimization_goal Balanced
-bram_utilization 100
-ramstyle Auto
-romstyle auto
-use_carry_chain 1
-carry_chain_length 0
-force_gsr 0
-resource_sharing 1
-propagate_constants 1
-remove_duplicate_regs 1
-mux_style Auto
-max_fanout 1000
-fsm_encoding_style Auto
-twr_paths 3
-use_io_insertion 0
-resolve_mixed_drivers 0
-use_io_reg 0
-lpf 0
-p \"$Para(ProjectPath)\" \"$Para(ProjectPath)/syn_results\"
-ver \"$Para(install_dir)/cae_library/synthesis/verilog/$Para(caelib).v\"
\"$Para(ProjectPath)/$Para(ModuleName)_core_bb.v\"
\"$Para(ProjectPath)/$Para(ModuleName).v\"
\"$Para(ProjectPath)/pcie_eval/models/$Para(tech)/$Para(ModuleName)_pcs_softlogic.v\"
\"$Para(ProjectPath)/pcie_eval/models/$Para(tech)/$Para(ModuleName)_pcs.v\"
\"$Para(ProjectPath)/pcie_eval/models/$Para(tech)/$Para(ModuleName)_sync1s.v\"
\"$Para(ProjectPath)/pcie_eval/models/$Para(tech)/$Para(ModuleName)_ctc.v\"
\"$Para(ProjectPath)/pcie_eval/models/$Para(tech)/$Para(ModuleName)_pipe.v\"
\"$Para(ProjectPath)/pcie_eval/models/$Para(tech)/$Para(ModuleName)_phy.v\"
-top $Para(ModuleName)
-ngo $Para(ModuleName).ngo
"
     close $rspFile
  }

  if [runCmd "\"$Para(FPGAPath)/synthesis\" -f $Para(ModuleName)_lattice.synproj"] {
    return
  } else {
    vwait done
    if [checkResult $done] {
      return
    }
  }

  file copy -force $Para(ModuleName).ngo ../
cd ..
	if [runCmd "\"$Para(FPGAPath)/ngdbuild\" -dt -a $Para(family) -d $Para(PartType) -p \"$Para(install_dir)/ispfpga/$Para(Family)/data\" -p \"syn_results\" \"$Para(ModuleName).ngo\" \"$Para(ModuleName).ngd\""] {
				return
	} else {
				vwait done
				if [checkResult $done] {
					return
				}
	}

file delete -force "syn_results"
cd $retdir

