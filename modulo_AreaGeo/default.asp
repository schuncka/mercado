<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_AreaGeo",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          				' - Default do Modulo...
 Const LTB = "tbl_areageo"	    				' - Nome da Tabela...
 Const DKN = "Id_areageo"          				' - Campo chave...
 Const DLD = "../modulo_AreaGeo/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Area Geo"    						' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strCODAREA, strAREA, strEVENTO, strSQL2
 
'Carraga os valores das varíáveis enviadaos pelo filtro 
 strCODAREA             = Replace(GetParam("var_Id_Areageo"),"'","''")
 strAREA                = Replace(GetParam("var_areageo"),"'","''")
 strEVENTO              = Session("Cod_Evento")
 
 'strCODAREATRIM = Int(Trim(getValue(objRS,"a.ID_AreaGeo")))

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
  
   If strCODAREA     <>   ""  Then auxSTR = auxSTR & " AND tbl_areageo_Cep.ID_AreaGeo_Cep LIKE  '" & strCODAREA & "%'"   
   If strAREA        <>   ""  Then auxSTR = auxSTR & " AND tbl_areageo.Nome_AreaGeo LIKE	'" & strAREA   & "%'"

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
	
strSQL = "	SELECT  tbl_areageo.ID_AreaGeo "
strSQL = strSQL & "	,tbl_areageo.Nome_AreaGeo "
strSQL = strSQL & "	,tbl_evento.NOME "
strSQL = strSQL & "	,tbl_areageo_cep.Id_AreaGeo_Cep "
strSQL = strSQL & "	,tbl_areageo_cep.Cep_Ini "
strSQL = strSQL & "	,tbl_areageo_cep.Cep_Fim "
strSQL = strSQL & "	,tbl_areageo_cep.ID_PAIS "
strSQL = strSQL & "	FROM tbl_areageo_cep,tbl_areageo INNER JOIN tbl_evento ON tbl_areageo.Cod_Evento = tbl_evento.COD_EVENTO "
strSQL = strSQL & "	WHERE tbl_areageo.ID_AreaGeo=tbl_areageo_cep.ID_AreaGeo "&MontaWhereAdds
strSQL = strSQL & "	and tbl_areageo.Cod_Evento="&strEVENTO
strSQL = strSQL & "	ORDER BY tbl_areageo.ID_AreaGeo "
 
 'athDebug strSQL ,true
	
	
	'strSQL = "SELECT tbl_areageo.ID_AreaGeo,tbl_areageo.Nome_AreaGeo, tbl_evento.NOME "&_
'		 " FROM tbl_areageo  INNER JOIN tbl_evento ON tbl_areageo.Cod_Evento = tbl_evento.COD_EVENTO"&_
'		 " WHERE tbl_areageo.Cod_Evento="&strEVENTO&_
'         MontaWhereAdds &_
'		" ORDER BY tbl_areageo.ID_AreaGeo"
'	 
'	 
'	 strSQL2 = "SELECT id_AreaGeo_cep, Cep_Ini, Cep_Fim, ID_PAIS, ID_AreaGeo FROM  tbl_areageo_cep " &_
'	 				"INNER JOIN tbl_areageo ON tbl_areageo.ID_AreaGeo = id_AreaGeo_cep.ID_AreaGeo"

'  

'strSQL = " SELECT a.ID_AreaGeo "
'strSQL = strSQL & "	,a.Nome_AreaGeo "
'strSQL = strSQL & "	,e.NOME "
'strSQL = strSQL & "	,ac.id_AreaGeo_cep "
'strSQL = strSQL & "	,ac.Cep_Ini "
'strSQL = strSQL & " ,ac.Cep_Fim "
'strSQL = strSQL & "	,ac.ID_PAIS "
'strSQL = strSQL & "	,ac.ID_AreaGeo "
'strSQL = strSQL & "	 FROM tbl_areageo as a,tbl_areageo_cep as ac, tbl_evento as e "
'strSQL = strSQL & "	WHERE e.Cod_Evento= a.cod_evento "
''strSQL = strSQL & "	and a.id_are_geo = " & strCODAREATRIM
'strSQL = strSQL & "	ORDER BY a.ID_AreaGeo "


 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 'strFields = "a.ID_AreaGeo,a.Nome_AreaGeo,ac.Cep_Ini,ac.Cep_Fim,id_Pais,e.NOME" 
 'arrFields = Split(strFields,",")  
 
 ' Define os campos para exibir na grade
 strFields = "a.ID_AreaGeo,a.Nome_AreaGeo,tbl_evento.NOME,tbl_areageo_cep.Id_AreaGeo_Cep,Cep_Ini,Cep_Fim,tbl_areageo_cep.ID_PAIS" 
 arrFields = Split(strFields,",")          

 arrLabels = Array("CODIGO"              ,  "DESCRICAO" , "EVENTO","ID CEP" , "CEP INI" ,   "CEP FIM"    ,  "PAIS" )
 arrSort   = Array("sortable-numeric" , "sortable",   "sortable" , "sortable"  , "sortable"  , "sortable" , "sortable" ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array("2%"               ,     "25%"   ,   "30%"     , "20%"  , "10%"    , "10%"      , "10%"  )     'Obs.:[somar 98%] ou deixar todos vazios
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