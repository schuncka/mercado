<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_database/secure.asp"-->
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista" onUnload="SaveData()" onLoad="LoadData()">
<div class="page container">
    <h1><a href="_include_grade.asp" class="history-back"><i class="icon-arrow-left-3 fg-darker smaller"></i></a> Módulo - Formulario Setup<small class="on-right"><!--//--></small></h1>
    <h3 class="fg-amber">Entendendo este módulo</h3>
    <div class="padding20 border">
        <p>Neste módulo é feita a configuração de quais campos devem ser exibidos e quais são obrigatórios no passo2(formulario de cadastro) na loja(EX:/shop, /shopex, /shoppj, /shoppj3).
		<br><br>
		<!--Estes campos são usados .//--></p>
       <!-- <div class="example">
            <div class="image selected span12" >
                <img src="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_painel_principal.png" >
            </div>
        </div>
        <p class="fg-gray"><a href="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_painel_principal.png" target="_blank">Na figura acima vemos um exemplo de painel 
		configurado com seus diferentes atalhos.</a></p>//-->
    </div>
    <div class="indent"></div>
    <h3 class="fg-amber">Acessando este módulo</h3>
	<div class="padding20 border">
       <p>Para acessar este módulo utilize o link: <u>http://pvista.proevento.com.br/(ambiente)/modulo_FormularioSetup/</u></p>
	</div>
	<div class="indent"></div>
    <h3 class="fg-amber">Utilizando este módulo</h3>
    <div class="padding20 border">
	<p>Ao acessar o módulo você verá os campos associados ao uma grade mostrando os principais dados de configuração de campos.</p>
	 <div class="padding20 border">
	<p class="item-title-secondary"><strong><u>Adicionando um CAMPO:</u></strong></p><br>
	<p>Para adicionar uma nova configurção de campo  clique no botão ADICIONAR localizado no canto direito da página.</p>
	<p>Uma nova janela (pop-up) se abrirá contendo duas abas distintas: GERAL e SETUP.
		<ul>
			<li>Na aba <strong>GERAL</strong> preenchemos as informações FORMULARIO/EVENTo:<br><br>
			        <p><strong class="text-info">COD.EVENTO:</strong>carrega o cód do evento corrente dentro de uma combo listando todos cód.eventos do sistema.</p>
			        <p><strong class="text-alert">TABELA:</strong> carrega do nome da tabela que será lida para gerar os campos.</p>
			        <p><strong class="text-warning">CAMPO:</strong> nome do campos que esta sendo configurado.</p>
			        <p><strong class="text-success">FORMULARIO/ETAPA:</strong> no FORMULARIO será setado o local onde os campos vão ser configurados e na ETAPA  
					em que momento do cadastro eles vão aparecer visto que uma cadastro ter mais de uma etapa.</p>
			</li>
			<br>
			<li>Na aba <strong>SETUP</strong> determinamos o VINCULOS/ORDEM:<br><br>
					<p><strong class="text-info">REQUERIDO/VINC.ENTIDADE:</strong> marcamos se sim ou não para garantir o requerimento e da mesma forma se existirá vinculo com
                    a entidade.</p>
    			    <p><strong class="text-alert">REQUERIDO COD.PAIS:</strong> no combo à direita definimos de qual tamanho será o ícone de atalho. Abaixo mostramos os tipos possíveis:</p>
    			    <p><strong class="text-warning">ORDEM:</strong> através desta opção configuramos a ordem de apresentação de cada campo dentro do formulário </p>					
                    <p>
					 <div class="example" align="center">
						<div class="image-container selected span10" >
		                <img src="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_formulariosetup_dialogs.jpg" >
        			    </div>
					 </div>
   				    <p class="fg-gray"><a href="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_formulariosetup_dialogs.jpg" target="_blank">Na figura acima podemos vizualizar a dialog de Insert do módulo
                    e as duas guias com os campos de configuração.</a></p>
					</p><br>							
			</li>
		</ul>	
	</div>
   <div class="indent"></div>
	</div>
</div>
</body>
</html>

<!--
O QUÊ...................................................................................................................................................10
 ONDE....................................................................................................................................................11
 COMO...................................................................................................................................................12
 QUANDO. ..................................................
//-->