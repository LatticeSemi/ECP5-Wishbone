
//
//    Copyright Ing. Buero Gardiner, 2021
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
//    All Rights Reserved
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: CtlPlaneFrame.h 26 2021-10-06 11:35:55Z  $
// Generated   : $LastChangedDate: 2021-10-06 13:35:55 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 26 $
//
// -----------------------------------------------------------------------------
//
// Description :  The CtlPlaneFrame class implements the GUI part of the 
//                application.
//
// -----------------------------------------------------------------------------

#include <wx/wxprec.h>
#ifndef WX_PRECOMP
    #include <wx/wx.h>
#endif

#include <wx/dataview.h>
#include <wx/listctrl.h>
#include <wx/sizer.h>

#include "DvcTargetEBR.h"

   // ------------------------------------------------------------------------
   //    Define the overloaded and application-specific methods
   //    and parameters.
   //
   //    The CtlPlaneFrame object represents the GUI application as seen by 
   //    the user and inherits from the wxWidges class wxFrame
   // ------------------------------------------------------------------------  
class CtlPlaneFrame : public wxFrame {
   public:
      CtlPlaneFrame();

   protected:
      void  InitSubframeEBR();
      void  InitSubframeIRQ();
      void  InitSubframeSPI();
            
   private:
      void OnAbout(wxCommandEvent& event);
      void OnExit(wxCommandEvent& event);
      void OnListValueChanged(wxDataViewEvent& event);
      void OnRandomiseEBR(wxCommandEvent& event);
      void OnUpdateEBR(wxCommandEvent& event);
      void UpdateViewEBR(uint32_t ofs = 0);
      
   protected:
      DvcTargetEBR         mTargetEBR;   
      wxDataViewListCtrl*  pListViewEBR;   
      wxPanel*             pPanel;
      wxSizer*             pSizerRoot;
      
   private:
      wxDECLARE_EVENT_TABLE();      
   };
   
