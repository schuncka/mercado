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
        	<td><strong>FORMUL�RIO</strong></td>
        	<td><strong>FUN��ES</strong></td>                                    
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
        	<td align="center">(n�o se aplica)</td>                                    
        </tr> 
		<tr bgcolor="#CCCCCC">
        	<td>form_termo.asp</td>
        	<td>
            	<li> Expositor imprime o termo de responsabilidade com os dados da montadora apresentada no formul�rio form_autorizacao.asp
            </td>
        	<td align="center">X</td>
        	<td align="center">(n�o se aplica)</td>                                    
        </tr>         
		<tr>
        	<td>form_aceite_montadora.asp</td>
        	<td>
            	<li> Registra o aceite e imprime o termo de responsabilidade da montadora e do respectivo expositor.
            </td>
        	<td align="center">(n�o se aplica)</td>
        	<td align="center">X</td>                                    
        </tr>           
		<tr bgcolor="#CCCCCC">
        	<td>form_credencial.asp</td>
        	<td>
            	<li> Insere pedido de credencial.
                <li> Cria contato na empresa logada.
                <li> C�lculo varia de acordo com setup ou regra espec�fica programada no form.
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr> 
		<tr>
        	<td>form_energia.asp</td>
        	<td>
            	<li> Insere pedido de energia.
                <li> C�lculo kva calculado  x vig�ncia de pre�o.
                <li> Possui calculadora com c�lculo de desconto de KVA da energia b�sica que estiver cadastrada.
            </td>
        	<td align="center">X</td>
        	<td align="center">(n�o se aplica)</td>                                    
        </tr>  
		<tr bgcolor="#CCCCCC">
        	<td>form_geral.asp</td>
        	<td>
            	<li> Insere pedido de servi�os diversos.
                <li> Permite habilitar campo de complemento texto.
                <li> Permite habilitar campo de upload de arquivo.
                <li> C�lculo atqde  x vig�ncia de pre�o.
                <li> N�o possui nenhum c�lculo extra de desconto ou metragem.              
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr>
		<tr>
        	<td>form_geral_hora.asp</td>
        	<td>
            	<li> Insere pedido de servi�o baseado em horas.
                <li> C�lculo - total intervalo hs dos combos x qtde informada x vig�ncia de pre�o.
                <li> Formul�rio indicado para servi�os de RH baseados em carga hor�ria (seguran�a, recepcionista, copeira, etc).
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr>
		<tr bgcolor="#CCCCCC">
        	<td>form_metragem.asp</td>
        	<td>
            	<li> Insere pedido de servi�o baseado em metragem.
                <li> C�lculo Qtde fixa(metragem do estande) x vig�ncia de pre�o.
                <li> Formul�rio indicado para servi�os baseados em metragem (ex.: limpeza)
            </td>
        	<td align="center">X</td>
        	<td align="center">(n�o se aplica)</td>                                    
        </tr>                                 
		<tr>
        	<td>form_limpeza_montadora.asp</td>
        	<td>
            	<li> Insere pedido de servi�o baseado na METRAGEM de CADA expositor vinculado a montadora.
                <li> C�lculo - Qtde fixa(metragem do estande de cada expositor)  x vig�ncia de pre�o.
                <li> Formul�rio indicado para MONTADOR (Ex.: taxa de limpeza de montagem).
            </td>
        	<td align="center">(n�o se aplica)</td>
        	<td align="center">X</td>                                    
        </tr>                                                        
		<tr bgcolor="#CCCCCC">
        	<td>form_radio.asp</td>
        	<td>
            	<li> Insere pedido servi�o.
                <li> C�lculo qtde  x vig�ncia de pre�o.
                <li> Permite selecionar APENAS 1 dos servi�os vinculados ao formul�rio.
            </td>
        	<td align="center">X</td>
        	<td align="center">X</td>                                    
        </tr>
		<tr>
        	<td>form_regulamento.asp</td>
        	<td>
            	<li>Imprime texto/regulamento exibido no formul�rio com campos para dados de dados do respons�vel.
            </td>
        	<td align="center">X</td>
        	<td align="center">(n�o se aplica)</td>                                    
        </tr>   
		<tr bgcolor="#CCCCCC">
        	<td>form_catalogo.asp</td>
        	<td>
            	<li> Formul�rio com campos para preenchimento de dados de cat�logo do evento.
                <li> Insere pedido de dados de cat�logo, com os dados informados em cada um dos campos do formul�rio.
                <li> Formul�rio possui campos de acordo com cada cliente (personalizado).
            </td>
        	<td align="center">X</td>
        	<td align="center">(n�o se aplica)</td>                                    
        </tr> 
		<tr>
        	<td>form_convite.asp</td>
        	<td>
            	<li> Insere pedido de convites vip (cadastrar servi�o e vincular ao fomrul�rio).
                <li> Formul�rio com campos para encaminhamento da quantidade de convites solicitada.
                <li> C�lculo qtde x  vig�ncia de pre�o
                <li> Este Formul�rio n�o insere cadastro/credencial no sistema.
            </td>
        	<td align="center">X</td>
        	<td align="center">(n�o se aplica)</td>                                    
        </tr>        
		<tr bgcolor="#CCCCCC">
        	<td>form_convitevip.asp</td>
        	<td>
            	<li> Insere pedido de convites vip personalizados (dados de cada vip) - cadastrar servi�o e vincular ao formul�rio.
                <li> Formul�rio com campos para encaminhamento e campos de informa��o dos convidados vip.
                <li> Este Formul�rio n�o insere cadastro/credencial no sistema.
            </td>
        	<td align="center">X</td>
        	<td align="center">(n�o se aplica)</td>                                    
        </tr>
		<tr>
        	<td colspan="4" align="center">
            	<br><strong>(*) N�o utilizar os formul�rios no ambiente aonde N�O SE APLICA (montador x expositor)
            	<br><br>Formul�rios que n�o est�o listados aqui N�O DEVEM SER USADOS!</strong><br><br>
            </td>                                    
        </tr>                                          
	</table>
    
</body>
</html>
