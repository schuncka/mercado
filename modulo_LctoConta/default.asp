<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_database/secure.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_SiteInfo",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          					' - Default do Modulo...
 Const LTB = "FIN_LCTO_EM_CONTA"	    			' - Nome da Tabela...
 Const DKN = "COD_LCTO_EM_CONTA"          			' - Campo chave...
 Const DLD = "../modulo_LctoConta/default.asp" 		' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "LCTO CONTA"    						' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro


 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strENTIDADE, strSALDO
 Dim strDT_INI, strDT_FIM
 Dim strCONTA, strPERIODO
 Dim strIO, strTITLE, boolLCTO, boolTRANSF
 Dim strCodigo,strCODLCTOCONTA	,strOPERACAO,strTIPO
 
 'Antes de abir o banco já carrega as variaveis 
 strCONTA	   			= GetParam("var_fin_conta")
 strPERIODO	   			= GetParam("var_periodo")
 strCODLCTOCONTA		= getParam("var_cod_lctoconta")
 strOPERACAO			= getParam(" var_operacao")  
 strTIPO 				= getParam("var_tipo")
 
 
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
'   If strIDAUTO  	<>   ""  Then auxSTR = auxSTR & " AND ID_AUTO   	LIKE  		'" & strIDAUTO &   "%'"  
	If strCODIGO     <>   ""  Then auxSTR = auxSTR & " AND COD_INFO    =    		'" & strCODIGO &	"'"
 
   MontaWhereAdds = auxSTR 
 end function
 ' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  
 strSQL = "SELECT "	
 strSQL = strSQL & "		  LCTO.COD_LCTO_EM_CONTA,"		 
 strSQL = strSQL & "		  LCTO.OPERACAO, "	
 strSQL = strSQL & "		  LCTO.CODIGO,"		 	
 strSQL = strSQL & "		  LCTO.TIPO,"			 
 strSQL = strSQL & "		  PLAN.COD_REDUZIDO," 	 
 strSQL = strSQL & "		  PLAN.NOME AS PLANO_CONTA,"		 
 strSQL = strSQL & "		  CUST.NOME AS CENTRO_CUSTO," 	 
 strSQL = strSQL & "		  LCTO.HISTORICO, "	
 strSQL = strSQL & "		  LCTO.NUM_LCTO, "	
 strSQL = strSQL & "		  LCTO.VLR_LCTO, "	
 strSQL = strSQL & "		  LCTO.DT_LCTO "		 
 strSQL = strSQL & "		  FROM FIN_LCTO_EM_CONTA LCTO "		 
 strSQL = strSQL & "		  LEFT OUTER JOIN FIN_PLANO_CONTA PLAN ON (PLAN.COD_PLANO_CONTA = LCTO.COD_PLANO_CONTA) " 	  
 strSQL = strSQL & "		  LEFT OUTER JOIN FIN_CENTRO_CUSTO CUST ON (CUST.COD_CENTRO_CUSTO = LCTO.COD_CENTRO_CUSTO) "  
 strSQL = strSQL & "		  LEFT OUTER JOIN FIN_CONTA CTA ON (LCTO.COD_CONTA = CTA.COD_CONTA) "  
 strSQL = strSQL & "		  WHERE LCTO.COD_LCTO_EM_CONTA > 0 "
'if strDT_INI<>"" and strDT_FIM<>"" then 
' strSQL = strSQL & " AND LCTO.DT_LCTO BETWEEN '" & PrepDataBrToUni(strDT_INI,false) & "' AND '" & PrepDataBrToUni(strDT_FIM,false) & "' "
'end if
'if strCONTA <> "" then 
'strSQL = strSQL & " AND (LCTO.COD_CONTA =" & strCONTA & ") "
strSQL = strSQL & " ORDER BY DT_LCTO DESC "
'athdebug strSQL , true
 
 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))
  
 ' Define os campos para exibir na grade
 strFields = "LCTO.COD_LCTO_EM_CONTA,LCTO.OPERACAO,LCTO.CODIGO,LCTO.TIPO,PLAN.COD_REDUZIDO,PLAN.NOME AS PLANO_CONTA,CUST.NOME AS CENTRO_CUSTO,LCTO.HISTORICO,LCTO.NUM_LCTO,LCTO.VLR_LCTO,LCTO.DT_LCTO"
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD","OPERAÇÂO","CODIGO","TIPO","REDUZIDO","PLAN CONTA","CENTRO CUSTO", "HISTORICO","Nº LCTO","VLR LCTO","DT LCTO")
 arrSort   = Array("sortable","sortable","sortable","sortable","sortable","sortable","sortable","sortable","sortable","sortable","sortable" )
 arrWidth  = Array(  "2%","%10","10%","%10","10%","%10","10%","%10","10%","%10","4%"   )  'obs.:[somar 98%] ou deixar todos vazios
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
			<!-- INI: Botões //-->
            <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:10px; padding-right:20px; margin:0px;">
            	<p class="button bg-dark fg-white"><i class="icon-help-2 fg-white" onClick="javascript:location.href='./help/default.asp';"></i></p>
            </div>
            <div class="" style="border:0px solid #F00; position:relative; top:0px; float:right;padding-top:6px;">
                <!--<p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>-->
                <!-- INI: Filtro (accordiion para filtragem) //-->
                <nav class="horizontal-menu place-left bg-dark">
                <!--ul class="" style="height:3px;"//-->
                    <li>
                        <p class="button bg-dark fg-white"><a class="dropdown-toggle bg-dark fg-white" href="#" style="height:10px;">ADICIONAR</a></p>
                        <ul class="dropdown-menu" data-show="hover" data-role="dropdown">
                            <li>
	                            <%=AthWindow("Insert.asp?var_tipo=DESP", 520, 620, "INSERIR DEC")%>
                            </li>
                            <li>
	                            <%=AthWindow("Insert.asp?var_tipo=REC", 520, 620, "INSERIR REC")%>
                            </li>                                   
                            <li>
	                            <%=AthWindow("InsertTransf.asp", 520, 620, "INSERIR TRANF")%>
                            </li>
                        </ul>
                    </li>
                <!--/ul//-->
                </nav>
				<!-- FIM: Filtro (accordiion -para filtragem) //-->
                &nbsp;
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