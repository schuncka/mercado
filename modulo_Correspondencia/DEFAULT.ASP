<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_database/secure.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Correspondencia",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          ' - Default do Modulo...
 Const LTB = "tbl_evento_corresp"	    ' - Nome da Tabela...
 Const DKN = "ID_AUTO"          ' - Campo chave...
 Const DLD = "../modulo_Correpondencia" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Correspondencia"    ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim  strCAMPO1 ,strCAMPO2, strCAMPO3, strCAMPO4, strCAMPO5, strSWFILTRO,strCODEVENTO
 
 
'Antes de abir o banco já carrega as variaveis 
 strCAMPO1             = Replace(GetParam("var_id_auto"),"'","''")
 strCAMPO2             = Replace(GetParam("var_title"),"'","''")
 strCAMPO3             = Replace(GetParam("var_tipo"),"'","''")
 strCAMPO4             = Replace(GetParam("var_cod_evento"),"'","''")
 strCAMPO5             = Replace(GetParam("var_tipo"),"'","''")

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
  'Neste CASO queremso que a filtragem tenhma no míniimo o EVENTO (atual) selecionado no filtro
   if (strCAMPO4="") then 	
	 strCAMPO4 = SESSION("COD_EVENTO")
   End IF 
 
   Dim auxSTR 
   If strCAMPO4    <>   ""  Then auxSTR = auxSTR & " AND COD_EVENTO     LIKE  		 '" & strCAMPO4 &   "'"  
   If strCAMPO1    <>   ""  Then auxSTR = auxSTR & " AND ID_AUTO 		LIKE    	 '" & strCAMPO1 &   "%'"
   If strCAMPO2    <>   ""  Then auxSTR = auxSTR & " AND TITLE   		LIKE         '" & strCAMPO2 &   "%'"
   If strCAMPO3    <>   ""  Then auxSTR = auxSTR & " AND TIPO   		LIKE         '" & strCAMPO3 &   "%'"
	
   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     ID_AUTO "
 strSQL = strSQL & "		  , COD_EVENTO"
 strSQL = strSQL & "		  , TITLE "
 strSQL = strSQL & "		  , RESUMO "
 strSQL = strSQL & "		  , TIPO " 
 strSQL = strSQL & "    FROM " & LTB 
 strSQL = strSQL & "    WHERE ID_AUTO = ID_AUTO " & MontaWhereAdds
 'strSQL = strSQL & "    AND COD_EVENTO = " & Session("COD_EVENTO")  
 strSQL = strSQL & "    ORDER BY TIPO, TITLE"

' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))
 
 ' Define os campos para exibir na grade
 strFields = "ID_AUTO,COD_EVENTO,TITLE,RESUMO,TIPO," 
 arrFields = Split(strFields,",")        

 arrLabels = Array(    "COD"          ,     "COD.Evento"   ,  "Titulo"  , "Resumo"   , "tipo"      )
 arrSort   = Array("sortable-numeric" , "sortable-numeric" , "sortable" , "sortable" , "sortable"  )
 arrWidth  = Array(  "2%"             ,      "2%"          ,   "42%"    , "42%"       , "10%"      )  'obs.:[somar 98%] ou deixar todos vazios
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
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
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
                        <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP", 520, 720, "ADICIONAR")%></p>
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