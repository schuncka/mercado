	<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INATIVA|", BuscaDireitosFromDB("modulo_evento", Session("METRO_USER_ID_USER")), true %>
<%
'------------------------------------------------------------
Dim ObjConn, objRS, strSQL, objRSProd, objRSDetail

AbreDBConn objConn, CFG_DB
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
            <h1><i class="icon-database fg-black on-right on-left"></i>PREENCHE NOME CREDENCIAL DOS CONTATOS</h1>
            <h2></h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            

					<%
						strSQL = "UPDATE tbl_empresas set NOMEFAN = CONCAT(substring_index(ltrim(NOMECLI), ' ', 1),' ',substring_index(rtrim(NOMECLI), ' ', -1) ) where NOMEFAN is null AND tipo_pess = 'S';"
						set objRS = objconn.execute(strSQL)
						
						strSQL = "update tbl_empresas_sub set nome_credencial = CONCAT(substring_index(ltrim(Nome_Completo), ' ', 1),' ',substring_index(rtrim(Nome_Completo), ' ', -1) ) where nome_credencial is null;"
						set objRS = objconn.execute(strSQL)
					%>
		    	            <div class="padding20" style="width:100%; height:200px;">
    	        		    	<p>Nomes de credencial da base de dados <strong><%=CFG_DB%></strong> preenchidos com sucesso.</p>
                                <p>* São considerados cadastros onde o campo nome credencial está vazio.</p>							
                            </div>         
             <hr>
                
        </div>
</div>
</body>
</html>


<%
'athdebug "<hr> [FIM]" , true
'response.Redirect(strLOCATION)

'FechaRecordSet ObjRS
FechaDBConn ObjConn
%>