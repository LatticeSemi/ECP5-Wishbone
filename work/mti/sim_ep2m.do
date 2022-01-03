   # The PCIe BFM is probably compiled with ecp5um ( for the Lattice RC core)
vsim evbx1_ep2m_tb_lib.evbx1_ep2m_tb -L ovi_ecp5um -L ovi_ecp2m -L pmi_work
log -rec /*
