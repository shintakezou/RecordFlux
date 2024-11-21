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
with RFLX.Universal.Options;
with RFLX.Universal.Option;
with RFLX.RFLX_Types.Operators;

package body RFLX.Test.S.FSM
with
  SPARK_Mode
is

   use RFLX.RFLX_Types.Operators;

   use type RFLX.RFLX_Types.Bytes_Ptr;

   use type RFLX.RFLX_Types.Bit_Length;

   procedure Start (Ctx : in out Context)
   with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      Options_Ctx : Universal.Options.Context;
      Options_Buffer : RFLX_Types.Bytes_Ptr;
      function Start_Invariant return Boolean is
        (Global_Initialized (Ctx)
         and Universal.Options.Has_Buffer (Options_Ctx)
         and Options_Ctx.Buffer_First = RFLX.RFLX_Types.Index'First
         and Options_Ctx.Buffer_Last >= RFLX.RFLX_Types.Index'First + RFLX_Types.Length'(4095)
         and Ctx.P.Slots.Slot_Ptr_2 = null
         and Ctx.P.Slots.Slot_Ptr_1 = null)
      with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      Options_Buffer := Ctx.P.Slots.Slot_Ptr_2;
      pragma Warnings (Off, "unused assignment");
      Ctx.P.Slots.Slot_Ptr_2 := null;
      pragma Warnings (On, "unused assignment");
      Universal.Options.Initialize (Options_Ctx, Options_Buffer);
      pragma Assert (Start_Invariant);
      pragma Warnings (Off, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition is always False");
      pragma Warnings (Off, "this code can never be executed and has been deleted");
      pragma Warnings (Off, "statement has no effect");
      pragma Warnings (Off, "this statement is never reached");
      if not Universal.Options.Valid (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");
      pragma Warnings (On, "this code can never be executed and has been deleted");
      pragma Warnings (On, "condition is always False");
      pragma Warnings (On, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition is always False");
      pragma Warnings (Off, "this code can never be executed and has been deleted");
      pragma Warnings (Off, "statement has no effect");
      pragma Warnings (Off, "this statement is never reached");
      if not Universal.Options.Has_Element (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");
      pragma Warnings (On, "this code can never be executed and has been deleted");
      pragma Warnings (On, "condition is always False");
      pragma Warnings (On, "condition can only be False if invalid values present");
      -- tests/feature/fsm_append_unconstrained/test.rflx:13:10
      if not Universal.Options.Has_Element (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      declare
         RFLX_Element_Options_Ctx : Universal.Option.Context;
      begin
         Universal.Options.Switch (Options_Ctx, RFLX_Element_Options_Ctx);
         if not Universal.Option.Sufficient_Space (RFLX_Element_Options_Ctx, Universal.Option.F_Option_Type) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not RFLX.Universal.Option.Field_Condition (RFLX_Element_Options_Ctx, RFLX.Universal.Option.F_Option_Type, Universal.To_Base_Integer (Universal.OT_Data)) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         Universal.Option.Set_Option_Type (RFLX_Element_Options_Ctx, Universal.OT_Data);
         if not Universal.Option.Sufficient_Space (RFLX_Element_Options_Ctx, Universal.Option.F_Length) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not RFLX.Universal.Option.Field_Condition (RFLX_Element_Options_Ctx, RFLX.Universal.Option.F_Length, Universal.To_Base_Integer (Universal.Length'(1))) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         Universal.Option.Set_Length (RFLX_Element_Options_Ctx, Universal.Length'(1));
         if not Universal.Option.Valid_Length (RFLX_Element_Options_Ctx, Universal.Option.F_Data, RFLX_Types.To_Length (1 * RFLX_Types.Byte'Size)) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not Universal.Option.Sufficient_Space (RFLX_Element_Options_Ctx, Universal.Option.F_Data) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not RFLX.Universal.Option.Field_Condition (RFLX_Element_Options_Ctx, RFLX.Universal.Option.F_Data, 0) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         Universal.Option.Set_Data (RFLX_Element_Options_Ctx, (RFLX_Types.Index'First => RFLX_Types.Byte'Val (1)));
         pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
         Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
         pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
      end;
      pragma Warnings (Off, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition is always False");
      pragma Warnings (Off, "this code can never be executed and has been deleted");
      pragma Warnings (Off, "statement has no effect");
      pragma Warnings (Off, "this statement is never reached");
      if not Universal.Options.Valid (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");
      pragma Warnings (On, "this code can never be executed and has been deleted");
      pragma Warnings (On, "condition is always False");
      pragma Warnings (On, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition is always False");
      pragma Warnings (Off, "this code can never be executed and has been deleted");
      pragma Warnings (Off, "statement has no effect");
      pragma Warnings (Off, "this statement is never reached");
      if not Universal.Options.Has_Element (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");
      pragma Warnings (On, "this code can never be executed and has been deleted");
      pragma Warnings (On, "condition is always False");
      pragma Warnings (On, "condition can only be False if invalid values present");
      -- tests/feature/fsm_append_unconstrained/test.rflx:14:10
      if not Universal.Options.Has_Element (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      declare
         RFLX_Element_Options_Ctx : Universal.Option.Context;
      begin
         Universal.Options.Switch (Options_Ctx, RFLX_Element_Options_Ctx);
         if not Universal.Option.Sufficient_Space (RFLX_Element_Options_Ctx, Universal.Option.F_Option_Type) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not RFLX.Universal.Option.Field_Condition (RFLX_Element_Options_Ctx, RFLX.Universal.Option.F_Option_Type, Universal.To_Base_Integer (Universal.OT_Data)) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         Universal.Option.Set_Option_Type (RFLX_Element_Options_Ctx, Universal.OT_Data);
         if not Universal.Option.Sufficient_Space (RFLX_Element_Options_Ctx, Universal.Option.F_Length) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not RFLX.Universal.Option.Field_Condition (RFLX_Element_Options_Ctx, RFLX.Universal.Option.F_Length, Universal.To_Base_Integer (Universal.Length'(2))) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         Universal.Option.Set_Length (RFLX_Element_Options_Ctx, Universal.Length'(2));
         if not Universal.Option.Valid_Length (RFLX_Element_Options_Ctx, Universal.Option.F_Data, RFLX_Types.To_Length (2 * RFLX_Types.Byte'Size)) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not Universal.Option.Sufficient_Space (RFLX_Element_Options_Ctx, Universal.Option.F_Data) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not RFLX.Universal.Option.Field_Condition (RFLX_Element_Options_Ctx, RFLX.Universal.Option.F_Data, 0) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         Universal.Option.Set_Data (RFLX_Element_Options_Ctx, (RFLX_Types.Byte'Val (2), RFLX_Types.Byte'Val (3)));
         pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
         Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
         pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
      end;
      pragma Warnings (Off, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition is always False");
      pragma Warnings (Off, "this code can never be executed and has been deleted");
      pragma Warnings (Off, "statement has no effect");
      pragma Warnings (Off, "this statement is never reached");
      if not Universal.Options.Valid (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");
      pragma Warnings (On, "this code can never be executed and has been deleted");
      pragma Warnings (On, "condition is always False");
      pragma Warnings (On, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition can only be False if invalid values present");
      pragma Warnings (Off, "condition is always False");
      pragma Warnings (Off, "this code can never be executed and has been deleted");
      pragma Warnings (Off, "statement has no effect");
      pragma Warnings (Off, "this statement is never reached");
      if not Universal.Options.Has_Element (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      pragma Warnings (On, "this statement is never reached");
      pragma Warnings (On, "statement has no effect");
      pragma Warnings (On, "this code can never be executed and has been deleted");
      pragma Warnings (On, "condition is always False");
      pragma Warnings (On, "condition can only be False if invalid values present");
      -- tests/feature/fsm_append_unconstrained/test.rflx:15:10
      if not Universal.Options.Has_Element (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      declare
         RFLX_Element_Options_Ctx : Universal.Option.Context;
      begin
         Universal.Options.Switch (Options_Ctx, RFLX_Element_Options_Ctx);
         if not Universal.Option.Sufficient_Space (RFLX_Element_Options_Ctx, Universal.Option.F_Option_Type) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         if not RFLX.Universal.Option.Field_Condition (RFLX_Element_Options_Ctx, RFLX.Universal.Option.F_Option_Type, Universal.To_Base_Integer (Universal.OT_Null)) then
            Ctx.P.Next_State := S_Final;
            pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
            pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
            pragma Assert (Start_Invariant);
            goto Finalize_Start;
         end if;
         Universal.Option.Set_Option_Type (RFLX_Element_Options_Ctx, Universal.OT_Null);
         pragma Warnings (Off, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
         Universal.Options.Update (Options_Ctx, RFLX_Element_Options_Ctx);
         pragma Warnings (On, """RFLX_Element_Options_Ctx"" is set by ""Update"" but not used after the call");
      end;
      -- tests/feature/fsm_append_unconstrained/test.rflx:16:10
      Universal.Message.Reset (Ctx.P.Message_Ctx);
      if not Universal.Message.Sufficient_Space (Ctx.P.Message_Ctx, Universal.Message.F_Message_Type) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      if not RFLX.Universal.Message.Field_Condition (Ctx.P.Message_Ctx, RFLX.Universal.Message.F_Message_Type, Universal.To_Base_Integer (Universal.MT_Unconstrained_Options)) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      Universal.Message.Set_Message_Type (Ctx.P.Message_Ctx, Universal.MT_Unconstrained_Options);
      if not Universal.Message.Valid_Length (Ctx.P.Message_Ctx, Universal.Message.F_Options, Universal.Options.Byte_Size (Options_Ctx)) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      if not Universal.Message.Sufficient_Space (Ctx.P.Message_Ctx, Universal.Message.F_Options) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      if not RFLX.Universal.Message.Field_Condition (Ctx.P.Message_Ctx, RFLX.Universal.Message.F_Options, 0) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      if not Universal.Options.Valid (Options_Ctx) then
         Ctx.P.Next_State := S_Final;
         pragma Assert (Start_Invariant);
         goto Finalize_Start;
      end if;
      Universal.Message.Set_Options (Ctx.P.Message_Ctx, Options_Ctx);
      Ctx.P.Next_State := S_Reply;
      pragma Assert (Start_Invariant);
      <<Finalize_Start>>
      pragma Warnings (Off, """Options_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Universal.Options.Take_Buffer (Options_Ctx, Options_Buffer);
      pragma Warnings (On, """Options_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Assert (Ctx.P.Slots.Slot_Ptr_2 = null);
      pragma Assert (Options_Buffer /= null);
      Ctx.P.Slots.Slot_Ptr_2 := Options_Buffer;
      pragma Assert (Ctx.P.Slots.Slot_Ptr_2 /= null);
      pragma Assert (Global_Initialized (Ctx));
   end Start;

   procedure Reply (Ctx : in out Context)
   with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      function Reply_Invariant return Boolean is
        (Ctx.P.Slots.Slot_Ptr_1 = null
         and Ctx.P.Slots.Slot_Ptr_2 /= null)
      with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      pragma Assert (Reply_Invariant);
      -- tests/feature/fsm_append_unconstrained/test.rflx:25:10
      Ctx.P.Next_State := S_Final;
      pragma Assert (Reply_Invariant);
   end Reply;

   procedure Initialize (Ctx : in out Context)
   is
      Message_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      Test.S.FSM_Allocator.Initialize (Ctx.P.Slots, Ctx.P.Memory);
      Message_Buffer := Ctx.P.Slots.Slot_Ptr_1;
      pragma Warnings (Off, "unused assignment");
      Ctx.P.Slots.Slot_Ptr_1 := null;
      pragma Warnings (On, "unused assignment");
      Universal.Message.Initialize (Ctx.P.Message_Ctx, Message_Buffer);
      Ctx.P.Next_State := S_Start;
   end Initialize;

   procedure Finalize (Ctx : in out Context)
   is
      Message_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      pragma Warnings (Off, """Ctx.P.Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Universal.Message.Take_Buffer (Ctx.P.Message_Ctx, Message_Buffer);
      pragma Warnings (On, """Ctx.P.Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Assert (Ctx.P.Slots.Slot_Ptr_1 = null);
      pragma Assert (Message_Buffer /= null);
      Ctx.P.Slots.Slot_Ptr_1 := Message_Buffer;
      pragma Assert (Ctx.P.Slots.Slot_Ptr_1 /= null);
      Test.S.FSM_Allocator.Finalize (Ctx.P.Slots);
      Ctx.P.Next_State := S_Final;
   end Finalize;

   procedure Tick (Ctx : in out Context)
   is
   begin
      case Ctx.P.Next_State is
         when S_Start =>
            Start (Ctx);
         when S_Reply =>
            Reply (Ctx);
         when S_Final =>
            null;
      end case;
   end Tick;

   function In_IO_State (Ctx : Context) return Boolean is
     (Ctx.P.Next_State in S_Reply);

   procedure Run (Ctx : in out Context)
   is
   begin
      Tick (Ctx);
      while
         Active (Ctx)
         and not In_IO_State (Ctx)
      loop
         pragma Loop_Invariant (Initialized (Ctx));
         Tick (Ctx);
      end loop;
   end Run;

   procedure Read (Ctx : Context; Chan : Channel; Buffer : out RFLX_Types.Bytes; Offset : RFLX_Types.Length := 0)
   is
      function Read_Pre (Message_Buffer : RFLX_Types.Bytes) return Boolean is
        (Buffer'Length > 0
         and then Offset < Message_Buffer'Length);
      procedure Read (Message_Buffer : RFLX_Types.Bytes)
      with
        Pre =>
          Read_Pre (Message_Buffer)
      is
         Length : constant RFLX_Types.Length := RFLX_Types.Length'Min (Buffer'Length, Message_Buffer'Length - Offset);
         Buffer_Last : constant RFLX_Types.Index := Buffer'First + (Length - RFLX_Types.Length'(1));
      begin
         Buffer (Buffer'First .. RFLX_Types.Index (Buffer_Last)) := Message_Buffer (RFLX_Types.Index (RFLX_Types.Length (Message_Buffer'First) + Offset) .. Message_Buffer'First + Offset + (Length - RFLX_Types.Length'(1)));
      end Read;
      procedure Universal_Message_Read is new Universal.Message.Generic_Read (Read, Read_Pre);
   begin
      Buffer := (others => 0);
      case Chan is
         when C_Channel =>
            case Ctx.P.Next_State is
               when S_Reply =>
                  Universal_Message_Read (Ctx.P.Message_Ctx);
               when others =>
                  pragma Warnings (Off, "unreachable code");
                  null;
                  pragma Warnings (On, "unreachable code");
            end case;
      end case;
   end Read;

end RFLX.Test.S.FSM;
