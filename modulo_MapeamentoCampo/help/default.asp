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
        <h1><a href="_include_grade.asp" class="history-back"><i class="icon-arrow-left-3 fg-darker smaller"></i></a> M�dulo - Mapeamento Campo<small class="on-right"><!--//--></small></h1>
        <h3 class="fg-amber">Entendendo este m�dulo</h3>
	<div class="padding20 border">
            <p>Neste m�dulo � feita a configura��o de quais campos(EXTRAS) devem ser exibidos no formulario de cadastro, da loja(EX:/shop, /shopex, /shoppj, /shoppj3) e CADASTROS(modulo_manutencao).
            <br><br>
            Estes campos s�o acrescentados ao formul�rio mediante a cadastros feito neste m�dulo que ir� definir o dados a serem apresentados..</p>
        <div class="example" align="center">
            <div class="grid">
                <div class="row span8">
                    <div class="image-container selected span3">
                        <img src="../../modulo_MapeamentoCampo/help/hlp_cadastro_mapeamento.png">
                    </div>       
                    <div class="image-container selected span3">
                        <img src="../../modulo_MapeamentoCampo/help/hlp_modulo_mapeamento.png">
                    </div>
                </div>
            </div>
        </div>
            <p class="fg-gray"><a href="http://192.168.1.8:83/_pvista/modulo_MapeamentoCampo/help/hlp_exemplo_mapeamento.png" target="_blank">Na figura acima vemos um exemplo Mapeamento 
            configurado com seus comparativos m�dulo formulario.</a></p>
        </div>
        <div class="indent"></div>
        <h3 class="fg-amber">Acessando este m�dulo</h3>
        <div class="padding20 border">
           <p>Para acessar este m�dulo utilize o link: <u>http://pvista.proevento.com.br/(ambiente)/modulo_Mapeamento_Campo/</u></p>
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
                            <div class="image-container selected span6" >
                            <img src="http://192.168.1.8:83/_pvista/modulo_MapeamentoCampo/help/hlp_mapeamento_dialogs.png" >
                            </div>
                         </div>
                        <p class="fg-gray"><a href="http://192.168.1.8:83/_pvista/modulo_MapeamentoCampo/help/hlp_mapeamento_dialogs.png" target="_blank">Na figura acima podemos vizualizar a dialog de Insert do m�dulo
                        e as duas guias com os campos de configura��o.</a></p>
                        </p><br>							
                </li>
            </ul>	
        </div>
	</div><!--fim div padding border//-->
</div><!--fim page container//-->
  <div class="indent"></div>
</body>
 <div class="indent"></div>
</html>

<!--
O QU�...................................................................................................................................................10
 ONDE....................................................................................................................................................11
 COMO...................................................................................................................................................12
 QUANDO. ..................................................
//-->