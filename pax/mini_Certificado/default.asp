<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_Certificado",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          							' - Default do Modulo...
 Const LTB = "TBL_PRODUTOS" 								' - Nome da Tabela...
 Const DKN = "COD_EMPRESA"							 		' - Campo chave...
 Const DLD = "../pax/mini_Certificado/default.asp" 			' "../evento/data.asp" - 'Default Location após Deleção


 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, objLang, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage 
 'Relativas a FILTRAGEM
 Dim strCODLINK, strCOD_EVENTO,strCODLINKMINI,strID_AUTO 
 Dim strCOD_EMPRESA, strCODBARRA, strCODBARRA_EMP, strCODBARRA_SUB, strCOD_INSCRICAO
 

 strCOD_EMPRESA		= Replace(GetParam("var_chavereg"),"'","''")
 strCODBARRA		= getParam("var_codbarra") 
 strCODBARRA_SUB	= getParam("var_codbarra_sub")
 
 If strCODBARRA_SUB <> "" Then
 	strCODBARRA = strCODBARRA_SUB
 End If
 
 'Quando vem o [var_cod_inscricao] é porque foi chamado direto 
 'da lista histórico de inscrições e deve mostar então somente 
 'os certificados da inscrição correspo0ndente
 strCOD_INSCRICAO		= getParam("var_cod_inscricao")

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------



'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------



 'Relativos a PAGINAÇÃO ----------------------------------------------------------------------------------------
 'Altera a qtde de elementos por página a partir do filtrpo 
 auxNumPerPage = Replace(GetParam("var_numperpage"),"'","''") 
 If (auxNumPerPage<>"") then 
  numPerPage = auxNumPerPage
 End If
 'Cuida do controle de página corrente
 Function GetCurPage
   Dim auxCurPage
   auxCurPage = Request.Form("var_curpage") 'neste caso não pode usar GetParam
   If (Not isNumeric(auxCurPage)) or (auxCurPage = "")  then
	 auxCurPage = 1 
   Else
	 If cint(auxCurPage) < 1 Then auxCurPage =  1 
	 If cint(auxCurPage) > objRS.PageCount Then auxCurPage = objRS.PageCount 
   End If
   GetCurPage = auxCurPage
 end function
' ---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

 strSQL =          " SELECT DISTINCT P.COD_PROD, IP.COD_INSCRICAO, I.COD_EVENTO, E.NOME, I.COD_EMPRESA, "

 if lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
	strSQL = strSQL & " P.TITULO_INTL AS TITULO, P.DESCRICAO_INTL AS DESCRICAO, "
 Else
	strSQL = strSQL & " P.TITULO, P.DESCRICAO, "
 End If 
 
 strSQL = strSQL & "  if(QC.COD_QUESTIONARIO = p.CERTIFICADO_VINCULO_COD_QUESTIONARIO,null,p.CERTIFICADO_VINCULO_COD_QUESTIONARIO) as QUESTIONARIO,  "
 strSQL = strSQL & "  if(QC.COD_QUESTIONARIO = p.CERTIFICADO_VINCULO_COD_QUESTIONARIO,null,p.CERTIFICADO_VINCULO_COD_QUESTIONARIO) as COD_QUESTIONARIO " 
 strSQL = strSQL & "   FROM tbl_INSCRICAO I INNER JOIN tbl_INSCRICAO_PRODUTO IP ON I.COD_INSCRICAO = IP.COD_INSCRICAO"
 ' Busca os produtos da inscrição e também os produtos que tiveram direitos de acesso validados pelos produtos da inscrição
 strSQL = strSQL & "                        LEFT JOIN tbl_PRODUTOS P ON (P.COD_PROD = IP.COD_PROD OR concat(',',P.COD_PROD_VALIDA,',') LIKE concat('%,',IP.COD_PROD,',%') ) "
 strSQL = strSQL & "                        LEFT JOIN tbl_EVENTO E ON E.COD_EVENTO = P.COD_EVENTO"
 ' Verifica se a empresa ou o contato já preencheram o questionário obrigatório para este certeificado/produto
 strSQL = strSQL & "						LEFT JOIN TBL_QUESTIONARIO_CLIENTE QC ON P.CERTIFICADO_VINCULO_COD_QUESTIONARIO = QC.COD_QUESTIONARIO AND LEFT(QC.CODBARRA,6) = '" & strCOD_EMPRESA & "'"
 ' Exclui produtos que não tenham terminado ou que o evento deste produto não tenha terminado
 strSQL = strSQL & "  WHERE (NOW() > P.DT_TERMINO OR NOW() > E.DT_FIM )"
 strSQL = strSQL & "    AND  I.COD_EMPRESA = '" &strCOD_EMPRESA & "'"

 ' Limita consulta ao contato da empresa logada se houver
 If strCODBARRA_SUB <> "" Then
	strSQL = strSQL & "    AND  I.CODbarra = '" & strCODBARRA_SUB & "'"
 End if 

 If strCOD_INSCRICAO<>"" then
	strSQL = strSQL & "    AND  I.COD_INSCRICAO = '" & strCOD_INSCRICAO & "'"
 End if

 ' Limita a consulta a produtos que tenham o campo com o html do PDF preenchido do idioma logado
 If lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
	strSQL = strSQL & " AND (P.CERTIFICADO_PDF_INTL IS NOT NULL OR P.CERTIFICADO_PDF_INTL <> '') "
 Else
	strSQL = strSQL & " AND (P.CERTIFICADO_PDF IS NOT NULL OR P.CERTIFICADO_PDF <> '') "
 End If

