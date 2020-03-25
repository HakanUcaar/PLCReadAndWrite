unit MahBit8;

interface

uses SysUtils;

type
     {TBIT8 CLASS}
     TBit8 = class(TObject)
     private
       FValue1  : byte;
       FValue2  : byte;
     protected
       // Internal Methods
       procedure _CheckBitNumber(ABitNumber : byte);
     public
       // Methods (Functions)
       function BitSet(ABitNumber : byte) : boolean;

       // Methods (Procedures)
       procedure SetBit(ABitNumber : byte);
       procedure ClrBit(ABitNumber : byte);

       // Properties
       property AsByteO : byte read FValue1 write FValue1;
       property AsByteI : byte read FValue2 write FValue2;
     end;

// ------------------------------------------------------------------------
implementation

const C_BITVALARR : array [0..7] of byte=($01,$02,$04,$08,$10,$20,$40,$80);

procedure TBit8._CheckBitNumber(ABitNumber : byte);
begin
  if not (ABitNumber in [0..7]) then
      raise EConvertError.Create(IntToStr(ABitNumber) +
                                 ' is not a valid bit number (0..7)');
end;

function TBit8.BitSet(ABitNumber : byte) : boolean;
begin
  _CheckBitNumber(ABitNumber);
  Result := FValue1 and C_BITVALARR[ABitNumber] = C_BITVALARR[ABitNumber];
end;

procedure TBit8.SetBit(ABitNumber : byte);
begin
  _CheckBitNumber(ABitNumber);
   FValue2 := byte(FValue2) or C_BITVALARR[ABitNumber];
end;

procedure TBit8.ClrBit(ABitNumber : byte);
begin
  _CheckBitNumber(ABitNumber);
   FValue2 := (byte(FValue2) or C_BITVALARR[ABitNumber]) xor
             C_BITVALARR[ABitNumber];
end;

end.
