pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Interfaces.C; use Interfaces.C;
with x86_64_linux_gnu_bits_types_h;
with x86_64_linux_gnu_bits_types_u_mbstate_t_h;

package x86_64_linux_gnu_bits_types_u_fpos64_t_h is

  -- The tag name of this struct is _G_fpos64_t to preserve historic
  --   C++ mangled names for functions taking fpos_t and/or fpos64_t
  --   arguments.  That name should not be used in new code.   

   type u_G_fpos64_t is record
      uu_pos : aliased x86_64_linux_gnu_bits_types_h.uu_off64_t;  -- /usr/include/x86_64-linux-gnu/bits/types/__fpos64_t.h:12
      uu_state : aliased x86_64_linux_gnu_bits_types_u_mbstate_t_h.uu_mbstate_t;  -- /usr/include/x86_64-linux-gnu/bits/types/__fpos64_t.h:13
   end record
   with Convention => C_Pass_By_Copy;  -- /usr/include/x86_64-linux-gnu/bits/types/__fpos64_t.h:10

   subtype uu_fpos64_t is u_G_fpos64_t;  -- /usr/include/x86_64-linux-gnu/bits/types/__fpos64_t.h:14

end x86_64_linux_gnu_bits_types_u_fpos64_t_h;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
