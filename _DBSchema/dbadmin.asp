<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"-->
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_database/secure.asp"-->
<%
If Ucase(Session("GRP_USER")) <> "ADMIN" Then 
   Mensagem "Você não esta autorizado a efetuar esta operação.<BR><BR>Usuário = " & Session("ID_USER") , "Javascript:history.back()", 1  
Else

Dim sAction
Dim sTable
Dim sField
Dim sRecordSet
Dim Con
Dim RS
Dim DbName
Dim sConnectionString
Dim UsingSQL
Dim ThisPage
Dim sID

'For MS ACCESS connections'
UsingSQL = False
'DbName = Server.MapPath("main.mdb")
'If Request("var_combo") <> "" Then

'	sConnectionString = "driver=MySQL ODBC 5.1 Driver;server=localhost;uid="&CFG_DB_DADOS_USER&";pwd="&CFG_DB_DADOS_PWD&";database="&Request("var_combo")
'	sConnectionString = "Driver={Microsoft Access Driver (*.mdb)};DBQ=" & Request("var_combo") & ";"
'	sConnectionString = "Driver={Microsoft Access Driver (*.mdb)};DBQ=" & Request("var_combo") & ";"
'Else

	sConnectionString = "driver=MySQL ODBC 5.1 Driver;server=localhost;uid="&CFG_DB_DADOS_USER&";pwd="&CFG_DB_DADOS_PWD&";database="&CFG_DB_DADOS
'	sConnectionString = "Driver={Microsoft Access Driver (*.mdb)};DBQ=" & CFG_PATH & CFG_DB_DADOS & ";"
'	sConnectionString = "Driver={Microsoft Access Driver (*.mdb)};DBQ=" & CFG_DB_SITE & ";"
'End If
'Response.Write(sConnectionString)
'Response.End()
'sConnectionString = "DSN=;user=;password=;"

'For SQL Server Connections'
'UsingSQL = 1'
'DbName = "Starrcommon"'
'sConnectionString = "Driver={SQL Server}; Server=(LOCAL);Database=" & DbName & "; UID=usernamehere; PWD=passwordhere"'

'--- Do not edit blow this line ---'



sAction = trim(Request("action"))
sTable = trim(Request("table"))
sField = trim(Request("field"))
Dim currentPage, rowCount, i
currentPage = TRIM(Request("currentPage"))
if currentPage = "" then currentPage = 1

sID = trim(Request("id"))
if sID = "" then sID = trim(Request.Form("id"))
If sID = "" then sID = 0


ThisPage = Request.ServerVariables("SCRIPT_NAME")


'- MS ADO Constant Values------------------------------'
'---- CursorTypeEnum Values ----'
Const adOpenForwardOnly = 0
Const adOpenKeyset = 1
Const adOpenDynamic = 2
Const adOpenStatic = 3

'---- CursorOptionEnum Values ----'
Const adHoldRecords = &H00000100
Const adMovePrevious = &H00000200
Const adAddNew = &H01000400
Const adDelete = &H01000800
Const adUpdate = &H01008000
Const adBookmark = &H00002000
Const adApproxPosition = &H00004000
Const adUpdateBatch = &H00010000
Const adResync = &H00020000
Const adNotify = &H00040000

'---- LockTypeEnum Values ----'
Const adLockReadOnly = 1
Const adLockPessimistic = 2
Const adLockOptimistic = 3
Const adLockBatchOptimistic = 4

'---- ExecuteOptionEnum Values ----'
Const adRunAsync = &H00000010

'---- ObjectStateEnum Values ----'
Const adStateClosed = &H00000000
Const adStateOpen = &H00000001
Const adStateConnecting = &H00000002
Const adStateExecuting = &H00000004

'---- CursorLocationEnum Values ----'
Const adUseServer = 2
Const adUseClient = 3

'---- DataTypeEnum Values ----'
Const adEmpty = 0
Const adTinyInt = 16
Const adSmallInt = 2
Const adInteger = 3
Const adBigInt = 20
Const adUnsignedTinyInt = 17
Const adUnsignedSmallInt = 18
Const adUnsignedInt = 19
Const adUnsignedBigInt = 21
Const adSingle = 4
Const adDouble = 5
Const adCurrency = 6
Const adDecimal = 14
Const adNumeric = 131
Const adBoolean = 11
Const adError = 10
Const adUserDefined = 132
Const adVariant = 12
Const adIDispatch = 9
Const adIUnknown = 13
Const adGUID = 72
Const adDate = 7
Const adDBDate = 133
Const adDBTime = 134
Const adDBTimeStamp = 135
Const adBSTR = 8
Const adChar = 129
Const adVarChar = 200
Const adLongVarChar = 201
Const adWChar = 130
Const adVarWChar = 202
Const adLongVarWChar = 203
Const adBinary = 128
Const adVarBinary = 204
Const adLongVarBinary = 205

'---- FieldAttributeEnum Values ----'
Const adFldMayDefer = &H00000002
Const adFldUpdatable = &H00000004
Const adFldUnknownUpdatable = &H00000008
Const adFldFixed = &H00000010
Const adFldIsNullable = &H00000020
Const adFldMayBeNull = &H00000040
Const adFldLong = &H00000080
Const adFldRowID = &H00000100
Const adFldRowVersion = &H00000200
Const adFldCacheDeferred = &H00001000

'---- EditModeEnum Values ----'
Const adEditNone = &H0000
Const adEditInProgress = &H0001
Const adEditAdd = &H0002
Const adEditDelete = &H0004

