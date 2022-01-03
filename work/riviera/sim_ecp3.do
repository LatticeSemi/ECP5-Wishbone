vsim -l versa_ecp3_tb.log versa_ecp3_tb_lib.versa_ecp3_tb -t 1ps -random_seed random +access +r
log -rec sim:/*

run -all

if [batch_mode] {
   quit
   }
