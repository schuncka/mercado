<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<% Response.Expires = 0 %>
<html>
<head>
	<title>ProEvento <%=Session("NOME_EVENTO")%> </title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<link href="../_css/csm.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#FFFFFF" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
	
    <table width="100%" cellpadding="5" cellspacing="1" border="1">
    	<tr bgcolor="#999999" >
        	<td><strong>FORMULÁRIO</strong></td>
        	<td><strong>FUNÇÕES</strong></td>                                    
        	<td align="center"><strong>EXPOSITOR*</strong></td>
        	<td align="center"><strong>MONTADOR*</strong></td>
        </tr>
        
		<tr>
        	<td>form_autorizacao.asp</td>
        	<td>
            	<li> Cadastra e vincula montadora ao expositor logado.
                <li> Envia e-mail para a montadora com dados de login.
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr> 
		<tr bgcolor="#CCCCCC">
        	<td>form_termo.asp</td>
        	<td>
            	<li> Expositor imprime o termo de responsabilidade com os dados da montadora apresentada no formulário form_autorizacao.asp
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr>         
		<tr>
        	<td>form_aceite_montadora.asp</td>
        	<td>
            	<li> Registra o aceite e imprime o termo de responsabilidade da montadora e do respectivo expositor.
            </td>
        	<td align="center">(não se aplica)</td>
        	<td align="center">X</td>                                    
        </tr>           
		<tr bgcolor="#CCCCCC">
        	<td>form_credencial.asp</td>
        	<td>
            	<li> Insere pedido de credencial.
                <li> Cria contato na empresa logada.
                <li> Cálculo varia de acordo com setup ou regra específica programada no form.
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr> 
		<tr>
        	<td>form_energia.asp</td>
        	<td>
            	<li> Insere pedido de energia.
                <li> Cálculo kva calculado  x vigência de preço.
                <li> Possui calculadora com cálculo de desconto de KVA da energia básica que estiver cadastrada.
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr>  
		<tr bgcolor="#CCCCCC">
        	<td>form_geral.asp</td>
        	<td>
            	<li> Insere pedido de serviços diversos.
                <li> Permite habilitar campo de complemento texto.
                <li> Permite habilitar campo de upload de arquivo.
                <li> Cálculo atqde  x vigência de preço.
                <li> Não possui nenhum cálculo extra de desconto ou metragem.              
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr>
		<tr>
        	<td>form_geral_hora.asp</td>
        	<td>
            	<li> Insere pedido de serviço baseado em horas.
                <li> Cálculo - total intervalo hs dos combos x qtde informada x vigência de preço.
                <li> Formulário indicado para serviços de RH baseados em carga horária (segurança, recepcionista, copeira, etc).
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr>
		<tr bgcolor="#CCCCCC">
        	<td>form_metragem.asp</td>
        	<td>
            	<li> Insere pedido de serviço baseado em metragem.
                <li> Cálculo Qtde fixa(metragem do estande) x vigência de preço.
                <li> Formulário indicado para serviços baseados em metragem (ex.: limpeza)
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr>                                 
		<tr>
        	<td>form_limpeza_montadora.asp</td>
        	<td>
            	<li> Insere pedido de serviço baseado na METRAGEM de CADA expositor vinculado a montadora.
                <li> Cálculo - Qtde fixa(metragem do estande de cada expositor)  x vigência de preço.
                <li> Formulário indicado para MONTADOR (Ex.: taxa de limpeza de montagem).
            </td>
        	<td align="center">(não se aplica)</td>
        	<td align="center">X</td>                                    
        </tr>                                                        
		<tr bgcolor="#CCCCCC">
        	<td>form_radio.asp</td>
        	<td>
            	<li> Insere pedido serviço.
                <li> Cálculo qtde  x vigência de preço.
                <li> Permite selecionar APENAS 1 dos serviços vinculados ao formulário.
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr>
		<tr>
        	<td>form_regulamento.asp</td>
        	<td>
            	<li>Imprime texto/regulamento exibido no formulário com campos para dados de dados do responsável.
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr>   
		<tr bgcolor="#CCCCCC">
        	<td>form_catalogo.asp</td>
        	<td>
            	<li> Formulário com campos para preenchimento de dados de catálogo do evento.
                <li> Insere pedido de dados de catálogo, com os dados informados em cada um dos campos do formulário.
                <li> Formulário possui campos de acordo com cada cliente (personalizado).
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr> 
		<tr>
        	<td>form_convite.asp</td>
        	<td>
            	<li> Insere pedido de convites vip (cadastrar serviço e vincular ao fomrulário).
                <li> Formulário com campos para encaminhamento da quantidade de convites solicitada.
                <li> Cálculo qtde x  vigência de preço
                <li> Este Formulário não insere cadastro/credencial no sistema.
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr>        
		<tr bgcolor="#CCCCCC">
        	<td>form_convitevip.asp</td>
        	<td>
            	<li> Insere pedido de convites vip personalizados (dados de cada vip) - cadastrar serviço e vincular ao formulário.
                <li> Formulário com campos para encaminhamento e campos de informação dos convidados vip.
                <li> Este Formulário não insere cadastro/credencial no sistema.
            </td>
        	<td align="center">X</td>
        	<td align="center">(não se aplica)</td>                                    
        </tr>
		<tr>
        	<td colspan="4" align="center">
            	<br><strong>(*) Não utilizar os formulários no ambiente aonde NÃO SE APLICA (montador x expositor)
            	<br><br>Formulários que não estão listados aqui NÃO DEVEM SER USADOS!</strong><br><br>
            </td>                                    
        </tr>                                          
	</table>
    
</body>
</html>
