<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_PAX", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
 Dim objConn, objRS, objLang, strSQL, strLOCALE, objRS2
 
 Dim strCOD_EMP, strIDAUTO_EMP, strIDAUTO_SUB, strCODBARRA_EMP, strCODBARRA_SUB
 Dim strNOMEFAN_EMP, strNOMECRED_SUB
 Dim strIDENTIFICADOR, strEMAIL, strFOTO
 Dim strTIPO_PESS, strTABELA, i
  
 Dim strVLR_PAGO, strVLR_COMPRADO, strSemProduto, strSALDO, strCOD_FORMAPGTO, strTIPO_LOJA, strLINK_BOLETO, flagPALESTRANTE
 'usadas no INCLUDE
 Dim strMsgCateg, strMsgObs, strMsgIcoCor, strMsgLink1, strMsgLink2, strMsgUpload1, strMsgUpload2

 strCOD_EMP 		= getParam("var_cod_emp")
 strIDAUTO_EMP	 	= getParam("var_idauto_emp")
 strIDAUTO_SUB 		= getParam("var_idauto_sub")
 strCODBARRA_EMP 	= getParam("var_codbarra_emp" )
 strCODBARRA_SUB 	= getParam("var_codbarra_sub")
 strNOMEFAN_EMP 	= getParam("var_nomefan_emp")
 strIDENTIFICADOR	= getParam("var_identificador")
 strNOMECRED_SUB	= getParam("var_nomecred_sub")
 strEMAIL			= getParam("var_email")
 strFOTO			= getParam("var_foto")
 strTIPO_PESS		= getParam("var_tipopess_emp") 
 strTABELA			= getParam("var_tabela")

 'athDebug  "[" & strCOD_EMP & "] [" & strIDAUTO_EMP & "] [" & strIDAUTO_SUB & "] [" & strCODBARRA_EMP & "] [" & strCODBARRA_SUB  & "] [" &  strNOMEFAN_EMP & "] [" & strNOMECRED_SUB  & "] [" &  strIDENTIFICADOR & "] [" & strEMAIL  & "] [" &  strTIPO_PESS & "] [" & strTABELA & "]<br><br>", false

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"./lang/"
 ' -------------------------------------------------------------------------------
 
 AbreDBConn objConn, CFG_DB	 
 
 'marca se é palestrante
 strSQL = " SELECT tbl_palestrante.COD_PALESTRANTE from tbl_palestrante where cod_empresa = " & strCOD_EMP & " LIMIT 1 "
 set objRS = objConn.execute(strSQL)	
 flagPALESTRANTE = "disabled" 
 If not objRS.EOF Then
	flagPALESTRANTE = "" 
 End if
 FechaRecordSet ObjRS 
 
	 
 strSQL = " SELECT tbl_Empresas.ID_AUTO "
 strSQL = strSQL & " ,tbl_Empresas.NOMEFAN AS NOME_EMP "
 strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME_CRED "
 strSQL = strSQL & " ,tbl_Empresas.ID_NUM_DOC1  "
 strSQL = strSQL & " ,tbl_Empresas.EMAIL1 AS EMAIL "
 strSQL = strSQL & " ,tbl_Empresas.COD_EMPRESA "
 strSQL = strSQL & " ,tbl_Empresas.NOMECLI "
 strSQL = strSQL & " ,tbl_Empresas.NOMEFAN "
 strSQL = strSQL & " ,tbl_Empresas.IMG_FOTO AS FOTO "
 strSQL = strSQL & " ,tbl_Empresas.TIPO_PESS "
 strSQL = strSQL & " ,tbl_Empresas.SYS_DATACA "
 strSQL = strSQL & " ,tbl_Empresas.SYS_USERCA "
 strSQL = strSQL & " ,tbl_Empresas.SYS_DATAAT "
 strSQL = strSQL & " ,tbl_Empresas.SYS_UPDATE "
 strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO "
 strSQL = strSQL & " ,tbl_Empresas.END_PAIS "
 strSQL = strSQL & " ,tbl_Inscricao.COD_INSCRICAO "
 strSQL = strSQL & " ,tbl_Inscricao.PARCELAS "
 strSQL = strSQL & " ,tbl_Inscricao.INSCR_MASTER " 
 strSQL = strSQL & " ,if(tbl_Inscricao.INSCR_MASTER > 0,tbl_Inscricao.INSCR_MASTER,tbl_Inscricao.COD_INSCRICAO) as INSCR_CHAVE "
 strSQL = strSQL & " ,tbl_Inscricao.CODBARRA "
 strSQL = strSQL & " ,tbl_Inscricao.DT_CHEGADAFICHA "
 strSQL = strSQL & " ,tbl_Inscricao.COD_EVENTO "
 strSQL = strSQL & " ,tbl_Inscricao.COD_FORMAPGTO " 
 strSQL = strSQL & " ,tbl_formapgto.FORMAPGTO " 
 strSQL = strSQL & " ,tbl_Inscricao.COD_STATUS_PRECO "
 strSQL = strSQL & " ,tbl_Inscricao.CHECK_STATUS_PRECO "
 strSQL = strSQL & " ,tbl_Inscricao.COMPROVANTE_CATEGORIA "
 strSQL = strSQL & " ,tbl_Inscricao.COMPROVANTE_CATEGORIA2 "
 strSQL = strSQL & " ,tbl_Inscricao.COD_PAIS "
 strSQL = strSQL & " ,(select cod_palestrante from tbl_palestrante where cod_empresa =  tbl_Empresas.COD_EMPRESA) as PALESTRANTE"
 strSQL = strSQL & " ,tbl_Evento.NOME 				as NOME_EVENTO "
 strSQL = strSQL & " ,tbl_Evento.CIDADE 			as CIDADE_EVENTO "
 strSQL = strSQL & " ,tbl_Evento.ESTADO_EVENTO 		as ESTADO_EVENTO "
 strSQL = strSQL & " ,tbl_Evento.PAVILHAO 			as PAVILHAO_EVENTO "
 strSQL = strSQL & " ,date(tbl_Evento.DT_INICIO)	as DTINI_EVENTO "
 strSQL = strSQL & " ,date(tbl_Evento.DT_FIM) 		as DTFIM_EVENTO "
 If lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
 	strSQL = strSQL & " ,tbl_Status_Preco.STATUS_INTL as CATEGORIA "
 	strSQL = strSQL & " ,tbl_Status_Preco.OBSERVACAO_INTL as CATEGORIA_OBSERVACAO "
 else
 	strSQL = strSQL & " ,tbl_Status_Preco.STATUS as CATEGORIA "
 	strSQL = strSQL & " ,tbl_Status_Preco.OBSERVACAO as CATEGORIA_OBSERVACAO "
 End if	
 strSQL = strSQL & " ,tbl_Status_Preco.UPLOAD_COMPROVANTE " 
 strSQL = strSQL & " ,ifnull(tbl_Status_Preco.QTDE_COMPROVANTE,1) as QTDE_COMPROVANTE " 
 strSQL = strSQL & " ,COALESCE((select SUM(VLR) FROM tbl_Caixa_Sub_INSC where cod_inscricao = tbl_Inscricao.COD_INSCRICAO),NULL,0) as VLR_PAGO "
 strSQL = strSQL & " ,(select SUM(VLR_PAGO) FROM tbl_inscricao_produto where cod_inscricao = tbl_Inscricao.COD_INSCRICAO) as VLR_COMPRA "
 strSQL = strSQL & " FROM ((tbl_Empresas INNER JOIN tbl_Inscricao ON tbl_Empresas.COD_EMPRESA =  tbl_Inscricao.COD_EMPRESA) "
 strSQL = strSQL & "                     INNER JOIN tbl_Evento ON tbl_Inscricao.COD_EVENTO = tbl_Evento.COD_EVENTO) "
 strSQL = strSQL & "                     LEFT JOIN tbl_Empresas_Sub ON tbl_Inscricao.CODBARRA = tbl_Empresas_Sub.CODBARRA "
 strSQL = strSQL & "                     LEFT JOIN tbl_Status_Preco ON tbl_Inscricao.COD_STATUS_PRECO = tbl_Status_Preco.COD_STATUS_PRECO " 
 strSQL = strSQL & "						LEFT JOIN tbl_formapgto ON tbl_formapgto.COD_FORMAPGTO = tbl_Inscricao.COD_FORMAPGTO "
 strSQL = strSQL & " WHERE tbl_Empresas.ID_AUTO = " & strIDAUTO_EMP
 strSQL = strSQL & "   AND tbl_Inscricao.SYS_INATIVO IS NULL "
 If strCODBARRA_SUB <> "" Then
	 strSQL = strSQL & "    AND  tbl_Inscricao.CODbarra = " & strToSQL(strCODBARRA_SUB) 
 End if 			 
 strSQL = strSQL & " ORDER BY  tbl_Inscricao.DT_CHEGADAFICHA DESC "
 '--- limitando a 10 enquanto ainda não criamos a grid de todas as inscrições
 strSQL = strSQL & " LIMIT 10 " 
 'athDebug strSQL, false		
			
 set objRS = objConn.execute(strSQL)	 
