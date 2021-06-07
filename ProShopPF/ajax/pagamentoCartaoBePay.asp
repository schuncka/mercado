<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_database/athSendMail.asp"--> 
<!--#include file="../../ajax/aspJSON1.17.asp"--> 
<!--#include file="../../ajax/hash.asp"--> 

<%

Response.AddHeader "Content-Type","text/html; charset=iso-8859-1" 

Dim strCOD_EVENTO, strCodigoPromo
Dim objConn, objRS, strSQL,strProduto,strSQLDel, objRSProd, ObjRSProduto
Dim strCodProd, strQuantidade,strCategoria, strSessionId
Dim strItens, item, i
Dim objSvrHTTP,PostData, sStatus, objXMLSend,strTEXTO
Dim objXML, strSTATUS, strURLautenticacao, strURLtid, strMensagem
Dim varSTATUS, varURLautenticacao, varURLtid, varMensagem, strReturn
Dim oJSON, oJSON1, this, this2
Dim strOUTPUT
Dim strCodEvento
Dim arrItem, arrItemDado, strEV_NOME
Dim strCOD_INSC, strVALOR,valoresHash, Hash, strVALOR_TAXA
Dim ApiAccessKey,SecretKey,MediatorAccountId,SellerAccountId,strExternalId, strBANDEIRA
Dim dt_lancamento, strEV_IDUSER_LOJA,idcaixa,strHISTORICO,strINSTRUCAO,strNUM_DIAS_VCTO, strNRO_DIAS
Dim strDESCRICAO , strSUFIXO_BOLETO
strCodEvento = request.Cookies("METRO_ProshopPF")("COD_EVENTO")
AbreDBConn objConn, CFG_DB_DADOS


function buscaArrayDados(prBusca,arrDados)
Dim arrTmp1, arrTmp2
	'arrDados = "|var_tp_pagamento:|var_bandeira:VISA|lng:BR|var_sobrenome:Schunck|db:prodesenv_dados|var_cartao:4716661794289419|cod_evento:109|var_valor_comprado:320|var_cel_titular:12131223|var_parcelas:1|var_categoria:146|var_fone:5132132132|var_cod_inscricao:315575|var_cod_empresa:309392|var_cod_formapgto:8002|var_tipo_pagamento:cartao;cartao;8002;var_cod_cartao:617|var_cpf_titular:95065750025|var_razao_social:Teste Razao|var_num_doc1:94866381000130|var_cep:90460150|var_nome:Gabriel|var_nome_titular:Gabriel Schunck|var_end_numero:319|var_end_complemento:503|var_end_bairro:Petropolis|var_end_cidade:Porto Alegre|var_end_estado:RS|var_email:gabriel@proevento.com.br|var_departamento:teste|var_dia_cartao:7|var_ano_cartao:2019|var_endereco:Rua Joao Abbott|var_pais:BRASIL|var_data_nasc_titular:17/11/1980"
	arrTmp1 = split(arrDados,"|")
	i=0
	'response.write(ubound(arrdados))
	For i = 0 To ubound(arrTmp1)
		if instr(arrTmp1(i),prBusca) then
			arrTmp2 = split(arrTmp1(i),":")
			'response.write(arrTmp(0)&"<br>"&vbnewline)
			buscaArrayDados =arrTmp2(1)
		end if
	next
end function


'response.write(strCodEvento)
strVALOR = 0
For Each item in request.form

 strItens = strItens &"|"& item & ":" & replace(Request.Form(item),"|",";") 
 
next
'response.write(strItens&vbnewline)
'response.end()
strCOD_INSC = buscaArrayDados("var_cod_inscricao",strItens)


  strSQL =          " SELECT IP.COD_PROD, P.TITULO, P.DESCRICAO, IP.QTDE, IP.VLR_PAGO,(IP.QTDE*IP.VLR_PAGO) AS VLR_TOT_PAGO  "
  strSQL = strSQL & "  FROM tbl_Inscricao_Produto IP, tbl_Produtos P " 
  strSQL = strSQL & "  WHERE IP.COD_PROD = P.COD_PROD"
  strSQL = strSQL & "  AND IP.COD_INSCRICAO = " & strCOD_INSC

 ' response.write(strSQL)


