<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"--> 
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_PaxShopAgenda",Session("METRO_USER_ID_USER")), true %>
<% 
 Dim objConn,objRS,strSQL,objRSCombo, objLang		
 Dim strDT_CHEGADAFICHA, strSYS_DATAAT, strPROD_TITULO
 Dim strQTDE, Qtde, Valor, strRETORNO, strFAIXA_PRECO_QTDE
 Dim strEV_IDUSER_LOJA
 Dim ProdTimeStamp_INI, ProdTimeStamp_FIM, auxColidiu
 Dim strCOD_PROD, strCOD_EVENTO, strCOD_INSCR, strCOD_EMPRESA, strNOME_EVENTO, strCOD_STATUS_PRECO, strDEFAULT_LOCATION

 Dim strTpMsg, strMSg, strMSgSys, strICON, strJScript, strNOME, strTITULO

 strCOD_EVENTO		 = getParam("var_cod_evento") 
 strCOD_EMPRESA		 = getParam("var_cod_empresa")		
 strCOD_INSCR  		 = getParam("var_cod_inscricao") 
 strNOME_EVENTO		 = getParam("var_nome_evento") 
 strCOD_PROD		 = getParam("var_cod_prod")
 strCOD_STATUS_PRECO = getParam("var_cod_status_preco")
 If strCOD_STATUS_PRECO = "" Then
	strCOD_STATUS_PRECO = "0" 
 End If
 strDEFAULT_LOCATION = getParam("DEFAULT_LOCATION")

 strRETORNO			 = "" 
 strSYS_DATAAT		 = now()
 strDT_CHEGADAFICHA  = now()
 strQTDE			 = 1
 strFAIXA_PRECO_QTDE = 1
 '===========================================================================
 strEV_IDUSER_LOJA   = strCOD_EMPRESA	'????????????????
 strPROD_TITULO		 = strCOD_PROD		'????????????????
 '===========================================================================

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------

 AbreDBConn objConn, CFG_DB 

 '----------------------------------------------------------------------------------------------------------------- 
 '----------------------------------------------------------------------------------------------------------------- 
 ' INI: Principal	
 '----------------------------------------------------------------------------------------------------------------- 
 'Default para MSGDLG no final do processo
 strNOME  	= "" 													'- nome da janela;
 strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_addok",0)	'"O item foi adicionado com sucesso!"	'- titulo da mensagem;
 strTpMsg	= "INFO" 												'- tipo de MSG , ex: INFO,WARN,ERR;
 strMSg		= objLang.SearchIndex("mini_shopagenda_exec_addok2",0)  ' "Esta atividade/produto foi adicionado à sua AGENDA."
 strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | E: " & strCOD_EMPRESA & ")"
 'athDebug str_MSGSYS,true
 'strICON    	= "icon-info fg-blue on-right on-left"				'- icone usado no tipo de mensagem por padrão serão três possiveis (icon-info&icon-warnning,icon-minus), mas a mesmas poderai receber outros icones para novas janelas de info																													
 																	'  , juntamente com a cor e se na classe houver outros atributos de estilo manda junto na string

 'strJScript	= "window.opener.location.reload(true); window.close();"
 'strJScript	= "window.history.go(-3);"
 'strJScript	= "parent.formgeral.target='fr_principal';parent.formgeral.action = parent.formgeral.var_page.value; parent.formgeral.submit();"
  strJScript	= "parent.document.getElementById('formgeral').submit();"
 '========================================================================


 'INI: busca a datahora (em formato timestamp) do produto/ativaidade que 
 'esta sendo adicionado para comparar, na inserão, se há colisão de horários
 strSQL = "         SELECT UNIX_TIMESTAMP (DT_OCORRENCIA) as full_ini "
 strSQL = strSQL & "      ,UNIX_TIMESTAMP (dt_termino) as full_fim "
 strSQL = strSQL & "  FROM tbl_Produtos "
 strSQL = strSQL & " WHERE COD_PROD = '" & strCOD_PROD  & "'"
 Set objRS = objConn.Execute(strSQL)
 If (not objRS.EOF) and (not objRS.BOF) Then
 	ProdTimeStamp_INI = objRS("full_ini")
 	ProdTimeStamp_FIM = objRS("full_fim")
 End if
 FechaRecordSet objRS
 'FIM: busca a datahora (em formato timestamp)...


 strSQL = "         SELECT COD_PROD, QTDE FROM tbl_Inscricao_Produto "
 strSQL = strSQL & " WHERE COD_INSCRICAO = '" & strCOD_INSCR &"'" 
 strSQL = strSQL & "   AND COD_PROD      = '" & strCOD_PROD &"'"
 'response.Write("DEBUG: strSQL ["&strSQL&"]<br><br>")
 Set objRS = objConn.Execute(strSQL)
 If (not objRS.EOF) and (not objRS.BOF) Then
    'Chama a funcao RemoveProduto antes para garantir que se ja tiver colocado alguem antes entao remove para conceder o desconto do "combo"
	strSQL = "SELECT PC.DESCONTO_PERC, PC.DESCONTO_VLR, IP.COD_PROD, IP.QTDE "
	strSQL = strSQL & "  FROM tbl_Produtos_Combo PC, tbl_Inscricao_Produto IP "
	strSQL = strSQL & " WHERE PC.COD_PROD = IP.COD_PROD "
	strSQL = strSQL & "   AND PC.COD_PROD_RELACAO = " & strCOD_PROD 
	strSQL = strSQL & "   AND PC.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO 
	strSQL = strSQL & "   AND IP.COD_INSCRICAO 	  = " & strCOD_INSCR 
	strSQL = strSQL & "   AND IP.SYS_DATACA IS NULL "
    Set objRSCombo = objConn.Execute(strSQL)
	'response.Write("DEBUG: Principal1 - strSQL ["&strSQL&"]<br><br>")

	if objRSCombo.eof then
		strTpMsg	= "WARNING"
 		strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_addErr",0)	'"Não foi possivel adicionar o item!"	'- titulo da mensagem;
 		strMSg		= replace(objLang.SearchIndex("mini_shopagenda_exec_addE1msg",0),"<TAG_COD_PROD>",strCOD_PROD)  '..pois este já existe na sua agenda ou não foi encontrado o StatusPreço(do item) ou StatusPreçoVisitante(do evento)."
		strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | SPrc: " & strCOD_STATUS_PRECO & ")"
	end if

    Do While not objRSCombo.EOF
      'response.Write("DEBUG: Principal2 cod_prod | qtde ["&objRSCombo("COD_PROD")&"]["&objRSCombo("QTDE")&"]<br><br>")
	  RemoveProduto objRSCombo("COD_PROD"), objRSCombo("QTDE")
	  objRSCombo.MoveNext
	Loop
	FechaRecordSet objRSCombo
	'response.Write("DEBUG: Principal3 cod_prod | qtde ["&objRS("COD_PROD")&"]["&objRS("QTDE")&"]<br><br>")
    RemoveProduto objRS("COD_PROD"), objRS("QTDE")
 Else
	If VerificaRestricao(strCOD_PROD) Then
		'response.Write("DEBUG: Principal4 cod_prod | qtde ["&strCOD_PROD&"]["&strQTDE&"]<br><br>")
		InsereProduto strCOD_PROD, strQTDE
	End If
 End If
 FechaRecordSet objRS

 '----------------------------------------------------------------------------------------------------------------- 
 ' FIM: Principal	
 '----------------------------------------------------------------------------------------------------------------- 
 '----------------------------------------------------------------------------------------------------------------- 





 ' =======================================================================
 Function FormataDataSQL(prDATA, prFLAG_DATA)
	FormataDataSQL = Year(prDATA) & "-" & Month(prDATA) & "-" & Day(prDATA)
	If prFLAG_DATA Then
		FormataDataSQL = FormataDataSQL & " " & Hour(prDATA) & ":" & Minute(prDATA) & ":" & Second(prDATA)
	End If
 End Function
 ' =======================================================================

 Function VerificaRestricao(prCOD_PROD)
	 Dim objRSLocal, strCOD_PROD_RELACAO
	 Dim strInNoIn, strLjTpRestricao
	
	 VerificaRestricao = True
	 strCOD_PROD_RELACAO = "0"
	 
	 strSQL = " SELECT tbl_Produtos_Restricao.COD_PROD, tbl_Produtos_Restricao.COD_PROD_RELACAO, tbl_Produtos_Restricao.RESTRICAO, tbl_Produtos.TITULO " & _
			  "   FROM tbl_Produtos_Restricao, tbl_Produtos " & _
			  "  WHERE tbl_Produtos_Restricao.COD_PROD_RELACAO = tbl_Produtos.COD_PROD" & _
			  "    AND tbl_Produtos_Restricao.COD_PROD = " & prCOD_PROD & _
			  "    AND tbl_Produtos_Restricao.COD_PROD_RELACAO IN ( SELECT COD_PROD FROM tbl_Inscricao_Produto WHERE COD_INSCRICAO = " & strCOD_INSCR & ")"& _
			  "    AND (tbl_Produtos_Restricao.RESTRICAO = 1 OR tbl_Produtos_Restricao.RESTRICAO = -1)" & _
			  "  ORDER BY tbl_Produtos_Restricao.COD_PROD"
	 set objRS = objConn.Execute(strSQL)
	 If not objRS.EOF Then
	   ' strRETORNO = strRETORNO & "Produtos que NÃO podem ser comprados em conjunto com o selecionado:\n"
	   strRETORNO = strRETORNO & Request("var_restricao_separada") & "\n"
	   Do While not objRS.EOF
		 strRETORNO = strRETORNO & "(" & objRS("COD_PROD_RELACAO") & ") " & objRS("TITULO") & "\n"
		 If objRS("RESTRICAO") = -1 Then
		   strSQL = "DELETE FROM tbl_Inscricao_Produto WHERE SYS_DATACA IS NULL AND COD_INSCRICAO = " & strCOD_INSCR & " AND COD_PROD = " & objRS("COD_PROD_RELACAO")
		   objConn.Execute(strSQL)
		 End If
		 strCOD_PROD_RELACAO = strCOD_PROD_RELACAO & "," & objRS("COD_PROD_RELACAO")
		 objRS.MoveNext
	   Loop
	
	   'Teste para ver se tem algum produto já comprado anteriormente que tenha restrição
	   strSQL = "SELECT COD_PROD FROM tbl_Inscricao_Produto WHERE SYS_DATACA IS NOT NULL AND COD_INSCRICAO = " & strCOD_INSCR & " AND COD_PROD IN (" & strCOD_PROD_RELACAO & ")"
	   Set objRSLocal = objConn.Execute(strSQL)
	   VerificaRestricao = objRSLocal.EOF
	   FechaRecordSet objRSLocal
	 End If

	 'Busca o tipo de restrição para o produto atual em relação aos outros (AND ou OR - tem de ter comprado todos eles "and" ou basta algum deles "or"
	 strInNoIn		  = "NOT IN"
	 strLjTpRestricao = "AND"
	 strSQL 		  = "SELECT TBL_PRODUTOS.LOJA_TIPO_RESTRICAO FROM TBL_PRODUTOS WHERE TBL_PRODUTOS.COD_PROD = " & prCOD_PROD
	 set objRS = objConn.Execute(strSQL)
	 If not objRS.EOF Then
		strLjTpRestricao = objRS("LOJA_TIPO_RESTRICAO")
	 End if
	 if ucase(strLjTpRestricao) = "OR" then
		 strInNoIn = "IN"
	 End if
	 
	 'Novo SQL para tratar compra de um produto vinculado a outro produto OU o equivalente deste
	 strSQL = "  SELECT tbl_Produtos_Restricao.COD_PROD, tbl_Produtos_Restricao.COD_PROD_RELACAO, tbl_Produtos_Restricao.RESTRICAO, tbl_Produtos.TITULO, tbl_Produtos.OCUPACAO, tbl_Produtos.CAPACIDADE " & _
			  "    FROM tbl_Produtos_Restricao, tbl_Produtos " & _
			  "   WHERE tbl_Produtos_Restricao.COD_PROD_RELACAO = tbl_Produtos.COD_PROD " & _
			  "     AND tbl_Produtos_Restricao.COD_PROD = " & prCOD_PROD & _
			  "    AND  ( " & _
			  "           (tbl_Produtos_Restricao.COD_PROD_RELACAO " & strInNoIn & " ( SELECT COD_PROD FROM tbl_Inscricao_Produto WHERE COD_INSCRICAO = " & strCOD_INSCR & ") ) " & _
			  "           AND " & _
			  "           (if(tbl_Produtos_Restricao.COD_PROD_EQUIV IS NULL,TRUE,FALSE) OR tbl_Produtos_Restricao.COD_PROD_EQUIV " & strInNoIn & " ( SELECT COD_PROD FROM tbl_Inscricao_Produto WHERE COD_INSCRICAO = " & strCOD_INSCR & ") ) " & _
			  "         ) " & _
			  "     AND tbl_Produtos_Restricao.RESTRICAO = 0 " & _
			  "   ORDER BY tbl_Produtos_Restricao.COD_PROD"
			  
	 set objRS = objConn.Execute(strSQL)

	 ' INI: TESTE MODO AND ou OR para restrições de compra obrigatória ----------------------------------
	 if ucase(strLjTpRestricao) = "AND" then
		 ' MODO AND
		 If not objRS.EOF Then
			Do While not objRS.EOF
				strRETORNO = strRETORNO & "[" & objRS("COD_PROD_RELACAO") & " - " & objRS("TITULO") & "] "
				VerificaRestricao = False
				objRS.MoveNext
			Loop
		 End If
		 If not VerificaRestricao then 
			strTpMsg	= "WARNING"
	 		strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_addErr",0)   '"Não foi possivel adicionar o item!"	'- titulo da mensagem;
			strMSg		= objLang.SearchIndex("mini_shopagenda_exec_addE2msg",0) & strRETORNO & "." ''É preciso efetuar a compra do(s) produto(s):'...
			strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | E: " & strCOD_EMPRESA & ")"
		 End if
	 Else
		 ' MODO OR
		 VerificaRestricao = False
		 If not objRS.EOF Then
			Do While not objRS.EOF
				VerificaRestricao = True
				objRS.MoveNext
			Loop
		 End If
		 If not VerificaRestricao then 
			strTpMsg	= "WARNING"
	 		strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_addErr",0)  '"Não foi possivel adicionar o item!"	'- titulo da mensagem;
			strMSg		= objLang.SearchIndex("mini_shopagenda_exec_addE2msg",0) & ucase(objLang.SearchIndex("inscricao",0)) & "."
			strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | E: " & strCOD_EMPRESA & ")"
		 End if
	 End If
	 ' FIM: TESTE MODO AND ou OR para restrições de compra obrigatória ----------------------------------

	 'Novo SQL para verificar se há vaga
	 strSQL = "  SELECT tbl_Produtos.OCUPACAO, tbl_Produtos.CAPACIDADE " & _
			  "    FROM tbl_Produtos " & _
			  "   WHERE tbl_Produtos.COD_PROD = " & prCOD_PROD
			  
	 set objRS = objConn.Execute(strSQL)


	 ' INI: TESTE SE TEM VAGA NO MOMENTO ----------------------------------------------------------------
	 If not objRS.EOF Then
		 if ( CInt(objRS("OCUPACAO") ) >= CInt( objRS("CAPACIDADE") ) ) then
				strTpMsg	= "WARNING"
		 		strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_addErr",0) '"Não foi possivel adicionar o item!"	'- titulo da mensagem;
				strMSg		= objLang.SearchIndex("mini_shopagenda_exec_addE3msg",0) '"O item encontra-se esgotado."
				strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | E: " & strCOD_EMPRESA  & " | O: " & objRS("OCUPACAO")  & " | C: " & objRS("CAPACIDADE") & ")"
				VerificaRestricao = False
		 end if	
	 End if
	 ' FIM: TESTE SE TEM VAGA NO MOMENTO ----------------------------------------------------------------	 
 End Function



 ' =======================================================================
 Sub InsereProduto(prCOD_PROD, prQTDE)
	Dim strDESCONTO_PROD, strVLR_FIXO, strFLAG_SENHA_STATUS_PRECO
	Dim objRS_lc, objRSCombo_lc
	
	strFLAG_SENHA_STATUS_PRECO = False
	strSQL = "SELECT COD_STATUS_PRECO, SENHA FROM tbl_STATUS_PRECO WHERE COD_STATUS_PRECO = " & strCOD_STATUS_PRECO
	'response.Write("DEBUG: InsereProduto1 strSQL ["&strSQL&"]<br><br>")
	Set objRS_lc = objConn.Execute(strSQL)
	If not objRS_lc.EOF Then
		If objRS_lc("SENHA")&"" <> "" Then
			 strFLAG_SENHA_STATUS_PRECO = True
		End If
	End If
	FechaRecordSet objRS_lc
	'response.Write("DEBUG: InsereProduto2 strFLAG_SENHA_STATUS_PRECO ["&strFLAG_SENHA_STATUS_PRECO&"]<br><br>")
	
	
	' ----------------------------------------------------------
	' INI: Colisão de horário
	' ----------------------------------------------------------
	strSQL = "  	    SELECT  p.id_auto, p.cod_prod, ip.cod_Inscricao, p.`local` as sala, p.titulo "
	strSQL = strSQL & " 	   ,UNIX_TIMESTAMP (p.DT_OCORRENCIA) as full_ini "
	strSQL = strSQL & "  	   ,UNIX_TIMESTAMP (p.dt_termino) as full_ini "
	strSQL = strSQL & "  FROM tbl_Produtos as p "
	strSQL = strSQL & " INNER JOIN tbl_Inscricao_Produto IP on p.cod_prod = ip.cod_prod "
	strSQL = strSQL & " WHERE p.COD_EVENTO = " & strCOD_EVENTO 
	strSQL = strSQL & "   AND (IP.COD_INSCRICAO = '" & strCOD_INSCR & "' or IP.COD_INSCRICAO is null) "
	strSQL = strSQL & "   AND ( "

