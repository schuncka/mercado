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
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strAtivo
 Dim strCODTIT, strDT_INI, strDT_FIM, strSITUACAO, strTIPO, strCONTA_PREVISTA, strCODIGO_ENT, strCODCCUSTO, strCODCONTRATO
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
	
	if strTIPO="PAGAR"   then  auxSTR = auxSTR & " AND T1.PAGAR_RECEBER <> 0 "
	if strTIPO="RECEBER" then  auxSTR = auxSTR & " AND T1.PAGAR_RECEBER = 0 "
	
	'if strCONTA_PREVISTA<>"" then auxSTR = auxSTR &	" AND (T2.COD_CONTA ="& strCONTA_PREVISTA &") "
	
	'if strCODIGO_ENT<>"" and strTIPO_ENT<>"" then auxSTR = auxSTR & " AND (T1.TIPO LIKE '"& strTIPO_ENT &"' AND T1.CODIGO LIKE '"& strCODIGO_ENT &"')"
	
	'adicionado filtro por centro de custo - by vini 25.01.2013
	'if strCODCCUSTO<>"" then auxSTR = auxSTR &	" AND (T4.COD_CENTRO_CUSTO="& strCODCCUSTO & ") "
	
	'if strCODCONTRATO<>"" then auxSTR = auxSTR & " AND (T1.COD_CONTRATO=" & strCODCONTRATO & ") "
	
	
   
   
   MontaWhereAdds = auxSTR 
  End function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
