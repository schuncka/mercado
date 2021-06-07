<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<!--#include file="../_database/ADOVBS.INC"-->
<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--include file="../_database/athUtils.asp"-->
<%
 Response.CacheControl = "no-cache"
 Response.AddHeader "Pragma","no-cache"
 Response.Expires = -1

 Dim objConn, objRS, strSQL 
 Dim i, j, strBgColor
 Dim strMODULO, strTABLE 

 AbreDBConn objConn, CFG_DB_DADOS 

 strMODULO = GetParam("var_modulo")
 strTABLE  = GetParam("var_table")
 
 strSQL = "SELECT COD_FIELD, MODULO, TABELA, CAMPO, TAMANHO, ORDENACAO, ORDEM, DT_INATIVO FROM SYS_FIELDS_QUERY " & _ 
          " WHERE MODULO='" & strMODULO & "' AND TABELA='" & strTABLE & "' ORDER BY ORDEM"

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
 if not objRS.EOF then
%>
<html>
<head>
<title></title>
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body topmargin="0" leftmargin="0" bgcolor="#FFFFFF" marginwidth="0" marginheight="0">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 <tr> 
  <td colspan="2" align="center"><BR> 
   <table width="95%" border="0" cellpadding="2" cellspacing="0" bgcolor='#FFFFFF'>
     <tr> 
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo" align="left">Módulo</td>
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo" align="left">Tabela</td>
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo" align="left">Campo</td>
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo" align="left">Tamanho</td>
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo" align="left">Ordem</td>
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo" align="left">"Sort"</td>
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo" align="left"></td>
		 <td bgcolor="<%=CFG_CORBAR_TOP%>" class="texto_contraste_mdo"></td>
     </tr> 
     <% 
       i = 0
	   While Not objRS.EOF  
	 %>
	 <form name="FormUpdateAuto<%=i%>" action="../_database/athUpdateToDB.asp" method="POST">
  	 <input type="hidden" name="DEFAULT_DB"       value="<%=CFG_DB_DADOS%>">
  	 <input type="hidden" name="DEFAULT_TABLE"    value="SYS_FIELDS_QUERY">
     <input type="hidden" name="FIELD_PREFIX"     value="DBVAR_">
  	 <input type="hidden" name="RECORD_KEY_NAME"  value="COD_FIELD">
  	 <input type="hidden" name="RECORD_KEY_VALUE" value="<%=GetValue(objRS,"COD_FIELD")%>">
	 <input type="hidden" name="RECORD_KEY_TYPE"  value="NUM">
  	 <input type="hidden" name="DEFAULT_LOCATION" value="ConfigTableViews.asp?var_modulo=<%=strMODULO%>&var_table=<%=strTABLE%>">
     <tr> 
	   <td class="texto_copro_mdo" align="left"><%=GetValue(objRS,"MODULO")%></td>
	   <td class="texto_copro_mdo" align="left"><%=GetValue(objRS,"TABELA")%></td>
	   <td class="texto_copro_mdo" align="left"><%=GetValue(objRS,"CAMPO")%></td>
	   <td class="texto_copro_mdo" align="left"><input if="DBVAR_NUM_TAMANHO" name="DBVAR_NUM_TAMANHO" size="3" maxlength="3" type="text" value="<%=GetValue(objRS,"TAMANHO")%>"></td>
	   <td class="texto_copro_mdo" align="left"><input id="DBVAR_NUM_ORDEM"   name="DBVAR_NUM_ORDEM"   size="3" maxlength="3" type="text" value="<%=GetValue(objRS,"ORDEM")%>"></td>
	   <td class="texto_copro_mdo" align="left">
	   <select id="DBVAR_STR_ORDENACAO" name="DBVAR_STR_ORDENACAO">
	     <option id="ASC" <%if GetValue(objRS,"ORDENACAO")="ASC" then response.write "selected"%>>ASC</option>
	     <option id="DESC" <%if GetValue(objRS,"ORDENACAO")="DESC" then response.write "selected"%>>DESC</option>
	   </select>
	   </td>
	   <td class="texto_copro_mdo" align="left" nowrap>
	   <%
           If GetValue(objRS,"DT_INATIVO")="" Then
            Response.Write("<input type='radio' class='texto_copro_mdo' name='DBVAR_DATE_DT_INATIVO' value='NULL' checked>Ativo")
            Response.Write("<input type='radio' class='texto_copro_mdo' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "'>Inativo")
           Else
            Response.Write("<input type='radio' class='texto_copro_mdo' name='DBVAR_DATE_DT_INATIVO' value='NULL'>Ativo")
            Response.Write("<input type='radio' class='texto_copro_mdo' name='DBVAR_DATE_DT_INATIVO' value='" & Date() & "' checked>Inativo")
          End If
       %>	   
	   </td>
	   <td class='texto_copro_mdo' align='left'><input type="submit" value="salvar"></td>
     </tr> 
     </form>
    <% 
       i = i + 1
	   objRS.movenext
	  wend 
	%>
   </table><BR>
  </td>
 </tr>
</table>
</body>
</html>
<%
 end if

 FechaRecordSet ObjRS
 FechaDBConn ObjConn
%>