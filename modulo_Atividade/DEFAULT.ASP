<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Atividade",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"             ' - Default do Modulo...
 Const LTB = "tbl_atividade"	   ' - Nome da Tabela...
 Const DKN = "CODATIV"             ' - Campo chave...
 Const DLD = "../modulo_Atividade" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Atividade"           ' Carregado o Titulo do modulo 
            
 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim  strCODATIV,strATIVIDADE,strATIVMINI,strCODATIVPAI,strIDAUTO,strATIVMINIINTL, exportaREL,strSWFILTRO

'Antes de abir o banco já carrega as variaveis 
 strCODATIV           = Replace(GetParam("var_codativ"),"'","''")
 strATIVIDADE         =  Replace(GetParam("var_atividade"),"'","''")
 strATIVMINI          = Replace(GetParam("var_ativmini"),"'","''")
 strATIVMINIINTL      = Replace(GetParam("var_ativminiintl"),"'","''")
 strIDAUTO            = Replace (GetParam("var_idauto"),"'","''")
 strCODATIVPAI        = Replace(GetParam("var_codativ_pai"),"'","''")
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
  
   If strCODATIV      <>   ""  Then auxSTR = auxSTR & " AND CODATIV      LIKE   '" & strCODATIV       &   "'"
   If strIDAUTO       <>   ""  Then auxSTR = auxSTR & " AND  ID_AUTO     LIKE   '" & strIDAUTO        &   "'"
   If strATIVIDADE    <>   ""  Then auxSTR = auxSTR & " AND ATIVIDADE    LIKE   '" & strATIVIDADE     &   "%'"
   if strATIVMINI     <>   ""  Then auxSTR = auxSTR & " AND ATIVMINI     LIKE   '" & strATIVMINI      &   "%'"
   if strATIVMINIINTL <>   ""  Then auxSTR = auxSTR & " AND ATIVMINI_INL LIKE   '" & strATIVMINIINTL  &   "%'" 
   If strCODATIVPAI   <>   ""  Then auxSTR = auxSTR & " AND CODATIV_PAI  LIKE   '" & strCODATIVPAI    &   "%'" 
   
   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     CODATIV  "
 strSQL = strSQL & "		  , ID_AUTO   "
 strSQL = strSQL & "		  , ATIVIDADE "
 strSQL = strSQL & "		  , ATIVMINI " 
 strSQL = strSQL & "		  , ATIVMINI_INTL "
 strSQL = strSQL & "		  , CODATIV_PAI " 
 strSQL = strSQL & "		  , LOJA_SHOW "
 strSQL = strSQL & "   FROM " & LTB 
 strSQL = strSQL & "  WHERE CODATIV = CODATIV " & MontaWhereAdds
 strSQL = strSQL & "  ORDER BY CODATIV_PAI, ATIVIDADE"

 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 
 
 ' Define os campos para exibir na grade
 strFields = "CODATIV,ID_AUTO, ATIVIDADE, ATIVMINI,ATIVMINI_INTL,CODATIV_PAI,LOJA_SHOW" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(     "COD"         ,       "ID"         , "DESCRIÇÃO" ,"RESUMIDO" ,"ATIVMINI_INTL"      ,"CODATIV_PAI","LOJA_SHOW"  )
 arrSort   = Array("sortable-numeric" , "sortable-numeric",  "sortable"  ,"sortable" , "sortable-date-dmy" , "sortable"  , "sortable"  )
 arrWidth  = Array(     "2%"          ,       "2%"       ,    "30%"     , "30%"     , "30%"                ,      "2%"   ,    "2%"     )  'obs.:[somar 98%] ou deixar todos vazios
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