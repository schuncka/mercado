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
function formatCep(prCep)
    dim limpo
    limpo = replace(replace(replace(prCep,"-",""),".",""),"/","")
    limpo = left(limpo,5)&"-"&right(limpo,3)
    formatCep = limpo
end function





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
strSQL = strSQL & "        (select  descrunid from tbl_unidade where idunid = tbl_contrato.unidade) as unidade_descr,"
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
strSQL = strSQL & "        (select descrvar from tbl_variedades where idvar = tbl_contrato.variedade) as descrvar, "
strSQL = strSQL & "        tbl_contrato.nfc_nro, "
strSQL = strSQL & "        tbl_contrato.nfv_nro, "
strSQL = strSQL & "        tbl_contrato.prod_detalhe "
strSQL = strSQL & " FROM   tbl_contrato "
strSQL = strSQL & "         LEFT JOIN tbl_embalagem  ON tbl_contrato.emb = tbl_embalagem.idemb"
strSQL = strSQL & "         LEFT JOIN tbl_variedades ON tbl_contrato.variedade = tbl_variedades.idvar      AND tbl_contrato.idempresa = 'MM'"
strSQL = strSQL & "         LEFT JOIN tbl_produtos   ON tbl_contrato.produto = tbl_produtos.idprod         AND tbl_produtos.idempresa = 'MM'"
strSQL = strSQL & "         LEFT JOIN tbl_produtos_2 ON tbl_contrato.produtosub = tbl_produtos_2.idsubprod AND tbl_produtos_2.idempresa = 'MM'"
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
<style>
 table {font-family:Arial, Helvetica, sans-serif;
 		font-size:10px;	
		width:100%;
		}
 td {}
 .titulo {width:100%;
 		  border-bottom:solid;
		  border-bottom-color:#000;
		  padding-top:10px;
		  font-size:12px;
		  }
  .titulo_principal { font-size:16px;}
  .table_text {text-align:justify;}
  .data_contrato {padding-top:5px;font-size:10px;}
  td {vertical-align:text-top}
</style>
</head>
<body>
<!-- (5) //-->

	<table class="titulo_principal">
	<tr>
    	<td style="text-align:center">
        	<img src="../img/<%=strLogo%>">
        </td>
    
    	<td style="text-align:right;vertical-align:bottom"><strong>CONTRATO DE COMPRA E VENDA Nº <%=getValue(objRS,"idcontrato") & " " & strTipoCV%></strong></td>
    </tr>
</table>
		
<table class="titulo" style="padding-top:25px;">
	<tr>
		<td valign="middle"><strong>DAS PARTES</strong></td>
    </tr>
</table>
<table>
	<tr>
		<td width="12%"><strong>Comprador</strong></td>
        <td width="41%"><strong><%=getValue(objRS,"nomec")%></strong></td>
        <td width="20%"></td>
        <td width="27%"></td>
    </tr>
    <tr>
		<td></td>
        <td><%=getValue(objRS,"enderecoc")%></td>
        <td></td>
        <td ><%=getValue(objRS,"bairroc")%></td>
    </tr>
    <tr>
		<td></td>
        <td><%=getValue(objRS,"cidadec")%> / <%=getValue(objRS,"estadoc")%></td>
        <td></td>
        <td><%=formatCep(getValue(objRS,"cepc"))%></td>
    </tr>
    <tr>
		<td></td>
        <td>CNPJ / CPF: <%=getValue(objRS,"cgccpfc")%></td>
        <td>IE: <%=getValue(objRS,"iergc")%></td>
        <td></td>
    </tr>
</table>

<table style="width:100%">
	<tr>
		<td width="12%"><strong>Vendedor</strong></td>
        <td width="41%"><strong><%=getValue(objRS,"nomev")%></strong></td>
        <td width="20%"></td>
        <td width="27%"></td>
    </tr>
    <tr>
		<td></td>
        <td><%=getValue(objRS,"enderecov")%></td>
        <td></td>
        <td ><%=getValue(objRS,"bairrov")%></td>
    </tr>
    <tr>
		<td></td>
        <td><%=getValue(objRS,"cidadev")%></td>
        <td></td>
        <td><%=formatCep(getValue(objRS,"cepv"))%></td>
    </tr>
    <tr>
		<td></td>
        <td>CNPJ / CPF: <%=getValue(objRS,"cgccpfv")%></td>
        <td>IE: <%=getValue(objRS,"iergv")%></td>
        <td></td>
    </tr>
</table>
		
<table class="titulo">
	<tr>
		<td><strong>DESCRIÇÃO DO PRODUTO</strong></td>
    </tr>
