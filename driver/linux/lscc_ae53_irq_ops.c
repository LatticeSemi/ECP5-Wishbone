
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_irq_ops.c 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#include "lscc_ae53_irq_ops.h"

#define IRQ_PRESCALE_VAL  8

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          lscc_ae53_irq_dpc
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
irqreturn_t lscc_ae53_irq_dpc(int irq, void* hDvc) {
   u8                _mIrqSel;
   pT_LSCC_AE53_DVC  _pDvc;

   _pDvc    = (pT_LSCC_AE53_DVC)hDvc;
   
   _mIrqSel    = (irq - pci_irq_vector(_pDvc->pPciDev, 0));
   
   if (! (_pDvc->mIrqFilter[_mIrqSel] % IRQ_PRESCALE_VAL))
      printk(KERN_INFO "lscc_ae53._irq_dpc() : %d events for vector %d\n", 
             ((_pDvc->mIrqWrap[_mIrqSel]) ? IRQ_PRESCALE_VAL : 1), _mIrqSel);
   
   _pDvc->mIrqFilter[_mIrqSel]   += 1;
   _pDvc->mIrqFilter[_mIrqSel]   = _pDvc->mIrqFilter[_mIrqSel] % IRQ_PRESCALE_VAL;
   _pDvc->mIrqWrap[_mIrqSel]     = (u8)1;

   wake_up_interruptible(&_pDvc->mIrqEvent[_mIrqSel]);
   
   return IRQ_HANDLED;
   }

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          lscc_ae53_irq_handler
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
irqreturn_t lscc_ae53_irq_handler(int irq, void* hDvc) {

   unsigned long        _IrqFlags;
   u8                   _IrqSel;
   irqreturn_t          _RetVal;
   pT_LSCC_AE53_DVC     _pDvc;


   _pDvc    = (pT_LSCC_AE53_DVC)hDvc;

   _IrqSel  = (irq - pci_irq_vector(_pDvc->pPciDev, 0));   
   _RetVal  = IRQ_WAKE_THREAD;
   
   spin_lock_irqsave(&_pDvc->mLockIrqMask, _IrqFlags);
   
   if (_pDvc->mUseMSI < 1) {
      _RetVal  = IRQ_NONE;
      }   
   
   spin_unlock_irqrestore(&_pDvc->mLockIrqMask, _IrqFlags);
   
   return _RetVal;
   }

/*
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          lscc_ae53_irq_init
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
void lscc_ae53_irq_init(pT_LSCC_AE53_DVC pDvc) {


   }
