<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("mini_PaperSearch",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          					' - Default do Modulo...
 Const LTB = "tbl_paper"	    					' - Nome da Tabela...
 Const DKN = "cod_paper"          					' - Campo chave...
 Const DLD = "../pax/mini_PaperSearch/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, objRSDetail, strSQL, objLang
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO, flagACHOU
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strFilCodPaper, strFilCodArea, strFilStatus, strFilAutor, strFilTitulo, strFilArea
 Dim strCOD_INSCRICAO, strCOD_EVENTO, strNOME_EVENTO

 
 'Carraga os valores das varíáveis enviadaos pelo filtro 
 strCOD_INSCRICAO  = Replace(GetParam("var_chavereg"),"'","''")

 'Filtros	
 strFilCodPaper	= GetParam("var_COD_PAPER")
 strFilCodArea	= GetParam("var_COD_PAPER_AREA")
 strFilStatus	= GetParam("var_COD_PAPER_STATUS")
 strFilAutor	= GetParam("var_autor")
 strFilTitulo	= GetParam("var_titulo")
 strFilArea		= GetParam("var_area")


 'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
 '---------------------------------------------------------------------------------------------------------------


 ' alocando objeto para tratamento de IDIOMA
 Set objLang = New ASPMultiLang
 objLang.LoadLang Request.Cookies("METRO_pax")("locale"),"../lang/"
 ' -------------------------------------------------------------------------------


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
  auxSTR = ""
  
  If strFilCodPaper <> "" Then
	auxSTR = auxSTR & " AND tbl_Paper.COD_PAPER = " & strFilCodPaper
  End If

  If strFilCodArea <> "" Then
	auxSTR = auxSTR & " AND tbl_Paper_Area.COD_Paper_Area = " & strFilCodArea
  End If

  If strFilStatus <> "" Then
	auxSTR = auxSTR & " AND tbl_Paper_Status.COD_Paper_Status = " & strFilStatus
  End If


  ' --------------------------------------------------------------------------------------------------
  ' FILTROS de GAMBIARRA original do Mauro para poder filtrar por campos que supostamente sáo titulo 
  ' ou autor, neste caos como os campos tem nomes dinâmicos, ele tentou fazer teste apartir dos supostos 
  ' nomes "título e autor" para então pesquizar nos valores correspondentesw.. enfim. 
  ' Não consegui melhorar essa parte e "por enqaunto" fica assim, até novas demandas serem apondadas 
  ' (funciona bem se no paper houverm campos nome: "título..." e "autor..."      by Aless 30/03/2017
  If strFilAutor <> "" Then
     auxSTR = auxSTR & " AND tbl_Paper_Cadastro.COD_Paper_Cadastro IN "
	 auxSTR = auxSTR & "     (SELECT Cod_Paper_Cadastro FROM  tbl_Paper_Sub, tbl_Paper_Sub_Valor"
	 auxSTR = auxSTR & "      WHERE tbl_Paper_Sub.COD_PAPER_SUB = tbl_Paper_Sub_Valor.COD_PAPER_SUB  "
	 If strFilCodPaper <> "" Then 
		auxSTR = auxSTR & "        AND tbl_Paper_Sub.COD_PAPER = " & strFilCodPaper
	 End if	
	 auxSTR = auxSTR & "        AND tbl_Paper_Sub.CAMPO_NOME LIKE '%Autor%'"
	 auxSTR = auxSTR & "        AND tbl_Paper_Sub_Valor.CAMPO_VALOR LIKE '%" & strFilAutor & "%')"
  End If

  If strFilTitulo <> "" Then
	auxSTR = auxSTR & " AND tbl_Paper_Cadastro.COD_Paper_Cadastro IN "
	auxSTR = auxSTR & "     (SELECT Cod_Paper_Cadastro FROM  tbl_Paper_Sub, tbl_Paper_Sub_Valor"
	auxSTR = auxSTR & "      WHERE tbl_Paper_Sub.COD_PAPER_SUB = tbl_Paper_Sub_Valor.COD_PAPER_SUB  "
	If strFilCodPaper <> "" Then 
		auxSTR = auxSTR & "        AND tbl_Paper_Sub.COD_PAPER = " & strFilCodPaper
	End if	
	auxSTR = auxSTR & "        AND tbl_Paper_Sub.CAMPO_NOME LIKE '%Título%'"
	auxSTR = auxSTR & "        AND tbl_Paper_Sub_Valor.CAMPO_VALOR LIKE '%" & strFilTitulo & "%')"
  End If
  ' --------------------------------------------------------------------------------------------------
  
   MontaWhereAdds = auxSTR 
 end function
 ' --------------------------------------------------------------------------------------------------------------


 ' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

 'BUSCA código do evento a partir do cod_inscrição recebido, para PERMITIR pesquisar os trabalhos do evento
 '... mas ... temos o caso especial (cahamando essa página para uso em TOTENS que devem permitir  apenas  a 
 'pesquisa dos trabalhoa postados um determinado EVENTO e PAPER, por exemplo:
 strCOD_EVENTO = Replace(GetParam("var_cod_evento"),"'","''")
 ' http://pvista.proevento.com.br/[CLIENTE]/pax/mini_PaperSearch/?var_cod_evento=107&var_cod_paper=4
 ' neste caso o cod_evento veio e nãop devo pegar o COD_EVENTO da inscrição (este s´[o vem quando esta ppágina é chamada diratemtene do PAX a partir do painel.asp
 if (strCOD_EVENTO = "") then 
			  strSQL = " SELECT cod_evento, cod_empresa "
	 strSQL = strSQL & "   FROM tbl_inscricao "
	 strSQL = strSQL & "  WHERE cod_inscricao = " & strCOD_INSCRICAO
	 set objRS = objConn.Execute(strSQL)
	 If NOT objRS.eof Then
		strCOD_EVENTO  = getValue(objRS,"cod_evento")
	 End If
 End If


 strSQL = " SELECT nome, nome_completo FROM tbl_evento WHERE cod_evento = " & strCOD_EVENTO
 set objRS = objConn.Execute(strSQL)
 If NOT objRS.eof Then
	strNOME_EVENTO  = getValue(objRS,"nome")
 End If

		  strSQL = "  SELECT DISTINCT tbl_Paper_Cadastro.COD_PAPER_CADASTRO "
 strSQL = strSQL & " ,tbl_Paper.COD_PAPER "
 strSQL = strSQL & " ,tbl_Paper.DESCRICAO "
 strSQL = strSQL & " ,tbl_Paper_Cadastro.SYS_DATAFINISH "
 strSQL = strSQL & " ,tbl_Empresas.NOMECLI AS NOME "
 strSQL = strSQL & " ,tbl_Empresas.EMAIL1 "
 strSQL = strSQL & " ,tbl_Paper_Area.COD_PAPER_AREA "
 strSQL = strSQL & " ,tbl_Paper_Area.AREA_PAPER "
 strSQL = strSQL & " ,tbl_Paper_Status.STATUS "
 strSQL = strSQL & " ,tbl_Paper_Cadastro.IDENTIFICACAO "
 strSQL = strSQL & " ,tbl_Paper_Sub_Valor.CAMPO_VALOR "
 strSQL = strSQL & " FROM tbl_Paper_Cadastro INNER JOIN tbl_Paper ON tbl_Paper_Cadastro.COD_PAPER = tbl_Paper.COD_PAPER "
 strSQL = strSQL & "        INNER JOIN tbl_paper_sub ON tbl_Paper.cod_paper = tbl_paper_sub.cod_paper "
 strSQL = strSQL & "        INNER JOIN tbl_paper_sub_valor ON tbl_paper_sub.cod_paper_sub = tbl_paper_sub_valor.cod_paper_sub and tbl_paper_sub_valor.COD_PAPER_CADASTRO = tbl_Paper_Cadastro.COD_PAPER_CADASTRO "
 strSQL = strSQL & "        INNER JOIN tbl_Empresas ON tbl_Paper_Cadastro.COD_EMPRESA = tbl_Empresas.COD_EMPRESA "
 strSQL = strSQL & "        LEFT JOIN tbl_Paper_Area ON tbl_Paper_Cadastro.COD_PAPER_AREA = tbl_Paper_Area.COD_Paper_Area "
 strSQL = strSQL & "        LEFT JOIN tbl_Paper_Status ON tbl_Paper_Cadastro.COD_PAPER_STATUS = tbl_Paper_Status.COD_Paper_Status "
 strSQL = strSQL & " WHERE tbl_Paper_Cadastro.SYS_DATAFINISH IS NOT NULL "
 strSQL = strSQL & "   AND tbl_Paper.COD_EVENTO = " &  strCOD_EVENTO 
 strSQL = strSQL & "   AND tbl_paper_sub.CAMPO_TIPO = 'F' "
 strSQL = strSQL & MontaWhereAdds
 strSQL = strSQL & " ORDER BY tbl_Paper_Cadastro.SYS_DATAFINISH " 

 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 


 'ATENÇÃO neste caso não foram montados os arraus de CAMPOS, Labels, etc porque a montade 
 'dos paper e suppaper e fica complicado organizar a forma de arrays (que antes ficavam nessa região)
 '---------------------------------------------------------------------------------------------------

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
<script src="../../_scripts/scriptsCS.js"></script>
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
                        	<i class="icon-search <%if (trim(strSWFILTRO)<>"") then response.write(" fg-white") end if%>" title="<%=lcase(strSWFILTRO) & " | " & strCOD_EVENTO %>"></i>
							<%=objLang.SearchIndex("mini_trabalho_pesquisar",0)%>&nbsp;
							<%'=objLang.SearchIndex("mini_trabalho_pesquisar_ext",0)%>
							<%=" (" & strNOME_EVENTO & ")"%>
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
            <!--
            <div style="border:0px solid #F00; position:relative; top:0px; float:right; padding-top:7px; padding-right:10px;">
                <p class="button bg-dark fg-white"><%'=AthWindow("INSERT.ASP", 520, 620, "ADICIONAR")%></p>&nbsp;
                <p class="button bg-dark fg-white"><i class="icon-help-2 fg-white" onClick="javascript:location.href='./help/default.asp';"></i></p>
            </div>
            //-->
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