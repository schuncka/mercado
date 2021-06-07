<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"--> 
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|UPD|", BuscaDireitosFromDB("pax",Session("METRO_USER_ID_USER")), true %>
<%
 Const LTB = "TBL_PAPER_SUB_VALOR"	' - Nome da Tabela...
 Const DKN = "COD_PAPER_CADASTRO"   ' - Campo chave...


 Dim strSQL, objRS, objRSDetail, objRSItem, ObjConn,objLang
 Dim objFSO, objTextStream
 Dim strCOD_PAPER_CADASTRO, strARPEL, strCOD_EMPRESA, strNOMECLI, strEMAIL1 
 Dim strCOD_PAPER, strDT_APRESENTACAO, strFORMA_APRESENTACAO, strSTATUS, strCODSTATUS, flagAVALIACAO
 Dim strCAMPO_VALOR, strCAMPO_VALOR_ORIGINAL, strCAMPO_LABEL_MEMO, flagAVALIACAO_DT, strPAX_UPDATE
 Dim strCAMPO_INSTRUCAO, strOPCAO, strCOD_PAPER_CADASTRO_PAI
 Dim auxFlagObr, i, strBgColor, strAviso, auxHint
 Dim strLOCALE ,strCAMPO_INSTRUCAO_INTL,strCOMBOLIST
 	
 strCOD_PAPER_CADASTRO = getParam("var_chavereg")


 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 strLOCALE = Request.Cookies("METRO_pax")("locale")
 objLang.LoadLang strLOCALE,"../lang/"
 ' -------------------------------------------------------------------------------
 			 
 strSQL = 			"SELECT  TBL_PAPER.COD_PAPER "
 strSQL = strSQL & "        ,tbl_Paper_Status.`STATUS` "
 strSQL = strSQL & "        ,tbl_Paper_Status.PAX_UPDATE "
 strSQL = strSQL & "		,tbl_paper_cadastro.COD_PAPER_STATUS "
 strSQL = strSQL & "		,tbl_paper_cadastro.SYS_COD_PAI "
 strSQL = strSQL & "		,tbl_paper_avaliacao.COD_PAPER_CADASTRO as TEM_AVALIACAO "
 strSQL = strSQL & "		,tbl_Empresas.COD_EMPRESA "
 strSQL = strSQL & "		,tbl_Empresas.NOMECLI "
 strSQL = strSQL & "		,tbl_Empresas.EMAIL1 "
 strSQL = strSQL & "		,TBL_PAPER_CADASTRO.DT_APRESENTACAO "
 strSQL = strSQL & "		,TBL_PAPER_CADASTRO.FORMA_APRESENTACAO "
 strSQL = strSQL & "		,TBL_PAPER.DT_AVALIACAO_INI "
 strSQL = strSQL & " FROM  TBL_PAPER "
 strSQL = strSQL & "		INNER JOIN TBL_PAPER_CADASTRO ON TBL_PAPER.COD_PAPER = TBL_PAPER_CADASTRO.COD_PAPER "
 strSQL = strSQL & "		INNER JOIN tbl_Empresas ON TBL_PAPER_CADASTRO.COD_EMPRESA = tbl_Empresas.COD_EMPRESA "
 strSQL = strSQL & "		LEFT  JOIN tbl_Paper_Status ON tbl_Paper_Cadastro.COD_PAPER_STATUS = tbl_Paper_Status.COD_Paper_Status "
 strSQL = strSQL & "		LEFT  JOIN tbl_paper_avaliacao ON TBL_PAPER.COD_PAPER = tbl_paper_avaliacao.COD_PAPER_CADASTRO "
 strSQL = strSQL & " WHERE TBL_PAPER_CADASTRO.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO

 AbreDBConn objConn, CFG_DB

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
	strCOD_EMPRESA 		  = getValue(objRS,"COD_EMPRESA")
	strNOMECLI 			  = getValue(objRS,"NOMECLI")
	strEMAIL1 			  = getValue(objRS,"EMAIL1")
	strCOD_PAPER	  	  = getValue(objRS,"COD_PAPER")
	strDT_APRESENTACAO	  = getValue(objRS,"DT_APRESENTACAO")
	strFORMA_APRESENTACAO = getValue(objRS,"FORMA_APRESENTACAO")
	strSTATUS			  =	getValue(objRS,"STATUS")
	strCOD_PAPER_CADASTRO_PAI =	getValue(objRS,"SYS_COD_PAI")
	strCODSTATUS		  =	getValue(objRS,"COD_PAPER_STATUS")
	flagAVALIACAO		  =	getValue(objRS,"TEM_AVALIACAO")
	strPAX_UPDATE		  =	getValue(objRS,"PAX_UPDATE")
	if getValue(objRS,"DT_AVALIACAO_INI") <> "" then
	  flagAVALIACAO_DT = (DATE() >= CDate(getValue(objRS,"DT_AVALIACAO_INI")))
	end if

 FechaRecordSet ObjRS

 'Condições bloquear edição:
 '----------------------------------------------------------------------
 '1) o cod_paper_cadastro ter avaliação: COD_PAPER_CADASTRO não pode 
 'constar na tbl_paper_avaliacao (tbl_paper_avaliacao.COD_PAPER_CADASTRO)
 '
 '2) o status do cod_paper_cadastro tem que ser = 0 ("Em análise") 
 'se o COD_PAPER_CADSATRO (tbl_paper_cadastro.COD_PAPER_STATUS) <> 0 
 'não pode editar
 'response.write("DEBUG: flagAVALIACAO [" & flagAVALIACAO & "]  strCODSTATUS [" & strCODSTATUS & "]")
 '
 '3) a DATA de inicio das avaliações já chegou, logo não pode mais editar o paper tbm


 'if ( (CStr(flagAVALIACAO) <> "") OR (CStr(strCODSTATUS) <> "0") OR (flagAVALIACAO_DT) ) then
 'por solicitação natália e POR ENQUANTO trabalhos avaliados podem ser editados
 
 'Agora se houver status atribuído, é possível permitir edição através de campo específico PAX_UPDATE = 1
	if ( (CStr(strCODSTATUS) <> "0") OR (flagAVALIACAO_DT)) then
		If CStr(strPAX_UPDATE) = "0" Then
			strAviso = objLang.SearchIndex("msg_nao_pode_editar",0)	
			Mensagem strAviso, "", "", true
			Response.End()
		End if
	end if
	 
