<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_Evento",Session("METRO_USER_ID_USER")), true %>
<%
  Dim strSQL, objConn, objRS
  Dim arrCOD_EVENTO, strCOD_EVENTO, strID_AUTO
  Dim indexCOD_EVENTO, strMENSAGEM,strLOCATION
  Dim strFlagLINK, strFlagRPSNFE, strFlagSTSPRECO,strVERBOSE,strTABLES

  strVERBOSE	= ""
  strTABLES		= ""
  strCOD_EVENTO = ""
  strLOCATION	= Replace(GetParam("DEFAULT_LOCATION"),"'","''")
  strID_AUTO	= Replace(GetParam("var_chavereg"),"'","''") 'recebe a chave do registro

  AbreDBConn objConn, CFG_DB

  strSQL = "SELECT COD_EVENTO FROM tbl_evento WHERE ID_AUTO = " & strID_AUTO
  
  AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null
  
  if (NOT objRS.EOF) then 
    strCOD_EVENTO = getValue(objRS,"COD_EVENTO")
  end if  


  If strCOD_EVENTO <> "" Then
	
    strSQL = "DELETE FROM TBL_INSCRICAO_PRODUTO WHERE COD_PROD IN (SELECT COD_PROD FROM tbl_PRODUTOS WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") )" 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_INSCRICAO_PRODUTO</li>"
	objConn.Execute strSQL

    strSQL = "DELETE FROM TBL_CONTROLE_PRODUTOS WHERE COD_PROD IN (SELECT COD_PROD FROM tbl_PRODUTOS WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") )" 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_CONTROLE_PRODUTOS</li>"
	objConn.Execute strSQL

    strSQL = "DELETE FROM TBL_PRCLISTA WHERE COD_PROD IN (SELECT COD_PROD FROM tbl_PRODUTOS WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") )" 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_PRCLISTA</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM TBL_PRODUTOS_PALESTRANTE WHERE COD_PROD IN ( SELECT COD_PROD FROM tbl_PRODUTOS WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") )" 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_PRODUTOS_PALESTRANTE</li>"
	objConn.Execute strSQL

    strSQL = "DELETE FROM TBL_PRODUTOS WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_PRODUTOS</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM TBL_AREAGEO WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_AREAGEO</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM TBL_MAPEAMENTO_CAMPO WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_MAPEAMENTO_CAMPO</li>"
	objConn.Execute strSQL
	
	strSQL = "DELETE FROM TBL_MAPEAMENTO_CAMPO_INSCRICAO WHERE COD_evento IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_MAPEAMENTO_CAMPO_INsCRICAO</li>"
	objConn.Execute strSQL
	
	strSQL = "DELETE FROM TBL_FORMULARIO_SETUP WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_FORMULARIO_SETUP</li>"
	objConn.Execute strSQL
	
	strSQL = "DELETE FROM TBL_AREA_RESTRITA_EXPOSITOR WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_AREA_RESTRITA_EXPOSITOR</li>"
	objConn.Execute strSQL
	
	strSQL = "DELETE FROM TBL_AUX_SERVICOS WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_AUX_SERVICOS</li>"
	objConn.Execute strSQL

	strSQL = "DELETE  FROM TBL_EVENTO_LINK WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_EVENTO_LINK</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM TBL_FIN_RPS_EVENTO WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_FIN_RPS_EVENTO</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM tbl_STATUS_PRECO WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_STATUS_PRECO</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM TBL_EVENTO_IMG  WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_EVENTO_IMG</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM TBL_EVENTO_FORMAPGTO WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_EVENTO_FORMAPGTO</li>"
	objConn.Execute strSQL
	
	strSQL = "DELETE FROM TBL_QUESTIONARIO WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_QUESTIONARIO</li>"
	objConn.Execute strSQL
	
	strSQL = "DELETE FROM TBL_CONTROLE_IN WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_CONTROLE_IN</li>"
	objConn.Execute strSQL

	strSQL = "DELETE FROM TBL_EVENTO WHERE COD_EVENTO IN (" & strCOD_EVENTO & ") " 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_EVENTO</li>"
	objConn.Execute strSQL
 
  End If

'------------SEPARADO PARA ANALISE------------------------------
	' strSQL = "DELETE FROM tbl_areageo a INNER JOIN tbl_areageo_cep 
	'ac ON a.id_areageo = ac.id_areageo LEFT JOIN tbl_areageo a2 ON 
	'a.nome_Areageo = a2.nome_areageo AND a2.cod_Evento = " & strCOD_EVENTO 
	'&" WHERE a2.id_areageo IS NOT NULL  AND A.COD_EVENTO IN (" & strCOD_EVENTO & ") "
	' 'athdebug strSQL&"<hr>" , false
	'strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	'strTABLES  = strTABLES & "<li>tbl_areageo</li>"
	 'objConn.Execute strSQL	
	
  'FechaDBConn objConn
  'Response.Redirect("default.asp")
'----------------------------------------------------------------  
 
%>

<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-stop-3 fg-black on-right on-left"></i>DELETE EVENTO</h1>
            <h2>Deleção de Evento <%=strCOD_EVENTO%></h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
                	<p>O sistema processou a deleção do Evento(<strong><%=strCOD_EVENTO%></strong>) de ID <strong><%=strID_AUTO%></strong>. As tabelas envolvidas nesta delete foram:</p>
                    <ul><%=ucase(strTABLES)%></ul>
                	<p>Abaixo segue, como informação técnica, o LOG de execução de script SQL relativos as deleções paralelas ao evento:</p>
					<hr />
					<%=ucase(strVERBOSE)%>
                </div>
                <hr>
                <div><form id="" action="default.asp">
                <input class="primary" type="submit" name="btRun" value="OK" />
                </form></div>
                <br>
        </div>
</div>
</body>
</html>


<%
'athdebug "<hr> [FIM]" , true
'response.Redirect(strLOCATION)

FechaRecordSet ObjRS
FechaDBConn ObjConn

%>