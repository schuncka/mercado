<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_CotacaoMoeda",Session("METRO_USER_ID_USER")), true %>
<%

Dim objConn, objRS, strSQL
Dim strCodigo, strCodMoedaOrigem, strCodMoedaDestino, strCotacaoData, strCotacaoTaxa,strDEFAULT_LOCATION

'strCodigo         = Replace(Request("var_id_auto"))
strCodMoedaOrigem  = GetParam("var_moeda_origem")
strCodMoedaDestino = GetParam("var_moeda_destino")
strCotacaoData     = GetParam("var_cotacao_data")
strCotacaoTaxa     = GetParam("var_cotacao_taxa")
strDEFAULT_LOCATION = getParam("DEFAULT_LOCATION")


AbreDBConn objConn, CFG_DB

'strCotacaoData = PrepData(strCotacaoData,false,false)
Function FormataDouble(prValor,prCasas)
	Dim strValorLocal
	
	strValorLocal = FormatNumber(prValor,prCasas)
	strValorLocal = Replace(Replace(strValorLocal,".",""),",",".")
	
	FormataDouble = strValorLocal
End Function


If strCotacaoTaxa <> "0" Then

	strSQL = " SELECT ID_AUTO FROM TBL_MOEDA_COTACAO WHERE " &_
			 " COTACAO_DATA = '" & PrepDataIve(strCotacaoData,false,false) & "' AND COD_MOEDA_ORIGEM = " & strCodMoedaOrigem & " AND COD_MOEDA_DESTINO = " & strCodMoedaDestino
	Set objRS = objConn.execute(strSQL)
	
	If objRS.EOF Then
		strSQL = " INSERT INTO tbl_MOEDA_COTACAO (COD_MOEDA_ORIGEM, COD_MOEDA_DESTINO, COTACAO_DATA, COTACAO_TAXA) " &_
				 "	VALUES " &_
				 " (" & strCodMoedaOrigem & "," & strCodMoedaDestino & ",'" & PrepDataIve(strCotacaoData,false,false) & "'," & FormataDouble(strCotacaoTaxa,6) & ")"
		objConn.execute(strSQL)
		
		strSQL = "SELECT Max(ID_AUTO) FROM TBL_MOEDA_COTACAO ORDER BY ID_AUTO DESC"
		Set objRS = objConn.execute(strSQL)
				 
		strSQL = " INSERT INTO tbl_MOEDA_COTACAO (COD_MOEDA_ORIGEM, COD_MOEDA_DESTINO, COTACAO_DATA, COTACAO_TAXA) " &_
				 "	VALUES " &_
				 " (" & strCodMoedaDestino & "," & strCodMoedaOrigem & ",'" & PrepDataIve(strCotacaoData,false,false) & "'," & FormataDouble(1/strCotacaoTaxa,6) & ")"
		objConn.execute(strSQL)
		
		Response.Redirect(strDEFAULT_LOCATION)
	Else
		FechaRecordSet objRS
		FechaDBConn objConn
		
		Mensagem "Já foi cadastrada uma cotação para as moedas selecionadas na data de " & Request("var_cotacao_data") & "<br><a href='#' onclick='javascript:history.back();'>Voltar</a>", "","",true
		Response.End()
	End If
Else
		Mensagem "O campo Taxa não pode ser Zero(0)<br><a href='#' onclick='javascript:history.back();'>Voltar</a>","","",true
		Response.End()
	End If
		

FechaRecordSet objRS
FechaDBConn objRS
%>