'	strSQL = strSQL & "	 	 (" & ProdTimeStamp_INI & " >= UNIX_TIMESTAMP (p.DT_OCORRENCIA)) and (" & ProdTimeStamp_INI & " <= UNIX_TIMESTAMP (p.dt_termino) ) "
'	strSQL = strSQL & "		  OR "
'	strSQL = strSQL & "		 (" & ProdTimeStamp_FIM & " >= UNIX_TIMESTAMP (p.DT_OCORRENCIA)) and (" & ProdTimeStamp_FIM & " <= UNIX_TIMESTAMP (p.dt_termino) ) "
	'21/09/2016 - caso especial tratado ficou sendo: SE o horário INICIAL de um evento cai no mesmo horário FINAL de outro, ele não considera mais colisão. 
	strSQL = strSQL & "	 	 (" & ProdTimeStamp_INI & " >= UNIX_TIMESTAMP (p.DT_OCORRENCIA)) and (" & ProdTimeStamp_INI & " < UNIX_TIMESTAMP (p.dt_termino) ) "
	strSQL = strSQL & "		  OR "
	strSQL = strSQL & "		 (" & ProdTimeStamp_FIM & " > UNIX_TIMESTAMP (p.DT_OCORRENCIA)) and (" & ProdTimeStamp_FIM & " <= UNIX_TIMESTAMP (p.dt_termino) ) "

	strSQL = strSQL & "	   )"
	strSQL = strSQL & "   AND P.COD_PROD <> '" & prCOD_PROD & "' "
	strSQL = strSQL & " ORDER BY p.DT_OCORRENCIA "
	'response.Write("DEBUG: InsereProduto2a.Colisão_Horario SQL["&strSQL&"]<br><br>")
	'response.End
	auxColidiu = ""
	Set objRS_lc = objConn.Execute(strSQL)
	While not objRS_lc.EOF
