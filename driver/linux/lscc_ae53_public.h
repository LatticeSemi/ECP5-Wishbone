
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_public.h 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------
//          /usr/src/linux/include/linux
// -----------------------------------------------------------------------------

#ifndef _LSCC_AE53_PUBLIC_H_
#define _LSCC_AE53_PUBLIC_H_

#include "../common/include/lscc_types.h"

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
typedef enum _T_FILE_UNIT_ID {
   LSCC_UNKNOWN   = 0,
   LSCC_EBR       = 1,
   LSCC_SPI       = 2,   
   LSCC_INVALID   = 3

   } T_FILE_UNIT_ID;
   
typedef enum _T_SPI_NBYTES_SPEC {
   LSCC_SPI_NBYTES_NONE       = 0,
   LSCC_SPI_NBYTES_ONE        = 1,
   LSCC_SPI_NBYTES_TWO        = 2,   
   LSCC_SPI_NBYTES_THREE      = 3,   
   LSCC_SPI_NBYTES_FOUR       = 4,   
   LSCC_SPI_NBYTES_INVALID    = 5

   } T_SPI_NBYTES_SPEC;

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//   
typedef struct _T_TSEV_REG_DESCR {
   LSCC_U32    regAdr;
   LSCC_U32    regValue;
   LSCC_U8     regByteEn;
   
   } T_TSEV_REG_DESCR, *pT_TSEV_REG_DESCR;   
   
typedef struct _T_TSEV_SPI_CONFIG {
   LSCC_U16    clkDiv;
   LSCC_U32    cmdOpRead;
   LSCC_U32    cmdOpWrite;   
   LSCC_U8     flagCpha : 1;
   LSCC_U8     flagCpol : 1;
   LSCC_U8     flagLsbFirst : 1;
   LSCC_U8     flagSselPolarity : 1;
   LSCC_U8     flagSselPulse : 1;
   LSCC_U8     szCmdRd;
   LSCC_U8     szCmdWr;
   LSCC_U8     szHeader;
   LSCC_U8     szPadding;   
   LSCC_U8     spiSel;
   LSCC_U8     wordSize;

   } T_TSEV_SPI_CONFIG;
   
//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//    Generated randomly using  perl -e 'printf "%x\n", rand(256)'
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
#define TSEV_IOCTL_MAGIC      0x9C

#define TSEV_CTL_REG_READ        0x0F
#define TSEV_CTL_REG_WRITE       0x61 
#define TSEV_CTL_TGT_SELECT      0xBF

   // These (LHS) are the codes used in user space
#define TSEV_AE53_REG_READ          _IOWR(TSEV_IOCTL_MAGIC, TSEV_CTL_REG_READ, T_TSEV_REG_DESCR*)
#define TSEV_AE53_REG_WRITE         _IOW(TSEV_IOCTL_MAGIC, TSEV_CTL_REG_WRITE, T_TSEV_REG_DESCR*)
#define TSEV_AE53_TGT_SELECT        _IOW(TSEV_IOCTL_MAGIC, TSEV_CTL_TGT_SELECT, T_FILE_UNIT_ID*)

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//

   
#endif
