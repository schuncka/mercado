<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_database/secure.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DIR|", BuscaDireitosFromDB("modulo_Usuario",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"           ' - Default do Modulo...
 Const LTB = "tbl_usuario"	     ' - Nome da Tabela...
 Const DKN = "COD_USUARIO"       ' - Campo chave...
 Const DLD = "../modulo_usuario" ' "../evento/data.asp" - 'Default Location
 Const TIT = "Usuário"           ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Dim WMD_WIDTH, WMD_WIDTHTTITLES
 WMD_WIDTH = 630
 WMD_WIDTHTTITLES = 100
 ' -------------------------------------------------------------------------------

  Dim ObjConn, objRS, objRS2, objRS3, strSQL
  Dim strIDUSER, strIDAPP, auxSTR2, arrAUX, strCOLOR, Cont, intCodUser , aucQtdeDir,strSQL2
  

  
  intCodUser	= GetParam("var_chavereg")
  AbreDBConn objConn, CFG_DB 
  
  if intCodUser = "" then
	   Mensagem "Usuário não possui CÓDIGO.", "","", true 
	  'response.write("Sem codigo de usuario") 'ELITON: COLOCAR A FUNCAO MENSAGEM!!!!
	  'response.End()
  Else
	  strSQL = "SELECT ID_USER,COD_USUARIO from tbl_usuario WHERE cod_usuario = " & intCodUser
	  Set objRS = objConn.execute(strSQL)
	  strIDUSER = getValue(objRS,"ID_USER")
  End If  
  
  if strIDUSER = "" Then
  	  Mensagem "Usuário não possui ID.", "","", true 
	  'response.write("ID do uduario não encontrado.") 'ELITON: COLOCAR A FUNCAO MENSAGEM!!!!
	  'response.End()
  End If
  
  
%>
<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script>
var i=0;
var flagOk=false;
//****** Funções de ação dos botões - Início ******
function ok()       { flagOk = true; submeterForm();setTimeout("window.close()",1580); return false;}
function cancelar() { parent.frames["vbTopFrame"].document.form_principal.submit(); }
function aplicar()  { flagOk = true; submeterForm(); }

function submeterForm() {
	if (i<document.forms.length) 
	{ 
		document.forms[i].var_todos.value = 'T'; 
		document.forms[i].submit();
	
	}
	
	}
	//****** Funções de ação dos botões - Fim ******
