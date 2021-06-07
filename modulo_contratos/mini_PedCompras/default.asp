<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_clientes",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          											' - Default do Modulo...
 Const LTB = "tbl_clientes_sub"							    		' - Nome da Tabela...
 Const DKN = "cod_tbl_clientes_sub"										      	  		' - Campo chave...
 Const DLD = "../modulo_Clientes/mini_Contatos/default.asp" 	' "../evento/data.asp" - 'Default Location ap�s Dele��o
 Const TIT = "Contatos"												' - Nome/Titulo sendo referencia como titulo do m�dulo no bot�o de filtro
 

 'Relativas a conex�o com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Pagina��o	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCodServ,strCodEvento
 


'Carraga a chave do registro, por�m neste caso a rela��o masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------

strCodServ			= Replace(GetParam("var_chavereg"),"'","''")

'------------------------------------------------------------------

'ATHDEBUG strINSTRUCAO, true

'------------------------------------------------------------------

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

 
   

 
                                                                                                                                            
 $strSQL = "	SELECT  t1.idcontrato,                                                                                                      "                                     
strSQL = strSQL &"		to_char(t1.data, 'dd/mm/yyyy') as data,"
strSQL = strSQL &"		t1.comprador, "
strSQL = strSQL &"		t1.nomec, "
strSQL = strSQL &"		concat(t1.cidadec,'/',t1.estadoc) AS LOCALC, "
strSQL = strSQL &"		t1.vendedor, "
strSQL = strSQL &"		t1.nomev, "
strSQL = strSQL &"		concat(t1.cidadev,'/',t1.estadov) AS LOCALV, "
strSQL = strSQL &"		concat(t2.produto,case when subproduto IS NULL then '' else  ' - ',subproduto) END  AS prodcontrato, "
strSQL = strSQL &"		( quantidade * kg ) / 1000 AS QTDETON, "
strSQL = strSQL &"		t1.quantidade, "
strSQL = strSQL &"		t1.preco, "
strSQL = strSQL &"		t1.comprador, "
strSQL = strSQL &"		t1.nfv_data, "
strSQL = strSQL &"		t1.nfv_valor, "
strSQL = strSQL &"		t1.nfv_nro, "
strSQL = strSQL &"		to_char(t1.nfv_pagto, 'dd/mm/yyyy') as nfv_pagto,"
strSQL = strSQL &"		(case when preco is null then 0 else preco end * case when quantidade is null then 0 else quantidade end)/1000 as total"
strSQL = strSQL &"	FROM  tbl_contrato t1"
strSQL = strSQL &"	left join tbl_produtos t2 on t1.produto = t2.idprod"
strSQL = strSQL &"	left join tbl_produtos_2 t3 on t1.produtosub = t3.idsubprod"
strSQL = strSQL &"	left join tbl_unidade t4 on t1.unidade = t4.descrunid"
strSQL = strSQL &"	where t1.vendedor = " & strCodServ  
strSQL = strSQL &"	order by t1.data desc"
 
 
		  
 'athDebug strSQL , TRUE

 ' Define os campos para exibir na grade
 strFields = "cod_tbl_clientes_sub, contato,celular, mailcom" 
 arrFields = Split(strFields,",")        

 arrLabels = Array("Contr"                    , "Data"           , "Comprador"           , "E-mail"                 )
 arrSort   = Array("sortable-numeric"       , "sortable" , "sortable" , "sortable"      ) 'Obs.:"sortable-date-dmy", "sortable-currency", "sortable-numeric", "sortable" 
 arrWidth  = Array("2%"                     , "30%"               , "15%"      	        , "15%"                    )     'Obs.:[somar 98%] ou deixar todos vazios
' ----------------------------------------------------------------------------------------------------------------------------

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
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js	"></script>
</head>
<body class="metro">
<!-- Embora um MINI M�dulo esteja convencionado a n�o ter elementos de filtragem
         criamos este Formul�rio de filtro necess�rio para envio da p�gina corrrente
         armazenamento da qqtde de elementos por p�gtina //-->
     <form id="formfiltro" name="formfiltro" action="default.asp" method="post" style="display:none; visibility:hidden;" >
      <input type="hidden" id="var_numperpage"    name="var_numperpage"         value="<%=numPerPage%>">
      <input type="hidden" id="var_chavereg"      name="var_chavereg"           value="<%=strCodServ%>">
      <input type="hidden" id="var_status_cred"   name="var_cod_evento"         value="<%=strCodEvento%>">     
      <input type="hidden" id="DEFAULT_LOCATION"  name="DEFAULT_LOCATION"       value="default.asp">        			
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
                        	<%=strCodServ%>.
                            <i class=" <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & Session("COD_EVENTO")%>"></i>
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
			<!-- INI: Bot�es //-->
             <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:7px; padding-right:10px;">
<!--                <p class="button bg-dark fg-white"><'%=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp;//-->                
					<p class="button bg-dark fg-white"><a href="#" onClick="javascript:AbreJanelaPAGE_NOVA('insert.asp?var_chavereg=<%=strCodServ%>','520','620')">ADICIONAR</a></p>&nbsp;                

             </div>
			<!-- FIM: Bot�es //-->
        </div>
    </div>
    
	            
       
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