<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
Dim objConn, objConnSchema, objRS, objRSSchema, strSQL
Dim strDATABASE, arrDATABASE, strSCRIPT, arrSCRIPT, strSTATUS, strACAO
Dim i

'teste
strACAO = Request("var_acao")

 Const auxAVISO  = "ATENÇÃO! Este procedimento RECALCULARÁ e AJUSTARÁ TODAS as CONTAS BANCO Cadastradas no sistema. Para confirmar clique no botão [ok], para desistir clique em [cancelar]."



Sub AjustaFinanceiro(pr_objConn, prCodConta)
		Dim objRS1_local, objRS2_local, strSQL_local, Cont_local
		Dim strCOD_CONTA, strMES, strANO, strDATA1, strDATA2, strOPERACAO
		Dim strVALOR, strSALDO1, strSALDO2
		
		Cont_local = 0
		
		'Limpa os saldos financeiros
		athDebug "<br>Deletando saldos...", False
		
		strSQL_local = " DELETE FROM FIN_SALDO_AC "
		If prCodConta <> "" Then strSQL_local = strSQL_local & " WHERE COD_CONTA = " & prCodConta
		pr_objConn.Execute(strSQL_local)
		
		'Varre todas as contas
		strSQL_local = " SELECT COD_CONTA, NOME, VLR_SALDO_INI, DT_CADASTRO FROM FIN_CONTA "
		If prCodConta <> "" Then strSQL_local = strSQL_local & " WHERE COD_CONTA = " & prCodConta
		Set objRS1_local = pr_objConn.Execute(strSQL_local)
		
		Do While Not objRS1_local.Eof
			athDebug "<br><br><br><strong>Ajustando conta " & GetValue(objRS1_local, "COD_CONTA") & " - " & GetValue(objRS1_local, "NOME") & "</strong>", False
			
			strCOD_CONTA = GetValue(objRS1_local, "COD_CONTA")
			strMES = DatePart("M", GetValue(objRS1_local, "DT_CADASTRO"))
			strANO = DatePart("YYYY", GetValue(objRS1_local, "DT_CADASTRO"))
			strVALOR = FormatNumber(GetValue(objRS1_local, "VLR_SALDO_INI"), 2)
			strVALOR = Replace(Replace(strVALOR,".",""),",",".")
			strSALDO1 = FormatNumber(GetValue(objRS1_local, "VLR_SALDO_INI"), 2)
			strSALDO1 = Replace(Replace(strSALDO1,".",""),",",".")
			
			'---------------------------------------------
			'Insere o saldo inicial
			'---------------------------------------------
			athDebug "<br>Inserindo saldo acumulado inicial para " & strMES & "/" & strANO & " com valor de " & strVALOR, False
			
			strSQL_local =                " INSERT INTO FIN_SALDO_AC (COD_CONTA, MES, ANO, VALOR, RECALCULADO, SYS_COD_USER_ULT_LCTO) "
			strSQL_local = strSQL_local & "	VALUES (" & strCOD_CONTA & ", " & strMES & ", " & strANO & ", " & strVALOR & ", -1, '" & SESSION("METRO_USER_ID_USER") & " (ajusta saldos)') "
			pr_objConn.Execute(strSQL_local)
			
			athDebug "<br>Inserindo outros saldos com zero até mês de hoje (" & DatePart("M", Date) & "/" & DatePart("YYYY", Date) & ")", False
			
			strDATA1 = DateAdd("M", 1, DateSerial(strANO, strMES, 1))
			strDATA2 = DateSerial(DatePart("YYYY", Date), DatePart("M", Date), 1)
			
			While (strDATA1 <= strDATA2)
				strSQL_local =                " INSERT INTO FIN_SALDO_AC (COD_CONTA, MES, ANO, VALOR, RECALCULADO, SYS_COD_USER_ULT_LCTO) "
				strSQL_local = strSQL_local & " VALUES (" & strCOD_CONTA & ", " & DatePart("M", strDATA1) & ", " & DatePart("YYYY", strDATA1) & ", 0, -1, '" & SESSION("METRO_USER_ID_USER") & " (ajusta saldos)') "
				
				strDATA1 = DateAdd("M", 1, strDATA1)
				
				pr_objConn.Execute(strSQL_local)
			WEnd
			
			'---------------------------------------------
			'Varre os lançamentos em conta
			'---------------------------------------------
			athDebug "<br>Varrendo lançamentos em conta:", False
			
			strSQL_local =                " SELECT OPERACAO, SUM(VLR_LCTO) AS VLR_TOTAL, Month(DT_LCTO) AS MES, Year(DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_EM_CONTA "
			strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
			strSQL_local = strSQL_local & " GROUP BY OPERACAO, Month(DT_LCTO), Year(DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(DT_LCTO), Month(DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strOPERACAO = GetValue(objRS2_local, "OPERACAO")
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				If strOPERACAO = "RECEITA" Then strOPERACAO = "+"
				If strOPERACAO = "DESPESA" Then strOPERACAO = "-"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Varre os lançamentos ordinários
			'---------------------------------------------
			athDebug "<br>Varrendo lançamentos ordinários de saída:", False
			
			strSQL_local =                " SELECT SUM(ORD.VLR_LCTO) AS VLR_TOTAL, Month(ORD.DT_LCTO) AS MES, Year(ORD.DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_ORDINARIO ORD "
			strSQL_local = strSQL_local & " INNER JOIN FIN_CONTA_PAGAR_RECEBER PR ON (ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER) "
			strSQL_local = strSQL_local & " WHERE PR.SYS_DT_CANCEL IS NULL AND ORD.SYS_DT_CANCEL IS NULL "
			strSQL_local = strSQL_local & " AND PR.PAGAR_RECEBER <> 0 AND ORD.COD_CONTA = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(ORD.DT_LCTO), Year(ORD.DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(ORD.DT_LCTO), Month(ORD.DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "-"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			athDebug "<br>Varrendo lançamentos ordinários de entrada:", False
			
			strSQL_local =                " SELECT SUM(ORD.VLR_LCTO) AS VLR_TOTAL, Month(ORD.DT_LCTO) AS MES, Year(ORD.DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_ORDINARIO ORD "
			strSQL_local = strSQL_local & " INNER JOIN FIN_CONTA_PAGAR_RECEBER PR ON (ORD.COD_CONTA_PAGAR_RECEBER = PR.COD_CONTA_PAGAR_RECEBER) "
			strSQL_local = strSQL_local & " WHERE PR.SYS_DT_CANCEL IS NULL AND ORD.SYS_DT_CANCEL IS NULL "
			strSQL_local = strSQL_local & " AND PR.PAGAR_RECEBER = 0 AND ORD.COD_CONTA = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(ORD.DT_LCTO), Year(ORD.DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(ORD.DT_LCTO), Month(ORD.DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "+"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Varre os lançamentos de transferência
			'---------------------------------------------
			athDebug "<br>Varrendo lançamentos de transferência de saída:", False
			
			strSQL_local =                " SELECT SUM(VLR_LCTO) AS VLR_TOTAL, Month(DT_LCTO) AS MES, Year(DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_TRANSF WHERE COD_CONTA_ORIG = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(DT_LCTO), Year(DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(DT_LCTO), Month(DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "-"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR 
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			athDebug "<br>Varrendo lançamentos de transferência de entrada:", False
			
			strSQL_local =                " SELECT SUM(VLR_LCTO) AS VLR_TOTAL, Month(DT_LCTO) AS MES, Year(DT_LCTO) AS ANO "
			strSQL_local = strSQL_local & " FROM FIN_LCTO_TRANSF WHERE COD_CONTA_DEST = " & strCOD_CONTA
			strSQL_local = strSQL_local & " GROUP BY Month(DT_LCTO), Year(DT_LCTO) "
			strSQL_local = strSQL_local & " ORDER BY Year(DT_LCTO), Month(DT_LCTO) "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VLR_TOTAL")
				strVALOR = FormatNumber(GetValue(objRS2_local, "VLR_TOTAL"), 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strOPERACAO = "+"
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Valor para " & strMES & "/" & strANO & " de " & strOPERACAO & strVALOR, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC " 
				strSQL_local = strSQL_local & " SET VALOR = VALOR " & strOPERACAO & strVALOR
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA 
				strSQL_local = strSQL_local & " AND MES = " & strMES 
				strSQL_local = strSQL_local & " AND ANO = " & strANO 
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Exibe os saldos acumulados
			'---------------------------------------------
			athDebug "<br><br>Exibindo acumulados:", False
			
			strSQL_local =                " SELECT VALOR, MES, ANO "
			strSQL_local = strSQL_local & " FROM FIN_SALDO_AC "
			strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA
			strSQL_local = strSQL_local & " ORDER BY ANO, MES "
			
			Set objRS2_local = pr_objConn.Execute(strSQL_local)
			
			strSALDO1 = 0
			Do While Not objRS2_local.Eof
				strMES = GetValue(objRS2_local, "MES")
				strANO = GetValue(objRS2_local, "ANO")
				strVALOR = GetValue(objRS2_local, "VALOR")
				
				strSALDO1 = strSALDO1 + CDbl(strVALOR)
				
				strVALOR = FormatNumber(strVALOR, 2)
				strVALOR = Replace(Replace(strVALOR,".",""),",",".")
				
				strSALDO2 = FormatNumber(strSALDO1, 2)
				strSALDO2 = Replace(Replace(strSALDO2,".",""),",",".")
				
				athDebug "<br>&nbsp;&nbsp;&nbsp;&nbsp;Acumulado parcial em " & strMES & "/" & strANO & " de " & strVALOR & ", atualizando para " & strSALDO2, False
				
				strSQL_local =                " UPDATE FIN_SALDO_AC "
				strSQL_local = strSQL_local & " SET VALOR = " & strSALDO2
				strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA
				strSQL_local = strSQL_local & " AND MES = " & strMES
				strSQL_local = strSQL_local & " AND ANO = " & strANO
				
				pr_objConn.Execute(strSQL_local)
				
				athMoveNext objRS2_local, Cont_local, 40
			Loop
			FechaRecordSet objRS2_local
			
			'---------------------------------------------
			'Atualiza o saldo da conta
			'---------------------------------------------
			strSALDO1 = FormatNumber(strSALDO1, 2)
			strSALDO1 = Replace(Replace(strSALDO1,".",""),",",".")
			
			athDebug "<br><br>Saldo total: " & strSALDO1, False
			
			strSQL_local =                " UPDATE FIN_CONTA "
			strSQL_local = strSQL_local & " SET VLR_SALDO = " & strSALDO1
			strSQL_local = strSQL_local & " WHERE COD_CONTA = " & strCOD_CONTA
			
			pr_objConn.Execute(strSQL_local)
			
			athMoveNext objRS1_local, Cont_local, 40
		Loop
		FechaRecordSet objRS1_local
End Sub


If Ucase(Session("METRO_USER_GRP_USER")) <> "ADMIN" Then 
   Mensagem "Você não esta autorizado a efetuar esta opera&ccedil;&atilde;o.<BR><BR>Usuário = " & Session("METRO_ID_USER") , "../default.asp","[ Voltar ]", 1  
Else	
%>

<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista">
<div class="grid fluid padding20">
		<%
          If strACAO = "RUN" Then
        %>
        
            <div class="padding20">
                <h1><i class="icon-warning fg-black on-right on-left"></i>AjustaSaldo</h1>
                <h2>Ajusta Saldo pVISTA </h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
                <hr>            
       <%  '---------------------------------------------------------------------------------
		   ' Faz ajuste das finanças: refaz os acumulados e atualiza saldo das contas
		   ' Segundo parâmetro é o código da conta, se não informado faz de todas as contas
		   '---------------------------------------------------------------------------------
		   AjustaFinanceiro objConn, ""
		%>
        <div align="center"><input class="primary" type="button" name="btHome" value="Home" onclick="document.location='mysql_database_run.asp';" /></div>
        <br />
       </div>
        <%
          Else
        %>
        <div class="padding20">
            <h1><i class="icon-warning fg-black on-right on-left"></i>AjustaSaldo</h1>
            <h2>Ajusta Saldo pVISTA </h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>            
            <hr>            
            <form name="form_insert" action="AjustaSaldos.asp" method="post">
			<input type="hidden" name="VAR_ACTION" value="RUN">
			<input type="hidden" name="DEFAULT_LOCATION" 	value='../modulo_PAINEL/principal.htm'>             
             	<span class="span8"><%=auxAVISO%></span>  
                <hr>            
                <div><input class="primary" type="submit" name="btRun" value="APLICAR" /></div>
            </form>
    
            <%
              End If
            %>
        </div>
</div>
</body>
</html>
<%

End If

Response.Flush
%>