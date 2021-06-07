<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
Dim objConn, objConnSchema, objRS, objRSSchema, strSQL, strDT_INI, strDT_FIM,objRSEvento
Dim strDATABASE, arrDATABASE, strSCRIPT, arrSCRIPT, strSTATUS, arrayDS
Dim i

strSCRIPT = Request.Form("var_script")
arrSCRIPT = split(strSCRIPT,";")

arrDATABASE = split(Request.Form("var_database"),",")

strDT_INI = request.form("var_dt_inicio")
strDT_FIM = request.form("var_dt_fim")
arrayDS = array("Dom","Seg","Ter","Qua","Qui","Sex","Sab")
If Ucase(Session("GRP_USER")) <> "ADMIN" Then 
   Mensagem "Você não esta autorizado a efetuar esta opera&ccedil;&atilde;o.<BR><BR>Usuário = " & Session("ID_USER") , "../default.asp","[ Voltar ]", 1  
Else	
%>

<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>

</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
		<%
          If Request("var_acao") = "RUN" Then
        %>
        
        <div class="padding20">
            <h1><i class="icon-database fg-black on-right on-left"></i>ListaEventosPorCliente</h1>
            <h2>Running . . . </h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>   
          <div id="retorno" class="padding20" style="border:1px solid #999; width:100%; height:600px; overflow:scroll; overflow-x:auto;">
		<%
        
        
         
            'If (instr(ucase(strSCRIPT), "DROP") > 0) OR (instr(ucase(strSCRIPT), "INNODB") > 0)  Then
            '    Mensagem "Comando DROP e manipula&ccedil;&atilde;o InnoDB n&atilde;o permitidos.", "mysql_database_run.asp?var_acao=form","[ Voltar ]", 1
            '    Response.End()
            'End If					
                    For Each strDATABASE in arrDATABASE				
                        On Error Resume Next
                        strDATABASE = Trim(strDATABASE)		
                        AbreDBConn objConn, strDATABASE
                        strSCRIPT =" SELECT COD_EVENTO , NOME, DT_INICIO, DT_FIM FROM tbl_evento WHERE DT_INICIO between '"&PrepDataIve(strDT_INI,false,False)&" 00:00:00' AND '"&PrepDataIve(strDT_FIM,false,False)&" 23:59:59' AND SYS_INATIVO IS NULL ORDER BY DT_INICIO ASC, NOME"
						Set objRSEvento = objConn.Execute(strSCRIPT)
						if Not objRSEvento.EOF Then
									%>
									<table width="100%" border="0" cellpadding="4" cellspacing="0">
									  <tr>
										<td width="150" align="right" bgcolor="#666666"><strong><font color="#FFFFFF">Database:</font></strong></td>
										<td bgcolor="#666666"><font color="#FFFFFF"><%=strDATABASE%></font></td>
									  </tr>
									<% If err.Number <> 0 Then	%>
									  <tr>
										<td width="150" align="right"><strong>Status:</strong></td>
										<td><%=err.Description%></td>
									  </tr>
									<%		
										Else
																
										'For Each strSCRIPT in arrSCRIPT					
										  On Error Resume Next					  
										  If Trim(strSCRIPT) <> "" Then
											Set objRSEvento = objConn.Execute(strSCRIPT)
											If err.Number <> 0 Then
											  strSTATUS = "<font color='red'>"&err.Description&"</font>"
											Else
												Do While not objRSEvento.EOF
													  strSTATUS = strSTATUS & objRSEvento("COD_EVENTO") &" | " & objRSEvento("NOME") &" | " & objRSEvento("DT_INICIO") &"["&arrayDS(weekday(objRSEvento("DT_INICIO"))-1)& "] | " & objRSEvento("DT_FIM") &"["&arrayDS(weekday(objRSEvento("DT_FIM"))-1) &"]<br>"
													  objRSEvento.MoveNext
												Loop
											  'strSTATUS = "<font color='blue'>"&"Script ran successfully."&"</font>"
											End If
								%>
								  
								  <tr>
									<td width="150" align="right"><strong>Eventos:</strong></td>
									<td><font color="blue"><%=strSTATUS%></font</td>
								  </tr>
								<%
									  End If
										strSTATUS = ""
										'Next
										err.Clear
										
										End If
								%>
								</table>
								<br />
        <%				end if 'se tem algo a exibir
                    FechaDBConn objConn
                    Response.Flush
                Next	
        %>
        </div>
        <div align="center"><input class="primary" type="button" name="btHome" value="Home" onclick="document.location='eventosFull.asp';" /></div>
        <br />
       </div>
        <%
          Else
          
          AbreDBConn objConnSchema, "information_schema" 
        %>
        <div class="padding20">
            <h1><i class="icon-database fg-black on-right on-left"></i>RunScripts</h1>
            <h2>Databases pVISTA </h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
            <form name="formrun" action="eventosFull.asp" method="post">
            <input type="hidden" name="var_acao" value="RUN" />                
                <div class="padding20" style="border:1px solid #999; width:100%; height:300px; overflow:scroll; overflow-x:hidden;">
            <%
                strSQL = "SELECT DISTINCT SCHEMA_NAME FROM SCHEMATA WHERE SCHEMA_NAME LIKE '%_DADOS%' AND SCHEMA_NAME not like 'integracao_dados' AND SCHEMA_NAME not like 'integracao_dados' order by 1 "
                Set objRSSchema = objConnSchema.Execute(strSQL)
                If not objRSSchema.EOF Then
                    Do While not objRSSchema.EOF
                        i=i+1 
            %>
                        <div style="width:200px; height:25px; border:0px solid #F00; display:block; float:left;">
                            <input type="checkbox" name="var_database" id="msguid_<%=i%>" value="<%=objRSSchema("SCHEMA_NAME")%>" checked="checked" /> <%=objRSSchema("SCHEMA_NAME")%>                    
                        </div>
            <%
                        objRSSchema.MoveNext
                    Loop
                Else
            %>
            Database name not found.
            <%
                End If
                FechaRecordSet objRSSchema
            %>  
                </div>
                <br>
                <span class="icon-checkbox" onClick="Javascript:data_ToggleCheckAll('msguid_'); return false;" style="cursor:pointer;"></span>&nbsp;Marca/Desmarca TODOS
                <br><br>
                <div><input type="text" name="var_dt_inicio" placeholder="dt inicio 00/00/0000"></div>
				<br><div><input type="text" name="var_dt_fim" placeholder="dt fim 00/00/0000"></div>
				
                <hr>
                <div><input class="primary" type="submit" name="btRun" value="APLICAR" /></div>
            </form>
    
            <%
              End If
            %>
        </div>
</div>
</body>
</html>
<%

End If

Response.Flush
%>