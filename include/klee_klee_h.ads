pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

with Interfaces.C; use Interfaces.C;
with System;
with stddef_h;
with Interfaces.C.Strings;
with stdint_h;
with x86_64_linux_gnu_bits_stdint_intn_h;

package klee_klee_h is

   --  unsupported macro: klee_assert(expr) ((expr) ? (void) (0) : __assert_fail (#expr, __FILE__, __LINE__, __PRETTY_FUNCTION__))
  --===-- klee.h --------------------------------------------------*- C++ -*-===//
  --//
  --//                     The KLEE Symbolic Virtual Machine
  --//
  --// This file is distributed under the University of Illinois Open Source
  --// License. See LICENSE.TXT for details.
  --//
  --//===----------------------------------------------------------------------=== 

  -- Add an accesible memory object at a user specified location. It
  --   * is the users responsibility to make sure that these memory
  --   * objects do not overlap. These memory objects will also
  --   * (obviously) not correctly interact with external function
  --   * calls.
  --    

   procedure klee_define_fixed_object (addr : System.Address; nbytes : stddef_h.size_t)  -- /usr/local/include/klee/klee.h:26
   with Import => True, 
        Convention => C, 
        External_Name => "klee_define_fixed_object";

  -- klee_make_symbolic - Make the contents of the object pointer to by \arg
  --   * addr symbolic.
  --   *
  --   * \arg addr - The start of the object.
  --   * \arg nbytes - The number of bytes to make symbolic; currently this *must*
  --   * be the entire contents of the object.
  --   * \arg name - A name used for identifying the object in messages, output
  --   * files, etc. If NULL, object is called "unnamed".
  --    

   procedure klee_make_symbolic
     (addr : System.Address;
      nbytes : stddef_h.size_t;
      --name : Interfaces.C.Strings.chars_ptr)  -- /usr/local/include/klee/klee.h:37
      name : System.Address)  -- /usr/local/include/klee/klee.h:37
   with Import => True, 
        Convention => C, 
        External_Name => "klee_make_symbolic";

  -- klee_range - Construct a symbolic value in the signed interval
  --   * [begin,end).
  --   *
  --   * \arg name - A name used for identifying the object in messages, output
  --   * files, etc. If NULL, object is called "unnamed".
  --    

   function klee_range
     (c_begin : int;
      c_end : int;
      name : Interfaces.C.Strings.chars_ptr) return int  -- /usr/local/include/klee/klee.h:45
   with Import => True, 
        Convention => C, 
        External_Name => "klee_range";

  --  klee_int - Construct an unconstrained symbolic integer.
  --   *
  --   * \arg name - An optional name, used for identifying the object in messages,
  --   * output files, etc.
  --    

   function klee_int (name : Interfaces.C.Strings.chars_ptr) return int  -- /usr/local/include/klee/klee.h:52
   with Import => True, 
        Convention => C, 
        External_Name => "klee_int";

  -- klee_silent_exit - Terminate the current KLEE process without generating a
  --   * test file.
  --    

   procedure klee_silent_exit (status : int)  -- /usr/local/include/klee/klee.h:58
   with Import => True, 
        Convention => C, 
        External_Name => "klee_silent_exit";

  -- klee_abort - Abort the current KLEE process.  
   procedure klee_abort  -- /usr/local/include/klee/klee.h:62
   with Import => True, 
        Convention => C, 
        External_Name => "klee_abort";

  -- klee_report_error - Report a user defined error and terminate the current
  --   * KLEE process.
  --   *
  --   * \arg file - The filename to report in the error message.
  --   * \arg line - The line number to report in the error message.
  --   * \arg message - A string to include in the error message.
  --   * \arg suffix - The suffix to use for error files.
  --    

   procedure klee_report_error
     (file : Interfaces.C.Strings.chars_ptr;
      line : int;
      message : Interfaces.C.Strings.chars_ptr;
      suffix : Interfaces.C.Strings.chars_ptr)  -- /usr/local/include/klee/klee.h:73
   with Import => True, 
        Convention => C, 
        External_Name => "klee_report_error";

  -- called by checking code to get size of memory.  
   function klee_get_obj_size (ptr : System.Address) return stddef_h.size_t  -- /usr/local/include/klee/klee.h:79
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_obj_size";

  -- print the tree associated w/ a given expression.  
   procedure klee_print_expr (msg : Interfaces.C.Strings.chars_ptr  -- , ...
      )  -- /usr/local/include/klee/klee.h:82
   with Import => True, 
        Convention => C, 
        External_Name => "klee_print_expr";

  -- NB: this *does not* fork n times and return [0,n) in children.
  --   * It makes n be symbolic and returns: caller must compare N times.
  --    

   function klee_choose (n : stdint_h.uintptr_t) return stdint_h.uintptr_t  -- /usr/local/include/klee/klee.h:87
   with Import => True, 
        Convention => C, 
        External_Name => "klee_choose";

  -- special klee assert macro. this assert should be used when path consistency
  --   * across platforms is desired (e.g., in tests).
  --   * NB: __assert_fail is a klee "special" function
  --    

  -- Return true if the given value is symbolic (represented by an
  --   * expression) in the current state. This is primarily for debugging
  --   * and writing tests but can also be used to enable prints in replay
  --   * mode.
  --    

   function klee_is_symbolic (n : stdint_h.uintptr_t) return unsigned  -- /usr/local/include/klee/klee.h:103
   with Import => True, 
        Convention => C, 
        External_Name => "klee_is_symbolic";

  -- Return true if replaying a concrete test case using the libkleeRuntime library
  --   * Return false if executing symbolically in KLEE.
  --    

   function klee_is_replay return unsigned  -- /usr/local/include/klee/klee.h:109
   with Import => True, 
        Convention => C, 
        External_Name => "klee_is_replay";

  -- The following intrinsics are primarily intended for internal use
  --     and may have peculiar semantics.  

   procedure klee_assume (condition : stdint_h.uintptr_t)  -- /usr/local/include/klee/klee.h:115
   with Import => True, 
        Convention => C, 
        External_Name => "klee_assume";

   procedure klee_warning (message : Interfaces.C.Strings.chars_ptr)  -- /usr/local/include/klee/klee.h:116
   with Import => True, 
        Convention => C, 
        External_Name => "klee_warning";

   procedure klee_warning_once (message : Interfaces.C.Strings.chars_ptr)  -- /usr/local/include/klee/klee.h:117
   with Import => True, 
        Convention => C, 
        External_Name => "klee_warning_once";

   procedure klee_prefer_cex (object : System.Address; condition : stdint_h.uintptr_t)  -- /usr/local/include/klee/klee.h:118
   with Import => True, 
        Convention => C, 
        External_Name => "klee_prefer_cex";

   procedure klee_posix_prefer_cex (object : System.Address; condition : stdint_h.uintptr_t)  -- /usr/local/include/klee/klee.h:119
   with Import => True, 
        Convention => C, 
        External_Name => "klee_posix_prefer_cex";

   procedure klee_mark_global (object : System.Address)  -- /usr/local/include/klee/klee.h:120
   with Import => True, 
        Convention => C, 
        External_Name => "klee_mark_global";

  -- Return a possible constant value for the input expression. This
  --     allows programs to forcibly concretize values on their own.  

   function klee_get_valuef (expr : float) return float  -- /usr/local/include/klee/klee.h:126
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_valuef";

   function klee_get_valued (expr : double) return double  -- /usr/local/include/klee/klee.h:127
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_valued";

   function klee_get_valuel (expr : long) return long  -- /usr/local/include/klee/klee.h:128
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_valuel";

   function klee_get_valuell (expr : Long_Long_Integer) return Long_Long_Integer  -- /usr/local/include/klee/klee.h:129
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_valuell";

   function klee_get_value_i32 (expr : x86_64_linux_gnu_bits_stdint_intn_h.int32_t) return x86_64_linux_gnu_bits_stdint_intn_h.int32_t  -- /usr/local/include/klee/klee.h:130
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_value_i32";

   function klee_get_value_i64 (expr : x86_64_linux_gnu_bits_stdint_intn_h.int64_t) return x86_64_linux_gnu_bits_stdint_intn_h.int64_t  -- /usr/local/include/klee/klee.h:131
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_value_i64";

  -- Ensure that memory in the range [address, address+size) is
  --     accessible to the program. If some byte in the range is not
  --     accessible an error will be generated and the state
  --     terminated. 
  --     The current implementation requires both address and size to be
  --     constants and that the range lie within a single object.  

   procedure klee_check_memory_access (address : System.Address; size : stddef_h.size_t)  -- /usr/local/include/klee/klee.h:142
   with Import => True, 
        Convention => C, 
        External_Name => "klee_check_memory_access";

  -- Enable/disable forking.  
   procedure klee_set_forking (enable : unsigned)  -- /usr/local/include/klee/klee.h:145
   with Import => True, 
        Convention => C, 
        External_Name => "klee_set_forking";

  -- Print stack trace.  
   procedure klee_stack_trace  -- /usr/local/include/klee/klee.h:148
   with Import => True, 
        Convention => C, 
        External_Name => "klee_stack_trace";

  -- Print range for given argument and tagged with name  
   procedure klee_print_range (name : Interfaces.C.Strings.chars_ptr; arg : int)  -- /usr/local/include/klee/klee.h:151
   with Import => True, 
        Convention => C, 
        External_Name => "klee_print_range";

  -- Open a merge  
   procedure klee_open_merge  -- /usr/local/include/klee/klee.h:154
   with Import => True, 
        Convention => C, 
        External_Name => "klee_open_merge";

  -- Merge all paths of the state that went through klee_open_merge  
   procedure klee_close_merge  -- /usr/local/include/klee/klee.h:157
   with Import => True, 
        Convention => C, 
        External_Name => "klee_close_merge";

  -- Get errno value of the current state  
   function klee_get_errno return int  -- /usr/local/include/klee/klee.h:160
   with Import => True, 
        Convention => C, 
        External_Name => "klee_get_errno";

end klee_klee_h;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
