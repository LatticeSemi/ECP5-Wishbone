--    
--    Copyright Ingenieurbuero Gardiner, 2007 - 2020
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--
--       This proprietary software may be used only as authorised in a licensing,
--       product development or training agreement.
--
--       Copies may only be made to the extent permitted by such an aforementioned
--       agreement. This entire notice above must be reproduced on
--       all copies.
--     
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_wbone_types-pb.vhd 33 2021-11-16 22:43:39Z  $
-- Generated   : $LastChangedDate: 2021-11-16 23:43:39 +0100 (Tue, 16 Nov 2021) $
-- Revision    : $LastChangedRevision: 33 $
--
--------------------------------------------------------------------------------
--
-- Description : Wishbone Utility Package
-- Work for modelsim issues:
--    ** Error: soc/common/packages/tspc_wbone_types/vhdl/tspc_wbone_types-pb.vhd(35): 
--       (vcom-1440) Language feature RECORD AGGREGATE IN A'ELEMENT OR O'SUBTYPE CONTEXT is not supported yet.
--
--------------------------------------------------------------------------------
Library IEEE;
Use IEEE.numeric_std.all;

Package Body tspc_wbone_types is
   function f_init(vrec : t_wb_classic_m2s) return t_wb_classic_m2s is   
      variable v_retval    : vrec'subtype;

   begin      
      v_retval.adr     := std_logic_vector(to_unsigned(0, v_retval.adr'length ));
      v_retval.cyc     := '0';
      v_retval.data    := std_logic_vector(to_unsigned(0, v_retval.data'length ));
      v_retval.lock    := '0';
      v_retval.sel     := std_logic_vector(to_unsigned(0, v_retval.sel'length ));
      v_retval.stb     := '0';
      v_retval.we      := '0';

      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_classic_m2s_multidrop) return t_wb_classic_m2s_multidrop is                                                        
      variable v_retval    : vrec'subtype;

   begin      
      v_retval.adr     := std_logic_vector(to_unsigned(0, v_retval.adr'length ));
      v_retval.cyc     := std_logic_vector(to_unsigned(0, v_retval.cyc'length ));
      v_retval.data    := std_logic_vector(to_unsigned(0, v_retval.data'length ));
      v_retval.lock    := '0';
      v_retval.sel     := std_logic_vector(to_unsigned(0, v_retval.sel'length ));
      v_retval.stb     := '0';
      v_retval.we      := '0';
      
      return v_retval;
   end function;   

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_classic_tgx_m2s) return t_wb_classic_tgx_m2s is                                                       
      variable v_retval    : vrec'subtype;

   begin      
      v_retval.base  := f_init(v_retval.base);
      v_retval.tga   := std_logic_vector(to_unsigned(0, v_retval.tga'length ));
      v_retval.tgc   := std_logic_vector(to_unsigned(0, v_retval.tgc'length ));
      v_retval.tgd   := std_logic_vector(to_unsigned(0, v_retval.tgd'length ));
      
      return v_retval;
   end function;   
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_classic_tgx_m2s_multidrop) return t_wb_classic_tgx_m2s_multidrop is 
      variable v_retval    : vrec'subtype;

   begin      
      v_retval.base  := f_init(v_retval.base);
      v_retval.tga   := std_logic_vector(to_unsigned(0, v_retval.tga'length ));
      v_retval.tgc   := std_logic_vector(to_unsigned(0, v_retval.tgc'length ));
      v_retval.tgd   := std_logic_vector(to_unsigned(0, v_retval.tgd'length ));
      
      return v_retval;
   end function;      
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_m2s) return t_wb_regfb_m2s is                                                       
      variable v_retval    : vrec'subtype;

   begin                                                 
      v_retval.adr     := std_logic_vector(to_unsigned(0, v_retval.adr'length ));
      v_retval.bte     := std_logic_vector(to_unsigned(0, v_retval.bte'length ));
      v_retval.cti     := std_logic_vector(to_unsigned(0, v_retval.cti'length ));
      v_retval.cyc     := '0';
      v_retval.data    := std_logic_vector(to_unsigned(0, v_retval.data'length ));
      v_retval.lock    := '0';
      v_retval.sel     := std_logic_vector(to_unsigned(0, v_retval.sel'length ));
      v_retval.stb     := '0';
      v_retval.we      := '0';

      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_m2s_multidrop) return t_wb_regfb_m2s_multidrop is                                                       
      variable v_retval    : vrec'subtype;

   begin                                                 
      v_retval.adr     := std_logic_vector(to_unsigned(0, v_retval.adr'length ));
      v_retval.bte     := std_logic_vector(to_unsigned(0, v_retval.bte'length ));
      v_retval.cti     := std_logic_vector(to_unsigned(0, v_retval.cti'length ));
      v_retval.cyc     := std_logic_vector(to_unsigned(0, v_retval.cyc'length ));
      v_retval.data    := std_logic_vector(to_unsigned(0, v_retval.data'length ));
      v_retval.lock    := '0';
      v_retval.sel     := std_logic_vector(to_unsigned(0, v_retval.sel'length ));
      v_retval.stb     := '0';
      v_retval.we      := '0';

      return v_retval;
   end function;      
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_tgx_m2s) return t_wb_regfb_tgx_m2s is                                                       
      variable v_retval    : vrec'subtype;

   begin      
      v_retval.base  := f_init(v_retval.base);
      v_retval.tga   := std_logic_vector(to_unsigned(0, v_retval.tga'length ));
      v_retval.tgc   := std_logic_vector(to_unsigned(0, v_retval.tgc'length ));
      v_retval.tgd   := std_logic_vector(to_unsigned(0, v_retval.tgd'length ));
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_tgx_m2s_multidrop) return t_wb_regfb_tgx_m2s_multidrop is  
      variable v_retval    : vrec'subtype;

   begin      
      v_retval.base  := f_init(v_retval.base);
      v_retval.tga   := std_logic_vector(to_unsigned(0, v_retval.tga'length ));
      v_retval.tgc   := std_logic_vector(to_unsigned(0, v_retval.tgc'length ));
      v_retval.tgd   := std_logic_vector(to_unsigned(0, v_retval.tgd'length ));
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_s2m) return t_wb_s2m is     
      variable v_retval    : vrec'subtype;

   begin     
      v_retval.data    := std_logic_vector(to_unsigned(0, v_retval.data'length ));
      v_retval.ack     := '0';
      v_retval.err     := '0';
      v_retval.rty     := '0';
      v_retval.stall   := '0';
         
      return v_retval;
   end function;      
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_s2m_tx) return t_wb_s2m_tx is      
      variable v_retval    : vrec'subtype;
                                       
   begin      
      v_retval.base  := f_init(v_retval.base);
      v_retval.tgd   := std_logic_vector(to_unsigned(0, v_retval.tgd'length ));
     
      return v_retval;   
   end function;
   
End tspc_wbone_types;
