unit MahBit16;

interface
{
  // Integer data types :
   Int1 : Byte;     //                        0 to 255
   Int2 : ShortInt; //                     -127 to 127
   Int3 : Word;     //                        0 to 65,535
   Int4 : SmallInt; //                  -32,768 to 32,767
   Int5 : LongWord; //                        0 to 4,294,967,295
   Int6 : Cardinal; //                        0 to 4,294,967,295
   Int7 : LongInt;  //           -2,147,483,648 to 2,147,483,647
   Int8 : Integer;  //           -2,147,483,648 to 2,147,483,647
   Int9 : Int64;  // -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807
 
   // Decimal data types :
   Dec1 : Single;   //  7  significant digits, exponent   -38 to +38
   Dec2 : Currency; // 50+ significant digits, fixed 4 decimal places
   Dec3 : Double;   // 15  significant digits, exponent  -308 to +308
   Dec4 : Extended; // 19  significant digits, exponent -4932 to +4932
}

uses SysUtils;

type
     {TBIT32 CLASS}
     TBit16 = class(TObject)
     private
       FValue1 : word;
       FValue2 : word;
     protected
       // Internal Methods
       procedure _CheckBitNumber(ABitNumber : byte);
     public
       function BitSet(ABitNumber : byte) : boolean;
       procedure SetBit(ABitNumber : byte);
       procedure ClrBit(ABitNumber : byte);

       // Properties
       property AsWordO : word read FValue1 write FValue1;
       property AsWordI : word read FValue2 write FValue2;
     end;

// ------------------------------------------------------------------------
implementation

const C_BITVALARR : array [0..15] of word =
                    ($0001,$0002,$0004,$0008,$0010,
                     $0020,$0040,$0080,$0100,$0200,
                     $0400,$0800,$1000,$2000,$4000,
                     $8000);

procedure TBit16._CheckBitNumber(ABitNumber : byte);
begin
  if not (ABitNumber in [0..15]) then
      raise EConvertError.Create(IntToStr(ABitNumber) +
                                 ' is not a valid bit number (0..15)');
end;

function TBit16.BitSet(ABitNumber : byte) : boolean;
begin
  _CheckBitNumber(ABitNumber);
  Result := FValue1 and C_BITVALARR[ABitNumber] = C_BITVALARR[ABitNumber];
end;

procedure TBit16.SetBit(ABitNumber : byte);
begin
  _CheckBitNumber(ABitNumber);
   FValue2 := word(FValue2) or C_BITVALARR[ABitNumber];
end;

procedure TBit16.ClrBit(ABitNumber : byte);
begin
  _CheckBitNumber(ABitNumber);
   FValue2 := (word(FValue2) or C_BITVALARR[ABitNumber]) xor
             C_BITVALARR[ABitNumber];
end;

end.
