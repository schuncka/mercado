<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_formularios",Session("METRO_USER_ID_USER")), true %> 
<%
 Const MDL = "DEFAULT"			' - Default do Modulo...
 Const LTB = "tbl_formularios" 								    ' - Nome da Tabela...
 Const DKN = "cod_formulario"									        ' - Campo chave...
 Const DLD = "../modulo_AreaRestritaSetup/mini_formularios/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Edição de campos"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 
Dim objRS, objRSDetail, strSQL, objConn
Dim strCOD_FORMAPGTO, strID_DOCUMENTO, strLANG, objRS_LOCAL

strID_DOCUMENTO = request("var_chavereg")

strLANG = GetParam("var_lang")

If strLANG = "" Then
  strLANG = "PT"
End If

AbreDBConn objConn, CFG_DB


If strID_DOCUMENTO <> "" Then
	
	
	strSQL = " SELECT * FROM tbl_formularios WHERE cod_formulario = " & strID_DOCUMENTO
	Set objRS = objConn.execute(strSQL)

	
	strSQL = " SELECT fs.IDAUTO, aserv.titulo, fs.qtde_fixa, fs.ordem  " &_
			 "   FROM tbl_formularios_servicos AS fs left join tbl_aux_servicos as ASERV ON fs.COD_SERV = aserv.COD_SERV " &_
			 "  WHERE fs.COD_FORMULARIO = " & strID_DOCUMENTO &_
			 "  ORDER BY ORDEM, TITULO " 
			 
	Set objRS_LOCAL = objConn.execute(strSQL)
	FechaRecordSet objRS_LOCAL

%>

<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<script src="../../metro-calendar.js"></script>
<script src="../../metro-datepicker.js"></script>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../modulo_AreaRestritaSeup/mini_formularios/default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../_database/athWindowClose.asp';")  
  	 end if
 %> 
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="../modulo_AreaRestritaSetup/mini_formularios/update.asp?var_chavereg=<%=strID_DOCUMENTO%>"; 
  if (validateRequestedFields("formupdate")) { 
	$.Notify({style: {background: 'green', color: 'white'}, content: "Enviando dados..."});
  	document.formupdate.submit(); 
  }
}
function cancelar() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("window.history.back()")
	 else
  		response.write ("window.close();")
  	 end if
 %> 

