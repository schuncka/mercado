<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Evento",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          ' - Default do Modulo...
 Const LTB = "tbl_empresas"	    ' - Nome da Tabela...
 Const DKN = "COD_EMPRESA"          ' - Campo chave...
 Const DLD = "../modulo_Cadastro/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Cadastro"    ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strCOD_EMPRESA,strCODBARRA,strNOMECLI,strNOMEFAN,strEND_FULL,strEND_LOGR,strEND_NUM,strEND_COMPL,strEND_BAIRRO,strEND_CIDADE,strEND_ESTADO,strEND_PAIS,strEND_CEP,strFONE1,strFONE2,strFONE3,strFONE4,strID_NUM_DOC1,strID_CNPJ
 Dim strID_CPF,strID_NUM_DOC2,strID_INSCR_EST,strID_RG,strID_INSCR_MUN,strTIPO_PESS,strCODATIV1,strCODATIV2,strCODATIV3,strSYS_DATACA,strSYS_USERCA,strSYS_DATAAT,strSYS_USERAT,strSYS_UPDATE,strSYS_INATIVO,strDT_ANIV,strDT_NASC
 Dim strEMAIL1,strEMAIL2,strHOMEPAGE,strCOLIGADA,strEXTRA_TXT_1,strEXTRA_TXT_2,strEXTRA_TXT_3,strEXTRA_TXT_4,strEXTRA_TXT_5,strEXTRA_TXT_6,strEXTRA_NUM_1,strEXTRA_NUM_2,strEXTRA_NUM_3,strCOE,SYS_DATACRED,strPDV,strCOD_STATUS_PRECO
 Dim strCOD_STATUS_CRED,strSEXO,strACOMP1,strACOMP2,strENTIDADE,strENTIDADE_CNPJ,strENTIDADE_CARGO,strLOJA_SENHA,strsenha,strENTIDADE_FANTASIA,strENTIDADE_SETOR,strENTIDADE_DEPARTAMENTO,strPORTADOR_NECESSIDADE_ESPECIAL
 Dim strRECEBER_SMS,strRECEBER_NEWSLETTER,strTRIB_EMPRESA_MISTA,strIMG_FOTO,strTRIB_EMPRESA_SIMPLES,strPRESS_TIPOVEICULO,strPRESS_EDITORIA,strSINDIPROM,strAUTORIZA_DIVULGACAO_DADOS,strEXTRA_TXT_7,strEXTRA_TXT_8
 Dim strEXTRA_TXT_9,strEXTRA_TXT_10,strNRO_EVENTOS_VISITADOS,strREFERENCIA,strULTIMO_COD_EVENTO,strENTIDADE_EMAIL,strENTIDADE_FONE,strENTIDADE_RESP_CREDENCIAL,strDESCRICAO,strSWFILTRO


