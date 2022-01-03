
//
//    Copyright Ing. Buero Gardiner, 2021
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
//    All Rights Reserved
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: CtlPlaneWx.cpp 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :  Implements the application top level
//                1) Register the application with the wxWidgets framework
//                2) Overload or implement CtlPlaneWx class methods
//
// -----------------------------------------------------------------------------

#include "CtlPlaneWx.h"
#include "CtlPlaneFrame.h"

   // ------------------------------------------------------------------------
   //    Register this application with the wxWidgets framework
   // ------------------------------------------------------------------------  
wxIMPLEMENT_APP(CtlPlaneWx);

   // ------------------------------------------------------------------------
   //    Initialise and Execute the Frame object. This is the Window which 
   //    the user sees.
   // ------------------------------------------------------------------------   
bool CtlPlaneWx::OnInit() {
      // Create an instance of the application window
   CtlPlaneFrame*   mFrame = new CtlPlaneFrame();
   
      // Configure the appearance of the application window
   mFrame->SetSize(20, 20, 1280, 500);
   
      // Display the application window
   mFrame->Show(true);
   
   return true;
   }
   
