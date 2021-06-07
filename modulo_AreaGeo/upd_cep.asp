<%

strCOD = Request("var_chavereg")

  strSQL = "SELECT tbl_areageo_cep.id_AreaGeo_cep, tbl_areageo_cep.Cep_Ini, tbl_areageo_cep.Cep_Fim, tbl_areageo_cep.ID_PAIS, ID_AreaGeo_Cep "&_
		   " FROM  tbl_areageo_cep  WHERE  tbl_areageo_cep.id_AreaGeo_cep="&strCOD
Set objRS3 = objConn.Execute(strSQL) 
%>
<form name="formCep_<%=objRS("Id_areageo")%>" action="updateexec.asp" method="POST">
<input type="hidden" name="var_id_areageo" value="<%=objRS("Id_areageo")%>">
<input type="hidden" name="var_id_areageo_cep" value="<%=objRS3("Id_areageo_cep")%>">
<input type="hidden" name="var_acao" <%If strACAO ="" Then%>value="CEP"<%Else%>value="INS"<%End If%>>
  <table width="500" height="4" border="0" align="center" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="4" height="4"><img src="../img/inbox_left_top_corner.gif" width="4" height="4"></td>
      <td width="492" height="4"><img src="../img/inbox_top_blue.gif" width="492" height="4"></td>
      <td width="4" height="4"><img src="../img/inbox_right_top_corner.gif" width="4" height="4"></td>
    </tr>
  </table>
  <table width="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#000000">
    <tr> 
      <td width="4" background="../img/inbox_left_blue.gif">&nbsp;</td>
      <td width="492"><table width="492" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="arial12">
          <tr> 
                  <td bgcolor="#7DACC5">&nbsp;Altera&ccedil;&atilde;o de area de CEP </td>
          </tr>
          <tr> 
            <td height="16" align="center">&nbsp;</td>
          </tr>
          <tr> 
            <td align="center">
			  <table width="480" border="0" cellpadding="0" cellspacing="0" class="arial11">
                 <tr> 
                   <td width="100" align="right">*CEP Inicial:&nbsp;</td>
                   <td width="350" align="left"><input name="var_Cep_Inicial" maxlength="9" value="<%=objRS3("Cep_Ini")%>" type="text" class="textbox70">&nbsp;&nbsp;*CEP Final:&nbsp;<input name="var_Cep_Final" value="<%=objRS3("Cep_Fim")%>" type="text" class="textbox70" maxlength="9"></td>
                 </tr>
                 <tr> 
                	 <td width="100" align="right">*Pa&iacute;s:&nbsp;</td>
                     		
							<%
							
						  	strSQL =  " SELECT PAIS, ID_PAIS FROM tbl_PAIS ORDER BY PAIS"
						  	Set objRS2 = objConn.Execute(strSQL)
					
							%>
					 
					 <td width="350" align="left"> 
                    	 <select name="var_pais" class="textbox180">
							<option value="">Selecione...</option>
							<%
							While Not objRS2.EOF
							%>
							<option value="<%=objRS2("ID_PAIS")%>" <%If objRS2("Id_Pais") = objRS3("Id_Pais") Then%> selected="selected"<%end If%>><%=objRS2("PAIS")%></option>
							<%
								objRS2.Movenext()
							Wend
							%>
						  </select>					</td>
              </tr>
              </table>
			  </td>
          </tr>
          <tr> 
            <td>&nbsp;</td>
          </tr>
        </table></td>
      <td width="4" background="../img/inbox_right_blue.gif">&nbsp;</td>
    </tr>
  </table>
  <table width="500" align="center" cellpadding="0" cellspacing="0" border="0">
    <tr> 
      <td width="4"   height="4" background="../img/inbox_left_bottom_corner.gif">&nbsp;</td>
      <td height="4" width="235" background="../img/inbox_bottom_blue.gif"><img src="../img/blank.gif" alt="" border="0" width="1" height="32"></td>
      <td width="21"  height="26"><img src="../img/inbox_bottom_triangle3.gif" alt="" width="26" height="32" border="0"></td>
      <td align="right" background="../img/inbox_bottom_big3.gif"><a href="javascript:formCep.submit();"><img src="../img/bt_save.gif" width="78" height="17" border="0"></a><a href="javascript:forminsert.reset();"><img src="../img/bt_clear.gif" width="78" height="17" hspace="10" border="0"></a><img src="../img/t.gif" width="3" height="3"><br></td>
      <td width="4"   height="4"><img src="../img/inbox_right_bottom_corner4.gif" alt="" width="4" height="32" border="0"></td>
    </tr>
  </table>
</form>

