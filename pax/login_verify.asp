<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%
 'Dim objConn, objRS, strSQL
 Dim strLOCALE
 Dim strCOD_EMP, strIDAUTO_EMP, strIDAUTO_SUB, strCODBARRA_EMP, strCODBARRA_SUB
 Dim strNOMEFAN_EMP, strNOMECRED_SUB
 Dim strIDENTIFICADOR, strEMAIL, strFOTO
 Dim strTIPO_PESS, strTABELA

 ' O AJAX retorna os elementos da seguinte forma:[...|...|...|]{...|...|...]...
 ' COD_EMPRESA |  IDAUTO_EMP | IDAUTO_SUB | CODBARRA_EMP | CODBARRA_SUB | NOMEFAN AS NOME_EMP | NOME_CREDENCIAL AS NOME_CRED | ES.ID_CPF ou E.ID_NUM_DOC1 | EMAIL | TIPO_PESS | TABELA 
 ' E os campos repassados pela default.asp sãos os seguintes:
 '
 '  lng | 
 '	var_cod_emp       | var_idauto_emp   | var_idauto_sub | var_codbarra_emp  | var_codbarra_sub		
 '  var_nomefan_emp   | var_nomecred_sub | var_email      | var_tipopess_emp
 '	var_identificador |	var_tabela
 '
 '  [var_identificador => ID_NUM_DOC1 (da tbl_emresas) OU ID_CPF (da empresas_sub) | na verade será o que foi digitado pra logar 
 '  ---------------------------------------------------------------------------------------------------------------------------------------------------------- 03/03/2017 - by Aless - 

 strCOD_EMP 		= getParam("var_cod_emp")
 strIDAUTO_EMP	 	= getParam("var_idauto_emp")
 strIDAUTO_SUB 		= getParam("var_idauto_sub")
 strCODBARRA_EMP 	= getParam("var_codbarra_emp" )
 strCODBARRA_SUB 	= getParam("var_codbarra_sub")
 strNOMEFAN_EMP 	= getParam("var_nomefan_emp")
 strIDENTIFICADOR	= getParam("var_identificador")
 strNOMECRED_SUB	= getParam("var_nomecred_sub")
 strEMAIL			= getParam("var_email")
 strFOTO			= getParam("var_foto")
 strTIPO_PESS		= getParam("var_tipopess_emp") 
 strTABELA			= getParam("var_tabela")

 'ATENÇÃO 
 '
 ' Essa [login_verify] não precisa fazer uma verificação/pesquisa de "elemento + senha", pois a DEFAULT.asp aciona o AJAX que busca 
 ' já elementos que correspondam ao identificador digitado (e-mail/cpf) e, quando requisitada senha, traz somente os que estão de acordo 
 ' com estes valores.
 ' 
 ' Desta forma essa página tem a função de:
 ' - REPASSAR os parâmetros para a página PRINCIPAL (que contém a "moldura" com menu / rodapé, e o IFRAME para conteúdo, onde o painel principal será aberto.
 ' - Buscar alguma informação nova no banco, se necessário, e adicioná-la como parâmetro para a PRINCIPAL
 '  ---------------------------------------------------------------------------------------------------------------------------------------------------------- 13/03/2017 - by Aless - 
%>
<html>
<head>
<title>pVSITA PAX</title>
</head>
<body class='metro' onLoad="document.formulario.submit();">
<form id="formulario" name="formulario" action="principal.asp" method="post">
    <input type="hidden" id="var_cod_emp"		name="var_cod_emp"		 value="<%=strCOD_EMP%>">
    <input type="hidden" id="var_idauto_emp"	name="var_idauto_emp"	 value="<%=strIDAUTO_EMP%>">
    <input type="hidden" id="var_idauto_sub"	name="var_idauto_sub"	 value="<%=strIDAUTO_SUB%>">
    <input type="hidden" id="var_codbarra_emp"	name="var_codbarra_emp"  value="<%=strCODBARRA_EMP%>">
    <input type="hidden" id="var_codbarra_sub"	name="var_codbarra_sub"	 value="<%=strCODBARRA_SUB%>">
    <input type="hidden" id="var_nomefan_emp"	name="var_nomefan_emp"	 value="<%=strNOMEFAN_EMP%>">
    <input type="hidden" id="var_identificador"	name="var_identificador" value="<%=strIDENTIFICADOR%>">
    <input type="hidden" id="var_nomecred_sub"	name="var_nomecred_sub"	 value="<%=strNOMECRED_SUB%>">
    <input type="hidden" id="var_email"			name="var_email"		 value="<%=strEMAIL%>">
    <input type="hidden" id="var_foto"			name="var_foto"		 	 value="<%=strFOTO%>">
    <input type="hidden" id="var_tipopess_emp"	name="var_tipopess_emp"  value="<%=strTIPO_PESS%>">
    <input type="hidden" id="var_tabela"		name="var_tabela"		 value="<%=strTABELA%>">
</form>
</html>