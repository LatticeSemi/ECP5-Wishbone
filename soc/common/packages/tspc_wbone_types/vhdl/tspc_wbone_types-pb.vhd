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
-- File ID     : $Id: tspc_wbone_types-pb.vhd 5092 2020-04-28 10:19:06Z  $
-- Generated   : $LastChangedDate: 2020-04-28 12:19:06 +0200 (Tue, 28 Apr 2020) $
-- Revision    : $LastChangedRevision: 5092 $
--
--------------------------------------------------------------------------------
--
-- Description : Wishbone Utility Package
--
--------------------------------------------------------------------------------

Package Body tspc_wbone_types is
   function f_init(vrec : t_wb_classic_m2s) return t_wb_classic_m2s is   
      constant c_retval    : vrec'subtype := (adr     => (others =>'0'),
                                              cyc     => '0',
                                              data    => (others => '0'),
                                              lock    => '0',
                                              sel     => (others => '0'),
                                              stb     => '0',
                                              we      => '0');
   begin      
      return c_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_classic_m2s_multidrop) return t_wb_classic_m2s_multidrop is                                                        
      constant c_retval    : vrec'subtype := (adr  => (others =>'0'),
                                              cyc  => (others => '0'),
                                              data => (others => '0'),
                                              lock => '0',
                                              sel  => (others => '0'),
                                              stb  => '0',
                                              we   => '0');
   begin
      return c_retval;
   end function;   

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_classic_tgx_m2s) return t_wb_classic_tgx_m2s is                                                       
      constant c_retval    : vrec'subtype := (base    => f_init(vrec.base),
                                              tga     => (others => '0'),
                                              tgc     => (others => '0'),
                                              tgd     => (others => '0'));
   begin      
      return c_retval;
   end function;   
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_classic_tgx_m2s_multidrop) return t_wb_classic_tgx_m2s_multidrop is 
      constant c_retval    : vrec'subtype := (base    => f_init(vrec.base),
                                              tga     => (others => '0'),
                                              tgc     => (others => '0'),
                                              tgd     => (others => '0'));   
   begin      
      return c_retval;
   end function;      
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_m2s) return t_wb_regfb_m2s is                                                       
      constant c_retval    : vrec'subtype := (adr     => (others =>'0'),
                                              bte     => (others => '0'),
                                              cti     => (others => '0'),
                                              cyc     => '0',
                                              data    => (others => '0'),
                                              lock    => '0',
                                              sel     => (others => '0'),
                                              stb     => '0',
                                              we      => '0');
   begin
      return c_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_m2s_multidrop) return t_wb_regfb_m2s_multidrop is                                                       
      constant c_retval    : vrec'subtype := (adr  => (others =>'0'),
                                              bte  => (others => '0'),
                                              cti  => (others => '0'),      
                                              cyc  => (others => '0'),
                                              data => (others => '0'),
                                              lock => '0',
                                              sel  => (others => '0'),
                                              stb  => '0',
                                              we   => '0');
   begin      
      return c_retval;
   end function;      
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_tgx_m2s) return t_wb_regfb_tgx_m2s is                                                       
      constant c_retval    : vrec'subtype := (base    => f_init(vrec.base),
                                              tga     => (others => '0'),
                                              tgc     => (others => '0'),
                                              tgd     => (others => '0'));   
   begin           
      return c_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_regfb_tgx_m2s_multidrop) return t_wb_regfb_tgx_m2s_multidrop is  
      constant c_retval    : vrec'subtype := (base    => f_init(vrec.base),
                                              tga     => (others => '0'),
                                              tgc     => (others => '0'),
                                              tgd     => (others => '0'));   
   begin      
      return c_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_s2m) return t_wb_s2m is     
      constant c_retval    : vrec'subtype := (data    => (others => '0'),
                                              others  => '0');   
   begin      
      return c_retval;
   end function;      
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_init(vrec : t_wb_s2m_tx) return t_wb_s2m_tx is      
      constant c_retval    : vrec'subtype := (base    => f_init(vrec.base),
                                              tgd     => (others => '0'));                                         
   begin      
      return c_retval;   
   end function;
   
End tspc_wbone_types;
