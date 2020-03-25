unit nodave;
  interface
(*uses windows;*)
{ Automatically converted by H2Pas 0.99.15 from nd.h }
{ The following command line parameters were used:
    nodave.h.  And modified to make it work.    
}

{ $ PACKRECORDS C}

  {
   Part of Libnodave, a free communication libray for Siemens S7 200/300/400 via
   the MPI adapter 6ES7 972-0CA22-0XAC
   or  MPI adapter 6ES7 972-0CA23-0XAC
   or  TS adapter 6ES7 972-0CA33-0XAC
   or  MPI adapter 6ES7 972-0CA11-0XAC,
   IBH-NetLink or CPs 243, 343 and 443

   (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2002..2004

   Libnodave is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   Libnodave is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Libnodave; see the file COPYING.  If not, write to
   the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
   }
{ $ifndef __nodave}
{ $define __nodave}

{$ifdef LINUX}
    type

       _daveOSserialType = record
            rfd : longint;
            wfd : longint;
         end;
{$endif}
{$ifdef WIN32}
    type
        pHandle=longint;
       _daveOSserialType = record
            rfd : pHANDLE;
            wfd : pHANDLE;
         end;
{$endif}

    {
        Define this if your system doesn't have byteswap.h or if you experience difficulties with
        the inline functions
     }
    { #define HANDMADE_CONVERSIONS  }
    { this is now done in the Makefile:  }
    { #define LINUX  }
    { #include "log.h"  }
    {
        some frequently used ASCII control codes:
     }

    const
       DLE = $10;
       ETX = $03;
       STX = $02;
       SYN = $16;
    {
        Protocol types to be used with newInterface:
     }
    { MPI for S7 300/400  }
       daveProtoMPI = 0;
    { MPI for S7 300/400, "Andrew's version"  }
       daveProtoMPI2 = 1;
    { PPI for S7 200  }
       daveProtoPPI = 2;
    { ISO over TCP  }
       daveProtoISOTCP = 122;
    { ISO over TCP with CP243  }
       daveProtoISOTCP243 = 123;
    { MPI with IBH NetLink MPI to ethernet gateway  }
       daveProtoIBH = 223;
    {
          ProfiBus speed constants:
     }
       daveSpeed9k = 0;
       daveSpeed19k = 1;
       daveSpeed187k = 2;
       daveSpeed500k = 3;
       daveSpeed1500k = 4;
       daveSpeed45k = 5;
       daveSpeed93k = 6;
    {
        Some MPI function codes (yet unused ones may be incorrect).
     }
       daveFuncOpenS7Connection = $F0;
       daveFuncRead = $04;
       daveFuncWrite = $05;
       daveFuncStartUpload = $1D;
       daveFuncUpload = $1E;
       daveFuncEndUpload = $1F;
    {
        S7 specific constants:
     }
       daveBlockType_OB = '8';
       daveBlockType_DB = 'A';
       daveBlockType_SDB = 'B';
       daveBlockType_FC = 'C';
       daveBlockType_SFC = 'D';
       daveBlockType_FB = 'E';
       daveBlockType_SFB = 'F';
    {
        Use these constants for parameter "area" in daveReadBytes and daveWriteBytes
     }
    { System info of 200 family  }
       daveSysInfo = $3;
    { System flags of 200 family  }
       daveSysFlags = $5;
    { analog inputs of 200 family  }
       daveAnaIn = $6;
    { analog outputs of 200 family  }
       daveAnaOut = $7;
       daveInputs = $81;
       daveOutputs = $82;
       daveFlags = $83;
    { data blocks  }
       daveDB = $84;
    { not tested  }
       daveDI = $85;
    { not tested  }
       daveLocal = $86;
    { don't know what it is  }
       daveV = $87;
       daveCounter = 28;
       daveTimer = 29;
    { 
        Library specific:
      }
    {
        Result codes. Genarally, 0 means ok, 
        >0 are results (also errors) reported by the PLC
        <0 means error reported by library code.
     }
    { means all ok  }
       daveResOK = 0;
    { CPU tells it does not support to read a bit block with a  }
       daveResMultipleBitsNotSupported = 6;
    { length other than 1 bit.  }
    { means a a piece of data is not available in the CPU, e.g.  }
       daveResItemNotAvailable200 = 3;
    { when trying to read a non existing DB or bit bloc of length<>1  }
    { This code seems to be specific to 200 family.  }
    { means a a piece of data is not available in the CPU, e.g.  }
       daveResItemNotAvailable = 10;
    { when trying to read a non existing DB  }
    { means the data address is beyond the CPUs address range  }
       daveAddressOutOfRange = 5;
       daveResCannotEvaluatePDU = -(123);
       daveResCPUNoData = -(124);
       daveUnknownError = -(125);
       daveEmptyResultError = -(126);
       daveEmptyResultSetError = -(127);
    {
        error code to message string conversion:
        Call this function to get an explanation for error codes returned by other functions.
     }

    function daveStrerror(code:longint):Pchar; 
	external 'libnodave.dll' {$ifdef WIN32} name '_daveStrerror'{$ENDIF};

    {
        Max number of bytes in a single message. 
        An upper limit for MPI over serial is:
        8		transport header
        +2 240	max PDU len  2 if every character were a DLE
        +3		DLE,ETX and BCC
        = 491

        Later I saw some programs offering up to 960 bytes in PDU size negotiation    

        Max number of bytes in a single message. 
        An upper limit for MPI over serial is:
        8		transport header
        +2 960	max PDU len  2 if every character were a DLE
        +3		DLE,ETX and BCC
        = 1931
        
        For now, we take the rounded max of all this to determine our buffer size. This is ok
        for PC systems, where one k less or more doesn't matter.
     }

    const
       daveMaxRawLen = 2048;
    {
        Some definitions for debugging:
     }
    { Show the single bytes received  }
       daveDebugRawRead = $01;
    { Show when special chars are read  }
       daveDebugSpecialChars = $02;
    { Show the single bytes written  }
       daveDebugRawWrite = $04;
    { Show the steps when determine devices in MPI net  }
       daveDebugListReachables = $08;
    { Show the steps when Initilizing the MPI adapter  }
       daveDebugInitAdapter = $10;
    { Show the steps when connecting a PLC  }
       daveDebugConnect = $20;
       daveDebugPacket = $40;
       daveDebugByte = $80;
       daveDebugCompare = $100;
       daveDebugExchange = $200;
    { debug PDU handling  }
       daveDebugPDU = $400;
    { debug PDU loading program blocks from PLC  }
       daveDebugUpload = $800;
       daveDebugMPI = $1000;
    { Print error messages  }
       daveDebugPrintErrors = $2000;
       daveDebugPassive = $4000;
       daveDebugAll = $ffff;

      (* var
         daveDebug : longint;cvar;external 'libnodave' {$ifdef WIN32} name 'daveDebug';
         *)


  {
        Some data types:
     }
     type uc = char;
        Puc=^char;
	pPuc=^puc;
	us = word;
	Pus =^us;

    {
        This is a wrapper for the serial or ethernet interface. This is here to make porting easier.
     }
{
    type
       _daveConnection = daveConnection;
       _daveInterface = daveInterface;
}       
    {
        Helper struct to manage PDUs. This is NOT the part of the packet I would call PDU, but
        a set of pointers that ease access to the "private parts" of a PDU.
     }
    { pointer to start of PDU (PDU header)  }
    { pointer to start of parameters inside PDU  }
    { pointer to start of data inside PDU  }
    { pointer to start of data inside PDU  }
    { header length  }
    { parameter length  }
    { data length  }
    { user or result data length  }
type
       PDU = record
            header : Puc;
            param : Puc;
            data : Puc;
            udata : Puc;
            hlen : longint;
            plen : longint;
            dlen : longint;
            udlen : longint;
         end;
	 PPDU =^PDU;
    {
        Definitions of prototypes for the protocol specific functions. The library "switches" 
        protocol by setting pointers to the protol specific implementations.
     }
    { 
        This groups an interface together with some information about it's properties
        in the library's context.
     }
    { some handle for the serial interface  }
    { a counter used when multiple PLCs are accessed via  }
    { the same serial interface and adapter.  }
    { the adapter's MPI address  }
    { just a name that can be used in programs dealing with multiple  }
    { daveInterfaces  }
    { Timeout in microseconds used in transort.  }
    { The kind of transport protocol used on this interface.  }
    { The MPI or Profibus speed  }
    { position of some packet number that has to be repeated in ackknowledges  }
    { pointers to the protocol  }
    { specific implementations  }
    { of these functions  }
    
    type

       MPIheader = record
            src_conn : uc;
            dst_conn : uc;
            MPI : uc;
            localMPI : uc;
            len : uc;
            func : uc;
            packetNumber : uc;
         end;

    pdaveInterface=^_daveInterface;
    pdaveConnection=^_daveConnection;
    
    
        { 
        This holds data for a PLC connection;
     }
    { pointer to used interface  }
    { The PLC's address  }
    { current message number  }
    { message number we need ackknowledge for  }
    { length of last message  }
    { template of MPI Header, setup once, copied in and then modified  }
    { used to retrieve single values from the result byte array  }
    { packetNumber in transport layer  }
    { position of PDU in outgoing messages. This is different for different transport methodes.  }
    { position of PDU in incoming messages. This is different for different transport methodes.  }
    { rack number for ISO over TCP  }
    { slot number for ISO over TCP  }
       _daveConnection = record
            iface : PdaveInterface;
            MPIAdr : longint;
            messageNumber : longint;
            needAckNumber : longint;
            AnswLen : longint;
            rcvdPDU : PDU;
            templ : MPIheader;
            msgIn : array[0..(daveMaxRawLen)-1] of uc;
            msgOut : array[0..(daveMaxRawLen)-1] of uc;
            resultPointer : Puc;
            _resultPointer : Puc;
            packetNumber : uc;
            PDUstartO : longint;
            PDUstartI : longint;
            rack : longint;
            slot : longint;
            ackByte2 : uc;
         end;

    
    initAdapterFunc=function(d:pdaveInterface):longint;
    connectPLCFunc=function(d:pdaveConnection):longint;
    disconnectPLCFunc=function(d:pdaveConnection):longint;
    disconnectAdapterFunc=function(d:pdaveInterface):longint;
    
    PinitAdapterFunc=^initAdapterFunc;
    PconnectPLCFunc=^connectPLCFunc;
    PdisconnectPLCFunc=^initAdapterFunc;
    PdisconnectAdapterFunc=^disconnectAdapterFunc;
    PexchangeFunc=^initAdapterFunc;
    PlistReachablePartnersFunc=^initAdapterFunc;
    
       _daveInterface = record
            fd : _daveOSserialType;
            users : longint;
            localMPI : longint;
            name : Pchar;
            timeout : longint;
            protocol : longint;
            speed : longint;
            ackPos : longint;
            initAdapter : PinitAdapterFunc;
            connectPLC : PconnectPLCFunc;
            disconnectPLC : PdisconnectPLCFunc;
            disconnectAdapter : PdisconnectAdapterFunc;
            exchange : PexchangeFunc;
            listReachablePartners : PlistReachablePartnersFunc;
         end;
    daveInterface=_daveInterface;
(*    pdaveInterface=^_daveInterface; *)

    {
        A special header for MPI packets:
     }


    type

       daveBlockTypeEntry = record
            type_ : array[0..1] of uc;
            count : word;
         end;
	pdaveBlockTypeEntry = ^daveBlockTypeEntry;

       daveBlockEntry = record
            number : word;
            type_ : array[0..1] of uc;
         end;
	 pdaveBlockEntry = ^daveBlockEntry;

    { 00 4A  }
    { some word var?  }
    { allways 'pp'  }
    { 00 4A  }
    { the block's number  }
    { ?  }
    { the block's length  }

       daveBlockInfo = record
            type_ : array[0..1] of uc;
            x1 : array[0..1] of uc;
            w1 : array[0..1] of uc;
            pp : array[0..1] of char;
            x2 : array[0..3] of uc;
            number : word;
            x3 : array[0..25] of uc;
            length : word;
            x4 : array[0..15] of uc;
            name : array[0..7] of uc;
            x5 : array[0..11] of uc;
         end;
    { 
        PDU handling:
        PDU is the central structure present in S7 communication.
        It is composed of a 10 or 12 byte header,a parameter block and a data block.
        When reading or writing values, the data field is itself composed of a data
        header followed by payload data
      }
    { allways 0x32  }
    { Header type, one of 1,2,3 or 7. type 2 and 3 headers are two bytes longer.  }
    { currently unknown. Maybe it can beused for long numbers?  }
    { A number. This can be used to make sure a received answer  }
    { corresponds to the request with the same number.  }
    { length of parameters which follow this header  }
    { length of data which follow the parameters  }
    { only present in type 2 and 3 headers. This contains error information.  }

       PDUHeader = record
            P : uc;
            type_ : uc;
            a : uc;
            b : uc;
            number : us;
            plen : us;
            dlen : us;
            result : array[0..1] of uc;
         end;

    {
        Setup a new connection structure using an initialized
        daveInterface and PLC's MPI address.
     }

    function daveNewConnection(di:PdaveInterface; MPI:longint; rack:longint; slot:longint):
    PdaveConnection; stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveNewConnection'{$ENDIF};

    function daveNewInterface(nfd:_daveOSserialType; nname:pchar; localMPI:longint;protocol:longint; speed:longint)
	:PdaveInterface;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveNewInterface'{$ENDIF};

    {
        set up the header. Needs valid header pointer in the struct p points to.
     }

    procedure _daveInitPDUheader(p:PPDU; type_:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveInitPDUheader'{$ENDIF};
    {
        add parameters after header, adjust pointer to data.
        needs valid header
     }
    procedure _daveAddParam(p:PPDU; param:Puc; len:us);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveAddParam'{$ENDIF};

    {
        add data after parameters, set dlen
        needs valid header,and valid parameters.
     }
    procedure _daveAddData(p:PPDU; data:pointer; len:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveAddData'{$ENDIF};

    {
        add values after value header in data, adjust dlen and data count.
        needs valid header,parameters,data,dlen
     }
    procedure _daveAddValue(p:PPDU; data:pointer; len:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveAddValue'{$ENDIF};

    {
        add data in user data. Add a user data header, if not yet present.
     }
    procedure _daveAddUserData(p:PPDU; da:Puc; len:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveAddUserData'{$ENDIF};

    {
        set up pointers to the fields of a received message
     }
    function _daveSetupReceivedPDU(p:PPDU):longint;stdcall;cdecl;
	external 'libnodave'  {$ifdef WIN32} name '__daveSetupReceivedPDU'{$ENDIF};

    {
        send PDU to PLC and retrieves the answer
     }
    function _daveExchange(dc:PdaveConnection; p:PPDU):longint;stdcall;cdecl;
	external 'libnodave'  {$ifdef WIN32} name '__daveExchange'{$ENDIF};

    {     
        
        Utilities:
        
        }
    {
        Hex dump PDU:
     }
    procedure _daveDumpPDU(p:PPDU);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveDumpPDU'{$ENDIF};

    {
        This is an extended memory compare routine. It can handle don't care and stop flags 
        in the sample data. A stop flag lets it return success, if there were no mismatches
        up to this point.
     }
    type size_t=longint; 
    function _daveMemcmp(a:Pus; b:Puc; len:size_t):longint;stdcall;cdecl;
	external 'libnodave'  {$ifdef WIN32} name '__daveMemcmp'{$ENDIF};
    {
        Hex dump. Write the name followed by len bytes written in hex and a newline:
     }
    procedure _daveDump(name:Pchar; b:Puc; len:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveDump'{$ENDIF};

    {
        name Objects:
     }
    function daveBlockName(bn:uc):Pchar;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveBlockName'{$ENDIF};


    function daveAreaName(n:uc):Pchar;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveAreaName'{$ENDIF};

    {
        Data conversion convenience functions:
     }

    function daveGetFloat(dc:PdaveConnection):single;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetFloat'{$ENDIF};

    function daveGetInteger(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetInteger'{$ENDIF};

    function daveGetDWORD(dc:PdaveConnection):Longword;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetDWORD'{$ENDIF};

    function daveGetUnsignedInteger(dc:PdaveConnection):Longword;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetUnsignedInteger'{$ENDIF};

    function daveGetWORD(dc:PdaveConnection):Longword;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetWORD'{$ENDIF};

    function daveGetByteat(dc:PdaveConnection; pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetByteat'{$ENDIF};

    function daveGetWORDat(dc:PdaveConnection; pos:longint):Longword;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetWORDat'{$ENDIF};

    function daveGetDWORDat(dc:PdaveConnection; pos:longint):Longword;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetDWORDat'{$ENDIF};

    function daveGetFloatat(dc:PdaveConnection; pos:longint):single;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetFloatat'{$ENDIF};
     function daveGetByte(dc:PdaveConnection):Longword;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetByte'{$ENDIF};

    {
    int daveGetBytesLeft(daveConnection   dc)
        return ( dc->AnswLen-(int)(dc->resultPointer)+(int)(dc->rcvdPDU.data));
    }

    function toPLCfloat(ff:single):double;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_toPLCfloat'{$ENDIF};

    function bswap_16(ff:smallint):smallint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_bswap_16'{$ENDIF};

    function bswap_32(ff:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_bswap_32'{$ENDIF};

    { 
        Timer and Counter conversion functions:
      }
    {	
        get time in seconds from current read position:
     }

    function daveGetSeconds(dc:PdaveConnection):double;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetSeconds'{$ENDIF};

    {	
        get time in seconds from random position:
     }
    function daveGetSecondsAt(dc:PdaveConnection; pos:longint):double;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetSecondsAt'{$ENDIF};

    {	
        get counter value from current read position:
     }
    function daveGetCounterValue(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetCounterValue'{$ENDIF};

    {	
        get counter value from random read position:
     }
    function daveGetCounterValueAt(dc:PdaveConnection; pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetCounterValueAt'{$ENDIF};

    {
        Functions to load blocks from PLC:
     }
    procedure _daveConstructUpload(p:PPDU; blockType:char; blockNr:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveConstructUpload'{$ENDIF};

    procedure _daveConstructDoUpload(p:PPDU; uploadID:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveConstructDoUpload'{$ENDIF};

    procedure _daveConstructEndUpload(p:PPDU; uploadID:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveConstructEndUpload'{$ENDIF};

    {
        Get the PLC's order code as ASCIIZ. Buf must provide space for
        21 characters at least.
     }

    const
       daveOrderCodeSize = 21;

    function daveGetOrderCode(dc:PdaveConnection; buf:Pchar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetOrderCode'{$ENDIF};

    {
        connect to a PLC. returns 0 on success.
     }
    function daveConnectPLC(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveConnectPLC'{$ENDIF};

    { 
        Read len bytes from the PLC. Start determines the first byte.
        Area denotes whether the data comes from FLAGS, DATA BLOCKS,
        INPUTS or OUTPUTS. The reading and writing of other data
        like timers and counters is not supported.
        DB is the number of the data block to be used. Set it to zero
        for other area types.
        Buffer is a pointer to a memory block provided by the calling
        program. If the pointer is not NULL, the result data will be copied thereto.
        Hence it must be big enough to take up the result.
        In any case, you can also retrieve the result data using the get<type> macros
        on the connection pointer.
        
        FIXME:	Existence of DB is not checked.
    		There is no error message for nonexistent data blocks.
    		There is no check for max. message len or 
    		automatic splitting into multiple messages.
     }
    function daveReadBytes(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveReadBytes'{$ENDIF};

    { 
        Write len bytes from buffer to the PLC. 
        Start determines the first byte.
        Area denotes whether the data goes to FLAGS, DATA BLOCKS,
        INPUTS or OUTPUTS. The writing of other data
        like timers and counters is not supported.
        DB is the number of the data block to be used. Set it to zero
        for other area types.
        FIXME:	Existence of DB is not checked.
    		There is no error message for nonexistent data blocks.
    		There is no check for max. message len or
    		automatic splitting into multiple messages.
     }
    function daveWriteBytes(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveWriteBytes'{$ENDIF};

    { 
        Bit manipulation:
     }
    function daveReadBits(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint;
               buffer:pointer):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveReadBits'{$ENDIF};

    function daveWriteBits(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveWriteBits'{$ENDIF};

    {
        PLC diagnostic and inventory functions:
     }
    function daveReadSZL(dc:PdaveConnection; ID:longint; index:longint; buf:pointer):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveReadSZL'{$ENDIF};

    function daveListBlocksOfType(dc:PdaveConnection; type_:uc; buf:PdaveBlockEntry):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveListBlocksOfType'{$ENDIF};

    function daveListBlocks(dc:PdaveConnection; buf:PdaveBlockTypeEntry):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveListBlocks'{$ENDIF};

    {
        PLC program read functions:
     }
    function initUpload(dc:PdaveConnection; blockType:char; blockNr:longint; uploadID:Plongint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_initUpload'{$ENDIF};

    function doUpload(dc:PdaveConnection; more:Plongint; buffer:PPuc; len:Plongint; uploadID:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_doUpload'{$ENDIF};

    function endUpload(dc:PdaveConnection; uploadID:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_endUpload'{$ENDIF};

    {
        Multiple variable support:
     }

    type

       daveResult = record
            error : longint;
            length : longint;
            bytes : Puc;
         end;
	pdaveResult=^daveResult;

       daveResultSet = record
            numResults : longint;
            results : PdaveResult;
         end;
	pdaveResultSet=^daveResultSet; 
    { use this to initialize a multivariable read:  }

    procedure davePrepareReadRequest(dc:PdaveConnection; p:PPDU);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_davePrepareReadRequest'{$ENDIF};
    procedure davePrepareWriteRequest(dc:PdaveConnection; p:PPDU);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_davePrepareWriteRequest'{$ENDIF};

    { Adds a new variable to a prepared request:  }
    procedure daveAddVarToReadRequest(p:PPDU; area:longint; DBnum:longint; start:longint; bytes:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveAddVarToReadRequest'{$ENDIF};
    procedure daveAddVarToWriteRequest(p:PPDU; area:longint; DBnum:longint; start:longint; bytes:longint; buffer:pointer);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveAddVarToWriteRequest'{$ENDIF};	
    procedure daveAddBitVarToWriteRequest(p:PPDU; area:longint; DBnum:longint; start:longint; bytes:longint; buffer:pointer);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveAddBitVarToWriteRequest'{$ENDIF};		

    { Executes the complete request.  }
    function daveExecReadRequest(dc:PdaveConnection; p:PPDU; rl:PdaveResultSet):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveExecReadRequest'{$ENDIF};
    function daveExecWriteRequest(dc:PdaveConnection; p:PPDU; rl:PdaveResultSet):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveExecWriteRequest'{$ENDIF};

    { Lets the functions daveGet<data type> work on the n-th result:  }
    function daveUseResult(dc:PdaveConnection; rl:daveResultSet; n:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveUseResult'{$ENDIF};

    { Frees the memory occupied by the result structure  }
    procedure daveFreeResults(rl:PdaveResultSet);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveFreeResults'{$ENDIF};

    function daveInitAdapter(di:PdaveInterface):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveInitAdapter'{$ENDIF};

    function daveDisconnectPLC(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveDisconnectPLC'{$ENDIF};

    function daveDisconnectAdapter(di:PdaveInterface):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveDisconnectAdapter'{$ENDIF};

    function daveListReachablePartners(di:PdaveInterface; buf:Pchar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveListReachablePartners'{$ENDIF};

    function _daveListReachablePartnersDummy(di:PdaveInterface; buf:Pchar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveListReachablePartnersDummy'{$ENDIF};

    { MPI specific functions  }

    const
       daveMPIReachable = $30;
       daveMPIunused = $10;
       davePartnerListSize = 126;

    function _daveListReachablePartnersMPI(di:PdaveInterface; buf:Pchar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveListReachablePartnersMPI'{$ENDIF};

    function _daveInitAdapterMPI1(di:PdaveInterface):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveInitAdapterMPI1'{$ENDIF};

    function _daveInitAdapterMPI2(di:PdaveInterface):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveInitAdapterMPI2'{$ENDIF};

    function _daveConnectPLCMPI1(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveConnectPLCMPI1'{$ENDIF};

    function _daveConnectPLCMPI2(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveConnectPLCMPI2'{$ENDIF};

    function _daveDisconnectPLCMPI(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveDisconnectPLCMPI'{$ENDIF};

    function _daveDisconnectAdapterMPI(di:PdaveInterface):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveDisconnectAdapterMPI'{$ENDIF};

    function _daveExchangeMPI(dc:PdaveConnection; p1:PPDU):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveExchangeMPI'{$ENDIF};

    { ISO over TCP specific functions  }
    function _daveExchangeTCP(dc:PdaveConnection; p1:PPDU):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveExchangeTCP'{$ENDIF};

    function _daveConnectPLCTCP(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveConnectPLCTCP'{$ENDIF};

    { PPI specific functions  }
    function _daveExchangePPI(dc:PdaveConnection; p1:PPDU):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveExchangePPI'{$ENDIF};

    {
        make PPI functions available for "passive mode"
     }
    procedure _daveSendYOURTURN(dc:PdaveConnection);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendYOURTURN'{$ENDIF};

    procedure _daveSendLength(di:PdaveInterface; len:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendLength'{$ENDIF};

    procedure _daveSendIt(di:PdaveInterface; b:Puc; size:longint);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendIt'{$ENDIF};

    { serial interface  }
    { a buffer  }
    { timeout in us  }
    { limit  }
    function _daveReadChars(di:PdaveInterface; b:Puc; tmo:longint; max:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveReadChars'{$ENDIF};

    {
        make MPI functions available for experimental use:
     }
    function _daveReadMPI(di:PdaveInterface; b:Puc):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveReadMPI'{$ENDIF};

    procedure _daveSendSingle(di:PdaveInterface; c:uc);stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendSingle'{$ENDIF};

    function _daveSendAck(dc:PdaveConnection; nr:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendAck'{$ENDIF};

    function _daveGetAck(di:PdaveInterface; nr:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveGetAck'{$ENDIF};

    function _daveSendDialog2(dc:PdaveConnection; size:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendDialog2'{$ENDIF};
	
    function _daveSendWithPrefix(dc: PdaveConnection; b:Puc; size:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendWithPrefix'{$ENDIF};

    function _daveSendWithPrefix2(dc: PdaveConnection; size:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendWithPrefix2'{$ENDIF};	

    function _daveSendWithCRC(di: PdaveInterface; b:Puc; size:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendWithCRC'{$ENDIF};

    function _daveReadSingle(di: PdaveInterface):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveReadSingle'{$ENDIF};	

    function _daveReadOne(di: PdaveInterface; b:Puc):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveReadOne'{$ENDIF};	
    
    function _daveReadMPI2(dc: PdaveInterface; b:Puc):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveReadMPI2'{$ENDIF};
    
    function _daveGetResponseMPI(dc: PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveGetResponseMPI'{$ENDIF};

    function _daveSendMessageMPI(dc:PdaveConnection; p1:PPDU):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '__daveSendMessageMPI'{$ENDIF};

{$IFDEF WIN32}	
    function setPort(name:pchar; baud: pchar; parity:char):pHandle; stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name 'setPort'{$ENDIF};
{$ENDIF}
{$IFDEF LINUX}	
    function setPort(name:pchar; baud: pchar; parity:char):longint; stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name 'setPort'{$ENDIF};
{$ENDIF}
    function openSocket(port:longint;name:pchar):longint; stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_openSocket'{$ENDIF};


    procedure setDebug(nDebug:longint); stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_setDebug'{$ENDIF};


    { _nodave  }
    {
        Changes:
        07/19/04 added the definition of daveExchange().
        09/09/04 applied patch for variable Profibus speed from Andrew Rostovtsew.
        09/09/04 applied patch from Bryan D. Payne to make this compile under Cygwin and/or newer gcc.
        12/09/04 added daveReadBits(), daveWriteBits()
        12/09/04 added some more comments.
        12/09/04 changed declaration of _daveMemcmp to use typed pointers.
     }

    function daveGetS8(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS8'{$ENDIF};
    function daveGetU8(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU8'{$ENDIF};	
    function daveGetS16(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS16'{$ENDIF};
    function daveGetU16(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU16'{$ENDIF};	
    function daveGetS32(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS32'{$ENDIF};
    function daveGetU32(dc:PdaveConnection):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU32'{$ENDIF};		

    function daveGetS8at(dc:PdaveConnection;pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS8at'{$ENDIF};
    function daveGetU8at(dc:PdaveConnection;pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU8at'{$ENDIF};	
    function daveGetS16at(dc:PdaveConnection;pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS16at'{$ENDIF};
    function daveGetU16at(dc:PdaveConnection;pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU16at'{$ENDIF};	
    function daveGetS32at(dc:PdaveConnection;pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS32at'{$ENDIF};
    function daveGetU32at(dc:PdaveConnection;pos:longint):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU32at'{$ENDIF};


    function daveGetS8from(b:pChar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS8from'{$ENDIF};
    function daveGetU8from(b:pChar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU8from'{$ENDIF};
    function daveGetS16from(b:pChar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS16from'{$ENDIF};
    function daveGetU16from(b:pChar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU16from'{$ENDIF};	
    function daveGetS32from(b:pChar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetS32from'{$ENDIF};
    function daveGetU32from(b:pChar):longint;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetU32from'{$ENDIF};
    function daveGetFloatfrom(b:pChar):single;stdcall;cdecl;
	external 'libnodave' {$ifdef WIN32} name '_daveGetFloatfrom'{$ENDIF};

    implementation
begin
end.