'end if
 '----------------------------------------------------------------------

 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")
 

function MontaField (prTipo, prFieldID, prMaxLeght, prMsg, prHint, prFieldCombo, prFieldValue, prDisabled)
  Dim auxStrField, strOPCAO, objRSItem, strCOD_PAPER_SUB, strCodPaperSub, strFieldName, auxVlrOrig, strDisabled
  strFieldName 	 = replace(prFieldID,"ô","")
  strCodPaperSub = replace(replace(prFieldID,"var_campo_sub_",""),"ô","")
  auxStrField	 = ""
  auxVlrOrig	 = "" 

  If prDisabled = "0" Then
  strDisabled    = " readonly='' "
  Else
  strDisabled    = ""
  End if

  
  if (prFieldValue<>"") then auxVlrOrig = "(original: " & prFieldValue & ")" end if
  Select Case ucase(prTipo) 'prTipo recebo valor do TBL_PAPER_SUB.CAMPO_TIPO 
	Case "T" 'TEXT (input)
		auxStrField = "<p class='input-control text' data-role='input-control' data-hint-position='top' " & prHint & ">"
		auxStrField = auxStrField & "<input type='text' name='" & strFieldName & "' id='" & prFieldid & "' maxlength='" & prMaxLeght &  "' value='" & prFieldValue & "' " & strDisabled & " >" & vbnewline
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & vbnewline
		auxStrField = auxStrField & "</p>"
'		auxStrField = auxStrField & prMsg & "</p>"

	Case "C" 'COMBO From File
		If strDisabled <> "" Then
		auxStrField = "<p class='input-control text' data-role='input-control' data-hint-position='top' " & prHint & ">"
		auxStrField = auxStrField & "<input type='text' name='" & strFieldName & "' id='" & prFieldid & "' maxlength='" & prMaxLeght &  "' value='" & prFieldValue & "' " & strDisabled & " >" & vbnewline
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & vbnewline
		auxStrField = auxStrField & "</p>"
