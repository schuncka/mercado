<%
Dim strDLLBARCODE, strDLLTYPE, strDLLHEIGHT, strDLLIMAGE, strDLLSHOWTEXT
strDLLBARCODE = request("barcode")
If strDLLBARCODE = "" Then
  strDLLBARCODE = "123456789"
End If

strDLLTYPE = request("type")
If strDLLTYPE = "" Then
  strDLLTYPE = "3"
End If

strDLLHEIGHT = request("h")
If strDLLHEIGHT = "" Then
  strDLLHEIGHT = "50"
End If

strDLLIMAGE = request("h")
If strDLLIMAGE = "" Then
  strDLLIMAGE = "BMP"
End If

strDLLSHOWTEXT = request("showtext")
If strDLLSHOWTEXT = "1" Then
  strDLLSHOWTEXT = True
Else
  strDLLSHOWTEXT = False
End If
strDLLSHOWTEXT = True

Dim ObjBarcode
Set ObjBarcode = Server.CreateObject("nonnoi_ASPBarcode.ASPBarcode") 
ObjBarcode.ImageTypeStr = strDLLIMAGE
ObjBarcode.BarcodeType = strDLLTYPE
ObjBarcode.Height = strDLLHEIGHT
ObjBarcode.Data = strDLLBARCODE
ObjBarcode.ShowText = strDLLSHOWTEXT
ObjBarcode.RegisterName = "uis felipe petry cabral"
ObjBarcode.RegisterKey = "408473BCE02DEBD5-4156"
ObjBarcode.Checksum = False
ObjBarcode.NarrowBarWidth = 1
ObjBarcode.Ratio = 2
ObjBarcode.ShowBarcode

set ObjBarcode = nothing

%> 
