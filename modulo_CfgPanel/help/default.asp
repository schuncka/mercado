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
    <h1><a href="_include_grade.asp" class="history-back"><i class="icon-arrow-left-3 fg-darker smaller"></i></a> Módulo - CFG Panel<small class="on-right"><!-- //--></small></h1>
    <h3 class="fg-amber">Entendendo este módulo</h3>
    <div class="padding20 border">
        <p>Neste módulo criamos e configuramos os principais atalhos para os demais módulos do sistema, que serão visualizados na tela inicial do mesmo.
		<br><br>
		Estes atalhos são chamados de <strong>TILE</strong> e podem ser configurados com tamanho, cor, ícones e links variados.</p>
        <div class="example" align="center">
            <div class="image-container selected span6">
                <img src="hlp_painel_principal.png" >
            </div>
        </div>
        <p class="fg-gray"><a href="hlp_painel_principal.png" target="_blank">Na figura acima vemos um exemplo de painel 
		configurado com seus diferentes atalhos.</a></p>
    </div>
    <div class="indent"></div>
    <h3 class="fg-amber">Utilizando este módulo</h3>
    <div class="padding20 border">
	<p>Ao acessar o módulo você verá a listagem de atalhos previamente criados, podendo pesquisar, alterar, deletar e adicionar novos atalhos.</p>
	<div class="padding20 border">
	<p class="item-title-secondary"><strong><u>Adicionando um atalho:</u></strong></p><br>
	<p>Para adicionar um atalho clique no botão ADICIONAR localizado no canto direito da página.</p>
	<p>Uma nova janela (pop-up) se abrirá contendo duas abas distintas: GERAL e LAYOUT.
		<ul>
			<li>Na aba <strong>GERAL</strong> preenchemos as informações relativas ao módulo que estamos apontando:<br><br>
			        <p><strong class="text-info">Rótulo:</strong> nome resumid do módulo que está sendo indicado e que ficará dentro do ícone/atalho(TILE).</p>
			        <p><strong class="text-alert">Descrição:</strong> nome completo ou breve descrição do módulo que aparecerá no hint(quando colocamos o mouse sobre o atalho).</p>
			        <p><strong class="text-warning">Link/Url:</strong> caminho(link) da página inicial do módulo indicado.</p>
			        <p><strong class="text-success">Parâmetros para Link/Url:</strong> neste campo, caso necessário, são colocadas as variáveis de ambiente (session) 
					que ao chegar a um módulo fornecem uma pré-seleção de dados.</p>
			</li>
			<br>
			<li>Na aba <strong>LAYOUT</strong> determinamos o aspecto, localização e tipo de atalho:<br><br>
					<p><strong class="text-info">Visualização:</strong> neste combo à esquerda definimos se o atalho será se visualização de todos(PUBLIC) ou apenas os 
					admisnitradores (PRIVATE). Atalhos PUBLIC são agrupados no meio da página e atalhos PRIVATE se localizam no canto direito.</p>
    			    <p><strong class="text-alert">Tipo:</strong> no combo à direita definimos de qual tamanho será o ícone de atalho. Abaixo mostramos os tipos possíveis:</p>
					<p>
					 <div class="example" align="center">
						<div class="image-container selected span6" >
		                	<img src="hlp_atalho_tamanhos.jpg" >
        			    </div>
					 </div>
   				    <p class="fg-gray"><a href="hlp_atalho_tamanhos.jpg" target="_blank">Na figura acima vemos os possíveis tamanhos de atalho.</a></p>
					</p><br>					
			        <p><strong class="text-warning">Ícone:</strong> define o ícone que o atalho receberá e deve ser escolhido de acordo com o significado do módulo em questão.</p>
				    <p><strong class="text-success">Cor:</strong> neste combo deve se escolher a cor do atalho, buscando mater um padrão de tonalidade de acordo com o agrupamento feito. </p>
			        <p><strong class="text-info">Ordem:</strong> define a localização dentro da sequência/ordem de atalhos do grupo selecionado(PRIVATE/PUBLIC).</p>
			        <p><strong class="text-alert">Situação:</strong> marcação para habilitar(Ativo) e desabilitar(Inativo) atalhos da tela inicial.</p>			
			</li>
		</ul>	
	</div>
	</div>
</div>
</body>
</html>

<!--
 O QUÊ....................................................10
 ONDE.....................................................11
 COMO.....................................................12
 QUANDO. ..................................................
//-->