
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_driver.c 25 2021-10-06 11:19:57Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:19:57 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 25 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// ----------------------------------------------------------------------------- (/)

#include "lscc_ae53_pch.h"

#include "lscc_ae53_private.h"
#include "lscc_ae53_file_ops.h"
#include "lscc_ae53_ioctl_ops.h"
#include "lscc_ae53_irq_ops.h"
#include "lscc_ae53_procfs.h"

#ifndef CONFIG_PCI
   #error No PCI Bus Support in kernel!
#endif

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~1~
//

#define PCI_DEV_LSCC_AE53     0xAE53
#define PCI_VEN_LATTICE       0x1204

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~1~
//

MODULE_AUTHOR("Ingenieurbuero Gardiner");
MODULE_DESCRIPTION("lscc_ae53 Demo Driver");

   // License this so no annoying messages when loading module
MODULE_LICENSE("Dual BSD/GPL");

MODULE_ALIAS("lscc_ae53");

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    The driver's global database of all boards and run-time information.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
static const char cDriverVersion[10] = "1.0.0.\0\0\0";

T_LSCC_AE53_DRV      m_lscc_ae53_drv;

static const char*   mDeviceName[2] = {"lscc_ae53", "lscc_ae53"};

static const char    mBuildId[32] = "$LastChangedRevision: 25 $\0\0\0\0";

static struct pci_device_id m_lscc_ae53_tbl[] =  {
   { PCI_VEN_LATTICE, PCI_DEV_LSCC_AE53, PCI_ANY_ID, PCI_ANY_ID, },  // lscc_ae53 device function
   { }                                                               // Terminating entry
   };

MODULE_DEVICE_TABLE(pci, m_lscc_ae53_tbl);   

   // Debug flag and getter function
   // 0=OFF, 1=Dbg_Level_1
static int lscc_debug = 0;

int isDebugMode(void) {
   return lscc_debug;
   }

module_param(lscc_debug, int, 0);
MODULE_PARM_DESC(lscc_debug, "Enable driver debug tracing (0-1)");

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//       Forward declarations
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

static int  probe_ae53(struct       pci_dev        *pdev,
                       const struct pci_device_id  *ent);

#if (LINUX_VERSION_CODE > KERNEL_VERSION(3,4,0))
static void unload_ae53(struct pci_dev *pdev);
#else
static void __devexit unload_ae53(struct pci_dev *pdev);
#endif

static void shutdown_ae53 (struct pci_dev *pdev);

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   //
   // See (e.g.) /usr/src/linux/include/linux/pci.h
   //
static struct pci_driver lscc_ae53_driver = {
   .name       = "lscc_ae53",
   .id_table   = m_lscc_ae53_tbl,
   .probe      = probe_ae53,
#if (LINUX_VERSION_CODE > KERNEL_VERSION(3,4,0))
   .remove     = unload_ae53,
#else
   .remove     = __devexit_p(unload_ae53),
#endif
   .shutdown   = shutdown_ae53,
   };

   //
   // See (e.g.) /usr/src/linux/include/linux/fs.h
   //
static struct file_operations drvr_fops = {
   .owner   = THIS_MODULE,
   .open    = tsev_fopen,
   .read    = tsev_fread,
   .write   = tsev_fwrite,   
   .release = tsev_fclose, 
   
#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35))
   .ioctl   = tsev_ioctl_handler,
#else
   .unlocked_ioctl = tsev_ioctl_unlocked,
#endif

#ifdef CONFIG_COMPAT
   .compat_ioctl = tsev_ioctl_compat,
#endif    
   };

#if LINUX_VERSION_CODE >= KERNEL_VERSION(5,6,0)
   static const struct proc_ops proc_fops_ebr = {
      .proc_open     = proc_open_ebr,
      .proc_read     = seq_read,
      .proc_lseek    = seq_lseek,
      .proc_release  = single_release,
      }; 

   static const struct proc_ops proc_fops_msi = {
      .proc_open     = proc_open_msi,
      .proc_read     = seq_read,
      .proc_lseek    = seq_lseek,
      .proc_release  = single_release,
      };       
      
   static const struct proc_ops proc_fops_spi = {
      .proc_open     = proc_open_spi,
      .proc_read     = seq_read,
      .proc_lseek    = seq_lseek,
      .proc_release  = single_release,
      };      
      
