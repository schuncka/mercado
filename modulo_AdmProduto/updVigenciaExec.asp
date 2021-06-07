<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_AdmProduto",Session("METRO_USER_ID_USER")), true %>
<%
 'Relativas a conexão com DB, RecordSet e SQL
 	Dim ObjConn, objRS, strSQL
	
	Dim strVERBOSE,strLOCATION,strTABLES
	Dim i
	Dim strCategoria, dtNovaInicio, dtNovaFim, dtVelhaInicio, dtVelhaFim,  strSESSIONEVENTO, strCategoriaNome, strProdutos

strVERBOSE 				= ""

strLOCATION 			= Replace(GetParam("DEFAULT_LOCATION"),"'","''")
strCategoria 		 	= Replace(GetParam("DBVAR_CATEGORIA"),"'","''")
dtVelhaInicio 	        = Replace(GetParam("DBVAR_VELHA_DT_INICIO"),"'","''")
dtVelhaFim 	 	        = Replace(GetParam("DBVAR_VELHA_DT_FIM"),"'","''")

dtNovaInicio		 	= Replace(GetParam("DBVAR_NOVA_DT_INICIO"),"'","''")
dtNovaFim				= Replace(GetParam("DBVAR_NOVA_DT_FIM"),"'","''")

'athDebug strCOD_PROD&strCOD_PROD_ORIGEM , true 

IF strSESSIONEVENTO = "" THEN
		strSESSIONEVENTO = session("COD_EVENTO")
	ELSE
		strSESSIONEVENTO = Session("METRO_EVENTO_COD_EVENTO")
END IF



		
 AbreDBConn objConn, CFG_DB 
 
strSQL = "SELECT COD_STATUS_PRECO, STATUS FROM tbl_STATUS_PRECO WHERE cod_status_preco = " & strCategoria & " AND COD_EVENTO = " & strSESSIONEVENTO

Set objRS = objConn.Execute(strSQL)
	if not objRS.EOF then
		strCategoriaNome = getValue(objRS, "status")
	end if
    
	strSQL = "            SELECT t1.cod_prod, t1.titulo "
    strSQL = strSQL & "      FROM tbl_produtos t1 inner join TBL_PRCLISTA t2 on t1.cod_prod = t2.cod_prod "
	strSQL = strSQL & "	  WHERE t1.cod_evento= " & strSESSIONEVENTO  
	strSQL = strSQL & "   AND t2.COD_STATUS_PRECO = " & strCategoria 
	strSQL = strSQL & "   AND   DT_VIGENCIA_INIC  = '" & PrepDataIve(dtVelhaInicio,False,False) & "'"
	strSQL = strSQL & "   AND   DT_VIGENCIA_FIM   = '" & PrepDataIve(dtVelhaFim,False,False) & "'"
	
	Set objRS = objConn.Execute(strSQL)
	if not objRS.EOF Then
		 
		 Do While not objRS.EOF
		 strProdutos = strProdutos & "<li><strong>" & objRS("COD_PROD") & " - " & objRS("TITULO") & "</strong></li>"
		 objRS.MoveNext
   Loop
	
	end if
		
	strSQL = " UPDATE tbl_PrcLista SET DT_VIGENCIA_INIC = '" & PrepDataIve(dtNovaInicio,False,False) & "', DT_VIGENCIA_FIM = '" & PrepDataIve(dtNovaFim,False,False) &"'" 
	strSQL = strSQL & " where COD_STATUS_PRECO = "  & strCategoria   
	strSQL = strSQL & " AND   DT_VIGENCIA_INIC  = '" & PrepDataIve(dtVelhaInicio,False,False) & "'"
	strSQL = strSQL & " AND   DT_VIGENCIA_FIM   = '" & PrepDataIve(dtVelhaFim,False,False) & "'"
	
	 	'athDebug strSQL&"<hr>" , true
		strVERBOSE = strVERBOSE & strSQL&"<hr>"
		'strTABLES  = strTABLES & "<li>VIGENCIAS</li>"	
	    objConn.Execute(strSQL)	

'========================PRODUTOS PALESTRANTE=====================================================

' painel ================================================================================================================================================================================================

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
            <h1><i class="icon-copy fg-black on-right on-left"></i>Alteração data vigência</h1>
            <!--h2>Alteração das datas de vigência por categoria</h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span//-->            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
                	<p>O sistema procedeu a alteração do das datas de vigência da categoria <strong><%=strCategoriaNome &" ["&strCategoria&"]"%></strong>, alterando as datas de <strong><%=dtVelhaInicio&"  -  "&dtVelhaFim%></strong> para <strong><%=dtNovaInicio&"  -  "&dtNovaFim%></strong>. para os seguintes produtos</p>
                    	<%=strProdutos%>
                	<p>Abaixo segue, como informação técnica, o LOG de execução de script SQL relativo a esta alteração:</p>
					<hr/>
					<%=ucase(strVERBOSE)%>
                </div>
                <hr>
                <div><form id="" action="<%=strLOCATION%>"><!--form id="" action="update.asp?var_chavereg=<'%=strCOD_PROD_ORIGEM%>"//--> 
                <input class="primary" type="submit" name="btRun" value="OK" />
                </form></div>
                <br>
        </div>
</div>
</body>
</html>

<%
FechaRecordSet ObjRS
FechaDBConn ObjConn
%>