'---- RecordStatusEnum Values ----'
Const adRecOK = &H0000000
Const adRecNew = &H0000001
Const adRecModified = &H0000002
Const adRecDeleted = &H0000004
Const adRecUnmodified = &H0000008
Const adRecInvalid = &H0000010
Const adRecMultipleChanges = &H0000040
Const adRecPendingChanges = &H0000080
Const adRecCanceled = &H0000100
Const adRecCantRelease = &H0000400
Const adRecConcurrencyViolation = &H0000800
Const adRecIntegrityViolation = &H0001000
Const adRecMaxChangesExceeded = &H0002000
Const adRecObjectOpen = &H0004000
Const adRecOutOfMemory = &H0008000
Const adRecPermissionDenied = &H0010000
Const adRecSchemaViolation = &H0020000
Const adRecDBDeleted = &H0040000

'---- GetRowsOptionEnum Values ----'
Const adGetRowsRest = -1

'---- PositionEnum Values ----'
Const adPosUnknown = -1
Const adPosBOF = -2
Const adPosEOF = -3

'---- enum Values ----'
Const adBookmarkCurrent = 0
Const adBookmarkFirst = 1
Const adBookmarkLast = 2

'---- MarshalOptionsEnum Values ----'
Const adMarshalAll = 0
Const adMarshalModifiedOnly = 1

'---- AffectEnum Values ----'
Const adAffectCurrent = 1
Const adAffectGroup = 2
Const adAffectAll = 3

'---- FilterGroupEnum Values ----'
Const adFilterNone = 0
Const adFilterPendingRecords = 1
Const adFilterAffectedRecords = 2
Const adFilterFetchedRecords = 3
Const adFilterPredicate = 4

'---- SearchDirection Values ----'
Const adSearchForward = 1
Const adSearchBackward = -1

'---- ConnectPromptEnum Values ----'
Const adPromptAlways = 1
Const adPromptComplete = 2
Const adPromptCompleteRequired = 3
Const adPromptNever = 4

'---- ConnectModeEnum Values ----'
Const adModeUnknown = 0
Const adModeRead = 1
Const adModeWrite = 2
Const adModeReadWrite = 3
Const adModeShareDenyRead = 4
Const adModeShareDenyWrite = 8
Const adModeShareExclusive = &Hc
Const adModeShareDenyNone = &H10

'---- IsolationLevelEnum Values ----'
Const adXactUnspecified = &Hffffffff
Const adXactChaos = &H00000010
Const adXactReadUncommitted = &H00000100
Const adXactBrowse = &H00000100
Const adXactCursorStability = &H00001000
Const adXactReadCommitted = &H00001000
Const adXactRepeatableRead = &H00010000
Const adXactSerializable = &H00100000
Const adXactIsolated = &H00100000

'---- XactAttributeEnum Values ----'
Const adXactCommitRetaining = &H00020000
Const adXactAbortRetaining = &H00040000

'---- PropertyAttributesEnum Values ----'
Const adPropNotSupported = &H0000
Const adPropRequired = &H0001
Const adPropOptional = &H0002
Const adPropRead = &H0200
Const adPropWrite = &H0400

'---- ErrorValueEnum Values ----'
Const adErrInvalidArgument = &Hbb9
Const adErrNoCurrentRecord = &Hbcd
Const adErrIllegalOperation = &Hc93
Const adErrInTransaction = &Hcae
Const adErrFeatureNotAvailable = &Hcb3
Const adErrItemNotFound = &Hcc1
Const adErrObjectInCollection = &Hd27
Const adErrObjectNotSet = &Hd5c
Const adErrDataConversion = &Hd5d
Const adErrObjectClosed = &He78
Const adErrObjectOpen = &He79
Const adErrProviderNotFound = &He7a
Const adErrBoundToCommand = &He7b
Const adErrInvalidParamInfo = &He7c
Const adErrInvalidConnection = &He7d
Const adErrStillExecuting = &He7f
Const adErrStillConnecting = &He81

'---- ParameterAttributesEnum Values ----'
Const adParamSigned = &H0010
Const adParamNullable = &H0040
Const adParamLong = &H0080

'---- ParameterDirectionEnum Values ----'
Const adParamUnknown = &H0000
Const adParamInput = &H0001
Const adParamOutput = &H0002
Const adParamInputOutput = &H0003
Const adParamReturnValue = &H0004

'---- CommandTypeEnum Values ----'
Const adCmdUnknown = &H0008
Const adCmdText = &H0001
Const adCmdTable = &H0002
Const adCmdStoredProc = &H0004

'---- SchemaEnum Values ----'
Const adSchemaProviderSpecific = -1
Const adSchemaAsserts = 0
Const adSchemaCatalogs = 1
Const adSchemaCharacterSets = 2
Const adSchemaCollations = 3
Const adSchemaColumns = 4
Const adSchemaCheckConstraints = 5
Const adSchemaConstraintColumnUsage = 6
Const adSchemaConstraintTableUsage = 7
Const adSchemaKeyColumnUsage = 8
Const adSchemaReferentialContraints = 9
Const adSchemaTableConstraints = 10
Const adSchemaColumnsDomainUsage = 11
Const adSchemaIndexes = 12
Const adSchemaColumnPrivileges = 13
Const adSchemaTablePrivileges = 14
Const adSchemaUsagePrivileges = 15
Const adSchemaProcedures = 16
Const adSchemaSchemata = 17
Const adSchemaSQLLanguages = 18
Const adSchemaStatistics = 19
Const adSchemaTables = 20
Const adSchemaTranslations = 21
Const adSchemaProviderTypes = 22
Const adSchemaViews = 23
Const adSchemaViewColumnUsage = 24
Const adSchemaViewTableUsage = 25
Const adSchemaProcedureParameters = 26
Const adSchemaForeignKeys = 27
Const adSchemaPrimaryKeys = 28
Const adSchemaProcedureColumns = 29

'-Main Page Code-----------------------------------'
if sAction = "" then sAction = "listtb"
WriteHeader
Select Case lcase(sAction)
case "listtb"
    WriteHeaders "Selecionar a Tabela"
	PutCombo
    ListTables
