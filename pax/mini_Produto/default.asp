<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_CfgLinks",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          							' - Default do Modulo...
 Const LTB = "tbl_INSCRICAO_PRODUTOS"						' - Nome da Tabela...
 Const DKN = "COD_INSCRICAO"						 		' - Campo chave...
 Const DLD = "../pax/mini_Produto/default.asp"  			' "../evento/data.asp" - 'Default Location após Deleção

 

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, objLang, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCODLINK, strCOD_EVENTO,strCODLINKMINI,strID_AUTO, strCOD_EMPRESA, strCOD_INSCRICAO
 Dim arrTEMPStr, arrTEMPLinha,strCODBARRA,strCODBARRA_SUB,strArquivo
 

'Carraga a chave do registro, porém neste caso a relação masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------
strCOD_INSCRICAO = Replace(GetParam("var_chavereg"),"'","''")
strCODBARRA		= getParam("var_codbarra") 
strCODBARRA_SUB	= getParam("var_codbarra_sub")


 If strCODBARRA_SUB <> "" Then
 	strCODBARRA = strCODBARRA_SUB
 End If
 
 strCOD_EMPRESA  = left(strCODBARRA,6)
'------------------------------------------------------------------
'ATHDEBUG strINSTRUCAO, true

'------------------------------------------------------------------
'ATHDEBUG strINSTRUCAO, true

'------------------------------------------------------------------

'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 

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
 
 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' --------------------------------------------------------------------------------------------------------------
 
 ' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

 strSQL = "SELECT DISTINCT P.COD_PROD as cod_produto, " & vbnewline
 if lcase(Request.Cookies("METRO_pax")("locale")) <> "pt-br" Then
	strSQL = strSQL & " P.TITULO_INTL AS TITULO, P.DESCRICAO_INTL AS DESCRICAO, " & vbnewline
 Else
	strSQL = strSQL & " P.TITULO, P.DESCRICAO,p.DOWNLOAD_VINCULO_COD_QUESTIONARIO,QC.COD_QUESTIONARIO " & vbnewline
 End If
 'strSQL = strSQL & " GROUP_CONCAT(REPLACE(REPLACE(D.ROTULO,']',''),'[','') , '[' , if(D.DOCUMENTO is null , D.URL , CONCAT('../../modulo_admproduto/docs/',D.DOCUMENTO)) , ']') AS ARQUIVO, P.COD_EVENTO "
 'strSQL = strSQL & "  if(QC.COD_QUESTIONARIO = p.DOWNLOAD_VINCULO_COD_QUESTIONARIO,p.DOWNLOAD_VINCULO_COD_QUESTIONARIO,null) as QUESTIONARIO,  "
 'strSQL = strSQL & "  if(QC.COD_QUESTIONARIO = p.DOWNLOAD_VINCULO_COD_QUESTIONARIO,p.DOWNLOAD_VINCULO_COD_QUESTIONARIO,null) as COD_QUESTIONARIO, " 
 
 strSQL = strSQL & " ,'' AS ARQUIVO, p.COD_EVENTO " & vbnewline
 strSQL = strSQL & " FROM TBL_PRODUTOS P INNER JOIN TBL_INSCRICAO_PRODUTO IP ON P.COD_PROD = IP.COD_PROD " & vbnewline
 strSQL = strSQL & " LEFT JOIN TBL_DOCUMENTOS D ON D.COD_PROD = P.COD_PROD " & vbnewline
 ' Verifica se a empresa ou o contato já preencheram o questionário obrigatório para este certeificado/produto
 strSQL = strSQL & " LEFT JOIN TBL_QUESTIONARIO_CLIENTE QC ON P.DOWNLOAD_VINCULO_COD_QUESTIONARIO = QC.COD_QUESTIONARIO AND LEFT(QC.CODBARRA,6) = '" & strCOD_EMPRESA & "'" & vbnewline
 strSQL = strSQL & " WHERE IP.COD_INSCRICAO = " & strCOD_INSCRICAO & vbnewline
 strSQL = strSQL & " GROUP BY 1,2 " 		   & vbnewline
 strSQL = strSQL & " ORDER BY P.TITULO " 	   & vbnewline
'response.write(strSQL)	  
 'athDebug strSQL , TRUE
 
 ' Define os campos para exibir na grade
 strFields = "TITULO,DESCRICAO,ARQUIVO" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(ucase(objLang.SearchIndex("mini_produto",0))  , ucase(objLang.SearchIndex("mini_descricao",0)) , ucase(objLang.SearchIndex("mini_arquivos",0))  )
 arrSort   = Array("sortable"  , "sortable"  , "sortable" ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array("30%"          , "30%"          , "38%"  	      )     'Obs.:[somar 98%] ou deixar todos vazios
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
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js	"></script>

</head>
<body class="metro">
<!-- Embora um MINI Módulo esteja convencionado a não ter elementos de filtragem
         criamos este Formulário de filtro necessário para envio da página corrrente
         armazenamento da qqtde de elementos por págtina //-->
     <form id="formfiltro" name="formfiltro" action="default.asp" method="post" style="display:none; visibility:hidden;" >
       <input type="hidden" id="var_numperpage"		name="var_numperpage" value="<%=numPerPage%>">
       <input type="hidden" id="var_chavereg"		name="var_chavereg"   value="<%=strCOD_INSCRICAO%>">
       <input type="hidden" name="DEFAULT_LOCATION" value="default.asp"> 
     </form>
     <%'athDebug strCOD_EVENTO, true%>
	<div class="grid fluid">
    <!-- INI: barra no topo (filtro e adicionar) //-->
    <div class="bg-white" style="border:0px solid #F00; width:100%; height:45px;  vertical-align:bottom; padding-left:0px;">
        <div style="width:100%;display:inline-block"> 
       
			<!-- INI: Filtro (accordiion para filtragem) //-->
            <div class="accordion place-left"  style="z-index:10; position:absolute; top:0px;">
                <div class="accordion-frame" style="border:0px solid #F00;">
               <a class="heading text-left bg-white fg-active-black" href="javascript:document.getElementById('formfiltro').submit();" style="height:45px;">
	                    <p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;">
                        	<%=strCOD_INSCRICAO%>.
                            <i class=" <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & strCOD_INSCRICAO%>"></i>
							<%= objLang.SearchIndex("mini_produto_arq",0)%>
                        </p>
                    </a>
                    <div class="content bg-white span3" style="border:1px solid #CCC;">
                        <div class="panel-content bg-white">	
                        	<!-- ondeficavafiltro--> 
                        </div>
                    </div>
                     
                </div>
            </div>
        </div>
    </div>
	<!-- FIM: grade de dados//-->            
       
    <!-- INI: grade de dados //-->        
    <div id="body_grade" style="position:absolute; top:45px; z-index:8; width:100%">
        <!--#include file="_include_grade.asp"-->                                       
    </div>
    <!-- FIM: grade de dados //-->

</div>


<form name="formdiploma" action="../confirmacao_arm.asp" method="post" target="_blank">
  <input type="hidden" name="var_cod_prod" value="">
  <input type="hidden" name="lng" id="lng" value="" />
  <input type="hidden" name="var_cod_empresa" value="">
  <input type="hidden" name="var_cod_evento" value="">
  <input type="hidden" name="var_cod_inscricao" value="<%=strCOD_INSCRICAO%>">
</form>


</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>