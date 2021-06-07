<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<%'secure sera usado somente quando direito ainda nao estiver cadastrado e ativado no codigo,
'portando o mesmo dever ser sempre temporario nos novos modulos MetrUI%>
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_FinContas",Session("METRO_USER_ID_USER")), true %>
<%

 Const MDL = "DEFAULT"          						' - Default do Modulo...
 Const LTB = "FIN_CONTA_PAGAR_RECEBER"	    						' - Nome da Tabela...
 Const DKN = "COD_CONTA_PAGAR_RECEBER"			          			' - Campo chave...
 Const DLD = "../modulo_FinTitulos/default.asp" 			' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "FinContaPagarReceber"    						' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro
 

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS,objRSa, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strAtivo
 Dim strCODTIT, strDT_INI, strDT_FIM, strSITUACAO, strTIPO, strCONTA_PREVISTA, strCODIGO_ENT, strCODCCUSTO, strCODCONTRATO
 Dim strCOOKIE_ID_USUARIO, strGRUPO_USUARIO
 Dim strENTIDADE, strSALDO
 Dim strCONTA_REALIZADA
 Dim strICON, strTITLE
 Dim strTIPO_ENT, strNUM_LCTOS, strCOD_CONTAS_LCTOS, strCONTAS_LCTOS
 Dim Selecionado
 Dim strCOLOR
 Dim strFilePath, strFileName
 Dim boolTIT, boolLCTO
'Antes de abir o banco já carrega as variaveis 

 'strAtivo           = Replace(GetParam("var_ativo"),"'","''")
 
 strCODTIT          = Replace(GetParam("var_cod_titulo"),"'","''")
 strDT_INI          = Replace(GetParam("var_dt_ini"),"'","''")
 strDT_FIM          = Replace(GetParam("var_dt_fim"),"'","''")
 strSITUACAO        = Replace(GetParam("var_situacao"),"'","''")
 strTIPO            = Replace(GetParam("var_tipo"),"'","''")
 strCONTA_PREVISTA  = Replace(GetParam("var_cta_prevista"),"'","''")
 strCODIGO_ENT      = Replace(GetParam("var_cod_entidade"),"'","''")
 strCODCCUSTO       = Replace(GetParam("var_cod_custo"),"'","''")
 strCODCONTRATO     = Replace(GetParam("var_cod_contrato"),"'","''")  'aqui muito possivel deverá ser o codigo da inscricao
 

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
    
   if strCODTIT<>"" then  auxSTR = auxSTR  & " AND T1.COD_CONTA_PAGAR_RECEBER = " & strCODTIT 

	if strDT_INI<>"" and strDT_FIM<>"" then auxSTR = auxSTR & "	AND T1.DT_VCTO BETWEEN '"& PrepDataBrToUni(strDT_INI,false) &"' AND '"& PrepDataBrToUni(strDT_FIM,false) &"'"
	
	if strSITUACAO<>"" then
		if mid(strSITUACAO,1,1)="_" then 
			auxSTR = auxSTR & " AND T1.SITUACAO NOT LIKE '"& mid(strSITUACAO,2) &"' AND T1.SITUACAO NOT LIKE 'CANCELADA'"
		else
			auxSTR = auxSTR & " AND T1.SITUACAO LIKE '"& strSITUACAO &"'"
		end if
	end if
	
	if strTIPO ="1"   then  
		auxSTR = auxSTR & " AND T1.PAGAR_RECEBER <> 0 "
	else
		if strTIPO ="0" then  
			auxSTR = auxSTR & " AND T1.PAGAR_RECEBER = 0 "
		end if	
	end if 
   
   MontaWhereAdds = auxSTR 
  End function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
