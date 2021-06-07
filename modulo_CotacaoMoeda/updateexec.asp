<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CotacaoMoeda",Session("METRO_USER_ID_USER")), true %>
<%

Dim objConn, objRSValida, strSQL
Dim strCodigo, strCodMoedaOrigem, strCodMoedaDestino, strCotacaoData, strCotacaoTaxa,strDEFAULT_LOCATION

strCodigo          = Replace(GetParam("var_id_auto"),"'","''")
strCotacaoTaxa     = Replace(GetParam("var_cotacao_taxa"),"'","''")

strDEFAULT_LOCATION = Replace(GetParam("DEFAULT_LOCATION"),"'","''")

If strCotacaoTaxa <> "0" Then

	If (strCodigo <> "" And IsNumeric(strCodigo)) And (strCotacaoTaxa <> "" And IsNumeric(strCotacaoTaxa)) Then
		
		AbreDBConn objConn, CFG_DB
		
		strSQL = " SELECT COTACAO_DATA, COD_MOEDA_DESTINO, COD_MOEDA_ORIGEM FROM TBL_MOEDA_COTACAO WHERE ID_AUTO = " & strCodigo
		Set objRSValida = objConn.execute(strSQL)
		  
		If Not objRSValida.EOF Then
			strSQL = "UPDATE TBL_MOEDA_COTACAO SET COTACAO_TAXA = " & FormataDouble(strCotacaoTaxa,6) & " WHERE ID_AUTO = " & strCodigo
			objConn.Execute strSQL
			
			strSQL = "UPDATE TBL_MOEDA_COTACAO SET COTACAO_TAXA = " & FormataDouble(1/strCotacaoTaxa,6) &_
					 " WHERE COTACAO_DATA = '" & strIsoDate(objRSValida("COTACAO_DATA")) & "' " &_
					 "   AND COD_MOEDA_ORIGEM  = " & objRSValida("COD_MOEDA_DESTINO") &_ 
					 "   AND COD_MOEDA_DESTINO = " & objRSValida("COD_MOEDA_ORIGEM")
			objConn.Execute strSQL
		End If
		
		Response.Redirect(strDEFAULT_LOCATION)
		
		FechaRecordSet objRS
		FechaDBConn objRS
	Else
		Mensagem "Preencha todos os campos obrigatórios.<br><a href='#' onclick='javascript:history.back();'>Voltar</a>", "","",true
		Response.End()
	
	End If

Else
		Mensagem "O campo Taxa não pode ser Zero(0). <br><a href='#' onclick='javascript:history.back();'>Voltar</a>", "","",true
		Response.End()
	End If
		

FechaRecordSet objRS
FechaDBConn objRS
%>
%>


