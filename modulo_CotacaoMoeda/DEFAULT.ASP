<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CotacaoMoeda",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"                    ' - Default do Modulo...
 Const LTB = "tbl_moeda_cotacao"          ' - Nome da Tabela...
 Const DKN = "ID_AUTO"                    ' - Campo chave...
 Const DLD = "../modulo_CotacaoMoeda"     ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Cotação Moeda"              ' - Carrega o titulo do modulo



 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim strRETIRADA_MATERIAL, arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim strID_AUTO,strCODMOEDA,strCOD_MOEDA_ORIGEM, strCOD_MOEDA_DESTINO, strDATA,strSWFILTRO
 
 
'Antes de abir o banco já carrega as variaveis 
 strCODMOEDA              = Replace(GetParam("var_codmoeda"),"'","''")
 strID_AUTO               = Replace(GetParam("var_idauto"),"'","''")
 strCOD_MOEDA_ORIGEM      = Replace(GetParam("var_moedaorigem"),"'","''")
 strCOD_MOEDA_DESTINO     = Replace(GetParam("var_moedadestino"),"'","''")
 strDATA                  = Replace(GetParam("var_data"),"'","''")
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
   
   if strCODMOEDA           <>   ""  Then auxSTR = auxSTR & " AND COD_MOEDA LIKE          '" & strCODMOEDA &          "%'" 
   If strID_AUTO            <>   ""  Then auxSTR = auxSTR & " AND ID_AUTO LIKE            '" & strID_AUTO &           "%'"
   If strCOD_MOEDA_ORIGEM   <>   ""  Then auxSTR = auxSTR & " AND COD_MOEDA_ORIGEM LIKE   '" & strCOD_MOEDA_ORIGEM &  "%'"
   if strCOD_MOEDA_DESTINO  <>   ""  Then auxSTR = auxSTR & " AND COD_MOEDA_DESTINO LIKE  '" & strCOD_MOEDA_DESTINO & "%'"
   if strDATA               <>   ""  Then auxSTR = auxSTR & " AND COTACAO_DATA LIKE       '" & strDATA &              "%'"  
  

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  strSQL = " SELECT     MC.ID_AUTO, MO.MOEDA " 
 strSQL = strSQL & "		AS MOEDA_ORIGEM, MD.MOEDA  "
 strSQL = strSQL & "		AS MOEDA_DESTINO, MC.COTACAO_DATA, MC.COTACAO_TAXA   " 
 strSQL = strSQL & "  FROM TBL_MOEDA_COTACAO MC, TBL_MOEDA MO, TBL_MOEDA MD "  
 strSQL = strSQL & "  WHERE MO.COD_MOEDA = MC.COD_MOEDA_ORIGEM  AND  MD.COD_MOEDA = MC.COD_MOEDA_DESTINO " & MontaWhereAdds 
 strSQL = strSQL & "  ORDER BY MC.ID_AUTO DESC "

  ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 
 
 ' Define os campos para exibir na grade
 strFields = "ID_AUTO,COD_MOEDA_ORIGEM,COD_MOEDA_DESTINO,COTACAO_DATA,COTACAO_TAXA" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(     "CÓDIGO"     , "MOEDA ORIGEM","MODEDA DESTINO" , "DATA COTAÇÃO"      ,     "TAXA"          )
 arrSort   = Array("sortable-numeric" , "sortable"    ,   "sortable"    , "sortable-date-dmy" , "sortable-numeric" )
 arrWidth  = Array(       "4%"       ,     "15%"     ,    "15%"        ,       "15%"          ,      "49%"         )  'obs.:[somar 98%] ou deixar todos vazios
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
<script language="javascript" type="text/javascript">
//função para ativar o date picker dos campos data
$("#datepicker").datepicker({
date: "2013-01-01", // set init date //<!--quando utlizar o datepicker nao colocar o data-date , pois o mesmo não deixa o value correto aparecer já  ele modifica automaticamente para data setada dentro da função//-->
format: "dd/mm/yyyy", // set output format
effect: "none", // none, slide, fade
position: "bottom", // top or bottom,
locale: '', // 'ru' or 'en', default is $.Metro.currentLocale
});
</script>
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