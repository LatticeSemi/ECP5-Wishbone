
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_file_ops.c 25 2021-10-06 11:19:57Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:19:57 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 25 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#include "lscc_ae53_file_ops.h"

#include <linux/kernel.h>
#include <linux/fs.h>

extern T_LSCC_AE53_DRV  m_lscc_ae53_drv;

ssize_t tsev_fread_ebr(struct file *fp, char __user *userBuf, size_t len, loff_t *offp);
ssize_t tsev_fread_spi(struct file *fp, char __user *userBuf, size_t len, loff_t *offp);
ssize_t tsev_fwrite_ebr(struct file *fp, const char __user *userBuf, size_t len, loff_t *offp);
ssize_t tsev_fwrite_spi(struct file *fp, const char __user *userBuf, size_t len, loff_t *offp);

#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,35))
static DEFINE_MUTEX(tsev_ae53_spi_mutex);
#endif

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_fclose
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
int tsev_fclose(struct inode* inode, struct file* fp) {

   pT_TSEV_FILE_CTX     _pFileCtx;

   _pFileCtx         = fp->private_data;
   fp->private_data  = NULL;
   kfree(_pFileCtx);
   
   return 0;
   }
   
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_fopen
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
int tsev_fopen(struct inode* inode, struct file* fp) {

   size_t               _mCopyLim;
   char                 _mFilePath[256];
   u32                  _mPosEnd;
   u32                  _mPosStart;
   pT_TSEV_FILE_CTX     _pFileCtx;
   char*                _pFilePath;

   
   printk(KERN_INFO "lscc_ae53: tsev_fopen()\n");
   
   memset(_mFilePath, 0x00, sizeof(_mFilePath));

   _pFileCtx = (pT_TSEV_FILE_CTX)kmalloc(sizeof(T_TSEV_FILE_CTX), GFP_KERNEL);
   memset((void*)_pFileCtx, 0, sizeof(T_TSEV_FILE_CTX));

   _pFileCtx->pTsevDvc  = &m_lscc_ae53_drv.lscc_ae53_dvc[iminor(inode)];

   fp->private_data  = _pFileCtx;
   
   _pFilePath  = file_path(fp, _mFilePath, sizeof(_mFilePath));
      // Don't let anybody fool us!! Enforce termination with null
   _mFilePath[sizeof(_mFilePath) - 1]  = '\0';
   
   if (isDebugMode()) 
      printk(KERN_INFO "lscc_ae53: File Path %s\n", _pFilePath);
   
   _mPosEnd    = sizeof(_mFilePath) - 1;
   do {
      _mPosEnd -= 1;
      } while (_mFilePath[_mPosEnd] == '\0');
      
   _mPosStart  = _mPosEnd - 1;
   
   while (_mPosStart && (_mFilePath[_mPosStart] != '/'))
      _mPosStart -= 1;
   
   _mPosStart  += 1;
   
   _mCopyLim   = _mPosEnd - _mPosStart;
   if (_mCopyLim > SZ_TARGET_ID)
      _mCopyLim   = SZ_TARGET_ID;
   
   memcpy((void*)&_pFileCtx->pTsevDvc->mTargetID, (void*)&_mFilePath[_mPosStart], _mCopyLim);
   _pFileCtx->pTsevDvc->mTargetID[SZ_TARGET_ID - 1]   = '\0';
   
   if (isDebugMode()) 
      printk(KERN_INFO "lscc_ae53: File Sel %s\n", &_mFilePath[_mPosStart]);
   
   _pFileCtx->mTargetID = LSCC_UNKNOWN;
   if (! strcmp("ebr", _pFileCtx->pTsevDvc->mTargetID))
      _pFileCtx->mTargetID = LSCC_EBR;
   
   else if (! strcmp("spi", _pFileCtx->pTsevDvc->mTargetID))
      _pFileCtx->mTargetID = LSCC_SPI;

   if (isDebugMode()) 
      printk(KERN_INFO "lscc_ae53: target ID %d\n", _pFileCtx->mTargetID);
   return 0;
   }

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_fread : Read from Device
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
ssize_t  tsev_fread(struct file *fp, char __user *userBuf, size_t len, loff_t *offp) {

   pT_TSEV_FILE_CTX     _pFileCtx;


   _pFileCtx      = fp->private_data;
   
   switch (_pFileCtx->mTargetID) {
      case (LSCC_EBR) :
         return tsev_fread_ebr(fp, userBuf, len, offp);
         break;
         
      default:
         return -EFAULT;
      }
   }
   
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_fread_ebr : Read from EBR Target
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
ssize_t  tsev_fread_ebr(struct file *fp, char __user *userBuf, size_t len, loff_t *offp) {

   size_t               _mBufSz;
   LSCC_U32             _mOffset;
   size_t               _mXferSz;
   pT_LSCC_AE53_DVC     _pDvc;
   pT_TSEV_FILE_CTX     _pFileCtx;
   LSCC_U8*             _pRdBuf;
   void __user*         _pUserBuf;
   int                  ix;


   _pFileCtx      = fp->private_data;
   _pDvc          = _pFileCtx->pTsevDvc;   
   _pUserBuf      = (void __user *)userBuf;
   
   _mBufSz  = len;
   _mOffset = (*offp & 0xFFFF) / sizeof(LSCC_U32);
      
   if (_mBufSz > C_MAX_MEM_ADR)
      _mBufSz  = C_MAX_MEM_ADR;
   
   _pRdBuf  = (LSCC_U8*)vmalloc(_mBufSz);
   memset((void*)_pRdBuf, 0, _mBufSz);
   
   for (ix = 0; ix < (_mBufSz / sizeof(LSCC_U32)); ix++) {
      *(((LSCC_U32*)_pRdBuf) + ix) = ioread32(&_pDvc->pDvcRegs->bmRAM_0[(_mOffset + ix) % (C_MAX_MEM_ADR / sizeof(LSCC_U32))]);
      }
      
   if (copy_to_user(_pUserBuf, _pRdBuf, _mBufSz)) {
      printk(KERN_ERR "ae53.tsev_fread: Could not copy buffer to user memory\n");
      _mXferSz    = 0;
      }   
   else
      _mXferSz    = _mBufSz;
   
   vfree(_pRdBuf);

   return _mXferSz;
   }
  
   
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_fread_spi : Read from SPI Target
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
ssize_t  tsev_fread_spi(struct file *fp, char __user *userBuf, size_t len, loff_t *offp) {
   
   size_t               _mBufSz;
   u32                  _mBufSzDw;
   u8                   _mSpiConfig;
   ssize_t              _mXferSz;
   ssize_t              _mXferTotal;
   pT_LSCC_AE53_DVC     _pDvc;
   pT_TSEV_FILE_CTX     _pFileCtx;
   LSCC_U32*            _pRdBuf;
   void __user*         _pUserBuf;


   _pFileCtx      = fp->private_data;
   _pDvc          = _pFileCtx->pTsevDvc;   
   _pUserBuf      = (void __user *)userBuf;
   
   _mBufSz        = len;
   _mBufSzDw      = (len % sizeof(u32)) ? ((len / 4) + 1) : (len / 4);
   _mSpiConfig    = 0;
   _mXferSz       = 0;
   
      // Always align to DWord
   _pRdBuf  = (LSCC_U32*)vmalloc(_mBufSzDw);
   memset((void*)_pRdBuf, 0, _mBufSz);   
   
   
   if (_pFileCtx->mSpiConfig.wordSize && (_pFileCtx->mSpiConfig.wordSize  < LSCC_SPI_NBYTES_INVALID)
                                      && (_pFileCtx->mSpiConfig.szCmdRd   < LSCC_SPI_NBYTES_INVALID)
                                      && (_pFileCtx->mSpiConfig.szCmdWr   < LSCC_SPI_NBYTES_INVALID)
                                      && (_pFileCtx->mSpiConfig.szHeader  < LSCC_SPI_NBYTES_INVALID)
                                      && (_pFileCtx->mSpiConfig.szPadding < LSCC_SPI_NBYTES_INVALID)) {
      mutex_lock(&tsev_ae53_spi_mutex);
      
      iowrite8((u8)(_pFileCtx->mSpiConfig.clkDiv & 0xFF), &_pDvc->pSpiRegs->spiClkDivLow);      
      iowrite8((u8)((_pFileCtx->mSpiConfig.clkDiv >> 8) & 0xFF), &_pDvc->pSpiRegs->spiClkDivHigh);      

      if (_pFileCtx->mSpiConfig.szCmdRd || _pFileCtx->mSpiConfig.szHeader || _pFileCtx->mSpiConfig.szPadding) {
         _mSpiConfig    =  C_VAL_SPI_WORD_SIZE_8;
         
         _mXferTotal    = len;
         _mXferTotal    += _pFileCtx->mSpiConfig.szHeader;
         _mXferTotal    += _pFileCtx->mSpiConfig.szPadding;         
         }
      else {
         _mSpiConfig    =  (_pFileCtx->mSpiConfig.wordSize - 1) << C_BPOS_SPI_CONFIG_DATA_NBYTES;
         
         _mXferTotal    = len / _pFileCtx->mSpiConfig.wordSize;
         }
      
      _mSpiConfig |= (_pFileCtx->mSpiConfig.flagCpha)       ? (1 << C_BPOS_SPI_CONFIG_CPHA) : 0;
      _mSpiConfig |= (_pFileCtx->mSpiConfig.flagCpol)       ? (1 << C_BPOS_SPI_CONFIG_CPOL) : 0;
      _mSpiConfig |= (_pFileCtx->mSpiConfig.flagLsbFirst)   ? (1 << C_BPOS_SPI_CONFIG_LSB_FIRST) : 0;
      _mSpiConfig |= (_pFileCtx->mSpiConfig.flagSselPulse)  ? (1 << C_BPOS_SPI_CONFIG_SSEL_PULSE) : 0;

      iowrite8(_mSpiConfig, &_pDvc->pSpiRegs->spiConfig);      
      
      iowrite8(((_pFileCtx->mSpiConfig.flagSselPolarity) ? (1 << (_pFileCtx->mSpiConfig.spiSel % 8)) : 0), &_pDvc->pSpiRegs->spiSlvPolarity);      
      iowrite8(1 << (_pFileCtx->mSpiConfig.spiSel % 8), &_pDvc->pSpiRegs->spiSlvSel);      
      
      
     
      mutex_unlock(&tsev_ae53_spi_mutex);
      }
      
   return _mXferSz;
   }
   
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          tsev_fwrite : Write to  Device
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
ssize_t  tsev_fwrite(struct file *fp, const char __user *userBuf, size_t len, loff_t *offp) {

   pT_TSEV_FILE_CTX     _pFileCtx;


   _pFileCtx      = fp->private_data;
   
   switch (_pFileCtx->mTargetID) {
      case (LSCC_EBR) :
         return tsev_fwrite_ebr(fp, userBuf, len, offp);
         break;
         
      default:
         return -EFAULT;
      }
   }
   
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    tsev_fwrite_ebr : Write to EBR Target 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
ssize_t tsev_fwrite_ebr(struct file *fp, const char __user *userBuf, size_t len, loff_t *offp) {
   
   size_t               _mBufSz;
   LSCC_U32             _mOffset = 0;
   size_t               _mXferSz;
   pT_LSCC_AE53_DVC     _pDvc;
   pT_TSEV_FILE_CTX     _pFileCtx;
   LSCC_U8*             _pWrBuf;
   void __user*         _pUserBuf;
   int                  ix;


   _pFileCtx      = fp->private_data;
   _pDvc          = _pFileCtx->pTsevDvc;   
   _pUserBuf      = (void __user *)userBuf;
   
   _mBufSz  = len;
   _mOffset = (*offp & 0xFFFF) / sizeof(LSCC_U32);
     
   if (_mBufSz > C_MAX_MEM_ADR)
      _mBufSz  = C_MAX_MEM_ADR;
   
   _pWrBuf  = (LSCC_U8*)vmalloc(_mBufSz);
   memset((void*)_pWrBuf, 0, _mBufSz);
   
   if (copy_from_user(_pWrBuf, _pUserBuf, _mBufSz)) {
      printk(KERN_ERR "ae53.tsev_fwrite: Could not copy user buffer to xfer-buffer\n");
      return -EFAULT;
      }  
      
   for (ix = 0; ix < (_mBufSz / sizeof(LSCC_U32)); ix++) {
      iowrite32(*(((LSCC_U32*)_pWrBuf) + ix), &_pDvc->pDvcRegs->bmRAM_0[(_mOffset + ix) % (C_MAX_MEM_ADR / sizeof(LSCC_U32))]);
      }
            
   vfree(_pWrBuf);

   return _mXferSz;
   }

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    tsev_fwrite_spi : Write to SPI Target 
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
ssize_t tsev_fwrite_spi(struct file *fp, const char __user *userBuf, size_t len, loff_t *offp) { 
   
   return 0;
   }
