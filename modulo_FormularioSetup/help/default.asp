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
    <h1><a href="_include_grade.asp" class="history-back"><i class="icon-arrow-left-3 fg-darker smaller"></i></a> M�dulo - Formulario Setup<small class="on-right"><!--//--></small></h1>
    <h3 class="fg-amber">Entendendo este m�dulo</h3>
    <div class="padding20 border">
        <p>Neste m�dulo � feita a configura��o de quais campos devem ser exibidos e quais s�o obrigat�rios no passo2(formulario de cadastro) na loja(EX:/shop, /shopex, /shoppj, /shoppj3).
		<br><br>
		<!--Estes campos s�o usados .//--></p>
       <!-- <div class="example">
            <div class="image selected span12" >
                <img src="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_painel_principal.png" >
            </div>
        </div>
        <p class="fg-gray"><a href="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_painel_principal.png" target="_blank">Na figura acima vemos um exemplo de painel 
		configurado com seus diferentes atalhos.</a></p>//-->
    </div>
    <div class="indent"></div>
    <h3 class="fg-amber">Acessando este m�dulo</h3>
	<div class="padding20 border">
       <p>Para acessar este m�dulo utilize o link: <u>http://pvista.proevento.com.br/(ambiente)/modulo_FormularioSetup/</u></p>
	</div>
	<div class="indent"></div>
    <h3 class="fg-amber">Utilizando este m�dulo</h3>
    <div class="padding20 border">
	<p>Ao acessar o m�dulo voc� ver� os campos associados ao uma grade mostrando os principais dados de configura��o de campos.</p>
	 <div class="padding20 border">
	<p class="item-title-secondary"><strong><u>Adicionando um CAMPO:</u></strong></p><br>
	<p>Para adicionar uma nova configur��o de campo  clique no bot�o ADICIONAR localizado no canto direito da p�gina.</p>
	<p>Uma nova janela (pop-up) se abrir� contendo duas abas distintas: GERAL e SETUP.
		<ul>
			<li>Na aba <strong>GERAL</strong> preenchemos as informa��es FORMULARIO/EVENTo:<br><br>
			        <p><strong class="text-info">COD.EVENTO:</strong>carrega o c�d do evento corrente dentro de uma combo listando todos c�d.eventos do sistema.</p>
			        <p><strong class="text-alert">TABELA:</strong> carrega do nome da tabela que ser� lida para gerar os campos.</p>
			        <p><strong class="text-warning">CAMPO:</strong> nome do campos que esta sendo configurado.</p>
			        <p><strong class="text-success">FORMULARIO/ETAPA:</strong> no FORMULARIO ser� setado o local onde os campos v�o ser configurados e na ETAPA  
					em que momento do cadastro eles v�o aparecer visto que uma cadastro ter mais de uma etapa.</p>
			</li>
			<br>
			<li>Na aba <strong>SETUP</strong> determinamos o VINCULOS/ORDEM:<br><br>
					<p><strong class="text-info">REQUERIDO/VINC.ENTIDADE:</strong> marcamos se sim ou n�o para garantir o requerimento e da mesma forma se existir� vinculo com
                    a entidade.</p>
    			    <p><strong class="text-alert">REQUERIDO COD.PAIS:</strong> no combo � direita definimos de qual tamanho ser� o �cone de atalho. Abaixo mostramos os tipos poss�veis:</p>
    			    <p><strong class="text-warning">ORDEM:</strong> atrav�s desta op��o configuramos a ordem de apresenta��o de cada campo dentro do formul�rio </p>					
                    <p>
					 <div class="example" align="center">
						<div class="image-container selected span10" >
		                <img src="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_formulariosetup_dialogs.jpg" >
        			    </div>
					 </div>
   				    <p class="fg-gray"><a href="http://192.168.1.8:83/_pvista/modulo_FormularioSetup/help/hlp_formulariosetup_dialogs.jpg" target="_blank">Na figura acima podemos vizualizar a dialog de Insert do m�dulo
                    e as duas guias com os campos de configura��o.</a></p>
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
O QU�...................................................................................................................................................10
 ONDE....................................................................................................................................................11
 COMO...................................................................................................................................................12
 QUANDO. ..................................................
//-->