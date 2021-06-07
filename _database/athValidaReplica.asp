
<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%
Dim objConn, objConnSchema, objRS, objRSSchema, strSQL
Dim strDATABASE, arrDATABASE, strSCRIPT, arrSCRIPT, strBgColor
Dim i
Dim arrScodi, arrSdesc

Dim strCLIENTE,strCNPJ,strCONTRATO,strGERENTE, strCheckin, strPath
Dim strToMaster
Dim strIO, strState, strSQLStatus
Dim streDblC
Dim strWebsite


AbreDBConn objConnSchema, "information_schema"


strPath = left(CFG_DB,instr(CFG_DB,"_")-1)
strWebsite = "pvista.proevento.com.br/"&strPath
'response.write(strPath)
'response.End()
strToMaster = getParam("var_tomaster")
response.write(strToMaster)
streDblC    = getParam("var_errorDblC")


If NOT PingSite( strWebsite ) Then    
    streDblC = "erro"
End If
'response.Write("to: " & Session("USER_OCULTO") & strToMaster)
if strToMaster = "sim" Then
	strSQL = "STOP SLAVE"				
	objConnSchema.Execute(strSQL) 
	response.Redirect("http://localhost/" & strPath)
End If

MontaArrySiteInfo arrScodi, arrSdesc

 strCLIENTE = ""
 if ArrayIndexOf(arrScodi,"CLIENTE") <> -1 THEN 
  strCLIENTE = arrSDesc(ArrayIndexOf(arrScodi,"CLIENTE"))
 end if
 
 strCNPJ = ""
 if ArrayIndexOf(arrScodi,"CNPJ") <> -1 THEN 
  strCNPJ = arrSDesc(ArrayIndexOf(arrScodi,"CNPJ"))
 end if
 
 strCONTRATO = ""
 if ArrayIndexOf(arrScodi,"CONTRATO") <> -1 THEN 
  strCONTRATO = arrSDesc(ArrayIndexOf(arrScodi,"CONTRATO"))
 end if
 
 strGERENTE = ""
 if ArrayIndexOf(arrScodi,"GERENTE") <> -1 THEN 
  strGERENTE = arrSDesc(ArrayIndexOf(arrScodi,"GERENTE"))
 end if
 strCheckin = "CLIENTE: " & strCLIENTE & " | CNPJ: " & strCNPJ & " | CONTRATO: " & strCONTRATO & " | GERENTE: " & strGERENTE

%>

<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language="javascript">

function toMaster(){
	var strPass = document.getElementById("var_senha_master").value;
	data = new Date();
	mes = data.getMonth();
	day = data.getDate();
	
	//alert(strPass);//201611102037
	//alert(mes);
	if (mes.toString().length == 1){
		mes = '0'+''+parseInt(data.getMonth()+1);
	}else{ mes = data.getMonth()+1;}
    

	if (day.toString().length == 1){
		day = '0'+''+parseInt(data.getDate());
	}else{ day = data.getDate();}	
	//alert(data.getFullYear() + '' + mes + '' + day +''+ (parseInt(data.getFullYear()) + (parseInt(mes))  + parseInt(data.getDate())));
	if (strPass != '' || !(strPass == nil)) {
    	if ( (strPass == 'chamadeus') || (strPass == data.getFullYear() + '' + mes + '' + day +''+ (parseInt(data.getFullYear()) + (parseInt(mes))  + parseInt(data.getDate()))) ){
			 alert('O servidor foi transformado em MASTER, você será direcionado para a página de login do sistema.');
			 window.location.assign('athValidaReplica.asp');
		}
		else {
			alert("Senha invalida para a data de hoje!");	
		}
	}
}


</script>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
        
        <div class="padding20">
            <h1><i class="icon-database fg-black on-right on-left"></i>Status DBReplication</h1>
            <h2>Login on <%=CFG_DB%></h2><span class="tertiary-text-secondary">(verificação para servidor MySQL slave (replicação))</span>  			
			<h5><i class="icon-stop fg-green on-right on-left"></i>Sincronizado</h5>
            <h5><i class="icon-stop fg-yellow on-right on-left"></i>Sincronizando</h5>
            <h5><i class="icon-stop fg-red on-right on-left"></i>Falha na Sincronização</h5>
            <h5><i class="icon-stop fg-dark on-right on-left"></i>Falha na Conexão</h5>
            <hr>
            <div class="padding10" style="border:1px solid #999; width:100%; height:50px;">
            	<p class="tertiary-text no-margin"><strong>CHECK-IN</strong> <small>(table sys_site_info)</small></p>
				<p class="tertiary-text no-margin"><%=strCheckin%><p>
            </div>
            <br>
<%if streDblC <> "erro" Then%>
            <p class="tertiary-text no-margin" id="dblCheck" style="text-align:left;">
            <iframe id="ifrCheck" name="ifrCheck" style="display:inline; border:none; background-color:transparent; width:100%; height:80px;" src="http://pvista.proevento.com.br/<%=strPath%>/_database/athValidaReplicaDblCheck.asp?var_db=<%=CFG_DB%>&var_checkin=<%=strCheckin%>"></iframe>
			</p> 
