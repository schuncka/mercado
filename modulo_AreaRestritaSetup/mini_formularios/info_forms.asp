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
			<td ><strong>FORMULÁRIO </strong></td>
			<td ><strong>FUNÇÕES </strong></td>
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
			<td>não se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_termo.asp</td>
			<td>
				<li> Expositor imprime o termo de responsabilidade com os dados da montadora apresentada no formulário form_autorizacao.asp
			</td>
			<td class="text-center">X</td>
			<td>não se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_aceite_montadora.asp</td>
			<td>
				<li>Registra o aceite e imprime o termo de responsabilidade da montadora e do respectivo expositor.</li>
			</td>
			<td>não se aplica</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_credencial.asp</td>
			<td>
				<li> Insere pedido de credencial.</li>
				<li> Cria contato na empresa logada.</li>
				<li> Cálculo varia de acordo com setup ou regra específica programada no form.</li>
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_energia.asp</td>
			<td>
				<li> Insere pedido de energia.</li>
				<li> Cálculo kva calculado  x vigência de preço.</li>
				<li> Possui calculadora com cálculo de desconto de KVA da energia básica que estiver cadastrada.</li>
			</td>
			<td class="text-center">X</td>
			<td>não se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_geral.asp</td>
			<td>
				<li> Insere pedido de serviços diversos.</li>
				<li> Permite habilitar campo de complemento texto.</li>
				<li> Permite habilitar campo de upload de arquivo.</li>
				<li> Cálculo atqde  x vigência de preço.</li>
				<li> Não possui nenhum cálculo extra de desconto ou metragem.</li>      
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_geral_hora.asp</td>
			<td>
				<li> Insere pedido de serviço baseado em horas.</li>  
				<li> Cálculo - total intervalo hs dos combos x qtde informada x vigência de preço.</li>  
				<li> Formulário indicado para serviços de RH baseados em carga horária (segurança, recepcionista, copeira, etc).</li>  
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_metragem.asp</td>
			<td>
				<li> Insere pedido de serviço baseado em metragem.</li>  
				<li> Cálculo Qtde fixa(metragem do estande) x vigência de preço.</li>  
				<li> Formulário indicado para serviços baseados em metragem (ex.: limpeza)</li>  
			</td>
			<td class="text-center">X</td>
			<td>não se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_limpeza_montadora.asp</td>
			<td>
				<li> Insere pedido de serviço baseado na METRAGEM de CADA expositor vinculado a montadora.</li>
				<li> Cálculo - Qtde fixa(metragem do estande de cada expositor)  x vigência de preço.</li>
				<li> Formulário indicado para MONTADOR (Ex.: taxa de limpeza de montagem).</li>
			</td>
			<td>não se aplica</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_radio.asp</td>
			<td>
				<li> Insere pedido serviço.</li>
                <li> Cálculo qtde  x vigência de preço.</li>
                <li> Permite selecionar APENAS 1 dos serviços vinculados ao formulário.</li>
			</td>
			<td class="text-center">X</td>
			<td class="text-center">X</td>
			</tr>
			<tr>
			<td scope="row">form_regulamento.asp</td>
			<td>
				<li>Imprime texto/regulamento exibido no formulário com campos para dados de dados do responsável.</li>
			</td>
			<td class="text-center">X</td>
			<td>não se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_catalogo.asp</td>
			<td>
				<li> Formulário com campos para preenchimento de dados de catálogo do evento.</li>
                <li> Insere pedido de dados de catálogo, com os dados informados em cada um dos campos do formulário.</li>
                <li> Formulário possui campos de acordo com cada cliente (personalizado).</li>
			</td>
			<td class="text-center">X</td>
			<td>não se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_convite.asp</td>
			<td>
				<li> Insere pedido de convites vip (cadastrar serviço e vincular ao fomrulário).</li>
                <li> Formulário com campos para encaminhamento da quantidade de convites solicitada.</li>
                <li> Cálculo qtde x  vigência de preço</li>
                <li> Este Formulário não insere cadastro/credencial no sistema.</li>
			</td>
			<td class="text-center">X</td>
			<td>não se aplica</td>
			</tr>
			<tr>
			<td scope="row">form_convitevip.asp</td>
			<td>
				<li> Insere pedido de convites vip personalizados (dados de cada vip) - cadastrar serviço e vincular ao formulário.</li>
                <li> Formulário com campos para encaminhamento e campos de informação dos convidados vip.</li>
                <li> Este Formulário não insere cadastro/credencial no sistema.</li>
			</td>
			<td class="text-center">X</td>
			<td>não se aplica</td>
			</tr>
		</tbody>
		</table>

		<div class="row"><br />
			<div class="text-center">
			<strong>(*) Não utilizar os formulários no ambiente aonde NÃO SE APLICA (montador x expositor)<br/>
					Formulários que não estão listados aqui NÃO DEVEM SER USADOS!</strong>
			</div>
		</div>
			
		</div>
	</div><!--FIM - FRAMES//-->
</div><!--FIM container //-->

</body>  
</html>
