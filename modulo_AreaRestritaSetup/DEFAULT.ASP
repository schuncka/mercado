<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_AreaRestritaSetup",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"                      ' - Default do Modulo...
 Const LTB = "tbl_area_restrita_expositor"	' - Nome da Tabela...
 Const DKN = "idauto"                       ' - Campo chave...
 Const DLD = "../modulo_AreaRestritaSetup"  ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "CAEX SETUP"                   ' Carregado o Titulo do modulo 
            
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS,strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 
 Dim strCOD_EVENTO, strNOME, strTITULO, strLANG

'Antes de abir o banco já carrega as variaveis 
strCOD_EVENTO   = Session ("METRO_EVENTO_COD_EVENTO")
	
'-------------------------------------------------------------------------------------------------------------
 strCOD_EVENTO   = Replace(GetParam("var_cod_evento"),"'","''")
 strNOME 		 = Replace(GetParam("var_nome"),"'","''")
 strLANG 		 = Replace(GetParam("var_lang"),"'","''")
 strTITULO  	 = Replace(GetParam("var_titulo"),"'","''")
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
  
   If strCOD_EVENTO  <>   ""  Then auxSTR = auxSTR & " AND t1.cod_evento  = '" & strCOD_EVENTO    &   "'"
   If strNOME        <>   ""  Then auxSTR = auxSTR & " AND t2.nome LIKE    '" & strNOME        &   "'"
   If strLANG        <>   ""  Then auxSTR = auxSTR & " AND t1.lang LIKE    '" & strLANG          &   "%'"
     
   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		
		  strSQL = " SELECT t1.idauto  "
 strSQL = strSQL & "		  , t1.cod_evento   "
 strSQL = strSQL & "		  , t2.nome "
 strSQL = strSQL & "		  , t1.lang " 
 strSQL = strSQL & "		  , t1.dt_ini "
 strSQL = strSQL & "		  , t1.dt_fim " 
 strSQL = strSQL & "		  , t1.sys_inativo "
 strSQL = strSQL & "  FROM tbl_area_restrita_expositor AS t1 "
 strSQL = strSQL & "  	INNER JOIN tbl_evento AS t2 ON (t1.cod_evento = t2.cod_evento) "
 strSQL = strSQL & "  WHERE 1 = 1 " & MontaWhereAdds
 strSQL = strSQL & "  AND t1.cod_evento =" & Session ("METRO_EVENTO_COD_EVENTO")
 strSQL = strSQL & "  ORDER BY t2.nome, t1.lang, t1.dt_ini "
 
 'athdebug strSQL, true

' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 


 ' Define os campos para exibir na grade
 strFields = "t1.cod_evento,t2.nome, t1.lang , t1.dt_ini , t1.dt_fim ,t1.sys_inativo " 
 arrFields = Split(strFields,",")        

 arrLabels = Array(     "EVENTO"      ,       "NOME"      , "LÍNGUA"   ,"DT_INI"   ,    "DT_FIM"        ,"INATIVO"     )
 arrSort   = Array("sortable-numeric" , "sortable-numeric",  "sortable","sortable" , "sortable-date-dmy", "sortable" )
 arrWidth  = Array(     "2%"          ,       "30%"       ,    "20%"   , "20%"     ,      "16%"         ,   "10%"  )  'obs.:[somar 98%] ou deixar todos vazios
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
	                    <p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;">
                        	<i class="icon-search <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & Session("COD_EVENTO")%>"></i>
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