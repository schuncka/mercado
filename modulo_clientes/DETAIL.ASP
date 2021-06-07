<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->
<!--#include file="../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<% VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_CfgPanel",Session("ID_USER")), true %>
<%
 Const MDL = "DEFAULT"		' - Default do Modulo...
 Const LTB = "tbl_clientes as t1"	 ' - Nome da Tabela...
 Const DKN = "COD_TBL_CLIENTES"    ' - Campo chave...
 Const TIT = "View"  

 Dim objConn, objRS, strSQL
 Dim strCODIGO ,Idx , strFIELD, strTYPE, strVALUE,objRSDetail,objResultCompra,total,preco,quantidade,totalLinha,produto
'  athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
 strCODIGO = GetParam("var_chavereg")
  
 If strCODIGO <> "" Then
	  AbreDBConn objConn, CFG_DB 
	  
	  strSQL = "SELECT codigodocliente,           "
      strSQL = strSQL & " nomedocliente,           " 
      strSQL = strSQL & " fantasia, "
      strSQL = strSQL & " endereco, "
      strSQL = strSQL & " bairro, "
      strSQL = strSQL & " cidade, "
      strSQL = strSQL & " estado, "
      strSQL = strSQL & " codigopostal, "
      strSQL = strSQL & " numerodetelefone, "
      strSQL = strSQL & " numerodetelefone1, "
      strSQL = strSQL & " numerodetelefone2, "
      strSQL = strSQL & " numerodetelefone3, "
      strSQL = strSQL & " ramal, "
      strSQL = strSQL & " idtelefone, "
      strSQL = strSQL & " idtelefone1, "
      strSQL = strSQL & " idtelefone2, "
      strSQL = strSQL & " idtelefone3, "
      strSQL = strSQL & " cgccpf, "
      strSQL = strSQL & " ierg, "
      strSQL = strSQL & " datafund, "
      strSQL = strSQL & " rg, "
      strSQL = strSQL & " datarg, "
      strSQL = strSQL & " orgaorg, "
      strSQL = strSQL & " emailcli,"
      strSQL = strSQL & " idempresa, "
      strSQL = strSQL & " codold, "
      strSQL = strSQL & " cgccpf, "
      strSQL = strSQL & " ierg, "
      strSQL = strSQL & " datafund, "
      strSQL = strSQL & " rg, "
      strSQL = strSQL & " datarg, "
      strSQL = strSQL & " orgaorg, "
      strSQL = strSQL & " emailcli, "
      strSQL = strSQL & " website, "
      strSQL = strSQL & " end2, "
      strSQL = strSQL & " observacoes, "
      strSQL = strSQL & " endcob, "
      strSQL = strSQL & " baircob, "
      strSQL = strSQL & " cidcob, "
      strSQL = strSQL & " estcob, "
      strSQL = strSQL & " cepcob, "
      strSQL = strSQL & " emailclicob, "
      strSQL = strSQL & " websitecob, "
      strSQL = strSQL & " observacoes2, "
      strSQL = strSQL & " (SELECT tipo2 FROM tbl_tipo where idtipo = t1.tipo limit 1) tipo, "
      strSQL = strSQL & " datacad, "
      strSQL = strSQL & " dataatual, "
      strSQL = strSQL & " bmrs, "
      strSQL = strSQL & " inss, "
      strSQL = strSQL & " cnae, "
      strSQL = strSQL & " bco, "
      strSQL = strSQL & " ag, "
      strSQL = strSQL & " cta, "
      strSQL = strSQL & " comissaor, "
      strSQL = strSQL & " dt_aut_corr, "
      strSQL = strSQL & " nrobanco, "
      strSQL = strSQL & " area_plantada, "
      strSQL = strSQL & " area_total, "
      strSQL = strSQL & " plantel, "
      strSQL = strSQL & " consumo_mensal, "
      strSQL = strSQL & " latitude, "
      strSQL = strSQL & " longitude, "
      strSQL = strSQL & " imovel, "
      strSQL = strSQL & " cod_tbl_clientes, "
      strSQL = strSQL & " sys_dtt_ins, "
      strSQL = strSQL & " sys_dtt_upd, "
      strSQL = strSQL & " (select nomedocliente from tbl_clientes where codigodocliente = t1.idrepre and tipo = 5 limit 1) as idrepre, "
      strSQL = strSQL & " ponto_referencia, "
      strSQL = strSQL & " nirf, "
      strSQL = strSQL & " sys_usr_ins, "
      strSQL = strSQL & " sys_usr_upd, "
      strSQL = strSQL & " sys_usr_del, "
      strSQL = strSQL & " sys_dtt_del, "
      strSQL = strSQL & " pais, "
      strSQL = strSQL & " inscr_munipal, "
      strSQL = strSQL & " email_nfe, "
      strSQL = strSQL & " dt_aut_conab "
      strSQL = strSQL & " FROM " & LTB & " WHERE " & DKN & " = " & strCODIGO
      Set objRS = objConn.Execute(strSQL)