</table>
<table >
	<tr>
		<td width="12%"><strong>Produto:</strong></td>
        <td width="41%"><strong><%=getValue(objRS,"produto")%>&nbsp;<%=getValue(objRS,"subproduto")%></strong></td>
        <td width="20%">Safra: <%=getValue(objRS,"safra")%></td>
        <td width="27%">Embalagem: <%=getValue(objRS,"descremb")%></td>
    </tr>
    <tr>
		<td>Quantidade:</td>
        <td><%=getValue(objRS,"quantidade")%>&nbsp;(<%=replace(extenso(getValue(objRS,"quantidade"),1),"reais","")%>&nbsp<%=(getValue(objRS,"unidade_descr"))%>)</td>
        <td></td>
        <td ></td>
    </tr>
    <tr>		
        <td colspan="2">Variedade:&nbsp;<%=getValue(objRS,"descrvar")%></td>
        <td>Tipo:<%=getValue(objRS,"tipo")%></td>
        <td  >Umid Máx:&nbsp;<%=getValue(objRS,"umidmax")%>%&nbsp;&nbsp;Imp Máx:&nbsp;<%=getValue(objRS,"impmax")%>%</td>
    </tr>
    
    <tr>
		<td>Preço:</td>
        <td colspan="3">R$ <%=formatnumber(getValue(objRS,"preco"),2)%> por &nbsp<%=(getValue(objRS,"unidade_descr"))%> <br> (<%=extenso(getValue(objRS,"preco"),1)%>*************************************************)</td>        
    </tr>
    <tr>
		<td>Valor Total Bruto:</td>
        <td colspan="3">R$ <%=formatnumber((getValue(objRS,"preco")*getValue(objRS,"quantidade")),2)%><br> (<%=extenso((getValue(objRS,"preco")*getValue(objRS,"quantidade")),1)%>*************************************************)</td>        
    </tr>
    <tr>
	    <td>Condições:</td>
		<td><%=getValue(objRS,"condicoes")%></td>			
		<td colspan="2">Tributos:&nbsp;<%=getValue(objRS,"tributo1")%>&nbsp;<%=getValue(objRS,"tributo2")%></td>
	    
    </tr>
    
</table>

<table class="titulo">
	<tr>
		<td valign="middle"><strong>PAGAMENTO / TRANSPORTE</strong></td>
    </tr>
</table>
<table>
	<tr>
		<td width="12%">Prazo:</td>
        <td width="41%"><% if getValue(objRS,"prazopag") = "" then%>Vide Observação<% else response.write(PrepData(getValue(objRS,"prazopag"),true,false)) end if%></td>
        <td width="20%"></td>
        <td width="27%"></td>
    </tr>
    <tr>
		<td>Banco:</td>
        <td><%=getValue(objRS,"bco")%></td>
        <td>AGÊNCIA: <%=getValue(objRS,"age")%></td>
        <td>CONTA CORRENTE: <%=getValue(objRS,"cta")%></td>
    </tr>
    <tr>
		<td>Data de Entrega:</td>
        <%

        %>
        <td><% if getValue(objRS,"data_entrega") = "" then%>Vide Observação<% else response.write(PrepData(getValue(objRS,"data_entrega"),true,false)) end if%></td>
        <td>Origem: <%=getValue(objRS,"origem")%></td>
        <td>Destino: <%=getValue(objRS,"destino")%></td>
    </tr>    
</table>

<table class="titulo">
	<tr>
		<td valign="middle"><strong>OBSERVAÇÕES</strong></td>
    </tr>
</table>
<table class="table_text" height="100">
	<tr>
		<td valign="top"> 
        <% if InStr(strTipoImpressao,"comprador")  then 
            response.write(getValue(objRS,"observacaoc"))
        else
            response.write(getValue(objRS,"observacaov"))
        end if
        %>
    	</td>
    </tr>   
</table>

<table class="data_contrato" >
    <tr>
        <td>
        O desacordo com qualquer uma das cláusulas acima descritas deverá ser imediatamente comunicado. A decisão de crédito e aceite da negociação, 
bem como o cumprimento das cláusulas aqui descritas, são de responsabilidade exclusiva das partes Compradora e Vendedora.<br><br>
        </td>
    </tr>
	<tr>
    	<td style="text-align:right">Porto Alegre, <%=day(now())%> de <%=MesExtenso(month(now()))%> de <%=year(now())%>.</td>
    </tr>
</table>

<table style="padding-top:25px">
	<tr>
    	<td width="44%"><!--VENDEDOR CIENTE E DE ACORDO--></td>
        <td width="12%"></td>
        <td width="44%"><!--COMPRADOR CIENTE E DE ACORDO--></td>
    </tr>
</table>
<table style="padding-top:30px">
	<tr>
    	<td width="44%" style="border-bottom:solid 1px;"></td>
        <td width="12%"></td>
        <td width="44%" style="border-bottom:solid  1px;"></td>
    </tr>

    
    <tr>
    	<td width="44%"><%=getValue(objRS,"nomev")%></td>
        <td width="12%"></td>
        <td width="44%"><%=getValue(objRS,"nomec")%></td>
    </tr>
</table>
<br><br>
<table style="padding-top:30px;text-align:center;">
	<tr>
    	<td width="28%"></td>
        <td width="44%" style="border-bottom:solid 1px;"><img src="../img/<%=getValue(objRS,"idrepre")%>.jpg" width="300"></td>
        <td width="28%"></td>
    </tr>
    <tr>
    	<td width="28%"></td>
        <td width="44%">Corretora Mercado</td> 
        <td width="28%"></td>       
    </tr>
</table>
<table style="padding-top:40px; padding-left:50px">
<%		if instr(strTipoImpressao,"m_") Then	%>
    
                <tr>
                    <td width="33%" style="text-align:left"  >
                        <font size="0.5">
                        <p>  <strong>Matriz:</strong><br>
                                Rua João Abbott, 433</br>
                                CEP 90460-150 Porto Alegre - RS</br>
                                Telefone: +55 (51) 3086-8700</br>
                                Fax: + 55 (51) 3086-8701</br>
                                mercado@clicmercado.com.br
                          </p>
                    </td>
                    <td width="33%" style="text-align:left;"><font size="0.5">
                                <p><strong>Filial:</strong></br>
                                Rua Duque de Caxias, 2319 - Pulse Coworking</br>
                                CEP 97060-210 – Santa Maria - RS</br>
                                Telefone: (55) 3029-2900</br>
                                santamaria@clicmercado.com.br</p>
                                
                            </td>
                            <td width="33%" style="text-align:left;padding-left:30px" ><font size="0.5">
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
                    </tr>
                    

<% end if%>			
		</table>
		
</body>
</html>
 