
# Linux 2.6 Kernel Makefile
# New format.  All building is done within the kernel development
# tree.  The user's makefile no longer needs to specify all build rules
# and kernel defines.  Its all done by the kernel now.
#
# For full details on bulding a kernel module see:
# 
# To build with more verbose output run:
# 	$> make V=1 

#
#    includes from /usr/src/linux/include/linux
#
 
#
#    /sbin/insmod lscc_ae53.ko
#
#    /sbin/rmmod -v lscc_ae53.ko
#



ifneq ($(KERNELRELEASE),)

obj-m := lscc_ae53.o
lscc_ae53-objs := lscc_ae53_driver.o lscc_ae53_file_ops.o lscc_ae53_ioctl_ops.o lscc_ae53_irq_ops.o lscc_ae53_procfs.o

EXTRA_CFLAGS += -I.

else

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
WARN := -W -Wall -Wstrict-prototypes -Wmissing-prototypes

all :
	$(MAKE) $(WARN) -C $(KDIR) M=$(shell pwd) modules

clean :
	rm *.o *.ko *.mod.c
endif