'response.end
  
  Set ObjRSProduto = objConn.Execute(strSQL)

  strVALOR = 0
  'Response.write strSQL
  Do While not ObjRSProduto.EOF
	  strDESCRICAO = strDESCRICAO & ObjRSProduto("DESCRICAO") & "<br>"
      strVALOR = strVALOR + ObjRSProduto("VLR_TOT_PAGO")
    ObjRSProduto.MoveNext
  Loop
  
  FechaRecordSet ObjRSProduto

'------------------------------------------------
'Pega tudo que já foi pago para esta inscricao

  strSQL =          " SELECT SUM(VLR) AS VLR_QUITADO "
  strSQL = strSQL & "  FROM tbl_Caixa_Sub_INSC " 
  strSQL = strSQL & "  WHERE COD_INSCRICAO = " & strCOD_INSC


'response.write(strSQL)
'response.end()

 
  Set ObjRSProduto = objConn.Execute(strSQL)
  If not ObjRSProduto.EOF Then
    If ObjRSProduto("VLR_QUITADO")>0 Then
      strVALOR = strVALOR - ObjRSProduto("VLR_QUITADO")
	End If
  End If
  FechaRecordSet ObjRSProduto

	strSQL = "SELECT SUFIXO_BOLETO from tbl_INSCRICAO WHERE COD_INSCRICAO = " & strCOD_INSC
	Set objRS = objConn.Execute(strSQL)
	If objRS.EOF Then
		strSUFIXO_BOLETO = 0
	else 
		strSUFIXO_BOLETO = objRS("sufixo_boleto")&""
	End If
	'response.write(strSUFIXO_BOLETO)
	if strSUFIXO_BOLETO = "" Then strSUFIXO_BOLETO=0
	strSUFIXO_BOLETO = strSUFIXO_BOLETO + 1
	strSQL = "UPDATE tbl_INSCRICAO SET SUFIXO_BOLETO = " & strSUFIXO_BOLETO & " WHERE COD_INSCRICAO = " & strCOD_INSC
	'response.write(strSQL)
	objConn.Execute(strSQL)
	strSUFIXO_BOLETO = AthFormataTamLeft(strSUFIXO_BOLETO,2,"0")
  

'response.write(strValor)
'response.end()

  strSQL = " SELECT EF.ID_LOJA, EF.ASSINATURA, EF.COD_CONTRATO, EF.CEDENTE, EF.PARCELAS, EF.INSTRUCOES, EF.DT_LIMITE_VCTO, FP.URL_ENTRADA, EF.VALOR_TAXA, EF.NUM_DIAS_VCTO, EF.CARTEIRA, EF.CAPTURA  FROM tbl_EVENTO_FORMAPGTO EF, tbl_FORMAPGTO FP WHERE EF.COD_FORMAPGTO = FP.COD_FORMAPGTO AND EF.COD_EVENTO = " & buscaArrayDados("cod_evento",strItens ) & " AND EF.COD_FORMAPGTO = " & buscaArrayDados("var_cod_formapgto",strItens)
