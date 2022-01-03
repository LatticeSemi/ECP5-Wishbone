
--    
--    Copyright Ingenieurbuero Gardiner, 2007 - 2020
--       https://www.ib-gardiner.eu
--       techsupport@ib-gardiner.eu
--
--    All Rights Reserved
--     
--------------------------------------------------------------------------------
--
-- File ID     : $Id: tspc_utils-p.vhd 5275 2021-03-04 00:17:58Z  $
-- Generated   : $LastChangedDate: 2021-03-04 01:17:58 +0100 (Thu, 04 Mar 2021) $
-- Revision    : $LastChangedRevision: 5275 $
--
--------------------------------------------------------------------------------
--
-- Description : General synthesisable utilities
--
--------------------------------------------------------------------------------

Library IEEE;
Use IEEE.std_logic_1164.all;

Package tspc_utils is
   constant c_no_wrap         : boolean := true;
   
   constant c_tie_high        : std_logic := '1';
   constant c_tie_high_byte   : std_logic_vector(7 downto 0) := (others => '1');
   constant c_tie_high_dword  : std_logic_vector(31 downto 0) := (others => '1');
   constant c_tie_high_hex    : std_logic_vector(3 downto 0) := (others => '1');
   constant c_tie_high_hword  : std_logic_vector(15 downto 0) := (others => '1');
   constant c_tie_high_qword  : std_logic_vector(63 downto 0) := (others => '1');
   constant c_tie_low         : std_logic := '0';
   constant c_tie_low_byte    : std_logic_vector(7 downto 0) := (others => '0');
   constant c_tie_low_dword   : std_logic_vector(31 downto 0) := (others => '0');
   constant c_tie_low_hex     : std_logic_vector(3 downto 0) := (others => '0');
   constant c_tie_low_hword   : std_logic_vector(15 downto 0) := (others => '0');
   constant c_tie_low_qword   : std_logic_vector(63 downto 0) := (others => '0');
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   subtype t_byte    is std_logic_vector(7 downto 0);
   subtype t_bytep   is std_logic_vector(8 downto 0);
   subtype t_dword   is std_logic_vector(31 downto 0);
   subtype t_dwordp  is std_logic_vector(35 downto 0);
   subtype t_hexcode is std_logic_vector(3 downto 0);
   subtype t_hword   is std_logic_vector(15 downto 0);
   subtype t_hwordp  is std_logic_vector(17 downto 0);   
   subtype t_qword   is std_logic_vector(63 downto 0);
   subtype t_qwordp  is std_logic_vector(71 downto 0);
   subtype t_word    is std_logic_vector(15 downto 0);
   subtype t_wordp   is std_logic_vector(17 downto 0);

   subtype t_edge_det   is std_logic_vector(1 downto 0); 
   subtype t_edge_sync  is std_logic_vector(2 downto 0); 
   subtype t_line_sync  is std_logic_vector(1 downto 0); 

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   type t_boolean_array is array (natural range <>) of boolean;
   type t_byte_array    is array (natural range <>) of t_byte;   
   type t_bytep_array   is array (natural range <>) of t_bytep;   
   type t_dword_array   is array (natural range <>) of t_dword;   
   type t_dwordp_array  is array (natural range <>) of t_dwordp;  
   type t_hexcode_array is array (natural range <>) of t_hexcode;
   type t_hword_array   is array (natural range <>) of t_hword;   
   type t_hwordp_array  is array (natural range <>) of t_hwordp;   
   type t_integer_array is array (natural range <>) of integer;
   type t_qword_array   is array (natural range <>) of t_qword;   
   type t_qwordp_array  is array (natural range <>) of t_qwordp;  
   type t_slv_array     is array (natural range <>) of std_logic_vector;
   type t_word_array    is array (natural range <>) of t_word;   
   type t_wordp_array   is array (natural range <>) of t_wordp;   
   
   type t_lut_boolean_sl is array (boolean range <>) of std_logic;
   
      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   constant c_bool_to_logic         : t_lut_boolean_sl := (true => '1', false => '0');
   constant c_dword_array_init_8    : t_dword_array(7 downto 0) := (others => (others => '0'));

      --    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   function f_add(vec : std_logic_vector; vincr : natural) return std_logic_vector;

   function f_add(vec : std_logic_vector; vincr : std_logic_vector) return std_logic_vector;

      -- Align a byte-address to the underlying data-size (e.g. hword, dword, qword) 
   function f_align_adr(slv : std_logic_vector; nsym : positive) return std_logic_vector;
   
      -- Align a vector to the leftmost position keeping upper bits of original vector 
   function f_align_msb(slv : std_logic_vector; dsz : natural) return std_logic_vector;

      -- Returns address offset indicated by first valid byte enable in a byte-enable vector
   function f_be_to_adr(slv : std_logic_vector) return std_logic_vector;
   
      -- Returns number of contiguous valid byte-enable bits in a byte-enable vector
   function f_be_to_bcd(slv : std_logic_vector) return std_logic_vector;
      
   function f_be_to_int(slv : std_logic_vector) return natural;
   
      -- vle : Little-Endian, stack increasing address to left. List order is zero-based
   function f_concat(slva : t_byte_array; vle : boolean := true) return std_logic_vector;

   function f_concat(slva : t_dword_array; vle : boolean := true) return std_logic_vector;
   
   function f_concat(slva : t_hword_array; vle : boolean := true) return std_logic_vector;

   function f_concat(slva : t_qword_array; vle : boolean := true) return std_logic_vector;

   function f_concat(slva : t_slv_array; vle : boolean := true) return std_logic_vector;
   
   function f_cp_resize(vec : std_logic_vector; sz : natural) return std_logic_vector;

   function f_decr(slv : std_logic_vector; no_wrap : boolean := false) return std_logic_vector;

   function f_decr(slv : std_logic_vector; vsval : natural) return std_logic_vector;   
   
   function f_det_ev(dt : t_edge_det) return boolean;

   function f_det_ev(dt : t_edge_det) return std_logic;
   
   function f_det_fall(dt : t_edge_det) return boolean;

   function f_det_fall(dt : t_edge_det) return std_logic;

   function f_det_rise(dt : t_edge_det) return boolean;   

   function f_det_rise(dt : t_edge_det) return std_logic;   
   
   function f_edge_any(sy : t_edge_sync) return boolean;

   function f_edge_any(sy : t_edge_sync) return std_logic;

   function f_edge_fall(sy : t_edge_sync) return boolean;

   function f_edge_fall(sy : t_edge_sync) return std_logic;

   function f_edge_rise(sy : t_edge_sync) return boolean;   

   function f_edge_rise(sy : t_edge_sync) return std_logic;   

   function f_extract(lw : std_logic_vector; sel : natural; osz : positive) return std_logic_vector;

   function f_extract(lw : std_logic_vector; sel : std_logic_vector; osz : positive) return std_logic_vector;
   
      -- Fill a vector with logic one. flp designates the bit position from left or right (0 to length - 1)
   function f_fill_lsb(slv : std_logic_vector; flp : natural := 0) return std_logic_vector;
   
   function f_fill_lsb(slv : std_logic_vector; flp : std_logic_vector) return std_logic_vector;   

   function f_fill_msb(slv : std_logic_vector; flp : natural := 0) return std_logic_vector;

   function f_fill_msb(slv : std_logic_vector; flp : std_logic_vector) return std_logic_vector;
   
      -- f_find_leftmost, f_find_rightmost, for compatibility to the previous utility library
      -- IEEE standard synthesis package (implemented in numeric_std) also provides find_leftmost 
      -- / find_rightmost implementations
      -- Synthesis results from this package and numeric_std are equivalent
   function f_find_leftmost(slv : std_logic_vector; val : std_logic) return integer;

   function f_find_leftmost(slv : std_logic_vector; val : std_logic; sz : positive) return std_logic_vector;
      
   function f_find_rightmost(slv : std_logic_vector; val : std_logic) return integer;
   
   function f_find_rightmost(slv : std_logic_vector; val : std_logic; sz : positive) return std_logic_vector;
   
   function f_get_svn_tag(i_vn : string; i_len : positive) return std_logic_vector;
  
   function f_incr(slv : std_logic_vector; no_wrap : boolean := false) return std_logic_vector;   

   function f_incr(slv : std_logic_vector; vmax : natural) return std_logic_vector;   

   function f_insert(dst : std_logic_vector; src : std_logic_vector; sel : natural) return std_logic_vector;

   function f_insert(dst : std_logic_vector; src : std_logic_vector; sel : std_logic_vector) return std_logic_vector;
   
   function f_is_zero(vec : std_logic_vector) return boolean;
   
   function f_is_zero(vec : std_logic_vector) return std_logic;
   
   function f_maj_2of3(slv : std_logic_vector) return std_logic;

   function f_maj_3of5(slv : std_logic_vector) return std_logic;
   
   function f_merge(rv     : std_logic_vector; 
                    di     : std_logic_vector;
                    be     : std_logic_vector;
                    symsz  : positive := 8) return std_logic_vector;
                        
   function f_mirror(bvl : std_logic_vector) return std_logic_vector;

   function f_num_bits(p1 : natural) return positive;
   
   function f_poll(vec : std_logic_vector; scl : std_logic) return std_logic_vector;
   
   function f_reg_load(vnat : natural; sz : natural) return std_logic_vector;

   function f_reg_load(vec : std_logic_vector; sz : natural) return std_logic_vector;
   
   function f_reg_read(slv : std_logic_vector; sz : natural) return std_logic_vector;
   
   function f_reg_write(rv    : std_logic_vector; 
                        di    : std_logic_vector;
                        be    : std_logic_vector;
                        symsz : positive := 8) return std_logic_vector;

   function f_reg_write(rv    : std_logic_vector; 
                        di    : std_logic_vector;
                        be    : std_logic_vector;
                        mask  : std_logic_vector;  -- set to '1' to allow vector element write
                        symsz : positive := 8) return std_logic_vector;

   function f_replicate(bvl : std_logic; sz : natural) return std_logic_vector;
   
   function f_replicate(svec : std_logic_vector; mult : natural) return std_logic_vector;

   function f_resize(vec : std_logic_vector; sz : natural) return std_logic_vector;
   
   function f_resize_se(vec : std_logic_vector; sz : natural) return std_logic_vector;
   
   function f_rol(slv : std_logic_vector; shft : natural := 1) return std_logic_vector;

   function f_rol(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector;
   
   function f_ror(slv : std_logic_vector; shft : natural := 1) return std_logic_vector;
   
   function f_ror(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector;

   function f_sel_tf(vsel : boolean; vtrue : integer; vfalse : integer) return integer;

   function f_sel_tf(vsel : boolean; vtrue : std_logic; vfalse : std_logic) return std_logic;
   
   function f_sel_tf(vsel : boolean; vtrue : std_logic_vector; vfalse : std_logic_vector) return std_logic_vector;

   function f_sel_tf(vsel : std_logic; vtrue : integer; vfalse : integer) return integer;

   function f_sel_tf(vsel : std_logic; vtrue : std_logic; vfalse : std_logic) return std_logic;
   
   function f_sel_tf(vsel : std_logic; vtrue : std_logic_vector; vfalse : std_logic_vector) return std_logic_vector;

   function f_shin_lsb(slv : std_logic_vector; sin : std_logic) return std_logic_vector;

   function f_shin_lsb(slv : std_logic_vector; sin : std_logic_vector) return std_logic_vector;
   
   function f_shin_msb(slv : std_logic_vector; sin : std_logic) return std_logic_vector;  
   
   function f_shin_msb(slv : std_logic_vector; sin : std_logic_vector) return std_logic_vector;  

   function f_shl(slv : std_logic_vector; shft : natural := 1) return std_logic_vector;

   function f_shl(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector;

   function f_shl_xv(slv : std_logic_vector; shft : natural := 1; lv : std_logic := '1') return std_logic_vector;
   
   function f_shl_xv(slv : std_logic_vector; shft : std_logic_vector; lv : std_logic := '1') return std_logic_vector;

   function f_shr(slv : std_logic_vector; shft : natural := 1) return std_logic_vector;
   
   function f_shr(slv : std_logic_vector; shft : std_logic_vector) return std_logic_vector;

   function f_shr_xv(slv : std_logic_vector; shft : natural := 1; lv : std_logic := '1') return std_logic_vector;
   
   function f_shr_xv(slv : std_logic_vector; shft : std_logic_vector; lv : std_logic := '1') return std_logic_vector;
   
   function f_sub(vnat : natural; vdecr : std_logic_vector) return std_logic_vector;

   function f_sub(vec : std_logic_vector; vdecr : natural) return std_logic_vector;

   function f_sub(vec : std_logic_vector; vdecr : std_logic_vector) return std_logic_vector;
   
   function f_swap_endian(slv : std_logic_vector; usz : positive := t_byte'length ) return std_logic_vector;   

   function f_sync_edge(sy : t_edge_sync; sig : std_logic) return t_edge_sync;

   function f_sync_line(sy : t_line_sync; sig : std_logic) return t_line_sync;

   function f_synced(sy : std_logic_vector) return std_logic;

   function f_to_binary(p1hot : std_logic_vector) return natural;
   
   function f_to_binary(p1hot : std_logic_vector; psz : positive) return std_logic_vector;
   
   function f_to_boolean(p1 : std_logic) return boolean;

   function f_to_boolean(p1 : std_logic_vector) return boolean;
   
   function f_to_chars(vpack : std_logic_vector) return t_byte_array;   
   
   function f_to_index(vsel : std_logic_vector) return natural;

   function f_to_logic(p1 : boolean) return std_logic;

   function f_to_onehot(ven : std_logic; vsel : natural; vsz : positive) return std_logic_vector;

   function f_to_onehot(ven : std_logic; vsel : std_logic_vector) return std_logic_vector;
   
   function f_to_onehot(vbin : std_logic_vector) return std_logic_vector;
   
   function f_to_strobe(p1: natural; vsz : positive) return std_logic_vector;

   function f_to_strobe(slv : std_logic_vector; vsz : positive) return std_logic_vector;
   
   function f_typecast(vbyt :t_byte_array) return t_slv_array;
   
   function f_typecast(vdwd : t_dword_array) return t_slv_array;

   function f_typecast(vhwd : t_hword_array) return t_slv_array;

   function f_typecast(vqwd : t_qword_array) return t_slv_array;
   
   function f_typecast(vnat : natural; sz : natural) return std_logic_vector;

   function f_typecast(vec : std_logic_vector; sz : natural; msb_sign : boolean := false) return std_logic_vector;

   function f_vec_msb(p1 : natural) return natural;
   
      --       Deprecated : Prefer f_num_bits()
   function f_vec_size(p1 : natural) return natural;
   
   function f_wired_and(a1 : t_byte_array) return t_byte;

   function f_wired_and(a1 : t_dword_array) return t_dword;

   function f_wired_or(a1 : t_byte_array) return t_byte;

   function f_wired_or(a1 : t_dword_array) return t_dword;

   function f_wired_xor(a1 : t_byte_array) return t_byte;

   function f_wired_xor(a1 : t_dword_array) return t_dword;   
End tspc_utils;
