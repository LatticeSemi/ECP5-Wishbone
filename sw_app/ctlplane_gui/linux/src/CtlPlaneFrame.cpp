
//
//    Copyright Ing. Buero Gardiner, 2021
//       https://www.ib-gardiner.eu
//       techsupport@ib-gardiner.eu
//
//    All Rights Reserved
//
// -----------------------------------------------------------------------------
//
// File ID     : $Id: CtlPlaneFrame.cpp 27 2021-10-06 13:09:29Z  $
// Generated   : $LastChangedDate: 2021-10-06 15:09:29 +0200 (Wed, 06 Oct 2021) $
// Revision    : $LastChangedRevision: 27 $
//
// -----------------------------------------------------------------------------
//
// Description :
//
// Note :   The this-> in front of the class variables is not strictly needed 
//          but it does make it more obvoius where the variable is declared.
//          It can also be useful if a local variable of the same name exists 
//          in a class method, making sure that the correct varible is used
// -----------------------------------------------------------------------------

#include "CtlPlaneFrame.h"

#include <sstream>
#include <string>

#include <wx/panel.h>

using namespace std;

enum {
      // Just a bunch of user defined IDs. Some IDs for identifying buttons, controls and menu items 
      // are already defined by the wxWidgets library such as wxID_ABOUT and wxID_EXIT. Most of the
      // standard IDs are < 2 or > 4999
   ID_BTN_RANDOM_EBR  = 301,
   ID_BTN_UPDATE_EBR  = 302
   };
   
wxBEGIN_EVENT_TABLE(CtlPlaneFrame, wxFrame)
   EVT_BUTTON( ID_BTN_RANDOM_EBR, CtlPlaneFrame::OnRandomiseEBR )
   EVT_BUTTON( ID_BTN_UPDATE_EBR, CtlPlaneFrame::OnUpdateEBR )

wxEND_EVENT_TABLE()

   
   // ------------------------------------------------------------------------
   //    The class constructor for the Frame object.
   //    
   //    The constructor in the base class wxFrame is called first, passing
   //    parameters such as the parent (NULL, this is the top windo of the 
   //    application), an Identifier (don't care) and the text to be displayed
   //    in the title bar
   //
   //    The GUI is not displayed until the application calls the Show() 
   //    method inherited from the base class wxFrame. This is done at the 
   //    end of CtlPlaneWx::OnInit(), i.e. when the initialisation of the
   //    wxWidgets application is complete
   // ------------------------------------------------------------------------   
