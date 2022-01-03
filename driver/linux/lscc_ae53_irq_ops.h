
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_irq_ops.h 25 2021-10-06 11:19:57Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:19:57 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 25 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#ifndef _LSCC_AE53_IRQ_OPS_H
#define _LSCC_AE53_IRQ_OPS_H

#include "lscc_ae53_pch.h"

#include "lscc_ae53_private.h"

/*
** ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

irqreturn_t lscc_ae53_irq_dpc(int irq, void* hDvc);
irqreturn_t lscc_ae53_irq_handler(int irq, void* hDvc);
void        lscc_ae53_irq_init(pT_LSCC_AE53_DVC pDvc);

#endif
