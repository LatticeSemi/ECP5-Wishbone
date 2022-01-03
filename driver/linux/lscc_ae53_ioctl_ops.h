
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_ioctl_ops.h 25 2021-10-06 11:19:57Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:19:57 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 25 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------
#ifndef _LSCC_AE53_IOCTL_OPS_H
#define _LSCC_AE53_IOCTL_OPS_H

#include "lscc_ae53_private.h"

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          Function Prototypes
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
int tsev_ioctl_handler(struct inode *i, struct file *fp, unsigned int cmd, unsigned long arg);
long tsev_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg);

#ifdef CONFIG_COMPAT
   long tsev_ioctl_compat(struct file *filep, unsigned int cmd, unsigned long arg);
#endif
#endif
