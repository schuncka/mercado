<%
Const ForReading   = 1
Const ForAppending = 8

Sub AbreArquivo (byref pr_objFSO, byref pr_objOpenFile, pr_type)
  Set pr_objFSO      = Server.CreateObject("Scripting.FileSystemObject")
  Set pr_objOpenFile = objFSO.OpenTextFile(Server.MapPath("_database/faq.txt"),pr_type)
End Sub


Sub FechaArquivo(byref pr_objFSO,  pr_objOpenFile)
  Set pr_objFSO = Nothing
  Set pr_objOpenFile = Nothing
End Sub

%>
