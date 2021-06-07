<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"--> 
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athdbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<%
	Dim strSQL, objRS, ObjConn, objRSLocal
	Dim strCOD_EVENTO, strID_AUTO, strOBSERVACAO, strDOCUMENTO
	
	AbreDBConn objConn, CFG_DB_DADOS
	
	strID_AUTO = Replace(GetParam("var_chavereg"),"'","''")
	
	strSQL = "SELECT COD_EVENTO,NOME,NOME_COMPLETO,CABECALHO,RODAPE,SITE,DT_MATERIAL,HR_MATERIAL,PAVILHAO, "
	strSQL = strSQL &"CIDADE,AGENCIA_TURISMO,AGENCIA_PUBLICIDADE,AGENCIA_BANCARIA,MONTADORA,DT_INICIO,DT_FIM,HORA_INICIO,HORA_FIM,ESTADO_EVENTO, "
	strSQL = strSQL & "LOGOMARCA,FREE,LOJA_STATUS_PRECO,STATUS_PRECO,STATUS_CRED,EMAIL,EMAIL_SENDER,SYS_INATIVO,ATIVO,CABECALHO_LOJA, "
	strSQL = strSQL & "RODAPE_LOJA,INSTRUCAO_INSC_EXISTENTE,ARM_TEXTO,ARM_TEXTO_INTL,ACE_TEXTO,ACE_TEXTO_INTL,ACEPRESS_TEXTO,MOD1_TITLE,MOD1_TEXTO, "
	strSQL = strSQL & "MOD2_TITLE,MOD2_TEXTO,MOD3_TITLE,MOD3_TEXTO,MOD4_TITLE,MOD4_TEXTO,MOD5_TITLE,MOD5_TEXTO,MOD6_TITLE,MOD6_TEXTO,MOD7_TITLE , "
	strSQL = strSQL & "MOD7_TEXTO,FONE,LOJA_ATIVA,LOJAPJ_ATIVA,MODELO_LOJAPJ,IDUSER_LOJA,RECIBO_TEXTO,CNPJ,COD_MOEDA_EVENTO,COD_MOEDA_COBRANCA , "
	strSQL = strSQL & "COD_MOEDA_REFERENCIA,LOJA_SHOW_DADOS,LOJA_SHOW_ENTIDADE,SUBPAPER_ATIVA,STATUS_PRECO_VISITANTE,ATESTADO_TEXTO, "
	strSQL = strSQL & "COD_GRUPO_EVENTO,PSC_ATIVA ,ACE_ASSUNTO,ACE_ASSUNTO_INTL,APE_TEXTO,APE_TEXTO_INTL,ARM_ASSUNTO, "
	strSQL = strSQL & "ARM_ASSUNTO_INTL,CONVITE_TEXTO,MOD8_TITLE  ,ACE_ASSUNTO_US, ACE_ASSUNTO_SP,LOJA_SHOW_FINANCEIRO, LOJA_SHOW_FATURAMENTO , "
	strSQL = strSQL & "MOD8_TEXTO,MOD9_TITLE,MOD9_TEXTO,MOD10_TITLE,MOD10_TEXTO,SMS_USER,SMS_PWD,SMS_TEXTO,CUPOM_FISCAL,VENDA_RAPIDA ,RETIRADA_MATERIAL, "
	strSQL = strSQL & "LIMITE_IDADE,PSC_STATUS_CRED,SMTP_SERVER,SMTP_USER,SMTP_PWD,ACE_TEXTO_US,ACE_TEXTO_SP ,INSCR_MUNICIPAL,ENTIDADE_OBRIGATORIO, "
	strSQL = strSQL & "CERTIFICADO_TEXTO1,CERTIFICADO_TEXTO2,ACEPRESS_TEXTO_US,ACEPRESS_TEXTO_ES,EMAIL_PRESS,APE_ASSUNTO,APE_ASSUNTO_INTL,ACEPRESS_TEXTO_INTL, "
	strSQL = strSQL & "EMAIL_AUDITORIA ,EMAIL_AUDITORIA_INTL,ARIEL_TEXTO,ARIEL_TEXTO_INTL,ARIEL_TEXTO_NPG,PROGRAMACAO,ATESTADO_PDF,ATESTADO_PDF_ORIENTACAO, "
	strSQL = strSQL & "CABECALHO_PAPER,RODAPE_PAPER,LOJA_TIPO_LOGIN ,DESCRICAO,PAIS,BAIRRO,LOGRADOURO,CRED_PRINT_CONTROLE,BARCODE_MODE,BARCODE_HEIGHT, "
	strSQL = strSQL & "CONVITE_VIP_TEXTO,CONVITE_ELETRONICO_TEXTO,CONVITE_ELETRONICO_TEXTO_INTL,CABECALHO_RECIBO,LOJA_PESQUISA_CNPJ,PRESS_STATUS_CRED,SMTP_PORT,IMG1,IMG2 "
	strSQL = strSQL & "FROM tbl_EVENTO " 
	strSQL = strSQL &  "WHERE ID_AUTO = " & strID_AUTO
	'response.Write(strSQL)
	'response.End()

	set objRS = objConn.Execute(strSQL)
	
	strCOD_EVENTO = objRS("COD_EVENTO")
	
