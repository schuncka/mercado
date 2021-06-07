<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|view|", BuscaDireitosFromDB("modulo_clientes",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"                          ' - Default do Modulo...
 Const LTB = "TBL_CLIENTES"	                ' - Nome da Tabela...
 Const DKN = "COD_TBL_CLIENTES"                         ' - Campo chave...
 Const DLD = "../modulo_clientes/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Clientes"                         ' - Carrega o titulo do modulo



 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim strCOD_SERV, strGRUPO, strTITULO, strCOD_EVENTO,strLOJA,strSWFILTRO, strContatoCodStatusCred
 Dim strCOD_CLIENTE, strRAZAO, strCIDADE, strTIPO, strCNPJ, strMarca

'Antes de abir o banco já carrega as variaveis 

 strCOD_CLIENTE    = Replace(GetParam("var_cod_cliente"),"'","''")
 strRAZAO          = Replace(GetParam("var_razao"),"'","''")
 strCNPJ           = replace(GetParam("var_cnpj"),"'","''")
 strCIDADE         = Replace(GetParam("var_cidade"),"'","''")
 strTIPO           = Replace(GetParam("var_tipo"),"'","''")
 strMarca          = Replace(GetParam("var_marca"),"'","''")
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
  
   If strCOD_CLIENTE             <>   "" Then auxSTR = auxSTR & "  AND COD_TBL_CLIENTES    =  '" & strCOD_CLIENTE& "'"
   'If strCOD_EVENTO          <>   "" Then auxSTR = auxSTR & "  AND COD_EVENTO LIKE          '" & strCOD_EVENTO & "%'"
   If strRAZAO                <>   "" Then auxSTR = auxSTR & "  AND NOMEDOCLIENTE      LIKE  '%" & strRAZAO    & "%'"
   if strCIDADE               <>   "" Then auxSTR = auxSTR & "  AND CIDADE             LIKE  '%" & strCIDADE   & "%'"
   if strTIPO				  <>   "" Then auxSTR = auxSTR & "  AND TIPO                  =  '" & strTIPO     & "'"
   if strCNPJ				  <>   "" Then auxSTR = auxSTR & "  AND CGCCPF                =  '" & strCNPJ     & "'"
   if strMARCA				  <>   "" Then auxSTR = auxSTR & "  AND upper(descr_marca)                LIKE  '%" & ucase(strMARCA)     & "%'"
'   if strContatoCodStatusCred <>   "" Then auxSTR = auxSTR & "  AND contato_cod_status_cred LIKE '%" & strContatoCodStatusCred & "%'"

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT   DISTINCT  COD_TBL_CLIENTES, codigodocliente "
 strSQL = strSQL & "		  , NOMEDOCLIENTE "
 strSQL = strSQL & "		  , CGCCPF "
 strSQL = strSQL & "		  , CONCAT(CIDADE,'/',ESTADO) AS cidade_estado"  
 strSQL = strSQL & "		  , NUMERODETELEFONE "
 strSQL = strSQL & "		  , (SELECT TIPO2 FROM TBL_TIPO where IDTIPO = "&LTB&".tipo) AS TIPO "
 strSQL = strSQL & "		  , (select GROUP_CONCAT(DISTINCT descr_marca ORDER BY  descr_marca ASC SEPARATOR ' / ') from tbl_clientes_marcas where cod_cliente = "&LTB&".COD_TBL_CLIENTES) AS MARCAS "
 strSQL = strSQL & "   FROM " & LTB 
 strSQL = strSQL & "      LEFT JOIN tbl_clientes_marcas ON cod_tbl_clientes = cod_cliente "
 strSQL = strSQL & "  WHERE 1 = 1 " & MontaWhereAdds
 strSQL = strSQL & "  ORDER BY NOMEDOCLIENTE"
'' response.write(strSQL)
' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "COD_TBL_CLIENTES        ,NOMEDOCLIENTE  ,CGCCPF         ,cidade_estado       , NUMERODETELEFONE ,TIPO,MARCAS" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(     "COD"         , "RAZAO SOCIAL",  "CNPJ/CPF"   ,  "CIDADE/ESTADO"   , "TELEFONE"       , "TIPO", "MARCAS" )
 arrSort   = Array("sortable-numeric" , "sortable"    , "sortable"    , "sortable"         , "sortable"       , "sortable","sortable"  )
 arrWidth  = Array(     "2%"          , "20%"         ,   "10%"       ,    "10%"           ,  "10%"           , "26%","20%" )  'obs.:[somar 98%] ou deixar todos vazios
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
			<!-- INI: Filtro (accordiion -para filtragem) //-->
            <div class="accordion place-left" data-role="accordion" style="z-index:10; position:absolute; top:0px;">
                <div class="accordion-frame" style="border:0px solid #F00;">
                    <a class="heading text-left fg-active-black" href="#" style="height:45px; background:#CCC">
                    	<p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;"> <i class="icon-search <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & Session("COD_EVENTO")%>"></i> <%=TIT%> </p>
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