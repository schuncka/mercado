<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_CotacaoMoeda",Session("METRO_USER_ID_USER")), true %>
<%
  
  Dim objConn, objRSValida
  Dim strSQL, strCODIGOS
  Dim arrCODIGOS, indexCOD, strMENSAGEM
  
  strMENSAGEM = ""
	
  strCODIGOS = Replace(Request("var_chavereg"),"'","''")
  AbreDBConn objConn, CFG_DB 
	
  arrCODIGOS = split(strCODIGOS,",")
  
  If strCODIGOS <> "" Then
    For Each indexCOD In arrCODIGOS
      strSQL = " SELECT COTACAO_DATA, COD_MOEDA_DESTINO, COD_MOEDA_ORIGEM FROM TBL_MOEDA_COTACAO WHERE ID_AUTO = " & indexCOD
	  Set objRSValida = objConn.execute(strSQL)
	  
	  If Not objRSValida.EOF Then
	      strSQL = "DELETE FROM TBL_MOEDA_COTACAO WHERE ID_AUTO = " & indexCOD
		  objConn.Execute strSQL
		  strSQL = "DELETE FROM TBL_MOEDA_COTACAO WHERE COTACAO_DATA = '" & PrepDataIve(objRSValida("COTACAO_DATA"),false,false) & "' " &_
		                                          " AND COD_MOEDA_ORIGEM  = " & objRSValida("COD_MOEDA_DESTINO") &_ 
												  " AND COD_MOEDA_DESTINO = " & objRSValida("COD_MOEDA_ORIGEM")
		  objConn.Execute strSQL
	  End If
	Next
  End If
	
  FechaDBConn objConn
  Response.Redirect("default.asp")
%>