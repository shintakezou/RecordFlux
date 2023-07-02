pragma Style_Checks ("N3aAbCdefhiIklnOprStux");
pragma Warnings (Off, "redundant conversion");
with RFLX.RFLX_Types;
with RFLX.Sequence.Integer_Vector;
with RFLX.Sequence.Enumeration_Vector;
with RFLX.Sequence.AV_Enumeration_Vector;

package RFLX.Sequence.Message with
  SPARK_Mode,
  Always_Terminates
is

   pragma Warnings (Off, "use clause for type ""Base_Integer"" * has no effect");

   pragma Warnings (Off, "use clause for type ""Bytes"" * has no effect");

   pragma Warnings (Off, """BASE_INTEGER"" is already use-visible through previous use_type_clause");

   pragma Warnings (Off, """LENGTH"" is already use-visible through previous use_type_clause");

   use type RFLX_Types.Bytes;

   use type RFLX_Types.Byte;

   use type RFLX_Types.Bytes_Ptr;

   use type RFLX_Types.Length;

   use type RFLX_Types.Index;

   use type RFLX_Types.Bit_Index;

   use type RFLX_Types.Base_Integer;

   use type RFLX_Types.Offset;

   pragma Warnings (On, """LENGTH"" is already use-visible through previous use_type_clause");

   pragma Warnings (On, """BASE_INTEGER"" is already use-visible through previous use_type_clause");

   pragma Warnings (On, "use clause for type ""Base_Integer"" * has no effect");

   pragma Warnings (On, "use clause for type ""Bytes"" * has no effect");

   pragma Unevaluated_Use_Of_Old (Allow);

   type Virtual_Field is (F_Initial, F_Length, F_Integer_Vector, F_Enumeration_Vector, F_AV_Enumeration_Vector, F_Final);

   subtype Field is Virtual_Field range F_Length .. F_AV_Enumeration_Vector;

   type Field_Cursor is private;

   type Field_Cursors is private;

   type Context (Buffer_First, Buffer_Last : RFLX_Types.Index := RFLX_Types.Index'First; First : RFLX_Types.Bit_Index := RFLX_Types.Bit_Index'First; Last : RFLX_Types.Bit_Length := RFLX_Types.Bit_Length'First) is private with
     Default_Initial_Condition =>
       RFLX_Types.To_Index (First) >= Buffer_First
       and RFLX_Types.To_Index (Last) <= Buffer_Last
       and Buffer_Last < RFLX_Types.Index'Last
       and First <= Last + 1
       and Last < RFLX_Types.Bit_Index'Last
       and First rem RFLX_Types.Byte'Size = 1
       and Last rem RFLX_Types.Byte'Size = 0;

   procedure Initialize (Ctx : out Context; Buffer : in out RFLX_Types.Bytes_Ptr; Written_Last : RFLX_Types.Bit_Length := 0) with
     Pre =>
       not Ctx'Constrained
       and then Buffer /= null
       and then Buffer'Length > 0
       and then Buffer'Last < RFLX_Types.Index'Last
       and then (Written_Last = 0
                 or (Written_Last >= RFLX_Types.To_First_Bit_Index (Buffer'First) - 1
                     and Written_Last <= RFLX_Types.To_Last_Bit_Index (Buffer'Last)))
       and then Written_Last mod RFLX_Types.Byte'Size = 0,
     Post =>
       Has_Buffer (Ctx)
       and Buffer = null
       and Ctx.Buffer_First = Buffer'First'Old
       and Ctx.Buffer_Last = Buffer'Last'Old
       and Ctx.First = RFLX_Types.To_First_Bit_Index (Ctx.Buffer_First)
       and Ctx.Last = RFLX_Types.To_Last_Bit_Index (Ctx.Buffer_Last)
       and Initialized (Ctx),
     Depends =>
       (Ctx => (Buffer, Written_Last), Buffer => null);

   procedure Initialize (Ctx : out Context; Buffer : in out RFLX_Types.Bytes_Ptr; First : RFLX_Types.Bit_Index; Last : RFLX_Types.Bit_Length; Written_Last : RFLX_Types.Bit_Length := 0) with
     Pre =>
       not Ctx'Constrained
       and then Buffer /= null
       and then Buffer'Length > 0
       and then Buffer'Last < RFLX_Types.Index'Last
       and then RFLX_Types.To_Index (First) >= Buffer'First
       and then RFLX_Types.To_Index (Last) <= Buffer'Last
       and then First <= Last + 1
       and then Last < RFLX_Types.Bit_Index'Last
       and then First rem RFLX_Types.Byte'Size = 1
       and then Last rem RFLX_Types.Byte'Size = 0
       and then (Written_Last = 0
                 or (Written_Last >= First - 1
                     and Written_Last <= Last))
       and then Written_Last rem RFLX_Types.Byte'Size = 0,
     Post =>
       Buffer = null
       and Has_Buffer (Ctx)
       and Ctx.Buffer_First = Buffer'First'Old
       and Ctx.Buffer_Last = Buffer'Last'Old
       and Ctx.First = First
       and Ctx.Last = Last
       and Initialized (Ctx),
     Depends =>
       (Ctx => (Buffer, First, Last, Written_Last), Buffer => null);

   pragma Warnings (Off, "postcondition does not mention function result");

   function Initialized (Ctx : Context) return Boolean with
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   procedure Reset (Ctx : in out Context) with
     Pre =>
       not Ctx'Constrained
       and RFLX.Sequence.Message.Has_Buffer (Ctx),
     Post =>
       Has_Buffer (Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = RFLX_Types.To_First_Bit_Index (Ctx.Buffer_First)
       and Ctx.Last = RFLX_Types.To_Last_Bit_Index (Ctx.Buffer_Last)
       and Initialized (Ctx);

   procedure Reset (Ctx : in out Context; First : RFLX_Types.Bit_Index; Last : RFLX_Types.Bit_Length) with
     Pre =>
       not Ctx'Constrained
       and RFLX.Sequence.Message.Has_Buffer (Ctx)
       and RFLX_Types.To_Index (First) >= Ctx.Buffer_First
       and RFLX_Types.To_Index (Last) <= Ctx.Buffer_Last
       and First <= Last + 1
       and Last < RFLX_Types.Bit_Length'Last
       and First rem RFLX_Types.Byte'Size = 1
       and Last rem RFLX_Types.Byte'Size = 0,
     Post =>
       Has_Buffer (Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = First
       and Ctx.Last = Last
       and Initialized (Ctx);

   procedure Take_Buffer (Ctx : in out Context; Buffer : out RFLX_Types.Bytes_Ptr) with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx),
     Post =>
       not Has_Buffer (Ctx)
       and Buffer /= null
       and Ctx.Buffer_First = Buffer'First
       and Ctx.Buffer_Last = Buffer'Last
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Context_Cursors (Ctx) = Context_Cursors (Ctx)'Old,
     Depends =>
       (Ctx => Ctx, Buffer => Ctx);

   procedure Copy (Ctx : Context; Buffer : out RFLX_Types.Bytes) with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Well_Formed_Message (Ctx)
       and then RFLX.Sequence.Message.Byte_Size (Ctx) = Buffer'Length;

   function Read (Ctx : Context) return RFLX_Types.Bytes with
     Ghost,
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Well_Formed_Message (Ctx);

   pragma Warnings (Off, "formal parameter ""*"" is not referenced");

   pragma Warnings (Off, "unused variable ""*""");

   function Always_Valid (Buffer : RFLX_Types.Bytes) return Boolean is
     (True);

   pragma Warnings (On, "unused variable ""*""");

   pragma Warnings (On, "formal parameter ""*"" is not referenced");

   generic
      with procedure Read (Buffer : RFLX_Types.Bytes);
      with function Pre (Buffer : RFLX_Types.Bytes) return Boolean is Always_Valid;
   procedure Generic_Read (Ctx : Context) with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Well_Formed_Message (Ctx)
       and then Pre (Read (Ctx));

   pragma Warnings (Off, "formal parameter ""*"" is not referenced");

   pragma Warnings (Off, "unused variable ""*""");

   function Always_Valid (Context_Buffer_Length : RFLX_Types.Length; Offset : RFLX_Types.Length) return Boolean is
     (True);

   pragma Warnings (On, "unused variable ""*""");

   pragma Warnings (On, "formal parameter ""*"" is not referenced");

   generic
      with procedure Write (Buffer : out RFLX_Types.Bytes; Length : out RFLX_Types.Length; Context_Buffer_Length : RFLX_Types.Length; Offset : RFLX_Types.Length);
      with function Pre (Context_Buffer_Length : RFLX_Types.Length; Offset : RFLX_Types.Length) return Boolean is Always_Valid;
   procedure Generic_Write (Ctx : in out Context; Offset : RFLX_Types.Length := 0) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then Offset < RFLX.Sequence.Message.Buffer_Length (Ctx)
       and then Pre (RFLX.Sequence.Message.Buffer_Length (Ctx), Offset),
     Post =>
       Has_Buffer (Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = RFLX_Types.To_First_Bit_Index (Ctx.Buffer_First)
       and Initialized (Ctx);

   function Has_Buffer (Ctx : Context) return Boolean;

   function Buffer_Length (Ctx : Context) return RFLX_Types.Length with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx);

   function Size (Ctx : Context) return RFLX_Types.Bit_Length with
     Post =>
       Size'Result rem RFLX_Types.Byte'Size = 0;

   function Byte_Size (Ctx : Context) return RFLX_Types.Length;

   function Message_Last (Ctx : Context) return RFLX_Types.Bit_Length with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Well_Formed_Message (Ctx);

   function Written_Last (Ctx : Context) return RFLX_Types.Bit_Length;

   procedure Data (Ctx : Context; Data : out RFLX_Types.Bytes) with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Well_Formed_Message (Ctx)
       and then Data'Length = RFLX.Sequence.Message.Byte_Size (Ctx);

   pragma Warnings (Off, "postcondition does not mention function result");

   function Valid_Value (Fld : Field; Val : RFLX_Types.Base_Integer) return Boolean with
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   pragma Warnings (Off, "postcondition does not mention function result");

   function Field_Condition (Ctx : Context; Fld : Field) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, Fld)
       and then RFLX.Sequence.Message.Sufficient_Space (Ctx, Fld),
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   function Field_Size (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Length with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, Fld),
     Post =>
       (case Fld is
           when F_Integer_Vector | F_Enumeration_Vector | F_AV_Enumeration_Vector =>
              Field_Size'Result rem RFLX_Types.Byte'Size = 0,
           when others =>
              True);

   pragma Warnings (Off, "postcondition does not mention function result");

   function Field_First (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Index with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, Fld),
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   function Field_Last (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Length with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, Fld)
       and then RFLX.Sequence.Message.Sufficient_Space (Ctx, Fld),
     Post =>
       (case Fld is
           when F_Integer_Vector | F_Enumeration_Vector | F_AV_Enumeration_Vector =>
              Field_Last'Result rem RFLX_Types.Byte'Size = 0,
           when others =>
              True);

   function Valid_Next (Ctx : Context; Fld : Field) return Boolean;

   function Available_Space (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Length with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, Fld);

   function Sufficient_Space (Ctx : Context; Fld : Field) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, Fld);

   function Equal (Ctx : Context; Fld : Field; Data : RFLX_Types.Bytes) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx)
       and RFLX.Sequence.Message.Valid_Next (Ctx, Fld);

   procedure Verify (Ctx : in out Context; Fld : Field) with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx),
     Post =>
       Has_Buffer (Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old;

   procedure Verify_Message (Ctx : in out Context) with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx),
     Post =>
       Has_Buffer (Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old;

   function Present (Ctx : Context; Fld : Field) return Boolean;

   function Well_Formed (Ctx : Context; Fld : Field) return Boolean;

   function Valid (Ctx : Context; Fld : Field) return Boolean with
     Post =>
       (if Valid'Result then Well_Formed (Ctx, Fld) and Present (Ctx, Fld));

   function Incomplete (Ctx : Context; Fld : Field) return Boolean;

   function Invalid (Ctx : Context; Fld : Field) return Boolean;

   function Well_Formed_Message (Ctx : Context) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx);

   function Valid_Message (Ctx : Context) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Has_Buffer (Ctx);

   pragma Warnings (Off, "postcondition does not mention function result");

   function Incomplete_Message (Ctx : Context) return Boolean with
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   pragma Warnings (Off, "precondition is always False");

   function Get_Length (Ctx : Context) return RFLX.Sequence.Length with
     Pre =>
       RFLX.Sequence.Message.Valid (Ctx, RFLX.Sequence.Message.F_Length);

   pragma Warnings (On, "precondition is always False");

   pragma Warnings (Off, "postcondition does not mention function result");

   function Valid_Length (Ctx : Context; Fld : Field; Length : RFLX_Types.Length) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, Fld),
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   pragma Warnings (Off, "aspect ""*"" not enforced on inlined subprogram ""*""");

   procedure Set_Length (Ctx : in out Context; Val : RFLX.Sequence.Length) with
     Inline_Always,
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Length)
       and then RFLX.Sequence.Valid_Length (RFLX.Sequence.To_Base_Integer (Val))
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Length) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Length)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_Length),
     Post =>
       Has_Buffer (Ctx)
       and Valid (Ctx, F_Length)
       and Get_Length (Ctx) = Val
       and Invalid (Ctx, F_Integer_Vector)
       and Invalid (Ctx, F_Enumeration_Vector)
       and Invalid (Ctx, F_AV_Enumeration_Vector)
       and Valid_Next (Ctx, F_Integer_Vector)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Valid_Next (Ctx, F_Length) = Valid_Next (Ctx, F_Length)'Old
       and Field_First (Ctx, F_Length) = Field_First (Ctx, F_Length)'Old;

   pragma Warnings (On, "aspect ""*"" not enforced on inlined subprogram ""*""");

   procedure Set_Integer_Vector_Empty (Ctx : in out Context) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Integer_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Integer_Vector) = 0,
     Post =>
       Has_Buffer (Ctx)
       and Well_Formed (Ctx, F_Integer_Vector)
       and Invalid (Ctx, F_Enumeration_Vector)
       and Invalid (Ctx, F_AV_Enumeration_Vector)
       and Valid_Next (Ctx, F_Enumeration_Vector)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Valid_Next (Ctx, F_Integer_Vector) = Valid_Next (Ctx, F_Integer_Vector)'Old
       and Get_Length (Ctx) = Get_Length (Ctx)'Old
       and Field_First (Ctx, F_Integer_Vector) = Field_First (Ctx, F_Integer_Vector)'Old;

   procedure Set_Integer_Vector (Ctx : in out Context; Seq_Ctx : RFLX.Sequence.Integer_Vector.Context) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Integer_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Valid_Length (Ctx, RFLX.Sequence.Message.F_Integer_Vector, RFLX.Sequence.Integer_Vector.Byte_Size (Seq_Ctx))
       and then RFLX.Sequence.Integer_Vector.Has_Buffer (Seq_Ctx)
       and then RFLX.Sequence.Integer_Vector.Valid (Seq_Ctx),
     Post =>
       Has_Buffer (Ctx)
       and Well_Formed (Ctx, F_Integer_Vector)
       and Invalid (Ctx, F_Enumeration_Vector)
       and Invalid (Ctx, F_AV_Enumeration_Vector)
       and Valid_Next (Ctx, F_Enumeration_Vector)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Valid_Next (Ctx, F_Integer_Vector) = Valid_Next (Ctx, F_Integer_Vector)'Old
       and Get_Length (Ctx) = Get_Length (Ctx)'Old
       and Field_First (Ctx, F_Integer_Vector) = Field_First (Ctx, F_Integer_Vector)'Old
       and (if Field_Size (Ctx, F_Integer_Vector) > 0 then Present (Ctx, F_Integer_Vector));

   procedure Set_Enumeration_Vector (Ctx : in out Context; Seq_Ctx : RFLX.Sequence.Enumeration_Vector.Context) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector)
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector)
       and then RFLX.Sequence.Message.Valid_Length (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector, RFLX.Sequence.Enumeration_Vector.Byte_Size (Seq_Ctx))
       and then RFLX.Sequence.Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and then RFLX.Sequence.Enumeration_Vector.Valid (Seq_Ctx),
     Post =>
       Has_Buffer (Ctx)
       and Well_Formed (Ctx, F_Enumeration_Vector)
       and Invalid (Ctx, F_AV_Enumeration_Vector)
       and Valid_Next (Ctx, F_AV_Enumeration_Vector)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Valid_Next (Ctx, F_Enumeration_Vector) = Valid_Next (Ctx, F_Enumeration_Vector)'Old
       and Get_Length (Ctx) = Get_Length (Ctx)'Old
       and Field_First (Ctx, F_Enumeration_Vector) = Field_First (Ctx, F_Enumeration_Vector)'Old
       and (if Field_Size (Ctx, F_Enumeration_Vector) > 0 then Present (Ctx, F_Enumeration_Vector));

   procedure Set_AV_Enumeration_Vector (Ctx : in out Context; Seq_Ctx : RFLX.Sequence.AV_Enumeration_Vector.Context) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector)
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector)
       and then RFLX.Sequence.Message.Valid_Length (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector, RFLX.Sequence.AV_Enumeration_Vector.Byte_Size (Seq_Ctx))
       and then RFLX.Sequence.AV_Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and then RFLX.Sequence.AV_Enumeration_Vector.Valid (Seq_Ctx),
     Post =>
       Has_Buffer (Ctx)
       and Well_Formed (Ctx, F_AV_Enumeration_Vector)
       and (if Well_Formed_Message (Ctx) then Message_Last (Ctx) = Field_Last (Ctx, F_AV_Enumeration_Vector))
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Valid_Next (Ctx, F_AV_Enumeration_Vector) = Valid_Next (Ctx, F_AV_Enumeration_Vector)'Old
       and Get_Length (Ctx) = Get_Length (Ctx)'Old
       and Field_First (Ctx, F_AV_Enumeration_Vector) = Field_First (Ctx, F_AV_Enumeration_Vector)'Old
       and (if Field_Size (Ctx, F_AV_Enumeration_Vector) > 0 then Present (Ctx, F_AV_Enumeration_Vector));

   procedure Initialize_Integer_Vector (Ctx : in out Context) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Integer_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Integer_Vector),
     Post =>
       Has_Buffer (Ctx)
       and then Well_Formed (Ctx, F_Integer_Vector)
       and then Invalid (Ctx, F_Enumeration_Vector)
       and then Invalid (Ctx, F_AV_Enumeration_Vector)
       and then Valid_Next (Ctx, F_Enumeration_Vector)
       and then Ctx.Buffer_First = Ctx.Buffer_First'Old
       and then Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and then Ctx.First = Ctx.First'Old
       and then Ctx.Last = Ctx.Last'Old
       and then Valid_Next (Ctx, F_Integer_Vector) = Valid_Next (Ctx, F_Integer_Vector)'Old
       and then Get_Length (Ctx) = Get_Length (Ctx)'Old
       and then Field_First (Ctx, F_Integer_Vector) = Field_First (Ctx, F_Integer_Vector)'Old;

   procedure Initialize_Enumeration_Vector (Ctx : in out Context) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector)
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector),
     Post =>
       Has_Buffer (Ctx)
       and then Well_Formed (Ctx, F_Enumeration_Vector)
       and then Invalid (Ctx, F_AV_Enumeration_Vector)
       and then Valid_Next (Ctx, F_AV_Enumeration_Vector)
       and then Ctx.Buffer_First = Ctx.Buffer_First'Old
       and then Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and then Ctx.First = Ctx.First'Old
       and then Ctx.Last = Ctx.Last'Old
       and then Valid_Next (Ctx, F_Enumeration_Vector) = Valid_Next (Ctx, F_Enumeration_Vector)'Old
       and then Get_Length (Ctx) = Get_Length (Ctx)'Old
       and then Field_First (Ctx, F_Enumeration_Vector) = Field_First (Ctx, F_Enumeration_Vector)'Old;

   procedure Initialize_AV_Enumeration_Vector (Ctx : in out Context) with
     Pre =>
       not Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector)
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector),
     Post =>
       Has_Buffer (Ctx)
       and then Well_Formed (Ctx, F_AV_Enumeration_Vector)
       and then (if Well_Formed_Message (Ctx) then Message_Last (Ctx) = Field_Last (Ctx, F_AV_Enumeration_Vector))
       and then Ctx.Buffer_First = Ctx.Buffer_First'Old
       and then Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and then Ctx.First = Ctx.First'Old
       and then Ctx.Last = Ctx.Last'Old
       and then Valid_Next (Ctx, F_AV_Enumeration_Vector) = Valid_Next (Ctx, F_AV_Enumeration_Vector)'Old
       and then Get_Length (Ctx) = Get_Length (Ctx)'Old
       and then Field_First (Ctx, F_AV_Enumeration_Vector) = Field_First (Ctx, F_AV_Enumeration_Vector)'Old;

   procedure Switch_To_Integer_Vector (Ctx : in out Context; Seq_Ctx : out RFLX.Sequence.Integer_Vector.Context) with
     Pre =>
       not Ctx'Constrained
       and then not Seq_Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Integer_Vector) > 0
       and then RFLX.Sequence.Message.Field_First (Ctx, RFLX.Sequence.Message.F_Integer_Vector) rem RFLX_Types.Byte'Size = 1
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Integer_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_Integer_Vector),
     Post =>
       not RFLX.Sequence.Message.Has_Buffer (Ctx)
       and RFLX.Sequence.Integer_Vector.Has_Buffer (Seq_Ctx)
       and Ctx.Buffer_First = Seq_Ctx.Buffer_First
       and Ctx.Buffer_Last = Seq_Ctx.Buffer_Last
       and Seq_Ctx.First = Field_First (Ctx, F_Integer_Vector)
       and Seq_Ctx.Last = Field_Last (Ctx, F_Integer_Vector)
       and RFLX.Sequence.Integer_Vector.Valid (Seq_Ctx)
       and RFLX.Sequence.Integer_Vector.Sequence_Last (Seq_Ctx) = Seq_Ctx.First - 1
       and Present (Ctx, F_Integer_Vector)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Field_Last (Ctx, F_Integer_Vector) = Field_Last (Ctx, F_Integer_Vector)'Old
       and (for all F in Field range F_Length .. F_Length =>
               Context_Cursors_Index (Context_Cursors (Ctx), F) = Context_Cursors_Index (Context_Cursors (Ctx)'Old, F)),
     Contract_Cases =>
       (Well_Formed (Ctx, F_Integer_Vector) =>
           (for all F in Field range F_Enumeration_Vector .. F_AV_Enumeration_Vector =>
               Context_Cursors_Index (Context_Cursors (Ctx), F) = Context_Cursors_Index (Context_Cursors (Ctx)'Old, F)),
        others =>
           Valid_Next (Ctx, F_Enumeration_Vector)
           and Invalid (Ctx, F_Enumeration_Vector)
           and Invalid (Ctx, F_AV_Enumeration_Vector));

   procedure Switch_To_Enumeration_Vector (Ctx : in out Context; Seq_Ctx : out RFLX.Sequence.Enumeration_Vector.Context) with
     Pre =>
       not Ctx'Constrained
       and then not Seq_Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector)
       and then RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector) > 0
       and then RFLX.Sequence.Message.Field_First (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector) rem RFLX_Types.Byte'Size = 1
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector),
     Post =>
       not RFLX.Sequence.Message.Has_Buffer (Ctx)
       and RFLX.Sequence.Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and Ctx.Buffer_First = Seq_Ctx.Buffer_First
       and Ctx.Buffer_Last = Seq_Ctx.Buffer_Last
       and Seq_Ctx.First = Field_First (Ctx, F_Enumeration_Vector)
       and Seq_Ctx.Last = Field_Last (Ctx, F_Enumeration_Vector)
       and RFLX.Sequence.Enumeration_Vector.Valid (Seq_Ctx)
       and RFLX.Sequence.Enumeration_Vector.Sequence_Last (Seq_Ctx) = Seq_Ctx.First - 1
       and Present (Ctx, F_Enumeration_Vector)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Field_Last (Ctx, F_Enumeration_Vector) = Field_Last (Ctx, F_Enumeration_Vector)'Old
       and (for all F in Field range F_Length .. F_Integer_Vector =>
               Context_Cursors_Index (Context_Cursors (Ctx), F) = Context_Cursors_Index (Context_Cursors (Ctx)'Old, F)),
     Contract_Cases =>
       (Well_Formed (Ctx, F_Enumeration_Vector) =>
           (for all F in Field range F_AV_Enumeration_Vector .. F_AV_Enumeration_Vector =>
               Context_Cursors_Index (Context_Cursors (Ctx), F) = Context_Cursors_Index (Context_Cursors (Ctx)'Old, F)),
        others =>
           Valid_Next (Ctx, F_AV_Enumeration_Vector)
           and Invalid (Ctx, F_AV_Enumeration_Vector));

   procedure Switch_To_AV_Enumeration_Vector (Ctx : in out Context; Seq_Ctx : out RFLX.Sequence.AV_Enumeration_Vector.Context) with
     Pre =>
       not Ctx'Constrained
       and then not Seq_Ctx'Constrained
       and then RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector)
       and then RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector) > 0
       and then RFLX.Sequence.Message.Field_First (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector) rem RFLX_Types.Byte'Size = 1
       and then RFLX.Sequence.Message.Available_Space (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector) >= RFLX.Sequence.Message.Field_Size (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector)
       and then RFLX.Sequence.Message.Field_Condition (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector),
     Post =>
       not RFLX.Sequence.Message.Has_Buffer (Ctx)
       and RFLX.Sequence.AV_Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and Ctx.Buffer_First = Seq_Ctx.Buffer_First
       and Ctx.Buffer_Last = Seq_Ctx.Buffer_Last
       and Seq_Ctx.First = Field_First (Ctx, F_AV_Enumeration_Vector)
       and Seq_Ctx.Last = Field_Last (Ctx, F_AV_Enumeration_Vector)
       and RFLX.Sequence.AV_Enumeration_Vector.Valid (Seq_Ctx)
       and RFLX.Sequence.AV_Enumeration_Vector.Sequence_Last (Seq_Ctx) = Seq_Ctx.First - 1
       and Present (Ctx, F_AV_Enumeration_Vector)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Field_Last (Ctx, F_AV_Enumeration_Vector) = Field_Last (Ctx, F_AV_Enumeration_Vector)'Old
       and (for all F in Field range F_Length .. F_Enumeration_Vector =>
               Context_Cursors_Index (Context_Cursors (Ctx), F) = Context_Cursors_Index (Context_Cursors (Ctx)'Old, F)),
     Contract_Cases =>
       (Well_Formed (Ctx, F_AV_Enumeration_Vector) =>
           True,
        others =>
           True);

   function Complete_Integer_Vector (Ctx : Context; Seq_Ctx : RFLX.Sequence.Integer_Vector.Context) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Integer_Vector);

   function Complete_Enumeration_Vector (Ctx : Context; Seq_Ctx : RFLX.Sequence.Enumeration_Vector.Context) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector);

   function Complete_AV_Enumeration_Vector (Ctx : Context; Seq_Ctx : RFLX.Sequence.AV_Enumeration_Vector.Context) return Boolean with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector);

   procedure Update_Integer_Vector (Ctx : in out Context; Seq_Ctx : in out RFLX.Sequence.Integer_Vector.Context) with
     Pre =>
       RFLX.Sequence.Message.Present (Ctx, RFLX.Sequence.Message.F_Integer_Vector)
       and then not RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Integer_Vector.Has_Buffer (Seq_Ctx)
       and then Ctx.Buffer_First = Seq_Ctx.Buffer_First
       and then Ctx.Buffer_Last = Seq_Ctx.Buffer_Last
       and then Seq_Ctx.First = Field_First (Ctx, F_Integer_Vector)
       and then Seq_Ctx.Last = Field_Last (Ctx, F_Integer_Vector),
     Post =>
       (if
           RFLX.Sequence.Message.Complete_Integer_Vector (Ctx, Seq_Ctx)
        then
           Present (Ctx, F_Integer_Vector)
           and Context_Cursor (Ctx, F_Enumeration_Vector) = Context_Cursor (Ctx, F_Enumeration_Vector)'Old
           and Context_Cursor (Ctx, F_AV_Enumeration_Vector) = Context_Cursor (Ctx, F_AV_Enumeration_Vector)'Old
        else
           Invalid (Ctx, F_Integer_Vector)
           and Invalid (Ctx, F_Enumeration_Vector)
           and Invalid (Ctx, F_AV_Enumeration_Vector))
       and Has_Buffer (Ctx)
       and not RFLX.Sequence.Integer_Vector.Has_Buffer (Seq_Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Seq_Ctx.First = Seq_Ctx.First'Old
       and Seq_Ctx.Last = Seq_Ctx.Last'Old
       and Field_First (Ctx, F_Integer_Vector) = Field_First (Ctx, F_Integer_Vector)'Old
       and Field_Size (Ctx, F_Integer_Vector) = Field_Size (Ctx, F_Integer_Vector)'Old
       and Context_Cursor (Ctx, F_Length) = Context_Cursor (Ctx, F_Length)'Old,
     Depends =>
       (Ctx => (Ctx, Seq_Ctx), Seq_Ctx => Seq_Ctx);

   procedure Update_Enumeration_Vector (Ctx : in out Context; Seq_Ctx : in out RFLX.Sequence.Enumeration_Vector.Context) with
     Pre =>
       RFLX.Sequence.Message.Present (Ctx, RFLX.Sequence.Message.F_Enumeration_Vector)
       and then not RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and then Ctx.Buffer_First = Seq_Ctx.Buffer_First
       and then Ctx.Buffer_Last = Seq_Ctx.Buffer_Last
       and then Seq_Ctx.First = Field_First (Ctx, F_Enumeration_Vector)
       and then Seq_Ctx.Last = Field_Last (Ctx, F_Enumeration_Vector),
     Post =>
       (if
           RFLX.Sequence.Message.Complete_Enumeration_Vector (Ctx, Seq_Ctx)
        then
           Present (Ctx, F_Enumeration_Vector)
           and Context_Cursor (Ctx, F_AV_Enumeration_Vector) = Context_Cursor (Ctx, F_AV_Enumeration_Vector)'Old
        else
           Invalid (Ctx, F_Enumeration_Vector)
           and Invalid (Ctx, F_AV_Enumeration_Vector))
       and Has_Buffer (Ctx)
       and not RFLX.Sequence.Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Seq_Ctx.First = Seq_Ctx.First'Old
       and Seq_Ctx.Last = Seq_Ctx.Last'Old
       and Field_First (Ctx, F_Enumeration_Vector) = Field_First (Ctx, F_Enumeration_Vector)'Old
       and Field_Size (Ctx, F_Enumeration_Vector) = Field_Size (Ctx, F_Enumeration_Vector)'Old
       and Context_Cursor (Ctx, F_Length) = Context_Cursor (Ctx, F_Length)'Old
       and Context_Cursor (Ctx, F_Integer_Vector) = Context_Cursor (Ctx, F_Integer_Vector)'Old,
     Depends =>
       (Ctx => (Ctx, Seq_Ctx), Seq_Ctx => Seq_Ctx);

   procedure Update_AV_Enumeration_Vector (Ctx : in out Context; Seq_Ctx : in out RFLX.Sequence.AV_Enumeration_Vector.Context) with
     Pre =>
       RFLX.Sequence.Message.Present (Ctx, RFLX.Sequence.Message.F_AV_Enumeration_Vector)
       and then not RFLX.Sequence.Message.Has_Buffer (Ctx)
       and then RFLX.Sequence.AV_Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and then Ctx.Buffer_First = Seq_Ctx.Buffer_First
       and then Ctx.Buffer_Last = Seq_Ctx.Buffer_Last
       and then Seq_Ctx.First = Field_First (Ctx, F_AV_Enumeration_Vector)
       and then Seq_Ctx.Last = Field_Last (Ctx, F_AV_Enumeration_Vector),
     Post =>
       (if
           RFLX.Sequence.Message.Complete_AV_Enumeration_Vector (Ctx, Seq_Ctx)
        then
           Present (Ctx, F_AV_Enumeration_Vector)
        else
           Invalid (Ctx, F_AV_Enumeration_Vector))
       and Has_Buffer (Ctx)
       and not RFLX.Sequence.AV_Enumeration_Vector.Has_Buffer (Seq_Ctx)
       and Ctx.Buffer_First = Ctx.Buffer_First'Old
       and Ctx.Buffer_Last = Ctx.Buffer_Last'Old
       and Ctx.First = Ctx.First'Old
       and Ctx.Last = Ctx.Last'Old
       and Seq_Ctx.First = Seq_Ctx.First'Old
       and Seq_Ctx.Last = Seq_Ctx.Last'Old
       and Field_First (Ctx, F_AV_Enumeration_Vector) = Field_First (Ctx, F_AV_Enumeration_Vector)'Old
       and Field_Size (Ctx, F_AV_Enumeration_Vector) = Field_Size (Ctx, F_AV_Enumeration_Vector)'Old
       and Context_Cursor (Ctx, F_Length) = Context_Cursor (Ctx, F_Length)'Old
       and Context_Cursor (Ctx, F_Integer_Vector) = Context_Cursor (Ctx, F_Integer_Vector)'Old
       and Context_Cursor (Ctx, F_Enumeration_Vector) = Context_Cursor (Ctx, F_Enumeration_Vector)'Old,
     Depends =>
       (Ctx => (Ctx, Seq_Ctx), Seq_Ctx => Seq_Ctx);

   function Context_Cursor (Ctx : Context; Fld : Field) return Field_Cursor with
     Annotate =>
       (GNATprove, Inline_For_Proof),
     Ghost;

   function Context_Cursors (Ctx : Context) return Field_Cursors with
     Annotate =>
       (GNATprove, Inline_For_Proof),
     Ghost;

   function Context_Cursors_Index (Cursors : Field_Cursors; Fld : Field) return Field_Cursor with
     Annotate =>
       (GNATprove, Inline_For_Proof),
     Ghost;

private

   type Cursor_State is (S_Valid, S_Well_Formed, S_Invalid, S_Incomplete);

   type Field_Cursor is
      record
         State : Cursor_State := S_Invalid;
         First : RFLX_Types.Bit_Index := RFLX_Types.Bit_Index'First;
         Last : RFLX_Types.Bit_Length := RFLX_Types.Bit_Length'First;
         Value : RFLX_Types.Base_Integer := 0;
      end record;

   type Field_Cursors is array (Virtual_Field) of Field_Cursor;

   function Well_Formed (Cursor : Field_Cursor) return Boolean is
     (Cursor.State = S_Valid
      or Cursor.State = S_Well_Formed);

   function Valid (Cursor : Field_Cursor) return Boolean is
     (Cursor.State = S_Valid);

   function Invalid (Cursor : Field_Cursor) return Boolean is
     (Cursor.State = S_Invalid
      or Cursor.State = S_Incomplete);

   pragma Warnings (Off, "postcondition does not mention function result");

   function Cursors_Invariant (Cursors : Field_Cursors; First : RFLX_Types.Bit_Index; Verified_Last : RFLX_Types.Bit_Length) return Boolean is
     ((for all F in Field =>
          (if
              Well_Formed (Cursors (F))
           then
              Cursors (F).First >= First
              and Cursors (F).Last <= Verified_Last
              and Cursors (F).First <= Cursors (F).Last + 1
              and Valid_Value (F, Cursors (F).Value))))
    with
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   pragma Warnings (Off, "formal parameter ""*"" is not referenced");

   pragma Warnings (Off, "postcondition does not mention function result");

   pragma Warnings (Off, "unused variable ""*""");

   function Valid_Predecessors_Invariant (Cursors : Field_Cursors; First : RFLX_Types.Bit_Index; Verified_Last : RFLX_Types.Bit_Length; Written_Last : RFLX_Types.Bit_Length; Buffer : RFLX_Types.Bytes_Ptr) return Boolean is
     ((if Well_Formed (Cursors (F_Length)) then True)
      and then (if Well_Formed (Cursors (F_Integer_Vector)) then Valid (Cursors (F_Length)))
      and then (if Well_Formed (Cursors (F_Enumeration_Vector)) then Well_Formed (Cursors (F_Integer_Vector)))
      and then (if Well_Formed (Cursors (F_AV_Enumeration_Vector)) then Well_Formed (Cursors (F_Enumeration_Vector))))
    with
     Pre =>
       Cursors_Invariant (Cursors, First, Verified_Last),
     Post =>
       True;

   pragma Warnings (On, "formal parameter ""*"" is not referenced");

   pragma Warnings (On, "postcondition does not mention function result");

   pragma Warnings (On, "unused variable ""*""");

   pragma Warnings (Off, "postcondition does not mention function result");

   function Valid_Next_Internal (Cursors : Field_Cursors; First : RFLX_Types.Bit_Index; Verified_Last : RFLX_Types.Bit_Length; Written_Last : RFLX_Types.Bit_Length; Buffer : RFLX_Types.Bytes_Ptr; Fld : Field) return Boolean is
     ((case Fld is
          when F_Length =>
             True,
          when F_Integer_Vector =>
             (Valid (Cursors (F_Length))
              and then True),
          when F_Enumeration_Vector =>
             (Well_Formed (Cursors (F_Integer_Vector))
              and then True),
          when F_AV_Enumeration_Vector =>
             (Well_Formed (Cursors (F_Enumeration_Vector))
              and then True)))
    with
     Pre =>
       Cursors_Invariant (Cursors, First, Verified_Last)
       and then Valid_Predecessors_Invariant (Cursors, First, Verified_Last, Written_Last, Buffer),
     Post =>
       True;

   pragma Warnings (On, "postcondition does not mention function result");

   pragma Warnings (Off, "unused variable ""*""");

   pragma Warnings (Off, "formal parameter ""*"" is not referenced");

   function Field_Size_Internal (Cursors : Field_Cursors; First : RFLX_Types.Bit_Index; Verified_Last : RFLX_Types.Bit_Length; Written_Last : RFLX_Types.Bit_Length; Buffer : RFLX_Types.Bytes_Ptr; Fld : Field) return RFLX_Types.Bit_Length'Base is
     ((case Fld is
          when F_Length =>
             8,
          when F_Integer_Vector =>
             RFLX_Types.Bit_Length (Cursors (F_Length).Value) * 8,
          when F_Enumeration_Vector | F_AV_Enumeration_Vector =>
             16))
    with
     Pre =>
       Cursors_Invariant (Cursors, First, Verified_Last)
       and then Valid_Predecessors_Invariant (Cursors, First, Verified_Last, Written_Last, Buffer)
       and then Valid_Next_Internal (Cursors, First, Verified_Last, Written_Last, Buffer, Fld);

   pragma Warnings (On, "unused variable ""*""");

   pragma Warnings (On, "formal parameter ""*"" is not referenced");

   pragma Warnings (Off, "postcondition does not mention function result");

   pragma Warnings (Off, "unused variable ""*""");

   pragma Warnings (Off, "no recursive call visible");

   pragma Warnings (Off, "formal parameter ""*"" is not referenced");

   function Field_First_Internal (Cursors : Field_Cursors; First : RFLX_Types.Bit_Index; Verified_Last : RFLX_Types.Bit_Length; Written_Last : RFLX_Types.Bit_Length; Buffer : RFLX_Types.Bytes_Ptr; Fld : Field) return RFLX_Types.Bit_Index'Base is
     ((case Fld is
          when F_Length =>
             First,
          when F_Integer_Vector =>
             First + 8,
          when F_Enumeration_Vector =>
             Field_First_Internal (Cursors, First, Verified_Last, Written_Last, Buffer, F_Integer_Vector) + Field_Size_Internal (Cursors, First, Verified_Last, Written_Last, Buffer, F_Integer_Vector),
          when F_AV_Enumeration_Vector =>
             Field_First_Internal (Cursors, First, Verified_Last, Written_Last, Buffer, F_Integer_Vector) + Field_Size_Internal (Cursors, First, Verified_Last, Written_Last, Buffer, F_Integer_Vector) + 16))
    with
     Pre =>
       Cursors_Invariant (Cursors, First, Verified_Last)
       and then Valid_Predecessors_Invariant (Cursors, First, Verified_Last, Written_Last, Buffer)
       and then Valid_Next_Internal (Cursors, First, Verified_Last, Written_Last, Buffer, Fld),
     Post =>
       True,
     Subprogram_Variant =>
       (Decreases =>
         Fld);

   pragma Warnings (On, "postcondition does not mention function result");

   pragma Warnings (On, "unused variable ""*""");

   pragma Warnings (On, "no recursive call visible");

   pragma Warnings (On, "formal parameter ""*"" is not referenced");

   pragma Warnings (Off, """Buffer"" is not modified, could be of access constant type");

   pragma Warnings (Off, "postcondition does not mention function result");

   function Valid_Context (Buffer_First, Buffer_Last : RFLX_Types.Index; First : RFLX_Types.Bit_Index; Last : RFLX_Types.Bit_Length; Verified_Last : RFLX_Types.Bit_Length; Written_Last : RFLX_Types.Bit_Length; Buffer : RFLX_Types.Bytes_Ptr; Cursors : Field_Cursors) return Boolean is
     ((if Buffer /= null then Buffer'First = Buffer_First and Buffer'Last = Buffer_Last)
      and then (RFLX_Types.To_Index (First) >= Buffer_First
                and RFLX_Types.To_Index (Last) <= Buffer_Last
                and Buffer_Last < RFLX_Types.Index'Last
                and First <= Last + 1
                and Last < RFLX_Types.Bit_Index'Last
                and First rem RFLX_Types.Byte'Size = 1
                and Last rem RFLX_Types.Byte'Size = 0)
      and then First - 1 <= Verified_Last
      and then First - 1 <= Written_Last
      and then Verified_Last <= Written_Last
      and then Written_Last <= Last
      and then First rem RFLX_Types.Byte'Size = 1
      and then Last rem RFLX_Types.Byte'Size = 0
      and then Verified_Last rem RFLX_Types.Byte'Size = 0
      and then Written_Last rem RFLX_Types.Byte'Size = 0
      and then Cursors_Invariant (Cursors, First, Verified_Last)
      and then Valid_Predecessors_Invariant (Cursors, First, Verified_Last, Written_Last, Buffer)
      and then ((if Invalid (Cursors (F_Length)) then Invalid (Cursors (F_Integer_Vector)))
                and then (if Invalid (Cursors (F_Integer_Vector)) then Invalid (Cursors (F_Enumeration_Vector)))
                and then (if Invalid (Cursors (F_Enumeration_Vector)) then Invalid (Cursors (F_AV_Enumeration_Vector))))
      and then ((if
                    Well_Formed (Cursors (F_Length))
                 then
                    (Cursors (F_Length).Last - Cursors (F_Length).First + 1 = 8
                     and then Cursors (F_Length).First = First))
                and then (if
                             Well_Formed (Cursors (F_Integer_Vector))
                          then
                             (Cursors (F_Integer_Vector).Last - Cursors (F_Integer_Vector).First + 1 = RFLX_Types.Bit_Length (Cursors (F_Length).Value) * 8
                              and then Cursors (F_Integer_Vector).First = Cursors (F_Length).Last + 1))
                and then (if
                             Well_Formed (Cursors (F_Enumeration_Vector))
                          then
                             (Cursors (F_Enumeration_Vector).Last - Cursors (F_Enumeration_Vector).First + 1 = 16
                              and then Cursors (F_Enumeration_Vector).First = Cursors (F_Integer_Vector).Last + 1))
                and then (if
                             Well_Formed (Cursors (F_AV_Enumeration_Vector))
                          then
                             (Cursors (F_AV_Enumeration_Vector).Last - Cursors (F_AV_Enumeration_Vector).First + 1 = 16
                              and then Cursors (F_AV_Enumeration_Vector).First = Cursors (F_Enumeration_Vector).Last + 1))))
    with
     Post =>
       True;

   pragma Warnings (On, """Buffer"" is not modified, could be of access constant type");

   pragma Warnings (On, "postcondition does not mention function result");

   type Context (Buffer_First, Buffer_Last : RFLX_Types.Index := RFLX_Types.Index'First; First : RFLX_Types.Bit_Index := RFLX_Types.Bit_Index'First; Last : RFLX_Types.Bit_Length := RFLX_Types.Bit_Length'First) is
      record
         Verified_Last : RFLX_Types.Bit_Length := First - 1;
         Written_Last : RFLX_Types.Bit_Length := First - 1;
         Buffer : RFLX_Types.Bytes_Ptr := null;
         Cursors : Field_Cursors := (others => <>);
      end record with
     Dynamic_Predicate =>
       Valid_Context (Context.Buffer_First, Context.Buffer_Last, Context.First, Context.Last, Context.Verified_Last, Context.Written_Last, Context.Buffer, Context.Cursors);

   function Initialized (Ctx : Context) return Boolean is
     (Ctx.Verified_Last = Ctx.First - 1
      and then Valid_Next (Ctx, F_Length)
      and then RFLX.Sequence.Message.Field_First (Ctx, RFLX.Sequence.Message.F_Length) rem RFLX_Types.Byte'Size = 1
      and then Available_Space (Ctx, F_Length) = Ctx.Last - Ctx.First + 1
      and then (for all F in Field =>
                   Invalid (Ctx, F)));

   function Has_Buffer (Ctx : Context) return Boolean is
     (Ctx.Buffer /= null);

   function Buffer_Length (Ctx : Context) return RFLX_Types.Length is
     (Ctx.Buffer'Length);

   function Size (Ctx : Context) return RFLX_Types.Bit_Length is
     (Ctx.Verified_Last - Ctx.First + 1);

   function Byte_Size (Ctx : Context) return RFLX_Types.Length is
     (RFLX_Types.To_Length (Size (Ctx)));

   function Message_Last (Ctx : Context) return RFLX_Types.Bit_Length is
     (Ctx.Verified_Last);

   function Written_Last (Ctx : Context) return RFLX_Types.Bit_Length is
     (Ctx.Written_Last);

   function Valid_Value (Fld : Field; Val : RFLX_Types.Base_Integer) return Boolean is
     ((case Fld is
          when F_Length =>
             RFLX.Sequence.Valid_Length (Val),
          when F_Integer_Vector | F_Enumeration_Vector | F_AV_Enumeration_Vector =>
             True));

   function Field_Condition (Ctx : Context; Fld : Field) return Boolean is
     ((case Fld is
          when F_Length | F_Integer_Vector | F_Enumeration_Vector | F_AV_Enumeration_Vector =>
             True));

   function Field_Size (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Length is
     (Field_Size_Internal (Ctx.Cursors, Ctx.First, Ctx.Verified_Last, Ctx.Written_Last, Ctx.Buffer, Fld));

   function Field_First (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Index is
     (Field_First_Internal (Ctx.Cursors, Ctx.First, Ctx.Verified_Last, Ctx.Written_Last, Ctx.Buffer, Fld));

   function Field_Last (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Length is
     (Field_First (Ctx, Fld) + Field_Size (Ctx, Fld) - 1);

   function Valid_Next (Ctx : Context; Fld : Field) return Boolean is
     (Valid_Next_Internal (Ctx.Cursors, Ctx.First, Ctx.Verified_Last, Ctx.Written_Last, Ctx.Buffer, Fld));

   function Available_Space (Ctx : Context; Fld : Field) return RFLX_Types.Bit_Length is
     (Ctx.Last - Field_First (Ctx, Fld) + 1);

   function Sufficient_Space (Ctx : Context; Fld : Field) return Boolean is
     (Available_Space (Ctx, Fld) >= Field_Size (Ctx, Fld));

   function Present (Ctx : Context; Fld : Field) return Boolean is
     (Well_Formed (Ctx.Cursors (Fld))
      and then Ctx.Cursors (Fld).First < Ctx.Cursors (Fld).Last + 1);

   function Well_Formed (Ctx : Context; Fld : Field) return Boolean is
     (Ctx.Cursors (Fld).State = S_Valid
      or Ctx.Cursors (Fld).State = S_Well_Formed);

   function Valid (Ctx : Context; Fld : Field) return Boolean is
     (Ctx.Cursors (Fld).State = S_Valid
      and then Ctx.Cursors (Fld).First < Ctx.Cursors (Fld).Last + 1);

   function Incomplete (Ctx : Context; Fld : Field) return Boolean is
     (Ctx.Cursors (Fld).State = S_Incomplete);

   function Invalid (Ctx : Context; Fld : Field) return Boolean is
     (Ctx.Cursors (Fld).State = S_Invalid
      or Ctx.Cursors (Fld).State = S_Incomplete);

   function Well_Formed_Message (Ctx : Context) return Boolean is
     (Well_Formed (Ctx, F_AV_Enumeration_Vector));

   function Valid_Message (Ctx : Context) return Boolean is
     (Valid (Ctx, F_AV_Enumeration_Vector));

   function Incomplete_Message (Ctx : Context) return Boolean is
     ((for some F in Field =>
          Incomplete (Ctx, F)));

   function Get_Length (Ctx : Context) return RFLX.Sequence.Length is
     (To_Actual (Ctx.Cursors (F_Length).Value));

   function Valid_Size (Ctx : Context; Fld : Field; Size : RFLX_Types.Bit_Length) return Boolean is
     (Size = Field_Size (Ctx, Fld))
    with
     Pre =>
       RFLX.Sequence.Message.Valid_Next (Ctx, Fld);

   function Valid_Length (Ctx : Context; Fld : Field; Length : RFLX_Types.Length) return Boolean is
     (Valid_Size (Ctx, Fld, RFLX_Types.To_Bit_Length (Length)));

   function Complete_Integer_Vector (Ctx : Context; Seq_Ctx : RFLX.Sequence.Integer_Vector.Context) return Boolean is
     (RFLX.Sequence.Integer_Vector.Valid (Seq_Ctx)
      and RFLX.Sequence.Integer_Vector.Size (Seq_Ctx) = Field_Size (Ctx, F_Integer_Vector));

   function Complete_Enumeration_Vector (Ctx : Context; Seq_Ctx : RFLX.Sequence.Enumeration_Vector.Context) return Boolean is
     (RFLX.Sequence.Enumeration_Vector.Valid (Seq_Ctx)
      and RFLX.Sequence.Enumeration_Vector.Size (Seq_Ctx) = Field_Size (Ctx, F_Enumeration_Vector));

   function Complete_AV_Enumeration_Vector (Ctx : Context; Seq_Ctx : RFLX.Sequence.AV_Enumeration_Vector.Context) return Boolean is
     (RFLX.Sequence.AV_Enumeration_Vector.Valid (Seq_Ctx)
      and RFLX.Sequence.AV_Enumeration_Vector.Size (Seq_Ctx) = Field_Size (Ctx, F_AV_Enumeration_Vector));

   function Context_Cursor (Ctx : Context; Fld : Field) return Field_Cursor is
     (Ctx.Cursors (Fld));

   function Context_Cursors (Ctx : Context) return Field_Cursors is
     (Ctx.Cursors);

   function Context_Cursors_Index (Cursors : Field_Cursors; Fld : Field) return Field_Cursor is
     (Cursors (Fld));

end RFLX.Sequence.Message;
