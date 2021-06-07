<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<%
 Dim objConn, ObjRS
 Dim strSQL, strvalor
 
 AbreDBConn objConn, CFG_DB 
 
 '--------------------------------------------------------------------------------------------------------------------
 ' Novo SQL otimizado para ajustar o controle de saldo
 ' Mauro - 10/09/2013
 strSQL = "update tbl_Produtos p set p.ocupacao = (select if(ip.QTDE is null,0,sum(ip.QTDE)) from tbl_inscricao_produto ip where ip.cod_prod = p.cod_prod) WHERE p.COD_EVENTO = " &  Session("COD_EVENTO") 
 objConn.Execute(strSQL)
 
 FechaDBConn ObjConn
%>
<style type="text/css">
<!--
.style1 {
  font-family: Verdana, Arial, Helvetica, sans-serif;
  font-size: 12px;
}
-->
</style>
<div align="center" class="style1">Processo finalizado.</div>