'
     If Not objRS.Eof Then  
 'if 1=1 then
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 

</head>
<body class="metro">
<!-- Barra que contem o título do módulo e ação da dialog//-->
<div class="bg-darkOrange fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px">DETAIL</span></sup>
</div>
<!-- FIM -------------------------------Barra//-->

        <div class="grid" style="padding: 0px 0px 0px 10px">
            <div class="row">
                <div class="span12">
                    <div class="panel" data-role="panel">
                        <div class="panel-header">
                            <%=getValue(objRS,"NomeDoCliente")%>&nbsp;(<%=getValue(objRS,"tipo")%>)
                        </div>
                        <div class="panel-content">
                            <table width="100%">
                                <tr>
                                    <td>Endereço:</td>
                                    <td colspan="3"><%=getValue(objRS,"Endereco")%>&nbsp;<%=getValue(objRS,"Bairro")%>&nbsp;<%=getValue(objRS,"Cidade")%>&nbsp;<%=getValue(objRS,"Estado")%><br><%=getValue(objRS,"CodigoPostal")%></td>                                    
                                </tr>                                
                                <tr>
                                    <td>CNPJ/CPF:</td>
                                    <td ><%=getValue(objRS,"CGCCPF")%></td>
                                    <td>Insc. Estadual:</td>
                                    <td ><%=getValue(objRS,"IERG")%></td>
                                </tr>
                                <tr>
                                    <td>Insc. Municipal:</td>
                                    <td ><%=getValue(objRS,"inscr_munipal")%></td>
                                    <td>RG:</td>
                                    <td ><%=getValue(objRS,"RG")%> <% if getValue(objRS,"DataRG")<>"" then %>&nbsp;(<%=getValue(objRS,"DataRG")%>&nbsp;<%=getValue(objRS,"OrgaoRG")%><%end if%></td>
                                </tr>
                                <tr>
                                    <td>Fone1:</td>
                                    <td><%=getValue(objRS,"NumeroDeTelefone")%></td>
                                    <td>Fone2:</td>
                                    <td><%=getValue(objRS,"NumeroDeTelefone1")%></td>
                                </tr>
                                <tr>
                                    <td>Fone3:</td>
                                    <td><%=getValue(objRS,"NumeroDeTelefone2")%></td>
                                    <td>Fone4:</td>
                                    <td><%=getValue(objRS,"NumeroDeTelefone3")%></td>
                                </tr>
                               
                                <tr>
                                    <td>Dados bancarios:</td>
                                    <td colspan="2"><%=getValue(objRS,"nrobanco")%> - <%=getValue(objRS,"BCO")%> <br> Agência/Conta: <%=getValue(objRS,"ag")%> / <%=getValue(objRS,"cta")%></td>
                                </tr>
                                <tr>
                                    <td>
                                </tr>
                            </table>
                        </div>
                    </div>
				</div><!--fim span7 class-->
           
            </div> <!--fim row-->

            <div class="row">
                
                <%
                    strSQL =  "SELECT  contato,celular, mailcom,cargo,aniv,msn,cpf,obs,bbm,email1 FROM tbl_clientes_sub t where codigodocliente =  " & getValue(objRS,"codigodocliente") & " order by contato" 
                    set objRSDetail = objConn.Execute(strSQL)
                    if Not objRSDetail.Eof Then                        
                %>
                
                        <div class="span12">
                             <div class="panel" data-role="panel">
                                <div class="panel-header">
                                    Contatos
                                </div>
                                <div class="panel-content" style="display: none;">
                                            <% Do While not objRSDetail.Eof%>
                                            <div class="panel" data-role="panel">
                                                <div class="panel-header" title="<%=getValue(objRSDetail,"cargo")%>">
                                                   <%=getValue(objRSDetail,"contato")%>&nbsp;&nbsp;<small><%=getValue(objRSDetail,"cargo")%></small>
                                                </div>
                                                <div class="panel-content" style="display: none;">
                                                    <table width="100%">                                                        
                                                            <tr>
                                                                <td width="25%">Cargo:</td>
                                                                <td width="75%"><%=getValue(objRSDetail,"cargo")%></td>
                                                            </tr>
                                                            <tr>
                                                                <td >CPF:</td>
                                                                <td ><%=getValue(objRSDetail,"cpf")%></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Fone:</td>
                                                                <td><%=getValue(objRSDetail,"celular")%></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Email</td>
                                                                <td><%=getValue(objRSDetail,"mailcom")%><% if getValue(objRSDetail,"email1")<>"" then %>&nbsp;/&nbsp;<%=getValue(objRSDetail,"email1")%><% end if %></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Skype:</td>
                                                                <td><%=getValue(objRSDetail,"msn")%></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Aniversário:</td>
                                                                <td><%=getValue(objRSDetail,"aniv")%></td>
                                                            </tr>
                                                            <tr>
                                                                <td>Observação:</td>
                                                                <td><%=getValue(objRSDetail,"obs")%></td>
                                                            </tr>
                                                            
                                                        
                                                    </table>
                                                </div>                        
                                            </div>
                            <%      objRSDetail.movenext
                                            loop %>
                                </div>
                            </div>
                        </div><!--fim span5 class-->
                    <%end if 'if dos contatos %>
</div>


        <%
            strSQL =  "	SELECT  t1.idcontrato, "
            
            strSQL = strSQL & "						       Date(t1.data)              AS data,"
            strSQL = strSQL & "						       t1.comprador,"
            strSQL = strSQL & "						       t1.nomec, "		
            strSQL = strSQL & "						       t1.vendedor,"
            strSQL = strSQL & "						       t1.nomev,"
            strSQL = strSQL & "						       t2.produto,"
            strSQL = strSQL & "						       subproduto,"
            strSQL = strSQL & "						       t1.quantidade,"
            strSQL = strSQL & "						       t1.preco,"
            strSQL = strSQL & "						       kg,"
            strSQL = strSQL & "						       t1.comprador, "
            strSQL = strSQL & "						       t1.nfv_data, "
            strSQL = strSQL & "						       t1.nfv_valor,"
            strSQL = strSQL & "						       t1.nfv_nro,"
            strSQL = strSQL & "						       Date(t1.nfv_pagto)         AS nfv_pagto"
            strSQL = strSQL & "					FROM  tbl_contrato t1"
            strSQL = strSQL & "					left join tbl_produtos t2 on t1.produto = t2.idprod"
            strSQL = strSQL & "					left join tbl_produtos_2 t3 on t1.produtosub = t3.idsubprod"
            strSQL = strSQL & "					left join tbl_unidade t4 on t1.unidade = t4.descrunid"
            strSQL = strSQL & "					where t1.comprador = " & getValue(objRS,"codigodocliente") 
            strSQL = strSQL & "					order by t1.data desc limit 10"
'response.write(strSQL)

		set objResultCompra = objConn.Execute(strSQL)
        if not objResultCompra.eof then 
    %>         
            <div class="row">
				<div class="span12">
					<div class="panel" data-role="panel">
							<div class="panel-header">
								Contratos Venda
							</div>
							<div class="panel-content" style="display:none;">
								<table align="center" cellpadding="0" cellspacing="1" style="width:100%;" class="tablesort">
                                    <thead>
                                        <tr>				
                                            <th width="10%" class="sortable" nowrap>CONTRATO</th>
                                            <th width="10%" class="sortable" nowrap>DATA</th>
                                            <th width="30%" class="sortable" nowrap>VENDEDOR</th>
                                            <th width="15%" class="sortable" nowrap>PRODUTO</th>
                                            <th width="11%" class="sortable" nowrap>QUANTIDADE</th>
                                            <th width="11%" class="sortable" nowrap>PREÇO UNIT</th>
                                            <th width="10%" class="sortable" nowrap>TOTAL R$ (MIL)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% do while not objResultCompra.Eof
                                       if getValue(objResultCompra,"preco") = "" Then
                                            preco = 0
                                        else 
                                            preco = getValue(objResultCompra,"preco")
                                        end if
                                        if getValue(objResultCompra,"quantidade") = "" Then
                                            quantidade = 0
                                        else 
                                            quantidade = getValue(objResultCompra,"quantidade")
                                        end if
                                        
                                        produto = getValue(objResultCompra,"produto")
                                        if getValue(objResultCompra,"subproduto") <>"" then
                                            produto = produto & " - " & getValue(objResultCompra,"subproduto")
                                        end if
                                        
                                       
                                    totalLinha = (preco * quantidade)/1000
                                       
                                    
                                    %>
                                        <tr>				
                                            <td align="left"> <%=getValue(objResultCompra,"idcontrato")%></td>
                                            <td align="left"> <%=getValue(objResultCompra,"data")%></td>
                                            <td align="left"> <%=getValue(objResultCompra,"nomev")%></td>
                                            <td align="left"> <%=produto%></td>
                                            <td align="right"><%=getValue(objResultCompra,"quantidade")%></td>
                                            <td align="right"><%=formatnumber(preco,2)%></td> 
                                            <td align="right"><%=formatnumber(totalLinha,2)%></td>                                          
                                        </tr>
                                    <% total = total +totalLinha  
                                        objResultCompra.movenext
                                        loop
                                    %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td align="right" colspan="6">Total:</td>				
                                            <td align="right" ><strong><%=formatnumber(total,2)%></strong></td>
                                        </tr>
                                    </tfoot>		
                                </table>
							</div>                        
					</div>
				</div> <!--fim span-->                    
            </div><!--fim row-->
        <%end if 'contratos compra %>


<%
            strSQL =  "	SELECT  t1.idcontrato, "
            
            strSQL = strSQL & "						       Date(t1.data)              AS data,"
            strSQL = strSQL & "						       t1.comprador,"
            strSQL = strSQL & "						       t1.nomec, "		
            strSQL = strSQL & "						       t1.vendedor,"
            strSQL = strSQL & "						       t1.nomev,"
            strSQL = strSQL & "						       t2.produto,"
            strSQL = strSQL & "						       subproduto,"
            strSQL = strSQL & "						       t1.quantidade,"
            strSQL = strSQL & "						       t1.preco,"
            strSQL = strSQL & "						       kg,"
            strSQL = strSQL & "						       t1.comprador, "
            strSQL = strSQL & "						       t1.nfv_data, "
            strSQL = strSQL & "						       t1.nfv_valor,"
            strSQL = strSQL & "						       t1.nfv_nro,"
            strSQL = strSQL & "						       Date(t1.nfv_pagto)         AS nfv_pagto"
            strSQL = strSQL & "					FROM  tbl_contrato t1"
            strSQL = strSQL & "					left join tbl_produtos t2 on t1.produto = t2.idprod"
            strSQL = strSQL & "					left join tbl_produtos_2 t3 on t1.produtosub = t3.idsubprod"
            strSQL = strSQL & "					left join tbl_unidade t4 on t1.unidade = t4.descrunid"
            strSQL = strSQL & "					where t1.vendedor = " & getValue(objRS,"codigodocliente") 
            strSQL = strSQL & "					order by t1.data desc limit 10"
'response.write(strSQL)

		set objResultCompra = objConn.Execute(strSQL)
        if not objResultCompra.eof then 
    %>         
            <div class="row">
				<div class="span12">
					<div class="panel" data-role="panel">
							<div class="panel-header">
								Contratos Compra
							</div>
							<div class="panel-content" style="display:none;">
								<table align="center" cellpadding="0" cellspacing="1" style="width:100%;" class="tablesort">
                                    <thead>
                                        <tr>				
                                            <th width="10%" class="sortable" nowrap>CONTRATO</th>
                                            <th width="10%" class="sortable" nowrap>DATA</th>
                                            <th width="30%" class="sortable" nowrap>COMPRADOR</th>
                                            <th width="15%" class="sortable" nowrap>PRODUTO</th>
                                            <th width="11%" class="sortable" nowrap>QUANTIDADE</th>
                                            <th width="11%" class="sortable" nowrap>PREÇO UNIT</th>
                                            <th width="10%" class="sortable" nowrap>TOTAL R$ (MIL)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% 
                                        total = 0
                                        totalLinha = 0
                                        do while not objResultCompra.Eof
                                       if getValue(objResultCompra,"preco") = "" Then
                                            preco = 0
                                        else 
                                            preco = getValue(objResultCompra,"preco")
                                        end if
                                        if getValue(objResultCompra,"quantidade") = "" Then
                                            quantidade = 0
                                        else 
                                            quantidade = getValue(objResultCompra,"quantidade")
                                        end if
                                        
                                        produto = getValue(objResultCompra,"produto")
                                        if getValue(objResultCompra,"subproduto") <>"" then
                                            produto = produto & " - " & getValue(objResultCompra,"subproduto")
                                        end if
                                        
                                       
                                    totalLinha = (preco * quantidade)/1000
                                       
                                    
                                    %>
                                        <tr>				
                                            <td align="left"> <%=getValue(objResultCompra,"idcontrato")%></td>
                                            <td align="left"> <%=getValue(objResultCompra,"data")%></td>
                                            <td align="left"> <%=getValue(objResultCompra,"nomec")%></td>
                                            <td align="left"> <%=produto%></td>
                                            <td align="right"><%=getValue(objResultCompra,"quantidade")%></td>
                                            <td align="right"><%=formatnumber(preco,2)%></td> 
                                            <td align="right"><%=formatnumber(totalLinha,2)%></td>                                          
                                        </tr>
                                    <% total = total +totalLinha  
                                        objResultCompra.movenext
                                        loop
                                    %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td align="right" colspan="6">Total:</td>				
                                            <td align="right" ><strong><%=formatnumber(total,2)%></strong></td>
                                        </tr>
                                    </tfoot>		
                                </table>
							</div>                        
					</div>
				</div> <!--fim span-->                    
            </div><!--fim row-->
        <%end if 'contratos venda %>



        <%
            strSQL =  "	SELECT  t1.idcontrato, "
            
            strSQL = strSQL & "						       Date(t1.data)              AS data,"
            strSQL = strSQL & "						       t1.comprador,"
            strSQL = strSQL & "						       t1.nomec, "		
            strSQL = strSQL & "						       t1.vendedor,"
            strSQL = strSQL & "						       t1.nomev,"
            strSQL = strSQL & "						       t2.produto,"
            strSQL = strSQL & "						       subproduto,"
            strSQL = strSQL & "						       t1.quantidade,"
            strSQL = strSQL & "						       t1.preco,"
            strSQL = strSQL & "						       kg,"
            strSQL = strSQL & "						       t1.comprador, "
            strSQL = strSQL & "						       t1.nfv_data, "
            strSQL = strSQL & "						       t1.nfv_valor,"
            strSQL = strSQL & "						       t1.nfv_nro,"
            strSQL = strSQL & "						       Date(t1.nfv_pagto)         AS nfv_pagto"
            strSQL = strSQL & "					FROM  tbl_contrato t1"
            strSQL = strSQL & "					left join tbl_produtos t2 on t1.produto = t2.idprod"
            strSQL = strSQL & "					left join tbl_produtos_2 t3 on t1.produtosub = t3.idsubprod"
            strSQL = strSQL & "					left join tbl_unidade t4 on t1.unidade = t4.descrunid"
            strSQL = strSQL & "					where t1.idrepre = " & getValue(objRS,"codigodocliente") 
            strSQL = strSQL & "					order by t1.data desc limit 10"
'response.write(strSQL)

		set objResultCompra = objConn.Execute(strSQL)
        if not objResultCompra.eof then 
    %>         
            <div class="row">
				<div class="span12">
					<div class="panel" data-role="panel">
							<div class="panel-header">
								Negocios Intermediarios
							</div>
							<div class="panel-content" style="display:none;">
								<table align="center" cellpadding="0" cellspacing="1" style="width:100%;" class="tablesort">
                                    <thead>
                                        <tr>				
                                            <th width="10%" class="sortable" nowrap>CONTRATO</th>
                                            <th width="10%" class="sortable" nowrap>DATA</th>
                                            <th width="30%" class="sortable" nowrap>COMPRADOR</th>
                                            <th width="30%" class="sortable" nowrap>VENDEDOR</th>
                                            <th width="15%" class="sortable" nowrap>PRODUTO</th>
                                            <th width="11%" class="sortable" nowrap>QUANTIDADE</th>
                                            <th width="11%" class="sortable" nowrap>PREÇO UNIT</th>
                                            <th width="10%" class="sortable" nowrap>TOTAL R$ (MIL)</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    <% 
                                        total = 0
                                        totalLinha = 0
                                        do while not objResultCompra.Eof
                                       if getValue(objResultCompra,"preco") = "" Then
                                            preco = 0
                                        else 
                                            preco = getValue(objResultCompra,"preco")
                                        end if
                                        if getValue(objResultCompra,"quantidade") = "" Then
                                            quantidade = 0
                                        else 
                                            quantidade = getValue(objResultCompra,"quantidade")
                                        end if
                                        
                                        produto = getValue(objResultCompra,"produto")
                                        if getValue(objResultCompra,"subproduto") <>"" then
                                            produto = produto & " - " & getValue(objResultCompra,"subproduto")
                                        end if
                                        
                                       
                                    totalLinha = (preco * quantidade)/1000
                                     
                                    %>
                                        <tr>				
                                            <td align="left"> <%=getValue(objResultCompra,"idcontrato")%></td>
                                            <td align="left"> <%=getValue(objResultCompra,"data")%></td>
                                            <td align="left"> <%=getValue(objResultCompra,"nomec")%></td>
                                            <td align="left"> <%=getValue(objResultCompra,"nomev")%></td>
                                            <td align="left"> <%=produto%></td>
                                            <td align="right"><%=getValue(objResultCompra,"quantidade")%></td>
                                            <td align="right"><%=formatnumber(preco,2)%></td> 
                                            <td align="right"><%=formatnumber(totalLinha,2)%></td>                                          
                                        </tr>
                                    <% total = total +totalLinha  
                                        objResultCompra.movenext
                                        loop
                                    %>
                                    </tbody>
                                    <tfoot>
                                        <tr>
                                            <td align="right" colspan="6">Total:</td>				
                                            <td align="right" ><strong><%=formatnumber(total,2)%></strong></td>
                                        </tr>
                                    </tfoot>		
                                </table>
							</div>                        
					</div>
				</div> <!--fim span-->                    
            </div><!--fim row-->
        <%end if 'contratos venda %>




        </div><!--fim grid-->

  
</body>
</html>
<%
	 End If 
      FechaRecordSet objRS
	  FechaDBConn objConn
 End If 
 'athDebug strSQL, true '---para testes'
%>
