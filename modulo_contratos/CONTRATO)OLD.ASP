<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|view|", BuscaDireitosFromDB("modulo_clientes",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"                          ' - Default do Modulo...
 Const LTB = "TBL_CONTRATO"	                ' - Nome da Tabela...
 Const DKN = "COD_TBL_CONTRATO"                         ' - Campo chave...
 Const DLD = "../modulo_contratos/default.asp" ' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Contratos"                         ' - Carrega o titulo do modulo



 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 Dim strCOD_SERV, strGRUPO, strTITULO, strCOD_EVENTO,strLOJA,strSWFILTRO, strContatoCodStatusCred
 Dim strCOD_CONTRATO, strIDCONTRATO, strNOMEC, strNOMEV, strDATA, strTipoImpressao, strTipoCV
 Dim strLogo
'Antes de abir o banco já carrega as variaveis 

 strCOD_CONTRATO    = Replace(GetParam("var_chavereg"),"'","''")
 strTipoImpressao    = Replace(GetParam("var_tipo"),"'","''")

if instr(strTipoImpressao,"m_") Then
	strLogo = "logoMercado.png"
else 
	strLogo = "logoSulgrain.png"
end if
 
'--------------------------------------------------------------------------------------------------------------
 

'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------




strSQL = "SELECT tbl_contrato.idcontrato, "             
strSQL = strSQL & "        tbl_produtos.produto,"
strSQL = strSQL & "        tbl_produtos_2.subproduto,"
strSQL = strSQL & "        tbl_contrato.data,"
strSQL = strSQL & "        tbl_contrato.comprador,"
strSQL = strSQL & "        tbl_contrato.nomec,"
strSQL = strSQL & "        tbl_contrato.enderecoc,"
strSQL = strSQL & "        tbl_contrato.bairroc,"
strSQL = strSQL & "        tbl_contrato.cidadec,"
strSQL = strSQL & "        tbl_contrato.estadoc,"
strSQL = strSQL & "        tbl_contrato.cepc,"
strSQL = strSQL & "        tbl_contrato.cgccpfc,"
strSQL = strSQL & "        tbl_contrato.iergc,"
strSQL = strSQL & "        tbl_contrato.vendedor,"
strSQL = strSQL & "        tbl_contrato.nomev,"
strSQL = strSQL & "        tbl_contrato.enderecov,"
strSQL = strSQL & "        tbl_contrato.bairrov,"
strSQL = strSQL & "        tbl_contrato.cidadev,"
strSQL = strSQL & "        tbl_contrato.estadov,"
strSQL = strSQL & "        tbl_contrato.cepv,"
strSQL = strSQL & "        tbl_contrato.cgccpfv,"
strSQL = strSQL & "        tbl_contrato.iergv," 
strSQL = strSQL & "        tbl_contrato.tributo1,"
strSQL = strSQL & "        tbl_contrato.tributo2,"
strSQL = strSQL & "        tbl_contrato.rend_min,"
strSQL = strSQL & "        tbl_contrato.umidmax,"
strSQL = strSQL & "        tbl_contrato.impmax,"
strSQL = strSQL & "        tbl_contrato.ph,"
strSQL = strSQL & "        tbl_contrato.tipo,"
strSQL = strSQL & "        tbl_contrato.variedade,"
strSQL = strSQL & "        tbl_contrato.unidade,"
strSQL = strSQL & "        tbl_contrato.quantidade,"
strSQL = strSQL & "        tbl_contrato.quant2,"
strSQL = strSQL & "        tbl_contrato.preco,"
strSQL = strSQL & "        tbl_contrato.preco2,"
strSQL = strSQL & "        tbl_contrato.prazopag,"
strSQL = strSQL & "        tbl_contrato.pagamento,"
strSQL = strSQL & "        tbl_contrato.pgto_2,"
strSQL = strSQL & "        tbl_contrato.pgto_3,"
strSQL = strSQL & "        tbl_contrato.embarque,"
strSQL = strSQL & "        tbl_contrato.origem,"
strSQL = strSQL & "        tbl_contrato.destino,"
strSQL = strSQL & "        tbl_contrato.obs_1,"
strSQL = strSQL & "        tbl_contrato.obs_2,"
strSQL = strSQL & "        tbl_contrato.obs_3,"
strSQL = strSQL & "        tbl_contrato.obs_4,"
strSQL = strSQL & "        tbl_contrato.transportadora,"
strSQL = strSQL & "        tbl_contrato.bco,"
strSQL = strSQL & "        tbl_contrato.age,"
strSQL = strSQL & "        tbl_contrato.defeito,"
strSQL = strSQL & "        tbl_classe.descrclas AS Classe,"
strSQL = strSQL & "        tbl_contrato.cta,"
strSQL = strSQL & "        tbl_contrato.emb,"
strSQL = strSQL & "        tbl_contrato.condicoes,"
strSQL = strSQL & "        tbl_contrato.valor,"
strSQL = strSQL & "        tbl_contrato.observacaoc,"
strSQL = strSQL & "        tbl_contrato.observacaov,"
strSQL = strSQL & "        tbl_contrato.safra,"
strSQL = strSQL & "        tbl_contrato.data_entrega,"
strSQL = strSQL & "        tbl_contrato.moeda,"
strSQL = strSQL & "        tbl_contrato.codigocc,"
strSQL = strSQL & "        tbl_contrato.unidadedemedida_2,"
strSQL = strSQL & "        tbl_contrato.idrepre,"
strSQL = strSQL & "        tbl_contrato.comissao,"
strSQL = strSQL & "        tbl_contrato.comissaoc, "
strSQL = strSQL & "        tbl_contrato.comissaov, "
strSQL = strSQL & "        tbl_embalagem.descremb, "
strSQL = strSQL & "        tbl_variedades.descrvar, "
strSQL = strSQL & "        tbl_contrato.nfc_nro, "
strSQL = strSQL & "        tbl_contrato.nfv_nro, "
strSQL = strSQL & "        tbl_contrato.prod_detalhe "
strSQL = strSQL & " FROM   tbl_contrato "
strSQL = strSQL & "         LEFT JOIN tbl_embalagem  ON tbl_contrato.emb = tbl_embalagem.idemb"
strSQL = strSQL & "         LEFT JOIN tbl_variedades ON tbl_contrato.variedade = tbl_variedades.idvar      AND tbl_contrato.idempresa = tbl_variedades.idempresa"
strSQL = strSQL & "         LEFT JOIN tbl_produtos   ON tbl_contrato.produto = tbl_produtos.idprod         AND tbl_contrato.idempresa = tbl_produtos.idempresa"
strSQL = strSQL & "         LEFT JOIN tbl_produtos_2 ON tbl_contrato.produtosub = tbl_produtos_2.idsubprod AND tbl_contrato.idempresa = tbl_produtos_2.idempresa"
strSQL = strSQL & "         LEFT JOIN tbl_classe     ON tbl_contrato.classe = tbl_classe.idclas            AND tbl_contrato.idempresa = tbl_classe.idempresa"
strSQL = strSQL & " WHERE tbl_contrato.cod_tbl_contrato = " & strCOD_CONTRATO 
'response.write(strSQL)
'abertura do banco de dados e configurações de conexão
 AbreDBConn objConn, CFG_DB 
 set objRS = objConn.execute(strSQL)
