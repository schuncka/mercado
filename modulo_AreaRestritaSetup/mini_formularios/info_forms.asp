<html>
<head> 
	<title>Mercado</title>
	<!--#include file="../../_metroui/meta_css_js.inc"--> 
    <!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
	<script src="../../_scripts/scriptsCS.js"></script>
	<script src="../../_css/tabstyles.css"></script>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body class="metro" id="metrotablevista" >
<!-- FIM:BARRA  //-->
<div class="container padding20">
	<div class="frames">
		<div class="grid" style="border:0px solid #F00">  
		<table class="table striped hovered bordered">
		<thead>
			<tr>
			<td ><strong>FORMUL�RIO </strong></td>
			<td ><strong>FUN��ES </strong></td>
			<td ><strong>EXPOSITOR* </strong></td>
			<td ><strong>MONTADOR* </strong></td>
			</tr>
		</thead>
		<tbody>
			<tr>
			<td scope="row">form_autorizacao.asp</td>
			<td>
				<li> Cadastra e vincula montadora ao expositor logado.</li>
				<li> Envia e-mail para a montadora com dados de login.</li>
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_termo.asp</td>
			<td>
				<li> Expositor imprime o termo de responsabilidade com os dados da montadora apresentada no formul�rio form_autorizacao.asp
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_aceite_montadora.asp</td>
			<td>
				<li>Registra o aceite e imprime o termo de responsabilidade da montadora e do respectivo expositor.</li>
			</td>
			<td>n�o se aplica</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_credencial.asp</td>
			<td>
				<li> Insere pedido de credencial.</li>
				<li> Cria contato na empresa logada.</li>
				<li> C�lculo varia de acordo com setup ou regra espec�fica programada no form.</li>
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_energia.asp</td>
			<td>
				<li> Insere pedido de energia.</li>
				<li> C�lculo kva calculado  x vig�ncia de pre�o.</li>
				<li> Possui calculadora com c�lculo de desconto de KVA da energia b�sica que estiver cadastrada.</li>
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_geral.asp</td>
			<td>
				<li> Insere pedido de servi�os diversos.</li>
				<li> Permite habilitar campo de complemento texto.</li>
				<li> Permite habilitar campo de upload de arquivo.</li>
				<li> C�lculo atqde  x vig�ncia de pre�o.</li>
				<li> N�o possui nenhum c�lculo extra de desconto ou metragem.</li>      
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_geral_hora.asp</td>
			<td>
				<li> Insere pedido de servi�o baseado em horas.</li>  
				<li> C�lculo - total intervalo hs dos combos x qtde informada x vig�ncia de pre�o.</li>  
				<li> Formul�rio indicado para servi�os de RH baseados em carga hor�ria (seguran�a, recepcionista, copeira, etc).</li>  
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_metragem.asp</td>
			<td>
				<li> Insere pedido de servi�o baseado em metragem.</li>  
				<li> C�lculo Qtde fixa(metragem do estande) x vig�ncia de pre�o.</li>  
				<li> Formul�rio indicado para servi�os baseados em metragem (ex.: limpeza)</li>  
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_limpeza_montadora.asp</td>
			<td>
				<li> Insere pedido de servi�o baseado na METRAGEM de CADA expositor vinculado a montadora.</li>
				<li> C�lculo - Qtde fixa(metragem do estande de cada expositor)  x vig�ncia de pre�o.</li>
				<li> Formul�rio indicado para MONTADOR (Ex.: taxa de limpeza de montagem).</li>
			</td>
			<td>n�o se aplica</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_radio.asp</td>
			<td>
				<li> Insere pedido servi�o.</li>
                <li> C�lculo qtde  x vig�ncia de pre�o.</li>
                <li> Permite selecionar APENAS 1 dos servi�os vinculados ao formul�rio.</li>
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_regulamento.asp</td>
			<td>
				<li>Imprime texto/regulamento exibido no formul�rio com campos para dados de dados do respons�vel.</li>
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_catalogo.asp</td>
			<td>
				<li> Formul�rio com campos para preenchimento de dados de cat�logo do evento.</li>
                <li> Insere pedido de dados de cat�logo, com os dados informados em cada um dos campos do formul�rio.</li>
                <li> Formul�rio possui campos de acordo com cada cliente (personalizado).</li>
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_convite.asp</td>
			<td>
				<li> Insere pedido de convites vip (cadastrar servi�o e vincular ao fomrul�rio).</li>
                <li> Formul�rio com campos para encaminhamento da quantidade de convites solicitada.</li>
                <li> C�lculo qtde x  vig�ncia de pre�o</li>
                <li> Este Formul�rio n�o insere cadastro/credencial no sistema.</li>
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_convitevip.asp</td>
			<td>
				<li> Insere pedido de convites vip personalizados (dados de cada vip) - cadastrar servi�o e vincular ao formul�rio.</li>
                <li> Formul�rio com campos para encaminhamento e campos de informa��o dos convidados vip.</li>
                <li> Este Formul�rio n�o insere cadastro/credencial no sistema.</li>
			</td>
			<td class="text-center">X</td>
			<td>n�o se aplica</td>
			</tr>
		</tbody>
		</table>

		<div class="row"><br />
			<div class="text-center">
			<strong>(*) N�o utilizar os formul�rios no ambiente aonde N�O SE APLICA (montador x expositor)<br/>
					Formul�rios que n�o est�o listados aqui N�O DEVEM SER USADOS!</strong>
			</div>
		</div>
			
		</div>
	</div><!--FIM - FRAMES//-->
</div><!--FIM container //-->

</body>  
</html>
