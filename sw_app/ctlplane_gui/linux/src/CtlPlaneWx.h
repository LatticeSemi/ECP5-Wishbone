
//
//    Copyright Ing. Buero Gardiner, 2021
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
//    All Rights Reserved
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: CtlPlaneWx.h 26 2021-10-06 11:35:55Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:35:55 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 26 $
//
// -----------------------------------------------------------------------------
//
// Description :  Defines the customised wxWidgets application. This is the
//                interface between the wxWidgets framework and the GUI
//                application seen by the user
//
// -----------------------------------------------------------------------------

#include <wx/wxprec.h>
#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

   // ------------------------------------------------------------------------
   //    The CtlPlaneWx class is derived from the wxWidgets class wxApp
   //    wxApp represents an application which uses the wxWidgets libraries
   //
   //    This section defines the overloaded and application-specific methods
   //    and parameters.
   // ------------------------------------------------------------------------  
class CtlPlaneWx : public wxApp {
   public:
      virtual bool OnInit();
   };
