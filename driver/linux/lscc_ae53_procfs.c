
//
//    Developed by Ing. Buero Gardiner
//                 Heuglinstr. 29a
//                 81249 Muenchen
//                 charles.gardiner@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_procfs.c 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#include "lscc_ae53_private.h"
#include "lscc_ae53_procfs.h"

extern T_LSCC_AE53_DRV      m_lscc_ae53_drv;
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          Function Prototypes
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

#if LINUX_VERSION_CODE >= KERNEL_VERSION(3,10,0)  
      //
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //          proc_show_ebr
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //  
   static int proc_show_ebr(struct seq_file *m, void *v) {

      int                  ix;
      int                  _RegSel;
      pT_LSCC_AE53_DVC     _pDvc;
      
      
      _pDvc       = m->private;         
      
      _RegSel     = 0x00;
      seq_printf(m,  "\nBlock Memory 0  [0:15]\n");
      
      for (ix = 0; ix < 16; ix++) {
         seq_printf(m, "   BMRAM Reg [+  %d] : 0x%08x \n", _RegSel, ioread32(((u32*)&_pDvc->pDvcRegs->bmRAM_0) + ix));
         
         _RegSel  += 1;
         }  
         
      _RegSel     = 0x00;
      seq_printf(m,  "\nBlock Memory 1  [0:15]\n");
      
      for (ix = 0; ix < 16; ix++) {
         seq_printf(m, "   BMRAM Reg [+  %d] : 0x%08x \n", _RegSel, ioread32(((u32*)&_pDvc->pDvcRegs->bmRAM_1) + ix));
         
         _RegSel  += 1;
         }  
         
      seq_printf(m, "\n");
         
      return 0; 
      }

      //
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //          proc_show_msi
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //       
   static int proc_show_msi(struct seq_file *m, void *v) {

      pT_LSCC_AE53_DVC     _pDvc;
      
      
      _pDvc       = m->private;      
      
      seq_printf(m,  "\nMSI Source: Not installed\n");
         
      seq_printf(m, "\n");
      
      return 0; 
      }      
      
      //
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //          proc_show_spi
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //       
   static int proc_show_spi(struct seq_file *m, void *v) {

      pT_LSCC_AE53_DVC     _pDvc;
      
      
      _pDvc       = m->private;      
      
      seq_printf(m,  "\nSPI Master. Not installed\n");

      seq_printf(m, "\n");
      
      return 0; 
      }      
      
      //
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //          proc_open_ebr
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //   
   int proc_open_ebr(struct inode *inode, struct file *file) {
         
         // The pointer passed n the 3rd parameter is available in seq_file->private in the show() callback
      return single_open(file, proc_show_ebr, &m_lscc_ae53_drv.lscc_ae53_dvc[iminor(inode)]);
      }
      
      //
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //          proc_open_msi
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //   
   int proc_open_msi(struct inode *inode, struct file *file) {
         
      return single_open(file, proc_show_msi, &m_lscc_ae53_drv.lscc_ae53_dvc[iminor(inode)]);
      }
      
      //
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //          proc_open_spi
      // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      //   
   int proc_open_spi(struct inode *inode, struct file *file) {
         
      return single_open(file, proc_show_spi, &m_lscc_ae53_drv.lscc_ae53_dvc[iminor(inode)]);
      }
      
#endif
