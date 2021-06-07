<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
	Dim strSQL, objRS, ObjConn
	Dim strCOD_PROD, strCERTIFICADO_TEXTO, strDIPLOMA_TEXTO, strVOUCHER_TEXTO, strVOUCHER_TEXTO_US, strVOUCHER_TEXTO_ES, strSINOPSE, strDINAMICA, strIMG
	
	Dim strCertificadopdf, strDiplomapdf, strGrupointl, strTitulointl, strDescricaointl, strCertificadopdf_or
	
	Dim strCERTIFICADO_TEXTO_INTL, strDIPLOMA_TEXTO_INTL, strCertificadopdf_INTL, strDiplomapdf_INTL, strDescricaoHtml
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strCOD_PROD = Replace(Request("var_chavereg"),"'","''")
	
	strSQL = "SELECT * " & _
	         "  FROM tbl_PRODUTOS " & _
			 " WHERE COD_PROD = " & strCOD_PROD & _
			 " AND tbl_Produtos.COD_EVENTO = " & Session("COD_EVENTO")

	set objRS = objConn.Execute(strSQL)
	
	strCERTIFICADO_TEXTO = objRS("CERTIFICADO_TEXTO") & ""
	strDIPLOMA_TEXTO 	 = objRS("DIPLOMA_TEXTO") & ""
	strVOUCHER_TEXTO 	 = objRS("VOUCHER_TEXTO") & ""
	strVOUCHER_TEXTO_US  = objRS("VOUCHER_TEXTO_US") & ""
	strVOUCHER_TEXTO_ES  = objRS("VOUCHER_TEXTO_ES") & ""
	strSINOPSE 			 = objRS("SINOPSE") & ""
	strDINAMICA			 = objRS("DINAMICA") & ""
	
	strCertificadopdf 	 = objRS("CERTIFICADO_PDF") & ""
	strDiplomapdf	 	 = objRS("DIPLOMA_PDF") & ""
	strGrupointl		 = objRS("GRUPO_INTL") & ""
	strTitulointl		 = objRS("TITULO_INTL") & ""
	strDescricaointl	 = objRS("DESCRICAO_INTL") & ""	
	strCertificadopdf_or = objRS("CERTIFICADO_PDF_ORIENTACAO") & ""
	

	strCERTIFICADO_TEXTO_INTL = objRS("CERTIFICADO_TEXTO_INTL") & ""
	strDIPLOMA_TEXTO_INTL  	  = objRS("DIPLOMA_TEXTO_INTL") & ""
	strCertificadopdf_intl 	  = objRS("CERTIFICADO_PDF_INTL") & ""
	strDiplomapdf_intl        = objRS("DIPLOMA_PDF_INTL") & ""
	
	strDescricaoHtml		  = objRS("DESCRICAO_HTML") & ""

	