'*********************************************************************
'           Função para montar tabela de info
'*********************************************************************
Function MontaTabelaFormaPagamento
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Forma Pagamento</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Exibir Loja</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = "SELECT EFP.COD_EVENTO, EFP.COD_FORMAPGTO, FP.FORMAPGTO, EFP.EXIBIR_LOJA " &_
	         "FROM TBL_EVENTO_FORMAPGTO EFP, TBL_FORMAPGTO FP " &_
			 "WHERE EFP.COD_EVENTO = " & strCOD_EVENTO &_
			 "  AND EFP.COD_FORMAPGTO = FP.COD_FORMAPGTO " &_
			 " ORDER BY FP.FORMAPGTO"
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("FORMAPGTO") & "</td>")
        Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>")
		If objRS_LOCAL("EXIBIR_LOJA") Then
          Response.Write("Sim")		
		Else
          Response.Write("Não")		
		End If
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
	Response.Write("      <table width='95%' border='0' cellspacing='0' cellpadding='0'>")
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
Function MontaListaImagem
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Imagem</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Área</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = " SELECT EI.ARQUIVO, EI.AREA " &_
			 " FROM tbl_EVENTO_IMG AS EI " &_
			 " WHERE EI.COD_EVENTO = " & strCOD_EVENTO &_
			 " ORDER BY EI.AREA, EI.ARQUIVO " 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("ARQUIVO") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("AREA") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='95%' border='0' cellspacing='0' cellpadding='0'>")
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

Function MontaListaStatusCred
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Código</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Status</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = " SELECT EI.COD_STATUS_CRED, EI.STATUS " &_
			 "   FROM tbl_STATUS_CRED AS EI " &_
			 "  ORDER BY EI.STATUS, EI.COD_STATUS_CRED " 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("COD_STATUS_CRED") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='95%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'>&nbsp;</td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
	FechaRecordSet objRS_LOCAL
End Function

