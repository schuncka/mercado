<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<html>
<head>
<title>Mercado</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista" onUnload="SaveData()" onLoad="LoadData()">
<div class="page container">
    <h1><a href="_include_grade.asp" class="history-back"><i class="icon-arrow-left-3 fg-darker smaller"></i></a> Módulo - SITE Info<small class="on-right"><!--//--></small></h1>
    <h3 class="fg-amber">Entendendo este módulo</h3>
    <div class="padding20 border">
        <p>Este módulo é composto de uma tabela *container, ou seja, uma tabela que permite a configuração de campos "chave"(aqui chamados de cod.info) e seus respectivos valores, desta forma estas configurações estarão todas ligadas ao ambiente em questão e seus valores utilizados em diversos pontos do sistema.
		<br><br>
		Na figura abaixo vemos um exemplo utilização do módulo onde a informação do site  
		é passada para outra página(neste caso "LOGOMARCA" sera lida na página de BRINDE) fazendo com que a imagem seja carregada automaticamente no ambiente do cliente sempre que necessário.
        <div class="example" align="center">
            <div class="image-container selected span6">
                <img src="hlp_ex_brinde_site_info2.png" >
            </div>
        </div>
        <p class="fg-gray"><a href="hlp_ex_brinde_site_info2.png" target="_blank">Na figura acima vemos um exemplo de painel 
		configurado com seus diferentes atalhos.</a></p>
    </div>
    <div class="indent"></div>
    <h3 class="fg-amber">Acessando este módulo</h3>
	<div class="padding20 border">
       <p>Para acessar este módulo utilize o link: <u>http://pvista.proevento.com.br/(ambiente)/modulo_SiteInfo/</u></p>
	</div>
	<div class="indent"></div>
    <h3 class="fg-amber">Utilizando este módulo</h3>
    <div class="padding20 border">
	<p>Ao acessar o módulo você verá a lista de código informativos previamente criados, podendo pesquisar, alterar, deletar e adicionar novos Cod.Info(s).</p>
	 <div class="padding20 border">
	<p class="item-title-secondary"><strong><u>Adicionando um Cod.Info:</u></strong></p><br>
	<p>Para adicionar um cod.info clique no botão ADICIONAR localizado no canto direito da página.</p>
	<p>Uma nova janela (pop-up) se abrirá contendo duas abas distintas: GERAL .
		<ul>
			<li>Na aba <strong>GERAL</strong> preenchemos as informações relativas ao módulo que estamos apontando:<br><br>
			        <p><strong class="text-info">Cod.Info:</strong>nome do código informativo do sistema.</p>
                    	<p>
        <span class="tertiary-text-secondary">
       
        <ul class="tertiary-text-secondary">
              <li><strong>CLIENTE:</strong>CÓDIGO PARA CARREGAR INFORMAÇÕES DO CLIENTE<br>
            </li>
            <li><strong>CNPJ:</strong>CÓDIGO PARA CARREGAR O CNPJ<br>
            </li>
            <li><strong>CONTATO:</strong>CÓDIGO PARA CARREGAR CONTATO DO CLIENTE<br>
            </li>
             <li><strong>CONTRATO:</strong>CÓDIGO PARA CARREGAR INFORMAÇÕES DO CONTRATO<br>
            </li>
            <li><strong>CPF:</strong>CÓDIGO PARA CARREGAR O CPF DO CLIENTE<br>
            </li>
            <li><strong>DATABASE:</strong>CÓDIGO PARA CARREGAR INFORMAÇÕES DO BANCO DE DADOS<br>
            </li>
            <li><strong>DOMINIO:</strong>CÓDIGO PARA CARREGAR INFORMAÇÕES DO DOMINIO<br>
            </li>
            <li><strong>DT_PUBLICACAO:</strong>CÓDIGO PARA CARREGAR INFORMAÇÕES DO DATA DE PUBLICACAO<br>
            </li>
            <li><strong>GERENTE:</strong>CÓDIGO PARA CARREGAR INFORMAÇÕES DO GERENTE<br>
            </li>
             <li><strong>HOSTING:</strong>CÓDIGO PARA CARREGAR INFORMAÇÕES DO HOSTING<br>
            </li>
            <li><strong>TOTEM:</strong> ESTE CÓDIGO PODER SER CONFIGURADO COM CPF;CNPJ;INSCRICAO;[CODBARRA ou SCRAMBLE_CODBARRA]<br>
            (localização -  http://pvista.proevento.com.br/[cliente]/totem/)
            </li>
            <li><strong>TOTEM_CONGRESSOS:</strong> ESTE CÓDIGO PODER SER CONFIGURADO COM CPF;CNPJ;INSCRICAO;NOME<br>
            (localização -  http://pvista.proevento.com.br/[cliente]/totem_congresso/)
            </li>
            <li><strong>TOTEM_VISITANTE:</strong> ESTE CÓDIGO PODER SER CONFIGURADO COM CPF;CNPJ;[CODBARRA ou SCRAMBLE_CODBARRA]<br>
            (localização -  http://pvista.proevento.com.br/[cliente]/totem_visitante/)
            </li>
            <li><strong>CFG_IDEMPRESA:</strong>CÓDIGO IDENTIFICADOR DA EMPRESA<br>
            </li>
            <li><strong>CFG_IDCLIENTE:</strong>CÓDIGO IDENTIFICADOR DO CLIENTE<br>
            </li>
            <li><strong>CFG_SIZE_LABEL_NOME:</strong>CÓDIGO PARA CARREGAR DADOS O TAMANHO DO ROTULO NO CAMPO NOME<br>
            </li>
            <li><strong>CFG_SIZE_LABEL_EMPRESA:</strong>CÓDIGO PARA CARREGAR DADOS O TAMANHO DO ROTULO NO CAMPO EMPRESA<br>
            </li>
            <li><strong>CFG_MAXLEN_LABEL_NOME:</strong>CÓDIGO PARA CARREGAR MÁXIMO DE DADOS DO ROTULO NO CAMPO NOME<br>
            </li>
            <li><strong>CFG_MAXLEN_LABEL_EMPRESA:</strong>CÓDIGO PARA CARREGAR MÁXIMO DE DADOS DO ROTULO NO CAMPO EMPRESA<br>
            </li>
             <li><strong>INSC_EXPRESSA_PGTO_ONLINE:</strong>SERVER PARA EXIBIR O LINK DO PAGAMENTO ADICIONAL AO VALOR DO SALDO.
			QUANDO ESTE PARÂMENTRO ESTÁ COM O VALOR "EXIBIR" E O SALDO A PAGAR ESTÁ MAIOR QUE 0,00 ENTÃO A IMAGEM DO "CAIXA" SE TORNA LINK PARA CHAMAMDA DA FORMA DE PAGAMENTE ONLINE DA LOJA.</li>
             

            <li><strong>PAX_CADASTRO:</strong> ESTE CÓDIGO PODER SER CONFIGURADO COM [EXIBIR][EDITAR][HOMOLOGAR][]-  campo quando vazio n&atilde;o exibe o bloco de dados cadastrais na &aacute;rea do PAX<br>
            (localização -  http://pvista.proevento.com.br/[cliente]/pax/)
            </li>
             
             <li><strong>PAX_CADASTRO_EMAIL:</strong> E-MAIL PARA AONDE VÃO AVISOS DISPARADOS POR AÇÕES NO PAX</strong></li>
             <li><strong>PAX_EMAIL_SENDER:</strong> E-MAIL SENDER DO PAX</strong></li>
             <li><strong>PAX_EMAIL_AUDITORIA_PROEVENTO:</strong> E-MAIL DE AUDITORIA DA PROEVENTO NO PAX</strong></li>
             <li><strong>PAX_EMAIL_AUDITORIA_CLIENTE:</strong> E-MAIL DE AUDITORIA DO CLIENTE NO PAX</strong></li>     
             <li><strong>PAX_VALIDA_SENHA:</strong> HABILITA SIM [TRUE] OU NÃO [FALSE] O CAMPO SENHA NO LOGIN DO PAX</strong></li>             
             
             <li><strong>TOTEM_IMPRIMIR_VISITANTE:</strong> ESTE C&Oacute;DIGO PODE SER CONFIGURADO COM [TRUE ou FALSE] PARA PERMITIR A IMPRESS&Atilde;O DE CREDENCIAL DE <em>VISITANTE</em> NO TOTEM</li>
             <li><strong>TOTEM_IMPRIMIR_CONGRESSISTA:</strong> ESTE C&Oacute;DIGO PODE SER CONFIGURADO COM [TRUE ou FALSE] PARA PERMITIR A IMPRESS&Atilde;O DE CREDENCIAL DE <em>CONGRESSISTA</em> NO TOTEM</li>
             <li><strong>TOTEM_TEMPO_LIMITE_REIMPRESSAO:</strong> YES/SIM (CONTROLE O LIMITE DE IMPRESS&Atilde;O POR DIA, A CADA NOVO DIA PODE REIMPRIMIR CONSIDERANDO OS MINUTOS DO TEMPO LIMITE) E NULL OU NO/NAO O CONTROLE &Eacute; GERAL, SE J&Aacute; IMPRIMIU N&Atilde;O IMPRIME MAIS, EXCETO DENTRO DO TEMPO LIMITE DE REIMPRESS&Atilde;O.</li>
             <li><strong>TOTEM_TEMPO_LIMITE_REIMPRESSAO_DIARIO:</strong> ESTE C&Oacute;DIGO PODE SER CONFIGURADO COM UM VALOR </li>
             <li><strong>BRINDE_IMPRIMIR_VOUCHER:</strong> ESTE C&Oacute;DIGO PODE SER CONFIGURADO COM [TRUE ou FALSE] PARA PERMITIR A IMPRESS&Atilde;O DE VOUCHER NO M&Oacute;DULO DE BRINDE<br>
             </li>
             <li><strong>SRF_PESQUISA_CNPJ:</strong> ESTE CÓDIGO É CONFIGURADO PARA PERMITIR A EXECUÇÃO DA CHAMADA EXTERNA DA SERASA PARA PESQUISA DE CADASTRO DE PESSOA JURÍDICA PELO CNPJ: [ONDEMAND ou REQUEST]</li>
             <li><strong>SRF_USER:</strong> USUÁRIO PARA A EXECUÇÃO DA CHAMADA EXTERNA DA SERASA PARA PESQUISA DE CADASTRO DE PESSOA JURÍDICA PELO CNPJ</li>
             <li><strong>SRF_PASSWORD:</strong> SENHA PARA A EXECUÇÃO DA CHAMADA EXTERNA DA SERASA PARA PESQUISA DE CADASTRO DE PESSOA JURÍDICA PELO CNPJ</li>
        </ul>
        </span>
    </p>
	          <p><strong class="text-alert">Descrição:</strong> nome completo ou breve descrição do módulo que aparecerá no hint(quando colocamos o mouse sobre o atalho).</p>
			       
			</li>
			<br>
		</ul>	
	</div>
    <div class="indent"></div>
    <div class="indent"></div>
    <div class="indent"></div>
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