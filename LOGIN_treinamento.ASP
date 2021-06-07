<%@ LANGUAGE=VBScript %>
<% Option Explicit %>
<%
'date in the past...
Response.AddHeader "Expires", "Mon, 26 Jul 1997 05:00:00 GMT"
'always modified
Response.AddHeader "Last-Modified", Now & " GMT"
'HTTP/1.1 
Response.AddHeader "Cache-Control", "no-cache, must-revalidate"
'HTTP/1.0 
Response.AddHeader "Pragma", "no-cache"
'last ditch attempt!
Response.Expires = -1
%>
<!--#include file="_scripts/scripts.js"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
 Dim objConn, objRS
 Dim strUserID, strSessionID, strSQL
 Dim iNOTICIA, iARTIGO, iDICA, iFAQ
 Dim arrScodi, arrSdesc
 Dim strCOD_EVENTO
 
 strCOD_EVENTO = Request("cod_evento")
' If strCOD_EVENTO = "" Then
 strCOD_EVENTO = Request.Cookies("sysMetro")("CODEVENTO")
' End If

 AbreDBConn objConn, CFG_DB_DADOS 
	
 ' ------------------------------------------------------------------------
 ' Monta consulta para localizar os dados do usuário informado             
 ' ------------------------------------------------------------------------
  strSQL = "SELECT ID_USER, GRP_USER, NOME, EMAIL, DT_INATIVO" & _
           "  FROM tbl_USUARIO" & _
           " WHERE ID_USER = '" & strUserID & "'"

  set objRS = objConn.execute(strSQL)

 ' ------------------------------------------------------------------------
 ' Busca dados relativos as informações do site no banco (athcsm.mdb) 
 ' para montagem na tela principal
 ' ------------------------------------------------------------------------
 MontaArrySiteInfo arrScodi, arrSdesc
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="_css/csm.css">

</head>

<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" 
      leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF"
	  onLoad="ATHSetFocus('formulario','userid')">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="70">&nbsp;&nbsp;&nbsp;<img src="img/SistemLogo_treinamento.gif"></td>
  </tr>
  <tr> 
    <td height="491" align="center" valign="middle"> 
      <table width="270" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="270" align="center" valign="middle">
		    <table width="68%" height="100%" border="1" cellspacing="0" cellpadding="0">
              <tr> 
                <td align="center" valign="top">
				  <table width="260" border="0" cellpadding="2" cellspacing="3" class="Tahomapreta10">
                    <tr> 
                      <td align="right">Servidor:</td>
                      <td><strong><%= Request.ServerVariables("SERVER_NAME") %></strong></td>
                    </tr>
                    <tr> 
                      <td align="right">Protocolo:</td>
                      <td><strong><%= Request.ServerVariables("SERVER_PROTOCOL") %> 
                        (<%=Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")%>)</strong></td>
                    </tr>
                    <tr> 
                      <td width="27%" align="right">Plataforma:</td>
                      <td><strong><%= Request.ServerVariables("SERVER_SOFTWARE")%></strong></td>
                    </tr>
                    <tr> 
                      <td align="right">Cliente:</td>
                      <td><strong><%=arrSdesc(ArrayIndexOf(arrScodi,"CLIENTE"))%></strong></td>
                    </tr>
                    <tr> 
                      <td align="right">IP Local:</td>
                      <td><strong><%= Request.ServerVariables("REMOTE_HOST") %></strong></td>
                    </tr>
                    <tr height="5"> 
                      <td height="5" colspan="2"></td>
                    </tr>
                    <tr bgcolor="#70A4BA" height="5"> 
                      <td height="5" colspan="2" bgcolor="#FF0000"><font color='#FFFFFF'> 
                        <%
						 if Request.Form("erro")="" then 
						   response.write "&nbsp;LOGIN:&nbsp;"
						 else
						   response.write "&nbsp;ERRO:&nbsp;<b>" & Request.Form("erro") & "</b>"
						 end if
						%>
                      </font> </tr>
                    <tr> 
                      <td colspan="2" align="center"><form method="post" action="login_verify.asp" name="formulario">
                          <table width="90%" border="0" cellpadding="2" cellspacing="3" class="Tahomapreta10">
                            <tr> 
                              <td align="right">Evento:</td>
                              <td colspan="2">
							  <select name="cod_evento" class="textbox180">
                                  <%
								 strSQL = "SELECT COD_EVENTO, NOME, DT_INICIO, DT_FIM FROM tbl_EVENTO WHERE SYS_INATIVO IS NULL"
								'Response.write(strSQL)
								'Response.End()
								 Set objRS = objConn.Execute(strSQL)
                                 Do While not objRS.EOF
                                   Response.Write "<option value=""" & objRS("COD_EVENTO") & """"
								   If Cstr(strCOD_EVENTO) = "" Then
								     If DateDiff("d",Date(),objRS("DT_INICIO")) <= 0  And DateDiff("d",Date(),objRS("DT_FIM")) >= 0 Then
								       strCOD_EVENTO = objRS("COD_EVENTO")
									 End If
								   End If
								   If Cstr(objRS("COD_EVENTO")) = Cstr(strCOD_EVENTO) Then
								     Response.Write(" selected")
								   End If
								   Response.Write ">" & objRS("NOME") & "</option>"
                                   objRS.MoveNext
                                 Loop
								 %>
                                </select>
								</td>
                            </tr>
                            <tr> 
                              <td align="right">UserID:</td>
                              <td colspan="2"><input type="text" name="userid" size="10" maxlength="20" class="textbox180"></td>
                            </tr>
                            <tr> 
                              <td align="right">Senha:</td>
                              <td colspan="2"><input type="password" name="senha" size="10" maxlength="20" class="textbox180"></td>
                            </tr>
                            <tr height="5"> 
                              <td bgcolor="#FF0000" height="5" colspan="3"></td>
                            </tr>
                            <tr> 
                              <td colspan="3" align="right"><a href="javascript:document.formulario.submit();"><img src="IMG/bt_ok.jpg" width="73" height="21" border="0"></a></td>
                            </tr>
                            <tr align="left"> 
                              <td colspan="3" class="Tahomacinza10"><p>* Seja 
                                  bem-vindo ao Sistema de credenciamento PROEVENTO. 
                                  Este sistema foi desenvolvido em parceria Athenas 
                                  Software &amp; Systems e BBSI. Todos os direitos 
                                  reservados.<br>
                                  * Se voc&ecirc; esqueceu sua senha <a href="javascript:AbreJanelaPAGE('solicitacao.asp','530','300');">clique 
                                  aqui</a><br>
                                </p></td>
                            </tr>
                          </table>
                          <input type="image" name="Submit" value="Enviar" src="img/transparent.gif" width="1" height="1">
                        </form></td>
                    </tr>
                  </table></td>
              </tr>
            </table></td>
        </tr>
      </table>
      </td>
  </tr>
  <tr>
    <td height="10" bgcolor="#3A88AD"></td>
  </tr>
</table>
</body>
</html>
<%
 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>