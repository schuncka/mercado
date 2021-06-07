<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_database/secure.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Const LTB = "sys_site_info" ' - Nome da Tabela...
 Const DKN = "ID_AUTO"      ' - Campo chave...
 Const TIT = "ImportTable"     ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 
 Dim arrICON, arrBG 
 Dim objConn, objRS, objRSAux, strSQL
 Dim strTabela, strArquivo
 Dim arrCOLUNAS, i, n, strCampos, auxAVISO
 Dim cnnExcel, rstExcel, iCols, strCOLUNAS, strCONEXAO 

 AbreDBConn objConn, CFG_DB 
 
 
 
 strSQL="show tables " 
 	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
 'If Not objRS.Eof Then
 ' Tamanho(largura) da moldura gerada ao redor da tabela dos ítens de formulário 
 ' e o tamanho da coluna dos títulos dos inputs
 Const WMD_WIDTH = 580 'Tamanho(largura) da Dialog gerada para conter os ítens de formulário 


 'Dim objConn, objRS, objRSAux, strSQL
 
  strArquivo = GetParam("var_arquivo_excel")
  strTabela = GetParam("var_tabela")

  
 
 AbreDBConn objConn, CFG_DB 

	strSQL="show tables "
 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1
 
' If Not objRS.Eof Then
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 	
	if (validateRequestedFields("form_principal")) { 
		document.form_principal.submit(); 
	} 
}
function aplicar()      { 
  /*document.forminsert.DEFAULT_LOCATION.value="../modulo_SiteInfo/insert.asp"; */
  if (validateRequestedFields("form_principal")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.forminsert.submit(); 
  }
}
function cancelar() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("window.history.back()")
	 else
  		response.write ("window.close();")
  	 end if

 %> 
}
</script>
</head>
<body class="metro">
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">INSERT</span></sup>
</div>
<div class="container padding20">
<form name="form_principal" id="form_principal" action="ImportExcel_exec2.asp" method="post">	    
    <input type="hidden" name="var_arquivo" value="<%=strArquivo%>">
    <input type="hidden" name="var_tabela" value="<%=strTABELA%>">    
    
    <div class="tab-control" data-effect="fade" data-role="tab-control">
                <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
                    <li class="active"><a href="#DADOS">GERAL</a></li>
                </ul>
                <div class="frames">
                    <div class="frame" id="DADOS" style="width:100%;">
                        <h2 id="_default"><%=ucase(strTABELA)%> / <%=strArquivo%></h2>
                        <div class="grid" style="border:0px solid #F00">  
                                
	<%						    Set cnnExcel = Server.CreateObject("ADODB.Connection")
                                'cnnExcel.Open "DRIVER={Microsoft Excel Driver (*.xls)}; DBQ=" & Server.MapPath("..") & "\modulo_importacao\" &strArquivo
								'cnnExcel.Open "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&Server.MapPath("../modulo_importacao/") & "\" & strARQUIVO&";Extended Properties=Excel 12.0"
								strConexao = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source="&Server.MapPath("../modulo_importacao/") & "\" & strARQUIVO&";Extended Properties=Excel 12.0"
								'strCONEXAO = "Provider=MSDASQL;DRIVER={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)}; DBQ=" & Server.MapPath("../modulo_importacao/")  &strArquivo
    							cnnExcel.Open strCONEXAO 
                                Set rstExcel = Server.CreateObject("ADODB.Recordset")
                                rstExcel.Open "SELECT * FROM [PLAN1$]",cnnExcel,adOpenStatic,adLockPessimistic
                                iCols = rstExcel.Fields.Count
                                strCOLUNAS=""
                                For I = 0 To iCols - 1
                                    If Trim(rstExcel.Fields.Item(I).Name)<>"" Then
                                        strCOLUNAS = strCOLUNAS &"|"&Trim(rstExcel.Fields.Item(I).Name)
                                    End If	
                                Next	                                        
                                arrCOLUNAS=Split(strColunas,"|")                                    
                                strSQL="SELECT * FROM " & strTABELA
                                set objRS = Server.CreateObject("ADODB.Recordset")
                                objRS.Open strSQL, objConn                    
                            For i = 0 to objRS.fields.count - 1
                                strCAMPOS=strCAMPOS&objRS.Fields(i).Name&"|"
					%>
                    		<div class="row"> 
                            	<div class="span3"><%=objRS.Fields(i).Name%>:&nbsp;</div>                            	                                
                                <div class="span6">
                                        <input type="hidden" name="var_tipo_<%=objRS.Fields(i).Name%>" value="<%=objRS.Fields(i).type%>" >
                                        	<select name="var_<%=objRS.Fields(i).Name%>" class="input-control text size3">								
                                            <option value="" selected>Selecione o campo</option>
                                            <%for n=0 to Ubound(arrCOLUNAS)	%>
                                            <option value="<%=arrCOLUNAS(n)%>" <% If UCase(objRS.Fields(i).Name) = UCase(arrCOLUNAS(n)) Then Response.Write("selected") End If %>><%=arrCOLUNAS(n)%></option>
                                            <%Next%>	
                                        </select>
                                    <%If objRS.Fields(i).type = 200 or  objRS.Fields(i).type = 202 or objRS.Fields(i).type = 203 Then%>                                                    
                                            <select class="input-control text size2" name="var_upper_<%=objRS.Fields(i).Name%>" >
                                                <option value="N" selected>Padrão</option>
                                                <option value="S">Maiúscula</option>
                                            </select>           
                                    <%Else%>
                                        <input type="hidden" name="var_upper_<%=objRS.Fields(i).Name%>" value="">
                                    <%End If%>                                 
                                 </div>                                 
                             </div><!--FIM ROW LAÇO //-->
                     	<% next %>
                        <div class="row">
                            <div class="span3">Excluir dados existentes:</div>
                            <div class="span6">
                                        <input type="radio" id="var_excluir_dados" name="var_excluir_dados" value="S" />&nbsp;Sim
                                        <input type="radio" id="var_excluir_dados" name="var_excluir_dados" value="N" checked />&nbsp;Não
                             </div>                                                                   
                        </div>
                    </div><!--FIM DIV GRID //--> 
                </div> <!--FIM DIV FRAME //-->         
           </div><!--FIM DIV FRAMES //-->
	</div><!--FIM DIV TAB-CONTROL //-->
 <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
        	<input type="hidden" name="var_campos" value="<%=strCAMPOS%>">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                                                  
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM DIV CONTAINER //-->
</body>
</html>
<%
 'End If
 
 FechaRecordSet objRS
 FechaDBConn objConn
%>	