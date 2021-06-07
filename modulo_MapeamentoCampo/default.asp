<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_MapeamentoCampo",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          						' - Default do Modulo...
 Const LTB = "tbl_mapeamento_campo"	    				' - Nome da Tabela...
 Const DKN = "ID_AUTO"          			' - Campo chave...
 Const DLD = "../modulo_MapeamentoCampo/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "MapeamentoCampo"    						' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 
 Dim  strCODMAPEA, strNOMECAMPOCLI, strNOMECAMPOPRO, strNOMEDESCRI, strNOMEDESCRIUS, strNOMEDESCRIES  
 Dim  strVINCULOENTI, strCAMPOINSTRU, strCODEVENTO, strLOJASHOW, strCAMPOCOMBOLIST, strCAMPOREQ, strCAMPOCOR 
 Dim  strCAMPOTIPO, strTIPO, strTIPOPESS, strINCLUIRBUSCA

'Antes de abir o banco já carrega as variaveis 

 strCODMAPEA             = Replace(GetParam("var_cod_mapea"),"'","''")
 strCODEVENTO			 = Replace(GetParam("var_cod_evento"),"'","''")
 strNOMECAMPOCLI         = Replace(GetParam("var_nomecli"),"'","''")
 strNOMECAMPOPRO         = Replace(GetParam("var_nomepro"),"'","''")
 strNOMEDESCRI           = Replace(GetParam("var_nomedescri"),"'","''")
 strCAMPOREQ             = Replace(GetParam("var_camporeq"),"'","''")
 strCAMPOCOMBOLIST       = Replace(GetParam("var_campocombolist"),"'","''")
 strCAMPOCOR             = Replace(GetParam("var_campocor"),"'","''")
 strVINCULOENTI          = Replace(GetParam("var_vinculoenti"),"'","''") 
 strLOJASHOW             = Replace(GetParam("var_lojashow"),"'","''")
 strTIPO				 = Replace(GetParam("var_tipo"),"'","''")
 
 'strNOMEDESCRIUS         = Replace(GetParam("var_nomedescri_us"),"'","''")
 'strNOMEDESCRIES         = Replace(GetParam("var_nomedescri_es"),"'","''")
 'strCAMPOINSTRU          = Replace(GetParam("var_campoinstru"),"'","''")
 'strCAMPOREQ             = Replace(GetParam("var_camporeq"),"'","''")
' strCAMPOTIPO		     = Replace(GetParam("var_campotipo"),"'","''")
 'strTIPOPESS			 = Replace(GetParam("var_tipopess"),"'","''")
 'strINCLUIRBUSCA         = Replace(GetParam("var_incluirbusca"),"'","''")
 
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

  
   If strCODMAPEA        <>   ""  Then auxSTR = auxSTR & " AND COD_MAPEAMENTO_CAMPO     LIKE  '" & strCODMAPEA &        "'" 
   If strCODEVENTO       <>   ""  Then auxSTR = auxSTR & " AND COD_EVENTO               LIKE  '" & strCODEVENTO &        "'"    
   If strNOMECAMPOCLI    <>   ""  Then auxSTR = auxSTR & " AND NOME_CAMPO_CLIENTE       LIKE  '" & strNOMECAMPOCLI &    "%'"
   If strNOMEDESCRI      <>   ""  Then auxSTR = auxSTR & " AND NOME_DESCRITIVO          LIKE  '" & strNOMEDESCRI &      "%'"
   If strCAMPOCOMBOLIST  <>   ""  Then auxSTR = auxSTR & " AND CAMPO_COMBOLIST          LIKE  '" & strCAMPOCOMBOLIST &  "'"   
   If strCAMPOCOR        <>   ""  Then auxSTR = auxSTR & " AND CAMPO_COR_DESTAQUE       LIKE  '" & strCAMPOCOR &        "'"
   if (strVINCULOENTI    <>   "")  and  (LCASE(strVINCULOENTI) <> "todos") then
   		if  LCASE(strVINCULOENTI) = "sim" then
			auxSTR = auxSTR & " AND VINCULADO_ENTIDADE IS NOT NULL "
		else
			auxSTR = auxSTR & " AND VINCULADO_ENTIDADE IS NULL "
		end if
   end if
   
   if (strLOJASHOW    <>   "")  and  (LCASE(strLOJASHOW) <> "todos") then
   		if  LCASE(strLOJASHOW) = "0" then
			auxSTR = auxSTR & " AND LOJA_SHOW = 0 "
		else
			if  LCASE(strLOJASHOW) = "0" then
			auxSTR = auxSTR & " AND LOJA_SHOW <> 0"
			END IF
		end if
   end if
   
   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------


	strSQL = " SELECT            ID_AUTO"
	strSQL = strSQL & "		  , COD_MAPEAMENTO_CAMPO"
	strSQL = strSQL & "		  , NOME_CAMPO_CLIENTE"
	strSQL = strSQL & "		  , NOME_CAMPO_PROEVENTO"
	strSQL = strSQL & "		  , NOME_DESCRITIVO"
	strSQL = strSQL & "		  , LOJA_SHOW"
	strSQL = strSQL & "		  , CAMPO_COMBOLIST"
	strSQL = strSQL & "		  , CAMPO_REQUERIDO"
	strSQL = strSQL & "		  , CAMPO_COR_DESTAQUE"
	strSQL = strSQL & "		  , CAMPO_TIPO"
	strSQL = strSQL & "		  , TIPO"
	strSQL = strSQL & "		  , NOME_DESCRITIVO_US"
	strSQL = strSQL & "		  , NOME_DESCRITIVO_ES"
	strSQL = strSQL & "		  , VINCULADO_ENTIDADE"
	strSQL = strSQL & "		  , CAMPO_INSTRUCAO"
	strSQL = strSQL & "		  , TIPOPESS"
	strSQL = strSQL & "		  , INCLUIR_BUSCA"
	strSQL = strSQL & "    FROM " & LTB 
	strSQL = strSQL & "    WHERE 1=1 " & MontaWhereAdds
	strSQL = strSQL & "    ORDER BY COD_MAPEAMENTO_CAMPO"
	
	
	 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))

 ' Define os campos para exibir na grade
 strFields = "ID_AUTO,COD_MAPEAMENTO_CAMPO, NOME_CAMPO_CLIENTE, NOME_CAMPO_PROEVENTO, NOME_DESCRITIVO, CAMPO_COMBOLIST, CAMPO_COR_DESTAQUE" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD"              ,"COD MAPE"              ,  "NOME CLI" ,  "NOME PRO" ,"DESCRI"    ,  "COMBO LIST", "COR"	)
 arrSort   = Array("sortable-numeric" ,"sortable-numeric" , "sortable"  ,  "sortable" , "sortable" ,  "sortable"  , "sortable"	)
 arrWidth  = Array(  "2%"             ,  "4%"             ,     "23%"   ,   "23%"     ,    "12%"   ,  "20%"   	  ,"14%"	    )  'obs.:[somar 98%] ou deixar todos vazios
' ----------------------------------------------------------------------------------------------------------------------------
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
 
strALL_PARAMS = URLDecode(Request.Form)'neste caso não pode usar GetParam
strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para não trancar a paginação

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

			<!-- INI: Botões //-->
            <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:7px; padding-right:10px;">
                <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp;
                <p class="button bg-dark fg-white"><i class="icon-help-2 fg-white" onClick="javascript:location.href='./help/default.asp';"></i></p>
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