'		response.Write("DEBUG: InsereProduto2b.Colisão_Horario cod_prod | título ["&objRS_lc("COD_PROD")&"]["&objRS_lc("titulo")&"]<br><br>")
'		auxColidiu = auxColidiu & "[" & objRS_lc("COD_PROD") & "]"
		'objRS_lc("COD_PROD") & "]"objRS_lc("TITULO")
		auxColidiu = auxColidiu & objRS_lc("TITULO") 'Server.HTMLEncode(objRS_lc("TITULO")) 
		objRS_lc.MoveNext
	wend
	FechaRecordSet objRS_lc
	'response.Write("DEBUG: InsereProduto2c.Colisão_Horario  [" & "]<br><br>")
	' FIM: Colisão de horário  ---------------------------------

	 
	If (auxColidiu = "") then
			 ' ----------------------------------------------------------
			 ' Foi trocado em 11/08/2008 a DT_CHEGADAFICHA pelo SYS_DATAAT
			 ' ----------------------------------------------------------
			 strSQL = " SELECT tbl_PrcLista.COD_PROD, tbl_PrcLista.PRC_LISTA AS VALOR, tbl_Senha_Promo_Prod.DESCONTO, tbl_Senha_Promo_Prod.VLR_FIXO" & vbnewline
			 strSQL = strSQL & " FROM tbl_PrcLista LEFT OUTER JOIN tbl_Senha_Promo_Prod "
			 'strSQL = strSQL & "                     ON (tbl_PrcLista.COD_PROD = tbl_Senha_Promo_Prod.COD_PROD AND tbl_Senha_Promo_Prod.CODIGO = '" & strWEB_DESCONTO_PROMO & "')" & vbnewline
			 strSQL = strSQL & "                     ON (tbl_PrcLista.COD_PROD = tbl_Senha_Promo_Prod.COD_PROD)" & vbnewline
			 strSQL = strSQL & " WHERE '" & FormataDataSQL(strSYS_DATAAT, False) & "' BETWEEN tbl_PrcLista.DT_VIGENCIA_INIC AND tbl_PrcLista.DT_VIGENCIA_FIM" &vbnewline
			 'strSQL = strSQL & "   AND tbl_PrcLista.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO & vbnewline
			 strSQL = strSQL & "   AND " & strFAIXA_PRECO_QTDE & " BETWEEN tbl_PrcLista.QTDE_INIC AND tbl_PrcLista.QTDE_FIM" & vbnewline 
			 strSQL = strSQL & "   AND tbl_PrcLista.COD_PROD = " & prCOD_PROD & vbnewline 
			 'response.Write("DEBUG: InsereProduto3 strSQL ["&strSQL&"]<br><br>")	  
			 set objRS_lc = objConn.Execute(strSQL)
			 
			 If not objRS_lc.EOF Then
						'response.Write("DEBUG: InsereProduto4<br><br>")
						
						Qtde			 = prQTDE
						strDESCONTO_PROD = objRS_lc("DESCONTO")
						strVLR_FIXO 	 = objRS_lc("VLR_FIXO")
						Valor 			 = objRS_lc("VALOR")
					   
						If not strFLAG_SENHA_STATUS_PRECO Then
						   If IsNull(strVLR_FIXO) Then
								 If IsNull(strDESCONTO_PROD) Or strDESCONTO_PROD = "" Then
								   strDESCONTO_PROD = 0
								 End If		  
								 strDESCONTO_PROD = 1 - (strDESCONTO_PROD / 100)
								 Valor = objRS_lc("VALOR") * strDESCONTO_PROD
						   Else
								 Valor = strVLR_FIXO
						   End If
						End If
						If Valor = "" or IsNull(Valor) Then
							Valor = 0
						End If
					
					
					   'Chama a funcao RemoveProduto antes para garantir que se ja tiver colocado alguem antes entao remove para conceder o desconto do "combo"
						strSQL = "SELECT PC.DESCONTO_PERC, PC.DESCONTO_VLR, IP.COD_PROD, IP.QTDE "&_
								 "  FROM tbl_Produtos_Combo PC, tbl_Inscricao_Produto IP"&_
								 " WHERE PC.COD_PROD = IP.COD_PROD" &_
								 "   AND PC.COD_PROD_RELACAO = " & prCOD_PROD &_
								 "   AND PC.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO &_
								 "   AND IP.COD_INSCRICAO = " & strCOD_INSCR &_
								 "   AND IP.SYS_DATACA IS NULL"
						Set objRSCombo_lc = objConn.Execute(strSQL)
						Do While not objRSCombo_lc.EOF
						  'response.Write("DEBUG: InsereProduto5.RemoveProduto5 cod_prod | qtde ["&objRSCombo("COD_PROD")&"]["&objRSCombo("QTDE")&"]<br><br>")
						  RemoveProduto objRSCombo_lc("COD_PROD"),objRSCombo_lc("QTDE")
						  objRSCombo_lc.MoveNext
						Loop
						FechaRecordSet objRSCombo_lc
						   
						'Se nao teve desconto entao contabiliza o desconto por COMBO
						If (strDESCONTO_PROD = 1 or IsNull(strDESCONTO_PROD) ) And IsNull(strVLR_FIXO) And not strFLAG_SENHA_STATUS_PRECO Then 
							'Verifica se tem desconto com produto "combo"
							strSQL = "SELECT PC.DESCONTO_PERC, PC.DESCONTO_VLR "&_
									 "  FROM tbl_Produtos_Combo PC, tbl_Inscricao_Produto IP"&_
									 " WHERE PC.COD_PROD_RELACAO = IP.COD_PROD" &_
									 "   AND PC.COD_PROD = " & prCOD_PROD &_
									 "   AND PC.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO &_
									 "   AND IP.COD_INSCRICAO = " & strCOD_INSCR
							Set objRSCombo_lc = objConn.Execute(strSQL)
							If not objRSCombo_lc.EOF Then
							  If objRSCombo_lc("DESCONTO_PERC") > 0 Then 
								Valor = Valor * (1 - (objRSCombo_lc("DESCONTO_PERC") / 100))
							  end if							
							  If objRSCombo_lc("DESCONTO_VLR") > 0 Then 
								Valor = Valor - objRSCombo_lc("DESCONTO_VLR")
							  end if							
							End If
							FechaRecordSet objRSCombo_lc 
						End If
						Valor = Replace(Valor,".","")
						Valor = Replace(Valor,",",".")
						
						'response.Write("DEBUG: InsereProduto6 ["&Valor&"]<br><br>")
						
						' Insere em "tbl_Inscricao_Produto"  -----------------------------------------------------------------------------------------  
						strSQL =  "INSERT INTO tbl_Inscricao_Produto "  
						strSQL = strSQL & " ( COD_INSCRICAO, COD_PROD, QTDE, VLR_PAGO, SYS_DATACA ,SYS_USERCA) " 
						strSQL = strSQL & " VALUES " 
						strSQL = strSQL & " (" & strCOD_INSCR & "," & prCOD_PROD & "," & Qtde & "," & Valor & ",NULL,'" & strEV_IDUSER_LOJA & "') "
					
						'response.Write("DEBUG: InsereProduto7 strSQL ["&strSQL&"]<br><br>")
						objConn.Execute(strSQL)
						
						strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO + " & Cint(Qtde) & " WHERE COD_PROD = " & prCOD_PROD
						'response.Write("DEBUG: InsereProduto8 strSQL ["&strSQL&"]<br><br>")
						objConn.Execute(strSQL)	
			 Else
				 strTpMsg	= "WARNING"
		 		 strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_addErr",0)   'Não foi possivel adicionar o item!"
				 strMSg		= objLang.SearchIndex("mini_shopagenda_exec_addE4msg",0) 'O item não foi encontrado na lista de preço, com vigencia, quantidade limite ou statuspreço adequados !"
				 strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | SPrc: " & strCOD_STATUS_PRECO & " | FPrc: " & strFAIXA_PRECO_QTDE &")"
			 End If
		Else
			strTpMsg	= "WARNING"
	 		strTITULO	= objLang.SearchIndex("mini_shopagenda_exec_addErr",0) 'Não foi possivel adicionar o item!
			strMSg		= replace(objLang.SearchIndex("mini_shopagenda_exec_addE5msg",0),"<TAG_COLIDIU>",Server.HTMLEncode(auxColidiu)) 'O item possui conflito de horário com ... ["&  Server.HTMLEncode(auxColidiu) &") existente em sua agenda." 'auxColidiu
			strMSgSys	= "(P: " & strCOD_PROD & " | I: " & strCOD_INSCR & " | SPrc: " & strCOD_STATUS_PRECO & " | FPrc: " & strFAIXA_PRECO_QTDE &")"
		End If			 
 End Sub

 ' =======================================================================
 Sub RemoveProduto(prCOD_PROD, prQTDE)
	Dim objRS_Local
	strSQL = "SELECT PC.DESCONTO_PERC, PC.DESCONTO_VLR, IP.COD_PROD, IP.QTDE "&_
			 "  FROM tbl_Produtos_Combo PC, tbl_Inscricao_Produto IP"&_
			 " WHERE PC.COD_PROD_RELACAO = IP.COD_PROD" &_
			 "   AND PC.COD_PROD         = " & prCOD_PROD &_
			 "   AND PC.COD_STATUS_PRECO = " & strCOD_STATUS_PRECO &_
			 "   AND IP.COD_INSCRICAO    = " & strCOD_INSCR
	'response.Write("DEBUG: RemoveProduto1 strSQL ["&strSQL&"]<br><br>")
	Set objRS_Local = objConn.Execute(strSQL)
	Do While not objRS_Local.EOF
		strSQL = " DELETE FROM tbl_Inscricao_Produto WHERE COD_INSCRICAO = " & strCOD_INSCR & " AND COD_PROD = " & objRS_Local("COD_PROD") 
		'response.Write("DEBUG: RemoveProduto2 strSQL ["&strSQL&"]<br><br>")
		objConn.Execute(strSQL)
		
		strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO - " & objRS_Local("QTDE") & " WHERE COD_PROD = " & objRS_Local("COD_PROD")
		'response.Write("DEBUG: RemoveProduto3 strSQL ["&strSQL&"]<br><br>")
		objConn.Execute(strSQL)	    

		objRS_Local.MoveNext
	Loop
	FechaRecordSet objRS_Local
	
	strSQL = " DELETE FROM tbl_Inscricao_Produto " &_
			 "  WHERE COD_INSCRICAO =" & strCOD_INSCR & _
			 "    AND COD_PROD = " & prCOD_PROD 
	'response.Write("DEBUG: RemoveProduto4 strSQL ["&strSQL&"]<br><br>")
	objConn.Execute(strSQL)
	
	strSQL = "UPDATE tbl_Produtos SET OCUPACAO = OCUPACAO - " & prQTDE & " WHERE COD_PROD = " & prCOD_PROD
	'response.Write("DEBUG: RemoveProduto5 strSQL ["&strSQL&"]<br><br>")
	objConn.Execute(strSQL)	
 End Sub

