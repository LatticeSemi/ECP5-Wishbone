
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
-- File ID     : $Id: tspc_wbone_types-p.vhd 5094 2020-04-28 10:26:32Z  $
-- Generated   : $LastChangedDate: 2020-04-28 12:26:32 +0200 (Tue, 28 Apr 2020) $
-- Revision    : $LastChangedRevision: 5094 $
--
--------------------------------------------------------------------------------
--
-- Description : Wishbone Utility Package
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Package tspc_wbone_types is
   subtype t_wb_bte is std_logic_vector(1 downto 0);
   subtype t_wb_cti is std_logic_vector(2 downto 0);
   
   constant c_wb_bte_burst_linear      : t_wb_bte := "00";
   constant c_wb_bte_burst_wrap4       : t_wb_bte := "01";
   constant c_wb_bte_burst_wrap8       : t_wb_bte := "10";
   constant c_wb_bte_burst_wrap16      : t_wb_bte := "11";
   
   constant c_wb_cti_burst_const_addr  : t_wb_cti := "001";
   constant c_wb_cti_burst_incr        : t_wb_cti := "010";
   constant c_wb_cti_burst_end         : t_wb_cti := "111";
   constant c_wb_cti_classic           : t_wb_cti := "000";

      --------------------------------------------------------------------------------
      -- Wishbone Classic    
      --------------------------------------------------------------------------------
   type t_wb_classic_m2s is 
      record
         adr      : std_logic_vector;
         cyc      : std_logic;
         data     : std_logic_vector;
         lock     : std_logic;
         sel      : std_logic_vector;
         stb      : std_logic;
         we       : std_logic;
      end record;

   type t_wb_classic_tgx_m2s is 
      record
         base     : t_wb_classic_m2s;
         tga      : std_logic_vector;
         tgc      : std_logic_vector;
         tgd      : std_logic_vector;
      end record;
      
   type t_wb_classic_m2s_multidrop is 
      record
         adr      : std_logic_vector;
         cyc      : std_logic_vector;
         data     : std_logic_vector;
         lock     : std_logic;
         sel      : std_logic_vector;
         stb      : std_logic;
         we       : std_logic;
      end record;

   type t_wb_classic_tgx_m2s_multidrop is 
      record
         base     : t_wb_classic_m2s_multidrop;
         tga      : std_logic_vector;
         tgc      : std_logic_vector;
         tgd      : std_logic_vector;
      end record;
      
      --------------------------------------------------------------------------------
        -- Wishbone Registered-Feedback 
      --------------------------------------------------------------------------------
   type t_wb_regfb_m2s is 
      record
         adr      : std_logic_vector;
         bte      : t_wb_bte;
         cti      : t_wb_cti;
         cyc      : std_logic;
         data     : std_logic_vector;
         lock     : std_logic;
         sel      : std_logic_vector;
         stb      : std_logic;
         we       : std_logic;
      end record;

   type t_wb_regfb_tgx_m2s is 
      record
         base     : t_wb_regfb_m2s;
         tga      : std_logic_vector;
         tgc      : std_logic_vector;
         tgd      : std_logic_vector;
      end record;
      
   type t_wb_regfb_m2s_multidrop is 
      record
         adr      : std_logic_vector;
         bte      : t_wb_bte;
         cti      : t_wb_cti;
         cyc      : std_logic_vector;
         data     : std_logic_vector;
         lock     : std_logic;
         sel      : std_logic_vector;
         stb      : std_logic;
         we       : std_logic;
      end record;

   type t_wb_regfb_tgx_m2s_multidrop is 
      record
         base     : t_wb_regfb_m2s_multidrop;
         tga      : std_logic_vector;
         tgc      : std_logic_vector;
         tgd      : std_logic_vector;
      end record;
      
      --------------------------------------------------------------------------------
      -- Wishbone slave port
      --------------------------------------------------------------------------------
   type t_wb_s2m is
      record
         ack      : std_logic;
         data     : std_logic_vector;
         err      : std_logic;
         rty      : std_logic;
         stall    : std_logic;
      end record;

   type t_wb_s2m_tx is
      record
         base     : t_wb_s2m;
         tgd      : std_logic_vector;
      end record;
      
      --------------------------------------------------------------------------------
      -- Frequently used constrained subtypes
      --------------------------------------------------------------------------------         
   subtype t_wb_classic_m2s_a12d32  is t_wb_classic_m2s(adr(11 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_a16d32  is t_wb_classic_m2s(adr(15 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_a24d32  is t_wb_classic_m2s(adr(23 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_a32d32  is t_wb_classic_m2s(adr(31 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_a48d32  is t_wb_classic_m2s(adr(47 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_a64d32  is t_wb_classic_m2s(adr(63 downto 0), data(31 downto 0), sel(3 downto 0));

   subtype t_wb_regfb_m2s_a12d32    is t_wb_regfb_m2s(adr(11 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_a16d32    is t_wb_regfb_m2s(adr(15 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_a24d32    is t_wb_regfb_m2s(adr(23 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_a32d32    is t_wb_regfb_m2s(adr(31 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_a48d32    is t_wb_regfb_m2s(adr(47 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_a64d32    is t_wb_regfb_m2s(adr(63 downto 0), data(31 downto 0), sel(3 downto 0));

      -- Registered-Feedback/Tag extension for control-signals, e.g. 10 bit for xfer_length
   subtype t_wb_regfb_tgx_m2s_a12d32_ta1c10d1 is t_wb_regfb_tgx_m2s(base(adr(11 downto 0), data(31 downto 0), sel(3 downto 0)),
                                                                    tga(0 downto 0), tgc(9 downto 0), tgd(0 downto 0));
   subtype t_wb_regfb_tgx_m2s_a32d32_ta1c10d1 is t_wb_regfb_tgx_m2s(base(adr(31 downto 0), data(31 downto 0), sel(3 downto 0)),
                                                                    tga(0 downto 0), tgc(9 downto 0), tgd(0 downto 0));                                                               
   subtype t_wb_regfb_tgx_m2s_a48d32_ta1c10d1 is t_wb_regfb_tgx_m2s(base(adr(47 downto 0), data(31 downto 0), sel(3 downto 0)),
                                                                    tga(0 downto 0), tgc(9 downto 0), tgd(0 downto 0));
                                                               
      -- Classic multi-drop to max. eight slaves
   subtype t_wb_classic_m2s_star_a12d32s8    is t_wb_classic_m2s_multidrop(adr(11 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_star_a16d32s8	   is t_wb_classic_m2s_multidrop(adr(15 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_star_a24d32s8    is t_wb_classic_m2s_multidrop(adr(23 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_star_a32d32s8    is t_wb_classic_m2s_multidrop(adr(31 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_star_a48d32s8    is t_wb_classic_m2s_multidrop(adr(47 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_classic_m2s_star_a64d32s8    is t_wb_classic_m2s_multidrop(adr(63 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));

      -- Registered-Feedback multi-drop to max. eight slaves
   subtype t_wb_regfb_m2s_star_a12d32s8   is t_wb_regfb_m2s_multidrop(adr(11 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_star_a16d32s8   is t_wb_regfb_m2s_multidrop(adr(15 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_star_a24d32s8   is t_wb_regfb_m2s_multidrop(adr(23 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_star_a32d32s8   is t_wb_regfb_m2s_multidrop(adr(31 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_star_a48d32s8   is t_wb_regfb_m2s_multidrop(adr(47 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));
   subtype t_wb_regfb_m2s_star_a64d32s8	is t_wb_regfb_m2s_multidrop(adr(63 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0));

      -- Registered-Feedback/Tag extension w/ multi-drop for control-signals, e.g. 10 bit for xfer_length
   subtype t_wb_regfb_m2s_star_a12d32s8_ta1c10d1 is t_wb_regfb_tgx_m2s_multidrop(
                                                            base(adr(11 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0)),
                                                            tga(0 downto 0), tgc(9 downto 0), tgd(0 downto 0));
   subtype t_wb_regfb_m2_stars_a32d32s8_ta1c10d1 is t_wb_regfb_tgx_m2s_multidrop(
                                                            base(adr(31 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0)),
                                                            tga(0 downto 0), tgc(9 downto 0), tgd(0 downto 0));                                                               
   subtype t_wb_regfb_m2s_star_a48d32s8_ta1c10d1 is t_wb_regfb_tgx_m2s_multidrop(
                                                            base(adr(47 downto 0), cyc(7 downto 0), data(31 downto 0), sel(3 downto 0)),
                                                            tga(0 downto 0), tgc(9 downto 0), tgd(0 downto 0));
                                                               
   subtype t_wb_s2m_d32                is t_wb_s2m(data(31 downto 0));

      -- =============================================================================
      --    Functions
      -- =============================================================================
   function f_init(vrec : t_wb_classic_m2s) return t_wb_classic_m2s;
   
   function f_init(vrec : t_wb_classic_m2s_multidrop) return t_wb_classic_m2s_multidrop;   
   
   function f_init(vrec : t_wb_classic_tgx_m2s) return t_wb_classic_tgx_m2s;

   function f_init(vrec : t_wb_classic_tgx_m2s_multidrop) return t_wb_classic_tgx_m2s_multidrop;   

   function f_init(vrec : t_wb_regfb_m2s) return t_wb_regfb_m2s;
   
   function f_init(vrec : t_wb_regfb_m2s_multidrop) return t_wb_regfb_m2s_multidrop;      
   
   function f_init(vrec : t_wb_regfb_tgx_m2s) return t_wb_regfb_tgx_m2s;

   function f_init(vrec : t_wb_regfb_tgx_m2s_multidrop) return t_wb_regfb_tgx_m2s_multidrop;      

   function f_init(vrec : t_wb_s2m) return t_wb_s2m;      

   function f_init(vrec : t_wb_s2m_tx) return t_wb_s2m_tx;        
End tspc_wbone_types;
