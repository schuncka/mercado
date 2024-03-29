<%
Function fnHash(HashType, Target)
    On Error Resume Next

    Dim PlainText, UTF8Encoding, Cryptography, x

    If IsArray(Target) = True Then PlainText = Target(0) Else PlainText = Target End If

    With CreateObject("ADODB.Stream")
        .Open
        .CharSet = "Windows-1252"
        .WriteText PlainText
        .Position = 0
        .CharSet = "UTF-8"
        PlainText = .ReadText
        .Close
    End With

    Set UTF8Encoding = CreateObject("System.Text.UTF8Encoding")
    Dim PlainTextToBytes, BytesToHashedBytes, HashedBytesToHex

    PlainTextToBytes = UTF8Encoding.GetBytes_4(PlainText)

    Select Case HashType
        Case "md5": Set Cryptography = CreateObject("System.Security.Cryptography.MD5CryptoServiceProvider") '< 64 (collisions found)
        Case "ripemd160": Set Cryptography = CreateObject("System.Security.Cryptography.RIPEMD160Managed")
        Case "sha1": Set Cryptography = CreateObject("System.Security.Cryptography.SHA1Managed") '< 80 (collision found)
        Case "sha256": Set Cryptography = CreateObject("System.Security.Cryptography.SHA256Managed")
        Case "sha384": Set Cryptography = CreateObject("System.Security.Cryptography.SHA384Managed")
        Case "sha512": Set Cryptography = CreateObject("System.Security.Cryptography.SHA512Managed")
        Case "md5HMAC": Set Cryptography = CreateObject("System.Security.Cryptography.HMACMD5")
        Case "ripemd160HMAC": Set Cryptography = CreateObject("System.Security.Cryptography.HMACRIPEMD160")
        Case "sha1HMAC": Set Cryptography = CreateObject("System.Security.Cryptography.HMACSHA1")
        Case "sha256HMAC": Set Cryptography = CreateObject("System.Security.Cryptography.HMACSHA256")
        Case "sha384HMAC": Set Cryptography = CreateObject("System.Security.Cryptography.HMACSHA384")
        Case "sha512HMAC": Set Cryptography = CreateObject("System.Security.Cryptography.HMACSHA512")
    End Select

    Cryptography.Initialize()

    If IsArray(Target) = True Then Cryptography.Key = UTF8Encoding.GetBytes_4(Target(1))

    BytesToHashedBytes = Cryptography.ComputeHash_2((PlainTextToBytes))

    For x = 1 To LenB(BytesToHashedBytes)
        HashedBytesToHex = HashedBytesToHex & Right("0" & Hex(AscB(MidB(BytesToHashedBytes, x, 1))), 2)
    Next

    If Err.Number <> 0 Then Response.Write(Err.Description) Else fnHash = LCase(HashedBytesToHex)

    On Error GoTo 0
End Function
%>