%>
<html>
<head>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<style>
a.disabled {
   pointer-events: none;
   cursor: default;
}
</style>
<script src="../_scripts/scriptsCS.js" type="text/javascript" ></script>
<title>PVISTA.PAX - PAINEL</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script type="text/javascript" language="javascript">

function openPopupPage(prUrl, prChaveReg, prCodBarraSub ) {
  /*
  DEBUG: 
  emailVerify('aless...', 'DEBUG: conferindo se a [scriptsCS.js] foi incluída corretamente');
  */
 
  var param = { 'var_chavereg' : prChaveReg , 'var_codbarra_sub' : prCodBarraSub };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}


/* ---  */
function openPopupPage_AGENDA(prUrl, prCodInsc, prCodEvent, prCodEmpresa, prNomeEvento, prCodStatusPreco) {
  var param = { 'var_cod_inscricao' : prCodInsc, 'var_cod_evento': prCodEvent, 'var_cod_empresa': prCodEmpresa, 'var_nome_evento': prNomeEvento, 'var_cod_status_preco': prCodStatusPreco };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

function openPopupPage_ARM(prUrl, prCodInsc, prCodEvent) {
  var param = { 'var_cod_inscricao' : prCodInsc, 'var_cod_evento': prCodEvent };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

function openPopupPage_RECIBO(prUrl, prCodInsc, prCodEvent) {
  var param = { 'var_cod_inscricao' : prCodInsc, 'var_cod_evento': prCodEvent };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

function openPopupPage_CERTIFICADO(prUrl, prCodEmpresa, prCodBarra, prCodInsc, prCodBarraSub) {
  var param = { 'var_chavereg' : prCodEmpresa, 'var_codbarra': prCodBarra, 'var_cod_inscricao': prCodInsc, 'var_codbarra_sub': prCodBarraSub };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

function openPopupPage_NOTAFISCAL(prUrl, prCodInsc) {
  var param = { 'var_cod_inscricao': prCodInsc };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

function openPopupPage_BOLETO(prUrl, prCodInsc, prCodEvent) {
  var param = { 'id' : prCodInsc, 'cod_evento': prCodEvent, 'adm':1 };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

function openPopupPage_BOLETO_BEPAY(prUrl, prCodInsc, prCodEvent) {
  var param = { 'cod_inscricao' : prCodInsc, 'cod_evento': prCodEvent, 'adm':1 };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_MINI_WITH%>, height=<%=CFG_MINI_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

function openPopupPage_DIALOG(prUrl, prChaveReg ) {
  var param = { 'var_chavereg' : prChaveReg };
  MyOpenWindowWithPost(prUrl, "width=<%=CFG_DIALOG_WITH%>, height=<%=CFG_DIALOG_HEIGHT%>, left=50, top=50, resizable=yes, scrollbars=yes", "pVISTANewFile", param);
}

/* ---  */

/* ----------------------------------------------------------------------------------------------------------------------- */
/* INI: Funções utilizadas pelo [_includePainelUploadComprov.asp] -------------------------------------------------------- */
function SetFormField(formname, fieldname, valor) {
  if ( (formname != "") && (fieldname != "") && (valor != "") ) {
    eval("document.getElementById('" + formname + "')." + fieldname + ".value = '" + valor + "';");
	eval("document.getElementById('" + formname + "').var_acao.value = 'COMPROVANTE'");
	var str = formname;
	if (str.indexOf("formcomprovante") >= 0) { 
		eval("document.getElementById('" + formname + "').submit();"); 
	}
  }
}

function UploadArqComprov(formname, fieldname, dir_upload, id_file, tamanho, extensao)
{
 var strcaminho;
 strcaminho = '../athUploader.asp?var_formname=' + formname + '&var_fieldname=' + fieldname; 
 strcaminho = strcaminho  + '&var_dir=' + dir_upload + '&id_file='+id_file +'&maxbytes='+tamanho+'&lng=BR&var_ext='+extensao;
 window.open(strcaminho,'Imagem','width=540,height=250,left=50,top=50,scrollbars=0');
}
/* FIM: Funções utilizadas pelo [_includePainelUploadComprov.asp] -------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------------------------------------- */


</script>
</head>
<body class="metro" style="background:#FFF;; width:100%;">
<div class="padding20"> <!--div principal//-->
            <div class="" style="border:0px solid #F00; width:270px; display: inline-block; float:left;">
            	<!-- INI: Coluna DADOS e MENU ----------------------------------------------------------- //-->
                <div class="grid">
                	<div class="row no-margin">
                        <div class="span6">
							<!-- INI: DADOS -------------------------------------------------------- //-->
                        	<div class="tile double double-vertical" 
                                 style="border:0px solid #CCC; background-color:#F3F3F3; padding:15px; vertical-align:top; cursor:pointer;" 
                                 data-hint="<%=objLang.SearchIndex("edit_perfil",0)%>" data-hint-position="right" 
                                 onClick="openPopupPage_DIALOG('update.asp',<%=strCOD_EMP%>);">
                            		<!-- table>
                                     <TR><TD  class="rounded" width="120" height="120" style="display:table-cell; border:1px solid #F00; background-image:url('../webcam/imgphoto/<%=getValue(objRS,"FOTO")%>'); background-position:center; background-repeat:no-repeat"></TD></TR>
                                    </table //-->
										<%
                                         If (strFOTO = "") Then
                                            strFOTO = "unknownuser.jpg"
                                         End If 
                                        %>
                                		<img src="../webcam/imgphoto/<%=strFOTO%>" class="rounded" width="120" height="120">
                                    <div class="" style="float:right;">
										<p class="fg-gray"><%=objLang.SearchIndex("bemvindo",0)%>! <br> <small><%=strCOD_EMP%></small></p>
                                    </div>
                                    <div style="margin-top:10px;">
                                        <p class="tertiary-text fg-gray">
											<strong><%=strNOMEFAN_EMP%></strong><br>
                                            <%=lcase(strEMAIL)%><br>
                                            <%=strCODBARRA_EMP & " " & strCODBARRA_SUB%><br><br>
                                            <span class="tertiary-text fg-gray">
                                                <%="Login at " & now()%>
                                            </span>
                                        </p>
                                    </div> 
							</div>
							<!-- FIM: DADOS -------------------------------------------------------- //-->                            
                        </div>
                   </div>
                   <div class="row">
                        <div class="span2">
							<!-- INI: MENU LATERAL -------------------------------------------------------- //-->
                            <div style="width:250px;height:288px;">
                                <nav class="sidebar light" >
                                    <ul>
                                        <!-- <li class="title">Items Group 1</li> //-->
                                        <li class="stick bg-red   ">	<a href="#" onClick="openPopupPage('mini_Certificado/',<%=strCOD_EMP%>,'<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("menu_certificados",0)%></a></li>
                                        <li class="stick bg-yellow">	<a href="#" onClick="openPopupPage('mini_Atestado/',<%=strCOD_EMP%>,'<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("menu_atestados",0)%></a></li>
                                        <li class="stick bg-green ">	<a href="#" onClick="openPopupPage('mini_Paper/',<%=strCOD_EMP%>,'<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("menu_papers",0)%></a></li>
                                        <li class="<%=flagPALESTRANTE%>"><a href="#" class="<%=flagPALESTRANTE%>" onClick="openPopupPage('mini_Diploma/',<%=strCOD_EMP%>,'<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("menu_diplomas",0)%></a></li>
                                        <li class="<%=flagPALESTRANTE%>"><a href="#" class="<%=flagPALESTRANTE%>" onClick="openPopupPage('mini_Palestra/',<%=strCOD_EMP%>,'<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("menu_palestras",0)%></a></li>
                                        <li class="<%=flagPALESTRANTE%>"><a href="#" class="<%=flagPALESTRANTE%>" onClick="openPopupPage('mini_Transporte/',<%=strCOD_EMP%>,'<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("menu_transporte",0)%></a></li>
                                        <li class="<%=flagPALESTRANTE%>"><a href="#" class="<%=flagPALESTRANTE%>" onClick="openPopupPage('mini_Hospedagem/',<%=strCOD_EMP%>,'<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("menu_hospedagem",0)%></a></li>
                                        <!-- li class="disabled"><a href="#">exemplo DESABLE</a></li //-->
                                    </ul>
                                </nav>
                            </div>
							<!-- FIM: MENU LATERAL -------------------------------------------------------- //-->                            
                        </div>
                    </div>                    
                </div>
            	<!-- FIM: Coluna DADOS e MENU ----------------------------------------------------------- //-->
            </div>

<!-- TESTE (para coisas extras como uma PSC... 
            <div class="" style="border:0px solid #0F0; display:inline-block; float:left;">
			<a class="tile double bg-lightBlue live" data-role="live-tile" data-effect="slideUp">
                <div class="tile-content email">
                    <div class="email-image">
                        <img src="../_metroUI/images/obama.jpg">
                    </div>
                    <div class="email-data">
                        <span class="email-data-title">PSC</span>
                        <span class="email-data-subtitle">Peça sua credencial</span>
                        <span class="email-data-text">12º Encontro Anual PMI 2017</span>
                    </div>
                </div>
                <div class="brand">
                    <div class="label"><h3 class="no-margin fg-white"><span class="icon-mail"></span></h3></div>
                    <div class="badge">0</div>
                </div>
            </a>
			</div>
//-->

            <div class="" style="border:0px solid #0F0; display:block; float:left;">
                <h1 style="font-size:26px;"><b><%=objLang.SearchIndex("resumo_inscricoes",0)%></b></h1>
                <div class="listview-outlook " data-role="listview" style="">
				<%					 
					Do While not objRS.EOF
				%>                                
                    <div class="list <%'=marked%>" id="mat_ativ_grupo" href="javascript:void(0);" style="border-bottom:#FFF solid 0px;">
                        <div class="list-content border" style="padding-top:12px; border:0px;">
                                <span class="list-title" style="font-size:18px; font-weight:bold;"><%=getValue(objRS,"COD_EVENTO") & " - " & ucase(getValue(objRS,"NOME_EVENTO"))%></span>
                                <span class="list-subtitle">
                            		<span style="color:#999"><%=getValue(objRS,"CIDADE_EVENTO") & "/" & ucase(getValue(objRS,"ESTADO_EVENTO")) & ", " & getValue(objRS,"PAVILHAO_EVENTO") & " [" & getValue(objRS,"DTINI_EVENTO") & " - " & getValue(objRS,"DTFIM_EVENTO") & "]"%></span>
									<br><%=objLang.SearchIndex("inscricao",0)%>:&nbsp;<%=getValue(objRS,"COD_INSCRICAO")%>
                                </span>
								<!--#include file="_includePainelUploadComprov.asp"-->
                               	<span class="remark">
                                		<small>
                                        	<%
												strVLR_PAGO = getValue(objRS,"VLR_PAGO")
												strVLR_PAGO = FormatNumber(abs(strVLR_PAGO))	
												if (getValue(objRS,"VLR_COMPRA") = "") then
													strVLR_COMPRADO = 0
													strSemProduto = "sem"
												else		
													strVLR_COMPRADO = getValue(objRS,"VLR_COMPRA") 
													strSemProduto = "com"
												end if
												strSALDO = FormatNumber(strVLR_COMPRADO - strVLR_PAGO)
											%>
                                        	R$ <%=FormatNumber(strVLR_COMPRADO)%>  (<%=objLang.SearchIndex("pago",0)%>&nbsp<%=FormatNumber(strVLR_PAGO) & " - " & getValue(objRS,"FORMAPGTO")%>)
                                        </small>
                               	</span>
								<p></p><!-- quebra de linha um pouco maior que <br>, foi necessária neste caso //-->
								<button id="btProd" class="bg-darkCyan fg-white" onClick="openPopupPage('mini_Produto/','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=strCOD_EMP%>');"><%=objLang.SearchIndex("but_produtos",0)%></button>

								<button id="btAgenda" class="bg-cyan fg-white" onClick="openPopupPage_AGENDA('mini_ShopAgenda/','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=getValue(objRS,"COD_EVENTO")%>','<%=getValue(objRS,"COD_EMPRESA")%>', '<%=ucase(getValue(objRS,"NOME_EVENTO"))%>', '<%=getValue(objRS,"COD_STATUS_PRECO")%>');"><%=objLang.SearchIndex("but_agenda",0)%></button>

								<button id="btQuest" class="bg-teal fg-white" onClick="openPopupPage('mini_Questionario/','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("but_questionario",0)%></button>

								<!-- Comentado temporariamente a pedido do Brunet 12/04/2017
                                <button id="btPaperSearch" class="bg-darkGreen fg-white" onClick="openPopupPage('mini_PaperSearch/','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("but_trabalhos",0)%></button>
                                //-->

                                <% If (strSALDO <= 0 AND strSemProduto = "com") Then %>
	                                <button id="btARM" class='bg-emerald fg-white' onClick="openPopupPage_ARM('confirmacao_arm.asp','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=getValue(objRS,"COD_EVENTO")%>');"><%=objLang.SearchIndex("but_arm",0)%></button>
								<% end if  %>	  

								<% If (strVLR_PAGO > 0) Then %>
    	                            <button id="btRECIBO" class="bg-green fg-white" onClick="openPopupPage_RECIBO('recibo.asp','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=getValue(objRS,"COD_EVENTO")%>');"><%=objLang.SearchIndex("but_recibo",0)%></button>
                                	<button id="btNOTAFISCAL" class="bg-lime fg-white" onClick="openPopupPage_NOTAFISCAL('mini_NotaFiscal/','<%=getValue(objRS,"INSCR_CHAVE")%>');"><%=objLang.SearchIndex("but_notafiscal",0)%></button>                                    
                                <% End If %>
								<%                        
								
								strCOD_FORMAPGTO = getValue(objRS,"COD_FORMAPGTO")
								
                                If getValue(objRS,"TIPO_PESS") = "S" And (Cstr(getValue(objRS,"INSCR_MASTER")) = "0" Or Cstr(getValue(objRS,"INSCR_MASTER")) = "")Then
                                  strTIPO_LOJA = "shop"
                                Else
                                  strTIPO_LOJA = "shoppj"
                                End If
								
								strLINK_BOLETO = ""
								'response.write("cod_boleto" & strCOD_FORMAPGTO)
								Select Case strCOD_FORMAPGTO
									Case "1"
										' Boleto Banco Brasil - MAPG
										strLINK_BOLETO = "../" & strTIPO_LOJA & "/boletobb.asp?"
										
									Case "7"
										' Boleto Itaú - SEM REGISTRO
										strLINK_BOLETO = "../" & strTIPO_LOJA & "/boletoitau2.asp?"
									Case "339"
										' Boleto Santander - SEM REGISTRO
										strLINK_BOLETO = "../" & strTIPO_LOJA & "/boleto_pro_santander2.asp?"	
									Case "8002"
										strLINK_BOLETO = "../" & strTIPO_LOJA & "/boletobepay.asp?"	
									'Case "800"
									'	strLINK_BOLETO = "../" & strTIPO_LOJA & "/boletobepay.asp?"	
										
									Case Else
								End Select
								
                                If ((strLINK_BOLETO <> "") AND (strVLR_PAGO = 0)) OR ((strSALDO > 0 AND strLINK_BOLETO <> "") )Then 
									if instr(strLINK_BOLETO, "boletobepay.asp") then %>                                	
    	                                <button id="btBOLETO" class="bg-green fg-white" onClick="openPopupPage_BOLETO_BEPAY('<%=strLINK_BOLETO%>','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=getValue(objRS,"COD_EVENTO")%>');"><%=objLang.SearchIndex("but_2aviaboleto",0)%></button>
                                   <% else %>
	                                    <button id="btBOLETO" class="bg-green fg-white" onClick="openPopupPage_BOLETO('<%=strLINK_BOLETO%>','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=getValue(objRS,"COD_EVENTO")%>');"><%=objLang.SearchIndex("but_2aviaboleto",0)%></button>
                                   <% end if    
                                End If 
								   %>                                
								
                                <button id="btCERTIFICADO" class="bg-lightOrange fg-white" onClick="openPopupPage_CERTIFICADO('mini_Certificado/','<%=strCOD_EMP%>','<%=strCODBARRA_EMP%>','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=strCODBARRA_SUB%>');"><%=objLang.SearchIndex("but_certificado",0)%></button>
                               
								<button id="btDownload" class="bg-darkOrange fg-white" onClick="openPopupPage('mini_Produto/','<%=getValue(objRS,"COD_INSCRICAO")%>','<%=strCOD_EMP%>');"><%=objLang.SearchIndex("but_download",0)%></button>
                                								
								<% 'Botões Reserva %>
                                <!--
                                <button id="btRESERVA2" class="bg-darkRed fg-white" onClick="">RESERVA2</button>                                   
                                <button id="btRESERVA2" class="bg-darkMagenta fg-white" onClick="">RESERVA2</button>   
                                <button id="btRESERVA3" class="bg-darkCrimson fg-white" onClick="">RESERVA3</button>
                                //-->
                                                             
								<p></p><!-- quebra de linha um pouco maior que <br>, foi necessária neste caso //-->
                        </div>
                    </div>
				<%
						objRS.MoveNext						
					Loop
				%>
                </div>
            </div> <!-- span8 //-->                      
            </div>
</div><!-- fim div principal //-->
</body>
</html>
<%
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>