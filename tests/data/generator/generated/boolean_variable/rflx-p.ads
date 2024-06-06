------------------------------------------------------------------------------
--                                                                          --
--                         Generated by RecordFlux                          --
--                                                                          --
--                          Copyright (C) AdaCore                           --
--                                                                          --
--         SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception          --
--                                                                          --
------------------------------------------------------------------------------

pragma Ada_2012;
pragma Style_Checks ("N3aAbCdefhiIklnOprStux");
pragma Warnings (Off, "redundant conversion");
with RFLX.RFLX_Types;

package RFLX.P with
  SPARK_Mode
is

   type T is range 0 .. 127 with
     Size =>
       7;

   use type RFLX.RFLX_Types.Base_Integer;

   function Valid_T (Val : RFLX.RFLX_Types.Base_Integer) return Boolean is
     (Val <= 127);

   function To_Base_Integer (Val : RFLX.P.T) return RFLX.RFLX_Types.Base_Integer is
     (RFLX.RFLX_Types.Base_Integer (Val));

   function To_Actual (Val : RFLX.RFLX_Types.Base_Integer) return RFLX.P.T is
     (RFLX.P.T (Val))
    with
     Pre =>
       Valid_T (Val);

end RFLX.P;