case "listrec"
    WriteHeaders "Editar Registros: " & trim(Request("Table"))
    ListRecords
case "addrec"
    WriteHeaders "Adicionar Registro: em " & sTable
    ShowEditor
case "editrec"
    WriteHeaders "Editar Registro: " & sID & " em " & sTable
    ShowEditor
case "saverec"
    WriteHeaders "Salvar Registro para: " & trim(Request("Table"))
    SaveRec
case "delrec"
    WriteHeaders "Deletar Registro: " & sID & " em " & sTable
    DeleteRec
case "addtable"
    WriteHeaders "Adicionar Tabela"
    AddTable
case "savetable"
    WriteHeaders "Tabela Criada"
    SaveTable
case "edittable"
    WriteHeaders "Editar Tabela " & sTable
    EditTable
case "deletetable"
    WriteHeaders "Deletar Tabela " & sTable
    DeleteTable
case "cleartable"
    WriteHeaders "Limpar Tabela " & sTable
    ClearTable
case "addfield"
    WriteHeaders "Adicionar Campo: em " & sTable
    AddField
case "editfield"
    WriteHeaders "Editar Campo " & sField & " em: " & sTable
    AddField
case "deletefield"
    WriteHeaders "Deletar " & sfield & " de: " & sTable
    deletefield
case "savefield"
    WriteHeaders "Salvando Campo " & sField & " em: " & sTable
    savefield
case "execsql"
    WriteHeaders "Executar Comandos SQL"
    execsql
end select
WriteFooter

Sub WriteHeader
%>
<HTML>
<HEAD><TITLE>Online Database Editor</TITLE>
</HEAD>

