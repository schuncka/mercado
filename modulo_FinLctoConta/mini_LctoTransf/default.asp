<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_SiteInfo",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          					' - Default do Modulo...
 Const LTB = "FIN_LCTO_TRANSF"	    			' - Nome da Tabela...
 Const DKN = "COD_LCTO_TRANSF"          			' - Campo chave...
 Const DLD = "../modulo_FinLctoConta/mini_LCTOTransf/default.asp" 		' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "LCTO TRANSF"    						' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro


 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strENTIDADE, strSALDO
 Dim strDT_INI, strDT_FIM
 Dim strCONTA, strPERIODO
 Dim strIO, strTITLE, boolLCTO, boolTRANSF
 Dim strCodigo,strCODLCTOCONTA	,strOPERACAO,strTIPO
 Dim strCOD_EVENTO,strID_AUTO
 
 'Antes de abir o banco já carrega as variaveis 
 strCONTA	   			= GetParam("var_fin_conta")
 strPERIODO	   			= GetParam("var_periodo")
 strCODLCTOCONTA		= getParam("var_cod_lctoconta")
 strOPERACAO			= getParam(" var_operacao")  
 strTIPO 				= getParam("var_tipo")
 
 
 'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage =  "10"'CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão----------------------------------------------------------
 AbreDBConn objConn, CFG_DB 
'---------------------------------------------------------------------------------------------------------------

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

' Monta FILTRAGEM -----------------------------------------------------------------------------------------------
 Function MontaWhereAdds
   Dim auxSTR 
'   If strIDAUTO  	<>   ""  Then auxSTR = auxSTR & " AND ID_AUTO   	LIKE  		'" & strIDAUTO &   "%'"  
	If strCODLCTOCONTA     	<>   ""  Then auxSTR = auxSTR & " AND COD_LCTO_EM_CONTA		=    		'" & strCODLCTOCONTA &	"'"
	If strOPERACAO     		<>   ""  Then auxSTR = auxSTR & " AND OPERACAO    			=			'" & strOPERACAO &	"'"
	If strTIPO     			<>   ""  Then auxSTR = auxSTR & " AND TIPO    				=    		'" & strTIPO &	"'"
	If strCONTA     		<>   ""  Then auxSTR = auxSTR & " AND COD_CONTA   			=			'" & strCONTA &	"'"
'	If strPERIODO     		<>   ""  Then auxSTR = auxSTR & " AND COD_INFO    			=    		'" & strPERIODO &	"'"
 
   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

 strSQL = " SELECT 			   T1.COD_LCTO_TRANSF "
 strSQL = strSQL & "		  , T1.COD_CONTA_ORIG "
 strSQL = strSQL & "		  , T1.COD_CONTA_DEST "
 strSQL = strSQL & "		  , T1.HISTORICO "
 strSQL = strSQL & "		  , T1.NUM_LCTO "
 strSQL = strSQL & "		  , T1.VLR_LCTO "
 strSQL = strSQL & "		  , T1.DT_LCTO " 
 strSQL = strSQL & "		   FROM FIN_LCTO_TRANSF AS T1, FIN_CONTA AS T2, FIN_CONTA AS T3 " 
 strSQL = strSQL & "		   WHERE T1.COD_CONTA_ORIG = T2.COD_CONTA AND T1.COD_CONTA_DEST = T3.COD_CONTA "
 
 ' if strDT_INI<>"" and strDT_FIM<>"" then strSQL = strSQL & " AND DT_LCTO BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "'"
'  if strCONTA<>"" then strSQL = strSQL & " AND (COD_CONTA_ORIG =" & strCONTA & " OR COD_CONTA_DEST =" & strCONTA & ")"
'  strSQL = strSQL & "ORDER BY DT_LCTO DESC "

 
 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))
  
 ' Define os campos para exibir na grade
 strFields = " T1.COD_CONTA_ORIG, T1.COD_CONTA_DEST, T1.HISTORICO, T1.NUM_LCTO, T1.VLR_LCTO, T1.DT_LCTO "
 arrFields = Split(strFields,",")        

 arrLabels = Array( "COD" ,"COD_CONTA_DEST", "HISTORICO" , "NUM_LCTO" , "VLR_LCTO" , "DssT_LCTO")
 arrSort   = Array("sortable","sortable","sortable","sortable","sortable","sortable")  'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable"
 arrWidth  = Array("2%","10%","10%","50%","10%","10%")  'obs.:[somar 98%] ou deixar todos vazios
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
</head>
<body class="metro">
<!-- Embora um MINI Módulo esteja convencionado a não ter elementos de filtragem
         criamos este Formulário de filtro necessário para envio da página corrrente
         armazenamento da qqtde de elementos por págtina //-->
     <form id="formfiltro" name="formfiltro" action="default.asp" method="post" style="display:none; visibility:hidden;" >
      <input type="hidden" id="var_numperpage" name="var_numperpage" value="<%=numPerPage%>">
      <input type="hidden" id="var_chavereg"   name="var_chavereg"   value="<%=strID_AUTO%>">
      <input type="hidden" id="var_cod_evento"   name="var_cod_evento"   value="<%=strCOD_EVENTO%>">   
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
                        	<%'=strCOD_EVENTO%>
                            <i class=" <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & Session("COD_EVENTO")%>"></i>
							<%=TIT%>
                        </p>
                    </a>
                    <div class="content bg-white span3" style="border:1px solid #CCC;">
                        <div class="panel-content bg-white">	
                        	<!-- ondeficavafiltro--> 
                        </div>
                    </div>
                     
                </div>
            </div>
			<!-- FIM: Filtro (accordiion -para filtragem) //-->
			<!-- INI: Botões //-->
             <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:7px; padding-right:10px;">
                <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp;                
					<!--<p class="button bg-dark fg-white"><a href="#" onClick="javascript:AbreJanelaPAGE('../mini_LctoTransf/insert.asp','520','620')">ADICIONAR</a></p>&nbsp;//-->             </div>
			<!-- FIM: Botões //-->
        </div>
    </div>
	<!-- FIM: grade de dados//-->            
       
    <!-- INI: grade de dados //-->        
    <div id="body_grade" style="position:absolute; top:45px; z-index:8; width:100%">
        <!--#include file="_include_grade.asp"-->                                       
    </div>
    <!-- FIM: grade de dados //-->

</div>
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>