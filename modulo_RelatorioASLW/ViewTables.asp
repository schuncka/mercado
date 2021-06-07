<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"-->
<!--#include file="../_scripts/scripts.js"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"-->
<%
 Dim objConn, objRS, strSQL, auxStr
 Dim queryType, criteria, selTable, i
 
 AbreDBConn objConn, CFG_DB_DADOS 

 selTable = trim(request("var_table"))
%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
</head>
<body topmargin="0" leftmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<br>
<table width="500" align="center" border="0" cellpadding="2" cellspacing="2" bgcolor="#CCCCCC">
  <tr><td align="left"><b>TABELAS</b></td></tr>
  <tr><td height="1" bgcolor="#FFFFFF"><td></tr>
  <tr>
    <td valign="top">
    <form name="formtables" action="ViewTables.asp" method="post">
      <select name="var_table" onchange='JavaScript:formtables.submit();' style="10">
      <%
        queryType = adSchemaTables
        criteria  = Array(CFG_DB_DADOS,Empty,Empty,"TABLE")
		set objRS = objConn.OpenSchema(queryType,criteria)
        while not objRS.EOF
          auxStr = "<option value='" & objRS(2) & "'" 
    	  if (objRS(2)=selTable) then auxStr = auxStr & "selected"
    	  auxStr = auxStr & ">" & objRS(2) & "</option>"
          Response.Write (auxStr)
          objRS.movenext
        wend
        response.write("<br>" & selTable)
      %>
      </select>
    </form>
	</td>
  </tr>
  <tr><td align="left"><b>CAMPOS</b></td></tr>
  <tr>
    <td valign="top" bgcolor="#FFFFFF">
      <%
       if (selTable<>"") then
  	     strSQL = "Select * from " & selTable
         FechaRecordSet objRS
         set objRS = objConn.Execute(strSQL)
	     if not objRS.EOF then
	        'response.write(objRS.fields(0).name & "<br>")
			Response.Write("SELECT " & "<br>") 
            for i = 0 to objRS.fields.count - 1
              Response.Write("&nbsp;&nbsp;&nbsp;")
			  if i>0 then Response.Write(",") 
			  Response.Write("<b>" & objRS.Fields(i).name & "</b><br>") 
            next
			Response.Write("FROM " & "<BR>&nbsp;&nbsp;&nbsp;" & selTable & "<br>") 
         end if
       end if	   
      %>
	</td>
  <tr><td height="20" bgcolor="#CCCCCC"></td></tr>
  </tr>
</table>

</body>
</html>
<%
FechaDBConn ObjConn
%>

