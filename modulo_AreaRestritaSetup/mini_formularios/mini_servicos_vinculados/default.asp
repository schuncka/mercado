<!--#include file="../../../_database/athdbConnCS.asp"-->
<!--#include file="../../../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 
VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_servicos_vinculados",Session("METRO_USER_ID_USER")), true 

 Const MDL = "DEFAULT"          								' - Default do Modulo...
 Const LTB = "TBL_FORMULARIOS_SERVICOS" 								    ' - Nome da Tabela...
 Const DKN = "IDAUTO"									    ' - Campo chave...
 Const DLD = "../modulo_AreaRestritaSetup/mini_formularios/mini_servicos_vinculados/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Edição de campos"									' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2, objRSLocal
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strID_AUTO, strCOD_EVENTO, strCOD_FORMULARIO, strCOD_DADO, strID_DOCUMENTO
 

'Carraga a chave do registro, porém neste caso a relação masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------
strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")
strID_DOCUMENTO = Replace(GetParam("var_chavereg"),"'","''")

'------------------------------------------------------------------

'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage = "") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
'---------------------------------------------------------------------------------------------------------------

 'Relativos a PAGINAÇÃO ----------------------------------------------------------------------------------------
 'Altera a qtde de elemetnos por página a partir do filtrpo 
 auxNumPerPage = Replace(GetParam("var_numperpage"),"'","''") 
 If (auxNumPerPage <> "") then 
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
strSQL = " SELECT fs.IDAUTO, aserv.titulo, fs.qtde_fixa, fs.ordem  " &_
            "   FROM tbl_formularios_servicos AS fs left join tbl_aux_servicos as ASERV ON fs.COD_SERV = aserv.COD_SERV " &_
            "  WHERE fs.COD_FORMULARIO = " & strID_DOCUMENTO &_
            "  ORDER BY ORDEM, TITULO " 
			 		  
 'athDebug strSQL , false

 ' Define os campos para exibir na grade 
 strFields = "idauto, qtde_fixa, ordem"  
 arrFields = Split(strFields,",")        
 arrFields = Split(strFields,",")        

 arrLabels = Array("CÓD-SERVICO" ,"QTDE FIXA"   ,"ORDEM")
 arrSort   = Array("sortable"    ,"sortable"    ,"sortable") 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array(""            ,""            ,     "" ) 'Obs.:[somar 98%] ou deixar todos vazios
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
<!--#include file="../../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../../_scripts/scriptsCS.js	"></script>
</head>
<body class="metro">
<!-- Embora um MINI Módulo esteja convencionado a não ter elementos de filtragem
         criamos este Formulário de filtro necessário para envio da página corrrente
         armazenamento da qqtde de elementos por págtina //-->
<form id="formfiltro" name="formfiltro" action="default.asp" method="post" style="display:none; visibility:hidden;" >
    <input type="hidden" id="var_numperpage" name="var_numperpage" value="<%=numPerPage%>">
    <input type="hidden" id="var_chavereg"   name="var_chavereg"   value="<%=strID_DOCUMENTO%>">
    <input type="hidden" id="var_cod_evento"   name="var_cod_evento" value="<%=strCOD_EVENTO%>">
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
                        	<%=strCOD_EVENTO%>.
                            <i class=" <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & strCOD_EVENTO%>"></i>
							<%=TIT%>
                        </p>
                    </a>
                    <div class="content bg-white span3" style="border:1px solid #CCC;">
                        <div class="panel-content bg-white">	
                        	<!-- ondeficavafiltro--> 
                        </div>
                    </div>
                     
                </div>
            </div>
			<!-- FIM: Filtro (accordiion -para filtragem) //-->
			<!-- INI: Botões //-->
             <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:7px; padding-right:10px;">
<!--                <p class="button bg-dark fg-white"><'%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp;//-->                
					<p class="button bg-dark fg-white"><a href="#" onClick="javascript:AbreJanelaPAGE_NOVA('insert.asp?var_chavemaster=<%=strCOD_EVENTO%>','520','620')">ADICIONAR</a></p>&nbsp;                

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