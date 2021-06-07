<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Evento",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          ' - Default do Modulo...
 Const LTB = "tbl_evento"	    ' - Nome da Tabela...
 Const DKN = "ID_AUTO"          ' - Campo chave...
 Const DLD = "../modulo_evento" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Evento"    ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strCODIGO, strNOME, strATIVO, strPAVILHAO, strESTADO, strCUPOM_FISCAL 
 Dim strVENDA_RAPIDA, strRETIRADA_MATERIAL ,strSWFILTRO,strCOD_EVENTO

'Antes de abir o banco já carrega as variaveis 
 strCODIGO             = Replace(GetParam("var_cod_evento"),"'","''")
 strNOME               = Replace(GetParam("var_nome"),"'","''")
 strPAVILHAO           = Replace(GetParam("var_pavilhao"),"'","''")
 strESTADO             = Replace(GetParam("var_estado"),"'","''")
 strCUPOM_FISCAL       = Replace(GetParam("var_cupom_fiscal"),"'","''")
 strVENDA_RAPIDA       = Replace(GetParam("var_venda_rapida"),"'","''")
 strRETIRADA_MATERIAL  = Replace(GetParam("var_retirada_material"),"'","''")
 strATIVO              = Replace(GetParam("var_ativo"),"'","''")
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
  
   If strCODIGO    <>   ""  Then auxSTR = auxSTR & " AND COD_EVENTO	 =     	 '" & strCODIGO &   "%'"
   If strNOME      <>   "" 	Then auxSTR = auxSTR & " AND NOME LIKE           '" & strNOME &     "%'"
   if strPAVILHAO  <>   ""  Then auxSTR = auxSTR & " AND PAVILHAO LIKE       '" & strPAVILHAO & "%'"
   if strESTADO    <>   ""  Then auxSTR = auxSTR & " AND ESTADO_EVENTO LIKE  '" & strESTADO &   "'"  
   if (strAtivo    <>   "")  and  (LCASE(strAtivo) <> "todos") then
   		if  LCASE(strAtivo) = "ativo" then
			auxSTR = auxSTR & " AND SYS_INATIVO IS NULL "
		else
			auxSTR = auxSTR & " AND SYS_INATIVO IS NOT NULL "
		end if
   end if

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     ID_AUTO "
' strSQL = strSQL & "		  , CONCAT_WS('.',cast(ID_AUTO AS CHAR), cast(COD_EVENTO AS CHAR)) as COD_EVENTO"
 strSQL = strSQL & "		  , COD_EVENTO"
 strSQL = strSQL & "		  , NOME "
 strSQL = strSQL & "		  , PAVILHAO " 
 strSQL = strSQL & "		  , date_format(dt_inicio,'%d-%m-%Y ')"
 strSQL = strSQL & "		  , date_format(dt_fim,'%d-%m-%Y ') "
 strSQL = strSQL & "		  , LOJA_ATIVA "
 strSQL = strSQL & "		  , PSC_ATIVA " 
 strSQL = strSQL & "		  , CUPOM_FISCAL " 
 strSQL = strSQL & "		  , STATUS_CRED" 
 strSQL = strSQL & "   FROM " & LTB 
 strSQL = strSQL & "  WHERE COD_EVENTO = COD_EVENTO " & MontaWhereAdds
 strSQL = strSQL & "  ORDER BY dt_inicio DESC, NOME "
 
 'response.Write(strSQL)
 'response.End()
 
 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "ID_AUTO,COD_EVENTO,NOME,PAVILHAO,date_format(dt_inicio,'%d-%m-%Y '),date_format(dt_fim,'%d-%m-%Y '),LOJA_ATIVA,PSC_ATIVA,CUPOM_FISCAL,STATUS_CRED" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("ID"               ,"COD"             , "NOME"      ,"PAVILHAO"   , "DT INI"             , "DT FIM"            , "LOJA"    , "PSC"     ,"CUPOM FISCAL" ,"STATUS CRED"      )
 arrSort   = Array("sortable-numeric" ,"sortable-numeric", "sortable"  ,"sortable"   , "sortable-date-dmy" , "sortable-date-dmy", "sortable", "sortable","sortable","sortable" )
 arrWidth  = Array("5%"                ,"5%"               , "18%"       , "18%"       , "10%"                , "10%"               , "5%"      , "5%"      ,"10%" ,"12%"      )  'obs.:[somar 98%] ou deixar todos vazios
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
                        <!--DELETE comentado pois neste modo procede que não haja exclusões de registros sem a devida supervisão//-->
                        <% IF ucase(Session("METRO_USER_ID_USER")) = "SAC" OR ucase(Session("METRO_USER_ID_USER")) = "sysMetro" THEN %>
                        <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP?var_chavereg=" & GetValue(objRS,DKN)&"&var_cod_evento="&GetValue(objRS,"COD_EVENTO"),620, 775, "ADICIONAR")%></p>
                        <% END IF  %>
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