'response.write(vbnewline&strSQL&vbnewline)
'response.end 



  Set objRS = objConn.Execute(strSQL)

  Set objSvrHTTP = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0")

	Set oJSON = New aspJSON
		

	ApiAccessKey      = objRS("id_loja")&""
	
	SecretKey 		  = objRS("assinatura")&""
	
	MediatorAccountId = objRS("cod_contrato")&""
	
	SellerAccountId   = objRS("cedente")&""
	
	
	'strCOD_INSC = 100000
	'if instr(buscaArrayDados("var_tipo_pagamento",strItens),"cartao")>0 then
	'	strExternalId = "10812688000168"&Left(Ucase(CFG_IDCLIENTE)&"_____",5)&Right("000"&strCodEvento,3)&Right("00000000"&strCOD_INSC,8)
	'else 
		strExternalId = "10812688000168"&Left(Ucase(CFG_IDCLIENTE)&"_____",5)&Right("000"&strCodEvento,3)&Right("00000000"&strCOD_INSC&strSUFIXO_BOLETO,8)
	'end if
	'response.write(strExternalId)
	
	strURLautenticacao = "https://api.bepay.com/v1/payments"
	'response.End()
	'If ApiAccessKey = "" or SecretKey = "" or MediatorAccountId = "" or SellerAccountId = ""  Then
	strVALOR_TAXA = replace(objRS("VALOR_TAXA"),",",".")
	'strVALOR_TAXA = "9.93"
	if 1=22 then
		ApiAccessKey = "2F10A163-5420-4ED1-A2A8-63D5D3F28F61"
		SecretKey = "C801505D-E51F-4A12-B0D4-8E03D1D252AB"
		MediatorAccountId = "A21D5F48-A434-8F73-A3AB-78822FF6FF71"
		SellerAccountId = "A21D5F48-A434-8F73-A3AB-78822FF6FF71"		
		strURLautenticacao = "https://homolog-api.bepay.com/v1/payments"
		
	End If

'if buscaArrayDados("var_valor_comprado",strItens) <100 Then
'strVALOR = Fix(buscaArrayDados("var_valor_comprado",strItens))
'else
'strVALOR = Fix(buscaArrayDados("var_valor_comprado",strItens)/100)
'strVALOR = Fix(buscaArrayDados("var_valor_comprado",strItens))
Dim strValorConta
strValorConta = strValor
strVALOR = Fix(strValor)
'end if
 
 if instr(buscaArrayDados("var_tipo_pagamento",strItens),"cartao")>0	Then
	valoresHash = trim(buscaArrayDados("var_cpf_titular",strItens) & buscaArrayDados("var_cartao",strItens) & strVALOR & SellerAccountId & strVALOR)
 else
 	valoresHash = trim(buscaArrayDados("var_num_doc1",strItens) &  strVALOR & SellerAccountId & strVALOR)
end if

	FechaRecordSet objRS


	Hash = fnHash("sha256HMAC", Array(valoresHash, SecretKey))
	'response.Write("hash :"&valoresHash)
	'response.End()
	
	PostData = ""	