#elif LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0)      
   static const struct file_operations proc_fops_ebr = {
      .owner   = THIS_MODULE,
      .open    = proc_open_ebr,
      .read    = seq_read,
      .llseek  = seq_lseek,
      .release = single_release,
      }; 

   static const struct file_operations proc_fops_msi = {
      .owner   = THIS_MODULE,
      .open    = proc_open_msi,
      .read    = seq_read,
      .llseek  = seq_lseek,
      .release = single_release,
      };       
      
   static const struct file_operations proc_fops_spi = {
      .owner   = THIS_MODULE,
      .open    = proc_open_spi,
      .read    = seq_read,
      .llseek  = seq_lseek,
      .release = single_release,
      };       
#endif
  
static struct proc_dir_entry* lscc_ae53_proc_dir; 

static ssize_t cb_spi_show(struct device *dev, struct device_attribute *attr, char *buf) {
   return 0;
   }
   
static ssize_t cb_spi_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t size) {
   return 0;
   }
   
//static DEVICE_ATTR(spi, S_IRWXU | S_IRWXG | S_IRWXO, cb_spi_show, cb_spi_store);
static DEVICE_ATTR(spi, 0440, cb_spi_show, cb_spi_store);

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//       drv_exit_ae53    - Remove the driver
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
static void __exit drv_exit_ae53(void) {

   printk(KERN_INFO "lscc_ae53: _exit()\n");

      // Reset the number of devices
   m_lscc_ae53_drv.numDevices = 0;

   pci_unregister_driver(&lscc_ae53_driver);

   #ifdef CONFIG_PROC_FS
      #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0)
         if (lscc_ae53_proc_dir)
            remove_proc_entry("driver/lscc_ae53", NULL);
      #endif
   #endif
   
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12))
   class_destroy(m_lscc_ae53_drv.sysClass);
#else
   class_simple_destroy(m_lscc_ae53_drv.sysClass);
#endif

   printk(KERN_INFO "lscc_ae53: _exit() End\n");

   return;
   }
   
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          drv_init_ae53
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
static int __init drv_init_ae53(void) {

   int                  _Err;
   int                  _FuncHit = 0;
   int                  _Status;
   char*                _StrDest;
   char*                _StrSrc;   
   struct pci_dev*      _pDvcObj = NULL;

   
   lscc_ae53_proc_dir   = NULL;
   
      // Check that there is at least one device present
#if LINUX_VERSION_CODE < KERNEL_VERSION(3,0,0)
   while ((_pDvcObj = pci_find_device(PCI_VEN_LATTICE, PCI_DEV_LSCC_AE53, _pDvcObj))) {
#else
   while ((_pDvcObj = pci_get_device(PCI_VEN_LATTICE, PCI_DEV_LSCC_AE53, _pDvcObj))) {
#endif

      _FuncHit += 1;
      }

   if (_FuncHit) {
      printk(KERN_INFO "lscc_ae53: found %d devices\n", _FuncHit);
      }
   else {
      printk(KERN_ERR "lscc_ae53: no device found => ABORT!\n");
      return (-ENOSYS);
      }

   memset(&m_lscc_ae53_drv, 0, sizeof(m_lscc_ae53_drv));

   _Status  = alloc_chrdev_region(&m_lscc_ae53_drv.drvDevNum,     // return allocated Device Num here
                                  0,                               // first minor number
                                  MAX_MINORS,
                                  "lscc_ae53");

   if (_Status < 0) {
      printk(KERN_ERR "lscc_ae53: can't get major/minor numbers!\n");
      return(_Status);
      }

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12))
   m_lscc_ae53_drv.sysClass = class_create(THIS_MODULE, "lscc_ae53");
   