<%end if%>         
			<% strSQL = "SHOW SLAVE STATUS"				
  Set objRS = objConnSchema.Execute(strSQL) 
  
            If not objRS.EOF Then				
				strState  = objRS("Slave_IO_State")
				strIO = objRS("Slave_IO_Running")
				strSQLStatus = objRS("Slave_SQL_Running")				
				'teste se o problema esta na conexao de internet strSQLStatus em YES indica q a replicacao nao foi quebrada
				If instr(strState,"Connecting") AND strIO = "No" AND strSQLStatus = "Yes" Then %>
					<div class="padding20">                                            
                        <p class="text-info">Este servidor é um SLAVE, porém sua conexão de internet apresenta instabilidade, em caso de problemas no acesso contatar a equipe técnica.
                                         <br>Caso a conexao tenha sido perdida e não há previsão de retorno clique no link abaixo ou aguarde o retorno da conexão para que seja reestabelcida automaticamente a conexão, será exibida a efetuação sincronização assim que retornar a conexão</p>                                    	
                     </div>
                    <% if Session("USER_OCULTO") then %>
						<div class="padding20">
							<p class="text-info fg-orange">
								<span onClick="javascript:toMaster();" style="cursor:pointer">Clique aqui para tornar esse servidor MASTER</span>                        
							</p>                    
					    </div>
						<%  strBgColor = "bg-red"
							End If				
				End If
				If objRS("Slave_IO_Running") = "No" AND objRS("Slave_SQL_Running") = "No"  Then %>
					<div class="padding20">                                            
                        <p class="text-info">Você está acessando um servidor MASTER, em caso de problemas no acesso contatar a equipe técnica<br>Acesse novamente a pagina de login.</p>                    
                	</div>	
				<% Else
						if strBgColor = "" then
							strBgColor ="bg-green"				
						end if
						If strBgColor = "bg-green" AND objRS("Seconds_Behind_Master") <> "0" Then
							strBgColor = "bg-yellow"
						End If
						If streDblC = "erro" Then
							strBgColor = "bg-dark"
						end if
					%>
						<div id="leitura" name="leitura" class="padding10 <%=strBgColor%>" style="border:1px solid #999; width:100%; height:200px; overflow:scroll; overflow-x:hidden;">
					<%  				
						For i = 0 to objRS.fields.count -1                 
					%>
							<p class="code-text"><%=i%> : <%=objRS.Fields(i).Name%> : <%=objRS(i)%></p>                                  
					<%                        
						Next
					%>
						</div>
						<div class="padding20">
							<p class="text-info">
								Você esta acessando um servidor replicado (SLAVE), caso sua conexão tenha sido interrompida com o servidor principal (MASTER), quando esta for reestabelecida, a sincronização continuará normalmente.
							</p>
							<p class="text-info">
								Em caso de interrupção definitiva da conexão com o servidor MASTER e desejar tornar este servidor ativo, certifique-se de entrar em contato com equipe técnica para o procedimento de inativação do servidor master e promoção destes servidor para MASTER neste caso de contingência.
							</p>
						</div>
                        <% if Session("USER_OCULTO") then 
							'if Session("METRO_USER_OCULTO") then%>
						<div class="padding20">
							<p class="text-info fg-orange">
								<form id="frm_master" name="frm_master" >
                                <p class="text-info">
                                Inserir a senha para transformar em servidor master.<br>
                                Após clique em oks
                                </p>
                                <div class="input-control password" style="width:300px;">
	                                <input type="password" id="var_senha_master" name="var_senha_master" value="">
									<input type="hidden"   id="var_tomaster"     name="var_tomaster" value="sim">
    	                            <button class="btn-reveal"></button>
                                </div>
                                <button class="bg-darkRed fg-white" onClick="toMaster();">OK</button></span>
                                </form>
							</p>                    
						</div>
						<%
							End If
					End If
			End If			
			FechaRecordSet objRS 
            %>                               
                <br>
                <div class="tile-content ">
                    <div class="padding10" >                        
                        <p class="tertiary-text-secondary no-margin"><%="Login at " & Request.ServerVariables("REMOTE_HOST")%> | <%= Request.ServerVariables("SERVER_SOFTWARE")%> | <%=Request.ServerVariables("SERVER_NAME")%> |                         <%= Request.ServerVariables("SERVER_PROTOCOL")%> (<%=Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")%>) / <%="SessionID." & Session.SessionID%></p>
                    </div>
                </div>
                <br>           
        </div>
</div>
</body>
<script type="text/javascript">
  		
	
	setTimeout(function () { 
     // location.reload(true);
	 location.href = "athValidaReplica.asp";
    }, 20 * 1000);
</script>
</html>
<%
'Response.Flush
%>