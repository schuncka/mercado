<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
Dim objConn, objConnSchema, objRS, objRSSchema, strSQL
Dim strDATABASE, arrDATABASE, strSCRIPT, arrSCRIPT, strSTATUS
Dim i

strSCRIPT = Request.Form("var_script")
arrSCRIPT = split(strSCRIPT,";")

arrDATABASE = split(Request.Form("var_database"),",")



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
            <h1><i class="icon-database fg-black on-right on-left"></i>RunScripts</h1>
            <h2>Running . . . </h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>   
        <%
        
        
           ' response.Write(instr(ucase(strSCRIPT), "DROP"))
		'	response.Write(instr(ucase(strSCRIPT), "INNODB"))
        '    Response.End()
            If (instr(ucase(strSCRIPT), "DROP") > 0) OR (instr(ucase(strSCRIPT), "INNODB") > 0)  Then
                Mensagem "Comando DROP e manipula&ccedil;&atilde;o InnoDB n&atilde;o permitidos.", "mysql_database_run.asp?var_acao=form","[ Voltar ]", 1
                Response.End()
            End If					
                    For Each strDATABASE in arrDATABASE				
                        On Error Resume Next
                        strDATABASE = Trim(strDATABASE)		
                        AbreDBConn objConn, strDATABASE
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
                            For Each strSCRIPT in arrSCRIPT					
                              On Error Resume Next					  
                              If Trim(strSCRIPT) <> "" Then
                                Set objRS = objConn.Execute(strSCRIPT)
                                If err.Number <> 0 Then
                                  strSTATUS = "<font color='red'>"&err.Description&"</font>"
                                Else
                                  strSTATUS = "<font color='blue'>"&"Script ran successfully."&"</font>"
                                End If
                    %>
                      <tr>
                        <td width="150" align="right" bgcolor="#CCCCCC"><strong>Script:</strong></td>
                        <td bgcolor="#CCCCCC"><%=strSCRIPT%></td>
                      </tr>
                      <tr>
                        <td width="150" align="right"><strong>Status:</strong></td>
                        <td><%=strSTATUS%></td>
                      </tr>
                    <%
                          End If
                    
                            Next
                            err.Clear
                            
                            End If
                    %>
                    </table>
                    <br />
        <%
                    FechaDBConn objConn
                    Response.Flush
                Next	
        %>
        <div align="center"><input class="primary" type="button" name="btHome" value="Home" onclick="document.location='mysql_database_run.asp';" /></div>
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
            <form name="formrun" action="mysql_database_run.asp" method="post">
            <input type="hidden" name="var_acao" value="RUN" />                
                <div class="padding20" style="border:1px solid #999; width:100%; height:300px; overflow:scroll; overflow-x:hidden;">
            <%
                strSQL = "SELECT DISTINCT SCHEMA_NAME FROM SCHEMATA WHERE SCHEMA_NAME LIKE '%_DADOS%'"
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
                <div>Script (MySQL)</div>
                <br>
                <div><textarea name="var_script" rows="10" style="width:100%;"></textarea></div>
                <hr>
                <div><input class="primary" type="submit" name="btRun" value="Run" /></div>
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