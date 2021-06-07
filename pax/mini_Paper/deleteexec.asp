<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%' VerificaDireito "|DEL|", BuscaDireitosFromDB("modulo_Evento",Session("METRO_USER_ID_USER")), true %>
<%
  Dim strSQL, objConn, objRS
  Dim strCOD_PAPER_CADASTRO, strCOD_EMPRESA
  Dim strMENSAGEM,strLOCATION
  Dim strVERBOSE,strTABLES

  strVERBOSE			= ""
  strTABLES				= ""
  strCOD_PAPER_CADASTRO	= Replace(GetParam("var_chavereg"),"'","''") 'recebe a chave do registro

  AbreDBConn objConn, CFG_DB

  If strCOD_PAPER_CADASTRO <> "" Then
  
    strSQL = "SELECT COD_EMPRESA FROM TBL_PAPER_CADASTRO WHERE COD_PAPER_CADASTRO IN (" & strCOD_PAPER_CADASTRO & ")"
	set objRS = objConn.Execute (strSQL)
	
	If not objRS.eof then
		strCOD_EMPRESA = GetValue(objRS,"COD_EMPRESA")
	End if
	
    strSQL = "DELETE FROM TBL_PAPER_SUB_VALOR WHERE COD_PAPER_CADASTRO IN (SELECT COD_PAPER_CADASTRO FROM TBL_PAPER_CADASTRO WHERE COD_PAPER_CADASTRO IN (" & strCOD_PAPER_CADASTRO & ") AND (COD_PAPER_STATUS = 0 OR COD_PAPER_STATUS IS NULL))" 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_PAPER_SUB_VALOR</li>"
	objConn.Execute strSQL

    strSQL = "DELETE FROM TBL_PAPER_CADASTRO WHERE COD_PAPER_CADASTRO IN (" & strCOD_PAPER_CADASTRO & ")  AND (COD_PAPER_STATUS = 0 OR COD_PAPER_STATUS IS NULL)" 
	strVERBOSE = strVERBOSE & strSQL&"<hr>"	
	strTABLES  = strTABLES & "<li>TBL_PAPER_CADASTRO</li>"
	objConn.Execute strSQL
 
  End If

%>

<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" style="display:none" id="metrotablevista">
<div class="grid fluid padding20">
        <div class="padding20">
            <h1><i class="icon-stop-3 fg-black on-right on-left"></i>DELETE TRABALHO</h1>
            <h2>Deleção de Trabalho(s) <%=strCOD_PAPER_CADASTRO%></h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
                <div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
                	<p>O sistema processou a deleção do(s) Trabalho(s)(<strong><%=strCOD_PAPER_CADASTRO%></strong>). As tabelas envolvidas nesta delete foram:</p>
                    <ul><%=ucase(strTABLES)%></ul>
                	<p>Abaixo segue, como informação técnica, o LOG de execução de script SQL relativos as deleções paralelas ao trabalho:</p>
					<hr />
					<%=ucase(strVERBOSE)%>
                </div>
                <hr>
                <div><form id="formVERBOSE" action="default.asp">
                <input type="hidden" name="var_chavereg" value="<%=strCOD_EMPRESA%>" />                
                <input class="primary" type="submit" name="btRun" value="OK" />
                </form></div>
                <br>
        </div>
</div>
</body>
</html>
<script type="text/javascript" language="javascript">
document.getElementById("formVERBOSE").submit();
</script>

<%
'athdebug "<hr> [FIM]" , true
'response.Redirect(strLOCATION)
FechaRecordSet objRS
FechaDBConn ObjConn

%>