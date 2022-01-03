
--    
--    Copyright Ingenieurbuero Gardiner, 2007 - 2020
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--     
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_utils-pb.vhd 5283 2021-03-04 01:16:54Z  $
-- Generated   : $LastChangedDate: 2021-03-04 02:16:54 +0100 (Thu, 04 Mar 2021) $
-- Revision    : $LastChangedRevision: 5283 $
--
--------------------------------------------------------------------------------
--
-- Description : General synthesisable utilities
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.math_real.ceil;
Use IEEE.math_real.log2;
Use IEEE.math_real.realmin;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

Package Body tspc_utils is  
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_add(vec : std_logic_vector; vincr : natural) return std_logic_vector is
   begin
      return std_logic_vector(unsigned(vec) + vincr);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_add(vec : std_logic_vector; vincr : std_logic_vector) return std_logic_vector  is
   begin
      return std_logic_vector(unsigned(vec) + unsigned(vincr));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_align_adr(slv : std_logic_vector; nsym : positive) return std_logic_vector is
      constant c_adr_lsb   : natural := f_vec_size(nsym) - 1;
      
      variable v_retval : std_logic_vector(slv'length - 1  downto 0);
      variable v_slv    : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_retval    := (others => '0');
      v_slv       := slv;
      
      if (nsym = 1) then
         v_retval    := slv;
      else
         if (slv'length >= c_adr_lsb) then
            v_retval(v_slv'left downto c_adr_lsb)  := v_slv(v_slv'left downto c_adr_lsb);
         end if;
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_align_msb(slv : std_logic_vector; dsz : natural) return std_logic_vector is
      variable v_retval : std_logic_vector(dsz - 1 downto 0);
      variable v_slv    : std_logic_vector(slv'length - 1 downto 0);
   begin
      if (slv'length = dsz) then
         return slv;
      else
         if (slv'length < dsz) then
            v_retval := (others => '0');
            v_retval(v_retval'left downto (dsz - slv'length ))   := slv;
         else
            v_slv    := slv;
            v_retval := v_slv(v_slv'left downto v_slv'length - dsz);
         end if;
         return v_retval;
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_be_to_adr(slv : std_logic_vector) return std_logic_vector is
      constant c_retval_sz    : positive := f_num_bits(slv'length -1);
      variable v_pos          : integer;
      variable v_slv          : std_logic_vector(slv'length - 1 downto 0);
      variable v_retval       : std_logic_vector(f_num_bits(slv'length - 1) - 1 downto 0);
   begin
      v_slv    := slv;
      
      v_pos := find_rightmost(unsigned(v_slv), '1');
      
      if (v_pos < 0) then
         v_retval    := (others => '0');
      else
         v_retval    :=  std_logic_vector(to_unsigned(v_pos, c_retval_sz));
      end if;
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_be_to_bcd(slv : std_logic_vector) return std_logic_vector is
      variable v_retval    : std_logic_vector(f_num_bits(slv'length ) - 1 downto 0);
   begin
      v_retval    := std_logic_vector(to_unsigned(f_be_to_int(slv), v_retval'length ));
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_be_to_int(slv : std_logic_vector) return natural is
      variable v_slv    : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_slv    := slv;
      
      if (or(v_slv) = '0') then
         return 0;
      else
         return find_leftmost(unsigned(v_slv), '1') - find_rightmost(unsigned(v_slv), '1') + 1;
      end if;      
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_concat(slva : t_byte_array; vle : boolean := true) return std_logic_vector is
      variable v_retval    : std_logic_vector((slva'length * t_byte'length ) - 1 downto 0);
      variable v_slva      : t_byte_array(slva'length - 1 downto 0); 
      
   begin
      v_retval    := (others => '0');
      v_slva      := slva;
      
      if (vle) then
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_retval(v_retval'left - t_byte'length downto 0) & v_slva(ix);
         end loop;
      else
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_slva(ix) & v_retval(v_retval'left downto t_byte'length);
        end loop;      
      end if;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_concat(slva : t_dword_array; vle : boolean := true) return std_logic_vector is
      variable v_retval    : std_logic_vector((slva'length * t_dword'length ) - 1 downto 0);
      variable v_slva      : t_dword_array(slva'length - 1 downto 0); 

   begin
      v_retval    := (others => '0');
      v_slva      := slva;
     
      if (vle) then
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_retval(v_retval'left - t_dword'length downto 0) & v_slva(ix);
         end loop;
      else
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_slva(ix) & v_retval(v_retval'left downto t_dword'length);
         end loop;      
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  function f_concat(slva : t_hword_array; vle : boolean := true) return std_logic_vector is
      variable v_retval    : std_logic_vector((slva'length * t_hword'length ) - 1 downto 0);
      variable v_slva      : t_hword_array(slva'length - 1 downto 0); 

   begin
      v_retval    := (others => '0');
      v_slva      := slva;
      
      if (vle) then
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_retval(v_retval'left - t_hword'length downto 0) & v_slva(ix);
         end loop;
      else
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_slva(ix) & v_retval(v_retval'left downto t_hword'length);
         end loop;      
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_concat(slva : t_qword_array; vle : boolean := true) return std_logic_vector is
      variable v_retval    : std_logic_vector((slva'length * t_qword'length ) - 1 downto 0);
      variable v_slva      : t_qword_array(slva'length - 1 downto 0); 

   begin
      v_retval    := (others => '0');
      v_slva      := slva;
      
      if (vle) then
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_retval(v_retval'left - t_qword'length downto 0) & v_slva(ix);
         end loop;
      else
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_slva(ix) & v_retval(v_retval'left downto t_qword'length);
         end loop;      
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_concat(slva : t_slv_array; vle : boolean := true) return std_logic_vector is
      subtype t_lt_slv_elem   is std_logic_vector(slva(slva'low )'length - 1 downto 0);
      subtype t_lt_slv_array  is t_slv_array(slva'length - 1 downto 0)(t_lt_slv_elem'length - 1 downto 0);
      
      variable v_slva      : t_lt_slv_array;
      variable v_retval    : std_logic_vector((t_lt_slv_elem'length * t_lt_slv_array'length) - 1 downto 0);
   begin
      v_retval    := (others => '0');
      v_slva      := slva;
      
      if (vle) then
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_retval(v_retval'left - t_lt_slv_elem'length downto 0) & v_slva(ix);
         end loop;
      else
         for ix in 0 to v_slva'length - 1 loop
            v_retval := v_slva(ix) & v_retval(v_retval'left downto t_lt_slv_elem'length);
         end loop;      
      end if;
      
      return v_retval;      
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_cp_resize(vec : std_logic_vector; sz : natural) return std_logic_vector is
      -- now just an alias for f_typecast which is the preferred call. 
      -- Retained for backward version compatibility
      -- Also consider resize() from ieee.numeric_std
   begin
      return f_typecast(vec, sz);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_decr(slv : std_logic_vector; no_wrap : boolean := false) return std_logic_vector is
   begin
      if (no_wrap) then
         if (unsigned(slv) = 0) then
            return slv;
         else
            return std_logic_vector(unsigned(slv) - 1);
         end if;
      else
         return std_logic_vector(unsigned(slv) - 1);
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_decr(slv : std_logic_vector; vsval : natural) return std_logic_vector is
   begin
      if (unsigned(slv) = 0) then
         return f_typecast(vsval, slv'length );
      else
         return std_logic_vector(unsigned(slv) - 1);
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_det_ev(dt : t_edge_det) return boolean is
   begin
      return f_to_boolean(dt(1) xor dt(0));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_det_ev(dt : t_edge_det) return std_logic is
   begin
      return dt(1) xor dt(0);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_det_fall(dt : t_edge_det) return boolean is
   begin
      return f_to_boolean(dt(1) and not dt(0));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_det_fall(dt : t_edge_det) return std_logic is
   begin
      return dt(1) and not dt(0);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_det_rise(dt : t_edge_det) return boolean is
   begin
      return f_to_boolean(dt(0) and not dt(1));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_det_rise(dt : t_edge_det) return std_logic is
   begin
      return dt(0) and not dt(1);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_edge_any(sy : t_edge_sync) return boolean is
   begin
      return f_to_boolean(sy(2) xor sy(1));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_edge_any(sy : t_edge_sync) return std_logic is
   begin
      return sy(2) xor sy(1);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_edge_fall(sy : t_edge_sync) return boolean is
   begin
      return f_to_boolean(sy(2) and not sy(1));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_edge_fall(sy : t_edge_sync) return std_logic is
   begin
      return sy(2) and not sy(1);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_edge_rise(sy : t_edge_sync) return boolean is
   begin
      return f_to_boolean(sy(1) and not sy(2));
   end function;  
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_edge_rise(sy : t_edge_sync) return std_logic is
   begin
      return sy(1) and not sy(2);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_extract(lw : std_logic_vector; sel : natural; osz : positive) return std_logic_vector is   
      subtype t_sel  is natural range 0 to (lw'length / minimum(osz, lw'length )) - 1;
      
      variable v_din       : std_logic_vector(lw'length - 1 downto 0);
      variable v_osz       : natural;   
      variable v_retval    : std_logic_vector(osz - 1 downto 0);
      variable v_sel       : t_sel;   
   begin
      v_din    := lw;
      v_osz    := minimum(osz, lw'length );
      v_sel    := minimum(sel, t_sel'high );
      
      v_retval := v_din((v_sel * v_osz) + v_osz - 1 downto v_sel * v_osz);
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_extract(lw : std_logic_vector; sel : std_logic_vector; osz : positive) return std_logic_vector is
   begin
      return f_extract(lw, to_integer(unsigned(sel)), osz);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_fill_lsb(slv : std_logic_vector; flp : natural := 0) return std_logic_vector is
      subtype t_fill    is integer range 0 to slv'length - 1;
      
      variable v_fill   : t_fill;
      variable v_retval : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_fill   := minimum(flp, t_fill'high );

      v_retval := (others => '0');
      v_retval(v_fill downto 0)  := (others => '1');
   
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_fill_lsb(slv : std_logic_vector; flp : std_logic_vector) return std_logic_vector is
   begin
      return f_fill_lsb(slv, to_integer(unsigned(flp)));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_fill_msb(slv : std_logic_vector; flp : natural := 0) return std_logic_vector is
      subtype t_fill    is integer range 0 to slv'length - 1;
      
      variable v_fill   : t_fill;
      variable v_retval : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_fill   := minimum(flp, t_fill'high );

      v_retval := (others => '0');
      v_retval(v_retval'left downto v_retval'left - v_fill)  := (others => '1');
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_fill_msb(slv : std_logic_vector; flp : std_logic_vector) return std_logic_vector is
   begin
      return f_fill_msb(slv, to_integer(unsigned(flp)));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_find_leftmost(slv : std_logic_vector; val : std_logic) return integer is
      variable v_retval : integer; 
      variable v_slv    : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_retval := 0;
      v_slv    := slv;
      
      for ix in v_slv'length - 1 downto 0 loop
         if (v_slv(ix) = val) then
            v_retval := ix;
            exit;
         end if;
      end loop;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_find_leftmost(slv : std_logic_vector; val : std_logic; sz : positive) return std_logic_vector is
   begin
      return std_logic_vector(to_unsigned(f_find_leftmost(slv, val), sz));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_find_rightmost(slv : std_logic_vector; val : std_logic) return integer is
      variable v_retval : integer; 
      variable v_slv    : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_retval := 0;
      v_slv    := slv;
      
      for ix in 0 to v_slv'length - 1 loop
         if (v_slv(ix) = val) then
            v_retval := ix;
            exit;
         end if;
      end loop;
      
      return v_retval;   
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_find_rightmost(slv : std_logic_vector; val : std_logic; sz : positive) return std_logic_vector is
   begin
      return std_logic_vector(to_unsigned(f_find_rightmost(slv, val), sz));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_get_svn_tag(i_vn : string; i_len : positive) return std_logic_vector is
      constant c_vnr    : string (1 to i_vn'length ) := i_vn;
      
      variable v_iter   : natural := 1;
      variable v_pos    : natural := i_vn'length;
      variable v_vn     : natural := 0;
   begin
      while (v_pos > 0) loop
         if ((character'pos(c_vnr(v_pos)) < character'pos(':')) and (character'pos(c_vnr(v_pos)) > character'pos('/'))) then
            exit;
         end if;
         
         v_pos := v_pos - 1;
      end loop;
      
      if (v_pos > 0) then
         while ((character'pos(c_vnr(v_pos)) < character' pos(':')) and (character'pos(c_vnr(v_pos)) > character'pos('/'))) loop
            if (v_pos = 0) then
               exit;
            end if;
            
            v_vn  := v_vn + ((character'pos(c_vnr(v_pos)) - character'pos('0')) * v_iter);
            v_iter   := v_iter * 10;
            v_pos    := v_pos - 1;
         end loop;
      end if;
      
      return std_logic_vector(to_unsigned(v_vn, i_len));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_incr(slv : std_logic_vector; no_wrap : boolean := false) return std_logic_vector is
   begin
      if (no_wrap) then
         if (unsigned(not slv) = 0) then
            return slv;
         else
            return std_logic_vector(unsigned(slv) + 1);
         end if;
      else
         return std_logic_vector(unsigned(slv) + 1);
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_incr(slv : std_logic_vector; vmax : natural) return std_logic_vector is
   begin
      if (unsigned(slv) = vmax) then
         return f_typecast(0, slv'length );
      else
         return std_logic_vector(unsigned(slv) + 1);
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_insert(dst : std_logic_vector; src : std_logic_vector; sel : natural) return std_logic_vector is
      subtype t_sel  is natural range 0 to (dst'length / minimum(src'length, dst'length )) - 1;
      
      variable v_din       : std_logic_vector(dst'length - 1 downto 0);
      variable v_ins       : std_logic_vector(minimum(dst'length, src'length ) - 1 downto 0);
      variable v_osz       : natural;   
      variable v_retval    : std_logic_vector(dst'length - 1 downto 0);
      variable v_sel       : t_sel;     
   begin
      v_ins    := f_resize(src, v_ins'length );
      v_retval := dst;
      v_sel    := minimum(sel, t_sel'high );
      
      v_retval((v_sel * v_ins'length ) + v_ins'length - 1 downto v_sel * v_ins'length )   := v_ins;
      
      return v_retval;
   
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_insert(dst : std_logic_vector; src : std_logic_vector; sel : std_logic_vector) return std_logic_vector is
   begin
      return f_insert(dst, src, to_integer(unsigned(sel)));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_zero(vec : std_logic_vector) return boolean is
   begin
      return (unsigned(vec) = 0);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_is_zero(vec : std_logic_vector) return std_logic is
   begin
      return f_to_logic(f_is_zero(vec));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_maj_2of3(slv : std_logic_vector) return std_logic is
      variable v_slv_in    : std_logic_vector(2 downto 0);
   begin
      v_slv_in := std_logic_vector(resize(unsigned(slv), v_slv_in'length));
      
      case v_slv_in is
         when "111" | "011" | "101" | "110" =>
            return '1';
            
         when others =>
            return '0';
      end case; 
   end;  

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_maj_3of5(slv : std_logic_vector) return std_logic is
      variable v_slv_in    : std_logic_vector(4 downto 0);
   begin
      v_slv_in := std_logic_vector(resize(unsigned(slv), v_slv_in'length));
      
      case v_slv_in is
         when "11111" | "01111" | "10111" | "11011" | "11101" | "11110" |
              "00111" | "01011" | "01101" | "01110" | 
              "10011" | "10101" | "10110" | 
              "11001" | "11010" | "11100" => 
            return '1';
            
         when others =>
            return '0';
      end case;
   end;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_merge(rv     : std_logic_vector; 
                    di     : std_logic_vector;
                    be     : std_logic_vector;
                    symsz  : positive := 8) return std_logic_vector is
                    
      variable v_be_val    : std_logic_vector(be'length - 1 downto 0); 
      variable v_din_val   : std_logic_vector(di'length - 1 downto 0);
      variable v_lsb       : natural;
      variable v_msb       : natural;
      variable v_slv_cur   : std_logic_vector((be'length * symsz) - 1 downto 0);
      variable v_slv_new   : std_logic_vector((be'length * symsz) - 1 downto 0);
      
   begin
      v_be_val    := be;
      v_din_val   := std_logic_vector(resize(unsigned(di), v_din_val'length));
      v_slv_cur   := std_logic_vector(resize(unsigned(rv), v_slv_cur'length));
      
      for ix in 0 to v_slv_new'length - 1 loop
         v_slv_new(ix)  := (v_din_val(ix mod v_din_val'length) and v_be_val(ix / symsz)) or
                           (v_slv_cur(ix) and not v_be_val(ix / symsz));
      end loop;
      
      return std_logic_vector(resize(unsigned(v_slv_new), rv'length));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_mirror(bvl : std_logic_vector) return std_logic_vector is
   
      variable v_retval : std_logic_vector(bvl'length - 1 downto 0);
      variable v_vin    : std_logic_vector(bvl'length - 1 downto 0);
   begin
      v_vin    := bvl;
      
      for ix in v_vin'range loop
         v_retval(v_retval'left - ix)  := v_vin(ix);
      end loop;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_num_bits(p1 : natural) return positive is
      variable v_p1     : real;
   begin
      v_p1  := realmin(real(integer'high ), real(p1) + 1.0);
      
      return maximum(1, natural(ceil(log2(v_p1))));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_poll(vec : std_logic_vector; scl : std_logic) return std_logic_vector is
   begin
      return f_shin_lsb(vec, scl);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_reg_load(vnat : natural; sz : natural) return std_logic_vector is
   begin
      return f_typecast(vnat, sz);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_reg_load(vec : std_logic_vector; sz : natural) return std_logic_vector is
   begin
      return f_typecast(vec, sz);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_reg_read(slv : std_logic_vector; sz : natural) return std_logic_vector is
         -- This function is just an alias but makes register block code more uniform
   begin
      return f_typecast(slv, sz);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_reg_write(rv    : std_logic_vector; 
                        di    : std_logic_vector;
                        be    : std_logic_vector;
                        symsz : positive := 8) return std_logic_vector is
   begin
      return std_logic_vector(resize(unsigned(f_merge(rv, di, be, symsz)), rv'length ));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_reg_write(rv    : std_logic_vector; 
                        di    : std_logic_vector;
                        be    : std_logic_vector;
                        mask  : std_logic_vector;
                        symsz : positive := 8) return std_logic_vector is
                        
      variable v_din    : std_logic_vector((be'length * symsz) - 1 downto 0);
      variable v_mask   : std_logic_vector((be'length * symsz) - 1 downto 0);
      variable v_rv     : std_logic_vector((be'length * symsz) - 1 downto 0);
   begin
      v_din    := std_logic_vector(resize(unsigned(di),   v_din'length));
      v_mask   := std_logic_vector(resize(unsigned(mask), v_mask'length));
      v_rv     := std_logic_vector(resize(unsigned(rv), v_rv'length));
      
      for ix in v_rv'length - 1 downto 0 loop
         if (v_mask(ix) = '0') then
            v_din(ix)   := rv(ix);
         end if;
      end loop;
      
      return std_logic_vector(resize(unsigned(f_merge(v_rv, v_din, be, symsz)), rv'length ));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_replicate(bvl : std_logic; sz : natural) return std_logic_vector is
      subtype t_retval  is std_logic_vector(sz downto 0);
      
      variable v_retval    : t_retval;
   begin
      v_retval := (others => bvl);
      
      if (sz = 0) then
         v_retval    := not v_retval;
         return v_retval;
      else
         return v_retval(v_retval'left - 1 downto 0);
      end if;      
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_replicate(svec : std_logic_vector; mult : natural) return std_logic_vector is
      subtype t_retval  is std_logic_vector(mult * svec'length downto 0);
   
      variable v_vin    : std_logic_vector(svec'length - 1 downto 0);
      variable v_retval : t_retval;
      
   begin
      v_vin    := svec;
      
      for ix in v_retval'range loop
         v_retval(ix)   := v_vin(ix mod svec'length );
      end loop;
      
      if (mult = 0) then
         v_retval    := not v_retval;
         return v_retval;
      else
         return v_retval(v_retval'left - 1 downto 0);
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_resize(vec : std_logic_vector; sz : natural) return std_logic_vector is
      -- Deprecated : Use f_typecast or resize() from ieee.numeric_std library instead
   begin
      return f_typecast(vec, sz);   
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_resize_se(vec : std_logic_vector; sz : natural) return std_logic_vector is
      variable v_retval    : std_logic_vector(sz - 1 downto 0);
      variable v_vec       : std_logic_vector(vec'length - 1 downto 0);
   begin
      v_vec := vec;
      
      if (sz > vec'length ) then
         v_retval    := f_replicate(v_vec(v_vec'left ), sz - vec'length ) & v_vec;
      else
         v_retval    := v_vec(v_vec'left ) & v_vec(v_retval'left - 1 downto 0);
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_rol(slv : std_logic_vector; shft : natural := 1) return std_logic_vector is
   begin
      return std_logic_vector(rotate_left(unsigned(slv), shft));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_rol(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector is
   begin
      return std_logic_vector(rotate_left(unsigned(slv), to_integer(unsigned(shft))));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_ror(slv : std_logic_vector; shft : natural := 1) return std_logic_vector is
   begin
      return std_logic_vector(rotate_right(unsigned(slv), shft));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_ror(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector is
   begin
      return std_logic_vector(rotate_right(unsigned(slv), to_integer(unsigned(shft))));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sel_tf(vsel : boolean; vtrue : integer; vfalse : integer) return integer is
   begin
      if (vsel) then
         return vtrue;
      else
         return vfalse;
      end if;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sel_tf(vsel : boolean; vtrue : std_logic; vfalse : std_logic) return std_logic is
   begin
      if (vsel) then
         return vtrue;
      else
         return vfalse;
      end if;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sel_tf(vsel : boolean; vtrue : std_logic_vector; vfalse : std_logic_vector) return std_logic_vector is
      constant c_ret_sz    : positive := maximum(vtrue'length, vfalse'length );
      
   begin
      if (vsel) then
         return std_logic_vector(resize(unsigned(vtrue), c_ret_sz));
      else
         return std_logic_vector(resize(unsigned(vfalse), c_ret_sz));
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sel_tf(vsel : std_logic; vtrue : integer; vfalse : integer) return integer is
   begin
      if (vsel = '1') then
         return vtrue;
      else
         return vfalse;
      end if;   
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sel_tf(vsel : std_logic; vtrue : std_logic; vfalse : std_logic) return std_logic is
   begin
      if (vsel = '1') then
         return vtrue;
      else
         return vfalse;
      end if;
   end function;
  
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sel_tf(vsel : std_logic; vtrue : std_logic_vector; vfalse : std_logic_vector) return std_logic_vector is
      constant c_ret_sz    : positive := maximum(vtrue'length, vfalse'length );
      
   begin
      if (vsel = '1') then
         return std_logic_vector(resize(unsigned(vtrue), c_ret_sz));
      else
         return std_logic_vector(resize(unsigned(vfalse), c_ret_sz));
      end if;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shin_lsb(slv : std_logic_vector; sin : std_logic) return std_logic_vector is
      variable v_slv_in    : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_slv_in := slv;
      
      return v_slv_in(v_slv_in'left - 1 downto 0) & sin;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shin_lsb(slv : std_logic_vector; sin : std_logic_vector) return std_logic_vector is
      variable v_slv_in    : std_logic_vector(slv'length + sin'length - 1 downto 0);
   begin
      v_slv_in := slv & sin;
      
      return v_slv_in(slv'length - 1 downto 0);
   end function; 
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shin_msb(slv : std_logic_vector; sin : std_logic) return std_logic_vector is
      variable v_slv_in    : std_logic_vector(slv'length - 1 downto 0);
   begin
      v_slv_in := slv;
      
      return sin & v_slv_in(v_slv_in'left downto 1);
   end function; 

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shin_msb(slv : std_logic_vector; sin : std_logic_vector) return std_logic_vector is
      variable v_slv_in    : std_logic_vector(slv'length + sin'length - 1 downto 0);
   begin
      v_slv_in := sin & slv;
      
      return v_slv_in(v_slv_in'high downto sin'length);
   end function; 
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shl(slv : std_logic_vector; shft : natural := 1) return std_logic_vector is
   begin
      return std_logic_vector(shift_left(unsigned(slv), shft));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shl(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector is
   begin
      return std_logic_vector(shift_left(unsigned(slv), to_integer(unsigned(shft))));
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shl_xv(slv : std_logic_vector; shft : natural := 1; lv : std_logic := '1') return std_logic_vector is
      subtype t_retval  is std_logic_vector(slv'length - 1 downto 0);
      subtype t_shft    is integer range 0 to slv'length;
      
      variable v_retval : t_retval;
      variable v_shft   : t_shft;
   begin
      v_retval := slv;
      v_shft   := minimum(shft, t_shft'high );
      
      if (v_shft > 0) then 
         v_retval(v_shft - 1 downto 0) := (others => lv);
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shl_xv(slv : std_logic_vector; shft : std_logic_vector; lv : std_logic := '1') return std_logic_vector is
   begin
      return f_shl_xv(slv, to_integer(unsigned(shft)), lv);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shr(slv : std_logic_vector; shft : natural := 1) return std_logic_vector is
   begin
      return std_logic_vector(shift_right(unsigned(slv), shft));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shr(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector is
   begin
      return std_logic_vector(shift_right(unsigned(slv), to_integer(unsigned(shft))));
   end function;  

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shr_xv(slv : std_logic_vector; shft : natural := 1; lv : std_logic := '1') return std_logic_vector is
      subtype t_retval  is std_logic_vector(slv'length - 1 downto 0);
      subtype t_shft    is integer range 0 to slv'length;
      
      variable v_retval : t_retval;
      variable v_shft   : t_shft;
   begin
      v_retval := slv;
      v_shft   := minimum(shft, t_shft'high );
      
      if (v_shft > 0) then 
         v_retval(v_retval'left downto v_retval'left - v_shft + 1) := (others => lv);
      end if;
      
      return v_retval;   
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_shr_xv(slv : std_logic_vector; shft : std_logic_vector; lv : std_logic := '1') return std_logic_vector is
   begin
      return f_shr_xv(slv, to_integer(unsigned(shft)), lv);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sub(vnat : natural; vdecr : std_logic_vector) return std_logic_vector is
      variable v_minuend   : std_logic_vector(f_num_bits(vnat) - 1 downto 0);
   begin
      v_minuend   := std_logic_vector(to_unsigned(vnat, v_minuend'length ));
      
      return f_sub(v_minuend, vdecr);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sub(vec : std_logic_vector; vdecr : natural) return std_logic_vector is
   begin
      return std_logic_vector(unsigned(vec) - vdecr);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sub(vec : std_logic_vector; vdecr : std_logic_vector) return std_logic_vector  is
   begin
      return std_logic_vector(unsigned(vec) - unsigned(vdecr));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_swap_endian(slv : std_logic_vector; usz : positive := t_byte'length ) return std_logic_vector is
      constant c_nchars : positive := slv'length / usz;
      
      variable v_din       : std_logic_vector(slv'length - 1 downto 0);
      variable v_dout      : std_logic_vector(slv'length - 1 downto 0);
      variable v_lsb_in    : natural;
      variable v_lsb_out   : natural;
   begin
      v_din    := slv;
      v_dout   := (others => '0');
      
      for ix in 0 to c_nchars - 1 loop
         v_lsb_in    := ix * usz;
         v_lsb_out   := ((c_nchars - 1) - ix) * usz;
         v_dout(v_lsb_out + usz - 1 downto v_lsb_out) := v_din(v_lsb_in + usz - 1 downto v_lsb_in);
      end loop;
      
      return v_dout;
   end function; 
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sync_edge(sy : t_edge_sync; sig : std_logic) return t_edge_sync is
      variable v_sy  : t_edge_sync;
   begin
      v_sy  := sy;
      return v_sy(1 downto 0) & sig;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_sync_line(sy : t_line_sync; sig : std_logic) return t_line_sync is
      variable v_sy  : t_line_sync;
   begin
      v_sy  := sy;
      return v_sy(0) & sig;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_synced(sy : std_logic_vector) return std_logic is
      variable v_sy  : std_logic_vector(sy'length -1 downto 0);  
   begin
      assert sy'length > 1 report "f_get_sync() requires a vector length of at least two!"
                           severity error;
      if (sy'length > 1) then
         v_sy  := sy;                
         return v_sy(1);
      else
         return 'X';
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_binary(p1hot : std_logic_vector) return natural is
      variable v_rval   : integer;
   begin
      v_rval   := find_rightmost(unsigned(p1hot), c_tie_high);
      
      if (v_rval > 0) then
         return v_rval;
      else
         return 0;
      end if;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_binary(p1hot : std_logic_vector; psz : positive) return std_logic_vector is
      variable v_pos    : natural;
      variable v_rval   : std_logic_vector(psz -1 downto 0);  
      
   begin
      v_pos    := maximum(0, find_rightmost(unsigned(p1hot), c_tie_high));
      v_rval   := std_logic_vector(to_unsigned(v_pos, v_rval'length ));
      
      return v_rval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_boolean(p1 : std_logic) return boolean is
   begin
      if (p1 = '1') then
         return true;
      else
         return false;
      end if; 
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_boolean(p1 : std_logic_vector) return boolean is
   begin
      if ((or(p1)) = '1') then
         return true;
      else
         return false;
      end if; 
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_chars(vpack : std_logic_vector) return t_byte_array is
      constant c_nr_units  : positive := (vpack'length / t_byte'length) + f_sel_tf(((vpack'length mod t_byte'length ) = 0), 0, 1);
      
      variable v_retval    : t_byte_array(c_nr_units - 1 downto 0);
      variable v_vin       : std_logic_vector((c_nr_units * t_byte'length ) - 1 downto 0);
   begin
      v_vin    := f_resize(vpack, v_vin'length );
      
      for ix in 0 to c_nr_units - 1 loop
         v_retval(ix)   := v_vin(((ix + 1) * t_byte'length ) - 1 downto (ix * t_byte'length ));
      end loop;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_index(vsel : std_logic_vector) return natural is
   begin
      return to_integer(unsigned(vsel));
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_logic(p1 : boolean) return std_logic is
   begin
      if (p1 = true) then
         return '1';
      else
         return '0';
      end if;   
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_onehot(ven : std_logic; vsel : natural; vsz : positive) return std_logic_vector is
      variable v_retval    : std_logic_vector(vsz -1 downto 0); 
   begin
      v_retval := (others => '0');
      
      if (vsel < vsz) then
         v_retval(vsel) := ven;
      end if;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_onehot(ven : std_logic; vsel : std_logic_vector) return std_logic_vector is
      variable v_retval    : std_logic_vector((2 ** vsel'length ) - 1 downto 0);
   begin
      v_retval    := (others => '0');
      v_retval(0) := ven;
      
      return f_shl(v_retval, vsel);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_onehot(vbin : std_logic_vector) return std_logic_vector is
      variable v_retval    : std_logic_vector((2 ** vbin'length ) - 1 downto 0);
   begin
      v_retval := f_reg_load(1, v_retval'length);
      
      return f_rol(v_retval, vbin);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_strobe(p1: natural; vsz : positive) return std_logic_vector is
      variable v_retval    : std_logic_vector(vsz - 1 downto 0);
      variable v_slv       : std_logic_vector(maximum(f_vec_msb(p1), vsz) downto 0);
   begin
      v_slv    := std_logic_vector(to_unsigned(p1, v_slv'length ));
      
      v_retval := f_to_strobe(v_slv, vsz);
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_to_strobe(slv : std_logic_vector; vsz : positive) return std_logic_vector is
      subtype t_pos    is integer range 0 to vsz - 1;
   
      variable v_msb       : t_pos;
      variable v_retval    : std_logic_vector(vsz - 1 downto 0);
      variable v_slv       : std_logic_vector(maximum(slv'length, f_num_bits(vsz)) - 1 downto 0);
   begin
      v_slv       := f_resize(slv, v_slv'length );
            
      if (unsigned(v_slv) = 0) then
         v_retval    := (others => '0');
      else
         if (unsigned(v_slv) < vsz) then
            v_msb       := to_integer(unsigned(v_slv)) - 1;
            
            v_retval    := (others => '0');
            v_retval(v_msb downto 0) := (others => '1');
         else
            v_retval    := (others => '1');
         end if;
      end if;
      
      return v_retval;      
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_typecast(vbyt : t_byte_array) return t_slv_array is
      subtype t_retval_array  is t_slv_array(vbyt'length - 1 downto 0)(t_byte'length - 1 downto 0);
      
      variable v_retval    : t_retval_array;
      variable v_din       : t_byte_array(vbyt'length - 1 downto 0);
      
   begin
      v_din    := vbyt;
      
      for ix in v_retval'range loop
         v_retval(ix) := v_din(ix);
      end loop;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_typecast(vdwd : t_dword_array) return t_slv_array is
      subtype t_retval_array  is t_slv_array(vdwd'length - 1 downto 0)(t_dword'length - 1 downto 0);
      
      variable v_retval    : t_retval_array;
      variable v_din       : t_dword_array(vdwd'length - 1 downto 0);
      
   begin
      v_din    := vdwd;

      for ix in v_retval'range loop
         v_retval(ix) := v_din(ix);
      end loop;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_typecast(vhwd : t_hword_array) return t_slv_array is
      subtype t_retval_array  is t_slv_array(vhwd'length - 1 downto 0)(t_hword'length - 1 downto 0);
      
      variable v_retval    : t_retval_array;
      variable v_din       : t_hword_array(vhwd'length - 1 downto 0);
      
   begin
      v_din    := vhwd;

      for ix in v_retval'range loop
         v_retval(ix) := v_din(ix);
      end loop;
      
      return v_retval;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_typecast(vqwd : t_qword_array) return t_slv_array is
      subtype t_retval_array  is t_slv_array(vqwd'length - 1 downto 0)(t_qword'length - 1 downto 0);
      
      variable v_retval    : t_retval_array;
      
   begin
      for ix in v_retval'range loop
         v_retval(ix) := vqwd(ix);
      end loop;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_typecast(vnat : natural; sz : natural) return std_logic_vector is
      variable v_retval    : std_logic_vector(sz - 1 downto 0);
   begin
      if (f_vec_msb(vnat) < v_retval'length ) then
         v_retval    := std_logic_vector(to_unsigned(vnat, v_retval'length ));
      else
         v_retval    := (others => '1');
      end if;
      
      return v_retval;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_typecast(vec : std_logic_vector; sz : natural; msb_sign : boolean := false) return std_logic_vector is
      variable v_retval    : std_logic_vector(sz - 1 downto 0);
      variable v_vec       : std_logic_vector(vec'length - 1 downto 0);
   begin
      if (msb_sign) then
         v_vec := vec;
         
         if (sz > vec'length ) then
            v_retval    := f_replicate(v_vec(v_vec'left ), sz - vec'length ) & v_vec;
         else
            v_retval    := v_vec(v_vec'left ) & v_vec(v_retval'left - 1 downto 0);
         end if;
         
         return v_retval;         
      else
         return std_logic_vector(resize(unsigned(vec), sz));
      end if;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_vec_msb(p1 : natural) return natural is
   
   begin
      return maximum(0, f_vec_size(p1) - 1);
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      --       Deprecated : Prefer f_num_bits
   function f_vec_size(p1 : natural) return natural is
   
   begin
   
      return f_num_bits(p1);
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_wired_and(a1 : t_byte_array) return t_byte is 
      variable v_result : t_byte;
   begin
      v_result := (others => '1');
      for i in a1'range loop
         v_result := v_result and a1(i);
      end loop;
      
      return v_result;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_wired_and(a1 : t_dword_array) return t_dword is 
      variable v_result : t_dword;
   begin
      v_result := (others => '1');
      for i in a1'range loop
         v_result := v_result and a1(i);
      end loop;
      
      return v_result;
   end function;

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_wired_or(a1 : t_byte_array) return t_byte is 
      variable v_result : t_byte;
   begin
      v_result := (others => '0');
      for i in a1'range loop
         v_result := v_result or a1(i);
      end loop;
      
      return v_result;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_wired_or(a1 : t_dword_array) return t_dword is 
      variable v_result : t_dword;
   begin
      v_result := (others => '0');
      for i in a1'range loop
         v_result := v_result or a1(i);
      end loop;
      
      return v_result;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_wired_xor(a1 : t_byte_array) return t_byte is 
      variable v_result : t_byte;
   begin
      v_result := (others => '0');
      for i in a1'range loop
         v_result := v_result xor a1(i);
      end loop;
      
      return v_result;
   end function;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_wired_xor(a1 : t_dword_array) return t_dword is 
      variable v_result : t_dword;
   begin
      v_result := (others => '0');
      for i in a1'range loop
         v_result := v_result xor a1(i);
      end loop;
      
      return v_result;
   end function;
   
End tspc_utils;