Function MontaListaStatusPreco
Dim objRS_LOCAL, strSQL
Dim i, strBgColor
	
	Response.Write("<table width='100%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'><BR>")
	Response.Write("      <table width='95%' border='0' cellpadding='0' cellspacing='0'>")
    '<!-- header da tabela ----------------------------------------------------------->
	Response.Write("        <tr>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><img width='15' height='1' src='../img/1x1.gif'></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Status</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Senha</strong></td>")
	Response.Write("          <td align='left' bgcolor='#7DACC5' class='arial10'><strong>Observação</strong></td>")
	Response.Write("        </tr>")
    '<!-- /header da tabela --------------------------------------------------------->
	
	strSQL = " SELECT EI.COD_STATUS_PRECO, EI.STATUS, EI.SENHA, EI.OBSERVACAO " &_
			 "   FROM tbl_STATUS_PRECO AS EI " &_
			 "  WHERE EI.COD_EVENTO = " & strCOD_EVENTO &_
			 "  ORDER BY EI.STATUS, EI.COD_STATUS_PRECO " 
	Set objRS_LOCAL = objConn.execute(strSQL)
	
	i = 0
	Do While Not objRS_LOCAL.EOF
		If (i mod 2) = 0 Then
			strBgColor = "#E0ECF0"
		Else
			strBgColor = "#FFFFFF"
		End If

		strOBSERVACAO = objRS_LOCAL("OBSERVACAO")		
