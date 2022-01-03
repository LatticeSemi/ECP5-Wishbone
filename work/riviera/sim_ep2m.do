vsim -l evbx1_ep2m_tb.log evbx1_ep2m_tb_lib.evbx1_ep2m_tb -t 1ps -random_seed random +access +r
log -rec sim:/*

run -all

if [batch_mode] {
   quit
   }