if instr(buscaArrayDados("var_tipo_pagamento",strItens),"cartao")>0	Then
	PostData = PostData & "{"

	PostData = PostData & "  ""totalAmount"": """&strValorConta&""","

	PostData = PostData & "  ""currency"": ""BRL"","
	PostData = PostData & "  ""paymentInfo"": {"
	PostData = PostData & "    ""transactionType"": ""CreditCard"","
	PostData = PostData & "    ""creditCard"": {"
	PostData = PostData & "      ""cardType"": """&buscaArrayDados("var_bandeira",strItens)&""","
	PostData = PostData & "      ""cardNumber"": """&buscaArrayDados("var_cartao",strItens) &""","
	PostData = PostData & "      ""expirationMonth"": """&buscaArrayDados("var_mes_cartao",strItens) &""","
	PostData = PostData & "      ""expirationYear"": """&buscaArrayDados("var_ano_cartao",strItens) &""","
	PostData = PostData & "      ""cvv"": """&buscaArrayDados("var_cod_cartao",strItens) &""","
	PostData = PostData & "      ""nameOnCard"": """&buscaArrayDados("var_nome_titular",strItens) &""","

	PostData = PostData & "      ""holderTaxId"": {"
	PostData = PostData & "        ""taxId"": """&buscaArrayDados("var_cpf_titular",strItens)&""","
	PostData = PostData & "        ""country"": ""BRA"""
	PostData = PostData & "      },"
	PostData = PostData & "      ""installments"": """ & buscaArrayDados("var_parcelas",strItens) & """ "

	PostData = PostData & "    }"
	PostData = PostData & "  },"
	PostData = PostData & "  ""sender"": {"
	PostData = PostData & "    ""client"": {"
	PostData = PostData & "      ""name"": """&buscaArrayDados("var_nome_titular",strItens)&""","

	PostData = PostData & "      ""taxIdentifier"": {"
	PostData = PostData & "        ""taxId"": """&buscaArrayDados("var_cpf_titular",strItens)&""","
	PostData = PostData & "        ""country"": ""BRA"""
	PostData = PostData & "      },"

	PostData = PostData & "      ""mobilePhones"": [{"
	PostData = PostData & "        ""country"": ""BRA"","
	PostData = PostData & "        ""phoneNumber"": """&buscaArrayDados("var_cel_ddd_titular",strItens)&buscaArrayDados("var_cel_titular",strItens)&""""
	PostData = PostData & "      }],"

	PostData = PostData & "      ""email"": """&buscaArrayDados("var_email",strItens)&""""
	PostData = PostData & "    }"
	PostData = PostData & "  },"

	PostData = PostData & "  ""myAccount"": {"
	PostData = PostData & "    ""accountId"": """&MediatorAccountId&""""
	PostData = PostData & "  },"
	PostData = PostData & "  ""recipients"": ["
	PostData = PostData & "    {"
	PostData = PostData & "      ""account"": {"
	PostData = PostData & "        ""accountId"": """&SellerAccountId&""""
	PostData = PostData & "      },"
	PostData = PostData & "      ""order"": {"
	PostData = PostData & "        ""orderId"": """&buscaArrayDados("cod_evento",strItens)&"-"&Right("0000000000"&strCOD_INSC,10)&""","
	PostData = PostData & "        ""dateTime"": """&Replace(PrepDataIve(Now(),False,True)," ","T")&"+03:00"","
	PostData = PostData & "        ""description"": """&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strNomeEvento")&""""
	PostData = PostData & "      },"
	PostData = PostData & "      ""amount"": """&strValorConta&""","
	PostData = PostData & "      ""mediatorFee"": """&strVALOR_TAXA&""","
	PostData = PostData & "      ""currency"": ""BRL"""
	PostData = PostData & "    }"
	PostData = PostData & "  ],"
	PostData = PostData & "  ""externalIdentifier"": """&strExternalId&""","
	PostData = PostData & "  ""callbackAddress"": ""https://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/bepaycallback.asp"""
	PostData = PostData & "}"
