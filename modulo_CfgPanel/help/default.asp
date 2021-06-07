<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista">
<div class="page container">
    <h1><a href="_include_grade.asp" class="history-back"><i class="icon-arrow-left-3 fg-darker smaller"></i></a> M�dulo - CFG Panel<small class="on-right"><!-- //--></small></h1>
    <h3 class="fg-amber">Entendendo este m�dulo</h3>
    <div class="padding20 border">
        <p>Neste m�dulo criamos e configuramos os principais atalhos para os demais m�dulos do sistema, que ser�o visualizados na tela inicial do mesmo.
		<br><br>
		Estes atalhos s�o chamados de <strong>TILE</strong> e podem ser configurados com tamanho, cor, �cones e links variados.</p>
        <div class="example" align="center">
            <div class="image-container selected span6">
                <img src="hlp_painel_principal.png" >
            </div>
        </div>
        <p class="fg-gray"><a href="hlp_painel_principal.png" target="_blank">Na figura acima vemos um exemplo de painel 
		configurado com seus diferentes atalhos.</a></p>
    </div>
    <div class="indent"></div>
    <h3 class="fg-amber">Utilizando este m�dulo</h3>
    <div class="padding20 border">
	<p>Ao acessar o m�dulo voc� ver� a listagem de atalhos previamente criados, podendo pesquisar, alterar, deletar e adicionar novos atalhos.</p>
	<div class="padding20 border">
	<p class="item-title-secondary"><strong><u>Adicionando um atalho:</u></strong></p><br>
	<p>Para adicionar um atalho clique no bot�o ADICIONAR localizado no canto direito da p�gina.</p>
	<p>Uma nova janela (pop-up) se abrir� contendo duas abas distintas: GERAL e LAYOUT.
		<ul>
			<li>Na aba <strong>GERAL</strong> preenchemos as informa��es relativas ao m�dulo que estamos apontando:<br><br>
			        <p><strong class="text-info">R�tulo:</strong> nome resumid do m�dulo que est� sendo indicado e que ficar� dentro do �cone/atalho(TILE).</p>
			        <p><strong class="text-alert">Descri��o:</strong> nome completo ou breve descri��o do m�dulo que aparecer� no hint(quando colocamos o mouse sobre o atalho).</p>
			        <p><strong class="text-warning">Link/Url:</strong> caminho(link) da p�gina inicial do m�dulo indicado.</p>
			        <p><strong class="text-success">Par�metros para Link/Url:</strong> neste campo, caso necess�rio, s�o colocadas as vari�veis de ambiente (session) 
					que ao chegar a um m�dulo fornecem uma pr�-sele��o de dados.</p>
			</li>
			<br>
			<li>Na aba <strong>LAYOUT</strong> determinamos o aspecto, localiza��o e tipo de atalho:<br><br>
					<p><strong class="text-info">Visualiza��o:</strong> neste combo � esquerda definimos se o atalho ser� se visualiza��o de todos(PUBLIC) ou apenas os 
					admisnitradores (PRIVATE). Atalhos PUBLIC s�o agrupados no meio da p�gina e atalhos PRIVATE se localizam no canto direito.</p>
    			    <p><strong class="text-alert">Tipo:</strong> no combo � direita definimos de qual tamanho ser� o �cone de atalho. Abaixo mostramos os tipos poss�veis:</p>
					<p>
					 <div class="example" align="center">
						<div class="image-container selected span6" >
		                	<img src="hlp_atalho_tamanhos.jpg" >
        			    </div>
					 </div>
   				    <p class="fg-gray"><a href="hlp_atalho_tamanhos.jpg" target="_blank">Na figura acima vemos os poss�veis tamanhos de atalho.</a></p>
					</p><br>					
			        <p><strong class="text-warning">�cone:</strong> define o �cone que o atalho receber� e deve ser escolhido de acordo com o significado do m�dulo em quest�o.</p>
				    <p><strong class="text-success">Cor:</strong> neste combo deve se escolher a cor do atalho, buscando mater um padr�o de tonalidade de acordo com o agrupamento feito. </p>
			        <p><strong class="text-info">Ordem:</strong> define a localiza��o dentro da sequ�ncia/ordem de atalhos do grupo selecionado(PRIVATE/PUBLIC).</p>
			        <p><strong class="text-alert">Situa��o:</strong> marca��o para habilitar(Ativo) e desabilitar(Inativo) atalhos da tela inicial.</p>			
			</li>
		</ul>	
	</div>
	</div>
</div>
</body>
</html>

<!--
 O QU�....................................................10
 ONDE.....................................................11
 COMO.....................................................12
 QUANDO. ..................................................
//-->