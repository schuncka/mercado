<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_database/athSendMail.asp"--> 
<%
Dim strCOD_EVENTO, strCodigoPromo
Dim objConn, objRS, strSQL,strProduto,strSQLDel, objRSProd
Dim strCodProd, strQuantidade,strCategoria, strSessionId

strCodProd     = Request("var_codigo_prod")
strQuantidade  = Request("var_quantidade")
strCategoria   = Request("var_categoria")
strCOD_EVENTO  = Request("cod_evento")


If strCOD_EVENTO = "" Then
  strCOD_EVENTO = request.Cookies("METRO_ProshopPF")("COD_EVENTO")
End If

'response.write("strCodEvento = "& strCOD_EVENTO)
'response.Write("<br>CodigoPromo = " & strCodigoPromo)

If strCodProd = "" and strCOD_EVENTO = "" Then
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
	  
		strSQL = "				SELECT tbl_PrcLista.COD_STATUS_PRECO "
		strSQL = strSQL & "			  , TBL_STATUS_PRECO.status "
		strSQL = strSQL & "			  , TBL_STATUS_PRECO.status_intl "
		strSQL = strSQL & "		  	  , tbl_Produtos.COD_PROD "
		strSQL = strSQL & "			  , tbl_Produtos.TITULO "
		strSQL = strSQL & "			  , tbl_Produtos.TITULO_INTL "
		strSQL = strSQL & "			  , tbl_Produtos.DESCRICAO "
		strSQL = strSQL & "			  , tbl_Produtos.DESCRICAO_INTL "
		strSQL = strSQL & "			  , tbl_Produtos.GRUPO "
		strSQL = strSQL & "			  , tbl_Produtos.GRUPO_INTL "
		strSQL = strSQL & "			  , tbl_Produtos.CAPACIDADE "
		strSQL = strSQL & "			  , tbl_Produtos.OCUPACAO "
		strSQL = strSQL & "			  , tbl_Produtos.grupo "
		strSQL = strSQL & "			  , (tbl_Produtos.CAPACIDADE - tbl_Produtos.OCUPACAO) AS VAGAS "
		strSQL = strSQL & "			  , tbl_PrcLista.PRC_LISTA "
		strSQL = strSQL & "		FROM tbl_Produtos INNER JOIN tbl_PrcLista ON tbl_Produtos.COD_PROD = tbl_PrcLista.COD_PROD "
		strSQL = strSQL & "		                       AND now() BETWEEN tbl_PrcLista.DT_VIGENCIA_INIC AND tbl_PrcLista.DT_VIGENCIA_FIM "
		strSQL = strSQL & "							   AND 1 BETWEEN tbl_PrcLista.QTDE_INIC AND tbl_PrcLista.QTDE_FIM "
		strSQL = strSQL & "						  INNER JOIN TBL_STATUS_PRECO ON TBL_STATUS_PRECO.COD_STATUS_PRECO = tbl_PrcLista.COD_STATUS_PRECO "
		strSQL = strSQL & "		WHERE tbl_Produtos.LOJA_SHOW = 1 "
		strSQL = strSQL & "		  AND tbl_status_preco.loja_show = 1 "
		strSQL = strSQL & "		  AND tbl_Produtos.cod_prod = " & strCodProd
		strSQL = strSQL & "		  AND tbl_Produtos.COD_EVENTO =  "& strCOD_EVENTO 
				if strCategoria <> "0" Then
		strSQL = strSQL & "       AND tbl_PrcLista.cod_status_preco = " & strCategoria
				end if				
		
  ''   response.write(strSQL)
	  
	  Set objRS = objConn.Execute(strSQL) 
	 If not objRS.EOF  Then
			if strQuantidade = "0" then
				strSQL = "delete from tbl_inscricao_produto_session where id_session = "&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")& " and cod_prod = " & strCodProd				
			else
			'strSQL = "insert into tbl_inscricao_produto_session(id_session          , cod_prod             ,        qtde       ,          vlr_pago       ,       vlr_original       ,    complemento            ) "
			'strSQL = strSQL & "		 values                   ("&session.SessionID&", "&objRS("cod_prod")&","&strQuantidade & ","& objRS("prc_lista") & "," & objRS("prc_lista") & "," & objRS("complemento")& ")"
				strSQL = "select cod_prod from tbl_produtos where cod_evento = " & strCOD_EVENTO & " and cod_prod not in(" & strCodProd & ")"
				strSQL = strSQL & "		and tbl_Produtos.LOJA_SHOW = 1 "
				strSQL =strSQL & "		and dt_ocorrencia in(select dt_ocorrencia from tbl_produtos where cod_evento = "&strCOD_EVENTO&" and cod_prod = "&strCodProd&");"
response.write(strSQL)
				Set objRSProd = objConn.Execute(strSQL) 

				strProduto = ""
					Do while not objRSProd.EOF 
						strSQLDel = "delete from tbl_inscricao_produto_session where id_session = "&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")& " and cod_prod = " & getValue(objRSProd,"cod_prod") & " AND cod_evento = " & strCOD_EVENTO & ";"
						objConn.Execute(strSQLDel)
						strProduto =  getValue(objRSProd,"cod_prod")& "|" &strProduto
						objRSProd.movenext
					loop
					if strProduto <> "" then
						response.write(strProduto)
					end if

					
				strSQL = "delete from tbl_inscricao_produto_session where id_session = "&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")& " and cod_prod = " & strCodProd & " AND cod_evento = " & strCOD_EVENTO & ";"
				objConn.Execute(strSQL)	
				strSQL =  "insert into tbl_inscricao_produto_session(    id_session                                                          , cod_evento          , cod_prod                ,        qtde         ,          vlr_pago        ,       vlr_original       , sys_dtt_ins) "
				strSQL = strSQL & "		 values                   (" & request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId") & "," & strCOD_EVENTO & "," & objRS("cod_prod") & "," & strQuantidade & "," & objRS("prc_lista") & "," & objRS("prc_lista") & ", current_timestamp)"
			end if
			objConn.Execute(strSQL)
	  	    response.write(strSQL)
	 Else 
		'  response.Write("err|Senha Invalida| | | ")
	 End If
	 ' FechaRecordSet objRS
	else
	'response.Write("invalida")
	End If
	
	FechaDBConn objConn	  

End If
%>