'---------------------------------------------------------------------------------------------------------------
if InStr(strTipoImpressao,"comprador")  then  
	strTipoCV = "C"
else 
	strTipoCV = "V"
end if


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="iso-8859-1">
<style type="text/css">
<!--
	table.bordasimples1 {border-collapse: collapse;}
	table.bordasimples1 tr td {border:0px solid #000000;}
	table.bordasimples {border-collapse: collapse;}
	table.bordasimples tr td {border:1px solid #000000;}
	td.fpeq {font-size:11px;}
	td.fmed {font-size:12.5px;}
	td.fgrd {font-size:15px;}
	td {font-size:12px;}
</style>
</head>
<body style="margin:5px 5px 5px 5px; font-family: Verdana, Geneva, Tahoma, sans-serif;">
<!-- (5) //-->

	
		<table width="100%" class="bordasimples1"  cellpadding="0" cellspacing="4" border="0" >
			<tr height="25">
            	<td>
                    <div align="center"> 
                    	<img src="../img/<%=strLogo%>">
                    </div>
                </td>
            </tr>
			<tr>
				<td>
					<div align="center"> 
						<font size="4" ><strong>PEDIDO DE COMPRA E VENDA</strong>
					</div><br/>
				</td>
			</tr>			
		</table>

		<table width="100%" >
				<tr>								
					<td class='fmed'>
						
							Por sua conta e ordem, confirmamos a transação do seguinte negócio:
						
					</td>
					<td  class='fgrd'>									
						N° <strong><%=getValue(objRS,"idcontrato") & " " & strTipoCV%></strong>
					</td>
				</tr>
		</table>	
			<hr>
		<table  width="100%" cellpadding="0" cellspacing="0" border='0' >
				<tr>
					<td width="4%"  align="left">Comprador:</td>
					<td width="50%" colspan="5" align="left"><strong><%=getValue(objRS,"nomec")%></strong></td>
					
				</tr>
				<tr>
					<td align="left">Endereço:</td>
					<td align="left" colspan="5"><strong><%=getValue(objRS,"enderecoc")%></strong></td>
					
				</tr>
				<tr>
					<td align="left">Cep:</td>
					<td align="left"><%=getValue(objRS,"cepc")%></strong></td>					
					<td width="10%"   align="left">Cidade:</td>
					<td width="20%"   align="left"><strong><%=getValue(objRS,"cidadec")%></strong></td>
					<td width="4%"    align="left">UF:</td>
					<td width="12%"   align="left"><strong><%=getValue(objRS,"estadoc")%></strong></td>
				</tr>
				<tr>
					<td  align="left">CNPJ/CPF:</td>
					<td width="20%" align="left"><strong><%=getValue(objRS,"cgccpfc")%></strong></td>
					<td  align="left"nowrap="nowrap">Insc. Est:</td>
					<td  align="left"><strong><%=getValue(objRS,"iergc")%></strong></td>
					<td  align="left"></td>
					<td  align="left"></td>
				</tr>
		</table>
			<hr>
		<table  width="100%" cellpadding="0" cellspacing="0" border='0' >
				<tr>
					<td width="4%" align="left">Vendedor:</td>
					<td width="50%" colspan="5" align="left"><strong><%=getValue(objRS,"nomev")%></strong></td>					
				</tr>
				<tr>
					<td align="left">Endereço:</td>
					<td align="left" colspan="5"><strong><%=getValue(objRS,"enderecov")%></strong></td>
					
				</tr>
				<tr>
					<td   align="left">Cep:</td>
					<td   align="left"><%=getValue(objRS,"cepv")%></strong></td>					
					<td width="10%"   align="left">Cidade:</td>
					<td width="20%"   align="left"><strong><%=getValue(objRS,"cidadev")%></strong></td>
					<td width="4%"    align="left">UF:</td>
					<td width="12%"   align="left"><strong><%=getValue(objRS,"estadov")%></strong></td>
				</tr>
				<tr>
					<td  align="left">CNPJ/CPF:</td>
					<td width="20%" align="left"><strong><%=getValue(objRS,"cgccpfv")%></strong></td>
					<td  align="left" nowrap="nowrap">Insc. Est:</td>
					<td  align="left"><strong><%=getValue(objRS,"iergv")%></strong></td>
					<td  align="left"></td>
					<td  align="left"></td>
				</tr>
		</table>						
			<hr>
						
			<table width="100%" cellpadding="0" cellspacing="0" border="1"  >
					<tr>
						<td width="4%" align="left">Produto:</td>
						<td width="50%" colspan="5" align="left"><strong><%=getValue(objRS,"produto")%>&nbsp;<%=getValue(objRS,"subproduto")%></strong></td>

					</tr>					
					
					<tr>
						<td   align="left">Embalagem:</td>
						<td   align="left"><strong><%=getValue(objRS,"descremb")%></strong></td>					
						<td width="4%"   align="left">Safra:</td>
						<td width="20%"   align="left"><strong><%=getValue(objRS,"safra")%></strong></td>
					</tr>
					<tr>
						<td width="4%" align="left">Quantidade:</td>
						<td width="50%" colspan="5" align="left"><strong><%=getValue(objRS,"quantidade")%>&nbsp;<%=getValue(objRS,"quant2")%></strong></td>
					</tr>
					<tr>					
						<td width="4%">Qualidade:</td>						
						<td>
						<table cellpadding='0' cellspacing='0'>
							<tr>
							<td>Variedade:&nbsp;<strong><%=getValue(objRS,"descrvar")%></strong></td>
							<td>Tipo:&nbsp;<strong><%=getValue(objRS,"tipo")%></strong></td>
							<td>Umid Máx:&nbsp;<strong><%=getValue(objRS,"umidmax")%></strong></td>
							<td>Imp Máx:&nbsp;<strong><%=getValue(objRS,"impmax")%></strong></td>
								</tr>
							</table>
						</td>
					</tr>


					<!--tr>					
						<td width="10%"><font size='2'>Especificações:</td>
						<td width="90%"  >
							<table cellpadding="0" cellspacing="0">
								<tr>
									<td>Classe:&nbsp;<strong><%=getValue(objRS,"classe")%></strong></td>
									<td>Renda Mínima:&nbsp;<strong><%=getValue(objRS,"rend_min")%></strong></td>
									<td>P.H. Mín:&nbsp;<strong><%=getValue(objRS,"ph")%></strong></td>									
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td width="25%" colspan="2">Detalhamento:&nbsp;<strong><%=getValue(objRS,"prod_detalhe")%></strong></td>
					</tr>
					<tr>
						<td width="25%" colspan="2">Defeitos:&nbsp;<strong><%=getValue(objRS,"defeito")%></strong></td>
					</tr-->
			</table>
						
			<hr>
			

			<table width="100%" >
					<tr>
						<td width="25%">Preço:&nbsp;<strong><%if getValue(objRS,"preco")<>"" then response.write(formatnumber(getValue(objRS,"preco"),2)&" "& getValue(objRS,"preco2") ) end if%></strong></td>
					</tr>
					<tr>
						<td width="25%">Condições:&nbsp;<strong><%=getValue(objRS,"condicoes")%></strong></td>
					</tr>
					<tr>
						<td width="25%">Tributos:&nbsp;<strong><%=getValue(objRS,"tributo1")%><br><%=getValue(objRS,"tributo2")%></strong></td>
					</tr>
			</table>
						
			<hr>
			

			<table width="100%" >
					<tr>
						<td width="25%" colspan="3">Data Pagto:&nbsp;<strong><%=getValue(objRS,"prazopag")%></strong></td>						
					
					</tr>
					<tr>
						<td width="25%">Banco:&nbsp;<%=getValue(objRS,"bco")%></strong></td>
						<td width="25%">Agencia:&nbsp;<strong><%=getValue(objRS,"age")%></strong></td>
						<td width="25%">Cc:&nbsp;<strong><%=getValue(objRS,"cta")%></strong></td>
					</tr>
			</table>
			<hr>
			<table width="100%" >
					<tr>
						<td width="25%">Data Entrega:&nbsp;<strong><%=getValue(objRS,"data_entrega")%></strong></td>
					</tr>
					<tr>
						<td width="25%">Origem:&nbsp;<strong><%=getValue(objRS,"origem")%></strong></td>						
						<td width="25%">Destino:&nbsp;<strong><%=getValue(objRS,"destino")%></strong></td>						
					</tr>
			</table>
			
			<hr>
			

			<table width="100%" >
					<tr><td>
						Observações:  
						<strong>
							<%
								if InStr(strTipoImpressao,"comprador")  then 
									response.write(getValue(objRS,"observacaoc"))
								else
									response.write(getValue(objRS,"observacaov"))
								end if
							%>					
						</strong>
						</td>
					</tr>
				
			</table>			
			<hr>			

			<table width="100%" >
					<tr>								
						<td width="100%" colspan="2">
							
								O desacordo com qualquer uma das cláusulas acima descritas deverá ser imediatamente comunicado. A decisão de crédito e aceite da negociação, 
								bem como o cumprimento das cláusulas aqui descritas, são de responsabilidade exclusiva das partes Compradora e Vendedora.
							
						</td>						
						<tr>
						<td></td><br><br>
						<td width="30%" align="right">								
							<br>Porto Alegre, <%=day(now())%> de <%=MesExtenso(month(now()))%> de <%=year(now())%>.
						</td>
					</tr>	
			</table>
<br><br><br>

			
			<table width="100%"  style="text-align: center;" >
					<tr>
						<td width="33.5%"><hr><%=getValue(objRS,"nomec")%></td>						
						<td width="33.5%"><hr>Corretora Mercado</td>						
						<td width="33.5%"><hr><%=getValue(objRS,"nomev")%></td>
						
					</tr>
			</table>
			<br><br>
			<center>
		<table width="100%" >
<%		if instr(strTipoImpressao,"m_") Then	%>
		
			
					<tr>
						<td width="33%"   >
						   
						   <font size="0.5">
							<p><strong>Matriz:</strong><br>
									Rua João Abbott, 433</br>
									CEP 90460-150 Porto Alegre - RS</br>
									Telefone: +55 (51) 3086-8700</br>
									Fax: + 55 (51) 3086-8701</br>
									mercado@clicmercado.com.br</p>
							
							
						</td>
						<td width="33%"  ><font size="0.5">
							<p><strong>Filial:</strong></br>
                            Rua Duque de Caxias, 2319 - Pulse Coworking</br>
							CEP 97060-210 – Santa Maria - RS</br>
							Telefone: (55) 3029-2900</br>
							santamaria@clicmercado.com.br</p>
							
						</td>
						<td width="33%" ><font size="0.5">
							<p><strong>Bolsa:</strong> <br>
							Rua dos Andradas 955, 3º andar</br>
							CEP 90020-005 - Porto Alegre - RS</br>
							Telefone: (51) 4066-8700</p>
							
						</td>
					</tr>					
			
<% else %>

					<tr>
						<td width="33.3%" align="center" ><font size="1">
							<p><strong>SULGRAIN - CORRETORA DE MERCADORIAS LTDA.</strong><br>
									Rua João Abbott, 433 - CEP 90460-150 Porto Alegre - RS</br>
									Telefones: +55 (51) 3330-2230 e 3126-3922 - Fax: + 55 (51) 3330-7444</br>
									www.sulgrain.com.br - sulgrain@sulgrain.com.br</p>
							
						</td>
                     </p>
                     </p>

<% end if%>			
		</table>
		</center>
		


	

</body>
</html>
 