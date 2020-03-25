unit MahBit32;

interface

// ========================================================================
// 32 Bit Manipulation/Conversion Class
// Mike Heydon Nov 2004
//
// This class allows conversion and bit manipulation of a 32 bit integer.
// Values may be set and retrieved as INT,HEX or BINARY.
// Individual bits may be SET,TOGGLED,ROTATED and CLEARED,
// Checked for ON-OFF status.
// Bit numbers are 0..31 from right to left.
// ie. 31,30,29 ..... 4,3,2,1,0
//
// Properties
// ----------
// AsInteger      - Get or Set value as an integer
// AsHex          - Get or Set value as a Hex String
// AsBinary       - Get or Set value as a Binary String
//
// Methods (Functions)
// --------------------
// BitSet()       - Return if bit number is set.
// BitsSet()      - Return if a an array of bit numbers are all set
//
// Methods (Procedures)
// --------------------
// SetBit()       - Sets a single bit number to 1
// SetBits()      - Sets an array of bit numbers to 1
// ClrBit()       - Clears a single bit number to 0
// ClrBits()      - Clears an array of bit numbers to 0
// ToggleBit()    - Toggle a single bit number 0=1 1=0
// ToggleBits()   - Toggles an array of bit numbers to 0=1 1=0
// RotateLeft     - Shifts the value left by 1 with lost bit in bit 0
// RotateRight    - Shits the value right by 1 with lost bit in bit 31
//
// ========================================================================
//    Examples

//    var oBit32 : TBit32;

//    ....
//    oBit32 := TBit32.Create;
//    oBit32.AsInteger := 34212;

//    ShowMessage(oBit32,AsBinary);
//    // '00000000000000000100001011010010'

//    ShowMessage(oBit32.AsHex)
//    // '000042D2 '

//    oBit32.AsBinary := '110110';
//    // and so forth

//    oBit32.SetBit(10);
//    oBit32.RotateLeft;

//    if oBit32.BitsSet([2,4,8]) then ....

//    oBit32.Free;
// ========================================================================

uses SysUtils;

type
     {TBIT32 CLASS}
     TBit32 = class(TObject)
     private
       FValue : integer;
       FValue2 : integer;
       function GetFAsHex : string;
       procedure SetFAsHex(const AValue : string);
       function GetFAsBinary : string;
       function GetFAsBinaryS : string;
       procedure SetFAsBinary(const AValue : string);
     protected
       // Internal Methods
       procedure _CheckBitNumber(ABitNumber : byte);
       function _CalcMask(ABitNumArray : array of byte) : longword;
     public
       // Methods (Functions)
       function BitSet(ABitNumber : byte) : boolean;
       function BitsSet(ABitNumArray : array of byte) : boolean;

       // Methods (Procedures)
       procedure SetBit(ABitNumber : byte);
       procedure SetBits(ABitNumArray : array of byte);
       procedure ClrBit(ABitNumber : byte);
       procedure ClrBits(ABitNumArray : array of byte);
       procedure ToggleBit(ABitNumber : byte);
       procedure ToggleBits(ABitNumArray : array of byte);
       procedure RotateRight;
       procedure RotateLeft;

       // Properties
       property AsInteger : integer read FValue write FValue;
       property AsInteger2 : integer read FValue2 write FValue2;
       property AsHex : string read GetFAsHex write SetFAsHex;
       property AsBinary : string read GetFAsBinary write SetFAsBinary;
     end;

// ------------------------------------------------------------------------
implementation

const C_BITVALARR : array [0..31] of longword =
                    ($00000001,$00000002,$00000004,$00000008,$00000010,
                     $00000020,$00000040,$00000080,$00000100,$00000200,
                     $00000400,$00000800,$00001000,$00002000,$00004000,
                     $00008000,$00010000,$00020000,$00040000,$00080000,
                     $00100000,$00200000,$00400000,$00800000,$01000000,
                     $02000000,$04000000,$08000000,$10000000,$20000000,
                     $40000000,$80000000);

// =============================================
// Internal routine to validate bit number 0..31
// Will raise EConvertError Exception if fails
// =============================================

procedure TBit32._CheckBitNumber(ABitNumber : byte);
begin
  if not (ABitNumber in [0..31]) then
      raise EConvertError.Create(IntToStr(ABitNumber) +
                                 ' is not a valid bit number (0..31)');
end;


// ============================================================
// Internal routine to return a binaray mask from an array of
// bit numbers
// ============================================================

function TBit32._CalcMask(ABitNumArray : array of byte) : longword;
var i : integer;
    iResult : longword;
begin
  iResult := 0;

  for i := low(ABitNumArray) to high(ABitNumArray) do begin
    _CheckBitNumber(ABitNumArray[i]);
    iResult := iResult or C_BITVALARR[ABitNumArray[i]];
  end;

  Result := iResult;
end;


// ==============================================
// Get/Set Property Methods
// ==============================================

function TBit32.GetFAsHex : string;
begin
  Result := IntToHex(FValue,8);
end;


procedure TBit32.SetFAsHex(const AValue : string);
begin
  try
    FValue := StrToInt('$' + AValue);
  except
    raise EConvertError.Create(QuotedStr(AValue) +
                               ' is not a valid hex value');
  end;
