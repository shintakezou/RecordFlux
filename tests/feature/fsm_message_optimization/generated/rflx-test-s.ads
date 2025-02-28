------------------------------------------------------------------------------
--                                                                          --
--                         Generated by RecordFlux                          --
--                                                                          --
--                          Copyright (C) AdaCore                           --
--                                                                          --
--         SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception          --
--                                                                          --
------------------------------------------------------------------------------

pragma Restrictions (No_Streams);
pragma Ada_2012;
pragma Style_Checks ("N3aAbCdefhiIklnOprStux");
pragma Warnings (Off, "redundant conversion");
with RFLX.Test.S_Environment;
with RFLX.RFLX_Types;
with RFLX.Test.Option_Data;

package RFLX.Test.S
with
  SPARK_Mode
is

   procedure Get_Option_Data (State : in out RFLX.Test.S_Environment.State; Data : RFLX_Types.Bytes; RFLX_Result : out RFLX.Test.Option_Data.Structure);

end RFLX.Test.S;