CtlPlaneFrame::CtlPlaneFrame() : wxFrame(NULL, wxID_ANY, "ECPx Control Plane GUI") {

   wxMenu*  mMenuFile   = new wxMenu;
    
   this->pPanel      = new wxPanel(this);
      
   this->pSizerRoot  = new wxBoxSizer(wxVERTICAL);
   
   mMenuFile->AppendSeparator();
   mMenuFile->Append(wxID_EXIT);
   
   wxMenu*  mMenuHelp = new wxMenu;
   mMenuHelp->Append(wxID_ABOUT);
   wxMenuBar*  mMenuBar = new wxMenuBar;
   mMenuBar->Append(mMenuFile, "&File");
   mMenuBar->Append(mMenuHelp, "&Help");
   SetMenuBar( mMenuBar );
   
   CreateStatusBar();
   SetStatusText("Lattice ECPx App");
   
   Bind(wxEVT_MENU, &CtlPlaneFrame::OnAbout, this, wxID_ABOUT);
   Bind(wxEVT_MENU, &CtlPlaneFrame::OnExit, this, wxID_EXIT);    
      
   InitSubframeIRQ();
 //InitSubframeSPI();
   InitSubframeEBR();
   
   this->pPanel->SetSizer(this->pSizerRoot);   
   };

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------    
void CtlPlaneFrame::InitSubframeEBR() {
   int                     mCharWidth;
   wxScreenDC              mScreenDC;   
   wxButton*               pButton;
   wxDataViewListStore*    pDataViewEBR;
   wxGridSizer*            pGrid;
   wxSizer*                pSizer; 
   wxSizer*                pSizerBox;
   
   
   pSizer      = new wxStaticBoxSizer(wxHORIZONTAL, this->pPanel, " EBR Target ");
   pSizerBox   = new wxBoxSizer(wxVERTICAL);
   
   this->pSizerRoot->Add(pSizer, wxSizerFlags(100).Expand().Border());
   
      // The left-hand part of the child box uses 90% of available width in enclosing box
      // we will use the remaining part for the button child-box below
   pSizer->Add(pSizerBox, wxSizerFlags(90).Expand());
   
      // The wxDataViewListStore stores the data
   pDataViewEBR         = new wxDataViewListStore();
      // The wxDataViewListCtrl displays/renders the data   
   this->pListViewEBR   = new wxDataViewListCtrl(this->pPanel, wxID_ANY, wxDefaultPosition, wxDefaultSize, wxDV_ROW_LINES | wxVSCROLL);
      // Link the storage to the renderer
   this->pListViewEBR->AssociateModel(pDataViewEBR);

   pSizerBox->Add(this->pListViewEBR, wxSizerFlags(100).Expand().Border());
   
      // Get the current font size so we can calculate the width needed to disply a 10-character
      // hex string e.g. 0x01234567
   mScreenDC.SetFont(this->pListViewEBR->GetFont());
   mCharWidth  = mScreenDC.GetTextExtent(wxString('M', 10)).GetWidth();    
      
      // Define the table appearance
      // We want to display 32 bytes per row arranged as eight DWords. LSB is on the right
   this->pListViewEBR->AppendTextColumn("Address", wxDATAVIEW_CELL_EDITABLE, -1, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x1C", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x18", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x14", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x10", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x0C", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x08", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x04", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   this->pListViewEBR->AppendTextColumn("0x00", wxDATAVIEW_CELL_EDITABLE, mCharWidth, wxALIGN_CENTER);
   
      // Connect to the LFD2NX hardware and read the first part of the current EBR content
   if (this->mTargetEBR.connect("/dev/lscc_ae53/0"))
      UpdateViewEBR();   
   else
      wxMessageBox("No File Handle to Device", "Error Info", wxOK | wxICON_INFORMATION);         
   
      // Add the additional buttons for manipulating the data and assign event IDs to the buttons
      // The event IDs are registered with an event handler at the start of this file
   pSizerBox   = new wxBoxSizer(wxVERTICAL);
   
   pGrid    = new wxGridSizer(2, 1, 0, 0);
   pSizerBox->Add(pGrid, wxSizerFlags(100).Expand().Border());

   pButton     = new wxButton(this->pPanel, ID_BTN_RANDOM_EBR, wxT("Randomise"));
   pGrid->Add(pButton, 0, wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL | wxALL, 5);
   pButton     = new wxButton(this->pPanel, ID_BTN_UPDATE_EBR, wxT("Update"));
   pGrid->Add(pButton, 0, wxALIGN_CENTER_HORIZONTAL | wxALIGN_CENTER_VERTICAL | wxALL, 5);   
   
      // Insert the box containing the buttons on the right.
      // The enclosing box has been defined as wxHORIZONTAL above
   pSizer->Add(pSizerBox, wxSizerFlags(20).Expand());
   
   pListViewEBR->Bind(wxEVT_DATAVIEW_ITEM_VALUE_CHANGED, &CtlPlaneFrame::OnListValueChanged, this);
   }
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------    
void CtlPlaneFrame::InitSubframeIRQ() {
   wxSizer*       pSizer;
   //wxSizer*       pSizerBox;
   
   
   pSizer      = new wxStaticBoxSizer(wxVERTICAL, this->pPanel, " Panel 1  ");
   //pSizer      = new wxStaticBoxSizer(wxVERTICAL, this->pPanel, " IRQ Subsystem  ");
   //pSizerBox   = new wxBoxSizer(wxHORIZONTAL);
   
   this->pSizerRoot->Add(pSizer, wxSizerFlags(100).Expand().Border());
   //pSizer->Add(pSizerBox, wxSizerFlags(100).Expand());   
   }

   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------    
void CtlPlaneFrame::InitSubframeSPI() {
   wxSizer*       pSizer;
   wxSizer*       pSizerBox;
   
   
   pSizer      = new wxStaticBoxSizer(wxVERTICAL, this->pPanel, " Panel 2 ");
 //pSizer      = new wxStaticBoxSizer(wxVERTICAL, this->pPanel, " SPI Target ");
   pSizerBox   = new wxBoxSizer(wxHORIZONTAL);
   
   this->pSizerRoot->Add(pSizer, wxSizerFlags(100).Expand().Border());
   pSizer->Add(pSizerBox, wxSizerFlags(100).Expand());      
   }
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------     
void CtlPlaneFrame::OnAbout(wxCommandEvent& event) {
   wxMessageBox("This is a Lattice ECP5 Demo",
                "About ECP5 App", wxOK | wxICON_INFORMATION);
   }  
   
   // ------------------------------------------------------------------------
   //    
   // ------------------------------------------------------------------------     
void CtlPlaneFrame::OnExit(wxCommandEvent& event) {
   Close(true);
   }

   // ------------------------------------------------------------------------
   //    This callback is executed when a value in the memory table is modified    
   // ------------------------------------------------------------------------      
void CtlPlaneFrame::OnListValueChanged(wxDataViewEvent& event) {
   uint32_t          mAdrValue;
   uint32_t          mColSel;
   uint32_t          mDataValue;
   wxString          mFieldWx;
   string            mFieldString;
   uint32_t          mRowSel;
   istringstream*    pFieldStream;

   
   mColSel  = event.GetColumn();
   mRowSel  = pListViewEBR->ItemToRow(event.GetItem());
   
   if (mColSel > 0) {
         // Update a memory location
      mFieldWx       = pListViewEBR->GetTextValue(mRowSel, mColSel);
      mFieldString   = mFieldWx.c_str();
      pFieldStream   = new istringstream(mFieldString);

      *pFieldStream >> hex >> mDataValue;
      
      mFieldWx       = pListViewEBR->GetTextValue(mRowSel, 0);
      mFieldString   = mFieldWx.c_str();
      pFieldStream   = new istringstream(mFieldString);

      *pFieldStream >> hex >> mAdrValue;      
         // We have eight columns, the lowest address is to the right
      mAdrValue   += (8 - mColSel) * sizeof(uint32_t);
      
      this->mTargetEBR.putDW(mAdrValue, mDataValue); 
      
         // Some sanity checks/clean-ups
      mAdrValue   &= ~((1 << 5) - 1);
      mAdrValue   -= mRowSel * 32;
      mAdrValue   = (mAdrValue & 0x80000000) ? 0 : mAdrValue;   
      UpdateViewEBR(mAdrValue);
      
    //wxMessageBox(wxString::Format("Modify location 0x%08x, 0x%08x", 
    //            mAdrValue, mDataValue),
    //            "List Info", wxOK | wxICON_INFORMATION);         
      }
   else {
         // Reposition the view window
      mFieldWx       = pListViewEBR->GetTextValue(mRowSel, 0);
      mFieldString   = mFieldWx.c_str();
      pFieldStream   = new istringstream(mFieldString);

      *pFieldStream >> hex >> mAdrValue;  
         // Some sanity checks/clean-ups
      mAdrValue   &= ~((1 << 5) - 1);
      mAdrValue   -= mRowSel * 32;
      mAdrValue   = (mAdrValue & 0x80000000) ? 0 : mAdrValue;
      
      UpdateViewEBR(mAdrValue);
      }
   }

   // ------------------------------------------------------------------------
   //    This callback is executed when the Randomise button is pressed    
   // ------------------------------------------------------------------------   
void CtlPlaneFrame::OnRandomiseEBR( wxCommandEvent& WXUNUSED(event)) {
   uint32_t          mAdrValue;
   wxString          mFieldWx;
   string            mFieldString;
   istringstream*    pFieldStream;

   
   mFieldWx       = pListViewEBR->GetTextValue(0, 0);
   mFieldString   = mFieldWx.c_str();
   pFieldStream   = new istringstream(mFieldString);

   *pFieldStream >> hex >> mAdrValue;  
   
   this->mTargetEBR.randomise(mAdrValue);

   UpdateViewEBR();
   }
   
   // ------------------------------------------------------------------------
   //    This callback is executed when the Update button is pressed    
   // ------------------------------------------------------------------------   
void CtlPlaneFrame::OnUpdateEBR( wxCommandEvent& WXUNUSED(event)) {
   uint32_t          mAdrValue;
   wxString          mFieldWx;
   string            mFieldString;
   istringstream*    pFieldStream;

   
   mFieldWx       = pListViewEBR->GetTextValue(0, 0);
   mFieldString   = mFieldWx.c_str();
   pFieldStream   = new istringstream(mFieldString);

   *pFieldStream >> hex >> mAdrValue;  
   
   UpdateViewEBR(mAdrValue);
   }  

   // ------------------------------------------------------------------------
   //    This routine fetches an EBR memory region and displays it
   // ------------------------------------------------------------------------    
void CtlPlaneFrame::UpdateViewEBR(uint32_t ofs) {
   wxVector<wxVariant>     mMemLineEBR;      
   uint8_t                 mRxBufEBR[256];
   
   
   this->pListViewEBR->DeleteAllItems();

   if (this->mTargetEBR.read(mRxBufEBR, sizeof(mRxBufEBR), ofs) > 0) {
      for (int ix = 0; ix < 7; ix++) {
         mMemLineEBR.clear();
         
            // Fill the address column (left-most)
         mMemLineEBR.push_back(wxString::Format("0x%04x", ofs + (ix * 32)));
         
         for (int jx = 1; jx < 9; jx++) 
            mMemLineEBR.push_back(wxString::Format("0x%08x", *(((uint32_t*)mRxBufEBR) + ((ix + 1) * 8) - jx)));
         
         this->pListViewEBR->AppendItem( mMemLineEBR );
         }
      }
   else
      wxMessageBox("No Data returned from device", "Error Info", wxOK | wxICON_INFORMATION);    
   }
   
