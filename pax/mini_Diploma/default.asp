<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_Diploma",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          							' - Default do Modulo...
 Const LTB = "tbl_PRODUTOS_PALESTRANTE"						' - Nome da Tabela...
 Const DKN = "COD_PALESTRANTE"						 		' - Campo chave...
 Const DLD = "../pax/mini_Diploma/default.asp"  			' "../evento/data.asp" - 'Default Location ap�s Dele��o

 'Relativas a conex�o com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, objLang, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Pagina��o	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCODLINK, strCOD_EVENTO,strCODLINKMINI,strID_AUTO, strCOD_EMPRESA
 

'Carraga a chave do registro, por�m neste caso a rela��o masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------
strCOD_EMPRESA	= Replace(GetParam("var_chavereg"),"'","''")
'------------------------------------------------------------------
'ATHDEBUG strINSTRUCAO, true

'------------------------------------------------------------------
'ATHDEBUG strINSTRUCAO, true

'------------------------------------------------------------------

'Relativo P�gina��o, mas para controle de linhas por p�gina----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configura��es de conex�o
 AbreDBConn objConn, CFG_DB 

 'Relativos a PAGINA��O ----------------------------------------------------------------------------------------
 'Altera a qtde de elemetnos por p�gina a partir do filtrpo 
 auxNumPerPage = Replace(GetParam("var_numperpage"),"'","''") 
 If (auxNumPerPage<>"") then 
  numPerPage = auxNumPerPage
 End If
 'Cuida do controle de p�gina corrente
 Function GetCurPage
   Dim auxCurPage
   auxCurPage = Request.Form("var_curpage") 'neste caso n�o pode usar GetParam
   If (Not isNumeric(auxCurPage)) or (auxCurPage = "")  then
	 auxCurPage = 1 
   Else
	 If cint(auxCurPage) < 1 Then auxCurPage =  1 
	 If cint(auxCurPage) > objRS.PageCount Then auxCurPage = objRS.PageCount 
   End If
   GetCurPage = auxCurPage
 end function
 ' ---------------------------------------------------------------------------------------------------------------
				 
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------

 ' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

   strSQL =          " SELECT E.NOME, "
   if lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
   		strSQL = strSQL & " P.TITULO_INTL AS TITULO, P.DESCRICAO_INTL AS DESCRICAO, "
   Else
   		strSQL = strSQL & " P.TITULO, P.DESCRICAO, "
   End If
   strSQL = strSQL & " PP.TEMA, PP.FUNCAO,PL.COD_PALESTRANTE, P.COD_EVENTO, P.COD_PROD, P.GRUPO, P.DT_OCORRENCIA"
   strSQL = strSQL & " FROM tbl_Produtos P INNER JOIN tbl_Produtos_Palestrante pp ON P.COD_PROD = pp.COD_PROD "
   strSQL = strSQL & "  INNER JOIN tbl_Palestrante PL ON PL.COD_PALESTRANTE = pp.COD_PALESTRANTE "
   strSQL = strSQL & "  INNER JOIN tbl_Palestrante_Evento ON tbl_Palestrante_Evento.COD_PALESTRANTE = PL.COD_PALESTRANTE"
   strSQL = strSQL & "  INNER JOIN tbl_Evento E ON P.COD_EVENTO = E.COD_EVENTO"
   strSQL = strSQL & "  WHERE P.DIPLOMA_PDF IS NOT NULL"
   strSQL = strSQL & "    AND PL.COD_EMPRESA = '" &strCOD_EMPRESA & "'"
   strSQL = strSQL & "    AND (NOW() > P.DT_OCORRENCIA OR NOW() > E.DT_FIM )"
   strSQL = strSQL & "  GROUP BY TEMA, COD_PROD "
   strSQL = strSQL & "  ORDER BY E.DT_INICIO DESC, P.DT_OCORRENCIA, P.GRUPO"
   
 		  
 'athDebug strSQL , TRUE

 ' Define os campos para exibir na grade
 strFields = "NOME,TITULO,TEMA,FUNCAO,COD_PALESTRANTE" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(ucase(objLang.SearchIndex("mini_evento",0))   , ucase(objLang.SearchIndex("mini_palestra",0))  , ucase(objLang.SearchIndex("mini_tema",0))     , ucase(objLang.SearchIndex("mini_funcao",0))   , " ")
 arrSort   = Array("sortable" , "sortable"  , "sortable" , "sortable" , "" ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array(""         , ""          , ""  	     , ""  		  , ""	)     'Obs.:[somar 98%] ou deixar todos vazios
' ----------------------------------------------------------------------------------------------------------------------------

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 

 strALL_PARAMS = URLDecode(Request.Form) 'neste caso n�o pode usar GetParam
 strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para n�o trancar a pagina��oz
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

function diploma(cod_palestrante,cod_prod,cod_evento,funcao) {
  document.formdiploma.var_cod_palestrante.value = cod_palestrante;
  document.formdiploma.var_cod_prod.value = cod_prod;
  document.formdiploma.var_cod_evento.value = cod_evento;
  document.formdiploma.var_funcao.value = funcao;
  document.formdiploma.submit();  
}
</script>

</head>
<body class="metro">
<!-- Embora um MINI M�dulo esteja convencionado a n�o ter elementos de filtragem
         criamos este Formul�rio de filtro necess�rio para envio da p�gina corrrente
         armazenamento da qqtde de elementos por p�gtina //-->
     <form id="formfiltro" name="formfiltro" action="default.asp" method="post" style="display:none; visibility:hidden;" >
       <input type="hidden" id="var_numperpage"		name="var_numperpage" value="<%=numPerPage%>">
       <input type="hidden" id="var_chavereg"		name="var_chavereg"   value="<%=strCOD_EMPRESA%>">
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
							<%=objLang.SearchIndex("mini_diploma",0)%>
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


<form name="formdiploma" action="diplomapdf.asp" method="post" target="_blank">
  <input type="hidden" name="var_cod_prod" value="">
  <input type="hidden" name="var_cod_palestrante" value="">
  <input type="hidden" name="lng" id="lng" value="" />
  <input type="hidden" name="var_cod_empresa" value="<%=strCOD_EMPRESA%>">
  <input type="hidden" name="var_cod_evento" value="">
  <input type="hidden" name="var_funcao" value="">
</form>


</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>