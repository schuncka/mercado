<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->  
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Cargo",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          ' - Default do Modulo...
 Const LTB = "tbl_cargos"	    ' - Nome da Tabela...
 Const DKN = "COD_CARGOS"          ' - Campo chave...
 Const DLD = "../modulo_Cargo/default.asp" ' "../evento/data.asp" - 'Default Location ap�s Dele��o
 Const TIT = "Cargo"    ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresenta��o do modulo no bot�o de filtro

 'Relativas a conex�o com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Pagina��o	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim  strCAMPO1, strCAMPO2, strCAMPO3,strCODCARGOS, strSWFILTRO
 
 
'Antes de abir o banco j� carrega as variaveis 
 strCODCARGOS            = Replace(GetParam("var_cod_cargos"),"'","''")
 strCAMPO1               = Replace(GetParam("var_campo1"),"'","''")
 strCAMPO2               = Replace(GetParam("var_campo2"),"'","''")
 strCAMPO3               = Replace(GetParam("var_campo3"),"'","''")
'--------------------------------------------------------------------------------------------------------------
 

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
  
   If strCODCARGOS    <>   ""  Then auxSTR = auxSTR & " AND COD_CARGOS LIKE     '" & strCODCARGOS &   "%'"
   If strCAMPO1       <>   ""  Then auxSTR = auxSTR & " AND CAMPO1 LIKE         '" & strCAMPO1 &   "%'"
   If strCAMPO2       <>   ""  Then auxSTR = auxSTR & " AND CAMPO2 LIKE         '" & strCAMPO2 &   "%'"
   If strCAMPO3       <>   ""  Then auxSTR = auxSTR & " AND CAMPO3 LIKE         '" & strCAMPO3 &   "%'"
   
   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     COD_CARGOS "
 strSQL = strSQL & "		  , CAMPO1 "
 strSQL = strSQL & "		  , CAMPO2 " 
 strSQL = strSQL & "		  , CAMPO3 "
 strSQL = strSQL & "   FROM " & LTB 
 strSQL = strSQL & "  WHERE COD_CARGOS = COD_CARGOS " & MontaWhereAdds
 strSQL = strSQL & "  ORDER BY COD_CARGOS "
 
 'ATHdEBUG STRsql ,TRUE
 
 ' String dos filtros, apenas para marca��o/exibi��o de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "COD_CARGOS,CAMPO1,CAMPO2,CAMPO3" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD"              , "ID"               ,"Descri��o"  , "Extra"    )
 arrSort   = Array("sortable-numeric" , "sortable-numeric" ,"sortable"   , "sortable"  )
 arrWidth  = Array("2"                , "32%"              , "32%"       , "32%"       )  'obs.:[somar 98%] ou deixar todos vazios
' --------------------------------------------------------------------------------------------------------------


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