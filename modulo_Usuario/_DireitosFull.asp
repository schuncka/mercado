<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|UPD_DIR|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<!--#include file="../_scripts/scripts.js"-->
<%
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Dim WMD_WIDTH, WMD_WIDTHTTITLES
 WMD_WIDTH = 630
 WMD_WIDTHTTITLES = 100
 ' -------------------------------------------------------------------------------

  Dim ObjConn, objRS, objRS2, objRS3, strSQL
  Dim strIDUSER, strIDAPP, auxSTR, arrAUX, strCOLOR, Cont
  
  strIDAPP  = GetParam("var_idapp")
  strIDUSER = GetParam("var_iduser")
  
  AbreDBConn objConn, CFG_DB 
%>
<html>
<head>
<title>VBoss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script>
var i=0;
var flagOk=false;
//****** Funções de ação dos botões - Início ******
function ok()       { flagOk = true; submeterForm(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { flagOk = false; submeterForm(); }

function submeterForm() {
 if (i<document.forms.length) 
  { 
   document.forms[i].var_todos.value = 'T'; 
   document.forms[i].submit(); 
  }
 else 
  { 
   i=0; 
   if (flagOk) { parent.frames["vbTopFrame"].document.form_principal.submit(); }	  
   else { Recarrega(); }	 
  }
}
//****** Funções de ação dos botões - Fim ******

function SomaIGrava() { i++; submeterForm(); }
function Recarrega()  { 
  //setTimeout("document.location.reload()",1000); 
  document.location = "DireitosFull.asp?var_iduser=<%=strIDUSER%>"
}
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table align="center" cellpadding="0" cellspacing="0" border="0">
<tr>
 <td valign="top"> 
	<%=athBeginDialog(WMD_WIDTH, "Direitos: " & ucase(strIDUSER))%>
	  <table width="100%" cellpadding="1" cellspacing="0" border="0">
		<%
		 strSQL="SELECT DISTINCT (ID_APP) FROM SYS_APP_DIREITO ORDER BY ID_APP"
		 set objRS = objConn.execute(strSQL)
		 while not objRs.EOF
		 strIDAPP = GetValue(objRS,"ID_APP")
		 
		 if (strCOLOR="#FFFFFF") then strCOLOR="#EFEFEF" else strCOLOR="#FFFFFF" end if
		%> 
		<tr>
		  <td width="30%" valign="middle" style="text-align:right; vertical-align:top" title="<%=strIDAPP%>"><%=replace(strIDAPP,"modulo_","")%>&nbsp;&nbsp;</td>
		  <td width="65%">
			<table cellpadding="0" cellspacing="0" border="0">
			  <tr>
				<td width="1%">
				<table cellpadding="0" cellspacing="0" style="border: 1px solid #C9C9C9;" bgcolor="<%=strCOLOR%>">
				<tr>
				  <form name="formdir_<%=strIDAPP%>" id="formdir_<%=strIDAPP%>" action="DireitosExec.asp" method="post" target="VBossIframeSave_<%=strIDAPP%>">
				  <input type="hidden" name="var_iduser" value="<%=strIDUSER%>">
				  <input type="hidden" name="var_idapp"  value="<%=strIDAPP%>">
				  <input type="hidden" name="var_todos"  value="F">
				<%
				  auxSTR = ""
				  strSQL = " SELECT T2.ID_DIREITO FROM SYS_APP_DIREITO_USUARIO T1, SYS_APP_DIREITO T2 " &_
						   "  WHERE T1.ID_USUARIO = '" & strIDUSER & "'" &_
						   "    AND T2.ID_APP = '" & strIDAPP & "' AND T1.COD_APP_DIREITO = T2.COD_APP_DIREITO"
				  set objRS3 = objConn.execute(strSQL)
				  while not objRS3.EOF
					auxSTR = auxSTR & getValue(objRS3,"ID_DIREITO") & "|"
					objRS3.MoveNext
				  Wend	
				  FechaRecordSet objRS3
				  arrAux = split(auxSTR,"|")
					
				  strSQL="SELECT SYS_APP_DIREITO.ID_DIREITO, SYS_DIREITO.DESCRICAO, SYS_APP_DIREITO.COD_APP_DIREITO " &_
						 "  FROM SYS_APP_DIREITO, SYS_DIREITO " &_ 
						 " WHERE SYS_APP_DIREITO.ID_DIREITO = SYS_DIREITO.ID_DIREITO " &_ 
						 "   AND ID_APP='" & strIDAPP & "' ORDER BY SYS_DIREITO.ORDEM "
				  set objRS2 = objConn.execute(strSQL)
				  Cont = 1 
				  while not objRS2.EOF
				%>
					<td width="1">
						<table width="1" cellpadding="0" cellspacing="3" border="0">
						<tr>
							<td height="16" align="left" valign="top">
							  <input type="checkbox" id="var_direitos" name="var_direitos" class="inputclean" style="height:12px; width:12px; background-color:<%=strCOLOR%>;" title="<%=getValue(objRS2,"DESCRICAO")%>" value="<%=getValue(objRS2,"COD_APP_DIREITO")%>"
							  <% if ArrayIndexOf(arrAUX,getValue(objRS2,"ID_DIREITO")) <>-1 then response.write "checked"%>>
							</td>
							<td align="left" valign="middle" nowrap="nowrap"><%=GetValue(objRS2,"ID_DIREITO")%></td>
						</tr>
						</table>
					</td>
				<%
					objRS2.movenext
					if ((Cont mod 5)=0) then response.write("</tr><tr>") end if
					Cont = Cont + 1
				  wend
				  FechaRecordSet objRS2
				%>
				  </form>
				</tr>
				</table>
				  <td width="1%" align="right" valign="middle" nowrap>
					<a href="javascript:document.formdir_<%=strIDAPP%>.submit();"><img src="../img/BtOk.gif" border="0" hspace="6"></a>
				  </td>
				  <td width="98%" valign="middle" style="text-align:right" nowrap>
					<iframe id="VBossIframeSave_<%=strIDAPP%>" frameborder="0" width="16" height="16" name="VBossIframeSave_<%=strIDAPP%>" scrolling="no"></iframe>
				  </td>
			  </tr>
			</table>
		  </td>
		</tr>
		<tr><td colspan="2" height="5"></td></tr>
		<%
		  objRS.movenext
		 wend
		 FechaRecordSet objRS
		%> 
	  </table>
	<%=athEndDialog("", "../img/butxp_ok.gif", "ok();", "../img/butxp_cancelar.gif", "cancelar();", "../img/butxp_aplicar.gif", "aplicar();") %>
 </td>
 
 <td valign="top" align="left"><br><br>&nbsp;<b>Legenda:</b><br><br>
	<%
	  strSQL = " SELECT ID_DIREITO, DESCRICAO FROM SYS_DIREITO "
	  set objRS = objConn.execute(strSQL)
	  response.write "<span style=' font-size: 9px; font-family : Tahoma'>" 
	  while not objRS.EOF
		response.write "&nbsp;" & getValue(objRS,"ID_DIREITO") & "<BR>&nbsp;" & getValue(objRS,"DESCRICAO") & "<BR><BR>" 
		objRS.MoveNext
	  Wend	
	  response.write "</span>" 
	  FechaRecordSet objRS
	%>
 </td>
</tr>
</table>
<%
  FechaDBConn objConn
%>
</body>
</html>
