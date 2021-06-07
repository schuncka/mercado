<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_database/athSendMail.asp"--> 
<%
Dim strCOD_EVENTO, strCodigoPromo
Dim objConn, objRS, strSQL

strCodigoPromo = Request("var_codigo_promo")
strCOD_EVENTO = Request("cod_evento")
'response.write(strCodigoPromo)
If strCOD_EVENTO = "" Then
  strCOD_EVENTO = Session("COD_EVENTO")
End If

'response.write("strCodEvento = "& strCOD_EVENTO)
'response.Write("<br>CodigoPromo = " & strCodigoPromo)

If strCodigoPromo = "" and strCOD_EVENTO = "" Then
%>
<form name="formwebservice" action="valida_codigo_promo.asp" method="post" > 
  CODIGO PROMO: <input type="text" name="var_codigo_promo" value=""  />
 <br /> EVENTO: <input type="text" name="cod_evento" value="" />
  <input type="submit" name="butsend" id="butsend" value="Pesquisar">
</form>
<%
Else

	
	
    AbreDBConn objConn, CFG_DB_DADOS

	If strCOD_EVENTO <> "" Then
	  
	 ' strSQL = "select codigo, cod_inscricao, cod_status_preco from tbl_senha_promo " 
	 ' strSQL = strSQL & " where cod_evento = " & strCOD_EVENTO 
	 ' strSQL = strSQL & "   AND codigo = '" & strCodigoPromo & "'"
	  
	  strSQL =          "  SELECT	                                                 "
 	  strSQL = strSQL & "   S.CODIGO                                                 "
 	  strSQL = strSQL & " , S.DT_VALIDADE                                            "
 	  strSQL = strSQL & " , S.COD_INSCRICAO                                          "
 	  strSQL = strSQL & " , S.COD_STATUS_PRECO                                       "
 	  strSQL = strSQL & " , sp.COD_PROD                                              "
 	  strSQL = strSQL & " , sp.DESCONTO                                              "
 	  strSQL = strSQL & " , sp.VLR_FIXO                                              "
 	  strSQL = strSQL & " FROM tbl_senha_promo S                                     "
 	  strSQL = strSQL & " left join tbl_senha_promo_prod SP on sp.codigo = s.codigo	 "
 	  strSQL = strSQL & " WHERE s.cod_evento = " & strCOD_EVENTO
 	  strSQL = strSQL & " AND S.CODIGO LIKE '" & strCodigoPromo & "'                 "

	  
	  
	 ' response.write(strSQL)
	  Set objRS = objConn.Execute(strSQL)
	  If not objRS.EOF  Then
			if ( objRS("dt_validade") <= now() ) AND ( objRS("dt_validade")<>"" )Then
				response.write("Senha Expirada")
			Else if objRS("cod_inscricao")&"" <>"" AND objRS("cod_inscricao") <> "-1" Then
						response.write("err|Codigo utilizado| | | ")
				 else 
						if objRS("cod_status_preco") <> "" Then
							response.Write(objRS("cod_status_preco")&"|"&objRS("cod_prod")&"|"&objRS("desconto")&"|"&objRS("vlr_fixo")&"|ok")
						else
							response.Write("0|"&objRS("cod_prod")&"|"&objRS("desconto")&"|"&objRS("vlr_fixo")&"|ok")
						end if
				 end if	  			  	  		
			End If	
	  Else 
		  response.Write("err|Senha Invalida| | | ")
	  End If
	  FechaRecordSet objRS
	'else
	'response.Write("invalida")
	End If
	
FechaDBConn objConn	  

End If
%>