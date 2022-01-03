
//
//    Copyright Ing. Buero Gardiner, 2021
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
//    All Rights Reserved
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: DvcTargetEBR.cpp 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#include "DvcTargetEBR.h"
#include "lscc_ae53_public.h"

#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#define EBR0_ADR_BASE   0
#define EBR1_ADR_BASE   4096

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------    
DvcTargetEBR::DvcTargetEBR() {
   hFile    = 0;
   
   srand(time(NULL));
   }

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------ 
DvcTargetEBR::~DvcTargetEBR() {
   
   if (hFile) {
      close(hFile);
      
      hFile    = 0;
      }
   }

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------       
bool DvcTargetEBR::connect(const char* fpath) {
   uint8_t     _TgtID;
   
   if (hFile > 0) 
      close(hFile);
   
   hFile    = ::open(fpath, O_RDWR);
   
   if (hFile < 0)
      return false;
   else {
      _TgtID   = LSCC_EBR;
      
      ::ioctl(hFile, TSEV_AE53_TGT_SELECT, &_TgtID);
      
      return true;
      }
   }

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------      
bool DvcTargetEBR::getDW(uint32_t vAdr, uint32_t* pDw) {
   T_TSEV_REG_DESCR     _RegOpDescr;

   if (hFile < 1)
      return false;
   
   _RegOpDescr.regAdr      = vAdr;
   _RegOpDescr.regByteEn   = 0x0F;
   
   ::ioctl(hFile, TSEV_AE53_REG_READ, &_RegOpDescr);
   
   *pDw  = _RegOpDescr.regValue;
   
   return true;
   }
   
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------     
bool DvcTargetEBR::isConnected() {
   return (hFile > 0);
   }
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------      
bool DvcTargetEBR::putDW(uint32_t vAdr, uint32_t vDw) {
   T_TSEV_REG_DESCR     _RegOpDescr;

   if (hFile < 1)
      return false;
   
   _RegOpDescr.regAdr      = EBR0_ADR_BASE + vAdr;
   _RegOpDescr.regByteEn   = 0x0F;
   _RegOpDescr.regValue    = vDw;
   
   ::ioctl(hFile, TSEV_AE53_REG_WRITE, &_RegOpDescr);
   
   return true;
   }
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------    
bool DvcTargetEBR::randomise(off_t offset, size_t rndSz) {
   
   int            _XferSz;
   uint8_t*       _pTxBuf;
   
   
   if (hFile < 1)
      return false;
   
   if (rndSz > 4096)
      return false;
   
   _pTxBuf        = new uint8_t[rndSz]; 
   
   memset(_pTxBuf, 0, rndSz);

   for (int ix = 0; ix < rndSz; ix++)
      *(_pTxBuf + ix)   = rand() % 256;
   
   _XferSz   = ::pwrite(hFile, (void*)_pTxBuf, rndSz, offset);   
   
   delete _pTxBuf;
   
   return (_XferSz > 0);
   };
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------    
ssize_t DvcTargetEBR::read(void *buf, size_t count, off_t offset) {
   
   if (! hFile)
      return -1;
   
   return ::pread(hFile, (void*)buf, count, offset);
   }

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------   
ssize_t DvcTargetEBR::write(void *buf, size_t count, off_t offset) {
   
   if (! hFile)
      return -1;
   
   return ::pwrite(hFile, (void*)buf, count, offset);   
   }

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------  
ssize_t DvcTargetEBR::write(uint8_t dval, off_t offset) {
   uint8_t  _Buf;
   
   if (! hFile)
      return -1;
   
   _Buf  = dval;
   return ::pwrite(hFile, (void*)&_Buf, sizeof(_Buf), offset);    
   }
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------  
ssize_t DvcTargetEBR::write(uint16_t dval, off_t offset) {
   uint16_t    _Buf;

   if (! hFile)
      return -1;
   
   return ::pwrite(hFile, (void*)&_Buf, sizeof(_Buf), offset);    
   }
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------  
ssize_t DvcTargetEBR::write(uint32_t dval, off_t offset) {
   uint32_t    _Buf;

   if (! hFile)
      return -1;
   
   return ::pwrite(hFile, (void*)&_Buf, sizeof(_Buf), offset);    
   }
