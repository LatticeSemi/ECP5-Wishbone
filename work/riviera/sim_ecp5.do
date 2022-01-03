vsim -l versa_ecp5_tb.log versa_ecp5_tb_lib.versa_ecp5_tb -t 1ps -random_seed random +access +r
log -rec sim:/*

run -all

if [batch_mode] {
   quit
   }
