
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_procfs.h 25 2021-10-06 11:19:57Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:19:57 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 25 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#ifndef _LSCC_AE53_PROCFS_H
#define _LSCC_AE53_PROCFS_H

#include "lscc_ae53_pch.h"

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          Function Prototypes
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0)

   int proc_open_ebr(struct inode *inode, struct file *file);
   int proc_open_msi(struct inode *inode, struct file *file);
   int proc_open_spi(struct inode *inode, struct file *file);
   
#endif
#endif
