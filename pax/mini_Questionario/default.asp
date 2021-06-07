<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_CfgLinks",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          							' - Default do Modulo...
 Const LTB = "TBL_QUESTIONARIO" 								' - Nome da Tabela...
 Const DKN = "COD_QUESTIONARIO"							 		' - Campo chave...
 Const DLD = "../pax/mini_Questionario/default.asp" 			' "../evento/data.asp" - 'Default Location após Deleção
 

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, objLang, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCODLINK, strCOD_EVENTO,strCODLINKMINI,strID_AUTO, strCOD_INSCRICAO
 
 Dim strCodEmpresa, strCodBarra, strCodEvento, strCodStatusPrc



'Carraga a chave do registro, porém neste caso a relação masterdetail 

'---------------carrega cachereg do pai local cred-----------------
strCOD_INSCRICAO	= Replace(GetParam("var_chavereg"),"'","''")

'------------------------------------------------------------------
'ATHDEBUG strCOD_INSCRICAO, true

'------------------------------------------------------------------

'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 

 'Relativos a PAGINAÇÃO ----------------------------------------------------------------------------------------
 'Altera a qtde de elemetnos por página a partir do filtrpo 
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

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
						 
'---------------------------------------------------------------------
' Dados de participação congressos e impressão de certificados

'BUSCA OS DADOS RELATIVOS AO EVENTO E A INSCRIÇÃO, SÃO USADOS PARA 
strSQL = "select cod_inscricao, cod_empresa, codbarra, cod_evento, cod_status_preco from tbl_inscricao WHERE cod_inscricao = " & strCOD_INSCRICAO
set objRS = objConn.Execute(strSQL)

If NOT objRS.eof Then
	strCOD_INSCRICAO = getValue(objRS,"cod_inscricao")
	strCodEmpresa    = getValue(objRS,"cod_empresa")
	strCodBarra      = getValue(objRS,"codbarra")
	strCodEvento     = getValue(objRS,"cod_evento")
	strCodStatusPrc  = getValue(objRS,"cod_status_preco")

End If



	strSQL =          " SELECT Q.COD_QUESTIONARIO, Q.TITULO , QC.SYS_DATACA, QC.SYS_DATACA as confirma"
	strSQL = strSQL & "   FROM TBL_QUESTIONARIO Q  LEFT JOIN TBL_QUESTIONARIO_CLIENTE QC ON Q.COD_QUESTIONARIO = QC.COD_QUESTIONARIO "
	strSQL = strSQL & "AND QC.CODBARRA = '" & strCodBarra & "'"
	strSQL = strSQL & "  WHERE Q.COD_EVENTO = " & strCodEvento
	strSQL = strSQL & "    AND Q.SYS_INATIVO IS NULL "
	strSQL = strSQL & "    AND concat(',',Q.COD_STATUS_PRECO,',') like '%," & strCodStatusPrc & ",%'"
	strSQL = strSQL & "  ORDER BY DT_CRIACAO"
 		  
' athDebug strSQL , TRUE

  ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------


 ' Define os campos para exibir na grade
 strFields = "COD_QUESTIONARIO, TITULO, SYS_DATACA, confirma" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("Cod."   , ucase(objLang.SearchIndex("mini_quest_tit",0)), ucase(objLang.SearchIndex("mini_quest_preenchido",0)), "" )
 arrSort   = Array("sortable" , "sortable", "sortable-date-dmy", ""  ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array("1%"       , "62%"     , "30%" , "5%"     )     'Obs.:[somar 98%] ou deixar todos vazios
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
<script src="../../_scripts/scriptsCS.js	"></script>
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
       <input type="hidden" id="var_chavereg"		name="var_chavereg"   value="<%=strCOD_INSCRICAO%>">
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
                        	<%=strCOD_INSCRICAO%>.
                            <i class=" <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & strCOD_INSCRICAO%>"></i>
							<%=objLang.SearchIndex("mini_questionario",0)%>
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
<!--form name="formcertificado" action="../certificadopdf.asp" method="post" target="_top">
  <input type="hidden" name="var_cod_prod" value="">
  <input type="hidden" name="var_cod_inscricao" value="">
  <input type="hidden" name="lng" id="lng" value="" />
  <input type="hidden" name="var_cod_empresa" value="<%'=strCOD_EMPRESA%>">
  <input type="hidden" name="var_cod_evento" value="">
</form //-->
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>