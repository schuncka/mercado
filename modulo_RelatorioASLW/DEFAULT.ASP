<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_RelatorioASLW",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"                  ' - Default do Modulo...
 Const LTB = "tbl_aslw_relatorio"	    ' - Nome da Tabela...
 Const DKN = "COD_RELATORIO"            ' - Campo chave...
 Const DLD = "../modulo_RelatorioASLW"  ' "../relatorio_aslw/data.asp" 'Default Location após Deleção
 Const TIT = "Relatorio ASLW"           ' Carrega o titulo do modulo no botão filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim strCOD_RELATORIO, strNOME, strCOD_CATEGORIA, strATIVO, strDESCRICAO ,strSWFILTRO
 
 
 'Antes de abir o banco já carrega as variaveis 
 strCOD_RELATORIO     = Replace(GetParam("var_cod_relatorio"),"'","''")
 strCOD_CATEGORIA     = Replace(GetParam("var_cod_categoria"),"'","''")
 strNOME              = Replace(GetParam("var_nome"),"'","''")
 strATIVO             = Replace(GetParam("var_ativo"),"'","''")

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
  
   If strCOD_RELATORIO      <>   ""  Then auxSTR = auxSTR & " AND COD_RELATORIO LIKE  '" & strCOD_RELATORIO &  "%'"
   If strCOD_CATEGORIA      <>   ""  Then auxSTR = auxSTR & " AND COD_CATEGORIA LIKE  '" & strCOD_CATEGORIA &  "%'"
   if strNOME               <>   ""  Then auxSTR = auxSTR & " AND NOME LIKE           '" & strNOME & "%'"
   if (strATIVO    <>   "")  and  (LCASE(strAtivo) <> "todos") then
   		if  LCASE(strATIVO) = "ativo" then
			auxSTR = auxSTR & " AND DT_INATIVO IS NULL "
		else
			auxSTR = auxSTR & " AND DT_INATIVO IS NOT NULL "
		end if
   end if

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

' strSQL = " SELECT    COD_RELATORIO "
' strSQL = strSQL & "	   ,COD_CATEGORIA "
'' strSQL = strSQL & "		  , CONCAT_WS('.',cast(COD_CATEGORIA AS CHAR), cast(COD_EVENTO AS CHAR)) as COD_EVENTO" 
' strSQL = strSQL & "	   ,NOME "
' strSQL = strSQL & "       ,MID(DESCRICAO,1,150)"
' strSQL = strSQL & " AS    DESCRICAO "
' strSQL = strSQL & "       ,SYS_CRIA "
' strSQL = strSQL & "	   ,EXECUTOR " 			
' strSQL = strSQL & " FROM " & LTB
' strSQL = strSQL & " WHERE DT_INATIVO IS NULL " & MontaWhereAdds
' strSQL = strSQL & " ORDER BY COD_RELATORIO, DESCRICAO "
 
 strSQL = " SELECT T1.COD_RELATORIO "
	strSQL = strSQL & "	 , T1.COD_CATEGORIA, T2.NOME AS CATEGORIA "
	strSQL = strSQL & "	 , T1.NOME  " 	
	strSQL = strSQL & "	 , T1.DESCRICAO "
	strSQL = strSQL & "	 , T1.EXECUTOR  "
	strSQL = strSQL & "	 , T1.PARAMETRO "  
	strSQL = strSQL & "	 , T1.SYS_CRIA "
	strSQL = strSQL & "	 , T1.SYS_ALTERA "
	strSQL = strSQL & "	 , T1.DT_CRIACAO "
	strSQL = strSQL & "	 , T1.DT_INATIVO "
	strSQL = strSQL & "	 , T1.DT_ALTERACAO "
  strSQL = strSQL & "	 FROM tbl_ASLW_RELATORIO T1 " 
  strSQL = strSQL & "	 LEFT OUTER JOIN tbl_ASLW_CATEGORIA T2 ON (T1.COD_CATEGORIA = T2.COD_CATEGORIA) " 
  strSQL = strSQL & "     WHERE DT_INATIVO IS NULL " & MontaWhereAdds  


 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 
 
 ' Define os campos para exibir na grade
 strFields = "COD_RELATORIO,CATEGORIA,COD_CATEGORIA,NOME,DESCRICAO,SYS_CRIA" 
 arrFields = Split(strFields,",")   
     

 arrLabels = Array("COD"              ,"COD CATEG"         ,"CATEGORIA", "NOME"      ,"DESCRICAO"  , "SYS_CRIA"           )
 arrSort   = Array("sortable-numeric" ,"sortable-numeric" , "sortable"  , "sortable"  ,"sortable"   , "sortable-date-dmy"  )
 arrWidth  = Array("2%"                ,"5%"             , "12%"  		, "27%"       , "40%"       , "10%"                )  'obs.:[somar 98%] ou deixar todos vazios
' --------------------------------------------------------------------------------------------------------------

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 



 strALL_PARAMS = URLDecode(Request.Form) 'neste caso não pode usar GetParam
 strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para não trancar a paginaçãoz
 'athDebug "[" & strALL_PARAMS & "]", false

 If (not objRS.eof) Then 
   objRS.AbsolutePage = GetCurPage
 End If
 
%>
<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista" onunload="SaveData()" onload="LoadData()">
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
                      <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp; <p class="button bg-dark"><%=AthWindow("viewtables.asp", 520, 620,"<i class='icon-layers fg-white' id='abretables' onClick='' title='Apresenta Visualizador de Tabelas'></i>")%></p>
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


