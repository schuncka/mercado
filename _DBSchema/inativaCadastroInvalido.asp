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
            <h1><i class="icon-database fg-black on-right on-left"></i>Inativa cadastro inválido</h1>
            <h2></h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            

					<%
						strSQL = "SELECT count(*) as qtde from tbl_empresas "
						strSQL = strSQL & " where end_full is null AND email1 is null and email2 is null and fone1 is null and fone2 is null and  fone3 is null and fone4 is null and sys_inativo is null;"
						set objRS = objconn.execute(strSQL)
						if cint(getValue(objRS,"qtde")) > 0 Then %>
		    	            <div class="padding20" style="width:100%; height:200px;">
    	        		    	<p>O sistema registrou a data de inativo (<%=now()%>) para <strong><%=getValue(objRS,"qtde")%></strong> cadastros, na base de dados <strong><%=CFG_DB%></strong>:</p>
                                <p>* São considerados cadastros inativos que nao tenham <strong>ENDEREÇO CADASTRADO</strong>, <strong>NENHUM EMAIL</strong> e <strong>NENHUM TELEFONE</strong> registrados.</p>
								<hr />
							<%
								strSQL = "update tbl_empresas set sys_inativo = now() where end_full is null AND email1 is null and email2 is null and fone1 is null and fone2 is null and  fone3 is null and fone4 is null and sys_inativo is null; "
								objConn.execute(strSQL)
							%>
                             </div>
                        <% else %>
  							   <div class="padding20" style="width:100%; height:200px; overflow:scroll; overflow-x:hidden;">
    	        		    	<p>Não existem registros a serem inativados.</p>								
					<%	end if %>                
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