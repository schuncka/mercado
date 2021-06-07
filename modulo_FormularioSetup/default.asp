<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FormularioSetup",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          						' - Default do Modulo...
 Const LTB = "tbl_formulario_setup"	    				' - Nome da Tabela...
 Const DKN = "idauto"          							' - Campo chave...
 Const DLD = "../modulo_FormularioSetup/default.asp" 	' "../evento/data.asp" - 'Default Location ap�s Dele��o
 Const TIT = "Form Setup"    							' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresenta��o do modulo no bot�o de filtro

 'Relativas a conex�o com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Pagina��o	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strIDAUTO ,strCAMPO, strREQUERIDO, strREQCODPAIS, strTABELA, strFORMULARIO,  strCODEVENTO, strETAPA, strVINCULOENT, strORDEM 
 
 
'Carrega os par�metros de filtragem
 strIDAUTO             = Replace(GetParam("var_idauto"),"'","''")
 strCODEVENTO          = Replace(GetParam("var_cod_evento"),"'","''")
 strCAMPO              = Replace(GetParam("var_campo"),"'","''")
 strREQUERIDO          = Replace(GetParam("var_requerido"),"'","''")
 strREQCODPAIS         = Replace(GetParam("var_reqcodpais"),"'","''")
 strTABELA             = Replace(GetParam("var_tabela"),"'","''")
 strFORMULARIO         = Replace(GetParam("var_formulario"),"'","''")
 strETAPA              = Replace(GetParam("var_etapa"),"'","''")
 strVINCULOENT         = Replace(GetParam("var_vinculo_ent"),"'","''")
 strORDEM              = Replace(GetParam("var_ordem"),"'","''")


'Relativo P�gina��o, mas para controle de linhas por p�gina----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configura��es de conex�o
 AbreDBConn objConn, CFG_DB 
'---------------------------------------------------------------------------------------------------------------

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

' Monta FILTRAGEM -----------------------------------------------------------------------------------------------
 Function MontaWhereAdds
   Dim auxSTR 
  
   'Neste CASO queremso que a filtragem tenhma no m�niimo o EVENTO (atual) selecionado no filtro
   if (strCODEVENTO="") then 	
	 strCODEVENTO = SESSION("COD_EVENTO")
   End IF 

   If strIDAUTO        <>   ""  Then auxSTR = auxSTR & " AND idauto                   =" & strIDAUTO 
   If strCAMPO         <>   ""  Then auxSTR = auxSTR & " AND CAMPO    			LIKE  '" & strCAMPO &            "%'"
   If strREQUERIDO     <>   ""  Then auxSTR = auxSTR & " AND REQUERIDO    		LIKE  '" & strREQUERIDO &        "%'"
   If strTABELA        <>   ""  Then auxSTR = auxSTR & " AND TABELA    			LIKE  '" & strTABELA &           "%'"
   If strFORMULARIO    <>   ""  Then auxSTR = auxSTR & " AND FORMULARIO    		LIKE  '" & strFORMULARIO &       "%'"
   If strCODEVENTO     <>   ""  Then auxSTR = auxSTR & " AND COD_EVENTO    		LIKE  '" & strCODEVENTO &        "'"
   If strETAPA         <>   ""  Then auxSTR = auxSTR & " AND ETAPA    			LIKE  '" & strETAPA &            "%'"
   If strVINCULOENT    <>   ""  Then auxSTR = auxSTR & " AND VINCULADO_ENTIDADE LIKE  '" & strVINCULOENT &       "'"
  

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     idauto "
 strSQL = strSQL & "		  , CAMPO"
 strSQL = strSQL & "		  , TABELA " 
 strSQL = strSQL & "		  , FORMULARIO " 
 strSQL = strSQL & "		  , COD_EVENTO"
 strSQL = strSQL & "		  , ETAPA"
 strSQL = strSQL & "		  , REQUERIDO "
 strSQL = strSQL & "		  , VINCULADO_ENTIDADE"
 strSQL = strSQL & "		  , ORDEM"
 strSQL = strSQL & "    FROM " & LTB 
 strSQL = strSQL & "    WHERE idauto = idauto " & MontaWhereAdds
 strSQL = strSQL & "    GROUP BY idauto, cod_evento"
 
 ' String dos filtros, apenas para marca��o/exibi��o de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))

 ' Define os campos para exibir na grade
 strFields = "idauto,CAMPO,TABELA,FORMULARIO,COD_EVENTO,ETAPA,REQUERIDO,VINCULADO_ENTIDADE" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD"              ,  "CAMPO"   ,   "TABELA"    ,  "FORM"     , "COD_EVENTO" , "ETAPA"    ,"REQUERIDO", "VINCULO" )
 arrSort   = Array("sortable-numeric" , "sortable" ,   "sortable"  , "sortable"  , "sortable"   , "sortable" ,  "sortable","sortable")
 arrWidth  = Array(  "2%"             ,     "8%"  ,   "28%"       ,    "20%"     , "8%"        , "8%"      ,   "10%", "14%"     )  'obs.:[somar 98%] ou deixar todos vazios
' --------------------------------------------------------------------------------------------------------------------------------------

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
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro">
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

			<!-- INI: Bot�es //-->
            <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:7px; padding-right:10px;">
                <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp;
                <p class="button bg-dark fg-white"><i class="icon-help-2 fg-white" onClick="javascript:location.href='./help/default.asp';"></i></p>
            </div>
			<!-- FIM: Bot�es //-->
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