'		If Len(objRS_LOCAL("OBSERVACAO")) > 100 Then
'			strOBSERVACAO = Mid(objRS_LOCAL("OBSERVACAO"),1,35) & "..."
'		Else
'			strOBSERVACAO = objRS_LOCAL("OBSERVACAO")
'		End If
		Response.Write("     <tr>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'></td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("STATUS") & "</td>")
		Response.Write("       <td noWrap bgcolor='" & strBgColor & "'>" & objRS_LOCAL("SENHA") & "</td>")
		Response.Write("       <td bgcolor='" & strBgColor & "'>" & strOBSERVACAO & "</td>")
		Response.Write("     </tr>")
		objRS_LOCAL.MoveNext
		i = i + 1
	Loop
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("  <tr>")
	Response.Write("    <td colspan='2' align='center'>")
	Response.Write("      <table width='95%' border='0' cellspacing='0' cellpadding='0'>")
	Response.Write("        <tr>")
	Response.Write("          <td bgcolor='#7DACC5'>&nbsp;</td>")
	Response.Write("        </tr>")
	Response.Write("      </table>")
	Response.Write("    </td>")
	Response.Write("  </tr>")
	Response.Write("</table>")
	
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
  
  if(doc!='') {
    conteudo = eval('document.formdetail.var_' + doc + '_texto.value');
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}

function viewdocloja(doc) {
  var conteudo = '';
  
  if(doc!='') {
    conteudo = eval('document.formdetail.var_' + doc + '_loja.value');
  }
  window.open('viewhtml.asp?var_html='+conteudo,'WinProHTML','top=0,left=0,width=600,height=500,resizable=1,scrollbars=1');
}
//-->
</script>
</head>
<body bgcolor="#FFFFFF" background="../img/bg_dialog.gif" text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="0">
<tr> 
<td align="center" valign="middle"><img src="../img/spacer.gif" width="10" height="5"></td>
</tr>
<tr> 
<td align="center" valign="middle">
   <table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
      <table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr> 
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Detalhes de Evento</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
                <td align="center"> 
				  <table width="99%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <form name="formdetail" action="" method="post">
                      <input name="var_arm_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(objRS("ARM_TEXTO")&""))%>">
					  <input name="var_atestado_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(objRS("ATESTADO_TEXTO")&""))%>">
                      <tr> 
                        <td width="130" align="right"><strong>C&oacute;digo:&nbsp;</strong></td>
                        <td width="407"><%=getValue(objRS,"COD_EVENTO")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Nome:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"NOME")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Nome Completo:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"NOME_COMPLETO")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Data Início:&nbsp;</strong></td>
                        <td><%=PrepData(getValue(objRS,"DT_INICIO"),True,False)%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Data Término:&nbsp;</strong></td>
                        <td><%=PrepData(getValue(objRS,"DT_FIM"),True,False)%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Hora Início:&nbsp;</strong></td>
                        <td> 
                          <% If IsDate(getValue(objRS,"HORA_INICIO")) Then Response.Write(FormatDateTime(PrepData(objRS("HORA_INICIO"),True,True), 4)) %>                        </td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Hora Término:&nbsp;</strong></td>
                        <td> 
                          <% If IsDate(getValue(objRS,"HORA_FIM")) Then Response.Write(FormatDateTime(PrepData(objRS("HORA_FIM"),True,True), 4)) %>                        </td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Site:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"SITE")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>E-mail Oficial Evento:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"EMAIL")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Telefone:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"FONE")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>CNPJ:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"CNPJ")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>E-mail Remetente:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"EMAIL_SENDER")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Data Material:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"DT_MATERIAL")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Hora Material:&nbsp;</strong></td>
                        <td><%=PrepData(getValue(objRS,"HR_MATERIAL"),True,True)%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Pavilh&atilde;o:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"PAVILHAO")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Cidade:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"CIDADE")%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right"><strong>Estado:&nbsp;</strong></td>
                        <td><%=getValue(objRS,"ESTADO_EVENTO")%></td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Status Credencial:&nbsp;</strong></td>
                        <td> 
                          <%
								If Not IsNull(getValue(objRS,"STATUS_CRED")) Then
									strSQL = "SELECT STATUS FROM TBL_STATUS_CRED WHERE COD_STATUS_CRED = " & objRS("STATUS_CRED")
									Set objRSLocal = objConn.execute(strSQL)
									
									If Not objRSLocal.EOF Then
										Response.Write(objRSLocal("STATUS"))
									End If
									
									Set objRSLocal = Nothing
								End If
							%>                        </td>
                      </tr>
                      <tr> 
                        <td align="right"><strong>Categoria Padr&atilde;o:&nbsp;</strong></td>
                        <td> 
                          <%
								If Not IsNull(getValue(objRS,"STATUS_PRECO")) Then
									strSQL = "SELECT STATUS FROM TBL_STATUS_PRECO WHERE COD_STATUS_PRECO = " & objRS("STATUS_PRECO")
									Set objRSLocal = objConn.execute(strSQL)
									
									If Not objRSLocal.EOF Then
										Response.Write(objRSLocal("STATUS"))
									End If
									
									Set objRSLocal = Nothing
								End If
							%>                        </td>
                      </tr>
					  <tr> 
                        <td align="right"><strong>Categoria PSC:&nbsp;</strong></td>
                        <td> 
                          <%
								If Not IsNull(getValue(objRS,"STATUS_PRECO_VISITANTE")) Then
									strSQL = "SELECT STATUS FROM TBL_STATUS_PRECO WHERE COD_STATUS_PRECO = " & objRS("STATUS_PRECO_VISITANTE")
									Set objRSLocal = objConn.execute(strSQL)
									
									If Not objRSLocal.EOF Then
										Response.Write(objRSLocal("STATUS"))
									End If
									
									Set objRSLocal = Nothing
								End If
							%>                        </td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Moeda Evento:&nbsp;</strong></td>
                        <td>
						 <%
								If Not IsNull(getValue(objRS,"COD_MOEDA_EVENTO")) Then
									strSQL = "SELECT MOEDA FROM TBL_MOEDA ORDER BY COD_MOEDA = " & getValue(objRS,"COD_MOEDA_EVENTO")
									Set objRSLocal = objConn.execute(strSQL)
									
									If Not objRSLocal.EOF Then
										Response.Write(objRSLocal("MOEDA"))
									End If
									
									Set objRSLocal = Nothing
								End If
						 %>                         </td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Moeda Cobran&ccedil;a:&nbsp;</strong></td>
                        <td>
						<%       
								
						
								If Not IsNull(getValue(objRS,"COD_MOEDA_COBRANCA")) Then
									'	strSQL = "SELECT MOEDA FROM TBL_MOEDA ORDER BY COD_MOEDA = " & getValue(objRS,"COD_MOEDA_COBRANCA") 	
								   'Set objRSLocal = objConn.execute(strSQL)
								   'If Not objRSLocal.EOF Then
										Response.Write("")
									'End If									
									Set objRSLocal = Nothing
																
								End If
						 %>						</td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Moeda Refer&ecirc;ncia:&nbsp;</strong></td>
                        <td>
						<%
								If Not IsNull(getValue(objRS,"COD_MOEDA_REFERENCIA")) Then
								'strSQL = "SELECT MOEDA FROM TBL_MOEDA ORDER BY COD_MOEDA = 1" 
								'	Set objRSLocal = objConn.execute(strSQL)
									
								'	If Not objRSLocal.EOF Then
										Response.Write("")
								'	End If
															
									Set objRSLocal = Nothing
									
								End If
						 %>						</td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Evento Gratuito:&nbsp;</strong></td>
                        <td align="left"><%If getValue(objRS,"FREE") Then Response.Write("Sim") Else Response.Write("Não") %></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Inativo:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"SYS_INATIVO")%></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top"><strong>Recibo A4:&nbsp;</strong></td>
                        <td align="left">
						<%
							 strDOCUMENTO = ReturnCaracterEspecial(objRS("RECIBO_TEXTO")&"")
							 Response.Write(Server.HTMLEncode(Left(strDOCUMENTO,150)))
							 If len(strDOCUMENTO) > 150 Then Response.Write("...")
						%>
						<input name="var_recibo_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">						</td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('recibo');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Cabe&ccedil;alho:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  Response.Write( Server.HTMLEncode(Left(ReturnCaracterEspecial(objRS("CABECALHO")&""),150)) )
													  If len(getValue(objRS,"CABECALHO")) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_cabecalho_texto"  type="hidden" value="<%=Server.HTMLEncode(ReturnCaracterEspecial(objRS("CABECALHO")&""))%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('cabecalho');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Rodapé:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
						                            strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"RODAPE")&"")
					                                  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_rodape_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('rodape');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Instrucao Insc. Existente:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
						                            strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"INSTRUCAO_INSC_EXISTENTE")&"")
					                                  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_instrucao_insc_existente_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('instrucao_insc_existente');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Texto 
                          ARM:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
						                              strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ARM_TEXTO")&"")
					                                  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_arm_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('arm');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Texto 
                          ARM Intl:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
						                              strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ARM_TEXTO_INTL")&"")
					                                  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_arm_intl_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('arm_intl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>ARM Assunto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
						                              strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ARM_ASSUNTO")&"")
					                                  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_arm_assunto_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('arm_assunto');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>					  
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>ARM Assunto Intl:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
						                              strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,("ARM_ASSUNTO_INTL"))&"")
					                                  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_arm_assunto_intl_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('arm_assunto_intl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>						  
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Texto 
                          ACE:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ACE_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_ace_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('ace');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Texto 
                          ACE Intl:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,("ACE_TEXTO_INTL"))&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_ace_intl_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('ace_intl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>ACE Assunto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ACE_ASSUNTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_ace_assunto_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('ace_assunto');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>	
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>ACE Assunto Intl:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ACE_ASSUNTO_INTL")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_ace_assunto_intl_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('ace_assunto_intl');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>	
                      <tr>
                        <td align="right" valign="top"><strong>ACE Imprensa:&nbsp;</strong></td>
                        <td align="left">
						<%
							 strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ACEPRESS_TEXTO")&"")
							 Response.Write(Server.HTMLEncode(Left(strDOCUMENTO,150)))
							 If len(strDOCUMENTO) > 150 Then Response.Write("...")
						%>
						<input name="var_acepress_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">						</td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('acepress');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> <strong>visualizar</strong></a></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top"><strong>Texto Atestado:&nbsp;</strong></td>
                        <td align="left">
						<%
							 strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"ATESTADO_TEXTO")&"")
							 Response.Write(Server.HTMLEncode(Left(strDOCUMENTO,150)))
							 If len(strDOCUMENTO) > 150 Then Response.Write("...")
						%>
						<input name="var_atestado_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">						</td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('atestado');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> <strong>visualizar</strong></a></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top"><strong>Evento Ativo:&nbsp;</strong></td>
                        <td align="left"><% If getValue(objRS,"ATIVO") Then Response.Write("Sim") Else Response.Write("Não") %></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left">&nbsp;</td>
                      </tr>
                      <tr align="center" bgcolor="#CCCCCC">
                        <td colspan="2" valign="top"><b><font color="#FFFFFF">Loja</font></b></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left">&nbsp;</td>
                      </tr>
                      <tr>
                        <td align="right" valign="top"><strong>Cabe&ccedil;alho Loja:&nbsp;</strong></td>
                        <td align="left">
						 <%
							 strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"CABECALHO_LOJA")&"")
							 Response.Write(Server.HTMLEncode(Left(strDOCUMENTO,150)))
							 If len(strDOCUMENTO) > 150 Then Response.Write("...")
						 %>
						 <input name="var_cabecalho_loja"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">						</td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdocloja('cabecalho');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> <strong>visualizar</strong></a></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top"><strong>Rodap&eacute; Loja:&nbsp;</strong></td>
                        <td align="left">
						 <%
							 strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"RODAPE_LOJA")&"")
							 Response.Write(Server.HTMLEncode(Left(strDOCUMENTO,150)))
							 If len(strDOCUMENTO) > 150 Then Response.Write("...")
						 %>
						 <input name="var_rodape_loja"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">						</td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdocloja('rodape');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> <strong>visualizar</strong></a></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Usu&aacute;rio Loja:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"IDUSER_LOJA")%></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Categoria Aberta:&nbsp;</strong></td>
                        <td align="left"><% If getValue(objRS,"LOJA_STATUS_PRECO") Then Response.Write("Sim") Else Response.Write("Não")%></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Exibir dados pessoais:&nbsp;</strong></td>
                        <td align="left"><% If getValue(objRS,"LOJA_SHOW_DADOS") Then Response.Write("Sim") Else Response.Write("Não")%></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Exibir entidade na loja:&nbsp;</strong></td>
                        <td align="left"><% If getValue(objRS,"LOJA_SHOW_ENTIDADE") Then Response.Write("Sim") Else Response.Write("Não")%></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Exibir Financeiro na Loja:&nbsp;</strong></td>
                        <td align="left"><% If getValue(objRS,"LOJA_SHOW_FINANCEIRO") Then Response.Write("Sim") Else Response.Write("Não")%></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Exibir Faturamento na Loja:&nbsp;</strong></td>
                        <td align="left"><% If getValue(objRS,"LOJA_SHOW_FATURAMENTO") Then Response.Write("Sim") Else Response.Write("Não")%></td>
                      </tr>					  				  
                      <tr>
                        <td align="right"><strong>Loja PAPER ativa:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"SUBPAPER_ATIVA")%></td>
                      </tr>					  
                      <tr>
                        <td align="right"><strong>Modelo Loja PJ:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MODELO_LOJAPJ")%></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Loja Ativa:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"LOJA_ATIVA")%></td>
                      </tr>
                      <tr>
                        <td align="right"><strong>Loja 
                          Ativa PJ:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"LOJAPJ_ATIVA")%></td>
                      </tr>
                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left">&nbsp;</td>
                      </tr>
                      <tr align="center">
                        <td colspan="2" valign="top" bgcolor="#CCCCCC"><b><font color="#FFFFFF">Correspond&ecirc;ncias</font></b></td>
                      </tr>
                      <tr> 
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          1 - Título:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MOD1_TITLE")&""%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          1 - Texto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"MOD1_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_mod1_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('mod1');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>
					  
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          2 - Título:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MOD2_TITLE")&""%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          2 - Texto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"MOD2_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_mod2_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('mod2');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          3 - Título:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MOD3_TITLE")&""%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          3 - Texto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"MOD3_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_mod3_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('mod3');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          4 - Título:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MOD4_TITLE")&""%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          4 - Texto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"MOD4_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_mod4_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('mod4');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          5 - Título:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MOD5_TITLE")&""%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          5 - Texto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"MOD5_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_mod5_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('mod5');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          6 - Título:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MOD6_TITLE")&""%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          6 - Texto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"MOD6_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_mod6_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('mod6');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>

                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          7 - Título:&nbsp;</strong></td>
                        <td align="left"><%=getValue(objRS,"MOD7_TITLE")&""%></td>
                      </tr>
                      <tr> 
                        <td width="130" align="right" valign="top"><strong>Mod 
                          7 - Texto:&nbsp;</strong></td>
                        <td align="left"> 
                          <% 
					                                  strDOCUMENTO = ReturnCaracterEspecial(getValue(objRS,"MOD7_TEXTO")&"")
													  Response.Write( Server.HTMLEncode(Left(strDOCUMENTO,150)) )
													  If len(strDOCUMENTO) > 150 Then Response.Write("...")
													%>                        </td>
                      </tr>
                      <input name="var_mod7_texto"  type="hidden" value="<%=Server.HTMLEncode(strDOCUMENTO)%>">
                      <tr> 
                        <td width="130" align="right" valign="top">&nbsp;</td>
                        <td align="left" bgcolor="#f2f2f2"><a href="javascript:viewdoc('mod7');" class="arial11"><img src="../img/BT_ZOOM.GIF" width="11" height="11" border="0" align="absmiddle"> 
                          <strong>visualizar</strong></a></td>
                      </tr>

                      <tr>
                        <td align="right" valign="top">&nbsp;</td>
                        <td align="left">&nbsp;</td>
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
      <table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
          <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strID_AUTO%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
        <br>

      <table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
      <table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
          <td>
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Formas de Pagamento</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="90%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <tr> 
                        <td colspan="2" align="center"><% MontaTabelaFormaPagamento %></td>
                    </tr>
                  </table></td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table>
          </td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
      <table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strID_AUTO%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

        <br>

      <table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
      <table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr> 
                  
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Imagens</td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center"> <table width="90%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                    <tr> 
                        <td colspan="2" align="center"><% MontaListaImagem %></td>
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
      <table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strID_AUTO%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>

      <br>
      <table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
          <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
        </tr>
      </table>
      <table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr>
          <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr>
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Status Credencial </td>
              </tr>
              <tr>
                <td height="16" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td align="center">
                    <table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr>
                        <td colspan="2" align="center"><% MontaListaStatusCred %></td>
                      </tr>
                    </table>
				</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
          </table></td>
          <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
        </tr>
      </table>
      <table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
          <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
          <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strID_AUTO%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
          <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
        </tr>
      </table>
      <br>
      <table width="550" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
        <tr>
          <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
          <td height="4" background="../img/inbox_top_blue.gif"><img src="../img/spacer.gif" width="10" height="4"></td>
          <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
        </tr>
      </table>
      <table width="550" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
        <tr>
          <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
          <td><table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
              <tr>
                <td bgcolor="#7DACC5">&nbsp;&nbsp;Lista de Status Pre&ccedil;o</td>
              </tr>
              <tr>
                <td height="16" align="center">&nbsp;</td>
              </tr>
              <tr>
                <td align="center">
                    <table width="95%" border="0" cellpadding="0" cellspacing="0" class="arial11">
                      <tr>
                        <td colspan="2" align="center"><% MontaListaStatusPreco %></td>
                      </tr>
                    </table>
				</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
          </table></td>
          <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
        </tr>
      </table>
      <table width="550" align="center" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
          <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
          <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
          <td align="right" background="../img/inbox_bottom_big3.gif"><a href="update.asp?var_chavereg=<%=strID_AUTO%>"><img src="../img/bt_edit.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
          <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
        </tr>
      </table>
</tr></td>
<tr> 
<td align="center" valign="middle"><img src="../img/spacer.gif" width="10" height="5"></td>
</tr>
</table>
</body>
</html>
<%
	FechaRecordSet ObjRS
	FechaDBConn ObjConn
%>