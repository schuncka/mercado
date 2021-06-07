<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
	 Const MDL = "DEFAULT"          							' - Default do Modulo...
	 Const LTB = "tbl_usuario"	    							' - Nome da Tabela...
	 Const DKN = "cod_usuario"          		   				' - Campo chave...
	 Const DLD = "../modulo_Usuario/exiberangelivre.asp.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
	 Const TIT = "Exibe Range"    							    ' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

	'Relativas a conexão com DB, RecordSet e SQL
	Dim objConn, objRS_p, objRS_f, strSQL,strSQL2
	'Adicionais
	Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
	'Relativas a SQL principal do modulo
	Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult 
	'Dim strFields2, arrFields2, arrLabels2, arrSort2, arrWidth2
	'Relativas a Paginação	
	Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
	'Relativas a FILTRAGEM
	Dim  strMOSTRAFILHOS, strCODEMPRESAS, strCODPAI


    strCODPAI = GetParam("var_cod_pai")
	
	 
'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
'---------------------------------------------------------------------------------------------------------------

' Monta SQLpai e abre a consulta ----------------------------------------------------------------------------------
 strSQL = " SELECT left(cod_empresa,2) as COD ,count(*) as CONTADOR FROM tbl_empresas group by 1 order by 1"

 AbreRecordSet objRS_p, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro">
<div class="grid fluid">
 <div class="padding20">
            <h1><i class="icon-database fg-black on-right on-left"></i>Exibe Range</h1>
            <h2>Exibir Ranges Livres</h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>
     <hr>         
	<div class="padding20" style="border:1px solid #999; width:100%; height:450px; overflow:scroll; overflow-x:hidden;">
	<% 
    	If (not objRS_p.BOF) and (not objRS_p.EOF) Then 
    %>
	
    <table class="tablesort table striped">
    <!-- Possibilidades de tipo de sort...  class="sortable-date-dmy" / class="sortable-currency" / class="sortable-numeric" / class="sortable" //-->
    <thead>
        <tr> 	        
			<th style="width:1%;"  class="" ></th>
	        <th style="width:20%;" class="sortable-numeric" >COD(BASE)</th>
	        <th style="width:77%;" class="sortable-numeric" >QUANTIDADE</th>
        </tr>
    </thead>
    <tbody>
		<%
        i = 0
        Do While (Not objRS_p.EOF) 
	        response.Write ("<tr>" & vbnewline)
			response.Write (" <td  align='left'><a href='exiberangelivre.asp?var_cod_pai=" & GetValue(objRS_p,"COD") & "'><img class='dropdown-toggle' src='../img/icon_action.gif'></a></td>"& vbnewline)
	        response.Write (" <td  align='left'><a href='exiberangelivre.asp?var_cod_pai=" & GetValue(objRS_p,"COD") & "'>" & GetValue(objRS_p,"COD") & "</a></td>" & vbnewline)
	        response.Write (" <td  align='left'>" & GetValue(objRS_p,"CONTADOR") & "</td>" & vbnewline)
	        response.Write ("</tr>" & vbnewline)
			if strCODPAI = GetValue(objRS_p,"COD") then
        		response.Write ("<tr><td colspan='3' >")
        		response.Write ("<table class='tablesort striped hovered' style='width:50%;' id='div2'><tread><th>COD(base)</th><th>RANGE</th><th>QTE</th></teread>")
				' Monta SQLfilhos e abre a consulta ----------------------------------------------------------------------------------
				 strSQL = "SELECT left(cod_empresa,3) AS COD_F, count(*)  AS QTDE_F FROM tbl_empresas WHERE cod_Empresa like '" & strCODPAI & "%' group by 1 order by 1"
				 AbreRecordSet objRS_f, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 
				 Do While (Not objRS_f.EOF)

	        		response.Write ("<tr><td class='fg-red'>" & GetValue(objRS_p,"COD")  & " </td><td class='fg-red'>" & GetValue(objRS_f,"COD_F") & " </td><td class='fg-red'> " & GetValue(objRS_f,"QTDE_F") & "</td></tr>" & vbnewline)
					
					athMoveNext objRS_f, ContFlush, CFG_FLUSH_LIMIT
				 Loop
        		response.Write ("<tfoot><td colspan='3'></td></tfoot></table>") 
        		response.Write ("</td></tr>")
			End IF
        i = i + 1
        athMoveNext objRS_p, ContFlush, CFG_FLUSH_LIMIT
        Loop
        %>
    </tbody>
    <tfoot>
    <tr>
        <td colspan="3" style="padding-top:3px; border-top:1px solid #000;  background-color:#F8F8F8;" >
        </td>
    </tr>
    </tfoot>
    </table>
    <%
    strSQL2 = "SELECT NOME, ID_USER, START_GEN_ID, LAST_GEN_ID FROM tbl_USUARIO WHERE " & clng(strCODPAI) & " BETWEEN START_GEN_ID AND LAST_GEN_ID"
    'response.Write(strSQL2)
	%>
<div class="indent"></div>
	<%
    Else
      Mensagem "Não existem dados para esta consulta.<br>Informe novos critérios para efetuar a pesquisa.", "","", true 
    End If
    %>
                                     
    </div>
    <!-- FIM: grade de dados PAI //-->
  </div> 
</div>
</body>
</html>
<% 
  FechaRecordSet ObjRS_p
  FechaDBConn ObjConn 
%>