else
	PostData = PostData & "{"
	'PostData = PostData & "    ""totalAmount"": """&buscaArrayDados("var_valor_comprado",strItens)&""","
	PostData = PostData & "    ""totalAmount"": """&strValorConta&""","
	PostData = PostData & "    ""currency"": ""BRL"","
	
	'	PostData = PostData & "    ""externalIdentifier"": ""10812688000168"&Right("0000000000"&strCOD_INSC&strSUFIXO_BOLETO,10)&""","
	PostData = PostData & "    ""externalIdentifier"": """&strExternalId&""","
	PostData = PostData & "    ""callbackAddress"": ""https://" & Request.ServerVariables("SERVER_NAME") & "/" & CFG_IDCLIENTE & "/shop/bepaycallback.asp"","
	PostData = PostData & "    ""sender"": "
	PostData = PostData & "        {    "
	PostData = PostData & "            ""client"":"
	PostData = PostData & "            {"
	PostData = PostData & "              ""name"": """&buscaArrayDados("var_nome",strItens)& " " & buscaArrayDados("var_sobrenome",strItens) & ""","
	PostData = PostData & "              ""taxIdentifier"": "
	PostData = PostData & "                  {"
	PostData = PostData & "                  	""taxId"": """&buscaArrayDados("var_num_doc1",strItens)&""","
	PostData = PostData & "                    ""country"": ""BRA"""
	PostData = PostData & "                  },"
	PostData = PostData & "              ""email"": """&buscaArrayDados("var_email",strItens)&""","
	PostData = PostData & "              ""mobilePhones"": ["
	PostData = PostData & "              		{"
	PostData = PostData & "              			""country"": ""BRA"","
	PostData = PostData & "              			""phoneNumber"": """&buscaArrayDados("var_cel_ddd_titular",strItens)&buscaArrayDados("var_cel_titular",strItens)&""""
	PostData = PostData & "              		}"
	PostData = PostData & "              	]"
	PostData = PostData & "            }"
	PostData = PostData & "        },"
	PostData = PostData & "    ""paymentInfo"": "
	PostData = PostData & "        {"
	PostData = PostData & "            ""transactionType"": ""Boleto"","
	PostData = PostData & "            ""boleto"": "
	PostData = PostData & "                {"
	PostData = PostData & "                    ""bank"": ""237"","
	PostData = PostData & "                    ""shopperStatement"": """&strINSTRUCAO&""","
	If strNRO_DIAS >= 0 and strNRO_DIAS <= 365 Then
		'26/07/2017 - Mauro
		'Dias Corridos Futuros: "CNNN" >> C000, C001, C002, .... , C365 e C366. 
		PostData = PostData & "                    ""accountingMethod"": ""C"&Right("000"&strNRO_DIAS,3)&""""
	Else
		'PostData = PostData & "                    ""accountingMethod"": ""DEF"""
		PostData = PostData & "                    ""accountingMethod"": ""C"&Right("000"&strNUM_DIAS_VCTO,3)&""""
	End If

	PostData = PostData & "                },"
	PostData = PostData & "            ""billingAddress"":"
	PostData = PostData & "                {"
	PostData = PostData & "                     ""logradouro"": """&buscaArrayDados("var_endereco",strItens)&""","
	PostData = PostData & "                     ""numero"": """&buscaArrayDados("var_end_numero",strItens)&""","
	PostData = PostData & "                     ""bairro"": """&buscaArrayDados("var_end_bairro",strItens)&""","
	PostData = PostData & "                     ""cidade"": """&buscaArrayDados("var_end_cidade",strItens)&""","
	PostData = PostData & "                     ""estado"": """&buscaArrayDados("var_end_estado",strItens)&""","
	PostData = PostData & "                     ""cep"": """&buscaArrayDados("var_cep",strItens)&""","
	PostData = PostData & "                     ""pais"": ""BRA"""
	PostData = PostData & "             }"
	PostData = PostData & "        },  "
	PostData = PostData & "    ""myAccount"":"
	PostData = PostData & "        {"
	PostData = PostData & "            ""accountId"": """&MediatorAccountId&""""
	PostData = PostData & "        },"
	'response.write(PostData)
	'response.end
	PostData = PostData & "    ""recipients"": "
	PostData = PostData & "        ["
	PostData = PostData & "            {"
	PostData = PostData & "                ""account"": "
	PostData = PostData & "                    {"
	PostData = PostData & "                        ""accountId"": """&SellerAccountId&""""
	PostData = PostData & "                    },"
	'PostData = PostData & "                ""amount"": """&buscaArrayDados("var_valor_comprado",strItens)&""","
	PostData = PostData & "                ""amount"": """&strValorConta&""","
	PostData = PostData & "                ""mediatorFee"": """&strVALOR_TAXA&""","
	PostData = PostData & "                ""currency"": ""BRL"""
	PostData = PostData & "            }"
	PostData = PostData & "        ]"
	PostData = PostData & "}"

