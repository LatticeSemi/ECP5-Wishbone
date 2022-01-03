//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_ioctl_ops.c 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#include "lscc_ae53_file_ops.h"
#include "lscc_ae53_ioctl_ops.h"
#include "lscc_ae53_private.h"

#include <linux/spi/spidev.h>

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
static DEFINE_MUTEX(tsev_ae53_ioctl_mutex);
#endif

extern T_LSCC_AE53_DRV  m_lscc_ae53_drv;

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_ioctl_unlocked
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))

long tsev_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg) {

   int   _RetVal = 0;
   
   
   mutex_lock(&tsev_ae53_ioctl_mutex);
   
   switch (_IOC_NR(cmd)) {         
      default : 
         _RetVal = tsev_ioctl_handler(NULL, fp, cmd, arg);

         mutex_unlock(&tsev_ae53_ioctl_mutex);           
         break;
      }   

   return (long) _RetVal;
   }
#endif

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    tsev_ioctl_compat
//       Purpose : Allow 32-bit userland programs to make ioctl calls on a 
//                 64-bit kernel.
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
#ifdef CONFIG_COMPAT
long tsev_ioctl_compat(struct file *filep, unsigned int cmd, unsigned long arg) {

   return (long) tsev_ioctl_handler(NULL, filep, cmd, arg);
   }
#endif

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_ioctl_handler
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
int tsev_ioctl_handler(struct inode *i, struct file *fp, unsigned int cmd, unsigned long arg) {

   u32                  _IrqPeriod;
   u8                   _IrqSel;
   u8                   _ParamAsByte;
   int                  _RetVal = 0;
   T_TSEV_REG_DESCR     _RegOpDescr;
   long                 _Tmout;   
   pT_LSCC_AE53_DVC     _pDvc;
   pT_TSEV_FILE_CTX     _pFileCtx;
   void __user*         _pUsrParams;
   
   struct spi_ioc_transfer *ioc;   


   ioc   = kmalloc(sizeof(struct spi_ioc_transfer), GFP_KERNEL);
   
   _pFileCtx      = fp->private_data;
   _pDvc          = _pFileCtx->pTsevDvc;   
   
   _pUsrParams    = (void __user *)arg;
   
   switch (_IOC_NR(cmd)) {
      case _IOC_NR(TSEV_AE53_REG_READ):         
         if (copy_from_user(&_RegOpDescr, _pUsrParams, sizeof(T_TSEV_REG_DESCR))) {
            printk(KERN_ERR "lscc_ae53.ioctl() : IOCTL code %x. Error on copy_from_user\n", _IOC_NR(cmd));
            _RetVal  = -EFAULT;  
            break;
            }        
            
         else {
            switch (_RegOpDescr.regByteEn) {
               case 0xF :
                  if (isDebugMode()) 
                     printk(KERN_INFO "lscc_ae53: Reading DWord at Offset 0x%08x\n", _RegOpDescr.regAdr / 4);
                  
                  _RegOpDescr.regValue    = ioread32(((u32*)_pDvc->pDvcRegs) + (_RegOpDescr.regAdr / 4));
                  break;
                  
               case 0x3:
               case 0xc:
                  if (isDebugMode()) 
                     printk(KERN_INFO "lscc_ae53: Reading HWord at Offset 0x%08x\n", _RegOpDescr.regAdr / 2);
                  
                  _RegOpDescr.regValue    = (u32)ioread16(((u16*)_pDvc->pDvcRegs) + (_RegOpDescr.regAdr / 2));
                  break;
                  
               default:
                  if (isDebugMode()) 
                     printk(KERN_INFO "lscc_ae53: Reading Byte at Offset 0x%08x\n", _RegOpDescr.regAdr);
                  
                  _RegOpDescr.regValue    = (u8)ioread8(((u16*)_pDvc->pDvcRegs) + _RegOpDescr.regAdr);
                  break;
               }  
               
            if (copy_to_user(_pUsrParams, &_RegOpDescr, sizeof(T_TSEV_REG_DESCR))) {
               printk(KERN_ERR "lscc_ae53.ioctl() : IOCTL code %x. Error on copy_to_user\n", _IOC_NR(cmd));
               _RetVal  = -EFAULT;  
               }      
            }
         break;

      case _IOC_NR(TSEV_AE53_REG_WRITE):         
         if (copy_from_user(&_RegOpDescr, _pUsrParams, sizeof(T_TSEV_REG_DESCR))) {
            printk(KERN_ERR "lscc_ae53.ioctl() : IOCTL code %x. Error on copy_from_user\n", _IOC_NR(cmd));
            _RetVal  = -EFAULT;  
            break;
            }          

         else {
            switch (_RegOpDescr.regByteEn) {
               case 0xF :
                  if (isDebugMode()) 
                     printk(KERN_INFO "lscc_ae53: Writing DWord 0x%08x to Offset 0x%08x\n", _RegOpDescr.regValue, _RegOpDescr.regAdr / 4);
                  
                  iowrite32(_RegOpDescr.regValue, ((u32*)_pDvc->pDvcRegs) + (_RegOpDescr.regAdr / 4));
                  break;
                  
               case 0x3:
               case 0xc:
                  if (isDebugMode()) 
                     printk(KERN_INFO  "lscc_ae53: Writing HWord 0x%04x to Offset 0x%08x\n", 
                                       (u16)(_RegOpDescr.regValue & 0xffff), _RegOpDescr.regAdr / 2);
                  
                  iowrite32((u16)(_RegOpDescr.regValue & 0xffff), ((u16*)_pDvc->pDvcRegs) + (_RegOpDescr.regAdr / 2));
                  break;
                  
               default:
                  if (isDebugMode()) 
                     printk(KERN_INFO  "lscc_ae53: Writing Byte 0x%02x to Offset 0x%08x\n", 
                                       (u8)(_RegOpDescr.regValue & 0xff), _RegOpDescr.regAdr / 4);
                  
                  iowrite32((u8)(_RegOpDescr.regValue & 0xff), ((u8*)_pDvc->pDvcRegs) + _RegOpDescr.regAdr);
                  break;
               }
            }
         
         break;
         
      case _IOC_NR(TSEV_AE53_TGT_SELECT):
         if (get_user(_ParamAsByte, (u8 __user *)arg)) {
            printk(KERN_ERR "lscc_ae53.ioctl() : IOCTL code %x. Error on get_user\n", _IOC_NR(cmd));
            _RetVal  = -EFAULT;  
            break;
            }         
         if (_ParamAsByte < LSCC_INVALID)
            _pFileCtx->mTargetID = _ParamAsByte;
         else {
            printk(KERN_ERR "lscc_ae53.ioctl() : Invalid Target Select received. %d\n", _ParamAsByte);
            _RetVal  = -EFAULT;              
            }
         break;
                  
      default:
         if (copy_from_user(ioc, _pUsrParams, sizeof(struct spi_ioc_transfer))) {
            printk(KERN_WARNING "lscc_ae53.ioctl() : Unknown IOCTL Code %x", _IOC_NR(cmd));
            _RetVal  = -EFAULT;  
            break;
            }          
         _pDvc->tmpVal  = ioc->speed_hz;
         //printk(KERN_WARNING "lscc_ae53.ioctl() : Unknown IOCTL Code %x", _IOC_NR(cmd));
         break;         
      }
      
   return _RetVal;
   }
