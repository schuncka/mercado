<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"--> 
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|DEL|", BuscaDireitosFromDB("shopagenda",Session("METRO_USER_ID_USER")), true %>
<%
 Dim objConn, objRS, strSQL, objRSCombo, objLang	 
 Dim strMENSAGEM,strMENSAGEM2,strMENSAGEM1,strMENSAGEM3
 Dim strNOME, strTpICO, strTIPO, strTITULO, strMSG, strMSGSYS, strICON, strJScript
 Dim strCOD_PROD, strCOD_EVENTO, strCOD_INSCR, strCOD_EMPRESA, strNOME_EVENTO, strCOD_STATUS_PRECO, strDEFAULT_LOCATION

 strCOD_EVENTO		 = getParam("var_cod_evento") 
 strCOD_EMPRESA		 = getParam("var_cod_empresa")		
 strCOD_INSCR  		 = getParam("var_cod_inscricao") 
 strNOME_EVENTO		 = getParam("var_nome_evento") 
 strCOD_PROD		 = getParam ("var_cod_prod")
 strCOD_STATUS_PRECO = getParam("var_cod_status_preco")
 If strCOD_STATUS_PRECO = "" Then
	strCOD_STATUS_PRECO = "0" 
 End If

 strDEFAULT_LOCATION = getParam("DEFAULT_LOCATION")

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------

 '=======================================================================
 'variaveis de envio de parametro para MSGDLG(dialog de mensagem)
 '=======================================================================
 strNOME  	= "" 																						'- nome da janela;
 strTIPO  	= "INFO"																					'- tipo de MSG , ex: INFO,WARN,ERR;
 strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_delok",0) '"O item foi removido com sucesso!"	'- titulo da mensagem;
 strMSG		= objLang.SearchIndex("mini_shopagenda_exec_delok2",0) 										'- text completo da mensagem;
 strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | E: " & strCOD_EMPRESA & ")"			'- log de execução quando necessario apresentar dos alterado
 'athDebug str_MSGSYS,true
 'strICON    	= "icon-info fg-blue on-right on-left"													'- icone usado no tipo de mensagem por padrão serão três possiveis (icon-info&icon-warnning,icon-minus), mas a mesmas poderai receber outros icones para novas janelas de info		
 																										' ,juntamente com a cor e se na classe houver outros atributos de estilo manda junto na string

 'strJScript	= "window.opener.location.reload(true); window.close();"
 'strJScript	= "window.history.go(-3);"
 'strJScript	= "parent.formgeral.target='fr_principal';parent.formgeral.action = parent.formgeral.var_page.value; parent.formgeral.submit();"
 'strJScript	= "$(parent.document.getElementById('btAgenda')).trigger('click');"
  strJScript	= "parent.document.getElementById('formgeral').submit();"
 '========================================================================


 AbreDBConn objConn, CFG_DB


 '----------------------------------------------------------------------------------------------------------------
 '----------------------------------------------------------------------------------------------------------------
 ' INI: Principal	
 '----------------------------------------------------------------------------------------------------------------
 strMENSAGEM  = ""

 strMENSAGEM1 = strMENSAGEM1 & replace(objLang.SearchIndex("mini_shopagenda_exec_delmsg1",0),"<TAG_COD_INSCR>",strCOD_INSCR)
 strMENSAGEM2 = strMENSAGEM2 & replace(objLang.SearchIndex("mini_shopagenda_exec_delmsg2",0),"<TAG_COD_PROD>",strCOD_PROD)
 strMENSAGEM3 = strMENSAGEM3 & objLang.SearchIndex("mini_shopagenda_exec_delmsg3",0)
 if strCOD_INSCR = "" or strCOD_PROD ="" then	
	strMENSAGEM = strMENSAGEM3 
 else
	strMENSAGEM = strMENSAGEM1&"<br>"&strMENSAGEM2
 end if	


 strSQL = "         SELECT COD_PROD, QTDE "
 strSQL = strSQL & "  FROM tbl_Inscricao_Produto "
 strSQL = strSQL & " WHERE COD_INSCRICAO = '" & strCOD_INSCR &"'" 
 strSQL = strSQL & "   AND COD_PROD      = '" & strCOD_PROD  &"'" 
 'response.Write("DEBUG: strSQL ["&strSQL&"]<br><br>") 
 Set objRS = objConn.Execute(strSQL)
 
 If (not objRS.EOF) and (not objRS.BOF) Then
	strSQL = "SELECT PC.DESCONTO_PERC, PC.DESCONTO_VLR, IP.COD_PROD, IP.QTDE "
	strSQL = strSQL & "  FROM tbl_Produtos_Combo PC, tbl_Inscricao_Produto IP "
	strSQL = strSQL & " WHERE PC.COD_PROD = IP.COD_PROD "
	strSQL = strSQL & "   AND PC.COD_PROD_RELACAO = " & strCOD_PROD 
	strSQL = strSQL & "   AND PC.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO 
	strSQL = strSQL & "   AND IP.COD_INSCRICAO 	  = " & strCOD_INSCR 
	strSQL = strSQL & "   AND IP.SYS_DATACA IS NULL " '????????????????????
    set objRSCombo = objConn.Execute(strSQL)
	'response.Write("DEBUG: Principal1 - strSQL ["&strSQL&"]<br><br>")
    Do While not objRSCombo.EOF
	 'response.Write("DEBUG: Principal2 cod_prod | qtde ["&objRSCombo("COD_PROD")&"]["&objRSCombo("QTDE")&"]<br><br>")
	  RemoveProduto objRSCombo("COD_PROD"), objRSCombo("QTDE")
	  objRSCombo.MoveNext
	Loop
	FechaRecordSet objRSCombo

	'response.Write("DEBUG: Principal3 cod_prod | qtde ["&objRS("COD_PROD")&"]["&objRS("QTDE")&"]<br><br>")
    RemoveProduto objRS("COD_PROD"), objRS("QTDE")
 end if 
 
 '----------------------------------------------------------------------------------------------------------------
 ' FIM: Principal	
 '----------------------------------------------------------------------------------------------------------------
 '----------------------------------------------------------------------------------------------------------------



 '----------------------------------------------------------------------------------------------------------------
 Sub RemoveProduto(prCOD_PROD, prQTDE)
	Dim objRS_Local,strSQL2,strSQL3
	'strMENSAGEM = "Seu produto será deletado deseja realmente remove-lo!" 'string de mensagem esta vazia
	strSQL = "SELECT PC.DESCONTO_PERC, PC.DESCONTO_VLR, IP.COD_PROD, IP.QTDE "&_
			 "  FROM tbl_Produtos_Combo PC, tbl_Inscricao_Produto IP"&_
			 " WHERE PC.COD_PROD_RELACAO = IP.COD_PROD" &_
			 "   AND PC.COD_PROD         = " & prCOD_PROD &_
			 "   AND PC.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO &_
			 "   AND IP.COD_INSCRICAO    = " & strCOD_INSCR
	'response.Write("DEBUG: RemoveProduto1 strSQL ["&strSQL&"]<br><br>")
	Set objRS_Local = objConn.Execute(strSQL)
	
	Do While not objRS_Local.EOF
		strSQL2 = " DELETE FROM tbl_Inscricao_Produto WHERE COD_INSCRICAO = " & strCOD_INSCR & " AND COD_PROD = " & objRS_Local("COD_PROD") 
		'response.Write("DEBUG: RemoveProduto2 strSQL ["&strSQL&"]<br><br>")
		objConn.Execute(strSQL)

		strSQL2 = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO - " & objRS_Local("QTDE") & " WHERE COD_PROD = " & objRS_Local("COD_PROD")
		'response.Write("DEBUG: RemoveProduto3 strSQL ["&strSQL&"]<br><br>")
		objConn.Execute(strSQL)
		objRS_Local.MoveNext
	Loop
	strSQL = " DELETE FROM tbl_Inscricao_Produto " &_
			 "  WHERE COD_INSCRICAO =" & strCOD_INSCR & _
			 "    AND COD_PROD = " & prCOD_PROD 
	'response.Write("DEBUG: RemoveProduto4 strSQL ["&strSQL&"]<br><br>")
	objConn.Execute(strSQL)
	
	strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO - " & prQTDE & " WHERE COD_PROD = " & prCOD_PROD
	'response.Write("DEBUG: RemoveProduto5 strSQL ["&strSQL&"]<br><br>")
	objConn.Execute(strSQL)
	
	FechaRecordSet objRS_Local
 End Sub
 '----------------------------------------------------------------------------------------------------------------