end if
    'response.Write(vbnewline&PostData&vbnewline&vbnewline)
    'response.end()
	'response.Write(  Hash&vbnewline&vbnewline)
	'if cstr(buscaArrayDados("cod_evento",strItens)) = cstr("109") and false  Then
	  'response.Write(PostData&vbnewline&vbnewline)
	'
	 ' response.Write("url: " & strURLautenticacao &vbnewline&vbnewline)
	 ' response.Write("ApiAccessKey: " & ApiAccessKey&vbnewline&vbnewline)
	 ' response.Write("Secret: " & SecretKey&vbnewline&vbnewline)
	 ' response.write("frase:  " & valoresHash&vbnewline&vbnewline)
	 ' response.Write("Hash: " & Hash&vbnewline&vbnewline)
	 ' response.Write("Account: " & SellerAccountId&vbnewline&vbnewline)
	  
	'End if
				
	objSvrHTTP.SetTimeouts 15000, 250000, 250000, 250000
	objSvrHTTP.open "POST", strURLautenticacao, false
	objSvrHTTP.setRequestHeader "Content-Type", "application/json"
	objSvrHTTP.setRequestHeader "Accept", "application/json"
	objSvrHTTP.setRequestHeader "Api-Access-Key", ApiAccessKey
	objSvrHTTP.setRequestHeader "Transaction-Hash", Hash

	objSvrHTTP.send PostData
	sStatus = objSvrHTTP.status
	strTEXTO = objSvrHTTP.responseText
	
	Set objSvrHTTP = Nothing
	
	'Response.Write strTEXTO
	'Response.End

	'Response.Write("<br>Status: " & sStatus&"<BR>")
	
	oJSON.loadJSON(vbnewline&strTEXTO&vbnewline)
	If sStatus = "200" Then
		'Load JSON string
		oJSON.loadJSON(strTEXTO)
		
		'Response.Write(oJSON.JSONoutput() &vbnewline&vbnewline)
		'response.end()
		'response.write(ojSON.data("data").item("transactionId")&vbnewline)
		'response.write(ojSON.data("data").item("externalIdentifier")&vbnewline)
		'response.write(ojSON.data("data").item("senderAccountId")&vbnewline)		
		'response.write(ojSON.data("data").item("financialStatement").item("status")&vbnewline)
		'response.write(ojSON.data("data").item("financialStatement").item("userMessage")&vbnewline)
		'response.write(ojSON.data("data").item("financialStatement").item("authorizationDetails").item("number")&vbnewline)
		'response.write(ojSON.data("data").item("transactionDate")&vbnewline)
		'response.write(ojSON.data("data").item("transactionType")&vbnewline)
		'response.write(ojSON.data("data").item("totalAmount")&vbnewline)
		'response.write(ojSON.data("data").item("paidAmount")&vbnewline)
		'strReturn = ojSON.data("data").item("transactionId") & "|" & ojSON.data("data").item("externalIdentifier") & "|" & ojSON.data("data").item("senderAccountId") & "|" & ojSON.data("data").item("financialStatement").item("status") & "|" & ojSON.data("data").item("financialStatement").item("userMessage") & "|" & ojSON.data("data").item("financialStatement").item("authorizationDetails").item("number") & "|" & ojSON.data("data").item("transactionDate") & "|" & ojSON.data("data").item("transactionType") & "|" & response.write(ojSON.data("data").item("totalAmount")&vbnewline) & "|" & ojSON.data("data").item("paidAmount")
		'Response.Write(strReturn)
		'response.end()
		If ojSON.data("data").item("financialStatement").item("status") <> "APPROVED" And ojSON.data("data").item("financialStatement").item("status") <> "CREATED"  Then
			strReturn = ojSON.data("data").item("transactionId")
			strReturn = strReturn & "|" & ojSON.data("data").item("externalIdentifier") 
			strReturn = strReturn& "|" & ojSON.data("data").item("senderAccountId") 
			strReturn = strReturn& "|" & ojSON.data("data").item("financialStatement").item("status") 
			strReturn = strReturn& "|" & ojSON.data("data").item("financialStatement").item("userMessage") 
			response.write(strReturn)
		
		Else
		
							strReturn = ojSON.data("data").item("transactionId")
							strReturn = strReturn & "|" & ojSON.data("data").item("externalIdentifier") 
							strReturn = strReturn& "|" & ojSON.data("data").item("senderAccountId") 
							strReturn = strReturn& "|" & ojSON.data("data").item("financialStatement").item("status") 
							strReturn = strReturn& "|" & ojSON.data("data").item("financialStatement").item("userMessage") 
							
							if lcase(ojSON.data("data").item("transactionType")) = "boleto" Then
									strReturn = strReturn & "|" & ojSON.data("data").item("boletoUrl")
									strReturn = strReturn & "|" & ojSON.data("data").item("typeableLine")
							else strReturn = "||"
							End If
							response.write(strReturn)