/*function UploadImage(formname,fieldname, dir_upload) {
		 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
		 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
		
		function SetFormField(formname, fieldname, valor) {
		  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
		  {
			eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
			document.location.reload();
		  }
		}
		
		function joinCategoriaValues () {
			var strCodigos = "";
			var i;
			
			try {
				for(i=0;i<document.formformapgto.var_cod_status_preco.length;i++) {
					strCodigos += (document.formformapgto.var_cod_status_preco[i].checked && i != 0) ? "," : "";
					strCodigos += (document.formformapgto.var_cod_status_preco[i].checked) ? document.formformapgto.var_cod_status_preco[i].value : "";
				}
			}
			catch(err) {
			}
			
			document.formformapgto.dbvar_str_cod_status_preco.value = strCodigos;
			
			strCodigos = "";
			try { 
				for(i=0;i<document.formformapgto.var_preenchimento_obrigatorio.length;i++) {
					strCodigos += (document.formformapgto.var_preenchimento_obrigatorio[i].checked && i != 0) ? "," : "";
					strCodigos += (document.formformapgto.var_preenchimento_obrigatorio[i].checked) ? document.formformapgto.var_preenchimento_obrigatorio[i].value : "";
				}
			}
			catch(err) {
			}
			
			document.formformapgto.dbvar_str_preenchimento_obrigatorio.value = strCodigos;
		}
		
		function UploadImage(formname,fieldname, dir_upload) {
		 var strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload;
		 window.open(strcaminho,'Imagem','width=540,height=260,top=50,left=50,scrollbars=1');
		}
		
		function SetFormField(formname, fieldname, valor) {
		  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
		  {
			eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
			document.location.reload();
		  }
		} 
	
function ToggleCheckAll(formname) 
{
 var i = 0;
 while ( eval("document." + formname + ".msguid_" + i) != null )
  {
   eval("document." + formname + ".msguid_" + i).checked = ! eval("document." + formname + ".msguid_" + i).checked;
   i = i + 1;
  }
}	
function DeleteSelect (formname)
{
 codigos = '';
 var i = 0;
 while ( eval("document." + formname + ".msguid_" + i) != null )
  {
    if (eval("document." + formname + ".msguid_" + i) != null) 
	{
      if (eval("document." + formname + ".msguid_" + i).checked) 
       {
	    if (codigos != '') 
	     {
	      codigos = codigos + ',' + eval("document." + formname + ".msguid_" + i).value;
	     }
	    else
	     {
	      codigos = eval("document." + formname + ".msguid_" + i).value;
	     }
      }
    }
    i = i + 1;
  }
 if (codigos != '') 
 {
  a=confirm("Você quer apagar definitivamente o(s) ítem(ns) selecionado(s)?");
  if (a==true)
  {
    var strpath = '';
  	if (formname == 'form_listaservico')
		strpath = '../_database/athDeleteToDB.asp?default_table=tbl_formularios_servicos' + '&default_db=<%=CFG_DB%>' + '&record_key_name=IDAUTO' + '&record_key_value=' + codigos + '&record_key_name_extra=' + '&record_key_value_extra=' + '&default_location=../arearestritasetup/update_formulario.asp?var_chavereg=<%=strID_DOCUMENTO%>';
	document.location = strpath;
  }
}

return false;
}*/

}
/* FIM: OK, APLICAR e CANCELAR, funções para action dos botões ------- */
</script>
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker( {
	date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
	format: "dd/mm/yyyy", // set output format
	effect: "none", // none, slide, fade
	position: "bottom", // top or bottom,
	locale: "en", // 'ru' or 'en', default is $.Metro.currentLocale
});
</script>

