pragma Style_Checks ("N3aAbcdefhiIklnOprStux");
pragma Warnings (Off, "redundant conversion");
with RFLX.Universal;
with RFLX.Universal.Message;
with RFLX.RFLX_Types;
use type RFLX.RFLX_Types.Index;
use type RFLX.Universal.Value;
use type RFLX.RFLX_Types.Bit_Length;

package body RFLX.Test.Session with
  SPARK_Mode
is

   procedure Start (Next_State : out Session_State) with
     Pre =>
       Initialized,
     Post =>
       Initialized
   is
      Message_Ctx : Universal.Message.Context;
      Local : Universal.Value := 2;
      Message_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      Message_Buffer := Test.Session_Allocator.Slot_Ptr_1;
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_1 := null;
      pragma Warnings (On, "unused assignment");
      Universal.Message.Initialize (Message_Ctx, Message_Buffer);
      declare
         procedure Universal_Message_Write is new Universal.Message.Write (Channel_Read);
      begin
         Universal_Message_Write (Message_Ctx);
      end;
      Universal.Message.Verify_Message (Message_Ctx);
      if Universal.Message.Valid (Message_Ctx, Universal.Message.F_Value) then
         Local := Local + Universal.Message.Get_Value (Message_Ctx);
      else
         Next_State := S_Terminated;
         pragma Warnings (Off, "unused assignment to ""Message_Ctx""");
         pragma Warnings (Off, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
         Universal.Message.Take_Buffer (Message_Ctx, Message_Buffer);
         pragma Warnings (On, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
         pragma Warnings (On, "unused assignment to ""Message_Ctx""");
         pragma Warnings (Off, "unused assignment");
         Test.Session_Allocator.Slot_Ptr_1 := Message_Buffer;
         pragma Warnings (On, "unused assignment");
         return;
      end if;
      Global := Local + 20;
      if Local < Global then
         Next_State := S_Reply;
      else
         Next_State := S_Terminated;
      end if;
      pragma Warnings (Off, "unused assignment to ""Message_Ctx""");
      pragma Warnings (Off, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Universal.Message.Take_Buffer (Message_Ctx, Message_Buffer);
      pragma Warnings (On, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Warnings (On, "unused assignment to ""Message_Ctx""");
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_1 := Message_Buffer;
      pragma Warnings (On, "unused assignment");
   end Start;

   procedure Reply (Next_State : out Session_State) with
     Pre =>
       Initialized,
     Post =>
       Initialized
   is
      Message_Ctx : Universal.Message.Context;
      Message_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      Message_Buffer := Test.Session_Allocator.Slot_Ptr_1;
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_1 := null;
      pragma Warnings (On, "unused assignment");
      Universal.Message.Initialize (Message_Ctx, Message_Buffer);
      if Message_Ctx.Last - Message_Ctx.First + 1 >= RFLX_Types.Bit_Length (32) then
         Universal.Message.Reset (Message_Ctx, RFLX_Types.To_First_Bit_Index (Message_Ctx.Buffer_First), RFLX_Types.To_First_Bit_Index (Message_Ctx.Buffer_First) + RFLX_Types.Bit_Length (32) - 1);
         Universal.Message.Set_Message_Type (Message_Ctx, Universal.MT_Value);
         Universal.Message.Set_Length (Message_Ctx, Universal.Length (Universal.Value'Size / 8));
         Universal.Message.Set_Value (Message_Ctx, Global);
      else
         Next_State := S_Terminated;
         pragma Warnings (Off, "unused assignment to ""Message_Ctx""");
         pragma Warnings (Off, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
         Universal.Message.Take_Buffer (Message_Ctx, Message_Buffer);
         pragma Warnings (On, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
         pragma Warnings (On, "unused assignment to ""Message_Ctx""");
         pragma Warnings (Off, "unused assignment");
         Test.Session_Allocator.Slot_Ptr_1 := Message_Buffer;
         pragma Warnings (On, "unused assignment");
         return;
      end if;
      if Universal.Message.Structural_Valid_Message (Message_Ctx) then
         declare
            procedure Universal_Message_Read is new Universal.Message.Read (Channel_Write);
         begin
            Universal_Message_Read (Message_Ctx);
         end;
      else
         Next_State := S_Terminated;
         pragma Warnings (Off, "unused assignment to ""Message_Ctx""");
         pragma Warnings (Off, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
         Universal.Message.Take_Buffer (Message_Ctx, Message_Buffer);
         pragma Warnings (On, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
         pragma Warnings (On, "unused assignment to ""Message_Ctx""");
         pragma Warnings (Off, "unused assignment");
         Test.Session_Allocator.Slot_Ptr_1 := Message_Buffer;
         pragma Warnings (On, "unused assignment");
         return;
      end if;
      Next_State := S_Terminated;
      pragma Warnings (Off, "unused assignment to ""Message_Ctx""");
      pragma Warnings (Off, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Universal.Message.Take_Buffer (Message_Ctx, Message_Buffer);
      pragma Warnings (On, """Message_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Warnings (On, "unused assignment to ""Message_Ctx""");
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_1 := Message_Buffer;
      pragma Warnings (On, "unused assignment");
   end Reply;

   procedure Initialize is
   begin
      Test.Session_Allocator.Initialize;
      Next_State := S_Start;
   end Initialize;

   procedure Finalize is
   begin
      Next_State := S_Terminated;
   end Finalize;

   procedure Tick is
   begin
      case Next_State is
         when S_Start =>
            Start (Next_State);
         when S_Reply =>
            Reply (Next_State);
         when S_Terminated =>
            null;
      end case;
   end Tick;

   procedure Run is
   begin
      Initialize;
      while Active loop
         pragma Loop_Invariant (Initialized);
         Tick;
      end loop;
      Finalize;
   end Run;

end RFLX.Test.Session;