function SomaIGrava() { i++; submeterForm(); }
function Recarrega()  { 
		document.location = "DireitosFull.asp?var_iduser=<%=strIDUSER%>"
	
	}
	/*function closeLaterNSaveNow()
{
  setTimeout("window.close()",5000);
  document.form.submit();
}*/
function marcarTodos(strDesmarca){ 
var formularios = document.forms.length;
var i;
var j;
   for (j=0;j<document.forms.length;j++){
	   i=0;
	   for (i=0;i<document.forms[j].elements.length;i++) {
		 if(document.forms[j].elements[i].type == "checkbox")	
			 if (strDesmarca == "sim"){
				document.forms[j].elements[i].checked=false;
			 }else{document.forms[j].elements[i].checked=true;}
		}
	}
	//document.getElementById("var_direitos").checked=true;
} 
</script>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">DIREITOS</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
            <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                <li class="active"><a href="#DADOS"><%=intCodUser%>.GERAL</a></li>
                <li class=""><a href="#LEGENDA">LEGENDA</a></li>
            </ul>
            <div class="frames">
                <div class="frame" id="DADOS" >
                <%%>
                 <!--h2 id="_default">Usuario:<strong><'%=getValue(objRS,"ID_USER")%></strong></h2//-->					
					<span style="cursor:pointer;" onClick="javascript:marcarTodos();"><i class="icon-checkbox" style="cursor:pointer;"></i>Marcar Todos</span>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="cursor:pointer;" onClick="javascript:marcarTodos('sim');"><i class="icon-checkbox-unchecked" style="cursor:pointer;"></i>Desmarcar Todos</span>
                    <div class="grid">
                        <div class="row">
                        	<div class="span8">
                            <%
									'RBS solicitou tirar acesso do modulo de setup de evento para os demais usuarios (proevento ja tem por default)
                                     strSQL="SELECT DISTINCT (ID_APP) FROM SYS_APP_DIREITO WHERE ID_APP NOT LIKE 'modulo_Evento' ORDER BY ID_APP "
									 
                                     set objRS = objConn.execute(strSQL)
                                     while not objRs.EOF
                                     strIDAPP = GetValue(objRS,"ID_APP")
                                
                                %> 
                                <!--INI div nome modulo//-->
							<div class="row">
                                <div class="span3" valign="middle" style="text-align:left; vertical-align:top" title="<%=strIDAPP%>"><p><strong><%=replace(strIDAPP,"modulo_","")%></strong></p></div>
                               
    <!--FIM div nome modulo//-->  
    <!--INI div nome marcação//--> 
                                    <div class="span5">
                                      <form name="formdir_<%=strIDAPP%>" id="formdir_<%=strIDAPP%>" action="DireitosExec.asp" method="post" target="pVISTAIframeSave_<%=strIDAPP%>" >
                                      <input type="hidden" name="var_iduser" value="<%=strIDUSER%>">
                                      <input type="hidden" name="var_idapp"  value="<%=strIDAPP%>">
                                      <input type="hidden" name="var_todos"  value="F">
                                      <input type="hidden" name="DEFAULT_LOCATION" value="">
                                      <tr>
                                    <%
                                      auxSTR2 = ""
                                      strSQL = " SELECT T2.ID_DIREITO FROM SYS_APP_DIREITO_USUARIO T1, SYS_APP_DIREITO T2, TBL_USUARIO T3 "						  
                                      strSQL = strSQL & "  WHERE T3.COD_USUARIO = " & intCodUser 
                                      strSQL = strSQL & "    AND T2.ID_APP = '" & strIDAPP & "' AND T1.COD_APP_DIREITO = T2.COD_APP_DIREITO"
                                      strSQL = strSQL & "    AND T1.ID_USER = T3.ID_USER"
                    
                                      set objRS3 = objConn.execute(strSQL)
                                      while not objRS3.EOF
                                        auxSTR2 = auxSTR2 & getValue(objRS3,"ID_DIREITO") & "|"
                                        objRS3.MoveNext
                                      Wend					  
                                      FechaRecordSet objRS3
                                      arrAux = split(auxSTR2,"|")
                                      
                                      aucQtdeDir = 0  
                                      strSQL2="SELECT count(*) as qtdedir FROM SYS_APP_DIREITO, SYS_DIREITO WHERE SYS_APP_DIREITO.ID_DIREITO = SYS_DIREITO.ID_DIREITO AND ID_APP='" & strIDAPP & "' "
                                      set objRS2 = objConn.execute(strSQL2)
                                      if not objRS2.EOF then
                                        aucQtdeDir = getValue(objRS2,"qtdedir")
                                      end if 
                                      FechaRecordSet objRS2
                                      
        
                                      strSQL="SELECT SYS_APP_DIREITO.ID_DIREITO, SYS_DIREITO.DESCRICAO, SYS_APP_DIREITO.COD_APP_DIREITO " &_
                                             "  FROM SYS_APP_DIREITO, SYS_DIREITO " &_ 
                                             " WHERE SYS_APP_DIREITO.ID_DIREITO = SYS_DIREITO.ID_DIREITO " &_ 
                                             "   AND ID_APP='" & strIDAPP & "' " &_
                                             " ORDER BY SYS_DIREITO.ORDEM "
                                      'athDebug strSQL, true 
                                      set objRS2 = objConn.execute(strSQL)
                                      Cont = 1 
                                      while not objRS2.EOF
                                    %>
                                    <td height="20" align="left" valign="top" nowrap="nowrap">
                                      <input  type="checkbox" id="var_direitos" name="var_direitos" class="inputclean" style="height:12px; width:12px; background-color:<%=strCOLOR%>;" title="<%=getValue(objRS2,"DESCRICAO")%>" value="<%=getValue(objRS2,"COD_APP_DIREITO")%>"
                                      <% if ArrayIndexOf(arrAUX,getValue(objRS2,"ID_DIREITO")) <>-1 then response.write "checked"%>>
                                    </td>
                                    <td align="left" valign="middle" nowrap="nowrap"><%=GetValue(objRS2,"ID_DIREITO")%></td>
                                    <% if ( Cint(Cont) = Cint(aucQtdeDir) ) then %>
    
                                    <td align="center" valign="middle" nowrap="nowrap">&nbsp;
                                    <!--INI  icone acao e confirmação//-->
                                         <button class="mini bg-white "onClick="javascript:document.formdir_<%=strIDAPP%>.submit();" value=""><i class="icon-floppy fg-darkBlue"></i></button>&nbsp;
                                         <iframe id="pVISTAIframeSave_<%=strIDAPP%>" frameborder="0" width="40" height="20" name="pVISTAIframeSave_<%=strIDAPP%>" scrolling="no"></iframe>
                                    <!--FIM INI  icone acao e confirmação//--//-->                                        
                                    </td>
                                    <%  end if %>
                                   <%
                                        athMoveNext  objRS2, ContFlush, CFG_FLUSH_LIMIT
                                        if ((Cont mod 5)=0 ) then 
											response.write("</tr><BR><tr>") 
										end if
                                        Cont = Cont + 1
                                      wend
                                      FechaRecordSet objRS2
                                    %>
                                      </tr>
                                   </form>
                                   </div>
                               </div>
                               <!--INI div nome modulo//-->
                                      <%
                                      objRS.movenext
                                     wend
                                     FechaRecordSet objRS
                                    %> 
                                </div>  
                		</div><!--fim: row//-->
        			</div><!--fim: grid//-->
        		</div><!--Fim frame geral//-->
				<div class="frame" id="LEGENDA">
					<h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
						<div class="grid">
							<div class="row">
								<div class="span12">
									<div class="">
									<%
									strSQL = " SELECT ID_DIREITO, DESCRICAO FROM SYS_DIREITO "
									set objRS = objConn.execute(strSQL)

									while not objRS.EOF
									
									response.write "<p><strong>" & getValue(objRS,"ID_DIREITO") & "</strong></p><p>" & getValue(objRS,"DESCRICAO") & "<p>" 
									
									objRS.MoveNext
									Wend	

									FechaRecordSet objRS
									%>
									</div>
								</div>
						</div>
					</div>
				</div>
        </div><!--fim: frames//-->
	</div><!--fim : tab control//--> 
     <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:window.close();">                   
			<input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();">       
		</div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> Marque os acessos que deve ter em cada módulo.</small>
        </div> 
        <br> 
    </div><!--FIM: BOTÕES/MENSAGENS //-->      
</div><!--fim: fim container//-->
<%
  FechaDBConn objConn
%>

</body>
</html>
<!--<span onClick="javascript:ok();" style="cursor:pointer;">[OK]</span>&nbsp;<span onClick="javascript:window.close();" style="cursor:pointer;">[cancelar]</span>
antigo botao de ação//-->