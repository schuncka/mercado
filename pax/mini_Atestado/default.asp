<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_CfgLinks",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          							' - Default do Modulo...
 Const LTB = "TBL_CONTROLE_IN" 								' - Nome da Tabela...
 Const DKN = "COD_EMPRESA"							 		' - Campo chave...
 Const DLD = "../pax/mini_Atestado/default.asp" 			' "../evento/data.asp" - 'Default Location após Deleção
 

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, objLang, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCODLINK, strCOD_EVENTO,strCODLINKMINI,strID_AUTO, strCOD_EMPRESA, strCODBARRA_SUB
 

strCOD_EMPRESA	= Replace(GetParam("var_chavereg"),"'","''")
strCODBARRA_SUB = getParam("var_codbarra_sub")

 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------
 

'------------------------------------------------------------------
'ATHDEBUG strINSTRUCAO, true

'------------------------------------------------------------------
'ATHDEBUG strINSTRUCAO, true

'------------------------------------------------------------------

'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If


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
 
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB  
 
 
' ---------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
						 
'---------------------------------------------------------------------
' Dados de visitação e impressão de atestado

 strSQL =          " SELECT tbl_Evento.NOME as NOMEEVENTO" 
 strSQL = strSQL & " ,tbl_Empresas.NOMECLI " 
 strSQL = strSQL & " ,tbl_Empresas.NOMEFAN" 
 strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO " 
 strSQL = strSQL & " ,tbl_Controle_IN.COD_EVENTO" 
 strSQL = strSQL & " ,tbl_Controle_IN.CODBARRA" 
 strSQL = strSQL & " ,tbl_Controle_IN.DT_INSERT" 
 strSQL = strSQL & " ,tbl_Empresas.COD_EMPRESA" 
 strSQL = strSQL & " ,tbl_Evento.ATESTADO_PDF" 
 strSQL = strSQL & " FROM ((tbl_Empresas INNER JOIN tbl_Controle_IN ON tbl_Empresas.COD_EMPRESA =  Left(tbl_Controle_IN.CODBARRA,6) )" 
 strSQL = strSQL & "                      INNER JOIN tbl_Evento ON tbl_Controle_IN.COD_EVENTO = tbl_Evento.COD_EVENTO)" 
 strSQL = strSQL & "                      LEFT OUTER JOIN tbl_Empresas_Sub ON tbl_Controle_IN.CODBARRA = tbl_Empresas_Sub.CODBARRA " 
 strSQL = strSQL & " WHERE tbl_Empresas.COD_EMPRESA = '" &strCOD_EMPRESA & "' " 

If strCODBARRA_SUB <> "" Then
 strSQL = strSQL & "    AND  tbl_Controle_IN.CODBARRA = '" & strCODBARRA_SUB & "' "
End if 


 strSQL = strSQL & " UNION"

 strSQL = strSQL & " SELECT tbl_Evento.NOME as NOMEEVENTO" 
 strSQL = strSQL & " ,tbl_Empresas.NOMECLI " 
 strSQL = strSQL & " ,tbl_Empresas.NOMEFAN" 
 strSQL = strSQL & " ,tbl_Empresas_Sub.NOME_COMPLETO " 
 strSQL = strSQL & " ,tbl_Controle_IN_Hist.COD_EVENTO" 
 strSQL = strSQL & " ,tbl_Controle_IN_Hist.CODBARRA" 
 strSQL = strSQL & " ,tbl_Controle_IN_Hist.DT_INSERT" 
 strSQL = strSQL & " ,tbl_Empresas.COD_EMPRESA" 
 strSQL = strSQL & " ,tbl_Evento.ATESTADO_PDF" 
 strSQL = strSQL & " FROM ((tbl_Empresas INNER JOIN tbl_Controle_IN_Hist ON tbl_Empresas.COD_EMPRESA =  Left(tbl_Controle_IN_Hist.CODBARRA,6) )" 
 strSQL = strSQL & "                      INNER JOIN tbl_Evento ON tbl_Controle_IN_Hist.COD_EVENTO = tbl_Evento.COD_EVENTO)" 
 strSQL = strSQL & "                      LEFT OUTER JOIN tbl_Empresas_Sub ON tbl_Controle_IN_Hist.CODBARRA = tbl_Empresas_Sub.CODBARRA " 
 strSQL = strSQL & " WHERE tbl_Empresas.COD_EMPRESA = '" &strCOD_EMPRESA & "' "

If strCODBARRA_SUB <> "" Then
 strSQL = strSQL & "    AND tbl_Controle_IN_Hist.CODBARRA = '" & strCODBARRA_SUB & "' "
End if 

 strSQL = strSQL & " ORDER BY 7"
 		  
 'athDebug strSQL , TRUE


 ' Define os campos para exibir na grade
 strFields = "NOMEEVENTO,DT_INSERT,COD_EMPRESA" 
 arrFields = Split(strFields,",")        

 arrLabels = Array( ucase(objLang.SearchIndex("mini_evento",0)) , ucase(objLang.SearchIndex("mini_data",0)) , " ")
 arrSort   = Array("sortable"                                   , "sortable-date-dmy"                       , "" ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array(""                                           , ""										, "" )  'Obs.:[somar 98%] ou deixar todos vazios
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

function atestado(cod_empresa,codbarra,cod_evento) {
  document.formatestado.var_cod_empresa.value = cod_empresa;
  document.formatestado.var_codbarra.value = codbarra;
  document.formatestado.var_cod_evento.value = cod_evento;
  document.formatestado.submit();  
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
							<%=objLang.SearchIndex("mini_atestado",0)%>
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

<form name="formatestado" action="atestadopdf.asp" method="post" target="_blank">
  <input type="hidden" name="lng" id="lng" value="" />
  <input type="hidden" name="var_cod_empresa" value="<%=strCOD_EMPRESA%>">
  <input type="hidden" name="var_codbarra" value="">
  <input type="hidden" name="var_cod_evento" value="">
</form>


</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>