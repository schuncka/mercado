<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% VerificaDireito "|RUN|", BuscaDireitosFromDB("modulo_RelatorioASLW",Session("METRO_USER_ID_USER")), true %>
<%
 Dim objConn, objRS, strSQL
 Dim strSQLRel, auxStrSQLRel, strNOME, strCOD_REL, strCATEGORIA, strDESCRICAO, strMSG, str, pos, strACAO
 Dim strInicParam, strFimParam
 
 ' Foi necess�rio indicar um caracter de fim de par�metro 
 ' para evitar problemas com ":param#" e ":param%"
 '--------------------------------------------------------
 strInicParam = "["
 strFimParam = "]"
 '--------------------------------------------------------
  
 strMSG = ""
 
 strCOD_REL   = Request("var_chavereg")
 strSQLRel    = " " & Request("var_strParam") & " "
 strNOME      = Request("var_nome")
 strCATEGORIA = Request("var_categoria")
 strDESCRICAO = Request("var_descricao")
 strACAO      = Request("var_acao")

 '-----------------------------------------------------------------------------
 ' Deve verificar primeiro se veio o C�DIGO do Relat�rio. Se sim � porque o 
 ' relat�rio j� est� no banco e quem chamou sabe disso e apenas passa o c�digo.
 ' Se n�o veio C�DIGO do Relat�rio � porque quem chamou est� apenas testanto 
 ' uma consulta que n�o foi pro banco ainda.
 '-----------------------------------------------------------------------------
 If strCOD_REL <> "" Then
	 AbreDBConn objConn, CFG_DB
	 
	 strSQL = " SELECT T1.NOME, T1.DESCRICAO, T1.EXECUTOR, T1.PARAMETRO " & _ 
	          "      , T1.DT_INATIVO, T2.NOME AS CATEGORIA " & _ 
	          "   FROM tbl_ASLW_RELATORIO T1  " & _
		 	  "   LEFT OUTER JOIN tbl_ASLW_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) " & _
	          "  WHERE T1.COD_RELATORIO = " & strCOD_REL 
	 set objRS = objConn.Execute(strSQL)
 'response.Write(strSQL)
 
 'Response.End()
	 If Not objRS.Eof Then
		 strSQLRel = " " & ObjRS("PARAMETRO") & " "
		 strNOME   = ObjRS("NOME")
		 strCATEGORIA = ObjRS("CATEGORIA")
		 strDESCRICAO = ObjRS("DESCRICAO")
	 End If

	 If Not objRS.Eof Then
 		'Verifica se est� ativo
	 	If ObjRS("DT_INATIVO") <> "" Then
			strMSG = strMSG & "<br>Relat�rio foi inativado em " & ObjRS("DT_INATIVO") & "."
		End If
	
		'Verifica se existe algum executor
		If ObjRS("EXECUTOR") = "" Then
			strMSG = strMSG & "<br>N�o foi definido um executor para consulta."
		End If

		'Verifica se existe alguma consulta
		If (UCase(ObjRS("EXECUTOR")) = "EXECASLW.ASP") And (Trim(strSQLRel) = "") Then
			strMSG = strMSG & "<br>Consulta vazia. Cl�usula SQL n�o encontrada."
		End If
	 Else
	 	strMSG = strMSG & "<br>Relat�rio n�o encontrado."
	 End If

	 FechaRecordSet ObjRS
 	 FechaDBConn ObjConn
 Else
	 If Trim(strSQLRel) = "" Then
		strMSG = strMSG & "<br>Consulta vazia. Cl�usula SQL n�o encontrada."
	 End If
 End If

 'Response.Write(strSQLRel & "<br>")
 'Response.Write(auxStrSQLRel & "<br>")
 'Response.End

 'Neste ponto o que estiver colocado entre { } ser� substitu�do por valores correspondentes
 'de vari�veis ambientes na sess�o
 'ex.: 	SELECT * FROM TBL_INSCRICAO WHERE COD_EVENTO = {METRO_EVENTO_COD_EVENTO}
 '	 	se o evento 112 estiver logado, ser� substitu�do por:
 '		SELECT * FROM TBL_INSCRICAO WHERE COD_EVENTO = 112
 '-----------------------------------------------------------------------------------------
 strSQLRel = replaceParametersSession(strSQLRel)

 'Aqui efetua a EncodeASLW
 '---------------------------------------------------
 auxStrSQLRel = replace(strSQLRel, "%", "<ASLW_PERCENT>")
 auxStrSQLRel = replace(auxStrSQLRel, "#", "<ASLW_SHARP>")
 auxStrSQLRel = replace(auxStrSQLRel, "+", "<ASLW_PLUS>")
 '---------------------------------------------------
 
 'Aux�lio de digita��o, ajusta sintaxe 
 'Faz as seguintes altera��es: " por ', 
 '	e '[ por [', [% por %[, [# por #[, 
 '	e ]' por '], %] por ]%, #] por ]#
 '-------------------------------------------------------------------------------
 auxStrSQLRel = replace(strSQLRel, """", "'")
 auxStrSQLRel = replace(auxStrSQLRel, "'" & strInicParam, strInicParam & "'")
 auxStrSQLRel = replace(auxStrSQLRel, strFimParam & "'", "'" & strFimParam)

 auxStrSQLRel = replace(auxStrSQLRel, strInicParam & "<ASLW_PERCENT>", "<ASLW_PERCENT>" & strInicParam)
 auxStrSQLRel = replace(auxStrSQLRel, "<ASLW_PERCENT>" & strFimParam, strFimParam & "<ASLW_PERCENT>")

 auxStrSQLRel = replace(auxStrSQLRel, strInicParam & "<ASLW_SHARP>", "<ASLW_SHARP>" & strInicParam)
 auxStrSQLRel = replace(auxStrSQLRel, "<ASLW_SHARP>" & strFimParam, strFimParam & "<ASLW_SHARP>")

 auxStrSQLRel = replace(auxStrSQLRel, VbCrLf, " ")
 '-------------------------------------------------------------------------------
' Response.Write(auxStrSQLRel & "<br>")
 'Response.End()

 ' Por enquanto n�o permitimos as opera��es listadas abaixo. Depois 
 ' poderemos permitir se usu�rio for "superusu�rio", "ADMIN", etc
 If InStr(1, strSQLRel, " INSERT ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o INSERT n�o � permitida."
 If InStr(1, strSQLRel, " UPDATE ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o UPDATE n�o � permitida."
 If InStr(1, strSQLRel, " DELETE ", vbTextCompare) > 0 Then strMSG = strMSG & "<br>Instru��o DELETE n�o � permitida."
 
 If strMSG <> "" Then
 	Mensagem strMSG,"JavaScript:window.close()", "" ,True
 Else
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--
function SetParamToSQL () 
{
  var myStrSQL, cont;
  //alert("SetParamToSQL");
  
  myStrSQL = document.FormPrSQL.sqlBUFFER.value;
  //alert("sqlBUFFER: " + document.FormPrSQL.sqlBUFFER.value);

  cont = 0;
  while ( document.FormPrSQL.elements[cont].name != '' ) 
    {
	  while (myStrSQL.indexOf(document.FormPrSQL.elements[cont].name) > 0) {
	  	myStrSQL = myStrSQL.replace(document.FormPrSQL.elements[cont].name,document.FormPrSQL.elements[cont].value);
	  }
      cont = cont + 1;
    }

  //alert("SQL to Send:" + myStrSQL);
  document.FormPrSQL.sqlBUFFER.value 	= myStrSQL; //????
  document.FormPrSQL.var_strParam.value = myStrSQL;
  document.FormPrSQL.submit();
}
//-->
</script>
</head>
<body>
<%
Dim strURL_DESTINO
strURL_DESTINO = "ResultASLW.asp"
If strACAO = ".xls" or strACAO = ".doc" Then
  strURL_DESTINO = "ResultASLW_detail.asp"
End If
%>
<table width="100%" height="100%" cellpadding="0" cellspacing="0" border="0">
<tr>
<td align="center" valign="middle">
<form name="formEnvia" id="formEnvia" action="<%=strURL_DESTINO%>" method="post">
     <input name="var_nome" 	 id="var_nome" 			type="hidden" value="<%=strNOME%>">
     <input name="var_categoria" id="var_categoria"  	type="hidden" value="<%=strCATEGORIA%>">
	 <input name="var_strParam"  id="var_strParam" 		type="hidden" value="<%=auxStrSQLRel%>">
     <input name="var_acao" 	 id="var_acao" 			type="hidden" value="<%=strACAO%>">
     <input name="var_chavereg"  id="var_chavereg" 		type="hidden" value="<%=strCOD_REL%>">
</form>
<%
If strACAO = ".xls" or strACAO = ".doc" Then
%>
    <div align="center">
    Exportando arquivo Word/Excel.<br>
    Aguarde o t�rmino do download.<br>
    <input type="button" onClick="javascript:window.close();" name="btClose" id="btClose" value="Fechar">
    </div>
<%
End IF
%>

<form name="FormPrSQL" id="FormPrSQL" action="<%=strURL_DESTINO%>"  method="post">
<table cellpadding="0" cellspacing="2" border="0">
<%
   pos=InSTR(auxStrSQLRel,strInicParam)
   if pos>0 then
     while pos>0
	   str=Mid(auxStrSQLRel, pos+1 , InSTR(pos,auxStrSQLRel,strFimParam)-(pos+1))
	   str=replace(str, """","") 
	   str=replace(str, "'","") 
	   auxStrSQLRel=replace(auxStrSQLRel, strInicParam, "", 1, 1) 
	   auxStrSQLRel=replace(auxStrSQLRel, strFimParam, "", 1, 1) 
       response.write ("<tr>")
       response.write (" <td>"& str &"</td>")
       response.write (" <td><input name='"&str&"' id='"&str&"' type='text' value=''></td>")
       response.write ("</tr>")
	   pos=InSTR(auxStrSQLRel,strInicParam)
     wend
   else
     'response.Write(auxStrSQLRel)
	 'response.End()
     'response.redirect("ResultASLW.asp?var_nome=" & strNOME & "&var_categoria=" & strCATEGORIA & "&var_strParam=" & auxStrSQLRel)
	 %>
	 <script language="JavaScript">
	 <!--
	 	   document.formEnvia.submit();
	 //-->
	 </script>
	 <%
   end if
%>
 <tr><td colspan="2"><hr></td></tr>
 <tr>
   <td></td>
   <td align="right">	
		<!-- input name="" type="submit" onClick="document.formEnvia.submit();" //-->
		<input type="button" onClick="javascript:SetParamToSQL(); return false;" value="EXECUTAR">
   </td>
 </tr>
 <tr><td height="20" colspan="2"></td></tr>
 <tr>
   <td colspan="2">
   	 <input name="sqlBUFFER" 	 id="sqlBUFFER" 	type="hidden" value="<%=auxStrSQLRel%>">
     <input name="descBUFFER" 	 id="descBUFFER" 	type="hidden" value="<%=strDESCRICAO%>">
	 <input name="var_strParam"  id="var_strParam" 	type="hidden" value="<%=auxStrSQLRel%>">

     <input name="var_chavereg"  id="var_chavereg"	type="hidden" value="<%=strCOD_REL%>">
     <input name="var_nome" 	 id="var_nome" 		type="hidden" value="<%=strNOME%>">
     <input name="var_categoria" id="var_categoria" type="hidden" value="<%=strCATEGORIA%>">
     <input name="var_acao" id="var_acao" type="hidden" value="<%=strACAO%>">

   </td>
 </tr>
</table>
</form>
</td>
</tr>
</table>
</body>
</html>
<%
 End If
%>