' teste para ver se tem controle de leitura de salas minima para imprimir o certificado   
 strSQL = strSQL & "    AND ( ( P.CERTIFICADO_NRO_PRODUTOS_MIN IS NULL  AND P.CERTIFICADO_COD_PROD_VALIDA IS NULL ) OR "
 strSQL = strSQL & "      IF(P.CERTIFICADO_NRO_PRODUTOS_MIN IS NULL,1,P.CERTIFICADO_NRO_PRODUTOS_MIN) <= (select count(distinct cod_prod) from tbl_controle_produtos where codbarra = i.codbarra and cod_evento = i.cod_evento and concat(',',P.CERTIFICADO_COD_PROD_VALIDA,',') LIKE concat('%,',cod_prod,',%') )"
 strSQL = strSQL & "    )"
 ' teste para ver se tem carga horaria minima para imprimir o certificado
 strSQL = strSQL & "    AND (P.CERTIFICADO_CARGA_HORARIA_MIN IS NULL OR P.CERTIFICADO_CARGA_HORARIA_MIN IS NULL < ("
 strSQL = strSQL & "    select sum(prod.carga_horaria)"
 strSQL = strSQL & "     from tbl_produtos prod"
 strSQL = strSQL & "    where prod.cod_prod in ("
 strSQL = strSQL & "             select distinct cp.cod_prod from tbl_controle_produtos cp  where cp.codbarra = i.codbarra and cp.cod_evento = i.cod_evento  and concat(',',P.CERTIFICADO_COD_PROD_VALIDA,',') LIKE concat('%,',cod_prod,',%')"
 strSQL = strSQL & "                           )"
 strSQL = strSQL & "                                      )"
 strSQL = strSQL & "    )"
 ' teste para ver se a retirada de material autoriza  imprimir o certificado   
 strSQL = strSQL & "    AND ( P.CERTIFICADO_DT_RETIRADA_MATERIAL IS NULL  OR IP.SYS_DATAMAT > P.CERTIFICADO_DT_RETIRADA_MATERIAL )"
 strSQL = strSQL & "  ORDER BY E.DT_INICIO DESC, P.DT_OCORRENCIA, P.GRUPO"
		  
 'athDebug strSQL , TRUE


 ' Define os campos para exibir na grade
 strFields = "NOME,TITULO,DESCRICAO,QUESTIONARIO,COD_QUESTIONARIO" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(ucase(objLang.SearchIndex("mini_evento",0)) , ucase(objLang.SearchIndex("mini_produto",0)) , ucase(objLang.SearchIndex("mini_descricao",0)) , " ", " ")
 arrSort   = Array("sortable"                                  , "sortable"                                   , "sortable"                                     , "" , ""  ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array(""                                          , ""                                           , ""    	                                       , "" , "" 		  	)     'Obs.:[somar 98%] ou deixar todos vazios
' ----------------------------------------------------------------------------------------------------------------------------

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 

 strALL_PARAMS = URLDecode(Request.Form) 'neste caso não pode usar GetParam
 strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para não trancar a paginaçãoz
 'athDebug "[" & strALL_PARAMS & "]", false

 If (not objRS.eof) Then 
   objRS.AbsolutePage = GetCurPage
 End If
 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
<script language="JavaScript">
function certificado(cod_inscricao,cod_prod,cod_evento) {
  document.formcertificado.var_cod_inscricao.value = cod_inscricao;
  document.formcertificado.var_cod_prod.value = cod_prod;
  document.formcertificado.var_cod_evento.value = cod_evento;
  document.formcertificado.submit();  
}
</script>

</head>
<body class="metro">
<!-- Embora um MINI Módulo esteja convencionado a não ter elementos de filtragem
         criamos este Formulário de filtro necessário para envio da página corrrente
         armazenamento da qqtde de elementos por págtina //-->
	<form id="formfiltro" name="formfiltro" action="default.asp" method="post" style="display:none; visibility:hidden;" >
		<input type="hidden" id="var_numperpage"		name="var_numperpage" value="<%=numPerPage%>">
		<input type="hidden" id="var_chavereg"		name="var_chavereg"   value="<%=strCOD_EMPRESA%>">
		<% If strCOD_INSCRICAO<>"" then %>
       		<input type="hidden" id="var_cod_inscricao"	name="var_cod_inscricao"   value="<%=strCOD_INSCRICAO%>">
		<% End if %>
		<input type="hidden" name="DEFAULT_LOCATION" value="default.asp"> 
	</form>
	<%'athDebug strCOD_EVENTO, true%>
	<div class="grid fluid">
    <!-- INI: barra no topo (filtro e adicionar) //-->
    <div class="bg-white" style="border:0px solid #F00; width:100%; height:45px;  vertical-align:bottom; padding-left:0px;">
        <div style="width:100%;display:inline-block"> 
       
			<!-- INI: Filtro (accordiion para filtragem) //-->
            <div class="accordion place-left"  style="z-index:10; position:absolute; top:0px;">
                <div class="accordion-frame" style="border:0px solid #F00;">
               <a class="heading text-left bg-white fg-active-black" href="javascript:document.getElementById('formfiltro').submit();" style="height:45px;">
	                    <p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;">
                        
                        	<%=strCOD_EMPRESA%>.
                            <i class=" <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & strCOD_EMPRESA%>"></i>
							<%=objLang.SearchIndex("mini_certificado",0)%>
                        </p>
                    </a>
                    <div class="content bg-white span3" style="border:1px solid #CCC;">
                        <div class="panel-content bg-white">	
                        	<!-- ondeficavafiltro--> 
                        </div>
                    </div>
                     
                </div>
            </div>
        </div>
    </div>
	<!-- FIM: grade de dados//-->            
       
    <!-- INI: grade de dados //-->        
    <div id="body_grade" style="position:absolute; top:45px; z-index:8; width:100%">
        <!--#include file="_include_grade.asp"-->                                       
    </div>
    <!-- FIM: grade de dados //-->

</div>
<form name="formcertificado" action="certificadopdf.asp" method="post" target="_top">
  <input type="hidden" name="var_cod_prod" value="">
  <input type="hidden" name="var_cod_inscricao" value="">
  <input type="hidden" name="lng" id="lng" value="" />
  <input type="hidden" name="var_cod_empresa" value="<%=strCOD_EMPRESA%>">
  <input type="hidden" name="var_cod_evento" value="">
</form>
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>