<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_Usuario", session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"           ' - Default do Modulo...
 Const LTB = "tbl_usuario"	     ' - Nome da Tabela...
 Const DKN = "COD_USUARIO"       ' - Campo chave...
 Const DLD = "../modulo_usuario/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Usuário"           ' - Carrega o nome da pasta onde se localiza o modulo sendo refenrencia para apresentação do modulo no botão de filtro


 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim strNOME, strATIVO, strIDUSER, strGRPUSER, strTEMP, strCODUSUER,strSWFILTRO

'Antes de abir o banco já carrega as variaveis 
 strCODUSUER	= Replace(GetParam("var_cod_usuario"),"'","''")

 strIDUSER		= Replace(GetParam("var_id_user"),"'","''")
 strNOME		= Replace(GetParam("var_nome"),"'","''")
 strGRPUSER		= Replace(GetParam("var_grp_user"),"'","''")
 strTEMP		= Replace(GetParam("var_temporario"),"'","''")
 strATIVO		= Replace(GetParam("var_ativo"),"'","''")

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
  
   If strCODUSUER  <>   "" 	Then auxSTR = auxSTR & " AND tbl_USUARIO.COD_USUARIO    LIKE '" & strCODUSUER    & "' " 
   If strNOME      <>   "" 	Then auxSTR = auxSTR & " AND tbl_USUARIO.NOME 			LIKE '" & strNOME    & "%' "
   If strIDUSER    <>   "" 	Then auxSTR = auxSTR & " AND tbl_USUARIO.ID_USER		LIKE '" & strIDUSER  & "%' "
   If strGRPUSER   <>   "" 	Then auxSTR = auxSTR & " AND tbl_USUARIO.GRP_USER		LIKE '" & strGRPUSER & "' "

   if (strTEMP <> "")  and  (LCASE(strTEMP) <> "todos") then
		auxSTR = auxSTR & " AND tbl_USUARIO.TEMPORARIO = " & strTEMP
   end if

   if (strAtivo <> "")  and  (LCASE(strAtivo) <> "todos") then
   		if  LCASE(strAtivo) = "ativo" then
			auxSTR = auxSTR & " AND tbl_USUARIO.DT_INATIVO IS NULL "
		else
			auxSTR = auxSTR & " AND tbl_USUARIO.DT_INATIVO IS NOT NULL "
		end if
   end if

   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------
strSQL = "SELECT DISTINCT ID_USER FROM tbl_USUARIO" 
 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
if   SESSION("METRO_USER_OCULTO") = 1 then 

		strSQL = "SELECT DISTINCT tbl_USUARIO.COD_USUARIO "
	strSQL = strSQL & "	 ,  tbl_USUARIO.ID_USER"
	strSQL = strSQL & " 	 , tbl_USUARIO.NOME "
	strSQL = strSQL & "     , tbl_USUARIO.GRP_USER "
	strSQL = strSQL & "	 , tbl_USUARIO.LAST_GEN_ID "
	strSQL = strSQL & "	 , tbl_USUARIO.LAST_INSC_ID "
	strSQL = strSQL & "	 , tbl_USUARIO.DT_INATIVO "
	'strSQL = strSQL & "     , tbl_USUARIO.OCULTO " 
	strSQL = strSQL & "     , tbl_USUARIO.TEMPORARIO " 
	strSQL = strSQL & "  FROM (tbl_USUARIO "
	strSQL = strSQL & "  LEFT OUTER JOIN tbl_usuario_evento ON (tbl_usuario_evento.COD_USUARIO = tbl_USUARIO.COD_USUARIO)) " 
	strSQL = strSQL & "  LEFT OUTER JOIN tbl_evento ON (tbl_evento.COD_EVENTO = tbl_usuario_evento.COD_EVENTO AND tbl_usuario_evento.COD_EVENTO = " & Session("COD_EVENTO") & ") " 
	'strSQL = strSQL & " WHERE tbl_USUARIO.ID_USER =" & SESSION("ID_USER") &_
	'strSQL = strSQL & " AND tbl_USUARIO.OCULTO = 1 " & MontaWhereAdds
	strSQL = strSQL & " WHERE tbl_USUARIO.OCULTO >= 0 " & MontaWhereAdds 
	strSQL = strSQL & " ORDER BY tbl_USUARIO.COD_USUARIO " 
		
	
else
	 
	 	strSQL = "SELECT DISTINCT tbl_USUARIO.COD_USUARIO "
	 strSQL = strSQL & "	 , tbl_USUARIO.ID_USER "
	 strSQL = strSQL & " 	 , tbl_USUARIO.NOME "
	 strSQL = strSQL & "     , tbl_USUARIO.GRP_USER "
	 strSQL = strSQL & "	 , tbl_USUARIO.LAST_GEN_ID "
	 strSQL = strSQL & "	 , tbl_USUARIO.LAST_INSC_ID "
	 strSQL = strSQL & "	 , tbl_USUARIO.DT_INATIVO "
	 'strSQL = strSQL & "     , tbl_USUARIO.OCULTO " 
	 strSQL = strSQL & "     , tbl_USUARIO.TEMPORARIO " 
	 strSQL = strSQL & "  FROM (tbl_USUARIO "
	 strSQL = strSQL & "  LEFT OUTER JOIN tbl_usuario_evento ON (tbl_usuario_evento.COD_USUARIO = tbl_USUARIO.COD_USUARIO)) " 
	 strSQL = strSQL & "  LEFT OUTER JOIN tbl_evento ON (tbl_evento.COD_EVENTO = tbl_usuario_evento.COD_EVENTO AND tbl_usuario_evento.COD_EVENTO = " & Session("COD_EVENTO") & ") " 
	 strSQL = strSQL & " WHERE tbl_USUARIO.OCULTO = 0 " & MontaWhereAdds 
	 strSQL = strSQL & " ORDER BY tbl_USUARIO.ID_USER "

end if
 FechaRecordSet ObjRS

 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | ")) 

 ' Define os campos para exibir na grade
 strFields = "COD_USUARIO,ID_USER,NOME,GRP_USER,LAST_GEN_ID,LAST_INSC_ID,DT_INATIVO,TEMPORARIO" 
 arrFields = Split(strFields,",")     

 arrLabels = Array("CODIGO"   ,"ID_USER"	, "NOME"      , "GRUPO"     , "ULT.CAD."          , "ULT.INSCR."        , "INATIVO"  ,"TEMPORARIO"   )
 arrSort   = Array("sortable" , "sortable"  ,"sortable-numeric " , "sortable"  , "sortable-numeric"  , "sortable-numeric"  , "sortable" ,"sortable" 	)
 arrWidth  = Array("5%"        ,"8%"        , "40%"       , "9%"       , "8%"                , "5%"                , "5%"       ,"10%"      		)  'obs.:[somar 98%] ou deixar todos vazios
' ---------------------------------------------------------------------------------------------------------------------

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 

 
	


 strALL_PARAMS = URLDecode(Request.Form) 'neste caso não pode usar GetParam
 strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para não trancar a paginaçãoz
 'athDebug "[" & strALL_PARAMS & "]", false

 If (not objRS.eof) Then 
   objRS.AbsolutePage = GetCurPage
 End If
%>
<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro" id="metrotablevista" onunload="SaveData()" onload="LoadData()">
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
                        <p class="button bg-dark fg-white"><%=AthWindow("INSERT.asp", 520, 620,"ADICIONAR")%></p>
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