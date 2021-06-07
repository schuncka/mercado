<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%

'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, objRSAux, objRSCheckEmp, objRSCheckInsc, objRSCheckCred,objRSCalcEmp, objRSCalcInsc, objRSCalcCred
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult, strFlagInsEmpresas, strFlagInsInscricao, strFlagInsCredencial
 'Relativas a Paginação	
 Dim  strQuantFreeEmp, strQuantFreeInsc, strQuantFreeCred, strEMPRESA_RANGE_LIMITE, strCREDENCIAL_RANGE_LIMITE

AbreDBConn objConn, CFG_DB

strSQL = " SELECT COD_USUARIO, ID_USER, START_GEN_ID, START_INSC_ID, START_CREDEXP_ID, LAST_GEN_ID, LAST_INSC_ID, LAST_CREDEXP_ID, NOME FROM TBL_USUARIO ORDER BY NOME, ID_USER"
Set objRS = objConn.execute(strSQL)
%>
<html>
<head>
	<title>Proevento Vista -  Teste de range por usuário</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body class="metro">
<div class="grid fluid">
	<div class="padding20">
            <h1><i class="icon-database fg-black on-right on-left"></i>Testa Range</h1>
            <h2>Exibir Ranges Livres</h2><span class="tertiary-text-secondary">(login on <%=CFG_DB%>)</span>
     <hr>         
	<div class="padding20" style="border:1px solid #999; width:100%; height:400px; overflow:scroll; overflow-x:hidden;">
	<style> .indent { height: 50px; }</style>
            <table class="tablesort table striped hovered">
                <thead>
                    <tr>
                        <th width="8%"  class="sortable-numeric">ID Usuário</th>
                        <th width="15%" class="sortable">Nome</th>
                        <th width="25%" class="sortable">Empresas</th>
                        <th width="25%" class="sortable">Credencial</th>
                        <th width="25%" class="sortable-numeric">Inscrição</th>
                    </tr>
                </thead> 
             <tbody>   
            <%
            While Not objRS.EOF
            
                strEMPRESA_RANGE_LIMITE = ""
                strCREDENCIAL_RANGE_LIMITE = ""
                
                If Not IsNull(objRS("LAST_GEN_ID")) And objRS("LAST_GEN_ID") <> 0 Then
                    strSQL = " SELECT COD_EMPRESA FROM TBL_EMPRESAS WHERE COD_EMPRESA = " & objRS("LAST_GEN_ID") & " + 1 "
                    Set objRSCheckEmp = objConn.execute(strSQL)
                    
                    If objRSCheckEmp.EOF Then
                         strFlagInsEmpresas = "<span class=""green"">sim</span>"
                         
                        strSQL = "SELECT COD_EMPRESA FROM TBL_EMPRESAS WHERE COD_EMPRESA >= '" & objRS("LAST_GEN_ID") & "' ORDER BY COD_EMPRESA LIMIT 1 "
                        Set objRSCalcEmp = objConn.execute(strSQL)
                        
                        If not objRSCalcEmp.EOF Then
                          strQuantFreeEmp = clng(objRSCalcEmp("COD_EMPRESA")) - clng(objRS("LAST_GEN_ID"))
                          If strQuantFreeEmp < 0 Then strQuantFreeEmp = 0
                        End If
                        
                        FechaRecordSet(objRSCalcEmp)
            
                        strSQL = "SELECT START_GEN_ID, ID_USER FROM TBL_USUARIO WHERE START_GEN_ID > " & objRS("LAST_GEN_ID") & " ORDER BY START_GEN_ID  LIMIT 1"
                        'strEMPRESA_RANGE_LIMITE = strSQL
                        Set objRSAux = objConn.execute(strSQL)
                        If not objRSAux.EOF Then
                          strEMPRESA_RANGE_LIMITE = strEMPRESA_RANGE_LIMITE & objRSAux("ID_USER") & ": "& objRSAux("START_GEN_ID")
                        End If
                        FechaRecordSet objRSAux
                        
                        
                    Else
                        strFlagInsEmpresas = "<span class=""fg-red"">não</span>"
                    End if
                    FechaRecordSet(objRSCheckEmp)
                Else 
                    strFlagInsEmpresas = "<span class=""fg-red"">não</span>"
                End If
                '-----------------------------------------------------------------------------------------------------------------------------------
                If Not IsNull(objRS("LAST_INSC_ID")) And objRS("LAST_INSC_ID") <> 0 Then
                    strSQL = " SELECT COD_INSCRICAO FROM TBL_INSCRICAO WHERE COD_INSCRICAO = " & objRS("LAST_INSC_ID") & " + 1 "
                    Set objRSCheckInsc = objConn.execute(strSQL)
                    
                    If objRSCheckInsc.EOF Then 
                        strFlagInsInscricao = "<span class=""fg-green"">sim</span>"
                        
                        strSQL = "SELECT COD_INSCRICAO FROM TBL_INSCRICAO WHERE COD_INSCRICAO > " & objRS("LAST_INSC_ID") & " ORDER BY COD_INSCRICAO  LIMIT 1"
                        Set objRSCalcInsc = objConn.execute(strSQL)
                        
                        If Not objRSCalcInsc.EOF Then
                            strQuantFreeInsc = objRSCalcInsc("COD_INSCRICAO") - objRS("LAST_INSC_ID")
                            If strQuantFreeInsc < 0 Then strQuantFreeInsc = 0
                        Else
                             strQuantFreeInsc = 0
                        End If
                        
                        FechaRecordSet(objRSCalcInsc)
                    Else
                        strFlagInsInscricao = "<span class=""fg-red"">não</span>"
                    End If
                    FechaRecordSet(objRSCheckInsc)
                Else 
                    strFlagInsInscricao = "<span class=""fg-red"">não</span>"
                End If
                '-----------------------------------------------------------------------------------------------------------------------------------
                If Not IsNull(objRS("LAST_CREDEXP_ID")) And objRS("LAST_CREDEXP_ID") <> 0 Then
                    'strSQL = " SELECT COD_CREDENCIAL FROM TBL_CREDENCIAL WHERE COD_CREDENCIAL = " & objRS("LAST_CREDEXP_ID") & " + 1 "
                    ' Somando 800000001 para testar com o range da CREDFAST
                    strSQL = " SELECT CREDENCIAL FROM TBL_CREDENCIAL WHERE CREDENCIAL = " & objRS("LAST_CREDEXP_ID") & " + 800000001 "
                    Set objRSCheckCred = objConn.execute(strSQL)
                    
                    If objRSCheckCred.EOF Then 
                        strFlagInsCredencial = "<span class=""fg-green"">sim</span>"
                        
                        'strSQL = "SELECT TOP 1 COD_CREDENCIAL FROM TBL_CREDENCIAL WHERE COD_CREDENCIAL > " & objRS("LAST_CREDEXP_ID") & " ORDER BY COD_CREDENCIAL "
                        strSQL = "SELECT CREDENCIAL FROM TBL_CREDENCIAL WHERE CREDENCIAL > 800000000 + " & objRS("LAST_CREDEXP_ID") & " ORDER BY CREDENCIAL  LIMIT 1"
                        Set objRSCalcCred = objConn.execute(strSQL)
                        
                        If Not objRSCalcCred.EOF Then
                            If Len(objRSCalcCred("CREDENCIAL")&"") = 9 And Left(objRSCalcCred("CREDENCIAL")&"",3) = "800" Then
                              strQuantFreeCred = objRSCalcCred("CREDENCIAL") - objRS("LAST_CREDEXP_ID")
                            Else
                              strQuantFreeCred = objRSCalcCred("CREDENCIAL") - objRS("LAST_CREDEXP_ID")
                            End If
                            If strQuantFreeCred < 0 Then strQuantFreeCred = 0
                            
                            strSQL = "SELECT START_CREDEXP_ID, ID_USER FROM TBL_USUARIO WHERE START_CREDEXP_ID > " & objRS("LAST_CREDEXP_ID") & " ORDER BY START_CREDEXP_ID  LIMIT 1"
                            'strCREDENCIAL_RANGE_LIMITE = strSQL
                            Set objRSAux = objConn.execute(strSQL)
                            If not objRSAux.EOF Then
                              strCREDENCIAL_RANGE_LIMITE = strCREDENCIAL_RANGE_LIMITE & objRSAux("ID_USER") & ": "& objRSAux("START_CREDEXP_ID")
                              
                              strQuantFreeCred = objRSAux("START_CREDEXP_ID") - objRS("LAST_CREDEXP_ID")
                            End If
                            FechaRecordSet objRSAux
                        
                        Else
                             strQuantFreeCred = 0
                        End If
                        
                        FechaRecordSet(objRSCalcCred)
                    Else 
                        strFlagInsCredencial = "<span class=""fg-red"">não</span>"
                    End If
                    FechaRecordSet(objRSCheckCred)
                Else 
                    strFlagInsCredencial = "<span class=""fg-red"">não</span>"
                End If
            %>	
            <tr>
                <td align="center"><b><%= objRS("ID_USER") %></b></td>
                <td><b><%= objRS("NOME") %></b></td>
              <td align="center" valign="top">
                  <%= strFlagInsEmpresas %>
                  <br>
                  <table width="100%" class="tablesort">
                    <tr>
                      <td width="34%" align="right">Start:</td>
                      <td width="66%" align="right"><b><%=objRS("START_GEN_ID")%></b></td>
                    </tr>
                    <tr>
                      <td align="right">Last:</td>
                      <td align="right"><b><%=objRS("LAST_GEN_ID")%></b></td>
                    </tr>
                    <tr>
                      <td colspan="2" align="right"><b><%=strEMPRESA_RANGE_LIMITE%></b></td>
                    </tr>
                    <tr>
                      <td align="right">Disp:</td>
                      <td align="right"><b><font color="#000099"><%= strQuantFreeEmp %></font></b></td>
                    </tr>
                  </table>
              </td>
              <td align="center" valign="top">
                  <%= strFlagInsCredencial %>
                  <br>
                <table width="100%" class="tablesort">
                    <tr>
                      <td width="34%" align="right">Start:</td>
                      <td width="66%" align="right"><b><%=objRS("START_CREDEXP_ID")%></b></td>
                    </tr>
                    <tr>
                      <td align="right">Last:</td>
                      <td align="right"><b><%=objRS("LAST_CREDEXP_ID")%></b></td>
                    </tr>
                    <tr>
                      <td colspan="2" align="right"><b><%=strCREDENCIAL_RANGE_LIMITE%></b></td>
                    </tr>
                    <tr>
                      <td align="right">Disp:</td>
                      <td align="right"><b><font color="#000099"><%= strQuantFreeCred %></font></b></td>
                    </tr>
                  </table>
              </td>
              <td align="center" valign="top">
                  <%= strFlagInsInscricao %>
                  <br>
                <table width="100%" class="tablesort">
                    <tr>
                      <td width="34%" align="right">Start:</td>
                      <td width="66%" align="right"><b><%=objRS("START_INSC_ID")%></b></td>
                    </tr>
                    <tr>
                      <td align="right">Last:</td>
                      <td align="right"><b><%=objRS("LAST_INSC_ID")%></b></td>
                    </tr>
                    <tr>
                      <td align="right">Disp:</td>
                      <td align="right"><b><font color="#000099"><%= strQuantFreeInsc %></font></b></td>
                    </tr>
                  </table>
              </td>
            </tr>
			<%	
                strQuantFreeEmp = 0
                strQuantFreeInsc = 0
                strQuantFreeCred = 0
                objRS.MoveNext
            Wend
            %>
            <tfoot>
                <tr>
                    <td colspan="5">&nbsp;</td>
                <tr>
            <tfoot>
            </table> 
            </div>        
		</div>
	</div>
 </body>
</html>
<%
	FechaRecordSet(objRS)
	FechaDBConn(objConn)
%>