strSQL = 	" SELECT T1.COD_CONTA_PAGAR_RECEBER " 									&_
				"	,	T1.TIPO " 													&_
				"	,	T1.CODIGO " 												&_
				"	,	T1.DT_EMISSAO " 											&_
				"	,	T1.DT_VCTO " 												&_
				"	,	T1.VLR_CONTA " 												&_	
				"	,	T2.NOME AS CONTA " 											&_	
				"	,	T3.COD_PLANO_CONTA " 										&_
				"	,	T4.NOME AS CENTRO_CUSTO "									&_ 	
				"	,	T1.SITUACAO " 												&_		
				"	,	T3.NOME AS PLANO_CONTA " 									&_
				"	,	T1.ARQUIVO_ANEXO " 											&_
				"	,	T1.HISTORICO " 												&_				
				"FROM FIN_CONTA_PAGAR_RECEBER AS T1 " 								&_
				"LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) "	&_
				"LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) "		&_
				"LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	&_
				"WHERE T2.DT_INATIVO IS NULL "  & MontaWhereAdds
 				'athDebug strSQl, true
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
 

			
' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "COD_CONTA_PAGAR_RECEBER ,TIPO,DT_EMISSAO,DT_VCTO, VLR_CONTA, CONTA, SITUACAO, PLANO_CONTA,CENTRO_CUSTO,ARQUIVO_ANEXO,HISTORICO " 
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD"              ,  "TIPO" 	,  "DT EMISS"	, "DT VCTO"	, "VLR CONTA"  , "CONTA" 	, "SITUACAO" , "PLAN CONTA" 		, "CRT CUSTO"   		, "ANEXO"				, "HISTORC."  )
 arrSort   = Array("sortable-numeric" ,  "sortable" ,  "sortable"	, "sortable", "sortable"   , "sortable"	, "sortable" , "sortable-numeric"   , "sortable-date-dmy" 	, "sortable-date-dmy"   , "sortable"  ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array("2%"               ,     "20%"   ,  "10%"		, "10%"		, "18%"        , "10%"      ,    "10%"   ,    "10%"   		  	,    "10%"   		 	,    "10%" 				, "sortable"  ) 'Obs.:[somar 98%] ou deixar todos vazios
' ----------------------------------------------------------------------------------------------------------------------------						

 strALL_PARAMS = URLDecode(Request.Form) 'neste caso não pode usar GetParam
 strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para não trancar a paginaçãz
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
<script>
function OpenLctoCont() {	
	AbreJanelaPAGE_NOVA('../modulo_FinLctoConta/mini_LctoTransf/default.asp','620','720');
}
function ShowPeriodo() {	
	if (document.getElementById("var_periodo").value == "ESPECIFICO"){
			document.getElementById("show_especifico").style.display = "block"; 
		}else{
			document.getElementById("show_especifico").style.display = "none"; 
			
	}
}
</script>
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
             <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:10px; padding-right:20px; margin:0px;">
            	<p class="button bg-dark fg-white" onClick="javascript:OpenTransf();return false;">LCTO em CONTA</p>
            </div>
            <div class="" style="border:0px solid #F00; position:relative; top:0px; float:right;padding-top:3px;">
				<div class="accordion place-left" data-role="accordion" style="z-index:10; position:relative; top:0px; float:right; padding-top:7px; padding-right:7px;">
                    <div class="accordion-frame" style="border:0px solid #F00;">
                        <!--div class="button bg-dark fg-white " style="height:30px; width:100px;margin-top:1px;"//-->
                        <div class="button-dropdown">
                        <!--<button class="dropdown-toggle bg-dark fg-white" style="height:25px;">ADICIONAR</button>
                            <ul class="dropdown-menu" data-role="dropdown">
                                <li><'%=AthWindow("Insert.asp?var_tipo=DESP", 520, 620, "INSERIR DESP")%></li>
                                <li><'%=AthWindow("Insert.asp?var_tipo=REC", 520, 620, "INSERIR REC")%></li>                                   
                                <!--li><%'=AthWindow("InsertTransf.asp", 520, 620, "INSERIR TRANSF")%></li>/>-->
                            </ul>
                        </div>                       
                    </div>
				</div>   
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