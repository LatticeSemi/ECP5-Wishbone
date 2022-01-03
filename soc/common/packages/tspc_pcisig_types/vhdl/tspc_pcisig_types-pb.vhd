
--
--    Copyright Ingenieurbuero Gardiner, 2007 - 2014
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
-- File ID     : $Id: tspc_pcisig_types-pb.vhd 5029 2020-02-23 00:03:15Z  $
-- Generated   : $LastChangedDate: 2020-02-23 01:03:15 +0100 (Sun, 23 Feb 2020) $
-- Revision    : $LastChangedRevision: 5029 $
--
--------------------------------------------------------------------------------
--
-- Description : Utility package for PCI(e) designs
--
--------------------------------------------------------------------------------
Library IEEE;
Use IEEE.numeric_std.all;
Use WORK.tspc_utils.all;

Package Body tspc_pcisig_types is

   function f_has_pload(vin : std_logic_vector) return boolean is
      variable v_cmd    : t_byte;
   begin
      v_cmd    := f_resize(vin, t_byte'length );
      
      return (v_cmd(v_cmd'left - c_brel_has_payload) = '1');
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_has_pload(vin : std_logic_vector) return std_logic is
   begin
      return f_to_logic(f_has_pload(vin));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_cplx(vin : std_logic_vector) return boolean is
      variable v_cmd    : t_byte;
   begin
      v_cmd    := f_resize(vin, t_byte'length );

      case v_cmd is
         when c_tlp_cpl | c_tlp_cpld | c_tlp_cpllk | c_tlp_cpldlk =>
            return true;

         when others => 
            return false;
      end case;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_cplx(vin : std_logic_vector) return std_logic is
   begin
      return f_to_logic(f_is_cplx(vin));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_hdr_4dw(vin : std_logic_vector) return boolean is
      variable v_cmd    : t_byte;
   begin
      v_cmd    := f_resize(vin, t_byte'length );
      
      return (v_cmd(v_cmd'left - c_brel_hdr_4dw) = '1');
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_hdr_4dw(vin : std_logic_vector) return std_logic is
   begin
      return f_to_logic(f_is_hdr_4dw(vin));
   end function;  

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_mem_wr(vin : std_logic_vector) return boolean is
      variable v_cmd    : t_byte;
   begin
      v_cmd    := f_resize(vin, t_byte'length );

      case v_cmd is
         when c_tlp_mwr32 | c_tlp_mwr64 =>
            return true;

         when others => 
            return false;
      end case;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_mem_wr(vin : std_logic_vector) return std_logic is
   begin
      return f_to_logic(f_is_mem_wr(vin));
   end function;  
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_np_req(vin : std_logic_vector) return boolean is
      variable v_cmd    : t_byte;
   begin
      v_cmd    := f_resize(vin, t_byte'length ) and X"F0";
      
      case v_cmd is
         when c_tlp_mwr32 | c_tlp_mwr64 | c_tlp_msg | c_tlp_msgd =>
            return false;

         when others => 
            return true;
      end case;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_np_req(vin : std_logic_vector) return std_logic is
      variable v_retval    : std_logic;
   begin
      return f_to_logic(f_is_np_req(vin));
   end function;      

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_set_hdr_byte_count(nin : natural) return std_logic_vector is
      variable v_retval    : t_pcie_hdr_byte_count;
   begin
      v_retval    := std_logic_vector(to_unsigned(nin, t_pcie_hdr_byte_count'length ));
      
      return v_retval;   
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_set_hdr_byte_count(vin : std_logic_vector) return std_logic_vector is
      variable v_retval    : t_pcie_hdr_byte_count;
   begin
      v_retval    := std_logic_vector(resize(unsigned(vin), t_pcie_hdr_byte_count'length ));
      
      return v_retval;   
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_set_hdr_length(nin : natural) return std_logic_vector is
      variable v_retval    : t_pcie_hdr_length;
   begin
      v_retval    := std_logic_vector(to_unsigned(nin, t_pcie_hdr_length'length ));
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_set_hdr_length(vin : std_logic_vector) return std_logic_vector is
      variable v_retval    : t_pcie_hdr_length;
   begin
      v_retval    := std_logic_vector(resize(unsigned(vin), t_pcie_hdr_length'length ));
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_bytecount(v_dwords : std_logic_vector; v_first : std_logic_vector; v_last : std_logic_vector) return std_logic_vector is
      variable v_be_first        : std_logic_vector(3 downto 0);
      variable v_be_last         : std_logic_vector(3 downto 0);
      variable v_byte_count      : std_logic_vector(12 downto 0);
      variable v_tlp_length      : std_logic_vector(9 downto 0);
      variable v_short_first     : std_logic_vector(1 downto 0);
      variable v_short_last      : std_logic_vector(1 downto 0);
   begin
      v_tlp_length   := f_resize(v_dwords, v_tlp_length'length );
      v_be_first     := f_resize(v_first, v_be_first'length );
      v_be_last      := f_resize(v_last, v_be_last'length );
      
      v_byte_count(v_byte_count'left - 1 downto 2) := v_tlp_length;
      v_byte_count(v_byte_count'left ) := not(or(v_tlp_length));
      v_byte_count(1 downto 0)         := (others => '0');

      case v_be_last is
         when "0100" | "0101" | "0110" | "0111" =>
            v_short_last   := std_logic_vector(to_unsigned(1, v_short_last'length ));

            case v_be_first is
               when "0010" | "0110" | "1010" | "1110" =>
                  v_short_first  := std_logic_vector(to_unsigned(1, v_short_first'length ));

               when "0100" | "1100" =>
                  v_short_first  := std_logic_vector(to_unsigned(2, v_short_first'length ));

               when "1000" =>
                  v_short_first  := std_logic_vector(to_unsigned(3, v_short_first'length ));

               when others =>
                  v_short_first  := (others => '0');
            end case;
                                 
         when "0010" | "0011" =>
            v_short_last   := std_logic_vector(to_unsigned(2, v_short_last'length ));

            case v_be_first is
               when "0010" | "0110" | "1010" | "1110" =>
                  v_short_first  := std_logic_vector(to_unsigned(1, v_short_first'length ));

               when "0100" | "1100" =>
                  v_short_first  := std_logic_vector(to_unsigned(2, v_short_first'length ));

               when "1000" =>
                  v_short_first  := std_logic_vector(to_unsigned(3, v_short_first'length ));

               when others =>
                  v_short_first  := (others => '0');
            end case;
                                 
         when "0001"  =>
            v_short_last   := std_logic_vector(to_unsigned(3, v_short_last'length ));

            case v_be_first is
               when "0010" | "0110" | "1010" | "1110" =>
                  v_short_first  := std_logic_vector(to_unsigned(1, v_short_first'length ));

               when "0100" | "1100" =>
                  v_short_first  := std_logic_vector(to_unsigned(2, v_short_first'length ));

               when "1000" =>
                  v_short_first  := std_logic_vector(to_unsigned(3, v_short_first'length ));
                  
               when others =>
                  v_short_first  := (others => '0');      
            end case;
                                 
         when "0000" =>
            v_short_last   := (others => '0');

            case v_be_first is
               when "0000" | "0001" | "0010" | "0100" | "1000" =>
                  v_short_first  := std_logic_vector(to_unsigned(3, v_short_first'length ));

               when "0011" | "0110" | "1100" =>
                  v_short_first  := std_logic_vector(to_unsigned(2, v_short_first'length ));

               when "0101" | "0111" | "1010" | "1110" =>
                  v_short_first  := std_logic_vector(to_unsigned(1, v_short_first'length ));

               when others =>
                  v_short_first  := (others => '0');                                                                                                                                    
            end case;
                              
         when others =>
            v_short_last   := (others => '0');

            case v_be_first is
               when "0010" | "0110" | "1010" | "1110" =>
                  v_short_first  := std_logic_vector(to_unsigned(1, v_short_first'length ));

               when "0100" | "1100" =>
                  v_short_first  := std_logic_vector(to_unsigned(2, v_short_first'length ));

               when "1000" =>
                  v_short_first  := std_logic_vector(to_unsigned(3, v_short_first'length ));

               when others =>
                  v_short_first  := (others => '0');
            end case;                  
      end case;      
      
      v_byte_count   := std_logic_vector(unsigned(v_byte_count) - unsigned(v_short_first) - unsigned(v_short_last));
      
      return v_byte_count;
   end function;
   
End tspc_pcisig_types;
