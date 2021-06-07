<!--#include file="../_database/athdbConn.asp"--><% 'ATENÇÃO: language, option explicit, etc... estão no athDBConn %>
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_USUARIO", Request.Cookies("VBOSS")("ID_USUARIO")), true %>
<!--#include file="../_database/athUtils.asp"-->
<%
   ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
   ' e o tamanho da coluna dos títulos dos inputs
   Dim WMD_WIDTH, WMD_WIDTHTTITLES
   WMD_WIDTH = "550"
   WMD_WIDTHTTITLES = 150
   ' -------------------------------------------------------------------------------

   Dim ObjConn, objRS, strSQL, auxAVISO
   Dim	strCODIGO, Idx

   auxAVISO  = "dlg_warning.gif:ATENÇÃO!Você está prestes a remover o registro acima visualizado." &_ 
   		       "Para confirmar clique no botão [ok], para desistir clique em [cancelar]."
   
   strCODIGO = GetParam("var_chavereg")
	
   If GetParam("var_chavereg") <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = "SELECT * FROM USUARIO_LOG WHERE COD_USUARIO_LOG = " & GetParam("var_chavereg") 
      Set objRS = objConn.Execute(strSQL)

      If Not objRS.Eof Then 
%>
<html>
<head>
<title>vboss</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/virtualboss.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
//****** Funções de ação dos botões - Início ******
function ok()       { document.form_delete.submit(); }
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
//****** Funções de ação dos botões - Fim ******
</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<%=athBeginDialog(WMD_WIDTH, "Usuário Log - Dele&ccedil;&atilde;o")%>
     <table width="100%" border="0" cellpadding="1" cellspacing="0" align="center">
        <% for Idx = 0 to objRS.fields.count - 1  'NÃO QUIZ EXIBIR TODOS OS DADOS... %> 
        <tr> 
          <td width=<%=WMD_WIDTHTTITLES%> style="text-align:right"><%=objRS.Fields(Idx).name%>:&nbsp;</td>
          <td><%=GetValue (objRS, objRS.Fields(Idx).name)%>&nbsp;</td>
        </tr>
        <% next %>
        <tr><td height="20"></td></tr>
     </table>
	 <form name="form_delete" action="../_database/athDeleteToDB.asp" method="post">
       <input type="hidden" name="DEFAULT_TABLE"    value="USUARIO_LOG">
       <input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB%>">
       <input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
       <input type="hidden" name="RECORD_KEY_NAME"  value="COD_USUARIO_LOG">
       <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCODIGO%>">
       <input type="hidden" name="JSCRIPT_ACTION"   value='parent.frames["vbTopFrame"].document.form_principal.submit();'>
     </form>
<%=athEndDialog(auxAVISO, "../img/butxp_ok.gif", "ok()", "../img/butxp_cancelar.gif", "cancelar();", "", "")%>
</body>
</html>
<%
      End If 
      FechaRecordSet objRS
	  FechaDBConn objConn
   End If 
%>