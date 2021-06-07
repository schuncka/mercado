<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_AdmProdutoCaex",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"              ' - Default do Modulo...
 Const LTB = "tbl_produtos"	        ' - Nome da Tabela...
 Const DKN = "COD_PROD"             ' - Campo chave...
 Const DLD = "../modulo_AdmProdutoCaex/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Produto"              ' - Carrega o titulo do modulo

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage,strMODE
 Dim strCOD_PROD, strGRUPO, strTITULO, strAtivo,strCOD_EVENTO,strLOCAL, strCODEVENTO,strSWFILTRO

'Antes de abir o banco já carrega as variaveis 
 strCOD_PROD       = Replace(GetParam("var_cod_prod"),"'","''")
 strGRUPO          = Replace(GetParam("var_grupo"),"'","''")
 strTITULO         = Replace(GetParam("var_titulo"),"'","''")
 'strMODE           = Replace(GetParam("var_mode"),"'","''")
 strMODE           = "CAEX"
 strCODEVENTO      = Replace(GetParam("var_cod_evento"),"'","''")
 strLOCAL          = Replace(GetParam("var_local"),"'","''")

'--------------------------------------------------------------------------------------------------------------
 

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
   Dim auxSTR 
   
    'Neste CASO queremso que a filtragem tenhma no míniimo o EVENTO (atual) selecionado no filtro
   if (strCODEVENTO="") then 	
	 strCODEVENTO = SESSION("COD_EVENTO")
   End IF 

  
   If strCOD_PROD     <>   ""  Then auxSTR = auxSTR & " AND COD_PROD    =      '" & strCOD_PROD &   "'"
   If strGRUPO        <>   ""  Then auxSTR = auxSTR & " AND GRUPO LIKE         '" & strGRUPO &      "%'"
   If strCODEVENTO    <>   ""  Then auxSTR = auxSTR & " AND COD_EVENTO  =      '" & strCODEVENTO & "%'"
   If strLOCAL        <>   ""  Then auxSTR = auxSTR & " AND LOCAL LIKE         '" & strLOCAL &      "%'"   
   if strTITULO       <>   ""  Then auxSTR = auxSTR & " AND TITULO LIKE        '" & strTITULO &     "%'"
   
   if (strAtivo       <>   "")  and  (LCASE(strAtivo) <> "todos") then
   		if  LCASE(strAtivo) = "ativo" then
			auxSTR = auxSTR & " AND SYS_DT_INATIVO IS NULL "
		else
			auxSTR = auxSTR & " AND SYS_DT_INATIVO IS NOT NULL "
		end if
   end if
   
   Select Case strMODE
    	Case "CAEX"
    		auxSTR = auxSTR & " AND CAEX_SHOW = 1"
    	Case "CONGRESSO"
    		auxSTR = auxSTR & " AND CAEX_SHOW = 0"
    End Select
   

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT    COD_PROD"
 strSQL = strSQL & "		  , COD_EVENTO "		  		  
 strSQL = strSQL & "		  , GRUPO "
 strSQL = strSQL & "		  , TITULO "
 strSQL = strSQL & "		  , LOCAL "
 strSQL = strSQL & "		  , DESCRICAO "       
 strSQL = strSQL & "   FROM " & LTB 
  strSQL = strSQL & "  WHERE COD_EVENTO = COD_EVENTO" & MontaWhereAdds
 'strSQL = strSQL & "  WHERE COD_EVENTO = " & Session("COD_EVENTO") & MontaWhereAdds
 strSQL = strSQL & "  ORDER BY GRUPO, TITULO"
 
 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))

 ' Define os campos para exibir na grade
 strFields = "COD_PROD,COD_EVENTO,GRUPO,TITULO,LOCAL,DESCRICAO" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(    "COD"          ,    "COD EVENTO"   ,  "GRUPO"   ,"TITULO"   , "LOCAL"     ,"DESCRIÇÃO")
 arrSort   = Array("sortable-numeric" ,"sortable-numeric" , "sortable" ,"sortable" ,"sortable"  ,"sortable"	 )
 arrWidth  = Array(      "2%"         ,      "10%"         , "14%"      , "20%"     ,   "22%"    , "30%"    	 )  'obs.:[somar 98%] ou deixar todos vazios
' --------------------------------------------------------------------------------------------------------------

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
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" id="metrotablevista" onUnload="SaveData()" onLoad="LoadData()">
<div class="grid fluid">
	<!-- INI: barra no topo (filtro e adicionar) //-->
    <div class="bg-lightTeal1" style="border:0px solid #F00; width:100%; height:45px; background-color:#CCC; vertical-align:bottom; padding-left:0px;">
        <div style="width:100%;display:inline-block"> 
			<!-- INI: Filtro (accordiion para filtragem) //-->
            <div class="accordion place-left" data-role="accordion" style="z-index:10; position:absolute; top:0px;">
                <div class="accordion-frame" style="border:0px solid #F00;">
                    <a class="heading text-left fg-active-black" href="#" style="height:45px; background:#CCC">
	                    <p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;">
                        	<i class="icon-search <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " %>"></i>
							<%=TIT%>
                        </p>
                    </a>
                    <div class="content bg-white span3" style="border:1px solid #CCC;">
                        <div class="panel-content bg-white">
                        	  <!--#include file="_include_filtro.asp"-->    
                        </div>
                    </div>
                </div>
            </div>
			<!-- FIM: Filtro (accordiion -para filtragem) //-->
			<!-- INI: Adiconar //-->
            <div class="accordion place-left" data-role="accordion" style="z-index:7; position:relative; top:0px; float:right; padding-top:7px; padding-right:7px;">
                <div class="accordion-frame" style="border:0px solid #F00;">
                    <!--div class="button bg-dark fg-white " style="height:30px; width:100px;margin-top:1px;"//-->
                      <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP",  520, 620, "ADICIONAR")%></p>
                      <p class="button bg-dark fg-white"><i class="icon-help-2 fg-white" onClick="javascript:location.href='./help/default.asp';"></i></p>
                    <!--/div//-->  
                </div>
            </div>   
			<!-- FIM: Adiconar //-->
        </div>
    </div>
	<!-- FIM: grade de dados//-->            
            
    <!-- INI: grade de dados //-->        
    <div style="position:absolute; top:45px; z-index:8; width:100%">
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