<BODY BGCOLOR="#FFFFFE" Text="#0A0D0A" LINK="#375AE2" VLINK="#36566D" ALINK="#3E85BB">
<style TYPE="text/css">
<!--  A:link {text-decoration: none; color:#375AE2}  A:visited {text-decoration: none; color:#375AE2}  A:active {text-decoration: none}   A:hover {text-decoration: ; color:#3E85BB; }-->
</style>
<%
End Sub

Sub WriteFooter
%>
</BODY>
</HTML>
<%
End Sub


Sub OpenCon()
Set Con = Server.CreateObject("ADODB.Connection")
Con.open(sConnectionString)
'Response.Write(sConnectionString)
End Sub

Sub CloseCon
rs.Close
con.close
End Sub

Function IsRecordSetEmpty
if rs.bof = 1 and rs.eof = 1 then
    IsRecordSetEmpty = 1
else
    IsRecordSetEmpty = 0
end if
end Function

Sub ChooseSQL(sSQL)
'Response.Write(sSQL)
'Response.End()
set rs=Server.CreateObject("ADODB.recordset")
	rs.open sSQL, sConnectionString, adOpenStatic, adLockOptimistic
End Sub

Sub ChoosePagesSQL(sSQL,sStart, sSize)
set rs=Server.CreateObject("ADODB.recordset")
sqlstmt = sSQL
rs.CursorType = 3
rs.PageSize = cint(sSize)
rs.open sqlstmt, sConnectionString
if isrecordsetempty = 0 then
'rs.AbsolutePage = cINT(sStart)
rs.PageSize = cINT(sStart)
end if
End Sub

Sub PutCombo()
'location.href = 'dbadmin.asp?var_combo=' + this.value;
%>
<form action="dbadmin.asp" method="post" name="frmConexao">
Selecionar conexão:<br><br>
	<select name="var_combo" onChange="javascript:document.frmConexao.submit();">
		<option value="<%=CFG_DB_DADOS%>" <% If Request("var_combo") = CFG_DB_DADOS Then Response.Write(" selected")%>>DADOS - <%=CFG_DB_DADOS%></option>
	</select>
<br><br>
</form>
<%
End Sub

Sub WriteHeaders(sTitle)
%>
<TABLE BORDER="0" CELLPADDING="6" CELLSPACING="0" WIDTH="100%" BGCOLOR="#C0C0C0" BORDERCOLOR="#C0C0C0" BORDERCOLORDARK="#C0C0C0" BORDERCOLORLIGHT="#C0C0C0" >
<TR>
<TD ALIGN="Left"><Font Face="Arial" COLOR="#000000" SIZE="4"><B><% Response.write(sTitle) %></B></FONT></TD>
</TR>
</TABLE>
<BR>
<%
Select Case lcase(sAction)
case "listtb"
case "listrec"
    WriteLink "","Voltar para Tabelas","<BR>"
end select

End Sub

Sub WriteLink(sParms,sDisplay,sBreak)
%>
<A HREF="<% Response.Write(ThisPage & sParms) %>"><% Response.Write(sDisplay) %></A><% Response.Write(sBreak) %>
<%
End Sub


Sub ListTables
WriteLink "?action=execsql&var_combo=" & Request("var_combo"),"Executar Comandos SQL","<BR><BR>"
WriteLink "?action=addtable&var_combo=" & Request("var_combo"),"Adicionar Novo","<BR><BR>"
%>
<TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" BGCOLOR="#FFFFFF" BORDERCOLOR="#C0C0C0" BORDERCOLORDARK="#C0C0C0" BORDERCOLORLIGHT="#C0C0C0">
<TR>
<TD ALIGN="Left" bgcolor="#C0C0C0"><FONT COlOR="#000000" FACE="Arial" SIZE="2">Visualizar</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><FONT COlOR="#000000" FACE="Arial" SIZE="2">Editar</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><FONT COlOR="#000000" FACE="Arial" SIZE="2">Limpar</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><FONT COlOR="#000000" FACE="Arial" SIZE="2">Excluir</FONT></TD>
</TR>
<%
Set Con = Server.CreateObject("ADODB.Connection")
Con.open(sConnectionString)
queryType = adSchemaTables
criteria = Array(DbName,Empty,Empty,"TABLE")
Set RS = Con.OpenSchema(queryType,criteria)
Do until RS.EOF
%>
<TR>
<TD ALIGN="Left"><FONT COlOR="#000000" FACE="Arial" SIZE="2"><% WriteLink "?action=listrec&var_combo=" & Request("var_combo") & "&table=" & RS(2),RS(2),"" %></FONT></TD>
<TD ALIGN="Left"><FONT COlOR="#000000" FACE="Arial" SIZE="2"><% WriteLink "?action=edittable&var_combo=" & Request("var_combo") & "&table=" & RS(2),"Editar","" %></FONT></TD>
<TD ALIGN="Left"><FONT COlOR="#000000" FACE="Arial" SIZE="2"><% WriteLink "?action=cleartable&var_combo=" & Request("var_combo") & "&table=" & RS(2),"Limpar","" %></FONT></TD>
<TD ALIGN="Left"><FONT COlOR="#000000" FACE="Arial" SIZE="2"><% WriteLink "?action=deletetable&var_combo=" & Request("var_combo") & "&table=" & RS(2),"Excluir","" %></FONT></TD>
</TR>
<%
RS.movenext
Loop
%>
</TABLE>
<%
end Sub

Sub ListRecords
OpenCon 
ChoosePagesSQL "Select * from " & trim(Request("Table")),currentPage, 10
rowCount = 0
Response.Write("<BR>")
DoCount currentPage
WriteLink "?action=addrec&var_combo=" & Request("var_combo") & "&table=" & sTable,"Adicionar Novo","<BR>"
%>
<BR>
<TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%" BGCOLOR="#FFFFFF" BORDERCOLOR="#C0C0C0" BORDERCOLORDARK="#C0C0C0" BORDERCOLORLIGHT="#C0C0C0">
<TR>
<TD ALIGN="Left" vAlign="top" bgcolor="#C0C0C0"><FONT COlOR="#000000" FACE="Arial" SIZE="1">Excluir</FONT></TD>
<%
For i = 0 to rs.fields.count - 1
if i = 0 then
%>
<TD ALIGN="Left" vAlign="top" bgcolor="#C0C0C0"><FONT COlOR="#000000" FACE="Arial" SIZE="1">Editar</FONT></TD>
<%
else
%>
<TD ALIGN="Left" vAlign="top" bgcolor="#C0C0C0"><FONT COlOR="#000000" FACE="Arial" SIZE="1"><% Response.Write(Rs.Fields(i).name) %></FONT></TD>
<%
end if

next
%>
</TR>
<%
'add table data here with paging'

do while not rs.eof
if rowCount = rs.PageSize then exit DO
%>
<TR>

<TD ALIGN="Left" vAlign="top"><FONT COlOR="#000000" FACE="Arial" SIZE="1">&nbsp;<% WriteLink "?action=delrec&var_combo=" & Request("var_combo") & "&table=" & sTable & "&id=" & rs.fields(0).value,"Excluir","" %></FONT></TD>
<%
For i = 0 to rs.fields.count - 1
%>
<TD ALIGN="Left" vAlign="top"><FONT COlOR="#000000" FACE="Arial" SIZE="1">&nbsp;<%
if i = 0 then
WriteLink "?action=editrec&var_combo=" & Request("var_combo") & "&table=" & sTable & "&id=" & rs.fields(0).value,"Editar #" & rs.fields(0).value,""
else 
Response.Write(Rs.Fields(i).value) 
end if
%></FONT></TD>
<%
next
%>
</TR>

<% 
rowCount = rowCount + 1
rs.movenext
loop

%>
</TABLE>
<%
CloseCon
End Sub

Sub DoCount(currentPage) 
h = 0

for i = 1 to rs.PageCount
 Response.Write(" <a href=" & chr(34) & ThisPage & "?currentpage=" &  i  & "&action=" & sAction & "&var_combo=" & Request("var_combo") & "&table=" & sTable & chr(34) & ">" & i & "</a>")
h = h +1
next
Response.Write("<BR><Small>Página " & currentPage & " de  " & h & "</SMALL></center><BR><BR>")
end sub

Sub ShowEditor
WriteLink "?action=listrec&var_combo=" & Request("var_combo") & "&table=" & sTable,"Voltar para " & sTable,"<BR>"
OpenCon
ChooseSQL "Select * from " & sTable & " where (COD_PROD=" & sID & ")"
%>
<FORM METHOD="POST" ACTION="<% Response.Write(ThisPage) %>?action=saverec&table=<% Response.Write(sTable) %>">
<TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" BGCOLOR="#FFFFFF" BORDERCOLOR="#C0C0C0" BORDERCOLORDARK="#C0C0C0" BORDERCOLORLIGHT="#C0C0C0">

<%

For i = 0 to rs.fields.count - 1
%>
<TR>
<TD ALIGN="Left" vAlign="Top"><Font Face="Arial" COLOR="#000000" SIZE="2"><B><% Response.Write(Rs.Fields(i).name) %></B></FONT></TD>
<TD ALIGN="Left" vAlign="Top" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2"><% WriteType i %></FONT></TD>
<TD ALIGN="Left" vAlign="Top" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2"><% Response.Write(GetFieldTypeName(Rs.Fields(i).type)) %></FONT></TD>
</TR>
<%
next
%>
</TABLE><BR>
<TABLE BORDER="0" CELLPADDING="3" CELLSPACING="0">
<TR>
<TD ALIGN="Left"><input type="submit" value="Save"></TD>
<TD ALIGN="Left"><input type="reset" value="Cancel"></TD>
</TR>
</TABLE>

</FORM>
<%
CloseCon
End Sub

Sub WriteType(I)
Select Case Rs.Fields(i).type
case 3 'primary key / auto number ?'
    if lcase(Rs.Fields(i).name) = "id" then
        %>
        <input type="hidden" name="id" value="<% Response.Write(sID) %>"> Auto Numeração (<% Response.Write(sID) %>)
        <%
    else
        %>
        <input type="text" name="<% Response.Write(Rs.Fields(i).name) %>" SIZE="75" value="<% GetFieldValue i %>">
        <%
    end if
case 11 'boolean'
    %>
    <INPUT TYPE="checkbox" NAME="<% Response.Write(Rs.Fields(i).name) %>" VALUE="1" <% GetCheckValue i %>>
    <%
case 203 'memo'
    %>
    <TEXTAREA NAME="<% Response.Write(Rs.Fields(i).name) %>" ROWS="20" COLS="56"><% GetFieldValue i %></TEXTAREA>
    <%
case else 'not handled by this function'
    %>
    <input type="text" name="<% Response.Write(Rs.Fields(i).name) %>" SIZE="75" value="<% GetFieldValue i %>">
    <%
End Select

End Sub

Sub GetFieldValue(i)
    if lcase(sAction) = "editrec" then
        Response.Write(rs.fields(i).value)
    else
        Response.Write("")
    end if
End Sub

Sub GetCheckValue(i)
    if lcase(sAction) = "editrec" then
        if rs.fields(i).value = 0 then
            Response.Write("")
        else
            Response.Write("checked")
        end if
    else
        Response.Write("")
    end if
End Sub

Sub SaveRec
'Save the record to the table'
OpenCon
ChooseSQL "Select * from " & sTable & " where (COD_PROD=" & sID & ")"
if sID = 0 then
    rs.addnew
else
    rs.movefirst
end if

For i = 0 to rs.fields.count - 1
    If CBool(rs.fields(i).Attributes And adFldUpdatable) then
    'set the field value'
    select case rs.fields(i).type
    case adBigInt
        rs.fields(i).value = csng(Request.Form(rs.fields(i).name))
    case adBoolean 
        if trim(Request.Form(rs.fields(i).name) = "") then
            rs.fields(i).value = 0
        else
            rs.fields(i).value = 1
        end if
   case adCurrency
        rs.fields(i).value = ccur(Request.Form(rs.fields(i).name))
   case adDate,adDBDate,adDBTime,adDBTimeStamp
        rs.fields(i).value = cdate(Request.Form(rs.fields(i).name))
   case adDecimal
        rs.fields(i).value = cdec(Request.Form(rs.fields(i).name))
   case adDouble
        rs.fields(i).value = cdbl(Request.Form(rs.fields(i).name))
   case adInteger
        rs.fields(i).value = cint(Request.Form(rs.fields(i).name))
   case adSingle
        rs.fields(i).value = csng(Request.Form(rs.fields(i).name))
   case else
        rs.fields(i).value = Request.Form(rs.fields(i).name)
   end select
   end if
next
rs.UpdateBatch adAffectAll
CloseCon
%>
Seu registro foi salvo.<BR>
<%
WriteLink "?action=listrec&var_combo=" & Request("var_combo") & "&table=" & sTable,"Clique aqui para continuar.","<BR>"
End Sub

Sub DeleteRec
WriteLink "?action=listrec&var_combo=" & Request("var_combo") & "&table=" & sTable,"Voltar para " & sTable,"<BR><BR>"
if lcase(Request("confirm")) = "yes" then
    'delete the record'
    OpenCon
    ChooseSQL "Select * from " & sTable & " where (COD_PROD=" & sID & ")"
    if isrecordsetempty = false then
        rs.movefirst
        rs.delete
        rs.UpdateBatch adAffectAll
    end if
    CloseCon
    %>
    O registro foi removido.<BR>
    <%
    WriteLink "?action=listrec&var_combo=" & Request("var_combo") & "&table=" & sTable,"Clique aqui para continuar.","<BR>"
else
    WriteLink "?action=delrec&var_combo=" & Request("var_combo") & "&confirm=yes&table=" & sTable & "&id=" & sid,"Sim - excluir o registro","<BR><BR>"
    WriteLink "?action=listrec&var_combo=" & Request("var_combo") & "&table=" & sTable,"Não - não excluir o registro","<BR><BR>"
end if

End Sub

Sub AddTable
   WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Voltar para o Gerenciador de Tabelas","<BR>"
   %>
    <FORM METHOD="POST" ACTION="<% Response.Write(ThisPage) %>?action=savetable">
    <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
    <TR>
    <TD><FONT COLOR="#000000" FACE="Arial" SIZE="2">Nome da Tabela</FONT></TD>
    <TD><INPUT TYPE="text" NAME="tablename" SIZE="30" VALUE=""></TD>
    </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
    <TR>
    <TD><INPUT TYPE="submit" VALUE="Salvar"></TD>
    <TD><INPUT TYPE="reset" VALUE="Cancelar"></TD>
    </TR>
    </TABLE>
    </FORM>
   <%
End Sub

Sub SaveTable
    WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Voltar para o Gerenciador de Tabelas","<BR>"
    sTable = Trim(Request.Form("tablename")) 
    if sTable = "" then
    Response.Write("Nenhum nome informado")
    else
    on error resume next
    OpenCon
        Con.Execute "Create Table " & sTable
        'add and ID field as autonumber and primary key'
        Con.Execute "alter table " & sTable & " Add ID COUNTER PRIMARY KEY"
    Con.close
    if err.number <> 0 then
        Response.Write("<BR><BR> Erro: " & Err.Description) '< write the error description
    Else
        %>
        <BR><BR>Tabela criada com sucesso.<BR>
        <%
        WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Clique aqui para continuar","<BR>"
    end if
    end if
End Sub

Sub DeleteTable
    WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Voltar para Gerenciador de Tabelas","<BR>"
if lcase(Request("confirm")) = "yes" then
    sTable = Trim(Request("table")) 
    if sTable = "" then
    Response.Write("Nenhum nome informado")
    else
    on error resume next
    OpenCon
        Con.Execute "Drop Table " & sTable
    Con.close
    if err.number <> 0 then
        Response.Write("<BR><BR> Erro: " & Err.Description) '< write the error description
    Else
        %>
        <BR><BR>Tabela Excluída<BR>
        <%
        WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Clique aqui para continuar","<BR>"
    end if
    end if
else
Response.Write("<BR><BR>")
    WriteLink "?action=deletetable&confirm=yes&var_combo=" & Request("var_combo") & "&table=" & sTable & "&id=" & sid,"Sim - Excluir a tabela","<BR><BR>"
    WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Não - Não excluir a tabela","<BR><BR>"
end if
End Sub

Sub ClearTable
    WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Voltar para Gerenciador de Tabelas","<BR>"
if lcase(Request("confirm")) = "yes" then
    sTable = Trim(Request("table")) 
    if sTable = "" then
    Response.Write("Nenhum nome informado")
    else
    on error resume next
    OpenCon
    if UsingSQL = 1 then
        Con.Execute "Truncate Table " & sTable
    else
        Con.Execute "Delete * From " & sTable
    end if
    Con.close
    if err.number <> 0 then
        Response.Write("<BR><BR> Erro: " & Err.Description) '< write the error description
    Else
        %>
        <BR><BR>Tabela Limpa<BR>
        <%
        WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Clique aqui para continuar","<BR>"
    end if
    end if
else
Response.Write("<BR><BR>")
    WriteLink "?action=cleartable&confirm=yes&var_combo=" & Request("var_combo") & "&table=" & sTable & "&id=" & sid,"Sim - Limpar a tabela","<BR><BR>"
    WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Não - Não limpar a tabela","<BR><BR>"
end if
End Sub

Sub EditTable
    WriteLink "?action=listtb&var_combo=" & Request("var_combo"),"Voltar para Gerenciador de Tabelas","<BR>"
Set Con = Server.CreateObject("ADODB.Connection")
Con.open(sConnectionString)
queryType = adSchemaColumns
criteria = Array(DbName,Empty,sTable)
Set RS = Con.OpenSchema(queryType,criteria)
Response.Write("<BR>")
WriteLink "?action=addfieldvar_combo=" & Request("var_combo") & "&&table=" & sTable,"Adicionar Campo","<BR><BR>"
%>
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%" BGCOLOR="#FFFFFF" BORDERCOLOR="#C0C0C0" BORDERCOLORDARK="#C0C0C0" BORDERCOLORLIGHT="#C0C0C0" >
<TR>
<TD ALIGN="Left" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2">Excluir</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2">Editar</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2">Nome</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2">Tipo</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2">Permitir Null</FONT></TD>
<TD ALIGN="Left" bgcolor="#C0C0C0"><Font COLOR="#000000" SIZE="2">Tamanho</FONT></TD>
</TR>
<%
Do until RS.EOF
%>
<TR>
<TD ALIGN="Left"><Font COLOR="#000000" SIZE="2">&nbsp;<% WriteLink "?action=deletefield&var_combo=" & Request("var_combo") & "&table=" & stable & "&field=" & RS(3),"Excluir","" %></FONT></TD>
<TD ALIGN="Left"><Font COLOR="#000000" SIZE="2">&nbsp;<% WriteLink "?action=editfield&var_combo=" & Request("var_combo") & "&table=" & stable & "&field=" & RS(3),"Editar #" & RS(6),"" %></FONT></TD>
<TD ALIGN="Left"><Font COLOR="#000000" SIZE="2">&nbsp;<% Response.Write(RS(3)) %></FONT></TD>
<TD ALIGN="Left"><Font COLOR="#000000" SIZE="2">&nbsp;<% Response.Write(GetFieldTypeName(RS(11))) %></FONT></TD>
<TD ALIGN="Left"><Font COLOR="#000000" SIZE="2">&nbsp;<% Response.Write(RS(10)) %></FONT></TD>
<TD ALIGN="Left"><Font COLOR="#000000" SIZE="2">&nbsp;<% Response.Write(RS(13)) %></FONT></TD>
</TR>
<%
Rs.movenext
Loop
%>
</TABLE>
<%
End Sub

Sub DeleteField
    WriteLink "?action=edittable&var_combo=" & Request("var_combo") & "&table=" & stable,"Voltar para Editor de Tabelas","<BR>"
if lcase(Request("confirm")) = "yes" then
    sTable = Trim(Request("table")) 
    sField = Trim(Request("field"))
    if sTable = "" or sField = "" then
    Response.Write("Nenhum nome informado")
    else
    on error resume next
    OpenCon

        Con.Execute "alter table " & sTable & " drop column " & sField

    Con.close
    if err.number <> 0 then
        Response.Write("<BR><BR> Erro: " & Err.Description) '< write the error description
    Else
        %>
        <BR><BR>Campo Excluído<BR>
        <%
        WriteLink "?action=edittable&var_combo=" & Request("var_combo") & "&table=" & stable,"Clique aqui para continuar","<BR>"
    end if
    end if
else
Response.Write("<BR><BR>")
    WriteLink "?action=deletefield&confirm=yes&var_combo=" & Request("var_combo") & "&table=" & sTable & "&field=" & sField,"Sim - Excluir o campo","<BR><BR>"
    WriteLink "?action=edittable&var_combo=" & Request("var_combo") & "&table=" & stable,"Não - Não excluir o campo","<BR><BR>"
end if
End Sub

Sub AddField
WriteLink "?action=edittable&var_combo=" & Request("var_combo") & "&table=" & stable,"Voltar para Editor de Tabelas","<BR>"

'load the field information'
Set Con = Server.CreateObject("ADODB.Connection")
Con.open(sConnectionString)
queryType = adSchemaColumns
criteria = Array(DbName,Empty,sTable)
Set RS = Con.OpenSchema(queryType,criteria)
Do until RS.EOF
if RS(3) = sField then
sFieldname = RS(3)
sFieldType = RS(11)
sFieldLen = RS(13)
end if
Rs.movenext
Loop
%>
<FORM METHOD="POST" ACTION="<% Response.Write(ThisPage) %>?action=savefield&table=<% Response.Write(sTable) %>">
<INPUT TYPE="hidden" NAME="nameold" SIZE="30" VALUE="<% Response.Write(sField) %>">
<TABLE BORDER="0" CELLPADDING="5" CELLSPACING="0">
<TR>
<TD><FONT COLOR="#000000" FACE="Arial" SIZE="2">Nome</FONT></TD>
<TD><INPUT TYPE="text" NAME="name" SIZE="30" VALUE="<% Response.Write(sFieldname) %>"></TD>
</TR>
<TR>
<TD><FONT COLOR="#000000" FACE="Arial" SIZE="2">Tipo</FONT></TD>
<TD><SELECT NAME="type" SIZE="1">
<OPTION SELECTED><% Response.Write(GetFieldTypeName(sFieldType)) %>
<OPTION>Empty
<OPTION>TinyInt
<OPTION>SmallInt
<OPTION>Integer
<OPTION>BigInt
<OPTION>UnsignedTinyInt
<OPTION>UnsignedSmallInt
<OPTION>UnsignedInt
<OPTION>UnsignedBigInt
<OPTION>Single
<OPTION>Double
<OPTION>Currency
<OPTION>Decimal
<OPTION>Numeric
<OPTION>Boolean
<OPTION>Error
<OPTION>UserDefined
<OPTION>Variant
<OPTION>IDispatch
<OPTION>IUnknown
<OPTION>GUID
<OPTION>Date
<OPTION>DBDate
<OPTION>DBTime
<OPTION>DBTimeStamp
<OPTION>BSTR
<OPTION>Char
<OPTION>VarChar
<OPTION>LongVarChar
<OPTION>WChar
<OPTION>VarWChar
<OPTION>LongVarWChar
<OPTION>Binary
<OPTION>VarBinary
<OPTION>LongVarBinary
</SELECT>
</TD>
</TR>
<TR>
<TD><FONT COLOR="#000000" FACE="Arial" SIZE="2">Tamanho</FONT></TD>
<TD><INPUT TYPE="text" NAME="Length" SIZE="10" VALUE="<% Response.Write(sFieldLen) %>"> (para campos tipo texto - 1073741823 max)</TD>
</TR>
</TABLE>
<BR>
<TABLE BORDER="0" CELLPADDING="6" CELLSPACING="0">
<TR>
<TD ALIGN="Left"><INPUT TYPE="submit" VALUE="Salvar"></TD>
<TD ALIGN="Left"><INPUT TYPE="reset" VALUE="Cancelar"></TD>
</TR>
</TABLE>
</FORM>


<%
End Sub

Sub Savefield
'only types that requre a lenght are 130,and 128'
'memo and ole object are 1073741823 by default'
    sFieldname = trim(Request.Form("name"))
    sFieldlen = trim(Request.Form("Length"))
    sFieldType = trim(Request.Form("type"))
    if trim(Request.Form("nameold")) = "" then
        sSQL = "alter table " & sTable & " add " & sFieldname & " "
    else
        sSQL = "alter table " & sTable & " alter column " & sFieldname & " "
    end if
    'd.Execute "ALTER TABLE Test ADD COLUMN aaaa LONGTEXT"'
    sSQL = sSQL & GetFieldTypeCode(sFieldType,sFieldlen)
    
    on error resume next
    OpenCon
    Con.Execute sSQL
    Con.close
    if err.number <> 0 then
    Response.Write(sSQL)
        Response.Write("<BR><BR> Erro: " & Err.Description) '< write the error description
    Else
        %>
        <BR><BR>Campo Editado<BR>
        <%
        WriteLink "?action=edittable&var_combo=" & Request("var_combo") & "&table=" & stable,"Clique aqui para continuar","<BR>"
    end if
End Sub

Sub ExecSQL
WriteLink "","Voltar para Tabelas","<BR><BR>"
    if Trim(Request.Form("sql")) = "" then
    'Show the editor'
    %>
    <FORM METHOD="POST" ACTION="<% Response.Write(ThisPage) %>?action=execsql">
		<input type="hidden" name="var_combo" value="<%=sConnectionString%>">
    Entre com seus comandos SQL abaixo.<BR>
    Novas linhas serão processadas como diferentes comandos.<BR>
    
<TEXTAREA NAME="sql" ROWS="15" COLS="160">'Comentários serão exibidos com um "'" na frente deles
'Entre com seus comandos SQL aqui como visto abaixo...
Create Table MyTABLE
'Adicionar um campo autonumerador ID como chave primária
alter table MyTABLE Add ID COUNTER PRIMARY KEY
'Adicionar outros campos
alter table MyTABLE Add Firstname varChar(255)
alter table MyTABLE Add Lastname varChar(255)
alter table MyTABLE Add City varChar(255)
alter table MyTABLE Add State varChar(255)
alter table MyTABLE Add Country varChar(255)
alter table MyTABLE Add Age Integer</TEXTAREA>
    <BR>
    <TABLE BORDER="0" CELLPADDING="6" CELLSPACING="0">
    <TR>
    <TD ALIGN="Left"><INPUT TYPE="submit" VALUE="Executar"></TD>
    <TD ALIGN="Left"><INPUT TYPE="reset" VALUE="Limpar"></TD>
    </TR>
    </TABLE>
    </FORM>
    <%
    else
    'execute the SQL Statment'
    Response.Write("<BR><BR>Não atualize esta página ou será executado o comando novamente!<BR><BR>")
    sSQL = Split(Trim(Request.Form("sql")),vbcrlf)
    on error resume next
    OpenCon
    
    
    For i = LBound(sSQL) to UBound(sSQL)
    err.Clear
    if mid(sSQL(i),1,1) = "'" then
        Response.Write("Comentário Encontrado: " & sSQL(i) & "<BR><BR>")
    else
        
        Con.Execute sSQL(i)
        if len(trim(sSQL(i))) <> 0 then
        Response.Write("Executando #" & I + 1 & ": " & sSQL(i) & "<BR>") 
            if err.number <> 0 then '< show any errors that occur
                Response.Write("Erro em #" & I + 1 & ": " & Err.description & "<BR><BR>")
            else
                Response.Write("Executado #" & I + 1 & " Sem Erros<BR><BR>")
            end if
        end if
    end if
    next

    Con.close
    end if
End Sub

Function GetFieldTypeName(I)
select case i
case 0
GetFieldTypeName = "Empty"
case 16
GetFieldTypeName = "TinyInt"
case 2
GetFieldTypeName = "SmallInt"
case 3
GetFieldTypeName = "Integer"
case 20
GetFieldTypeName = "BigInt"
case 17
GetFieldTypeName = "UnsignedTinyInt"
case 18
GetFieldTypeName = "UnsignedSmallInt"
case 19
GetFieldTypeName = "UnsignedInt"
case 21
GetFieldTypeName = "UnsignedBigInt"
case 4
GetFieldTypeName = "Single"
case 5
GetFieldTypeName = "Double"
case 6
GetFieldTypeName = "Currency"
case 14
GetFieldTypeName = "Decimal"
case 131
GetFieldTypeName = "Numeric"
case 11
GetFieldTypeName = "Boolean"
case 10
GetFieldTypeName = "Error"
case 132
GetFieldTypeName = "UserDefined"
case 12
GetFieldTypeName = "Variant"
case 9
GetFieldTypeName = "IDispatch"
case 13
GetFieldTypeName = "IUnknown"
case 72
GetFieldTypeName = "GUID"
case 7
GetFieldTypeName = "Date"
case 133
GetFieldTypeName = "DBDate"
case 134
GetFieldTypeName = "DBTime"
case 135
GetFieldTypeName = "DBTimeStamp"
case 8
GetFieldTypeName = "BSTR"
case 129
GetFieldTypeName = "Char"
case 200
GetFieldTypeName = "VarChar"
case 201
GetFieldTypeName = "LongVarChar"
case 130
GetFieldTypeName = "WChar"
case 202
GetFieldTypeName = "VarWChar"
case 203
GetFieldTypeName = "LongVarWChar"
case 128
GetFieldTypeName = "Binary"
case 204
GetFieldTypeName = "VarBinary"
case 205
GetFieldTypeName = "LongVarBinary"
End Select
End Function

Function GetFieldTypeCode(sTXT,sLen)
'I am not overly familar with this stuff'
'you may have to edit these values'
select case sTXT
case "Empty"
GetFieldTypeCode = "Empty"
case "TinyInt"
GetFieldTypeCode = "TinyInt"
case "SmallInt"
GetFieldTypeCode = "SmallInt"
case "Integer"
GetFieldTypeCode = "Integer"
case "BigInt"
GetFieldTypeCode = "BigInt"
case "UnsignedTinyInt"
GetFieldTypeCode = "UnsignedTinyInt"
case "UnsignedSmallInt"
GetFieldTypeCode = "UnsignedSmallInt"
case "UnsignedInt"
GetFieldTypeCode = "UnsignedInt"
case "UnsignedBigInt"
GetFieldTypeCode = "UnsignedBigInt"
case "Single"
GetFieldTypeCode = "Single"
case "Double"
GetFieldTypeCode = "Double"
case "Currency"
GetFieldTypeCode = "Currency"
case "Decimal"
GetFieldTypeCode = "Decimal"
case "Numeric"
GetFieldTypeCode = "Numeric"
case "Boolean"
GetFieldTypeCode = "Boolean"
case "Error"
GetFieldTypeCode = "Error"
case "UserDefined"
GetFieldTypeCode = "UserDefined"
case "Variant"
GetFieldTypeCode = "Variant"
case "IDispatch"
GetFieldTypeCode = "IDispatch"
case "IUnknown"
GetFieldTypeCode = "IUnknown"
case "GUID"
GetFieldTypeCode = "GUID"
case "Date"
GetFieldTypeCode = "Date"
case "DBDate"
GetFieldTypeCode = "DBDate"
case "DBTime"
GetFieldTypeCode = "DBTime"
case "DBTimeStamp"
GetFieldTypeCode = "DBTimeStamp"
case "BSTR"
GetFieldTypeCode = "BSTR(" & sLen & ")"
case "Char"
GetFieldTypeCode = "Char(" & sLen & ")"
case "VarChar"
GetFieldTypeCode = "VarChar(" & sLen & ")"
case "LongVarChar"
GetFieldTypeCode = "LongVarChar(" & sLen & ")"
case "WChar"
GetFieldTypeCode = "WChar(" & sLen & ")"
case "VarWChar"
GetFieldTypeCode = "VarWChar(" & sLen & ")"
case "LongVarWChar"
GetFieldTypeCode = "LongVarWChar(" & sLen & ")"
case "Binary"
GetFieldTypeCode = "Binary(" & sLen & ")"
case "VarBinary"
GetFieldTypeCode = "VarBinary(" & sLen & ")"
case "LongVarBinary"
GetFieldTypeCode = "LongVarBinary"
case else
GetFieldTypeCode = "IUnknown"
End Select
End Function


End If  ' Fim do teste para ver se tem autorizacao para visualizar esta página
%>