'Response.write ("<hr>FINALIZADO ")
'Response.write ("<a href='" & request("DEFAULT_LOCATION") & "' >[CLOSE]</a>")
' AVISO ---------------------------------------------
' Para Visualizar os DEBUGs descomente a linha abaixo
' Response.End()
' ---------------------------------------------------
%>
<html>
<head>
<title>pVISTA.PAX</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" onLoad="document.formdelproduto.submit()">
<!-- 'Este form envia para MSGDLG(dialog de mensagem) que recebe os parametros abaixo para preencher a página, 
		Sendo assim o value pode ser preenchido tando em um variavel quando direto no formulario //-->
<form name="formdelproduto" id="formdelproduto" action="../../_database/athMsgDlg.asp" method="post" target="_self">
    <input type="hidden" name="var_nome"			 	value="">
    <input type="hidden" name="var_tipo"			 	value="<%=strTpMsg%>">
    <input type="hidden" name="var_titulo"			 	value="<%=strTITULO%>">                                
    <input type="hidden" name="var_msg"			 		value="<%=strMSG%>">                                
    <input type="hidden" name="var_msgsys"			 	value="<%=strMSGSYS%>">                                
    <input type="hidden" name="var_icon"			 	value="<%=strICON%>">                                
    <input type="hidden" name="var_parent"			 	value="<%=strJScript%>"> 
	<input type="hidden" name="DEFAULT_LOCATION" 		value="<%=strDEFAULT_LOCATION%>">    

	<!-- input type="hidden" name="var_parent"			 	value="parent.formgeral.target='fr_principal';parent.formgeral.action = parent.formgeral.var_page.value;parent.formgeral.submit();" //-->
</form>              
</fom>          
</div><!--//-->									
</body>
</html>
<%FechaDBConn ObjConn%>