FechaRecordSet objRS
 
%>
<html>
<title>pVISTA.PAX</title>
<head>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" onLoad="document.formdelproduto.submit()">
<!-- 'Este form envia para MSGDLG(dialog de mensagem) que recebe os parametros abaixo para preencher a página, 
	  Sendo assim o value pode ser preenchido tando em um variavel quando direto no formulario //-->
<form name="formdelproduto" id="formdelproduto" action="../../_database/athMsgDlg.asp" method="post" target="_self">
    <input type="hidden" name="var_nome"			 	value="">
    <input type="hidden" name="var_tipo"			 	value="<%=Ucase("INFO")%>">                                
    <input type="hidden" name="var_titulo"			 	value="<%=strTITULO%>">                                
    <input type="hidden" name="var_msg"			 		value="<%=strMSG%>">                                
    <input type="hidden" name="var_msgsys"			 	value="<%=strMSGSYS%>">                                
    <input type="hidden" name="var_icon"			 	value="<%=strICON%>">                                
    <input type="hidden" name="var_parent"			 	value="<%=strJScript%>"> 
	<input type="hidden" name="DEFAULT_LOCATION" 		value="<%=strDEFAULT_LOCATION%>">    
</form>              
</fom>          
</div><!--//-->									
</body>
</html>
<%
 FechaDBConn objConn 	
%>