'*********************************************************************
'           Função para montar tabela de info
'*********************************************************************
Function MontaTabelaPrecos
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Data Término</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>$$ Lista</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Categoria</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Qtde. Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Qtde. Fim</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Capacidade</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT PL.COD_PRLISTA, PL.COD_PROD, PL.PRC_LISTA, PL.DT_VIGENCIA_INIC, PL.DT_VIGENCIA_FIM, SP.COD_STATUS_PRECO, SP.STATUS, PL.QTDE_INIC, PL.QTDE_FIM, PL.CAPACIDADE " &_
	         "FROM tbl_PrcLista PL, tbl_Status_Preco SP, tbl_Produtos P " &_
			 "WHERE PL.COD_PROD = " & strCOD_PROD &_
			 "  AND PL.COD_STATUS_PRECO = SP.COD_STATUS_PRECO " &_
			 "  AND PL.COD_PROD = P.COD_PROD " &_
			 "  AND P.COD_EVENTO = " & Session("COD_EVENTO") &_
			 "  AND SP.COD_EVENTO = " & Session("COD_EVENTO") &_
			 " ORDER BY PL.DT_VIGENCIA_INIC, PL.DT_VIGENCIA_FIM, SP.COD_STATUS_PRECO"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_INIC"),True,False) & "</td>")
     	Response.Write("       <td noWrap align='left' bgcolor='" & strBgColor & "'>" & PrepData(objRS_LOCAL("DT_VIGENCIA_FIM"),True,False) & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>")
		If objRS_LOCAL("PRC_LISTA")&"" <> "" Then
		  Response.Write(FormatNumber(objRS_LOCAL("PRC_LISTA")))
		End If
		Response.Write("       </td>")
        Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("QTDE_INIC") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("QTDE_FIM") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("CAPACIDADE") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellspacing='0' cellpadding='0'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'>&nbsp;</td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='img/separator.gif' width='100%' height='2' vspace='5'></td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Function

'*********************************************************************
'           Função para montar tabela de palestrantes
'*********************************************************************
Function MontaListaPalestrantes
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Nome</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Tema</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Função</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>e-mail</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Início</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Término</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Confirmado</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = " SELECT P.COD_PALESTRANTE, E.NOMECLI, E.EMAIL1, P.CARGO, PP.FUNCAO, PP.TEMA, PP.HORA_INI, PP.HORA_FIM, PP.CONFIRMADO, PP.ORDEM " &_
			 " FROM tbl_Palestrante AS P, tbl_Palestrante_Evento AS PE, tbl_Produtos_Palestrante AS PP, tbl_Empresas AS E" &_
			 " WHERE P.COD_PALESTRANTE = PE.COD_PALESTRANTE " &_
			 " AND PE.COD_EVENTO = " & Session("COD_EVENTO") &_
			 " AND P.COD_PALESTRANTE = PP.COD_PALESTRANTE " &_
			 " AND PP.COD_PALESTRANTE = PE.COD_PALESTRANTE " &_
			 " AND PP.COD_PROD = " & strCOD_PROD &_
			 " AND P.COD_EMPRESA = E.COD_EMPRESA " &_
			 " ORDER BY PP.ORDEM, PP.FUNCAO, PP.HORA_INI, PP.HORA_FIM, E.NOMECLI " 
			 
'	Response.Write(strSQL)
	
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("NOMECLI") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("TEMA") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("FUNCAO") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("EMAIL1") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>")
		If IsDate(objRS_LOCAL("HORA_INI")) Then
		  Response.Write( Right("0"&Hour(objRS_LOCAL("HORA_INI")),2) & ":" & Right("0"&Minute(objRS_LOCAL("HORA_INI")),2) )
	    End If
		Response.Write("       </td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>")
		If IsDate(objRS_LOCAL("HORA_FIM")) Then
		  Response.Write( Right("0"&Hour(objRS_LOCAL("HORA_FIM")),2) & ":" & Right("0"&Minute(objRS_LOCAL("HORA_FIM")),2) )
	    End If
		Response.Write("       </td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" )
		Select Case objRS_LOCAL("CONFIRMADO")&""
		  Case "0"
			Response.Write("Não")
		  Case "1"
			Response.Write("Sim")
		  Case Else 
			Response.Write("-") 
		End Select
		Response.Write("       </td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellspacing='0' cellpadding='0'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'>&nbsp;</td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='img/separator.gif' width='100%' height='2' vspace='5'></td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Function

Function MontaListaRestricoes
Dim objRS_LOCAL, strSQL
Dim i, strBgColor, strRestricao
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Produto</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Restrição</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10'><strong>Cod.Prod Equiv.</strong></td>")		
	Response.Write("        </tr>")
    '<!-- header da tabela ----------------------------------------------------------->
	
	strSQL = " SELECT PR.ID_AUTO, P.TITULO, PR.RESTRICAO,PR.COD_PROD_EQUIV " &_
			 " FROM TBL_PRODUTOS AS P, tbl_PRODUTOS_RESTRICAO AS PR " &_
			 " WHERE P.COD_PROD = PR.COD_PROD_RELACAO " &_
			 " AND PR.COD_PROD = " & strCOD_PROD &_
			 " ORDER BY TITULO " 
			 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		
		If objRS_LOCAL("RESTRICAO") = -1 Then
			strRestricao = "Não permite comprar junto (Erro)"
		ElseIf objRS_LOCAL("RESTRICAO") = 1 Then
			strRestricao = "Não permite comprar junto (Alerta)"
		ElseIf objRS_LOCAL("RESTRICAO") = 0 Then
		    strRestricao = "Compra Obrigatória"
		End If
			
		
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("TITULO") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "'>" & strRestricao & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("COD_PROD_EQUIV") & "</td>")			
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellspacing='0' cellpadding='0'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'></td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='img/separator.gif' width='100%' height='2' vspace='5'></td>")
	Response.Write("  </tr>")
	Response.Write("</table>")

	FechaRecordSet objRS_LOCAL
End Function

Function MontaListaCombo
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellpadding='1' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='40%'><strong>Produto</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='30%'><strong>Status</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15%'><strong>Desconto Perc.</strong></td>")
	Response.Write("          <td bgcolor='#7DACC5' class='arial10' width='15%'><strong>Desconto Valor</strong></td>")
	Response.Write("        </tr>")
    '<!-- header da tabela ----------------------------------------------------------->
	
	strSQL = " SELECT PC.ID_AUTO, P.TITULO, PC.DESCONTO_PERC, PC.DESCONTO_VLR, SP.STATUS  " &_
			 "   FROM TBL_PRODUTOS AS P, tbl_PRODUTOS_COMBO AS PC, tbl_STATUS_PRECO AS SP " &_
			 "  WHERE P.COD_PROD = PC.COD_PROD_RELACAO " &_
			 "    AND PC.COD_STATUS_PRECO = SP.COD_STATUS_PRECO " &_
			 "    AND PC.COD_PROD = " & strCOD_PROD &_
			 "  ORDER BY TITULO " 
			 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("TITULO") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "' align='right'>&nbsp;" & objRS_LOCAL("DESCONTO_PERC") & "</td>")
     	Response.Write("       <td bgcolor='" & strBgColor & "' align='right'>&nbsp;" & objRS_LOCAL("DESCONTO_VLR") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='98%' border='1' bordercolor='#FFFFFF' cellspacing='0' cellpadding='0'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'></td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><img src='img/separator.gif' width='100%' height='2' vspace='5'></td>")
	Response.Write("  </tr>")
	Response.Write("</table>")

	FechaRecordSet objRS_LOCAL
End Function

Function MontaTabelaDocumentos
Dim objRS_LOCAL, strSQL
Dim i, strBgColor

	strSQL = "SELECT t1.id_documento, t1.rotulo, area " &_
	         "FROM tbl_documentos AS t1 " &_
			 "WHERE t1.cod_evento = " & Session("COD_EVENTO") &_
			 "  AND t1.COD_PROD = " & strCOD_PROD &_
			 " ORDER BY t1.rotulo"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	If Not objRS_LOCAL.EOF Then
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
	'<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Rotulo</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr height=""20"">")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("rotulo") & "</td>")
		Response.Write("     </tr>")

		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  </tr>")
	Response.Write("  <tr><td height=""20"" colspan='2'></td></tr>")
	Response.Write("</table>")
	
	End If

	FechaRecordSet objRS_LOCAL
End Function

%>
<html>
<head>
<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
<script language="JavaScript">
<!--
function viewdoc(doc) {
  var conteudo = '';
 
  conteudo = eval('document.formdetail.var_' + doc + '_texto.value;');
  /* Estava enviadndo por metodo GET...  
     Foi modificado para enviao via metodo POST (by Aless)
     window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1'); */

  var myform  = document.createElement("form");
  var myinput = document.createElement("input");

  myinput.value = conteudo;
  myinput.type  = "hidden";
  myinput.name  = "var_html";
  myform.name   = "formviewdoc";
  myform.action = "viewhtml.asp";
  myform.method = "post";
  myform.target = "_blank";  
  myform.appendChild(myinput);
  document.body.appendChild(myform);
  myform.submit();
}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle"><br>
   <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Detalhes de Produtos</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
                <td align="center"> 
				  <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="formdetail" action="" method="post">
				    <input name="var_certificado_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strCERTIFICADO_TEXTO))%>">
				    <input name="var_diploma_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strDIPLOMA_TEXTO))%>">
					<input name="var_voucher_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strVOUCHER_TEXTO))%>">

					<input name="var_Certificadopdf_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strCertificadopdf))%>">
                    <input name="var_Diplomapdf_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strDiplomapdf))%>">
					<input name="var_Grupointl_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strGrupointl))%>">
					<input name="var_Titulointl_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strTitulointl))%>">
					<input name="var_Descricaointl_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strDescricaointl))%>">

				    <input name="var_certificadointl_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strCERTIFICADO_TEXTO_INTL))%>">
				    <input name="var_diplomaintl_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strDIPLOMA_TEXTO_INTL))%>">
					<input name="var_certificadopdfintl_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strCertificadopdf_INTL))%>">
                    <input name="var_diplomapdfintl_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strDiplomapdf_INTL))%>">
                    <input name="var_descricao_html_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(strDescricaoHtml))%>">
																										
                    <tr> 
                        <td align="right" width="120">C&oacute;digo:&nbsp;</td>
                        <td align="left"><%=objRS("COD_PROD")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Grupo:&nbsp;</td>
                        <td align="left"><%=objRS("GRUPO")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">T&iacute;tulo:&nbsp;</td>
                        <td align="left"><%=objRS("TITULO")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">T&iacute;tulo Abreviado:&nbsp;</td>
                        <td align="left"><%=objRS("TITULO_MINI")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120" valign="top">Descri&ccedil;&atilde;o:&nbsp;</td>
                        <td align="left"><%=objRS("DESCRICAO")%></td>
                    </tr>
                    
                    <tr>
                        <td align="right" width="120" valign="top">Descricao Html:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strDescricaoHtml),150)) )
													  If len(strGrupointl) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('descricao_html');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>
                    
                    
                    
                    
                    <tr> 
                        <td align="right" width="120">Capacidade:&nbsp;</td>
                        <td align="left"><%=objRS("CAPACIDADE")%></td>
                    </tr>
                    <tr>
                      <td align="right">Refer&ecirc;ncia Num&eacute;rica:&nbsp;</td>
                      <td align="left"><%=objRS("REF_NUMERICA")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Data/Hora In&iacute;cio:&nbsp;</td>
                        <td align="left"><%=PrepData(objRS("DT_OCORRENCIA"),True,True)%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Data/Hora T&eacute;rmino:&nbsp;</td>
                        <td align="left"><%=PrepData(objRS("DT_TERMINO"),True,True)%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Local:&nbsp;</td>
                        <td align="left"><%=objRS("LOCAL")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Carga Horária:&nbsp;</td>
                        <td align="left"><%=objRS("CARGA_HORARIA")%></td>
                    </tr>
                    <tr>
                        <td align="right" width="120">ID Start Comp:&nbsp;</td>
                        <td align="left"><%=objRS("NUM_COMPETIDOR_START")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120" valign="top">Sinopse:&nbsp;</td>
                        <td align="left"><%=strSINOPSE%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120" valign="top">Dinâmica:&nbsp;</td>
                        <td align="left"><%=strDINAMICA%></td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">Config. Certificado:&nbsp;</td>
                        <td align="left">
<% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strCERTIFICADO_TEXTO),150)) )
													  If len(strCERTIFICADO_TEXTO) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificado');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">Config. Diploma:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strDIPLOMA_TEXTO),150)) )
													  If len(strDIPLOMA_TEXTO) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diploma');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">Config. Voucher:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strVOUCHER_TEXTO),150)) )
													  If len(strVOUCHER_TEXTO) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('voucher');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>
					
					
                    <tr>
                        <td align="right" width="120" valign="top">Config. Voucher US:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strVOUCHER_TEXTO_US),150)) )
													  If len(strVOUCHER_TEXTO_US) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('voucher_us');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>

					
					
                    <tr>
                        <td align="right" width="120" valign="top">Config. Voucher ES:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strVOUCHER_TEXTO_ES),150)) )
													  If len(strVOUCHER_TEXTO_ES) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('voucher_es');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>




                    <tr>
                        <td align="right" width="120" valign="top">Certificado PDF:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strCertificadopdf),150)) )
													  If len(strCertificadopdf) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2">(<%=strCertificadopdf_or%>)&nbsp;
                        <a href="javascript:viewdoc('Certificadopdf');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                    </tr>
                    

                    <tr>
                        <td align="right" width="120" valign="top">Diploma PDF:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strDiplomapdf),150)) )
													  If len(strDiplomapdf) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('Diplomapdf');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>



                    <tr>
                        <td align="right" width="120" valign="top">Grupo Intl:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strGrupointl),150)) )
													  If len(strGrupointl) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('Grupointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>



                    <tr>
                        <td align="right" width="120" valign="top">Titulo Intl:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strTitulointl),150)) )
													  If len(strTitulointl) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('Titulointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>



                    <tr>
                        <td align="right" width="120" valign="top">Descrição Intl:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strDescricaointl),150)) )
													  If len(strDescricaointl) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('Descricaointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>
					

                    <tr>
                        <td align="right" width="120" valign="top">Config. Certificado Intl:&nbsp;</td>
                        <td align="left">
<% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strCERTIFICADO_TEXTO_INTL),150)) )
													  If len(strCERTIFICADO_TEXTO_INTL) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('certificadointl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">Config. Diploma Intl:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strDIPLOMA_TEXTO_INTL),150)) )
													  If len(strDIPLOMA_TEXTO_INTL) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomaintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>

					
					
                    <tr>
                        <td align="right" width="120" valign="top">Certificado PDF Intl:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strCertificadopdf_INTL),150)) )
													  If len(strCertificadopdf_INTL) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2">(<%=strCertificadopdf_or%>)&nbsp;
                        <a href="javascript:viewdoc('certificadopdfintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"><strong>visualizar</strong></a></td>
                    </tr>
                    

                    <tr>
                        <td align="right" width="120" valign="top">Diploma PDF Intl:&nbsp;</td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(strDiplomapdf_INTL),150)) )
													  If len(strDiplomapdf_INTL) > 150 Then Response.Write("...")
													%>					  </td>
                    </tr>
                    <tr>
                        <td align="right" width="120" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('diplomapdfintl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                    </tr>

					
					
					
                    <tr>
                      <td align="right">&nbsp;</td>
                      <td align="left">&nbsp;</td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Outros produtos que&nbsp;<br>
                          garantem acesso:&nbsp;</td>
                        <td align="left"><%=objRS("COD_PROD_VALIDA")%></td>
                    </tr>
                    <tr>
					    <td align="right" bgcolor="#CCCCCC">Regra para Exibir</td>
					    <td align="left" bgcolor="#CCCCCC"> do Certificado do PAX:&nbsp;&nbsp;</td>
				      </tr>
                    <tr> 
                        <td align="right" width="120">Exibir Certificado PAX
                        somente&nbsp;<br>
com <strong>presen&ccedil;a</strong> no(s) produto(s):&nbsp;</td>
                        <td align="left">&nbsp;<%=objRS("CERTIFICADO_COD_PROD_VALIDA")%></td>
                    </tr>
                    <tr> 
                        <td align="right">Exibir Certificado PAX<br>
                         <strong>se respondido </strong>questionario:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190">&nbsp;<%=objRS("CERTIFICADO_VINCULO_COD_QUESTIONARIO")%></td>
                              <td width="190">Ex: &quot;"31" (código de questionário)</td>
                            </tr>
                          </table>
                        </td>
	                  </tr>
                       <tr> 
                        <td align="right" valign="top">Quantidade Minima<br>
                         <strong>de produtos distintos </strong>com leitura:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190">&nbsp;<%=objRS("CERTIFICADO_NRO_PRODUTOS_MIN")%></td>
                      	<td width="190">Ex: &quot;"3" - leitura/presença em no mínimo 3 produtos</td>
                            </tr>
                          </table>
                        </td>
	                  </tr>
                       <tr> 
                         <td align="right" valign="top">Quantidade de horas<br>
                         <strong>mínima </strong>de presença:&nbsp;</td>
	                    <td align="left">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                             <td align="left"><%=objRS("CERTIFICADO_CARGA_HORARIA_MIN")%>
                         </td>
                       <td width="190">Ex: &quot;"8" - (soma das cargas horárias dos produtos que teve presença)</td>
                            </tr>
                          </table>
                        </td>
	                  </tr>
                    <tr> 
                        <td align="right" width="120">Exibir Certificado PAX com<br>
                        <strong>retirada de material&nbsp;</strong>ap&oacute;s data:&nbsp;</td>
                        <td align="left"><%=PrepData(objRS("CERTIFICADO_DT_RETIRADA_MATERIAL"),True,True)%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Exibir na Loja Agenda:&nbsp;</td>
                        <td align="left">
<%
					   If objRS("LOJA_AGENDA_SHOW") Then
					     Response.Write("Sim")
					   Else
					     Response.Write("Não")
					   End If
					   %></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Tipo Restrição:&nbsp;</td>
                        <td align="left"><% response.Write(getValue(objRS,"LOJA_TIPO_RESTRICAO"))%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Exibir na Loja:&nbsp;</td>
                        <td align="left">
<%
					   If objRS("LOJA_SHOW") Then
					     Response.Write("Sim")
					   Else
					     Response.Write("Não")
					   End If
					   %></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Editar na Loja:&nbsp;</td>
                        <td align="left">
<%
					   If objRS("LOJA_EDIT_QTDE") Then
					     Response.Write("Sim")
%>
                       &nbsp;&nbsp;&nbsp;
                       Qtde. Max. Unit. <%=objRS("QTDE_MAX_UNIT")%>
<%						 
					   Else
					     Response.Write("Não")
					   End If
					   %>
                       </td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Exibir no CAEX:&nbsp;</td>
                        <td align="left">
<%
					   If objRS("CAEX_SHOW") Then
					     Response.Write("Sim")
					   Else
					     Response.Write("Não")
					   End If
					   %></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Exibir no Check-in:&nbsp;</td>
                        <td align="left">
<%
					   If objRS("CHECKIN_SHOW") Then
					     Response.Write("Sim")
					   Else
					     Response.Write("Não")
					   End If
					   %></td>
                    </tr>
					<tr> 
                        <td align="right" width="120">Cor Fundo:&nbsp;</td>
                        <td align="left" bgcolor="<%=objRS("BGCOLOR")%>"><%=objRS("BGCOLOR")%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Imagem:&nbsp;</td>
                        <td align="left">
						<%
						strIMG = objRS("IMG")&""
						If strIMG <> "" Then
						%>
                        <img src='../imgdin/<%=strIMG%>' border='0'>
                        <%
						End If
						%></td>
                    </tr>
                    <tr> 
                        <td align="right" width="120">Ordem:&nbsp;</td>
                        <td align="left"><%=objRS("ORDEM")%></td>
                    </tr>
                    
                     <tr>
					    <td align="right">&nbsp;</td>
					    <td align="left">&nbsp;</td>
				      </tr>
					  
                      <tr>
					    <td align="right" bgcolor="#CCCCCC">Regra para Exibir</td>
					    <td align="left" bgcolor="#CCCCCC"> Download de arquivos do PAX:&nbsp;&nbsp;</td>
				      </tr>
                      
                      <tr> 
                        <td align="right" valign="top">Exibir Download Arquivos PAX <strong>se respondido</strong> questionario:&nbsp;</td>
	                    <td align="left" valign="top">
						<table width="380" border="0" cellspacing="0" cellpadding="0">
                            <tr>
                              <td width="190">&nbsp;&nbsp;<%=objRS("DOWNLOAD_VINCULO_COD_QUESTIONARIO")%></td>
                              <td width="190">&nbsp;</td>
                            </tr>
                          </table>
                          
                        </td>
	                  </tr>
                    
					<tr>
					  <td align="right">&nbsp;</td>
					  <td align="left">&nbsp;</td>
					  </tr>
					<tr>
					  <td align="right" bgcolor="#CCCCCC">Complemento 1:</td>
					  <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					<tr> 
                        <td align="right" width="120">Título:&nbsp;</td>
                        <td align="left"><%=objRS("EXTRA_INFO_MSG")%></td>
                    </tr>
					<tr> 
                        <td align="right" width="120">Exibir:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_SHOW") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>
					<tr> 
                        <td align="right" width="120"> Requerido:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_REQUERIDO") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>
                    
					<tr>
					  <td align="right">&nbsp;</td>
					  <td align="left">&nbsp;</td>
					  </tr>
					<tr>
					  <td align="right" bgcolor="#CCCCCC">Complemento 2:</td>
					  <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					<tr> 
                        <td align="right" width="120">Título:&nbsp;</td>
                        <td align="left"><%=objRS("EXTRA_INFO_2_MSG")%></td>
                    </tr>
					<tr> 
                        <td align="right" width="120">Exibir:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_2_SHOW") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>
					<tr> 
                        <td align="right" width="120"> Requerido:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_2_REQUERIDO") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>

                    
					<tr>
					  <td align="right">&nbsp;</td>
					  <td align="left">&nbsp;</td>
					  </tr>
					<tr>
					  <td align="right" bgcolor="#CCCCCC">Complemento 3:</td>
					  <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					<tr> 
                        <td align="right" width="120">Título:&nbsp;</td>
                        <td align="left"><%=objRS("EXTRA_INFO_3_MSG")%></td>
                    </tr>
					<tr> 
                        <td align="right" width="120">Exibir:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_3_SHOW") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>
					<tr> 
                        <td align="right" width="120"> Requerido:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_3_REQUERIDO") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>


                    
					<tr>
					  <td align="right">&nbsp;</td>
					  <td align="left">&nbsp;</td>
					  </tr>
					<tr>
					  <td align="right" bgcolor="#CCCCCC">Complemento 4:</td>
					  <td align="left" bgcolor="#CCCCCC">&nbsp;</td>
					  </tr>
					<tr> 
                        <td align="right" width="120">Título:&nbsp;</td>
                        <td align="left"><%=objRS("EXTRA_INFO_4_MSG")%></td>
                    </tr>
					<tr> 
                        <td align="right" width="120">Exibir:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_4_SHOW") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>
					<tr> 
                        <td align="right" width="120"> Requerido:&nbsp;</td>
                        <td align="left"><% If objRS("EXTRA_INFO_4_REQUERIDO") Then Response.Write("Sim") Else Response.Write("Não") End If %></td>
                    </tr>

				  </form>
                  </table>
				</td>
          </tr>
          <tr> 
            <td align="center">&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
          <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_PROD%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
        <br>

      <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Pre&ccedil;os - Produto</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td colspan="2" align="center"><% MontaTabelaPrecos %></td>
                      </tr>
                  </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_PROD%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

        <br>
        <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
            <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
            <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
          </tr>
        </table>
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
          <tr>
            <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
            <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
                <tr>
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Restri&ccedil;&otilde;es- Produto</td>
                </tr>
                <tr>
                  <td height="16" align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center"><table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <form name="form_listarestricao" action="../_database/AthInsertToDB.asp" method="POST">
                        <input type="hidden" name="DEFAULT_TABLE" value="tbl_produtos_restricao">
                        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                        <input type="hidden" name="FIELD_PREFIX"  value="dbvar_">
                        <input type="hidden" name="RECORD_KEY_NAME" value="ID_AUTO">
                        <input type="hidden" name="DEFAULT_LOCATION" value="../adm_produto/update.asp?var_chavereg=<%=objRS("COD_PROD")%>">
                        <input type="hidden" name="dbvar_str_cod_prod" value="<%=objRS("COD_PROD")%>">
                        <tr>
                          <td colspan="2" align="center"><% MontaListaRestricoes %></td>
                        </tr>
                        <tr>
                          <td width="100" align="right">&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                      </form>
                  </table></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
            </table></td>
            <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
          </tr>
        </table>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
            <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
            <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_PROD%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><a href="javascript:form_listarestricao.submit();"></a><img src="../img/t.gif" width="3" height="3"><br></td>
            <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
          </tr>
        </table>
        <br>
        <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
          <tr>
            <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
            <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
            <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
          </tr>
        </table>
        <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
          <tr>
            <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
            <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
                <tr>
                  <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Combos- Produto</td>
                </tr>
                <tr>
                  <td height="16" align="center">&nbsp;</td>
                </tr>
                <tr>
                  <td align="center"><table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <form name="form_listacombo" action="../_database/AthInsertToDB.asp" method="POST">
                        <input type="hidden" name="DEFAULT_TABLE" value="tbl_produtos_combo">
                        <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB_DADOS%>">
                        <input type="hidden" name="FIELD_PREFIX"  value="dbvar_">
                        <input type="hidden" name="RECORD_KEY_NAME" value="COD_PROD">
                        <input type="hidden" name="DEFAULT_LOCATION" value="../adm_produto/update.asp?var_chavereg=<%=objRS("COD_PROD")%>">
                        <input type="hidden" name="dbvar_str_cod_prod" value="<%=objRS("COD_PROD")%>">
                        <tr>
                          <td colspan="2" align="center"><% MontaListaCombo %></td>
                        </tr>
                        <tr>
                          <td width="100" align="right">&nbsp;</td>
                          <td>&nbsp;</td>
                        </tr>
                      </form>
                  </table></td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                </tr>
            </table></td>
            <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
          </tr>
        </table>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
          <tr>
            <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
            <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
            <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
            <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_PROD%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><a href="javascript:form_listacombo.submit();"></a><img src="../img/t.gif" width="3" height="3"><br></td>
            <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
          </tr>
        </table>
        <br>

      <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Palestrantes - Produto</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="98%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td colspan="2" align="center"><% MontaListaPalestrantes %></td>
                      </tr>
                  </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_PROD%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

      <br>
  <table width="98%" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="100%" height="4"><img src="../img/inbox_top_blue.gif" width="100%" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="98%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Documentos</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			      <table width="470" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr> 
                        <td width="120" align="center"><% MontaTabelaDocumentos %></td>
                      </tr>
                  </table>
		    </td>
          </tr>
          <tr><td>&nbsp;</td></tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="98%0" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strCOD_PROD%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
  <br>

</tr></td></table>
</body>
</html>
<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
%>