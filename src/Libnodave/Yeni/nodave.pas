unit nodave;
  interface
(*uses windows;*)
{ Automatically converted by H2Pas 0.99.15 from nodave.h }
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
   IBH/MHJ-NetLink or CPs 243, 343 and 443
   or VIPA Speed7 with builtin ethernet support.

   (C) Thomas Hergenhahn (thomas.hergenhahn@web.de) 2002..2005

   Libnodave is free software; you can redistribute it and/or modify
   it under the terms of the GNU Library General Public License as published by
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
    const LibName = 'libnodave';
{$endif}
{$ifdef WIN32}
    type
        pHandle=longint;
       _daveOSserialType = record
            rfd : pHANDLE;
            wfd : pHANDLE;
         end;
    const LibName = 'libnodave.dll';
	 
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
    { MPI for S7 300/400, what Step7 speaks, experimental"  }
       daveProtoMPI3 = 2;
    { MPI for S7 300/400, "Andrew's version" with additional STX  }
       daveProtoMPI4 = 3;
    { PPI for S7 200  }
       daveProtoPPI = 10;
    { S5 via programmer port }
       daveProtoAS511 = 20;

    { use S7Onlinx.dll for transport }
       daveProtoS7Online = 50;


    { ISO over TCP  }
       daveProtoISOTCP = 122;
    { ISO over TCP with CP243  }
       daveProtoISOTCP243 = 123;
    { MPI with IBH NetLink MPI to ethernet gateway  }
       daveProtoMPI_IBH = 223;
       daveProtoPPI_IBH = 224;
    { MPI with NetLink Pro MPI to ethernet gateway  }
       daveProtoNLpro = 230;   
    { user defined transport protocol }
       daveProtoUserTransport = 255;   
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
	daveFuncRequestDownload = $1A;
	daveFuncDownloadBlock = $1B;
	daveFuncDownloadEnded = $1C;
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
       daveP = $80;
		{ Peripheral data like PIW, PQW }
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

    function daveStrerror(code:longint):Pchar;stdcall;
	external LibName {$ifdef WIN32} name 'daveStrerror'{$ENDIF};

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
       daveDebugErrorReporting = $8000;
       daveDebugOpen = $10000;
       daveDebugAll = $1ffff;


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
	    AnswLen : longint;
	    resultPointer : Puc;
	    maxPDUlength : longint;
	    MPIAdr : longint;
            iface : PdaveInterface;
	    needAckNumber : longint;
            PDUnumber : longint;
	    ibhSrcConn : longint;
	    ibhDstConn : longint;
	    msgIn : array[0..(daveMaxRawLen)-1] of uc;
            msgOut : array[0..(daveMaxRawLen)-1] of uc;
	    _resultPointer : Puc;
	    PDUstartO : longint;
            PDUstartI : longint;
            rack : longint;
            slot : longint;
	    connectionNumber : longint;
	    connectionNumber2 : longint;
	    messageNumber : uc;
	    packetNumber : uc;
         end;

    
    initAdapterFunc=function(d:pdaveInterface):longint;
    connectPLCFunc=function(d:pdaveConnection):longint;
    disconnectPLCFunc=function(d:pdaveConnection):longint;
    disconnectAdapterFunc=function(d:pdaveInterface):longint;
    exchangeFunc=function(d:pdaveConnection;p:pPDU):longint;
    sendMessageFunc=function(d:pdaveConnection;p:pPDU):longint;
    getResponseFunc=function(d:pdaveConnection):longint;
    listReachablePartnersFunc=function(d:pdaveInterface; buffer:puc):longint;
    
    PinitAdapterFunc=^initAdapterFunc;
    PconnectPLCFunc=^connectPLCFunc;
    PdisconnectPLCFunc=^initAdapterFunc;
    PdisconnectAdapterFunc=^disconnectAdapterFunc;
    PexchangeFunc=^exchangeFunc;
    PsendMessageFunc=^sendMessageFunc;
    PgetResponseFunc=^getResponseFunc;
    PlistReachablePartnersFunc=^listReachablePartnersFunc;
    
    
       _daveInterface = record
    	    timeout : longint;
            fd : _daveOSserialType;
	    localMPI : longint;
            users : longint;
            name : Pchar;
            protocol : longint;
            speed : longint;
            ackPos : longint;
	    nextConnection : longint;
            initAdapter : PinitAdapterFunc;
            connectPLC : PconnectPLCFunc;
            disconnectPLC : PdisconnectPLCFunc;
            disconnectAdapter : PdisconnectAdapterFunc;
            exchange : PexchangeFunc;
	    sendMessage : PsendMessageFunc;
	    getResponse : PgetResponseFunc;
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
	 pdaveBlockInfo = ^daveBlockInfo;
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
    PdaveConnection; stdcall;
	external LibName {$ifdef WIN32} name 'daveNewConnection'{$ENDIF};

{  $DEFINE NOSOLUTION}  
{$DEFINE SOLUTION1}  
{  $DEFINE SOLUTION2}
(*  
    Somehow, it seems that when I declare this function stdcall, the parameter nfd is not passed
    by value as is expected by the .dll. Instead, probably a pointer is passed (call by reference).
*)    
{$ifdef NOSOLUTION}
    function daveNewInterface(nfd:_daveOSserialType; nname:pchar; localMPI:longint;protocol:longint; speed:longint)
	:PdaveInterface;stdcall;
	external LibName {$ifdef WIN32} name 'daveNewInterface'{$ENDIF};
{$ENDIF}

{$ifdef SOLUTION1}    
    function internalDaveNewInterface(a:longint;b:longint; nname:pchar; localMPI:longint;protocol:longint; speed:longint)
	:PdaveInterface;stdcall;
	external LibName name 'daveNewInterface';
{$ENDIF}	
{$ifdef SOLUTION2}    
    function daveNewInterface(nfd:_daveOSserialType; nname:pchar; localMPI:longint;protocol:longint; speed:longint)
	:PdaveInterface;stdcall;
	external LibName name 'davePascalNewInterface';
{$ENDIF}

    {
        set up the header. Needs valid header pointer in the struct p points to.
     }

    procedure _daveInitPDUheader(p:PPDU; type_:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveInitPDUheader'{$ENDIF};
    {
        add parameters after header, adjust pointer to data.
        needs valid header
     }
    procedure _daveAddParam(p:PPDU; param:Puc; len:us);stdcall;
	external LibName {$ifdef WIN32} name '_daveAddParam'{$ENDIF};

    {
        add data after parameters, set dlen
        needs valid header,and valid parameters.
     }
    procedure _daveAddData(p:PPDU; data:pointer; len:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveAddData'{$ENDIF};

    {
        add values after value header in data, adjust dlen and data count.
        needs valid header,parameters,data,dlen
     }
    procedure _daveAddValue(p:PPDU; data:pointer; len:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveAddValue'{$ENDIF};

    {
        add data in user data. Add a user data header, if not yet present.
     }
    procedure _daveAddUserData(p:PPDU; da:Puc; len:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveAddUserData'{$ENDIF};

    {
        set up pointers to the fields of a received message
     }
    function _daveSetupReceivedPDU(dc:PdaveConnection; p:PPDU):longint;stdcall;
	external LibName  {$ifdef WIN32} name '_daveSetupReceivedPDU'{$ENDIF};

    {
        send PDU to PLC and retrieves the answer
     }
    function _daveExchange(dc:PdaveConnection; p:PPDU):longint;stdcall;
	external LibName  {$ifdef WIN32} name '_daveExchange'{$ENDIF};

    {     
        
        Utilities:
        
        }
    {
        Hex dump PDU:
     }
    procedure _daveDumpPDU(p:PPDU);stdcall;
	external LibName {$ifdef WIN32} name '_daveDumpPDU'{$ENDIF};

    {
        This is an extended memory compare routine. It can handle don't care and stop flags 
        in the sample data. A stop flag lets it return success, if there were no mismatches
        up to this point.
     }
    type size_t=longint; 
    function _daveMemcmp(a:Pus; b:Puc; len:size_t):longint;stdcall;
	external LibName  {$ifdef WIN32} name '_daveMemcmp'{$ENDIF};
    {
        Hex dump. Write the name followed by len bytes written in hex and a newline:
     }
    procedure _daveDump(name:Pchar; b:Puc; len:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveDump'{$ENDIF};

    {
        name Objects:
     }
    function daveBlockName(bn:uc):Pchar;stdcall;
	external LibName {$ifdef WIN32} name 'daveBlockName'{$ENDIF};


    function daveAreaName(n:uc):Pchar;stdcall;
	external LibName {$ifdef WIN32} name 'daveAreaName'{$ENDIF};

    {
        Data conversion convenience functions:
     }

    function daveGetFloat(dc:PdaveConnection):single;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetFloat'{$ENDIF};

    function daveGetFloatAt(dc:PdaveConnection; pos:longint):single;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetFloatAt'{$ENDIF};

    function toPLCfloat(ff:single):double;stdcall;
	external LibName {$ifdef WIN32} name 'toPLCfloat'{$ENDIF};

    function daveToPLCfloat(ff:single):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveToPLCfloat'{$ENDIF};

    function daveSwapIed_16(ff:smallint):smallint;stdcall;
	external LibName {$ifdef WIN32} name 'daveSwapIed_16'{$ENDIF};

    function daveSwapIed_32(ff:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveSwapIed_32'{$ENDIF};

    { 
        Timer and Counter conversion functions:
      }
    {	
        get time in seconds from current read position:
     }

    function daveGetSeconds(dc:PdaveConnection):double;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetSeconds'{$ENDIF};

    {	
        get time in seconds from random position:
     }
    function daveGetSecondsAt(dc:PdaveConnection; pos:longint):double;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetSecondsAt'{$ENDIF};

    {	
        get counter value from current read position:
     }
    function daveGetCounterValue(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetCounterValue'{$ENDIF};

    {	
        get counter value from random read position:
     }
    function daveGetCounterValueAt(dc:PdaveConnection; pos:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetCounterValueAt'{$ENDIF};

    {
        Functions to load blocks from PLC:
     }
    procedure _daveConstructUpload(p:PPDU; blockType:char; blockNr:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveConstructUpload'{$ENDIF};

    procedure _daveConstructDoUpload(p:PPDU; uploadID:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveConstructDoUpload'{$ENDIF};

    procedure _daveConstructEndUpload(p:PPDU; uploadID:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveConstructEndUpload'{$ENDIF};
	
    function _daveForce200(dc:PdaveConnection; area:longint; start:longint; val:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveForce200'{$ENDIF};

    {
        Get the PLC's order code as ASCIIZ. Buf must provide space for
        21 characters at least.
     }

    const
       daveOrderCodeSize = 21;

    function daveGetOrderCode(dc:PdaveConnection; buf:Pchar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetOrderCode' {$ENDIF};

    {
        connect to a PLC. returns 0 on success.
     }
    function daveConnectPLC(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveConnectPLC'{$ENDIF};

    { 
        Read len bytes from the PLC. Start determines the first byte.
	Area denotes whether the data comes from FLAGS, DATA BLOCKS,
	INPUTS or OUTPUTS, etc. 
	DB is the number of the data block to be used. Set it to zero
	for other area types.
	Buffer is a pointer to a memory block provided by the calling
	program. If the pointer is not NULL, the result data will be copied thereto.
	Hence it must be big enough to take up the result.
	In any case, you can also retrieve the result data using the get<type> macros
	on the connection pointer.
    
	RESTRICTION:There is no check for max. message len or automatic splitting into 
		    multiple messages. Use daveReadManyBytes() in case the data you want
		    to read doesn't fit into a single PDU.
     }
    function daveReadBytes(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveReadBytes'{$ENDIF};

    {
        Read len bytes from the PLC. Start determines the first byte.
	In contrast to daveReadBytes(), this function can read blocks 
	that are too long for a single transaction. To achieve this,
	the data is fetched with multiple subsequent read requests to
	the CPU.
	Area denotes whether the data comes from FLAGS, DATA BLOCKS,
	INPUTS or OUTPUTS, etc. 
	DB is the number of the data block to be used. Set it to zero
	for other area types.
	Buffer is a pointer to a memory block provided by the calling
	program. It may not be NULL, the result data will be copied thereto.
	Hence it must be big enough to take up the result.
	You CANNOT read result bytes from the internal buffer of the
	daveConnection. This buffer is overwritten in each read request.
    }
    function daveReadManyBytes(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveReadManyBytes'{$ENDIF};
    { 
	Write len bytes from buffer to the PLC. 
	Start determines the first byte.
	Area denotes whether the data goes to FLAGS, DATA BLOCKS,
	INPUTS or OUTPUTS, etc.
	DB is the number of the data block to be used. Set it to zero
	for other area types.
	RESTRICTION: There is no check for max. message len or automatic splitting into 
		     multiple messages. Use daveReadManyBytes() in case the data you want
		     to read doesn't fit into a single PDU.

    }
    function daveWriteBytes(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveWriteBytes'{$ENDIF};

    {
        Write len bytes to the PLC. Start determines the first byte.
	In contrast to daveWriteBytes(), this function can write blocks 
	that are too long for a single transaction. To achieve this, the
	the data is transported with multiple subsequent write requests to
	the CPU.
	Area denotes whether the data comes from FLAGS, DATA BLOCKS,
        INPUTS or OUTPUTS, etc. 
	DB is the number of the data block to be used. Set it to zero
	for other area types.
	Buffer is a pointer to a memory block provided by the calling
	program. It may not be NULL.
    }	
    function daveWriteManyBytes(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveWriteManyBytes'{$ENDIF};	

    { 
        Bit manipulation:
     }
    function daveReadBits(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint;
               buffer:pointer):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveReadBits'{$ENDIF};

    function daveWriteBits(dc:PdaveConnection; area:longint; DB:longint; start:longint; len:longint; 
               buffer:pointer):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveWriteBits'{$ENDIF};

    {
        PLC diagnostic and inventory functions:
     }
    function daveReadSZL(dc:PdaveConnection; ID:longint; index:longint; buf:pointer; buflen: longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveReadSZL'{$ENDIF};

    function daveListBlocksOfType(dc:PdaveConnection; type_:uc; buf:PdaveBlockEntry):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveListBlocksOfType'{$ENDIF};

    function daveListBlocks(dc:PdaveConnection; buf:PdaveBlockTypeEntry):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveListBlocks'{$ENDIF};

    function daveGetBlockInfo(dc:PdaveConnection; buf:PdaveBlockInfo; type_:uc; number:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetBlockInfo'{$ENDIF};

    {
        PLC program read functions:
     }
    function initUpload(dc:PdaveConnection; blockType:char; blockNr:longint; uploadID:Plongint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'initUpload'{$ENDIF};

    function doUpload(dc:PdaveConnection; more:Plongint; buffer:PPuc; len:Plongint; uploadID:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'doUpload'{$ENDIF};

    function endUpload(dc:PdaveConnection; uploadID:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'endUpload'{$ENDIF};

 {
    PLC run/stop control functions:
 }
    function daveStop(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveStop'{$ENDIF};
    function daveStart(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveStart'{$ENDIF};
	
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
(*
 This is really a dynamic array, but standard pascal does not know such a thing 
 But here is a 20 results limit in S7, so range check warnings when trying to access an element 
 beyond 20 are appropriate in that sense.
*) 
	resultarray=array [0..19] of daveResult;
	presultarray = ^resultarray;
	
       daveResultSet = record
            numResults : longint;
{ this cannot be compiled with freePascal in Delphi compatibility mode }	    
//            results : PdaveResult;
{ this cannot be compiled  }	    
//	     results : ^array[0..0] daveResult;
{ so I used the helper type presultarray:  }	    
	     results : presultarray;
         end;
	 
	pdaveResultSet=^daveResultSet; 
    { use this to initialize a multivariable read:  }

    procedure davePrepareReadRequest(dc:PdaveConnection; p:PPDU);stdcall;
	external LibName {$ifdef WIN32} name 'davePrepareReadRequest'{$ENDIF};
    procedure davePrepareWriteRequest(dc:PdaveConnection; p:PPDU);stdcall;
	external LibName {$ifdef WIN32} name 'davePrepareWriteRequest'{$ENDIF};

    { Adds a new variable to a prepared request:  }
    procedure daveAddVarToReadRequest(p:PPDU; area:longint; DBnum:longint; start:longint; bytes:longint);stdcall;
	external LibName {$ifdef WIN32} name 'daveAddVarToReadRequest'{$ENDIF};
    procedure daveAddVarToWriteRequest(p:PPDU; area:longint; DBnum:longint; start:longint; bytes:longint; buffer:pointer);stdcall;
	external LibName {$ifdef WIN32} name 'daveAddVarToWriteRequest'{$ENDIF};
	
    procedure daveAddBitVarToWriteRequest(p:PPDU; area:longint; DBnum:longint; start:longint; bytes:longint; buffer:pointer);stdcall;
	external LibName {$ifdef WIN32} name 'daveAddBitVarToWriteRequest'{$ENDIF};
		

    { Executes the complete request.  }
    function daveExecReadRequest(dc:PdaveConnection; p:PPDU; rl:PdaveResultSet):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveExecReadRequest'{$ENDIF};
    function daveExecWriteRequest(dc:PdaveConnection; p:PPDU; rl:PdaveResultSet):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveExecWriteRequest'{$ENDIF};

    { Lets the functions daveGet<data type> work on the n-th result:  }
    function daveUseResult(dc:PdaveConnection; rl:PdaveResultSet; n:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveUseResult'{$ENDIF};

    { Frees the memory occupied by the result structure  }
    procedure daveFreeResults(rl:PdaveResultSet);stdcall;
	external LibName {$ifdef WIN32} name 'daveFreeResults'{$ENDIF};

    { Frees the memory occupied by internal structure  }
    procedure daveFree(p:pointer);stdcall;
	external LibName {$ifdef WIN32} name 'daveFree'{$ENDIF};
	

    function daveInitAdapter(di:PdaveInterface):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveInitAdapter'{$ENDIF};

    function daveDisconnectPLC(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveDisconnectPLC'{$ENDIF};

    function daveDisconnectAdapter(di:PdaveInterface):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveDisconnectAdapter'{$ENDIF};

    function daveListReachablePartners(di:PdaveInterface; buf:Pchar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveListReachablePartners'{$ENDIF};

    function daveForceDisconnectIBH(di:PdaveInterface; src:longint; dest:longint; MPI: longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveForceDisconnectIBH'{$ENDIF};

    function daveResetIBH(di:PdaveInterface):longint;stdcall;
        external LibName {$ifdef WIN32} name 'daveResetIBH'{$ENDIF};

    function _daveListReachablePartnersDummy(di:PdaveInterface; buf:Pchar):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveListReachablePartnersDummy'{$ENDIF};

    { MPI specific functions  }

    const
       daveMPIReachable = $30;
       daveMPIActive = $30;
       daveMPIPassive = $0;
       daveMPIunused = $10;
       davePartnerListSize = 126;

    function _daveListReachablePartnersMPI(di:PdaveInterface; buf:Pchar):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveListReachablePartnersMPI'{$ENDIF};

    function _daveInitAdapterMPI1(di:PdaveInterface):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveInitAdapterMPI1'{$ENDIF};

    function _daveInitAdapterMPI2(di:PdaveInterface):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveInitAdapterMPI2'{$ENDIF};

    function _daveConnectPLCMPI1(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveConnectPLCMPI1'{$ENDIF};

    function _daveConnectPLCMPI2(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveConnectPLCMPI2'{$ENDIF};

    function _daveDisconnectPLCMPI(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveDisconnectPLCMPI'{$ENDIF};

    function _daveDisconnectAdapterMPI(di:PdaveInterface):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveDisconnectAdapterMPI'{$ENDIF};

    function _daveExchangeMPI(dc:PdaveConnection; p1:PPDU):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveExchangeMPI'{$ENDIF};

    { ISO over TCP specific functions  }
    function _daveExchangeTCP(dc:PdaveConnection; p1:PPDU):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveExchangeTCP'{$ENDIF};

    function _daveConnectPLCTCP(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveConnectPLCTCP'{$ENDIF};

    { PPI specific functions  }
    function _daveExchangePPI(dc:PdaveConnection; p1:PPDU):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveExchangePPI'{$ENDIF};

    {
        make PPI functions available for "passive mode"
     }
    procedure _daveSendLength(di:PdaveInterface; len:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveSendLength'{$ENDIF};

    procedure _daveSendIt(di:PdaveInterface; b:Puc; size:longint);stdcall;
	external LibName {$ifdef WIN32} name '_daveSendIt'{$ENDIF};

    { serial interface  }
    { a buffer  }
    { timeout in us  }
    { limit  }
(*
    function _daveReadChars(di:PdaveInterface; b:Puc; tmo:longint; max:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveReadChars'{$ENDIF};
*)	
    function _daveReadChars2(di:PdaveInterface; b:Puc; max:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveReadChars2'{$ENDIF};

    {
        make MPI functions available for experimental use:
     }
    function _daveReadMPI(di:PdaveInterface; b:Puc):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveReadMPI'{$ENDIF};

    procedure _daveSendSingle(di:PdaveInterface; c:uc);stdcall;
	external LibName {$ifdef WIN32} name '_daveSendSingle'{$ENDIF};

    function _daveSendAck(dc:PdaveConnection; nr:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveSendAck'{$ENDIF};

    function _daveGetAck(di:PdaveInterface):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveGetAck'{$ENDIF};

    function _daveSendDialog2(dc:PdaveConnection; size:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveSendDialog2'{$ENDIF};
	
    function _daveSendWithPrefix(dc: PdaveConnection; b:Puc; size:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveSendWithPrefix'{$ENDIF};

    function _daveSendWithPrefix2(dc: PdaveConnection; size:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveSendWithPrefix2'{$ENDIF};
	

    function _daveSendWithCRC(di: PdaveInterface; b:Puc; size:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveSendWithCRC'{$ENDIF};

    function _daveReadSingle(di: PdaveInterface):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveReadSingle'{$ENDIF};
	

    function _daveReadOne(di: PdaveInterface; b:Puc):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveReadOne'{$ENDIF};
	
    
    function _daveReadMPI2(dc: PdaveInterface; b:Puc):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveReadMPI2'{$ENDIF};
    
    function _daveGetResponseMPI(dc: PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveGetResponseMPI'{$ENDIF};

    function _daveSendMessageMPI(dc:PdaveConnection; p1:PPDU):longint;stdcall;
	external LibName {$ifdef WIN32} name '_daveSendMessageMPI'{$ENDIF};

{$IFDEF WIN32}	
    function setPort(name:pchar; baud: pchar; parity:char):pHandle; stdcall;
	external LibName {$ifdef WIN32} name 'setPort'{$ENDIF};
{$ENDIF}
{$IFDEF LINUX}	
    function setPort(name:pchar; baud: pchar; parity:char):longint; stdcall;
	external LibName {$ifdef WIN32} name 'setPort'{$ENDIF};
{$ENDIF}
    function openSocket(port:longint;name:pchar):longint; stdcall;
	external LibName {$ifdef WIN32} name 'openSocket'{$ENDIF};
        
    function openS7online(name:pchar;handle: LongWord):longint; stdcall;
	external LibName {$ifdef WIN32} name 'openS7online'{$ENDIF};
	

    procedure closePort(port:longint); stdcall;
	external LibName {$ifdef WIN32} name 'closePort'{$ENDIF};
    procedure closeSocket(port:longint); stdcall;
	external LibName {$ifdef WIN32} name 'closeSocket'{$ENDIF};
    procedure closeS7online(port:longint); stdcall;
	external LibName {$ifdef WIN32} name 'closeS7online'{$ENDIF};


    procedure daveSetDebug(nDebug:longint); stdcall;
	external LibName {$ifdef WIN32} name 'daveSetDebug'{$ENDIF};
    function daveGetDebug:longint; stdcall;
	external LibName {$ifdef WIN32} name 'daveGetDebug'{$ENDIF};
	


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

    function daveGetS8(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS8'{$ENDIF};
    function daveGetU8(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU8'{$ENDIF};
	
    function daveGetS16(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS16'{$ENDIF};
    function daveGetU16(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU16'{$ENDIF};
	
    function daveGetS32(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS32'{$ENDIF};
    function daveGetU32(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU32'{$ENDIF};
		

    function daveGetS8At(dc:PdaveConnection;pos:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS8At'{$ENDIF};
    function daveGetU8At(dc:PdaveConnection;pos:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU8At'{$ENDIF};
	
    function daveGetS16At(dc:PdaveConnection;pos:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS16At'{$ENDIF};
    function daveGetU16At(dc:PdaveConnection;pos:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU16At'{$ENDIF};
	
    function daveGetS32At(dc:PdaveConnection;pos:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS32At'{$ENDIF};
    function daveGetU32At(dc:PdaveConnection;pos:longint):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU32At'{$ENDIF};


    function daveGetS8from(b:pChar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS8from'{$ENDIF};
    function daveGetU8from(b:pChar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU8from'{$ENDIF};
    function daveGetS16from(b:pChar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS16from'{$ENDIF};
    function daveGetU16from(b:pChar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU16from'{$ENDIF};
	
    function daveGetS32from(b:pChar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetS32from'{$ENDIF};
    function daveGetU32from(b:pChar):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetU32from'{$ENDIF};
    function daveGetFloatfrom(b:pChar):single;stdcall;
	external LibName {$ifdef WIN32} name 'daveGetFloatfrom'{$ENDIF};


    function davePut8(b:pChar;v:longint):pChar;stdcall;
	external LibName {$ifdef WIN32} name 'davePut8'{$ENDIF};
    function davePut16(b:pChar;v:longint):pChar;stdcall;
	external LibName {$ifdef WIN32} name 'davePut16'{$ENDIF};
    function davePut32(b:pChar;v:longint):pChar;stdcall;
	external LibName {$ifdef WIN32} name 'davePut32'{$ENDIF};
    function davePutFloat(b:pChar;v:single):pChar;stdcall;
	external LibName {$ifdef WIN32} name 'davePutFloat'{$ENDIF};


    { read out clock: } 
    function daveReadPLCTime(dc:PdaveConnection):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveReadPLCTime'{$ENDIF};
    {  set clock to a value given by user  } 
    function daveSetPLCTime(dc:PdaveConnection; ts: Puc):longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveSetPLCTime'{$ENDIF};
    {	set clock to PC system clock:	} 
    function daveSetPLCTimeToSystime(dc:PdaveConnection): longint;stdcall;
	external LibName {$ifdef WIN32} name 'daveSetPLCTimeToSystime'{$ENDIF};
    {
	BCD conversions:
    } 
    function daveToBCD(i:uc):uc;stdcall;
	external LibName {$ifdef WIN32} name 'daveToBCD'{$ENDIF};
    function daveFromBCD(i:uc):uc;stdcall;
	external LibName {$ifdef WIN32} name 'daveFromBCD'{$ENDIF};



{$ifdef SOLUTION1}    
    function daveNewInterface(fd:_daveOSserialType; nname:pchar; localMPI:longint;protocol:longint; speed:longint):PdaveInterface;
{$ENDIF}	  
    implementation

{$ifdef SOLUTION1}    
    function daveNewInterface(fd:_daveOSserialType; nname:pchar; localMPI:longint;protocol:longint; speed:longint):PdaveInterface;
	begin
	    daveNewInterface:=internalDaveNewInterface(
(* 
    Under freepascal, the explicit type conversion to pHANDLE is not necessary. Maybe it's needed
    for DELPHI. At least there will be something completely different, if this will be ever
    compiled on a system that is neither Windows nor a UNIX derivate...
*)
{$ifdef WIN32}	    
		pHANDLE(fd.rfd),
		pHANDLE(fd.wfd),
{$ENDIF}		
{$ifdef LINUX}	    
		fd.rfd,
		fd.wfd,
{$ENDIF}
		nname,localMPI,protocol,speed);
    end;
{$ENDIF}    
end.

{
    03/21/05  added daveStrPDUError()
    03/24/05  added function codes for download.
    03/29/05  added daveStop, daveStart.
    04/05/05  added daveP constant to access peripheral I/O.
    04/05/05  fixed missing stdcall; cdecl in interface of daveStrerror, daveStrPDUerror.
    04/06/05  removed daveGetByte.
    08/29/05  added PLC clock read/set functions.
    01/08/07  additional put/get functions by Axel Kinting.
    01/09/07  added some changes by Axel Kinting.
}
