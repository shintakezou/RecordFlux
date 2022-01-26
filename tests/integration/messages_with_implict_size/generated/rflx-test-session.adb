pragma Style_Checks ("N3aAbcdefhiIklnOprStux");
pragma Warnings (Off, "redundant conversion");
with RFLX.RFLX_Types;
use type RFLX.RFLX_Types.Bit_Length;

package body RFLX.Test.Session with
  SPARK_Mode
is

   procedure Start (P_Next_State : out State) with
     Pre =>
       Initialized,
     Post =>
       Initialized
   is
   begin
      Universal.Message.Verify_Message (M_R_Ctx);
      P_Next_State := S_Process;
   end Start;

   procedure Process (P_Next_State : out State) with
     Pre =>
       Initialized,
     Post =>
       Initialized
   is
   begin
      if
         Universal.Message.Size (M_R_Ctx) <= 32768
         and then Universal.Message.Size (M_R_Ctx) mod RFLX_Types.Byte'Size = 0
      then
         if RFLX_Types.To_First_Bit_Index (M_S_Ctx.Buffer_Last) - RFLX_Types.To_First_Bit_Index (M_S_Ctx.Buffer_First) + 1 >= Universal.Message.Field_Size (M_R_Ctx, Universal.Message.F_Data) + 8 then
            Universal.Message.Reset (M_S_Ctx, RFLX_Types.To_First_Bit_Index (M_S_Ctx.Buffer_First), RFLX_Types.To_First_Bit_Index (M_S_Ctx.Buffer_First) + (Universal.Message.Field_Size (M_R_Ctx, Universal.Message.F_Data) + 8) - 1);
            Universal.Message.Set_Message_Type (M_S_Ctx, Universal.MT_Unconstrained_Data);
            if Universal.Message.Valid_Next (M_R_Ctx, Universal.Message.F_Data) then
               if Universal.Message.Valid_Length (M_S_Ctx, Universal.Message.F_Data, RFLX_Types.To_Length (Universal.Message.Field_Size (M_R_Ctx, Universal.Message.F_Data))) then
                  if Universal.Message.Structural_Valid (M_R_Ctx, Universal.Message.F_Data) then
                     declare
                        function RFLX_Process_Data_Pre (Length : RFLX_Types.Length) return Boolean is
                          (Universal.Message.Has_Buffer (M_R_Ctx)
                           and then Universal.Message.Structural_Valid (M_R_Ctx, Universal.Message.F_Data)
                           and then Length >= RFLX_Types.To_Length (Universal.Message.Field_Size (M_R_Ctx, Universal.Message.F_Data)));
                        procedure RFLX_Process_Data (Data : out RFLX_Types.Bytes) with
                          Pre =>
                            RFLX_Process_Data_Pre (Data'Length)
                        is
                        begin
                           Universal.Message.Get_Data (M_R_Ctx, Data);
                        end RFLX_Process_Data;
                        procedure RFLX_Universal_Message_Set_Data is new Universal.Message.Generic_Set_Data (RFLX_Process_Data, RFLX_Process_Data_Pre);
                     begin
                        RFLX_Universal_Message_Set_Data (M_S_Ctx, RFLX_Types.To_Length (Universal.Message.Field_Size (M_R_Ctx, Universal.Message.F_Data)));
                     end;
                  else
                     P_Next_State := S_Terminated;
                     return;
                  end if;
               else
                  P_Next_State := S_Terminated;
                  return;
               end if;
            else
               P_Next_State := S_Terminated;
               return;
            end if;
         else
            P_Next_State := S_Terminated;
            return;
         end if;
      else
         P_Next_State := S_Terminated;
         return;
      end if;
      P_Next_State := S_Reply;
   end Process;

   procedure Reply (P_Next_State : out State) with
     Pre =>
       Initialized,
     Post =>
       Initialized
   is
   begin
      P_Next_State := S_Terminated;
   end Reply;

   procedure Initialize is
      M_R_Buffer : RFLX_Types.Bytes_Ptr;
      M_S_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      Test.Session_Allocator.Initialize;
      M_R_Buffer := Test.Session_Allocator.Slot_Ptr_1;
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_1 := null;
      pragma Warnings (On, "unused assignment");
      Universal.Message.Initialize (M_R_Ctx, M_R_Buffer);
      M_S_Buffer := Test.Session_Allocator.Slot_Ptr_2;
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_2 := null;
      pragma Warnings (On, "unused assignment");
      Universal.Message.Initialize (M_S_Ctx, M_S_Buffer);
      P_Next_State := S_Start;
   end Initialize;

   procedure Finalize is
      M_R_Buffer : RFLX_Types.Bytes_Ptr;
      M_S_Buffer : RFLX_Types.Bytes_Ptr;
   begin
      pragma Warnings (Off, "unused assignment to ""M_R_Ctx""");
      pragma Warnings (Off, """M_R_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Universal.Message.Take_Buffer (M_R_Ctx, M_R_Buffer);
      pragma Warnings (On, """M_R_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Warnings (On, "unused assignment to ""M_R_Ctx""");
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_1 := M_R_Buffer;
      pragma Warnings (On, "unused assignment");
      pragma Warnings (Off, "unused assignment to ""M_S_Ctx""");
      pragma Warnings (Off, """M_S_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      Universal.Message.Take_Buffer (M_S_Ctx, M_S_Buffer);
      pragma Warnings (On, """M_S_Ctx"" is set by ""Take_Buffer"" but not used after the call");
      pragma Warnings (On, "unused assignment to ""M_S_Ctx""");
      pragma Warnings (Off, "unused assignment");
      Test.Session_Allocator.Slot_Ptr_2 := M_S_Buffer;
      pragma Warnings (On, "unused assignment");
      P_Next_State := S_Terminated;
   end Finalize;

   procedure Reset_Messages_Before_Write with
     Pre =>
       Initialized,
     Post =>
       Initialized
   is
   begin
      case P_Next_State is
         when S_Start =>
            Universal.Message.Reset (M_R_Ctx, M_R_Ctx.First, M_R_Ctx.First - 1);
         when S_Process | S_Reply | S_Terminated =>
            null;
      end case;
   end Reset_Messages_Before_Write;

   procedure Tick is
   begin
      case P_Next_State is
         when S_Start =>
            Start (P_Next_State);
         when S_Process =>
            Process (P_Next_State);
         when S_Reply =>
            Reply (P_Next_State);
         when S_Terminated =>
            null;
      end case;
      Reset_Messages_Before_Write;
   end Tick;

   function In_IO_State return Boolean is
     (P_Next_State in S_Start | S_Reply);

   procedure Run is
   begin
      Tick;
      while
         Active
         and not In_IO_State
      loop
         pragma Loop_Invariant (Initialized);
         Tick;
      end loop;
   end Run;

   function Has_Data (Chan : Channel) return Boolean is
     ((case Chan is
          when C_Channel =>
             (case P_Next_State is
                 when S_Reply =>
                    Universal.Message.Structural_Valid_Message (M_S_Ctx)
                    and Universal.Message.Byte_Size (M_S_Ctx) > 0,
                 when others =>
                    False)));

   function Read_Buffer_Size (Chan : Channel) return RFLX_Types.Length is
     ((case Chan is
          when C_Channel =>
             (case P_Next_State is
                 when S_Reply =>
                    Universal.Message.Byte_Size (M_S_Ctx),
                 when others =>
                    raise Program_Error)));

   procedure Read (Chan : Channel; Buffer : out RFLX_Types.Bytes; Offset : RFLX_Types.Length := 0) is
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
      procedure Universal_Message_Read is new Universal.Message.Generic_Read (Read, Read_Pre);
   begin
      Buffer := (others => 0);
      case Chan is
         when C_Channel =>
            case P_Next_State is
               when S_Reply =>
                  Universal_Message_Read (M_S_Ctx);
               when others =>
                  raise Program_Error;
            end case;
      end case;
   end Read;

   function Needs_Data (Chan : Channel) return Boolean is
     ((case Chan is
          when C_Channel =>
             (case P_Next_State is
                 when S_Start =>
                    True,
                 when others =>
                    False)));

   function Write_Buffer_Size (Chan : Channel) return RFLX_Types.Length is
     ((case Chan is
          when C_Channel =>
             4096));

   procedure Write (Chan : Channel; Buffer : RFLX_Types.Bytes; Offset : RFLX_Types.Length := 0) is
      function Write_Pre (Context_Buffer_Length : RFLX_Types.Length; Offset : RFLX_Types.Length) return Boolean is
        (Buffer'Length > 0
         and then Context_Buffer_Length = Write_Buffer_Size (Chan)
         and then Offset <= RFLX_Types.Length'Last - Buffer'Length
         and then Buffer'Length + Offset <= Write_Buffer_Size (Chan));
      procedure Write (Message_Buffer : out RFLX_Types.Bytes; Length : out RFLX_Types.Length; Context_Buffer_Length : RFLX_Types.Length; Offset : RFLX_Types.Length) with
        Pre =>
          Write_Pre (Context_Buffer_Length, Offset)
          and then Offset <= RFLX_Types.Length'Last - Message_Buffer'Length
          and then Message_Buffer'Length + Offset = Write_Buffer_Size (Chan),
        Post =>
          Length <= Message_Buffer'Length
      is
      begin
         Length := Buffer'Length;
         Message_Buffer := (others => 0);
         Message_Buffer (Message_Buffer'First .. RFLX_Types.Index (RFLX_Types.Length (Message_Buffer'First) - 1 + Length)) := Buffer;
      end Write;
      procedure Universal_Message_Write is new Universal.Message.Generic_Write (Write, Write_Pre);
   begin
      case Chan is
         when C_Channel =>
            case P_Next_State is
               when S_Start =>
                  Universal_Message_Write (M_R_Ctx, Offset);
               when others =>
                  raise Program_Error;
            end case;
      end case;
   end Write;

end RFLX.Test.Session;
