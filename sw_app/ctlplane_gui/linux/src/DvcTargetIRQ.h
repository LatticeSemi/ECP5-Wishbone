
//
//    Copyright Ing. Buero Gardiner, 2021
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
//    All Rights Reserved
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: DvcTargetIRQ.h 26 2021-10-06 11:35:55Z  $
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

class DvcTargetIRQ {
   public:
      DvcTargetIRQ();
      ~DvcTargetIRQ();
      
      bool     connect(const char* fpath);
      bool     isConnected();
   
   protected:
      int   hFile;
   };
