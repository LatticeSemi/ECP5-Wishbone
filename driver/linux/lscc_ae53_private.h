
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_private.h 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------
//          /usr/src/linux/include/linux
// -----------------------------------------------------------------------------

#ifndef _LSCC_AE53_PRIVATE_H_
#define _LSCC_AE53_PRIVATE_H_

#include "lscc_ae53_pch.h"

#include "lscc_ae53_public.h"

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

#define C_MAX_MEM_ADR            8192
#define C_MSI_NUM_VECS           8

#define NUM_DEVICES              4                 // 4 devices per system
#define MAX_DEVICES              (NUM_DEVICES)
#define MINORS_PER_DEVICE        1                 // 1 minor number per discrete device
#define MAX_MINORS               (NUM_DEVICES * MINORS_PER_DEVICE)
#define SZ_PROC_NAME             8
#define SZ_TARGET_ID             4
#define SZ_VERSION_NR            32

   //
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //          Globally accessible methods
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //
int isDebugMode(void);

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
typedef struct _T_LSCC_AE53_DRV*       pT_LSCC_AE53_DRV;
typedef struct _T_LSCC_AE53_REGS*      pT_LSCC_AE53_REGS;
typedef struct _T_RADIANT_SPI_REGS*    pT_RADIANT_SPI_REGS;

   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //          Structure describing a Device Instance
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //
typedef struct _T_LSCC_AE53_DVC {
   u32   dvcType;
   u32   ID;            //*< PCI device ID of the board (0x5303, 0xe235, etc) //
   u32   instanceNum;   //*< tracks number of identical board,demo devices in system //
   u32   majorNum;      //*< copy of driver's Major number for use in places where only device exists //
   u32   minorNum;      //*< specific Minor number assigned to this board //

   struct cdev             charDev;    //*< the character device implemented by this driver //
   
   wait_queue_head_t       mIrqEvent[C_MSI_NUM_VECS];
   u8                      mIrqFilter[C_MSI_NUM_VECS];
   u8                      mIrqWrap[C_MSI_NUM_VECS];
   spinlock_t              mLockIrqAck;   
   spinlock_t              mLockIrqMask;   
   char                    mProcName[SZ_PROC_NAME];
   char                    mTargetID[SZ_TARGET_ID];
   int                     mUseMSI;
   pT_LSCC_AE53_DRV        pDrv;
   pT_LSCC_AE53_REGS       pDvcRegs;   
   struct pci_dev*         pPciDev;    //*< pointer to the PCI core representation of the fpga //
   struct proc_dir_entry*  pProcNode;   
   pT_RADIANT_SPI_REGS     pSpiRegs;
   u8                      tmpVal;

   } T_LSCC_AE53_DVC, *pT_LSCC_AE53_DVC; 
   
   //
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //          Structure describing Device Driver
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //
typedef struct _T_LSCC_AE53_DRV {

   dev_t                drvDevNum;                    //*> starting [MAJOR][MINOR] device number for this driver //
   char                 drvVersion[SZ_VERSION_NR]; 
   struct device*       dvcRef[NUM_DEVICES];
   u32                  numDevices;                   //*> total number of boards controlled by driver //
   T_LSCC_AE53_DVC      lscc_ae53_dvc[NUM_DEVICES];  //*> Database of LSC PCIe Eval Boards Installed //

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,12))
   struct class*           sysClass;   //*> the top entry point of lscpcie2 in /sys/class //
#else
   struct class_simple*    sysClass;   //*> the top entry point of lscpcie2 in /sys/class //
#endif
   } T_LSCC_AE53_DRV;
   
   //
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //          Structure describing Device Registers
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //   
typedef  struct _T_LSCC_AE53_REGS {
   u32      bmRAM_0[1024];   
   u32      bmRAM_1[1024];   

   } T_LSCC_AE53_REGS;   
   
   //
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //          Structure describing SPI Register Interface
   // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   //     
typedef struct _T_RADIANT_SPI_REGS {
      // See IPUG 02069
   u32      spiData;
   u32      spiSlvSel;
   u32      spiConfig;
   u32      spiClkDivLow;
      // 0x10
   u32      spiClkDivHigh;
   u32      spiIntSta;
   u32      spiIntEna;
   u32      spiIntSet;
      // 0x20
   u32      spiWordCount;
   u32      spiWcReset;
   u32      spiTargetWc;
   u32      spiFifoRst;
      // 0x30
   u32      spiSlvPolarity;
   u32      spiFifoSta;
   u32      spiPad[2];
   
   } T_RADIANT_SPI_REGS;
#endif
