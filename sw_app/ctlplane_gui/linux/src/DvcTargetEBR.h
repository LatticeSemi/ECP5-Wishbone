
//
//    Copyright Ing. Buero Gardiner, 2021
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
//    All Rights Reserved
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: DvcTargetEBR.h 26 2021-10-06 11:35:55Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:35:55 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 26 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#include <stdint.h>
#include <stdlib.h>

class DvcTargetEBR {
   public:
      DvcTargetEBR();
      ~DvcTargetEBR();
      
      bool     connect(const char* fpath);
      bool     getDW(uint32_t vAdr, uint32_t* pDw);    
      bool     isConnected();
      bool     putDW(uint32_t vAdr, uint32_t vDw);    
      bool     randomise(off_t offset = 0, size_t rndSz = 512);
      ssize_t  read(void *buf, size_t count, off_t offset);    
      ssize_t  write(void *buf, size_t count, off_t offset);    
      ssize_t  write(uint8_t dval, off_t offset);    
      ssize_t  write(uint16_t dval, off_t offset);    
      ssize_t  write(uint32_t dval, off_t offset);    
   
   protected:
      int   hFile;
   };
