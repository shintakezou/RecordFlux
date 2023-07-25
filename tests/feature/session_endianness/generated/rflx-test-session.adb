pragma Restrictions (No_Streams);
pragma Style_Checks ("N3aAbCdefhiIklnOprStux");
pragma Warnings (Off, "redundant conversion");

package body RFLX.Test.Session with
  SPARK_Mode
is

   use type RFLX.RFLX_Types.Bytes_Ptr;

   use type RFLX.RFLX_Types.Bit_Length;

   procedure Start (Ctx : in out Context'Class) with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      function Start_Invariant return Boolean is
        (Ctx.P.Slots.Slot_Ptr_1 = null
         and Ctx.P.Slots.Slot_Ptr_2 = null
         and Ctx.P.Slots.Slot_Ptr_3 = null
         and Ctx.P.Slots.Slot_Ptr_4 = null)
       with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      pragma Assert (Start_Invariant);
      -- tests/feature/session_endianness/test.rflx:16:10
      Messages.Msg_LE_Nested.Verify_Message (Ctx.P.In_Msg_Ctx);
      if Messages.Msg_LE_Nested.Byte_Size (Ctx.P.In_Msg_Ctx) > 0 then
         Ctx.P.Next_State := S_Copy;
      else
         Ctx.P.Next_State := S_Final;
      end if;
      pragma Assert (Start_Invariant);
   end Start;

   procedure Copy (Ctx : in out Context'Class) with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      function Copy_Invariant return Boolean is
        (Ctx.P.Slots.Slot_Ptr_1 = null
         and Ctx.P.Slots.Slot_Ptr_2 = null
         and Ctx.P.Slots.Slot_Ptr_3 = null
         and Ctx.P.Slots.Slot_Ptr_4 = null)
       with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      pragma Assert (Copy_Invariant);
      -- tests/feature/session_endianness/test.rflx:25:10
      Messages.Msg_LE.Reset (Ctx.P.Out_Msg_Ctx);
      pragma Assert (Messages.Msg_LE.Sufficient_Space (Ctx.P.Out_Msg_Ctx, Messages.Msg_LE.F_C));
      Messages.Msg_LE.Set_C (Ctx.P.Out_Msg_Ctx, Messages.Msg_LE_Nested.Get_X_A (Ctx.P.In_Msg_Ctx));
      pragma Assert (Messages.Msg_LE.Sufficient_Space (Ctx.P.Out_Msg_Ctx, Messages.Msg_LE.F_D));
      Messages.Msg_LE.Set_D (Ctx.P.Out_Msg_Ctx, Messages.Msg_LE_Nested.Get_X_B (Ctx.P.In_Msg_Ctx));
      Ctx.P.Next_State := S_Reply;
      pragma Assert (Copy_Invariant);
   end Copy;

   procedure Reply (Ctx : in out Context'Class) with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      function Reply_Invariant return Boolean is
        (Ctx.P.Slots.Slot_Ptr_1 = null
         and Ctx.P.Slots.Slot_Ptr_2 = null
         and Ctx.P.Slots.Slot_Ptr_3 = null
         and Ctx.P.Slots.Slot_Ptr_4 = null)
       with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      pragma Assert (Reply_Invariant);
      -- tests/feature/session_endianness/test.rflx:34:10
      Ctx.P.Next_State := S_Read2;
      pragma Assert (Reply_Invariant);
   end Reply;

   procedure Read2 (Ctx : in out Context'Class) with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      function Read2_Invariant return Boolean is
        (Ctx.P.Slots.Slot_Ptr_1 = null
         and Ctx.P.Slots.Slot_Ptr_2 = null
         and Ctx.P.Slots.Slot_Ptr_3 = null
         and Ctx.P.Slots.Slot_Ptr_4 = null)
       with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      pragma Assert (Read2_Invariant);
      -- tests/feature/session_endianness/test.rflx:41:10
      Messages.Msg_LE.Verify_Message (Ctx.P.In_Msg2_Ctx);
      if Messages.Msg_LE.Byte_Size (Ctx.P.In_Msg2_Ctx) > 0 then
         Ctx.P.Next_State := S_Copy2;
      else
         Ctx.P.Next_State := S_Final;
      end if;
      pragma Assert (Read2_Invariant);
   end Read2;

   procedure Copy2 (Ctx : in out Context'Class) with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      function Copy2_Invariant return Boolean is
        (Ctx.P.Slots.Slot_Ptr_1 = null
         and Ctx.P.Slots.Slot_Ptr_2 = null
         and Ctx.P.Slots.Slot_Ptr_3 = null
         and Ctx.P.Slots.Slot_Ptr_4 = null)
       with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      pragma Assert (Copy2_Invariant);
      -- tests/feature/session_endianness/test.rflx:50:10
      Messages.Msg.Reset (Ctx.P.Out_Msg2_Ctx);
      pragma Assert (Messages.Msg.Sufficient_Space (Ctx.P.Out_Msg2_Ctx, Messages.Msg.F_A));
      Messages.Msg.Set_A (Ctx.P.Out_Msg2_Ctx, Messages.Msg_LE.Get_C (Ctx.P.In_Msg2_Ctx));
      pragma Assert (Messages.Msg.Sufficient_Space (Ctx.P.Out_Msg2_Ctx, Messages.Msg.F_B));
      Messages.Msg.Set_B (Ctx.P.Out_Msg2_Ctx, Messages.Msg_LE.Get_D (Ctx.P.In_Msg2_Ctx));
      Ctx.P.Next_State := S_Reply2;
      pragma Assert (Copy2_Invariant);
   end Copy2;

   procedure Reply2 (Ctx : in out Context'Class) with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
      function Reply2_Invariant return Boolean is
        (Ctx.P.Slots.Slot_Ptr_1 = null
         and Ctx.P.Slots.Slot_Ptr_2 = null
         and Ctx.P.Slots.Slot_Ptr_3 = null
         and Ctx.P.Slots.Slot_Ptr_4 = null)
       with
        Annotate =>
          (GNATprove, Inline_For_Proof),
        Ghost;
   begin
      pragma Assert (Reply2_Invariant);
      -- tests/feature/session_endianness/test.rflx:59:10
      Ctx.P.Next_State := S_Start;
      pragma Assert (Reply2_Invariant);
   end Reply2;

   procedure Initialize (Ctx : in out Context'Class) is
      In_Msg_Buffer : RFLX_Types.Bytes_Ptr;
      In_Msg2_Buffer : RFLX_Types.Bytes_Ptr;
      Out_Msg_Buffer : RFLX_Types.Bytes_Ptr;
      Out_Msg2_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      Test.Session_Allocator.Initialize (Ctx.P.Slots, Ctx.P.Memory);
      In_Msg_Buffer := Ctx.P.Slots.Slot_Ptr_1;
      pragma Warnings (Off, "unused assignment");
      Ctx.P.Slots.Slot_Ptr_1 := null;
      pragma Warnings (On, "unused assignment");
      Messages.Msg_LE_Nested.Initialize (Ctx.P.In_Msg_Ctx, In_Msg_Buffer);
      In_Msg2_Buffer := Ctx.P.Slots.Slot_Ptr_2;
      pragma Warnings (Off, "unused assignment");
      Ctx.P.Slots.Slot_Ptr_2 := null;
      pragma Warnings (On, "unused assignment");
      Messages.Msg_LE.Initialize (Ctx.P.In_Msg2_Ctx, In_Msg2_Buffer);
      Out_Msg_Buffer := Ctx.P.Slots.Slot_Ptr_3;
      pragma Warnings (Off, "unused assignment");
      Ctx.P.Slots.Slot_Ptr_3 := null;
      pragma Warnings (On, "unused assignment");
      Messages.Msg_LE.Initialize (Ctx.P.Out_Msg_Ctx, Out_Msg_Buffer);
      Out_Msg2_Buffer := Ctx.P.Slots.Slot_Ptr_4;
      pragma Warnings (Off, "unused assignment");
      Ctx.P.Slots.Slot_Ptr_4 := null;
      pragma Warnings (On, "unused assignment");
      Messages.Msg.Initialize (Ctx.P.Out_Msg2_Ctx, Out_Msg2_Buffer);
      Ctx.P.Next_State := S_Start;
   end Initialize;

   procedure Finalize (Ctx : in out Context'Class) is
      In_Msg_Buffer : RFLX_Types.Bytes_Ptr;
      In_Msg2_Buffer : RFLX_Types.Bytes_Ptr;
      Out_Msg_Buffer : RFLX_Types.Bytes_Ptr;
      Out_Msg2_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      pragma Warnings (Off, """Ctx.P.In_Msg_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Messages.Msg_LE_Nested.Take_Buffer (Ctx.P.In_Msg_Ctx, In_Msg_Buffer);
      pragma Warnings (On, """Ctx.P.In_Msg_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Assert (Ctx.P.Slots.Slot_Ptr_1 = null);
      pragma Assert (In_Msg_Buffer /= null);
      Ctx.P.Slots.Slot_Ptr_1 := In_Msg_Buffer;
      pragma Assert (Ctx.P.Slots.Slot_Ptr_1 /= null);
      pragma Warnings (Off, """Ctx.P.In_Msg2_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Messages.Msg_LE.Take_Buffer (Ctx.P.In_Msg2_Ctx, In_Msg2_Buffer);
      pragma Warnings (On, """Ctx.P.In_Msg2_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Assert (Ctx.P.Slots.Slot_Ptr_2 = null);
      pragma Assert (In_Msg2_Buffer /= null);
      Ctx.P.Slots.Slot_Ptr_2 := In_Msg2_Buffer;
      pragma Assert (Ctx.P.Slots.Slot_Ptr_2 /= null);
      pragma Warnings (Off, """Ctx.P.Out_Msg_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Messages.Msg_LE.Take_Buffer (Ctx.P.Out_Msg_Ctx, Out_Msg_Buffer);
      pragma Warnings (On, """Ctx.P.Out_Msg_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Assert (Ctx.P.Slots.Slot_Ptr_3 = null);
      pragma Assert (Out_Msg_Buffer /= null);
      Ctx.P.Slots.Slot_Ptr_3 := Out_Msg_Buffer;
      pragma Assert (Ctx.P.Slots.Slot_Ptr_3 /= null);
      pragma Warnings (Off, """Ctx.P.Out_Msg2_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Messages.Msg.Take_Buffer (Ctx.P.Out_Msg2_Ctx, Out_Msg2_Buffer);
      pragma Warnings (On, """Ctx.P.Out_Msg2_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Assert (Ctx.P.Slots.Slot_Ptr_4 = null);
      pragma Assert (Out_Msg2_Buffer /= null);
      Ctx.P.Slots.Slot_Ptr_4 := Out_Msg2_Buffer;
      pragma Assert (Ctx.P.Slots.Slot_Ptr_4 /= null);
      Test.Session_Allocator.Finalize (Ctx.P.Slots);
      Ctx.P.Next_State := S_Final;
   end Finalize;

   procedure Reset_Messages_Before_Write (Ctx : in out Context'Class) with
     Pre =>
       Initialized (Ctx),
     Post =>
       Initialized (Ctx)
   is
   begin
      case Ctx.P.Next_State is
         when S_Start =>
            Messages.Msg_LE_Nested.Reset (Ctx.P.In_Msg_Ctx, Ctx.P.In_Msg_Ctx.First, Ctx.P.In_Msg_Ctx.First - 1);
         when S_Copy | S_Reply =>
            null;
         when S_Read2 =>
            Messages.Msg_LE.Reset (Ctx.P.In_Msg2_Ctx, Ctx.P.In_Msg2_Ctx.First, Ctx.P.In_Msg2_Ctx.First - 1);
         when S_Copy2 | S_Reply2 | S_Final =>
            null;
      end case;
   end Reset_Messages_Before_Write;

   procedure Tick (Ctx : in out Context'Class) is
   begin
      case Ctx.P.Next_State is
         when S_Start =>
            Start (Ctx);
         when S_Copy =>
            Copy (Ctx);
         when S_Reply =>
            Reply (Ctx);
         when S_Read2 =>
            Read2 (Ctx);
         when S_Copy2 =>
            Copy2 (Ctx);
         when S_Reply2 =>
            Reply2 (Ctx);
         when S_Final =>
            null;
      end case;
      Reset_Messages_Before_Write (Ctx);
   end Tick;

   function In_IO_State (Ctx : Context'Class) return Boolean is
     (Ctx.P.Next_State in S_Start | S_Reply | S_Read2 | S_Reply2);

   procedure Run (Ctx : in out Context'Class) is
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

   procedure Read (Ctx : Context'Class; Chan : Channel; Buffer : out RFLX_Types.Bytes; Offset : RFLX_Types.Length := 0) is
      function Read_Pre (Message_Buffer : RFLX_Types.Bytes) return Boolean is
        (Buffer'Length > 0
         and then Offset < Message_Buffer'Length);
      procedure Read (Message_Buffer : RFLX_Types.Bytes) with
        Pre =>
          Read_Pre (Message_Buffer)
      is
         Length : constant RFLX_Types.Index := RFLX_Types.Index (RFLX_Types.Length'Min (Buffer'Length, Message_Buffer'Length - Offset));
         Buffer_Last : constant RFLX_Types.Index := Buffer'First - 1 + Length;
      begin
         Buffer (Buffer'First .. RFLX_Types.Index (Buffer_Last)) := Message_Buffer (RFLX_Types.Index (RFLX_Types.Length (Message_Buffer'First) + Offset) .. Message_Buffer'First - 2 + RFLX_Types.Index (Offset + 1) + Length);
      end Read;
      procedure Messages_Msg_Read is new Messages.Msg.Generic_Read (Read, Read_Pre);
      procedure Messages_Msg_LE_Read is new Messages.Msg_LE.Generic_Read (Read, Read_Pre);
   begin
      Buffer := (others => 0);
      case Chan is
         when C_I =>
            pragma Warnings (Off, "unreachable code");
            null;
            pragma Warnings (On, "unreachable code");
         when C_O =>
            case Ctx.P.Next_State is
               when S_Reply =>
                  Messages_Msg_LE_Read (Ctx.P.Out_Msg_Ctx);
               when S_Reply2 =>
                  Messages_Msg_Read (Ctx.P.Out_Msg2_Ctx);
               when others =>
                  pragma Warnings (Off, "unreachable code");
                  null;
                  pragma Warnings (On, "unreachable code");
            end case;
      end case;
   end Read;

   procedure Write (Ctx : in out Context'Class; Chan : Channel; Buffer : RFLX_Types.Bytes; Offset : RFLX_Types.Length := 0) is
      Write_Buffer_Length : constant RFLX_Types.Length := Write_Buffer_Size (Ctx, Chan);
      function Write_Pre (Context_Buffer_Length : RFLX_Types.Length; Offset : RFLX_Types.Length) return Boolean is
        (Buffer'Length > 0
         and then Context_Buffer_Length = Write_Buffer_Length
         and then Offset <= RFLX_Types.Length'Last - Buffer'Length
         and then Buffer'Length + Offset <= Write_Buffer_Length);
      procedure Write (Message_Buffer : out RFLX_Types.Bytes; Length : out RFLX_Types.Length; Context_Buffer_Length : RFLX_Types.Length; Offset : RFLX_Types.Length) with
        Pre =>
          Write_Pre (Context_Buffer_Length, Offset)
          and then Offset <= RFLX_Types.Length'Last - Message_Buffer'Length
          and then Message_Buffer'Length + Offset = Write_Buffer_Length,
        Post =>
          Length <= Message_Buffer'Length
      is
      begin
         Length := Buffer'Length;
         Message_Buffer := (others => 0);
         Message_Buffer (Message_Buffer'First .. RFLX_Types.Index (RFLX_Types.Length (Message_Buffer'First) - 1 + Length)) := Buffer;
      end Write;
      procedure Messages_Msg_LE_Write is new Messages.Msg_LE.Generic_Write (Write, Write_Pre);
      procedure Messages_Msg_LE_Nested_Write is new Messages.Msg_LE_Nested.Generic_Write (Write, Write_Pre);
   begin
      case Chan is
         when C_I =>
            case Ctx.P.Next_State is
               when S_Start =>
                  Messages_Msg_LE_Nested_Write (Ctx.P.In_Msg_Ctx, Offset);
               when S_Read2 =>
                  Messages_Msg_LE_Write (Ctx.P.In_Msg2_Ctx, Offset);
               when others =>
                  pragma Warnings (Off, "unreachable code");
                  null;
                  pragma Warnings (On, "unreachable code");
            end case;
         when C_O =>
            pragma Warnings (Off, "unreachable code");
            null;
            pragma Warnings (On, "unreachable code");
      end case;
   end Write;

end RFLX.Test.Session;
