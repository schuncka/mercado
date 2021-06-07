<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_BreteCred",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          				' - Default do Modulo...
 Const LTB = "TBL_LOCAL_CREDENCIAL_SITE" 		' - Nome da Tabela...
 Const DKN = "COD_LOCAL_CREDENCIAL_SITE"		' - Campo chave...
 Const DLD = "../modulo_EntradaCred/mini_BreteCred/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "LCredencialSite"				' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCODIGO,strCODLOCALCREDENCIAL,strCODLOCALCREDENCIALSITE, strNOME, strLOCAL, strDESCRICAO, auxHPath
 
IF strCODLOCALCREDENCIAL = "" THEN 
	strCODLOCALCREDENCIAL 		= Replace(GetParam("var_chavereg"),"'","''")
END IF

'Carraga os valores das varíáveis enviadaos pelo filtro 
'---------------carrega cachereg do pai local cred-----------------
strCODLOCALCREDENCIAL 		= Replace(GetParam("var_chavereg"),"'","''")
'strCODLOCALCREDENCIALSITE 	= Replace(GetParam("var_chavereg"),"'","''")

'------------------------------------------------------------------
 strCODLOCALCREDENCIALSITE	= Replace(GetParam("var_cod_localcredencialsite"),"'","''")
 strNOME                	= Replace(GetParam("var_nome"),"'","''")
 strLOCAL               	= Replace(GetParam("var_local"),"'","''")
 strDESCRICAO				= Replace(GetParam("var_descricao"),"'","''")

'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão
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
   'Dim auxSTR 
   
   'If strCODLOCALCREDENCIAL     	<>   ""  Then auxSTR = auxSTR & " AND COD_LOCAL_CREDENCIAL    = '" & strCODLOCALCREDENCIAL  & 			"'"  
   'If strNOME     					<>   ""  Then auxSTR = auxSTR & " AND NOME      LIKE			'" & strNOME & 			"%'" 
   'If strLOCAL     					<> 	 ""  Then auxSTR = auxSTR & " AND LOCAL     LIKE 		    '" & strLOCAL   & 		"%'"
   'If strDESCRICAO 					<>   ""  Then auxSTR = auxSTR & " AND DESCRICAO LIKE 			'" & strDESCRICAO &		 "%'"
 
   'MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

		  strSQL = " SELECT     COD_LOCAL_CREDENCIAL_SITE "
 strSQL = strSQL & "		  , COD_EVENTO"		  
 strSQL = strSQL & "		  , NOME"
 strSQL = strSQL & "		  , LOCAL "
 strSQL = strSQL & "		  , OBS "
 strSQL = strSQL & "    FROM " & LTB 
 strSQL = strSQL & "    WHERE COD_LOCAL_CREDENCIAL = " & strCODLOCALCREDENCIAL
 strSQL = strSQL & "      AND ( (COD_EVENTO LIKE '" & session("METRO_EVENTO_COD_EVENTO") & "') OR (COD_EVENTO IS NULL) OR (COD_EVENTO LIKE '') )"
 strSQL = strSQL & "    ORDER BY COD_LOCAL_CREDENCIAL_SITE"
 'athDebug strSQL , false

 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "COD_LOCAL_CREDENCIAL_SITE,COD_EVENTO, NOME, LOCAL, OBS" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD"              ,  "COD EVENTO" 	        ,  "NOME" 	,  "LOCAL"  ,   "OBS"   )
 arrSort   = Array("sortable-numeric" , "sortable-numeric" ,"sortable"  , "sortable","sortable" ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array("2%"               ,     "25%"  		   ,   "10%"    ,    "10%"  ,"15%"  	)     'Obs.:[somar 98%] ou deixar todos vazios
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
</head>
<body class="metro">
<!-- Embora um MINI Módulo esteja convencionado a não ter elementos de filtragem
         criamos este Formulário de filtro necessário para envio da página corrrente
         armazenamento da qqtde de elementos por págtina //-->
    <form id="formfiltro" name="formfiltro" action="default.asp" method="post" style="display:none; visibility:hidden;" >
      <input type="hidden" id="var_numperpage" name="var_numperpage" value="<%=numPerPage%>">
      <input type="hidden" id="var_chavereg"   name="var_chavereg"   value="<%=strCODLOCALCREDENCIAL%>">
     </form>
<div class="grid fluid">
    <!-- INI: barra no topo (filtro e adicionar) //-->
    <div class="bg-lightBlue" style="border:0px solid #F00; width:100%; height:45px; background-color:#CCC; vertical-align:bottom; padding-left:0px;">
        <div style="width:100%;display:inline-block"> 
       
			<!-- INI: Filtro (accordiion para filtragem) //-->
            <div class="accordion place-left"  style="z-index:10; position:absolute; top:0px;">
                <div class="accordion-frame" style="border:0px solid #F00;">
                
                    <a class="heading text-left bg-lightBlue fg-active-black" href="javascript:document.getElementById('formfiltro').submit();" style="height:45px;">
	                    <p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;">
                        	<%=strCODLOCALCREDENCIAL%>.
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
<!--                <p class="button bg-dark fg-white"><'%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp;//-->                
					<p class="button bg-dark fg-white"><a href="#" onClick="javascript:AbreJanelaPAGE_NOVA('insert.asp?var_chavemaster=<%=strCODLOCALCREDENCIAL%>','520','620')">ADICIONAR</a></p>&nbsp;                

             </div>
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