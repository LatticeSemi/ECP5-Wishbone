
# 
#     Copyright Ing. Buero Gardiner, 2021
#        https://www.ib-gardiner.eu
#        techsupport@ib-gardiner.eu
# 
#     All Rights Reserved
# 
#  -----------------------------------------------------------------------------
# 
#  File ID     : $Id: Ta90_AdapterImpl.cpp 7165 2021-07-14 21:14:09Z  $
#  Generated   : $LastChangedDate: 2021-07-14 23:14:09 +0200 (Wed, 14 Jul 2021) $
#  Revision    : $LastChangedRevision: 7165 $
# 
#  -----------------------------------------------------------------------------

# g++ <list of project files> -I$TF_HOME/driver/linux `wx-config --libs --cxxflags` -o ctlplane_wx

SRC_FILES = DvcTargetEBR.cpp CtlPlaneFrame.cpp CtlPlaneWx.cpp

INCLUDES	= -I. -I${TF_HOME}/driver/linux
PLATFORM	= LINUX

CXX = g++ 


all: ctlplane_wx

ctlplane_wx: $(SRC_FILES)
	$(CXX) $^ $(INCLUDES) `wx-config --libs --cxxflags` -o $@ 
	
clean:
	$(RM) ctlplane_wx
	