#else
   m_lscc_ae53_drv.sysClass = class_simple_create(THIS_MODULE, "lscc_ae53");
#endif
   if (IS_ERR(m_lscc_ae53_drv.sysClass)) {
      printk(KERN_ERR "lscc_ae53: Error creating simple class interface\n");
      return(-1);
      }

   _Err  = pci_register_driver(&lscc_ae53_driver);

   if (_Err < 0)
      return(_Err);   
   
      // Get and print the driver version
   _StrSrc   = (char*)cDriverVersion;
   _StrDest  = (char*)&m_lscc_ae53_drv.drvVersion;
   while (*_StrSrc != '\0') {
      *(_StrDest++)   = *(_StrSrc++);
      }

   _StrSrc     = (char*)mBuildId;
   _StrSrc     += 22;
   while (*_StrSrc != '\0') {
      *(_StrDest++) = *(_StrSrc++);
      }
      
      // Make sure the string is null-terminated before we start printing
   memset((char*)&m_lscc_ae53_drv.drvVersion + SZ_VERSION_NR - 1, 0, 1);
   printk(KERN_INFO "lscc_ae53: Driver version %s loaded\n", (char*)&m_lscc_ae53_drv.drvVersion); 
   
   return 0;
   }
   
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          dvc_init_ae53
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
static pT_LSCC_AE53_DVC    dvc_init_ae53(struct pci_dev *PCI_Dev_Cfg, void * devID) {

   unsigned long        _BarSize;
   unsigned long        _BarStart;   
   pT_LSCC_AE53_DVC     _pDvc;
   u16                  _PciDeviceID;
   u16                  _PciVendorID;
   int                  ix;
   
   _pDvc          = &m_lscc_ae53_drv.lscc_ae53_dvc[m_lscc_ae53_drv.numDevices];
   _pDvc->pDrv    = &m_lscc_ae53_drv;   
   
   if (pci_read_config_word(PCI_Dev_Cfg, PCI_VENDOR_ID, &_PciVendorID)) {
      printk(KERN_ERR "lscc_ae53: Could not get Vendor ID of LSCC_AE53 device!\n");
      return(NULL);
      }
   if (pci_read_config_word(PCI_Dev_Cfg, PCI_DEVICE_ID, &_PciDeviceID)) {
      printk(KERN_ERR "lscc_ae53: Could not get Device ID of LSCC_AE53 device!\n");
      return(NULL);
      }

   _pDvc->ID            = _PciDeviceID;
   _pDvc->pPciDev       = PCI_Dev_Cfg;
   _pDvc->majorNum      = MAJOR(m_lscc_ae53_drv.drvDevNum);
   _pDvc->minorNum      = MINOR(m_lscc_ae53_drv.drvDevNum) + m_lscc_ae53_drv.numDevices;
   _pDvc->instanceNum   = m_lscc_ae53_drv.numDevices;   
   
   for (ix = 0; ix < 2; ix++) {
      _BarStart   = pci_resource_start(PCI_Dev_Cfg, ix);
      _BarSize    = pci_resource_len(PCI_Dev_Cfg, ix);

      if (pci_resource_flags(PCI_Dev_Cfg, ix) & IORESOURCE_MEM)
         printk(KERN_INFO "lscc_ae53: Mem-Space Resource %d, size %lu\n", ix, _BarSize);
            
      switch (ix) {
         case 0 :           
            _pDvc->pDvcRegs   = (pT_LSCC_AE53_REGS)ioremap(_BarStart, _BarSize);
            
            printk(KERN_INFO "lscc_ae53: Addr Base %x / %08llx\n", (__u32)_BarStart, (__u64)_pDvc->pDvcRegs);           
            break;

         case 1 :            
            _pDvc->pSpiRegs   = (pT_RADIANT_SPI_REGS)ioremap(_BarStart, _BarSize);
            
            printk(KERN_INFO "lscc_ae53: Addr Base %x / %08llx\n", (__u32)_BarStart, (__u64)_pDvc->pSpiRegs);            
            break;            
            
         default:
            break;
         };
      }
  
   spin_lock_init(&_pDvc->mLockIrqAck);
   spin_lock_init(&_pDvc->mLockIrqMask);
   
   m_lscc_ae53_drv.numDevices   += 1;
   
   return (_pDvc);   
   }
   
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//             probe_ae53
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
static int probe_ae53(struct        pci_dev        *pdev,
                      const struct  pci_device_id  *ent) {

   static char devNameStr[16]             = "lscc_ae53__";
   
   int                     _Err;
   int                     _StaCode;
   pT_LSCC_AE53_DVC        _pDvc;
   int                     ix;


   devNameStr[10] = '0' + m_lscc_ae53_drv.numDevices;

   _Err = pci_enable_device(pdev);
   if (_Err) {
      printk(KERN_ERR "lscc_ae53: Error enabling PCI Device\n");
      return _Err;
      }
      
   _Err = pci_request_regions(pdev, devNameStr);
   if (_Err) {
      printk(KERN_ERR "lscc_ae53: pci_request_regions() failed\n");
      return _Err;
      }
      
   pci_set_master(pdev);   

   _pDvc = dvc_init_ae53(pdev, (void*)ent);
   if (_pDvc == NULL) {
      printk(KERN_ERR "lscc_ae53: Error initialising RIF Device\n");
         // Clean up any resources we acquired along the way
      pci_release_regions(pdev);

      return(-1);
      }

   _pDvc->mUseMSI = pci_alloc_irq_vectors(pdev, 1, C_MSI_NUM_VECS, PCI_IRQ_MSI);
   
   if (_pDvc->mUseMSI < 0) {
      printk(KERN_WARNING "lscc_ae53: Could not acquire MSI");
      
      _StaCode = request_threaded_irq(pdev->irq, lscc_ae53_irq_handler, lscc_ae53_irq_dpc, IRQF_SHARED, KBUILD_MODNAME, _pDvc);
      }
   else {
      printk(KERN_INFO "lscc_ae53: %d MSI vectors allocated\n", _pDvc->mUseMSI);
      
      for (ix = 0; ix < _pDvc->mUseMSI; ix++) {
         _pDvc->mIrqFilter[ix] = 0;
         _pDvc->mIrqWrap[ix] = 0;
         _StaCode = request_threaded_irq(pci_irq_vector(pdev, ix), lscc_ae53_irq_handler, lscc_ae53_irq_dpc, 0, KBUILD_MODNAME, _pDvc);
         }
      }
      
   for (ix = 0; ix < C_MSI_NUM_VECS; ix++)
      init_waitqueue_head(&_pDvc->mIrqEvent[ix]);
   
   _pDvc->charDev.owner    = THIS_MODULE;
   _pDvc->charDev.ops      = &drvr_fops;
   kobject_set_name(&_pDvc->charDev.kobj, "lscc_ae53");

   cdev_init(&_pDvc->charDev, &drvr_fops);

   _Err  = cdev_add (&_pDvc->charDev, MKDEV(_pDvc->majorNum, _pDvc->minorNum), 1);
   if (_Err) {
      printk(KERN_ERR "lscc_ae53: Error adding Char Device\n");
      return _Err;
      }
      
   #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)
      m_lscc_ae53_drv.dvcRef[_pDvc->minorNum]   = device_create(m_lscc_ae53_drv.sysClass,
                                                                NULL,
                                                                MKDEV(_pDvc->majorNum, _pDvc->minorNum),
                                                                &(pdev->dev),
                                                                "%s_%d",
                                                                mDeviceName[_pDvc->dvcType],
                                                                _pDvc->instanceNum);
                     
      if (device_create_file(m_lscc_ae53_drv.dvcRef[_pDvc->minorNum], &dev_attr_spi))
         printk(KERN_ERR "lscc_ae53: Could not create reference to spi subsystem\n");
      
   #elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12))
      class_device_create(m_lscc_ae53_drv.sysClass,
                        NULL,
                        MKDEV(_pDvc->majorNum, _pDvc->minorNum),
                        &(pdev->dev), 
                        "%s_%d",
                        mDeviceName[_pDvc->deviceType],
                        _pDvc->instanceNum);
   #else
      class_simple_device_add(m_lscc_ae53_drv.sysClass,
                              MKDEV(_pDvc->majorNum, _pDvc->minorNum),
                              NULL, 
                              "%s_%d",
                              mDeviceName[_pDvc->deviceType],
                              _pDvc->instanceNum);
   #endif

   _pDvc->pProcNode  = NULL;
   memset(_pDvc->mProcName, 0x00, sizeof(_pDvc->mProcName));
   
   #ifdef CONFIG_PROC_FS
      #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0)
         if (! lscc_ae53_proc_dir)
            lscc_ae53_proc_dir   = proc_mkdir("driver/lscc_ae53", NULL);
         
         if (lscc_ae53_proc_dir) {            
            sprintf(_pDvc->mProcName, "dvc_%02d", _pDvc->minorNum);
            
            _pDvc->pProcNode  = proc_mkdir(_pDvc->mProcName, lscc_ae53_proc_dir);
            
            if (_pDvc->pProcNode) {
               proc_create_data("ebr", 0, _pDvc->pProcNode, &proc_fops_ebr, NULL);
               
               proc_create_data("msi", 0, _pDvc->pProcNode, &proc_fops_msi, NULL);

               proc_create_data("spi", 0, _pDvc->pProcNode, &proc_fops_spi, NULL);
               }
            }
         else 
            printk(KERN_WARNING "lscc_ae53: Cannot Create Proc FileSystem Entry\n");
      #endif
   #endif       
         
   pci_set_drvdata(pdev, _pDvc);
   
   return 0;   
   }
   

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//             shutdown_ae53    - Shutdown the device
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
static void shutdown_ae53 (struct pci_dev *pdev) {


   printk(KERN_INFO "lscc_ae53: shutdown_ae53()\n");

   }
   
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//             unload_ae53    - Unload the device
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
#if (LINUX_VERSION_CODE > KERNEL_VERSION(3,4,0))
static void unload_ae53(struct pci_dev *pdev) {
#else
static void __devexit unload_ae53(struct pci_dev *pdev) {
#endif

   pT_LSCC_AE53_DVC     _pDvc;
   int                  ix;
   
   
   printk(KERN_INFO "lscc_ae53: _unload()\n");

   _pDvc    = pci_get_drvdata(pdev);   
      
   for (ix = 0; ix < _pDvc->mUseMSI; ix++)
      free_irq(pci_irq_vector(pdev, ix), _pDvc);

   pci_free_irq_vectors(pdev);
   
   pci_release_regions(pdev);
   cdev_del(&_pDvc->charDev);

   #ifdef CONFIG_PROC_FS
      #if LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0)
         if (_pDvc->pProcNode) {
            remove_proc_entry("ebr", _pDvc->pProcNode);
            remove_proc_entry("msi", _pDvc->pProcNode);
            remove_proc_entry("spi", _pDvc->pProcNode);

            if (lscc_ae53_proc_dir)
               remove_proc_entry(_pDvc->mProcName, lscc_ae53_proc_dir);
            }
      #endif
   #endif
         
   unregister_chrdev_region(MKDEV(_pDvc->majorNum, _pDvc->minorNum), MAX_MINORS);
         
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,27)
   device_remove_file(m_lscc_ae53_drv.dvcRef[_pDvc->minorNum], &dev_attr_spi);
   
   device_destroy(m_lscc_ae53_drv.sysClass, MKDEV(_pDvc->majorNum, _pDvc->minorNum));
#elif (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12))
   class_device_destroy(m_lscc_ae53_drv.sysClass, MKDEV(_pDvc->majorNum, _pDvc->minorNum));
#else
   class_simple_device_remove(MKDEV(_pDvc->majorNum, _pDvc->minorNum));
#endif

   pci_disable_device(pdev);

   return;   
   }
   
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
module_init(drv_init_ae53);
module_exit(drv_exit_ae53);