'response.end
							
							if lcase(ojSON.data("data").item("transactionType")) = "boleto" then
							
							
									 strSQL = "INSERT INTO tbl_titulo ("
									 strSQL = strSQL & " nosso_numero, nro_documento, vlr, vlr_liquido, dt_emissao, dt_criacao, nro_digitacao, dt_vcto, cod_evento, nome, end_full, end_cidade, end_estado, end_cep, id_num_doc1, cod_empresa, cod_inscricao, transactionId, externalId, parcela, cod_formapgto "
									 strSQL = strSQL & ")"
									 strSQL = strSQL & " VALUES ("
									 strSQL = strSQL & " " & strToSQL(buscaArrayDados("var_cod_inscricao",strItens))
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_cod_inscricao",strItens))
									 strSQL = strSQL & "," & buscaArrayDados("var_valor_comprado",strItens)
									 strSQL = strSQL & "," & buscaArrayDados("var_valor_comprado",strItens)
									 strSQL = strSQL & ", NOW()" 
									 strSQL = strSQL & ", NOW()"  
									 strSQL = strSQL & "," & strToSQL(oJSON.data("data").item("typeableLine"))
									 strSQL = strSQL & ",'" & PrepDataIve(oJSON.data("data").item("dueDate"),False,False) & "'"
									 strSQL = strSQL & "," & buscaArrayDados("cod_evento",strItens)
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_nome",strItens)& " " & buscaArrayDados("var_sobrenome",strItens))
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_endereco",strItens) & " " & buscaArrayDados("var_end_numero",strItens) & " " & buscaArrayDados("var_end_complemento",strItens))
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_end_cidade",strItens))
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_end_estado",strItens))
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_cep",strItens))
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_num_doc1",strItens))
									 strSQL = strSQL & "," & strToSQL(buscaArrayDados("var_cod_empresa",strItens))
									 strSQL = strSQL & "," & buscaArrayDados("var_cod_inscricao",strItens)
									 strSQL = strSQL & "," & strToSQL(oJSON.data("data").item("transactionId"))
									 strSQL = strSQL & "," & strToSQL(oJSON.data("data").item("externalIdentifier"))
									 strSQL = strSQL & ", 1" 
									 strSQL = strSQL & ", " & buscaArrayDados("var_cod_formapgto",strItens)
									 strSQL = strSQL & ")"
									 'response.Write(strSQL)
									 objCONN.Execute(strSQL)
									 'response.End()
									 
									 
									 strSQL = "INSERT INTO tbl_partner_transaction ("
									 strSQL = strSQL & " COD_INSCRICAO, ID_TRANSACTION, COD_EVENTO, SYS_DATACA, SYS_USERCA, PARTNER, PAYLOAD "
									 strSQL = strSQL & ")"
									 strSQL = strSQL & " VALUES ("
									 strSQL = strSQL & " " & strToSQL(buscaArrayDados("var_cod_inscricao",strItens))
									 strSQL = strSQL & "," & strToSQL(oJSON.data("data").item("transactionId"))
									 strSQL = strSQL & "," & buscaArrayDados("cod_evento",strItens)
									 strSQL = strSQL & ", NOW()" 
									 strSQL = strSQL & ", 'bepay'"
									 strSQL = strSQL & ", 'BEPAY'" 
									 strSQL = strSQL & "," & strToSQL(PostData)
									 strSQL = strSQL & ")"
									 'response.Write(strSQL)
									 'response.End()
									 On Error Resume Next
									 objConn.Execute(strSQL)
							else
					
										 dt_lancamento = left(ojSON.data("data").item("transactionDate"),10) & " " & mid(ojSON.data("data").item("transactionDate"),12,8)
										 strEV_IDUSER_LOJA = request.cookies("METRO_ProshopPF")("METRO_ProShopPF_strUsuerLoja")
										 strEV_IDUSER_LOJA = "BEPAY"
										 strCOD_EVENTO = buscaArrayDados("cod_evento",strItens)
									
										strsql="insert into tbl_caixa (DT_PAGTO, OBS, SYS_USERCA, SYS_DATACA, COD_EVENTO) values ('"&dt_lancamento&"','BEPAY','" & strEV_IDUSER_LOJA & "','"&dt_lancamento&"'," & strCOD_EVENTO & ")"
										'response.write(strsql)
										'response.end
										objConn.Execute(strSQL)
									
										strsql="select max(idcaixa) as id from tbl_caixa where sys_userca = '" & strEV_IDUSER_LOJA & "' and sys_dataca = '"&dt_lancamento&"'"
										'response.write(strsql)
										'response.end
										set objRS = objConn.Execute(strSQL)
										idcaixa=clng(objRS("id"))
										FechaRecordSet objRS
									
										strsql="INSERT INTO tbl_Caixa_Sub_INSC (idcaixa, cod_inscricao, nomecompleto, vlr) values ('" & IDCAIXA & "','" & strCOD_INSC & "','" & buscaArrayDados("var_nome_titular",strItens) & "'," & FormataDouble(strVALOR,2) & ")"
										
										objConn.Execute(strSQL)
									
										strsql = "INSERT INTO tbl_Caixa_Sub (IDCAIXA, CH_CORRENTISTA, CH_NRO, CH_VENC, VLR, FORMA) " &_ 
												 " VALUES ("&IDCAIXA&",'"&ojSON.data("data").item("externalIdentifier")&"','"&ojSON.data("data").item("transactionId")&"','"&dt_lancamento&"',"&FormataDouble(strVALOR,2)&",'CARTAO " & UCase(buscaArrayDados("var_bandeira",strItens)) & " CREDITO')"
										objConn.Execute(strSQL)
										
									

								strHISTORICO = "TRANSAÇÃO BEPAY "&ojSON.data("data").item("externalIdentifier")&" AUTORIZADA NO VALOR DE " & strVALOR & " - AUTORIZAÇÃO " &  ojSON.data("data").item("transactionId") & " - " & buscaArrayDados("var_bandeira",strItens)
							'	If strLR <> "" Then
							'	  strHISTORICO = strHISTORICO & "<BR>" & strLR & "-" & strMENSAGEM
							'	End If
								strSQL = "INSERT INTO tbl_Inscricao_Hist (COD_INSCRICAO, SYS_USERCA, SYS_DATACA, HISTORICO, COD_INSCRICAO_HIST_CATEG) VALUES ("&strCOD_INSC&",'"&strEV_IDUSER_LOJA&"',NOW(),'"&strHISTORICO&"',1)"
								objConn.Execute(strSQL)
								
												'Response.Write("<BR>"&strSQL&"<BR>")

								 strSQL = "INSERT INTO tbl_partner_transaction ("
								 strSQL = strSQL & " COD_INSCRICAO, ID_TRANSACTION, COD_EVENTO, SYS_DATACA, SYS_USERCA, PARTNER, PAYLOAD, idcaixa "
								 strSQL = strSQL & ")"
								 strSQL = strSQL & " VALUES ("
								 strSQL = strSQL & " " & strCOD_INSC
								 strSQL = strSQL & "," & strToSQL(ojSON.data("data").item("transactionId"))
								 strSQL = strSQL & "," & strCOD_EVENTO
								 strSQL = strSQL & ", NOW()" 
								 strSQL = strSQL & ", '"&strEV_IDUSER_LOJA&"'"
								 strSQL = strSQL & ", 'BEPAY'" 
								 strSQL = strSQL & "," & strToSQL(PostData)
								 strSQL = strSQL & "," & idcaixa
								 strSQL = strSQL & ")"
								 'response.write(strsql)
										'response.end
								 objConn.Execute(strSQL)			
									On Error Resume Next
								strSQL = "INSERT INTO tbl_SYNC_ERP_PAGAMENTO (COD_INSCRICAO, IDCAIXA, SYS_DATACAD, SYS_DATAUPD) VALUES (" & strCOD_INSC & "," & idcaixa & ",NOW(),NULL)"
								objConn.Execute(strSQL)
							end if
		End If 
		
else
		Response.Write("<BR>Código Erro: "& oJSON.data("error").item("code"))
		Response.Write("<BR>Descrição: " & oJSON.data("error").item("description"))
		response.write(" | | |"&oJSON.data("error").item("code")&"|"&oJSON.data("error").item("description") )
		'If oJSON.data.Exists("error") = True Then
		'	Response.Write("<BR>Código Erro: "& oJSON.data("error").item("code"))
		'	Response.Write("<BR>Descrição: " & oJSON.data("error").item("description"))
		'end if
'		Else	
end if
%>
