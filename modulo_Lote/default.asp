<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Lote",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          ' - Default do Modulo...
 Const LTB = "tbl_LOTE"	    ' - Nome da Tabela...
 Const DKN = "COD_lote"          ' - Campo chave...
 Const DLD = "../modulo_Lote/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "lote"    ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim strCODIGO, strNOME, strATIVO, strDESCRICAO, strTOTALREG, strSYSUSERCA, strSWFILTRO
 Dim strDTCRI, strDTLASTUPDATE, strSQLCRITE, arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage



'Antes de abir o banco já carrega as variaveis 
 strCODIGO          = Replace(GetParam("var_cod"),"'","''")
 strNOME            = Replace(GetParam("var_nome"),"'","''")
 strDESCRICAO       = Replace(GetParam("var_descricao"),"'","''")
 strSYSUSERCA       = Replace(GetParam("var_sysuserca"),"'","''")
 strATIVO           = Replace(GetParam("var_ativo"),"'","''")


'Caso necessario apenas descomentar e ativar no form do filtro e a MontaWhereAdds
'--------------------------------------------------------------------------------
'strDTLASTUPDATE    = Replace(GetParam("var_dtlastupdate"),"'","''")
'strDTCRI  			= Replace(GetParam("var_dtcri"),"'","''")
'strSQLCRITE        = Replace(GetParam("var_sqlcrite"),"'","''")
'strTOTALREG        = Replace(GetParam("var_totalreg"),"'","''")

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
   
   if strATIVO = "" then 
   	strATIVO = "ativo"
	end if
    
   If strCODIGO   	  <>   ""  Then auxSTR = auxSTR & " AND COD_LOTE LIKE        '" & strCODIGO &   	 "'"
   If strNOME     	  <>   ""  Then auxSTR = auxSTR & " AND NOME LIKE            '" & strNOME & 		 "%'"
   if strDESCRICAO	  <>   ""  Then auxSTR = auxSTR & " AND DESCRICAO LIKE       '" & strDESCRICAO & 	 "%'"
   if strTOTALREG	  <>   ""  Then auxSTR = auxSTR & " AND TOTAL_REGISTROS LIKE       '" & strTOTALREG & 	 "'"
   if strSYSUSERCA	  <>   ""  Then auxSTR = auxSTR & " AND SYS_USERCA LIKE       '" & strSYSUSERCA &	 "%'"
   'if strDTCRI		  <>   ""  Then auxSTR = auxSTR & " AND DESCRICAO LIKE       '" & strDTCRI &		 "'"
   'if strDTLASTUPDATE <>   ""  Then auxSTR = auxSTR & " AND DESCRICAO LIKE       '" & strDTLASTUPDATE &  "'"
   'if strSQLCRITE	  <>   ""  Then auxSTR = auxSTR & " AND DESCRICAO LIKE       '" & strSQLCRITE & 	 "'"
   if (strAtivo    	  <>   "")  and  (LCASE(strAtivo) <> "todos") then
   		if  LCASE(strAtivo) = "ativo" then
			auxSTR = auxSTR & " AND DT_INATIVO IS NULL "
		else
			auxSTR = auxSTR & " AND DT_INATIVO IS NOT NULL "
		end if
   end if

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     COD_LOTE "
 strSQL = strSQL & "		  , NOME "
' strSQL = strSQL & "		  , SUBSTRING(DESCRICAO,1,30) " 
 strSQL = strSQL & "		  , TOTAL_REGISTROS "
 'strSQL = strSQL & "		  , SYS_USERCA "
 strSQL = strSQL & "		  , date_format(DT_CRIACAO ,'%d-%m-%Y ')"
 strSQL = strSQL & "		  , date_format(DT_INATIVO ,'%d-%m-%Y ')" 
 'strSQL = strSQL & "		  , date_format(DT_LASTUPDATE ,'%d-%m-%Y ')" 
 'strSQL = strSQL & "		  , NOMINAL " 
 'strSQL = strSQL & "		  , SUBSTRING(SQL_CRITERIO,1,50) " 
 strSQL = strSQL & "   FROM " & LTB 
 strSQL = strSQL & "  WHERE COD_LOTE = COD_LOTE " & MontaWhereAdds
 strSQL = strSQL & "  ORDER BY NOME, DT_CRIACAO"
 
 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))

 ' Define os campos para exibir na grade
 strFields = "COD_LOTE,NOME,SUBSTRING(DESCRICAO,1,30),TOTAL_REGISTROS,SYS_USERCA,date_format(DT_CRIACAO ,'%d-%m-%Y '),date_format(DT_LASTUPDATE ,'%d-%m-%Y '),NOMINAL,SUBSTRING(SQL_CRITERIO,1,50)" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD"              , "NOME"      ,"TOTAL REG"        ,"DT INI"            )
 arrSort   = Array("sortable-numeric" , "sortable"  ,"sortable-numeric" , "sortable-date-dmy")
 arrWidth  = Array("2%"               , "20%"       , "15%"             ,      "71%"         )  'obs.:[somar 98%] ou deixar todos vazios
' -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


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
			<!-- INI: Filtro (accordiion -para filtragem) //-->
            <div class="accordion place-left" data-role="accordion" style="z-index:10; position:absolute; top:0px;">
                <div class="accordion-frame" style="border:0px solid #F00;">
                     <a class="heading text-left fg-active-black" href="#" style="height:45px; background:#CCC">
                    	<p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;"> <i class="icon-search <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & Session("COD_EVENTO") & "|" & lcase(strATIVO)%>"></i> <%=TIT%> </p>
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
                        <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>
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