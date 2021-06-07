<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_class/ASPMultiLang/ASPMultiLang.asp"--> 
<%
 Dim objConn, objRS, objRSDetail, strSQL
 Dim strCOD_INSCRICAO, strCOMPROVANTE_CATEGORIA, strCOMPROVANTE_CATEGORIA2, strNRO_COMPROVANTE
  
 AbreDBConn objConn, CFG_DB

 strCOD_INSCRICAO			= getParam("var_cod_inscricao")
 strCOMPROVANTE_CATEGORIA	= getParam("var_comprovante_categoria")
 strCOMPROVANTE_CATEGORIA2	= getParam("var_comprovante_categoria2")
 strNRO_COMPROVANTE			= getParam("var_nro_comprovante")
  
 If strNRO_COMPROVANTE = 2 Then
	strSQL = "UPDATE tbl_Inscricao SET COMPROVANTE_CATEGORIA2 = " & strToSql(strCOMPROVANTE_CATEGORIA2) & " WHERE COD_INSCRICAO = " & strCOD_INSCRICAO
 Else
	strSQL = "UPDATE tbl_Inscricao SET COMPROVANTE_CATEGORIA = " & strToSql(strCOMPROVANTE_CATEGORIA) & " WHERE COD_INSCRICAO = " & strCOD_INSCRICAO
 End If
 objConn.Execute(strSQL)
 FechaDBConn ObjConn
%>
<script type="text/jscript" language="javascript">
	parent.document.getElementById('formgeral').submit();
</script>