<%@LANGUAGE="VBSCRIPT" %>
<% Option Explicit %>
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athutils.asp"--> 
<%
Dim strCOD_EVENTO, strEV_NOME
strCOD_EVENTO = Request("cod_evento")

Dim objConn, objRS, strSQL

AbreDBConn objConn, CFG_DB_DADOS

strSQL = "SELECT COD_EVENTO, NOME FROM TBL_EVENTO"
strSQL = strSQL & " WHERE SYS_INATIVO IS NULL"
If isNumeric(strCOD_EVENTO) and strCOD_EVENTO&"" <> "" Then
  strSQL = strSQL & " AND COD_EVENTO = " & strCOD_EVENTO
End If
strSQL = strSQL & " ORDER BY DT_INICIO DESC"

Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
  strCOD_EVENTO = objRS("COD_EVENTO")
  strEV_NOME = objRS("NOME")&""
End If
FechaRecordSet objRS

If strEV_NOME = "" Then
  Response.Write("<center>Evento inválido!</center>")
  Response.End()
End If

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<script language="javascript">
<!--
function importar() {
	formimport.submit();
}
//-->
</script>
</head>

<body>
<div class="arial12">
  <p align="center"><strong>INSTRU&Ccedil;&Otilde;ES              PARA IMPORTA&Ccedil;&Atilde;O - <%=strEV_NOME%></strong></p>
  <p><strong>Passo 1</strong> &ndash;          Verifique se a Planilha Excel a ser importada segue o modelo          espec&iacute;fico para importa&ccedil;&atilde;o (<a href="MODELO_IMPORTACAO_CRA.xls" class="arial12Bold"><u>clique aqui para baixar o modelo</u></a>).</p>
<p>a)&nbsp;&nbsp;&nbsp;&nbsp; Nome da Planilha (aba &ndash; inferior da          p&aacute;gina) deve permanecer Plan1;<br>
  b)&nbsp;&nbsp;&nbsp;&nbsp; Os n&uacute;meros de CPF n&atilde;o pode conter          pontos e tra&ccedil;os;<br>
  c)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; A primeira linha sempre deve          constar o nome espec&iacute;fico dos dados de cada coluna &ndash; CRA, NOME,          CPF, CATEGORIA;<br>
  d)&nbsp;&nbsp;&nbsp;&nbsp; Altere os dados da coluna CATEGORIA          para o c&oacute;digo da categoria no sistema ProEvento:<br>
  <br>
<%
strSQL = "SELECT COD_STATUS_PRECO, STATUS FROM TBL_STATUS_PRECO WHERE COD_EVENTO = " & strCOD_EVENTO & " ORDER BY STATUS"
Set objRS = objConn.Execute(strSQL)
If not objRS.EOF Then
	Do While not objRS.EOF 
	%>
	<li><%=objRS("STATUS")%> - <b>Código: <%=objRS("COD_STATUS_PRECO")%></b><br>
	<%
	  objRS.MoveNext
	Loop
Else
%>
  - Nenhuma catetoria cadastrada para este evento.<br>
<%
End If
FechaRecordSet objRS
%>
</p>
<p><strong>Passo 2</strong> &ndash;          Clique no &iacute;cone de importa&ccedil;&atilde;o logo abaixo;</p>
<p><strong>Passo 3</strong> &ndash;          Clique em UPLOAD, escolha o arquivo em seu computador e clique          em ENVIAR. Aguarde at&eacute; que a barra de carregamento do arquivo          seja preenchida e o aviso de upload completo apare&ccedil;a na pop-up;</p>
<p><strong>Passo 4</strong> &ndash;          Feche a pop-up e clique em IMPORTAR;<br>
  <br>
  <strong> Passo 5</strong> - Relacione os nomes dos campos nos respectivos combos            e clique em IMPORTAR; </p>
<p><strong>Passo 6</strong> &ndash;          Aguarde algum tempo at&eacute; que o box de mensagem informando a          quantidade de registros importados apare&ccedil;a. N&atilde;o feche a janela          antes que este aviso seja mostrado. Compare com sua planilha          para ver se a quantidade importada e informada na mensagem &eacute; a          mesma.</p>
<p><u>IMPORTANTE</u> &ndash; Cada nova importa&ccedil;&atilde;o, a lista          anterior &eacute; apagada, valendo sempre a &uacute;ltima importa&ccedil;&atilde;o.<br>
</p>
<p align="center">
Clique no icone abaixo para iniciar o processo de importação de dados.<br />
<br />
<div align="center">
<a onClick="javascript:importar();" href="#"><img src="../img/ico_excel.gif" alt="Importar Situação Cadastral CRA-PR do Excel"  border="0"></a><br>
<br>
<form name="formimport" action="crapr_importexcel.asp" method="post" target="_blank">
            <select name="var_cod_evento" class="textbox380" onChange="document.location='crapr_socios.asp?cod_evento='+this.value;">
            <%
			strSQL = "SELECT COD_EVENTO, NOME FROM TBL_EVENTO WHERE SYS_INATIVO IS NULL ORDER BY DT_INICIO DESC"
            MontaCombo strSQL, "COD_EVENTO", "NOME", strCOD_EVENTO
			%>
            </select>
			<input type="hidden" name="var_tabela" value="tbl_empresas_startup">
			<input type="hidden" name="var_campos" value="cod_evento - <%=strCOD_EVENTO%>, id_num_doc1, nome, descricao, cod_status_preco">
            <input type="hidden" name="var_nomes" value="<%=Server.HTMLEncode("Codigo Evento,CPF,Nome,CRA,Categoria")%>">
			<input type="hidden" name="var_label" value="<%=Server.HTMLEncode("Importar Status Cadastral CRA-PR")%>">
			<input type="hidden" name="var_url" value="">
   			<input type="hidden" name="var_preacao" value="delete from tbl_empresas_startup where cod_evento = <%=strCOD_EVENTO%>">
		</form>
</div>
</p>
</div>
</body>
</html>
<%
FechaDBConn objConn
%>