end;


function TBit32.GetFAsBinary : string;
var sResult : string;
    iValue : integer;
begin
  sResult := '';
  iValue := FValue;

  while iValue <> 0 do begin
    sResult := char(48 + (iValue and 1)) + sResult;
    iValue := iValue shr 1;
  end;
  Result := StringOfChar('0',32 - length(sResult)) + sResult;
end;

function TBit32.GetFAsBinaryS : string;
var sResult : string;
    iValue : integer;
begin
  sResult := '';
  iValue := FValue;

  while iValue <> 0 do begin
    sResult := char(48 + (iValue and 1)) + sResult;
    iValue := iValue shr 1;
  end;

  Result := StringOfChar('0',32 - length(sResult)) + sResult;

  Insert(' ', Result, 29);
  Insert('--', Result, 25);
  Insert(' ', Result, 21);
  Insert('--', Result, 17);
  Insert(' ', Result, 13);
  Insert('--', Result, 9);
  Insert(' ', Result, 5);
end;


procedure TBit32.SetFAsBinary(const AValue : string);
var i : integer;
    sValue : string;
begin
  // Validate is a valid binary string
  for i := 1 to length(AValue)  do begin
    if not (AValue[i] in ['0','1']) then begin
      raise EConvertError.Create(QuotedStr(AValue) +
                                 ' is not a valid binary value');
      break
    end;
  end;

  // Convert to binary string
  sValue := StringOfChar('0',32 - length(AValue)) + AValue;
  FValue := 0;
  for i := 1 to length(sValue) do
    FValue := (FValue shl 1) + (byte(sValue[i]) and 1) ;
end;

// ============================================
// Return true if bit number of Value is set
// ============================================

function TBit32.BitSet(ABitNumber : byte) : boolean;
begin
  _CheckBitNumber(ABitNumber);
  Result := FValue and C_BITVALARR[ABitNumber] = C_BITVALARR[ABitNumber];
end;


// ============================================
// Return true if bit numbers of Value are set
// Bit numbers are passed in array parameter
// eg. if MyBit32.BitsSet([3,7,12]) then ...
// ============================================

function TBit32.BitsSet(ABitNumArray : array of byte) : boolean;
var iMask : longword;
begin
  iMask := _CalcMask(ABitNumArray);
  Result := FValue and iMask = iMask;
end;

// ===============================================
// Set a bit (bit = 1) by bit number 0..31
// ===============================================

procedure TBit32.SetBit(ABitNumber : byte);
begin
  _CheckBitNumber(ABitNumber);
   FValue2 := longword(FValue2) or C_BITVALARR[ABitNumber];
end;


// ===============================================
// Set bits (bit = 1) by bit number array
// eg. MyBit32.SetBits([12,13,20]);
// ===============================================

procedure TBit32.SetBits(ABitNumArray : array of byte);
var iMask : longword;
begin
  iMask := _CalcMask(ABitNumArray);
  FValue2 := longword(FValue2) or iMask;
end;


// ===============================================
// Clear a bit (bit = 0) by bit number 0..31
// ===============================================

procedure TBit32.ClrBit(ABitNumber : byte);
begin
  _CheckBitNumber(ABitNumber);
   FValue2 := (longword(FValue2) or C_BITVALARR[ABitNumber]) xor
             C_BITVALARR[ABitNumber];
end;

// ===============================================
// Clear bits (bit = 0) by bit number array
// eg. MyBit32.ClrBits([12,13,20]);
// ===============================================

procedure TBit32.ClrBits(ABitNumArray : array of byte);
var iMask : longword;
begin
  iMask := _CalcMask(ABitNumArray);
  FValue2 := (longword(FValue2) or iMask) xor iMask;
end;


// ===============================================
// Toggle a bit (0=1 1=0) by bit number 0..31
// ===============================================

procedure TBit32.ToggleBit(ABitNumber : byte);
begin
  _CheckBitNumber(ABitNumber);
   FValue2 := longword(FValue2) xor C_BITVALARR[ABitNumber];
end;

// ===============================================
// Toggle bits (0=1 1=0) by bit number array
// eg. MyBit32.ToggleBits([12,13,20]);
// ===============================================

procedure TBit32.ToggleBits(ABitNumArray : array of byte);
var iMask : longword;
begin
  iMask := _CalcMask(ABitNumArray);
  FValue2 := longword(FValue2) xor iMask;
end;


// ====================================================
// Rotate the value left by 1
// The lost bit in bit 31 is restored in bit 0
// ====================================================

procedure TBit32.RotateLeft;
var bBit31Set : boolean;
begin
  bBit31Set := FValue and $80000000 = $80000000;
  FValue := FValue shl 1;
  if bBit31Set then FValue := FValue or 1;
end;

// ====================================================
// Rotate the value right by 1
// The lost bit in bit 0 is restored in bit 31
// ====================================================

procedure TBit32.RotateRight;
var bBit00Set : boolean;
begin
  bBit00Set := FValue and 1 = 1;
  FValue := FValue shr 1;
  if bBit00Set then FValue := longword(FValue) or $80000000;;
end;

end.
