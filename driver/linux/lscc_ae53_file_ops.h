
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_ae53_file_ops.h 25 2021-10-06 11:19:57Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:19:57 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 25 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// -----------------------------------------------------------------------------

#ifndef _LSCC_AE53_FILE_OPS_H
#define _LSCC_AE53_FILE_OPS_H

#include "lscc_ae53_pch.h"
#include "lscc_ae53_private.h"

#define  C_BPOS_SPI_CONFIG_CPHA           0
#define  C_BPOS_SPI_CONFIG_CPOL           1
#define  C_BPOS_SPI_CONFIG_DATA_NBYTES    3
#define  C_BPOS_SPI_CONFIG_LSB_FIRST      6
#define  C_BPOS_SPI_CONFIG_SSEL_PULSE     2
#define  C_BPOS_SPI_CONFIG_WR_RDN         5
#define  C_BPOS_SPI_FIFO_CLR_RX           0
#define  C_BPOS_SPI_FIFO_CLR_TX           1
#define  C_BPOS_SPI_IRQ_FIFO_RX_AFULL     1
#define  C_BPOS_SPI_IRQ_FIFO_TX_AMT       4
#define  C_BPOS_SPI_IRQ_XFER_DONE         7

#define  C_VAL_SPI_WORD_SIZE_8            0
#define  C_VAL_SPI_WORD_SIZE_16           1
#define  C_VAL_SPI_WORD_SIZE_24           2
#define  C_VAL_SPI_WORD_SIZE_32           3

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          Structure for describing a File Context
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
   
typedef struct _T_TSEV_FILE_CTX {
      // Put the SPI configuration here. This allows different file-handles 
      // to have different settings      
   T_TSEV_SPI_CONFIG    mSpiConfig;   
      // Selects between Block memory and SPI as target for read()/write()   
   T_FILE_UNIT_ID       mTargetID;
   
   pT_LSCC_AE53_DVC     pTsevDvc;

   } T_TSEV_FILE_CTX, *pT_TSEV_FILE_CTX;

//
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//          Function Prototypes
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//
int      tsev_fclose(struct inode* inode, struct file* fp);
int      tsev_fopen(struct inode* inode, struct file* fp);
ssize_t  tsev_fread(struct file *fp, char __user *userBuf, size_t len, loff_t *offp);
ssize_t  tsev_fwrite(struct file *fp, const char __user *userBuf, size_t len, loff_t *offp);

#endif
   
