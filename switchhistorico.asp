<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="_scripts/scripts.js"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
Dim objRSIn, objRSInHist, objConn, strSQL

AbreDBConn objConn, CFG_DB_DADOS

strSQL = " SELECT COUNT(COD_CONTROLE_IN) AS NUM_TOTAL, COD_EVENTO FROM TBL_CONTROLE_IN GROUP BY COD_EVENTO ORDER BY COD_EVENTO "
Set objRSIn = objConn.execute(strSQL)

strSQL = " SELECT COUNT(COD_CONTROLE_IN) AS NUM_TOTAL, COD_EVENTO FROM TBL_CONTROLE_IN_HIST GROUP BY COD_EVENTO ORDER BY COD_EVENTO "
Set objRSInHist = objConn.execute(strSQL)

%>
<html>
	<head>
		<title>PROEVENTO - Trocar Evento</title>
		<script>
			function switchHistorico(prDirec) {
				strAtual = (prDirec == "controle_in") ? "controle_in_hist" : "controle_in";
				
				var objForm = document.formswitch;
				var selectedIndex = eval("objForm.var_" + strAtual + ".selectedIndex")
				var maxIndex = eval("objForm.var_" + prDirec + ".length")

				if(maxIndex >= 0 & selectedIndex > -1){
					var intValueCombo = eval("objForm.var_" + strAtual + ".options[" + selectedIndex + "].value");
					var strLabelCombo = eval("objForm.var_" + strAtual + ".options[" + selectedIndex + "].text");
					
					objForm.var_tabela_prod.value = prDirec
					objForm.var_cod_evento.value = intValueCombo
					
					var objOption = document.createElement('option');
					
					objOption.text = strLabelCombo
					objOption.value = intValueCombo
					
					eval("document.formswitch.var_" + strAtual + ".remove(selectedIndex)");
					eval("document.formswitch.var_" + prDirec + ".add(objOption,-1)");
					
					objForm.submit();
				}
			}
		</script>
	</head>
	<body>
		<form name="formswitch" action="switchhistorico_exec.asp" method="post">
			<input type="hidden" name="var_tabela_prod" value="">
			<input type="hidden" name="var_cod_evento" value="">
		<table align="center" border="0" cellpadding="0" cellspacing="5" width="500">
			<tr bgcolor="#EEEEEE">
				<td style="font-family:Arial; font-size:13px" align="center"><b>Controle In</b></td>
				<td></td>
				<td style="font-family:Arial; font-size:13px" align="center"><b>Controle In Hist.</b></td>
			</tr>
			<tr>
				<td width="49%" align="center">
					<select name="var_controle_in" size="5" style="font-family:Courier New; width:200px">
						<%
						While Not objRSIn.EOF
							Response.Write("<option value=""" & objRSIn("COD_EVENTO") & """>" & ATHFormataTamLeft(Cstr(objRSIn("COD_EVENTO")),4,"0") & " | " & objRSIn("NUM_TOTAL") & "</option>")
							objRSIn.MoveNext
						Wend
						%>
					</select>
				</td>
				<td width="2%">
					<input type="button" value="&gt;&gt;" onClick="switchHistorico('controle_in_hist')"><br><br>
					<input type="button" value="&lt;&lt;" onClick="switchHistorico('controle_in')">
				</td>
				<td width="49%" align="center">
					<select name="var_controle_in_hist" size="5" style="font-family:Courier New;width:200px">
						<%
						While Not objRSInHist.EOF
							Response.Write("<option value=""" & objRSInHist("COD_EVENTO") & """>" & ATHFormataTamLeft(Cstr(objRSInHist("COD_EVENTO")),4,"0") & " | " & objRSInHist("NUM_TOTAL") & "</option>")
							objRSInHist.MoveNext
						Wend
						%>
					</select>
				</td>
			</tr>
		</table>
		</form>
	</body>
</html>
<%
FechaRecordSet(objRSIn)
FechaRecordSet(objRSInHist)
FechaDBConn(objConn)
%>