'		auxStrField = auxStrField & prMsg & "</p>"		
		Else
		
		auxStrField = "<p class='input-control select ' data-role='input-control' " & prHint & ">"
		auxStrField = auxStrField &  "<select name='" & strFieldName & "' id='" & prFieldid & "' " & strDisabled & ">" & vbnewline
        If objFSO.FileExists(Server.MapPath("..\..\") & "\subpaper\" & prFieldCombo) Then
		  Set objTextStream = objFSO.OpenTextFile(Server.MapPath("..\..\") & "\subpaper\" & prFieldCombo)
		  Do While not objTextStream.AtEndOfStream
				strOPCAO = objTextStream.ReadLine
				auxStrField = auxStrField & "<option value='" & strOPCAO &"'"
				If Trim(prFieldValue) = Trim(strOPCAO) Then
				 	auxStrField = auxStrField & "selected"
				End If
				auxStrField = auxStrField & ">" & strOPCAO & "</option>" & vbnewline
		  Loop
		  objTextStream.Close
		  Set objTextStream = Nothing
        End If
		auxStrField = auxStrField & "</select>" & vbnewline 
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & vbnewline      
		auxStrField = auxStrField & "</p>"
		'auxStrField = auxStrField & prMsg & "</p>"
		End if
	Case "D" 'COMBO from Database - TBL_PAPER_SUB_ITEM
	If strDisabled <> "" Then
		auxStrField = "<p class='input-control text' data-role='input-control' data-hint-position='top' " & prHint & ">"
		auxStrField = auxStrField & "<input type='text' name='" & strFieldName & "' id='" & prFieldid & "' maxlength='" & prMaxLeght &  "' value='" & prFieldValue & "' " & strDisabled & " >" & vbnewline
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & vbnewline
		auxStrField = auxStrField & "</p>"
'		auxStrField = auxStrField & prMsg & "</p>"
	Else
		auxStrField = "<p class='input-control select' data-role='input-control' data-hint-position='top'" & prHint & ">"
		auxStrField = auxStrField &  "<select name='" & strFieldName & "' id='" & prFieldid & "' " & strDisabled & ">" & vbnewline
		strSQL = "SELECT SIGLA, ITEM, ITEM_US, ITEM_ES FROM TBL_PAPER_SUB_ITEM WHERE COD_PAPER_SUB = " & strCodPaperSub & " ORDER BY ORDEM"
		Set objRSItem = objConn.Execute(strSQL)
		Do While not objRSItem.EOF
			strOPCAO = getValue(objRSitem,"ITEM")
			auxStrField = auxStrField & "<option value='" & strOPCAO &"'"
			If Trim(prFieldValue) = Trim(strOPCAO) Then
			 	auxStrField = auxStrField & "selected"
			End If
			auxStrField = auxStrField & ">" & strOPCAO & "</option>" & vbnewline
			athMoveNext objRSItem, ContFlush, CFG_FLUSH_LIMIT
		Loop
		auxStrField = auxStrField & "</select>" & vbnewline 
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & vbnewline		      
		auxStrField = auxStrField & "</p>"
		'auxStrField = auxStrField & prMsg & "</p>"
		FechaRecordSet objRSItem
	End if
	Case "R" 'Radio from Database - TBL_PAPER_SUB_ITEM
		auxStrField = "<p>"
		strSQL = "SELECT SIGLA, ITEM, ITEM_US, ITEM_ES, COD_PAPER_SUB FROM TBL_PAPER_SUB_ITEM WHERE COD_PAPER_SUB = " & strCodPaperSub & " ORDER BY ORDEM"
		Set objRSItem = objConn.Execute(strSQL)
		Do While not objRSItem.EOF
			strOPCAO = getValue(objRSitem,"ITEM")
			auxstrField = auxStrField & "<div class='input-control radio margin10' data-role='input-control' data-hint-position='top'" & prHint & ">"
			auxstrField = auxStrField & " <label>" & strOPCAO & vbnewline 
			auxStrField = auxStrField & "  <input type='radio' name='" & strFieldName & "' id='" & prFieldid & "' value='" & strOPCAO & "' "
			If Trim(prFieldValue) = Trim(strOPCAO) Then
			 	auxStrField = auxStrField & " checked "
			End If
			auxStrField = auxStrField & " " & strDisabled & " >"			
			auxStrField = auxStrField & "  <span class='check'></span>" & vbnewline 
			auxStrField = auxStrField & " </label>" & vbnewline
			auxStrField = auxStrField & "</div>" & vbnewline
			athMoveNext objRSItem, ContFlush, CFG_FLUSH_LIMIT
		Loop
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & vbnewline		
		auxStrField = auxStrField & "</p>"
		'auxStrField = auxStrField & prMsg & "</p>"
		FechaRecordSet objRSItem
					  
	Case "M" 'MEMO (textarea)
		auxStrField = "<div class='input-control textarea'>"
		auxStrField = auxStrField & "<textarea type='text' name='" & strFieldName & "' id='" & prFieldid & "'  data-hint-position='top' " & prHint & " value='" & prFieldValue & "' "
		auxStrField = auxStrField & " onKeyDown='MaxLenghtTextArea(this," & prMaxLeght & ");'" & strDisabled & ">" & prFieldValue & "</textarea>"
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & prMsg &  vbnewline
		auxStrField = auxStrField & " <span id='contChar'></span></div>"    
           				      
    Case "F" 'FILE
	    If strDisabled <> "" Then
		auxStrField = "<p class='input-control text' data-role='input-control' data-hint-position='top' " & prHint & ">"
		auxStrField = auxStrField & "<input type='text' name='" & strFieldName & "' id='" & prFieldid & "' maxlength='" & prMaxLeght &  "' value='" & prFieldValue & "' " & strDisabled & " >" & vbnewline
		'auxStrField = auxStrField & "<span class='tertiary-text-secondary'>" & auxVlrOrig & "</span>" & vbnewline
		auxStrField = auxStrField & "</p>"
'		auxStrField = auxStrField & prMsg & "</p>"
		Else
		auxStrField = "<p class='input-control text' data-role='input-control' data-hint-position='top' " & prHint & ">"
		auxStrField = auxStrField &  "<input type='text' name='" & strFieldName & "' id='" & prFieldid & "' maxlength='" & prMaxLeght &  "' value='" & prFieldValue & "' readonly >" & vbnewline 
		auxStrField = auxStrField &  "<button class='btn-file' onClick=""javascript:UploadImage('formupdate','" & Server.URLEncode(prFieldid) & "','\\subpaper\\upload\\','" & strCOD_EMPRESA & "_" & strCodPaperSub &"_',"&prMaxLeght&" ); return false;""></button>"
		auxStrField = auxStrField & "</p>"
		'auxStrField = auxStrField & prMsg & "</p>"
		End if
				
  End Select  
  
  MontaField = auxStrField
end function

%>
<html>
<head >
<title>pVISTA.PAX Edit<%=Session("NOME_EVENTO")%> </title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<!-- funções para action dos botões OK, APLICAR,CANCELAR  e NOTIFICAÇÂO//-->
<script type="text/javascript" language="javascript">
<!-- 
function MaxLenghtTextArea(prCampo, prLimite=0){
 var valor = prCampo.value;
 var limite = parseInt(prLimite);
 //alert (valor.length + " - " + limite );
 document.getElementById("contChar").innerHTML = "(" + valor.length + ")"
 if ( (valor.length > limite) && (limite > 0) ){
	alert ("Quantidade máxima de caracters permitida é " + prLimite + ".");
	return false;
 }
 return true;
}
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() {
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='default.asp';") 
	 else
  		response.write ("document.formupdate.DEFAULT_LOCATION.value='../../_database/athWindowClose.asp';")  
  	 end if
 %>  
	/*document.formupdate.DEFAULT_LOCATION.value="../_database/athWindowClose.asp"; */
	if (validateRequestedFields("formupdate")) { 
		document.formupdate.submit(); 
	} 
}
function aplicar()      { 
  document.formupdate.DEFAULT_LOCATION.value="edit_trab.asp?var_chavereg=<%=strCOD_PAPER_CADASTRO%>"; 
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
}

function UploadImage(formname,fieldname,dir_upload, prident, prmaxsize)
{
 var strcaminho = '../../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname + '&var_dir=' + dir_upload + '&id_file=' + prident+'&maxbytes='+prmaxsize;
 window.open(strcaminho,'Imagem','width=520,height=270,top=50,left=50,scrollbars=1');
}

function SetFormField(formname, fieldname, valor) 
{
  console.log("DEBUG: document.[" + formname + "].[" + fieldname + "].value = '[" + valor + "'];");
  if ( (formname != "") && (fieldname != "") && (valor != "") ) 
  {
	eval("document." + formname + "." + fieldname + ".value = '" + valor + "';");
	//document.location.reload();
  }
}
//-->
</script>


<script language="JavaScript">
<!--


function BuscaCadastro(){
	$(document).ready(function(){
				$.ajax({url: "../_ajax/buscaCadastro.asp?var_cod_paper_cadastro=<%=strCOD_PAPER_CADASTRO%>&var_dado="+$("#campoBusca").val(), success: function(result){																									
							if(result.indexOf("err")==0){
								document.getElementById("dados_inserir").innerHTML = "Dado n&atilde;o encontrado ou o autor j&aacute; est&aacute; cadastrado neste trabalho.";
								return false;
							}else{							
								var arrResult = result.split(",");
								var arrDados;
								var i;
								var displayTela = "";
								for (var i = 0; i < arrResult.length; i++) {
									arrDados = arrResult[i].split("|");															
									displayTela += "<div class=\'row\'><div class=\'span1\'><i class=\'icon-plus\' onClick=\'adicionaAutor("+eval(arrDados[0])+")\' style=\'cursor:pointer\')></i> " + arrDados[0] + " - " + arrDados[1] + "</div></div>";
								}
								document.getElementById("dados_inserir").innerHTML = "<div class='\grid\'>"+displayTela+"</div>";;
							}
						}});
		
		});
	
}		

function adicionaAutor(prCodEmpresa){	
	$(document).ready(function(){
				$.ajax({url: "../_ajax/addCadastro.asp?var_cod_paper_cadastro=<%=strCOD_PAPER_CADASTRO%>&var_cod_empresa="+prCodEmpresa, success: function(result){
							
							var arrResult = result.split(",");
							var arrDados;
							var i;
							var displayTela = "<tr><td colspan=2><strong>Autores Cadastrados: </strong></td></tr>";
							var displayTela2 = "";
							for (var i = 0; i < arrResult.length; i++) {
								arrDados = arrResult[i].split("|");															
								if (arrDados[4] != 'principal'){
									displayTela += "<div class=\'row\'><div class=\'span1\'><i class=\'icon-minus\' onClick=\'removeAutor("+eval(arrDados[0])+")\' style=\'cursor:pointer;\'></i>" + arrDados[3] + " - " + arrDados[2] + "</div></div>";
									displayTela2+= arrDados[3] + " - " + arrDados[2] +"<br>";
								}else{
									displayTela += "<div class=\'row\'><div class=\'span1\'><strong>" + arrDados[3] + " - " + arrDados[2] + " - Respons&aacute;vel</strong></div></div>";
									displayTela2+= "<strong>" +arrDados[3] + " - " + arrDados[2] +" - Respons&aacute;vel</strong><br>";
								}
								document.getElementById("dados_inserir").innerHTML = "";																
							}
							document.getElementById("dados_remover").innerHTML = "<div class='\grid\'>"+displayTela+"</div>";
							//self.opener.document.getElementById("exibe_autores").innerHTML = displayTela2;
						}});		
		});
}

function removeAutor(prCodPaperAutor){	
	$(document).ready(function(){
				$.ajax({url: "../_ajax/delCadastro.asp?var_cod_paper_cadastro=<%=strCOD_PAPER_CADASTRO%>&var_cod_paper_autor="+prCodPaperAutor, success: function(result){														
							if (result == "vazio"){
								document.getElementById("dados_remover").innerHTML = "N&atilde;o h&aacute; autores registrados para esse paper.";
								self.opener.document.getElementById("exibe_autores").innerHTML = "";
								return false;
							}
							var arrResult = result.split(",");
							var arrDados;
							var i;
							var displayTela = "<div class='\row\'><div class='\span3'\><strong>Autores Cadastrados: </strong></div></div>";
							var displayTela2 = "";
							for (var i = 0; i < arrResult.length; i++) {
								//alert(arrResult[i]);
								arrDados = arrResult[i].split("|");															
								
								if (arrDados[4] != 'principal'){
									displayTela += "<div class=\'row\'><div class=\'span1\'><i class=\'icon-minus\' onClick=\'removeAutor("+eval(arrDados[0])+")\' style=\'cursor:pointer;\'></i>" + arrDados[3] + " - " + arrDados[2] + "</div></div>";
									displayTela2+= arrDados[3] + " - " + arrDados[2] +"<br>";
								}else{
									displayTela += "<div class=\'row\'><div class=\'span1\'><strong>" + arrDados[3] + " - " + arrDados[2] + " - Respons&aacute;vel</strong></div></div>";
									displayTela2+= "<strong>" +arrDados[3] + " - " + arrDados[2] +" - Respons&aacute;vel</strong><br>";
								}
							}							
							document.getElementById("dados_remover").innerHTML = "<div class='\grid\'>"+displayTela+"</div>";
							//self.opener.document.getElementById("exibe_autores").innerHTML = displayTela2;
						}});		
		});
}


//-->
</script>



</head>
<body class="metro">
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkCobalt fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=objLang.SearchIndex("mini_paper",0)%>&nbsp;<sup><span style="font-size:12px">UPDATE</span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->

<div class="container padding20">      	
<!--div class TAB CONTROL --------------------------------------------------//-->
    <form name="formupdate" id="formupdate" action="edit_Trabexec.asp" method="post">
    <input type="hidden" name="DEFAULT_TABLE"    value="<%=LTB%>">
    <input type="hidden" name="DEFAULT_DB"		 value="<%=CFG_DB%>">
    <input type="hidden" name="FIELD_PREFIX"	 value="DBVAR_">
    <input type="hidden" name="RECORD_KEY_NAME"  value="<%=DKN%>">
    <input type="hidden" name="RECORD_KEY_VALUE" value="<%=strCOD_PAPER_CADASTRO%>">
    <input type="hidden" name="DEFAULT_LOCATION" value="">
    <input type="hidden" name="DEFAULT_MESSAGE"  value="NOMESSAGE">
    <input type="hidden" name="var_cod_paper_cadastro" value="<%=strCOD_PAPER_CADASTRO%>">
    <div class="tab-control" data-effect="fade" data-role="tab-control">
        <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS"><%=strCOD_PAPER_CADASTRO%>.<%=ucase(objLang.SearchIndex("dialog_geral",0))%></a></li>
            <!--<li class="#"><a href="#DETAILS">DETALHES</a></li>//-->
            <li class="#"><a href="#RECOMENDACOES"><%=ucase(objLang.SearchIndex("dialog_recomendacoes",0))%></a></li>
			<li class="#"><a href="#AUTORES"><%=ucase(objLang.SearchIndex("dialog_autores",0))%></a></li>
        	<li class="#"><a href="#HISTORICO"><%=ucase(objLang.SearchIndex("dialog_historico",0))%></a></li>
        </ul>
        
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <!--  solicitado para comentar isso num primeiro momento... 02/06/2016
                <h2 id="_default">
                    <p>Nome: <%'="(" & strCOD_EMPRESA & ") " & strNOMECLI %></p>
                    <p>E-mail: <%'=strEMAIL1%></p>    
                    <p>Data Apresentação:<%'=PrepData(strDT_APRESENTACAO,True,False)%></p>
                    <p>Forma Apresentação:<%'=strFORMA_APRESENTACAO%></p>
                    <p>Status:<%'=strSTATUS%></p>
                </h2>
                //-->

                <div class="grid" style="border:0px solid #F00">  
                <!-- INI: Novo trecho para EDITAR o conteúdo dos campos do TRABALHO ----------------------------------- //-->        
                <%
                    strSQL =          " SELECT TBL_PAPER_SUB.CAMPO_TIPO, TBL_PAPER_SUB.CAMPO_NOME, TBL_PAPER_SUB.CAMPO_NOME_INTL, TBL_PAPER_SUB_VALOR.CAMPO_VALOR, TBL_PAPER_SUB_VALOR.CAMPO_VALOR_ORIGINAL, TBL_PAPER_SUB.CAMPO_LABEL_MEMO, "
                    strSQL = strSQL & "        TBL_PAPER_SUB.COD_PAPER_SUB, TBL_PAPER_SUB.CAMPO_ORDEM, TBL_PAPER_SUB.CAMPO_REQUERIDO, TBL_PAPER_SUB.CAMPO_COMBOLIST,TBL_PAPER_SUB.CAMPO_COMBOLIST_INTL, TBL_PAPER_SUB.SHOW_MODO_HINT, TBL_PAPER_SUB.CAMPO_INSTRUCAO,TBL_PAPER_SUB.CAMPO_INSTRUCAO_INTL, TBL_PAPER_SUB.CAMPO_TIPO, TBL_PAPER_SUB.CAMPO_HTML, TBL_PAPER_SUB.CAMPO_TAMANHO, TBL_PAPER_SUB.CAMPO_PROEVENTO, TBL_PAPER_SUB.EDITAR_CAMPO_PAX "
                    strSQL = strSQL & "   FROM TBL_PAPER_SUB LEFT JOIN TBL_PAPER_SUB_VALOR ON TBL_PAPER_SUB.COD_PAPER_SUB = TBL_PAPER_SUB_VALOR.COD_PAPER_SUB AND TBL_PAPER_SUB_VALOR.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
                    strSQL = strSQL & "  WHERE TBL_PAPER_SUB_VALOR.COD_PAPER_CADASTRO = " & strCOD_PAPER_CADASTRO
                    strSQL = strSQL & "  ORDER BY TBL_PAPER_SUB.CAMPO_ORDEM, TBL_PAPER_SUB.CAMPO_NOME "
					'athDebug strSQL , false
                    Set objRSDetail = objConn.Execute(strSQL)
                    If not objRSDetail.EOF Then
						Do While not objRSDetail.EOF
							strCAMPO_VALOR		= getValue(objRSDetail,"CAMPO_VALOR")
							strCAMPO_INSTRUCAO 	= getValue(objRSDetail,"CAMPO_INSTRUCAO")
							strCAMPO_INSTRUCAO_INTL 	= getValue(objRSDetail,"CAMPO_INSTRUCAO_INTL")
							auxFlagObr = ""
							auxSTR = ""
							auxHint = ""
	
							If getValue(objRSDetail,"CAMPO_REQUERIDO") Then
							  auxFlagObr = "ô"
							END IF	
							
							if strCAMPO_INSTRUCAO <> "" Then 'campo vazio 
								if strLOCALE = "pt-br" then 'em qual ligua
									If getValue(objRSDetail,"SHOW_MODO_HINT") <> "1" Then ' se o campo hint estiver habilitado
										auxHint = " data-hint='" & Replace(strCAMPO_INSTRUCAO,"'","") & "' "
									else 	
										auxSTR = "<span class='tertiary-text-secondary'>" & strCAMPO_INSTRUCAO & "</span>"
									end if  
								else
									If getValue(objRSDetail,"SHOW_MODO_HINT") <> "1" Then
										auxHint = " data-hint='" & Replace(strCAMPO_INSTRUCAO_INTL,"'","") & "' "
									else 
										auxSTR = "<span class='tertiary-text-secondary'>" & strCAMPO_INSTRUCAO_INTL & "</span>"
									end if  
								 end IF 
							end if  
							 if strLOCALE = "pt-br" Then 
							    strCOMBOLIST = getValue(objRSDetail,"CAMPO_COMBOLIST") 
							 else 
							   strCOMBOLIST = getValue(objRSDetail,"CAMPO_COMBOLIST_INTL") 
							 end if
                %>
							<div class="row">
							  <div class="span2"><p>
							    <%
								  auxStr = replace(replace(getValue(objRSDetail,"CAMPO_NOME"),"[GRP_",""),"]"," - ")
								  if (strLOCALE <> "pt-br") then 
								  	if getValue(objRSDetail,"CAMPO_NOME_INTL") <> "" then 
								    	auxStr = replace(replace(getValue(objRSDetail,"CAMPO_NOME_INTL"),"[GRP_",""),"]"," - ")
									end if
								  end if
								  response.write (auxStr)

								%>:
                               </p></div>
							  <div class="span8"><!----(          prTipo         ,                                     prFieldID                       ,         prMaxLeght                   , prMsg , prHint ,                   prFieldCombo         ,             prFieldValue          )//-->
									<%=(MontaField(getValue(objRSDetail,"CAMPO_TIPO"),"var_campo_sub_" & getValue(objRSDetail,"COD_PAPER_SUB") & auxFlagObr, getValue(objRSDetail,"CAMPO_TAMANHO"), auxSTR, auxHint, strCOMBOLIST, getValue(objRSDetail,"CAMPO_VALOR"),getValue(objRSDetail,"EDITAR_CAMPO_PAX") ) )%>							  </div>
							</div> <!--FIM ROW//-->
                <%
							athMoveNext objRSDetail, ContFlush, CFG_FLUSH_LIMIT
						Loop
                    End If
                    FechaRecordSet objRSDetail
                %>
                <!-- FIM: Novo trecho para EDITAR o conteúdo dos campos do TRABALHO ----------------------------------- //-->        
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->
            
            
            <!--
             são dois campos fixos comentados que existem na dialog só do Mauro mas achamos que o aluno nao deve editar para que esta aba apreça novamente descomenta e linha 266 onesta a gua detalhes
            //-->			
            <div class="frame" id="DETAILS" style="width:100%;">
            	<div class="grid">
                	    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dlg_dt_apres",0)%>:</p></div>
                        <div class="span8">
                        	<p class="input-control text" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                <input id="var_dt_apresentacao" name="var_dt_apresentacao" type="text" placeholder="" value="<%=PrepData(strDT_APRESENTACAO,True,False)%>" maxlength="" class=""  >
                                <span class="btn-date"></span>
							</p>
							<span class="tertiary-text-secondary"></span>
                        </div>
                    </div> <!--FIM ROW//-->
                    <div class="row">
                        <div class="span2"><p><%=objLang.SearchIndex("dlg_forma_apres",0)%>:</p></div>
                        <div class="span8">
                            <p class="input-control text " data-role="input-control">
                            	<input type="text" name="var_forma_apresentacao" value="<%=strFORMA_APRESENTACAO%>" class="">
                            </p>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> <!--FIM ROW//-->
                </div>
            </div><!--fim do frame details//-->
            <!--  //-->
            
            
             <div class="frame" id="AUTORES" style="width:100%;">
            	<div class="grid">
                	    <div class="row">
                        <div class="span2"><!--p><%=objLang.SearchIndex("dlg_dt_apres",0)%>:</p//--></div>
                        <div class="span8">
                        	<p class="input-control text">
                                <input onBlur="BuscaCadastro();" name="campoBusca" id="campoBusca" value="" type="text" placeholder="<%=objLang.SearchIndex("dlg_busca_autores",0)%>" maxlength="" class="">
                                <span class="btn-search" onClick="BuscaCadastro();"></span>
							</p>
							<span class="tertiary-text-secondary"></span>
                        </div>
                    </div> <!--FIM ROW//-->
                    <div class="row">
                        <div class="span2"></div>
                        <div class="span8">
                            <div id="dados_inserir" class="text"></div>
                            <div id="dados_remover" class="text"></div>
                            <span class="tertiary-text-secondary"></span>
                        </div>
                    </div> <!--FIM ROW//-->
                </div>
            </div><!--fim do frame autores//-->

            
            <div class="frame" id="RECOMENDACOES" style="width:100%;">
                <div class="grid fluid">
                 <div class="padding20">
                           <!-- <h1><i class="icon-list fg-black on-right on-left"></i>PAX</h1>
                            <h2>Historico de Trabalhos</h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>
                     <hr>         -->
                    <div class="" style="border:0px solid #999; width:100%; height:650px; overflow-x: scroll; overflow-y:scroll;">
                        <table class="tablesort table striped hovered">
                            <!-- Possibilidades de tipo de sort...class="sortable-date-dmy",class="sortable-currency",class="sortable-numeric",class="sortable" //-->
                            <thead>
                                <tr>
                                    <th  class="sortable">RECOMENDACAO</th>                     
                                </tr>
                            </thead>
                            <tbody>
							<%							
							strSQL =          "SELECT * FROM tbl_paper_avaliacao "
							strSQL = strSQL & " WHERE EXPLICACAO IS NOT null and "
							strSQL = strSQL & " (cod_paper_cadastro = " & strCOD_PAPER_CADASTRO & " OR cod_paper_cadastro = " & strCOD_PAPER_CADASTRO_PAI & ")"
							
							Set objRSDetail = objConn.Execute(strSQL)
                            'response.write(strSQL)
							'response.end()
							
                            i = 0
                            Do While Not objRSDetail.EOF
                            strBgColor = "#FFFFFF"         
                            If (i mod 2) = 0 Then strBgColor = "#E0ECF0" End If 
                            %>
                            <tr>
                                <td width='500'  >&nbsp;<%=objRSDetail("EXPLICACAO")%></td>
                            </tr>
                            <%
                            objRSDetail.MoveNext
                            i = i + 1
                            Loop
                            FechaRecordSet objRSDetail
                            %>
                            </tbody>
                            <tfoot>
                                <tr><td colspan="3" bgcolor="#F8F8F8" >&nbsp;</td></tr>
                            </tfoot>
                        </table>
                    </div>
                  </div> 
                </div>

            </div><!--fim do frame \hisorico//-->

            
            <div class="frame" id="HISTORICO" style="width:100%;">
                <div class="grid fluid">
                 <div class="padding20">
                           <!-- <h1><i class="icon-list fg-black on-right on-left"></i>PAX</h1>
                            <h2>Historico de Trabalhos</h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>
                     <hr>         -->
                    <div class="" style="border:0px solid #999; width:100%; height:650px; overflow-x: scroll; overflow-y:scroll;">
                        <table class="tablesort table striped hovered">
                            <!-- Possibilidades de tipo de sort...class="sortable-date-dmy",class="sortable-currency",class="sortable-numeric",class="sortable" //-->
                            <thead>
                                <tr>
                                    <th width="30%" class="sortable">DT</th>
                                    <th width="50%" class="sortable">LOG</th>
                                    <th width="10%" class="sortable">USER</th>                        
                                </tr>
                            </thead>
                            <tbody>
                            <%
                            strSQL = " SELECT tbl_Empresas_Hist.COD_EMPRESA_HIST" & _
                            " ,tbl_Empresas_Hist.COD_EMPRESA" & _
                            " ,tbl_Empresas_Hist.SYS_USERCA AS USUARIO" & _
                            " ,tbl_Empresas_Hist.SYS_DATACA " & _
                            " ,tbl_Empresas_Hist.HISTORICO " & _
                            " FROM tbl_Empresas_Hist" & _
                            " WHERE tbl_Empresas_Hist.COD_EMPRESA = '"&strCOD_EMPRESA&"'" &_
                            "   AND tbl_Empresas_Hist.DT_INATIVO IS NULL " & _
                            " ORDER BY tbl_Empresas_Hist.SYS_DATACA DESC"
                            
                            set objRSDetail = objConn.Execute(strSQL)  
                            
                            i = 0
                            Do While Not objRSDetail.EOF
                            strBgColor = "#FFFFFF"         
                            If (i mod 2) = 0 Then strBgColor = "#E0ECF0" End If 
                            %>
                            <tr>
                                <td width='130'   nowrap>&nbsp;<%=PrepData(objRSDetail("SYS_DATACA"),True,True)%></td>
                                <td width='500'  >&nbsp;<%=objRSDetail("HISTORICO")%></td>
                                <td width='130'  >&nbsp;<%=objRSDetail("USUARIO")%></td>
                            </tr>
                            <%
                            objRSDetail.MoveNext
                            i = i + 1
                            Loop
                            FechaRecordSet objRSDetail
                            %>
                            </tbody>
                            <tfoot>
                                <tr><td colspan="3" bgcolor="#F8F8F8" >&nbsp;</td></tr>
                            </tfoot>
                        </table>
                    </div>
                  </div> 
                </div>

            </div><!--fim do frame \hisorico//-->
            
		</div><!--FIM - FRAMES//-->
    	<div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
            <div style="float:left">
                <input  class="primary" type="button"  value="OK"        onClick="javascript:ok();return false;">
                <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
                <input  class=""        type="button"  value="<%=ucase(objLang.SearchIndex("dialog_but_aplicar",0))%>"   onClick="javascript:aplicar();return false;">                   
            </div>
            <div style="float:right">
                <small class="text-left fg-teal" style="float:right"> <strong>*</strong><%=objLang.SearchIndex("campo_obrigatorio",0)%></small>
            </div> 
    	</div><!--FIM: BOTÕES/MENSAGENS //-->   
        
	</div><!--FIM TABCONTROL //--> 
    </form>
</div><!--FIM ----DIV CONTAINER//-->

<script language="JavaScript">
//faz a carga inicial caso tenha autores jÃ¡ registrado para esse paper
$(document).ready(function(){
				$.ajax({url: "../_ajax/cargaInicial.asp?var_cod_paper_cadastro=<%=strCOD_PAPER_CADASTRO%>", success: function(result){														
							if (result == "vazio"){
								document.getElementById("dados_remover").innerHTML = "N&atilde;o h&aacute; autores registrados para esse paper.";
								//self.opener.document.getElementById("exibe_autores").innerHTML = "";
								return false;
							}
							var arrResult = result.split(",");
							var arrDados;
							var i;
							var displayTela = "<div class='\row\'><div class='\span3'\><strong>Autores Cadastrados: </strong></div></div>";
							
							for (var i = 0; i < arrResult.length; i++) {								
								arrDados = arrResult[i].split("|");															
								if (arrDados[4] != 'principal'){
									displayTela += "<div class=\'row\'><div class=\'span1\'><i class=\'icon-minus\' onClick=\'removeAutor("+eval(arrDados[0])+")\' style=\'cursor:pointer;\'></i>" + arrDados[3] + " - " + arrDados[2] + "</div></div>";
								}else{
									displayTela += "<div class=\'row\'><div class=\'span1\'><strong>" + arrDados[3] + " - " + arrDados[2] + " - Respons&aacute;vel</strong></div></div>";
								}								
							}
							document.getElementById("dados_remover").innerHTML = "";
							document.getElementById("dados_remover").innerHTML = "<div class='\grid\'>"+displayTela+"</div>";							
						}});		
		});

</script> 

<%
 set objLang = Nothing
 FechaDBConn ObjConn
%>