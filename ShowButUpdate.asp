<%@ LANGUAGE=VBScript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="_scripts/scripts.js"-->
<!--#include file="_database/config.inc"-->
<!--#include file="_database/athDbConn.asp"-->
<!--#include file="_database/athUtils.asp"-->
<%
  Dim strCHAVE

  strCHAVE = UCase(Replace(Request("var_chave"),"'","''"))
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="_css/csm.css">
</head>
<body text="#916E28" link="#916E28" vlink="#916E28" alink="#916E28" 
      leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#FFFFFF">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td height="80" background="img/BGTopMenuFalse.jpg"><img src="img/FalseMenu.jpg" width="162" height="80"></td>
  </tr>
  <tr> 
    <td align="center" valign="middle"><BR>
      <table width="270" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="270"><img src="img/header_info.gif" width="270" height="19"></td>
        </tr>
        <tr> 
          <td align="center" valign="middle"><table width="68%" height="100%" border="1" cellspacing="0" cellpadding="0">
              <tr> 
                <td align="center" valign="top"><table width="260" border="0" cellpadding="2" cellspacing="3" class="Tahomapreta10">
                    <tr bgcolor="#70A4BA" height="5"> 
                      <td height="5"><font color='#FFFFFF'>&nbsp; </font> </tr>
                    <tr> 
                      <td align="center">
					      <%
						  If (strCHAVE = "RUNUPDATE") Then 
						  %>
  						    <form method="post" action="ExecButUpdate.asp" name="formulario">
						  <% 
						  Else
						  %>
						    <form method="post" action="" name="formulario">
						  <%
						  End If
						  %>
                          <table width="90%" border="0" cellpadding="2" cellspacing="3" class="Tahomapreta10">
                            <tr> 
                              <td width="13" align="right"></td>
                              <td width="195" colspan="2" align="right"></td>
                            </tr>
                            <tr> 
							  <td width="13" align="right"></td>
                              <td colspan="2" align="right">Para efetuar atualiza&ccedil;&atilde;o 
                                da ocupa&ccedil;&atilde;o clique no bot&atilde;o 
                                abaixo:</td>
                            </tr>
                            <tr height="5"> 
                              <td bgcolor="#70A4BA" height="5" colspan="3"></td>
                            </tr>
                            <tr> 
                              <td align="left">&nbsp;</td>
                              <td colspan="3" align="right">
							    <%
   						        If strCHAVE = "RUNUPDATE" Then 
						        %>
                                   <a href="javascript:document.formulario.submit();">
                                   <img src="IMG/bt_ok.jpg" width="73" height="21" border="0"></a>
  						        <% 
						        Else
						        %>
                                   <img src="IMG/bt_ok_disabled.jpg" width="73" height="21" border="0">
						        <%
						        End If
						        %>
                                </td>
                            </tr>
                            <tr align="left"> 
                              <td colspan="3" class="Tahomacinza10"><p> <br>
                                  <br>
                                  <br>
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
        <tr> 
          <td width="270" valign="top"><img src="img/footer_info.gif" width="270" height="15"></td>
        </tr>
      </table>
      </td>
  </tr>
  <tr>
    <td height="10" background="img/BGFooter.jpg"></td>
  </tr>
</table>
</body>
</html>