strSQL = 	" SELECT T1.COD_CONTA_PAGAR_RECEBER " 								                                        
				strSQL = strSQL & "	,	T1.TIPO " 													                                    
				strSQL = strSQL & "	,	T1.CODIGO " 												                                    
				strSQL = strSQL & "	,	T1.DT_EMISSAO " 											                                    
				strSQL = strSQL & "	,	T1.HISTORICO " 												                                    
				strSQL = strSQL & "	,	T1.TIPO_DOCUMENTO " 										                                    
				strSQL = strSQL & "	,	T1.NUM_DOCUMENTO " 											                                    
				strSQL = strSQL & "	,	T1.PAGAR_RECEBER " 											                                    
				strSQL = strSQL & "	,	T1.NUM_IMPRESSOES "											                                    
				strSQL = strSQL & "	,	T1.DT_VCTO " 												                                    
				strSQL = strSQL & "	,	T1.VLR_CONTA " 												                                    
				strSQL = strSQL & "	,	T2.NOME AS CONTA " 											                                    
				strSQL = strSQL & "	,	T1.SITUACAO " 												                                    
				strSQL = strSQL & "	,	T1.COD_NF "													                                    
				strSQL = strSQL & "	,	T3.NOME AS PLANO_CONTA " 									                                    
				strSQL = strSQL & "	,	T3.COD_PLANO_CONTA " 										                                    
				strSQL = strSQL & "	,	T3.COD_REDUZIDO AS PLANO_CONTA_COD_REDUZIDO " 				                                    
				strSQL = strSQL & "	,	T4.NOME AS CENTRO_CUSTO " 									                                    
				strSQL = strSQL & "	,	T4.COD_REDUZIDO AS CENTRO_CUSTO_COD_REDUZIDO " 				                                    
				strSQL = strSQL & "	,	T1.ARQUIVO_ANEXO " 											                                    
				strSQL = strSQL & "	,	T1.MARCA_NFE " 												                                    
				strSQL = strSQL & "	,	T1.COD_CONTRATO "											                                    
				strSQL = strSQL & "	,	COUNT(T5.COD_LCTO_ORDINARIO) AS LCTOS "						                                    
				strSQL = strSQL & "	,	SUM(T5.VLR_LCTO) AS VRL_LCTOS "		  				                                            
				strSQL = strSQL & "	,	'teste entidade' AS ENTIDADE "											
				strSQL = strSQL & " FROM " & ltb & " AS T1 " 								
				strSQL = strSQL & " LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) "	
				strSQL = strSQL & " LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) "		
				strSQL = strSQL & " LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	
				strSQL = strSQL & " LEFT OUTER JOIN FIN_LCTO_ORDINARIO AS T5 ON (T1.COD_CONTA_PAGAR_RECEBER = T5.COD_CONTA_PAGAR_RECEBER) " 
				strSQL = strSQL & " WHERE T2.DT_INATIVO IS NULL " & MontaWhereAdds
				
				strSQL = strSQL & " GROUP BY T1.COD_CONTA_PAGAR_RECEBER "
				strSQL = strSQL & "		,	T1.TIPO "
				strSQL = strSQL & "		,	T1.CODIGO "
				strSQL = strSQL & "		,	T1.DT_EMISSAO "
				strSQL = strSQL & "		,	T1.HISTORICO "
				strSQL = strSQL & "		,	T1.TIPO_DOCUMENTO "
				strSQL = strSQL & "		,	T1.NUM_DOCUMENTO "
				strSQL = strSQL & "		,	T1.PAGAR_RECEBER "
				strSQL = strSQL & "		,	T1.NUM_IMPRESSOES "
				strSQL = strSQL & "		,	T1.DT_VCTO "
				strSQL = strSQL & "		,	T1.VLR_CONTA "
				strSQL = strSQL & "		,	T2.NOME "
				strSQL = strSQL & "		,	T1.SITUACAO "
				strSQL = strSQL & "		,	T1.COD_NF "
				strSQL = strSQL & "		,	T3.NOME "
				strSQL = strSQL & "		,	T3.COD_PLANO_CONTA "
				strSQL = strSQL & "		,	T3.COD_REDUZIDO "
				strSQL = strSQL & "		,	T4.NOME "
				strSQL = strSQL & "		,	T4.COD_REDUZIDO "
				strSQL = strSQL & "		,	T1.ARQUIVO_ANEXO "
				strSQL = strSQL & "		,	T1.MARCA_NFE "
				strSQL = strSQL & "		,	T1.COD_CONTRATO "
				strSQL = strSQL & " ORDER BY T1.DT_VCTO, T1.COD_CONTA_PAGAR_RECEBER "

	strSQL  = " SELECT t1.COD_CONTA_PAGAR_RECEBER, 'teste' as entidade, t1.NUM_DOCUMENTO, t1.DT_VCTO, t1.VLR_CONTA "
	strSQL = strSQL & "	,	SUM(T5.VLR_LCTO) AS VRL_LCTOS "		  				                                            				
				strSQL = strSQL & " FROM " & ltb & " AS T1 " 								
				strSQL = strSQL & " LEFT OUTER JOIN FIN_CONTA AS T2 ON (T1.COD_CONTA=T2.COD_CONTA) "	
				strSQL = strSQL & " LEFT OUTER JOIN FIN_PLANO_CONTA AS T3 ON (T1.COD_PLANO_CONTA=T3.COD_PLANO_CONTA) "		
				strSQL = strSQL & " LEFT OUTER JOIN FIN_CENTRO_CUSTO AS T4 ON (T1.COD_CENTRO_CUSTO=T4.COD_CENTRO_CUSTO) " 	
				strSQL = strSQL & " LEFT OUTER JOIN FIN_LCTO_ORDINARIO AS T5 ON (T1.COD_CONTA_PAGAR_RECEBER = T5.COD_CONTA_PAGAR_RECEBER) " 
				strSQL = strSQL & " WHERE T2.DT_INATIVO IS NULL " & MontaWhereAdds


 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "COD_CONTA_PAGAR_RECEBER, ENTIDADE, NUM_DOCUMENTO, DT_VCTO, VLR_CONTA, VRL_LCTOS" 
 arrFields = Split(strFields,",")        



 arrLabels = Array("COD"              ,  "Entidade" ,  "NumDOC"         , "DT Vcto"               , "Vlr Titulo"        , "Vlr Pago"          )
 arrSort   = Array("sortable-numeric" ,  "sortable" ,  "sortable"       , "sortable-currency-dmy" , "sortable-currency" , "sortable-currency"  ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array("2%"               ,     "20%"   ,  "20%"            , "20%"                   , "18%"               , "18%"                   ) 'Obs.:[somar 98%] ou deixar todos vazios
' ----------------------------------------------------------------------------------------------------------------------------

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 

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