</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
<form name="formupdate" id="formupdate" action="../../_database/athupdatetodb.asp" method="post">
    <input type="hidden" name="DEFAULT_TABLE" value="tbl_formularios">
    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX" value="dbvar_">
    <input type="hidden" name="RECORD_KEY_NAME" value="cod_formulario">
    <input type="hidden" name="RECORD_KEY_VALUE" value="<%=objRS("cod_formulario")%>">
    <input type="hidden" name="DEFAULT_LOCATION" value="">
    <input type="hidden" name="dbvar_num_cod_evento" value="<%=objRS("COD_EVENTO")%>">
    <input type="hidden" name="dbvar_str_lang" value="<%=objRS("LANG")%>">
    
 <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>
        </ul>
        <div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">


                        <div class="row">
                            <div class="span2"><p>*URL:</p></div>
                                <div class="span8">
                                    <div class="input-control select">
                                        <select id="dbvar_str_link" name="dbvar_str_link">
                                            <option selected="selected"><%=objRS("link")%></option>
                                                <%

                                                    Dim objFSO, strPath, objFolder, objItem   
                                                    Dim strFormFolder

                                                    strFormFolder = Session("COD_EVENTO")&lcase(strLANG) 
                                                    strPath = "..\..\arearestrita\"&strFormFolder&"\" 'Tem que terminar com barra
                                                    'response.Write(strPath)
                                                    'response.End()
                                                    Set objFSO    = Server.CreateObject("Scripting.FileSystemObject")
                                                    
                                                    If not objFSO.FolderExists(Server.MapPath(strPath)) Then
                                                        'objFSO.CreateFolder(Server.MapPath(strPath))
                                                        strFormFolder = "forms"
                                                        strPath = "..\..\arearestrita\"&strFormFolder&"\" 'Tem que terminar com barra
                                                    End IF
                                                    
                                                    Set objFolder = objFSO.GetFolder(Server.MapPath(strPath))
                                                    For Each objItem In objFolder.Files
                                                        If (InStr(lcase(objItem.Name),".asp") > 0) and ( left(objItem.Name,1) <> "_" ) and (objItem.Name <> "athFormFunctions.asp" ) and (objItem.Name <> "deletepedido.asp" ) Then
                                                            %> <option value="<%=strFormFolder&"/"&objItem.Name%>"><%=objItem.Name%></option> <%
                                                        End If
                                                    Next 
                                                    Set objItem   = Nothing
                                                    Set objFolder = Nothing
                                                    Set objFSO    = Nothing
                                                %>
                                                
                                        </select>
                                    </div>
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                        </div>   

                        <div class="row">
                            <div class="span2"><p>Rótulo:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control">
                                    <input type="text" name="dbvar_str_rotulo" value="<%=objRS("rotulo")%>">
                                </p>
                                    <span class="tertiary-text-secondary"></span>
                            </div>

                        </div>

                        <div class="row">
                            <div class="span2"><p>Título:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control">
                                    <input id="dbvar_str_titulo" name="dbvar_str_titulo" type="text" placeholder="" value="<%=objRS("titulo")%>" maxlength="250">
                                </p>
                                    <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

                        <%
                            If objRS("LINK") = "forms/form_termo_empresa.asp" Then
                        %>

                        <div class="row">
                            <div class="span2"><p>Tipo Termo:</p></div>
                                <div class="span8"> 
                                    <p>
                                        <input name="dbvar_str_termo_tipo" id="dbvar_str_termo_tipo" type="radio" value="SEGURANCA" <% If getValue(objRS,"TERMO_TIPO") = "SEGURANCA" Then Response.Write("checked") End If %> >
                                                Segurança 

                                        <input name="dbvar_str_termo_tipo" id="dbvar_str_termo_tipo"  type="radio" value="AGENCIA" <% If getValue(objRS,"TERMO_TIPO") = "AGENCIA" Then Response.Write("checked") End If %>>
                                                Agência 
                                                
                                        <input name="dbvar_str_termo_tipo" id="dbvar_str_termo_tipo"  type="radio" value="PRESTADOR" <% If getValue(objRS,"TERMO_TIPO") = "PRESTADOR" Then Response.Write("checked") End If %>>
                                                Prestador de Serviços 
                                    </p>
                                    <span class="tertiary-text-secondary"></span>                             
                                </div>
                        </div>
                        <% End if %>

                        <div class="row">
                            <div class="span2"><p>Instrução:</p></div>
                            <div class="span8">
                                <p class="input-control textarea" data-role="input-control">
                                    <textarea id="dbvar_str_instrucao" name="dbvar_str_instrucao" rows="2" placeholder=""><%=objRS("instrucao")%></textarea>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div><br/>

                        <div class="row">
                            <div class="span2"><p>Rodapé:</p></div>
                            <div class="span8">
                                <p class="input-control textarea" data-role="input-control">
                                    <textarea id="dbvar_str_rodape" name="dbvar_str_rodape" rows="2" placeholder=""><%=objRS("rodape")%></textarea>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div><br/>

                        <div class="row">
                            <div class="span2"><p>Rótulo Internacional:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control">
                                    <input id="dbvar_str_rotulo_intl" name="dbvar_str_rotulo_intl" type="text" placeholder="" value="<%=objRS("rotulo_intl")%>" maxlength="250">
                                </p>
                                    <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Titulo Internacional:</p></div>
                                <div class="span8">
                                    <p class="input-control text" data-role="input-control">
                                    <input id="dbvar_str_titulo_intl" name="dbvar_str_titulo_intl" type="text" placeholder="" value="<%=objRS("titulo_intl")%>" maxlength="250">
                                </p>
                                    <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Instrução Internacional:</p></div>
                            <div class="span8">
                                <p class="input-control textarea" data-role="input-control">
                                    <textarea id="dbvar_str_instrucao_intl" name="dbvar_str_instrucao_intl" rows="2" placeholder=""><%=objRS("instrucao_intl")%></textarea>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div><br/>

                        <div class="row">
                            <div class="span2"><p>Rodapé Internacional:</p></div>
                            <div class="span8">
                                <p class="input-control textarea" data-role="input-control">
                                    <textarea id="dbvar_str_rodape_intl" name="dbvar_str_rodape_intl" rows="2" placeholder=""><%=objRS("rodape_intl")%></textarea>
                                </p>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div><br/>

                        <div class="row">
                            <div class="span2"><p>Dead Line:</p></div>
                                <div class="span8"> 
                                    <div class="input-control text data-role="input-control">                                        
                                        <p class="input-control text span3" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                            <input id="dbvar_date_dt_inativo" name="dbvar_date_dt_inativo" type="text" value="<%=objRS("dt_inativo")%>"placeholder="<%=Date()%>"maxlength="11" class="">
                                            <span class="btn-date"></span>
                                        </p>
                                    </div>    
                                    <span class="tertiary-text-secondary"></span>
                                </div>
                        </div>

                        <div class="row">
                            <div class="span2"><p>Área:</p></div>
                                <div class="span8">
                                <div class="input-control select ">
                                    <select id="dbvar_str_cod_status_cred" name="dbvar_str_cod_status_cred">
                                        <option value="" selected="selected"><%=objRS("cod_status_cred")%></option>
                                        <%
                                            strSQL = "SELECT cod_status_cred, status FROM tbl_status_cred ORDER BY status"
                                            MontaCombo "STR",strSQL, "cod_status_cred","status",""
                                        %>
                                    </select>
                                </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                        </div>

                        <div class="row">
                            <div class="span2"></div>
                                <div class="span4">
                                    <p><strong>Categorias:</strong></p>
                                    
                                        <% 
                                        Dim objRSCat, arrCAT, strCHECKED, i, arrCAT_OBRIGATORIO

                                        strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & Session("COD_EVENTO") & " AND STATUS IS NOT NULL AND CAEX_SHOW = 1 ORDER BY status"
                                        
                                        Set objRSCat = objConn.execute(strSQL)
                                            
                                        Do While Not objRSCat.EOF
                                            arrCAT = Split(""&objRS("cod_status_preco"),",")
                                            strCHECKED = ""
                                            For i = 0 To UBound(arrCAT)
                                                If CStr(arrCAT(i)) = CStr(objRSCat("cod_status_preco")) Then
                                                    strCHECKED = " checked"
                                                End If
                                            Next
                                        %>

                                        <div class="input-control checkbox">
                                        <label style="font-size: 11pt;">
                                            <input type="checkbox" name="dbvar_str_cod_status_preco"<%=strCHECKED%> id="check_sp_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>" onClick="concatenaDadoCheckBox('forminsert','sp_','dbvar_str_cod_status_preco');"><%=objRSCat("status")%>
                                            <span style="margin-top: -8px;" class="check"></span>
                                        </label>
                                        </div><br/>
                                        
                                        <%
                                            objRSCat.MoveNext
                                            Loop
                                        %>
                                    
                                </div>
                                <div class="span2"></div>
                                    <div class="span4">
                                        <p><strong>Obrigatório para:</strong></p>
                                            <% 
                                            strSQL = " SELECT cod_status_preco, status FROM tbl_status_preco WHERE cod_evento = " & Session("COD_EVENTO") & " AND STATUS IS NOT NULL AND CAEX_SHOW = 1 ORDER BY status"
                                            
                                            Set objRSCat = objConn.execute(strSQL)
            
                                            Do While Not objRSCat.EOF
                                                arrCAT_OBRIGATORIO = Split(""&objRS("preenchimento_obrigatorio"),",")
                                                strCHECKED = ""
                                                For i = 0 To UBound(arrCAT_OBRIGATORIO)
                                                    If CStr(arrCAT_OBRIGATORIO(i)) = CStr(objRSCat("cod_status_preco")) Then
                                                        strCHECKED = " checked"
                                                    End If
                                                Next
                                            %>
                                            <div class="input-control checkbox">
                                            <label style="font-size: 11pt;">
                                                <input type="checkbox" name="dbvar_str_preenchimento_obrigatorio"<%=strCHECKED%> id="check_obr_<%=objRSCat("cod_status_preco")%>" value="<%=objRSCat("cod_status_preco")%>" onClick="concatenaDadoCheckBox('forminsert','obr_','dbvar_str_preenchimento_obrigatorio');"> <%=objRSCat("status")%> 
                                                <span style="margin-top: -8px;" class="check"></span>
                                            </label>
                                            </div><br />

                                            <%
                                                objRSCat.MoveNext
                                                Loop
                                            %>
                                            
                                    </div>            
                        </div><!--FIM ROW CHECKBOX//-->

                        <div class="row">
                            <div class="span2" style=""><p>Categoria Aberta:</p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Código
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_bool_show_codigo" value="1" <% If objRS("show_codigo")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_bool_show_codigo" value="0" <% If not objRS("show_codigo")&"" <> "0" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div>
                            </div>

                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Quantidade
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_bool_show_qtde" value="1" <% If objRS("show_qtde")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_bool_show_qtde" value="0" <% If not objRS("show_qtde")&"" <> "0" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div>
                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Valor
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_bool_show_valor" value="1" <% If objRS("show_valor")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_bool_show_valor" value="0" <% If not objRS("show_valor")&"" <> "0" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div>
                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Sub-Total
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_bool_show_subtotal" value="1" <% If objRS("show_subtotal")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_bool_show_subtotal" value="0" <% If not objRS("show_subtotal")&"" <> "0" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div><br/><br/>

                        <div class="row">
                            <div class="span2" style=""><p>Campos Credencial:</p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    E-mail
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_num_show_cred_email" value="1" <% If objRS("show_Cred_email")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_num_show_cred_email" value="0" <% If not objRS("show_Cred_email")&"" <> "0" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Cpf
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_num_show_cred_cpf" value="1" <% If objRS("show_Cred_cpf")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_num_show_cred_cpf" value="0" <% If not objRS("show_Cred_cpf")&"" <> "0" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div>
                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Rg
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_num_show_cred_rg" value="1" <% If objRS("show_Cred_rg")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_num_show_cred_rg" value="0" <% If not objRS("show_Cred_rg")&"" = "1" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div>
                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Cargo
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_num_show_cred_cargo" value="1" <% If objRS("show_Cred_cargo")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_num_show_cred_cargo" value="0" <% If not objRS("show_Cred_cargo")&"" = "1" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div>
                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Entidade
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_num_show_cred_entidade" value="1" <% If objRS("show_Cred_entidade")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_num_show_cred_entidade" value="0" <% If not objRS("show_Cred_entidade")&"" = "1" Then Response.Write("checked") End If %>>
                                            Não 
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div>
                        <div class="row">
                            <div class="span2" style=""></p></div>
                                <div class="span10"> 
                                    <div class="span2">
                                    Fone
                                    </div>
                                    <p>
                                        <input type="radio" name="dbvar_num_show_cred_fone1" value="1" <% If objRS("show_Cred_fone1")&"" = "1" Then Response.Write("checked") End If %>>
                                            Sim 
                                        <input type="radio" name="dbvar_num_show_cred_fone1" value="0" <% If not objRS("show_Cred_fone1")&"" = "1" Then Response.Write("checked") End If %>>
                                        Não
                                    </p>
                                <span class="tertiary-text-secondary"></span>                             
                            </div><br/>
                        </div>

                </div> <!--FIM GRID//-->
        </div><!--fim do frame dados//-->
            
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 

    <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:aplicar();return false;">                   
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>*</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>                    
 
<%
	FechaRecordSet(objRS)
	FechaDBConn(objConn)
End If
%>              