'Antes de abir o banco já carrega as variaveis 
strCOD_EMPRESA							= Replace(GetParam("var_cod_empresa"),"'","''")									
'CODBARRA                               = Replace(GetParam("var_cod_evento"),"'","''")
strNOMECLI                              = Replace(GetParam("var_nomecli"),"'","''")
'NOMEFAN                                = Replace(GetParam("var_cod_evento"),"'","''")
strEND_FULL                             = Replace(GetParam("var_end_full"),"'","''")
'END_LOGR                               = Replace(GetParam("var_cod_evento"),"'","''")
'END_NUM                                = Replace(GetParam("var_cod_evento"),"'","''")
'END_COMPL                               = Replace(GetParam("var_cod_evento"),"'","''")
'END_BAIRRO                              = Replace(GetParam("var_cod_evento"),"'","''")
'END_CIDADE                              = Replace(GetParam("var_cod_evento"),"'","''")
strEND_ESTADO                              = Replace(GetParam("var_end_estado"),"'","''")
'END_PAIS                                = Replace(GetParam("var_cod_evento"),"'","''")
'END_CEP                                 = Replace(GetParam("var_cod_evento"),"'","''")
'FONE1                                   = Replace(GetParam("var_cod_evento"),"'","''")
'FONE2                                   = Replace(GetParam("var_cod_evento"),"'","''")
'FONE3                                   = Replace(GetParam("var_cod_evento"),"'","''")
'FONE4                                   = Replace(GetParam("var_cod_evento"),"'","''")
'ID_NUM_DOC1                             = Replace(GetParam("var_cod_evento"),"'","''")
'ID_CNPJ                                 = Replace(GetParam("var_cod_evento"),"'","''")
'ID_CPF                                  = Replace(GetParam("var_cod_evento"),"'","''")
'ID_NUM_DOC2                             = Replace(GetParam("var_cod_evento"),"'","''")
'ID_INSCR_EST                            = Replace(GetParam("var_cod_evento"),"'","''")
'ID_RG                                   = Replace(GetParam("var_cod_evento"),"'","''")
'ID_INSCR_MUN                            = Replace(GetParam("var_cod_evento"),"'","''")
strTIPO_PESS                               = Replace(GetParam("var_tipo_pess"),"'","''")
'CODATIV1                                = Replace(GetParam("var_cod_evento"),"'","''")
'CODATIV2                                = Replace(GetParam("var_cod_evento"),"'","''")
'CODATIV3                                = Replace(GetParam("var_cod_evento"),"'","''")
'SYS_DATACA                              = Replace(GetParam("var_cod_evento"),"'","''")
'SYS_USERCA                              = Replace(GetParam("var_cod_evento"),"'","''")
'SYS_DATAAT                              = Replace(GetParam("var_cod_evento"),"'","''")
'SYS_USERAT                              = Replace(GetParam("var_cod_evento"),"'","''")
'SYS_UPDATE                              = Replace(GetParam("var_cod_evento"),"'","''")
strSYS_INATIVO                             = Replace(GetParam("var_sys_inativo"),"'","''")
'DT_ANIV                                 = Replace(GetParam("var_cod_evento"),"'","''")
'DT_NASC                                 = Replace(GetParam("var_cod_evento"),"'","''")
'strEMAIL1								= Replace(GetParam("var_cod_evento"),"'","''")
'strEMAIL2                               = Replace(GetParam("var_cod_evento"),"'","''")
'strHOMEPAGE                             = Replace(GetParam("var_cod_evento"),"'","''")
'strCOLIGADA                             = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_1                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_2                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_3                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_4                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_5                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_6                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_NUM_1                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_NUM_2                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_NUM_3                          = Replace(GetParam("var_cod_evento"),"'","''")
'strCOE                                  = Replace(GetParam("var_cod_evento"),"'","''")
'strSYS_DATACRED                         = Replace(GetParam("var_cod_evento"),"'","''")
'strPDV                                  = Replace(GetParam("var_cod_evento"),"'","''")
strCOD_STATUS_PRECO                     = Replace(GetParam("var_cod_status_preco"),"'","''")
strCOD_STATUS_CRED                      = Replace(GetParam("var_cod_status_cred"),"'","''")
'strSEXO                                 = Replace(GetParam("var_cod_evento"),"'","''")
'strACOMP1                               = Replace(GetParam("var_cod_evento"),"'","''")
'strACOMP2                               = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE                             = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE_CNPJ                        = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE_CARGO                       = Replace(GetParam("var_cod_evento"),"'","''")
'strLOJA_SENHA                           = Replace(GetParam("var_cod_evento"),"'","''")
'strsenha                                = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE_FANTASIA                    = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE_SETOR                       = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE_DEPARTAMENTO                = Replace(GetParam("var_cod_evento"),"'","''")
'strPORTADOR_NECESSIDADE_ESPECIAL        = Replace(GetParam("var_cod_evento"),"'","''")
'strRECEBER_SMS                          = Replace(GetParam("var_cod_evento"),"'","''")
'strRECEBER_NEWSLETTER                   = Replace(GetParam("var_cod_evento"),"'","''")
'strTRIB_EMPRESA_MISTA                   = Replace(GetParam("var_cod_evento"),"'","''")
'strIMG_FOTO                             = Replace(GetParam("var_cod_evento"),"'","''")
'strTRIB_EMPRESA_SIMPLES                 = Replace(GetParam("var_cod_evento"),"'","''")
'strPRESS_TIPOVEICULO                    = Replace(GetParam("var_cod_evento"),"'","''")
'strPRESS_EDITORIA                       = Replace(GetParam("var_cod_evento"),"'","''")
'strSINDIPROM                            = Replace(GetParam("var_cod_evento"),"'","''")
'strAUTORIZA_DIVULGACAO_DADOS            = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_7                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_8                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_9                          = Replace(GetParam("var_cod_evento"),"'","''")
'strEXTRA_TXT_10                         = Replace(GetParam("var_cod_evento"),"'","''")
'strNRO_EVENTOS_VISITADOS                = Replace(GetParam("var_cod_evento"),"'","''")
'strREFERENCIA                           = Replace(GetParam("var_cod_evento"),"'","''")
strULTIMO_COD_EVENTO                    = Replace(GetParam("var_ultimo_cod_evento"),"'","''")
'strENTIDADE_EMAIL                       = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE_FONE                        = Replace(GetParam("var_cod_evento"),"'","''")
'strENTIDADE_RESP_CREDENCIAL             = Replace(GetParam("var_cod_evento"),"'","''")
strDESCRICAO                            = Replace(GetParam("var_descricao"),"'","''")

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
  
  	If strCOD_EMPRESA    	<>   ""  Then auxSTR = auxSTR & " AND COD_EMPRESA	 	=           '" & strCOD_EMPRESA &     "'"																			
	If strNOMECLI    		<>   ""  Then auxSTR = auxSTR & " AND NOMECLI	 		 LIKE     	 '" & strNOMECLI &   "%'"               
	If strEND_FULL    		<>   ""  Then auxSTR = auxSTR & " AND END_FULL	 		 LIKE     	 '" & strEND_FULL &   "%'"               
	If strEND_ESTADO    	<>   ""  Then auxSTR = auxSTR & " AND END_ESTADO	 	 LIKE     	 '" & strEND_ESTADO &   "%'"               
	If strTIPO_PESS    		<>   ""  Then auxSTR = auxSTR & " AND TIPO_PESS	 		 LIKE     	 '" & strTIPO_PESS &   "%'"               
	If strCOD_STATUS_PRECO  <>   ""  Then auxSTR = auxSTR & " AND COD_STATUS_PRECO	 =     	 '" & strCOD_STATUS_PRECO &   "'"            
	If strCOD_STATUS_CRED   <>   ""  Then auxSTR = auxSTR & " AND COD_STATUS_CRED	 =     	 '" & strCOD_STATUS_CRED &   "'"            
	If strULTIMO_COD_EVENTO <>   ""  Then auxSTR = auxSTR & " AND ULTIMO_COD_EVENTO	 =     	 '" & strULTIMO_COD_EVENTO &   "'"            
	If strDESCRICAO    		<>   ""  Then auxSTR = auxSTR & " AND DESCRICAO	 		 LIKE     	 '" & strDESCRICAO &   "%'"  
   if (strSYS_INATIVO    <>   "")  and  (LCASE(strSYS_INATIVO) <> "todos") then
   		if  LCASE(strSYS_INATIVO) = "ativo" then
			auxSTR = auxSTR & " AND SYS_INATIVO IS NULL "
		else
			auxSTR = auxSTR & " AND SYS_INATIVO IS NOT NULL "
		end if
   end if

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------


' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		
	'strSQL = strSQL & "		  ,CODBARRA "
	'strSQL = strSQL & "		  ,NOMEFAN "
	'strSQL = strSQL & "		  ,END_LOGR "
	'strSQL = strSQL & "		  ,END_NUM "
	'strSQL = strSQL & "		  ,END_COMPL "
	'strSQL = strSQL & "		  ,END_BAIRRO "
	'strSQL = strSQL & "		  ,END_CIDADE "
	'strSQL = strSQL & "		  ,END_PAIS "
	'strSQL = strSQL & "		  ,END_CEP "
	'strSQL = strSQL & "		  ,FONE1 "
	'strSQL = strSQL & "		  ,FONE2 "
	'strSQL = strSQL & "		  ,FONE3 "
	'strSQL = strSQL & "		  ,FONE4 "
	'strSQL = strSQL & "		  ,ID_NUM_DOC1 "
	'strSQL = strSQL & "		  ,ID_CNPJ "
	'strSQL = strSQL & "		  ,ID_CPF "
	'strSQL = strSQL & "		  ,ID_NUM_DOC2 "
	'strSQL = strSQL & "		  ,ID_INSCR_EST "
	'strSQL = strSQL & "		  ,ID_RG "
	'strSQL = strSQL & "		  ,ID_INSCR_MUN "
	'strSQL = strSQL & "		  ,CODATIV1 "
	'strSQL = strSQL & "		  ,CODATIV2 "
	'strSQL = strSQL & "		  ,CODATIV3 "
	'strSQL = strSQL & "		  ,SYS_DATACA "
	'strSQL = strSQL & "		  ,SYS_USERCA "
	'strSQL = strSQL & "		  ,SYS_DATAAT "
	'strSQL = strSQL & "		  ,SYS_USERAT "
	'strSQL = strSQL & "		  ,SYS_UPDATE "
	'strSQL = strSQL & "		  ,SYS_INATIVO "
	'strSQL = strSQL & "		  ,DT_ANIV "
	'strSQL = strSQL & "		  ,DT_NASC "
	'strSQL = strSQL & "		  ,EMAIL1 "
	'strSQL = strSQL & "		  ,EMAIL2 "
	'strSQL = strSQL & "		  ,HOMEPAGE "
	'strSQL = strSQL & "		  ,COLIGADA "
	'strSQL = strSQL & "		  ,EXTRA_TXT_1 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_2 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_3 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_4 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_5 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_6 "
	'strSQL = strSQL & "		  ,EXTRA_NUM_1 "
	'strSQL = strSQL & "		  ,EXTRA_NUM_2 "
	'strSQL = strSQL & "		  ,EXTRA_NUM_3 "
	'strSQL = strSQL & "		  ,COE "
	'strSQL = strSQL & "		  ,SYS_DATACRED "
	'strSQL = strSQL & "		  ,PDV "
	'strSQL = strSQL & "		  ,SEXO "
	'strSQL = strSQL & "		  ,ACOMP1 "
	'strSQL = strSQL & "		  ,ACOMP2 "
	'strSQL = strSQL & "		  ,ENTIDADE "
	'strSQL = strSQL & "		  ,ENTIDADE_CNPJ "
	'strSQL = strSQL & "		  ,ENTIDADE_CARGO "
	'strSQL = strSQL & "		  ,LOJA_SENHA "
	'strSQL = strSQL & "		  ,senha "
	'strSQL = strSQL & "		  ,ENTIDADE_FANTASIA "
	'strSQL = strSQL & "		  ,ENTIDADE_SETOR "
	'strSQL = strSQL & "		  ,ENTIDADE_DEPARTAMENTO "
	'strSQL = strSQL & "		  ,PORTADOR_NECESSIDADE_ESPECIAL "
	'strSQL = strSQL & "		  ,RECEBER_SMS "
	'strSQL = strSQL & "		  ,RECEBER_NEWSLETTER "
	'strSQL = strSQL & "		  ,TRIB_EMPRESA_MISTA "
	'strSQL = strSQL & "		  ,IMG_FOTO "
	'strSQL = strSQL & "		  ,TRIB_EMPRESA_SIMPLES "
	'strSQL = strSQL & "		  ,PRESS_TIPOVEICULO "
	'strSQL = strSQL & "		  ,PRESS_EDITORIA "
	'strSQL = strSQL & "		  ,SINDIPROM "
	'strSQL = strSQL & "		  ,AUTORIZA_DIVULGACAO_DADOS "
	'strSQL = strSQL & "		  ,EXTRA_TXT_7 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_8 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_9 "
	'strSQL = strSQL & "		  ,EXTRA_TXT_10 "
	'strSQL = strSQL & "		  ,NRO_EVENTOS_VISITADOS "
	'strSQL = strSQL & "		  ,REFERENCIA "
	'strSQL = strSQL & "		  ,ULTIMO_COD_EVENTO "
	'strSQL = strSQL & "		  ,ENTIDADE_EMAIL "
	'strSQL = strSQL & "		  ,ENTIDADE_FONE "
	'strSQL = strSQL & "		  ,ENTIDADE_RESP_CREDENCIAL "
	strSQL = " SELECT     COD_EMPRESA "
	strSQL = strSQL & "		  ,NOMECLI "
	strSQL = strSQL & "		  ,END_FULL "
	strSQL = strSQL & "		  ,END_ESTADO "
	strSQL = strSQL & "		  ,TIPO_PESS "
	strSQL = strSQL & "		  ,COD_STATUS_PRECO "
	strSQL = strSQL & "		  ,COD_STATUS_CRED "
	strSQL = strSQL & "		  ,DESCRICAO "
	strSQL = strSQL & "   FROM " & LTB 
	strSQL = strSQL & "  WHERE COD_EMPRESA = COD_EMPRESA " & MontaWhereAdds
	strSQL = strSQL & "  ORDER BY COD_EMPRESA,NOMECLI"
 
 'response.Write(strSQL)
 'response.End()
 
 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "COD_EMPRESA,NOMECLI,END_FULL,END_ESTADO,TIPO_PESS,COD_STATUS_PRECO,COD_STATUS_CRED,DESCRICAO" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD"               ,"NOME CLI" , "ENDERECO","END ESTADO", "T PESS"   , "STATUS PRECO"  , "STATUS CRED" , "DESCRICAO")
 arrSort   = Array("sortable-numeric"  ,"sortable" , "sortable","sortable"  , "sortable" , "sortable"		, "sortable"	,"sortable"  )
 arrWidth  = Array("2%"                ,"10%"       , "10%"     , "10%"      , "10%"      , "10%"      		, "10%"      	,"37%"       )  'obs.:[somar 98%] ou deixar todos vazios
' -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


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
                        <%' IF ucase(Session("METRO_USER_ID_USER")) = "SAC" OR ucase(Session("METRO_USER_ID_USER")) = "sysMetro" THEN %>
                        <p class="button bg-dark fg-white"><%=AthWindow("INSERT.ASP",960, 720, "ADICIONAR")%></p>
                        <% 'END IF  %>
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