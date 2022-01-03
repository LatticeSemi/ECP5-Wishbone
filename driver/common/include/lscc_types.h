
//
//    Developed by Ingenieurbuero Gardiner
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: lscc_types.h 30 2021-11-08 23:03:28Z  $
// Generated   : $LastChangedDate: 2021-11-09 00:03:28 +0100 (Tue, 09 Nov 2021) $
// Revision    : $LastChangedRevision: 30 $
//
// -----------------------------------------------------------------------------
//
// Description :  This file is really only needed for the driver public header
//                files which are shared by user-space and kernel-space 
//                applications. Here, the types are typicall used in IOCTL calls
//                and in structure definitions. 
//                Within the driver or user space files themselves, the appropriate
//                locally defined types can be used.
//
// -----------------------------------------------------------------------------

#ifndef _LSCC_TYPES_H
#define _LSCC_TYPES_H

   #ifdef WIN32
         // Type defines for Windows Application
      #include <stdint.h>
   
      #define LSCC_S8   int8_t
      #define LSCC_U8   uint8_t
      #define LSCC_S16  int16_t
      #define LSCC_U16  uint16_t
      #define LSCC_S32  int32_t   
      #define LSCC_U32  uint32_t
      #define LSCC_S64  int64_t
      #define LSCC_U64  uint64_t

   #else
      #ifdef _WDMDDK_
            // Type defines for Windows Device Driver
            
         #define LSCC_S8   CHAR
         #define LSCC_U8   UCHAR
         #define LSCC_S16  SHORT
         #define LSCC_U16  USHORT
         #define LSCC_S32	LONG   
         #define LSCC_U32  DWORD
         #define LSCC_S64  LONG64
         #define LSCC_U64  ULONG64
            
      #else
         #include "linux/types.h"

         #define LSCC_IOCTL_MAGIC      0xC0
         
         #ifdef __KERNEL__
               // Type defines for Linux kernel space 
               
            #define LSCC_S8   s8
            #define LSCC_U8   u8
            #define LSCC_S16  s16
            #define LSCC_U16  u16
            #define LSCC_S32	s32
            #define LSCC_U32  u32
            #define LSCC_S64  s64
            #define LSCC_U64  u64
         
         #else
               // Type defines for Linux user_space applications
            #include <stdint.h>
               
            #define LSCC_S8   int8_t
            #define LSCC_U8   uint8_t
            #define LSCC_S16  int16_t
            #define LSCC_U16  uint16_t
            #define LSCC_S32  int32_t   
            #define LSCC_U32  uint32_t
            #define LSCC_S64  int64_t
            #define LSCC_U64  uint64_t
            
         #endif   // End ifdef __KERNEL__
      #endif   // End ifdef _WDMDDK_
   #endif // End ifdef WIN32
#endif
