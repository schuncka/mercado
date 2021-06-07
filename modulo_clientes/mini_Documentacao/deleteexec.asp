<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->  
<!--#include file="../../_database/secure.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% VerificaDireito "|DEL|", BuscaDireitosFromDB("mini_ListaImagens",Session("PVISTA_USER_ID_USER")), true %>
<html>
<head>
<title>pVISTA</title>
<!--#include file="../../_metroui/meta_css_js.inc"--> 
<!--#include file="../../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista" onUnload="SaveData()" onLoad="LoadData()">
<div class="page container">
    <h1>
    	<a href="modulo_AdmProduto/default.asp" class="history-back">
        	<i class="icon-arrow-left-3 fg-darker smaller"></i>
       	</a>DEL<small class="on-right">
							 Módulo-EVENTO mini LISTA IMAGEM
				</small>
	</h1>
    <h2 class="fg-amber" id="_headigns">EM MANUTENÇÃO</h2>
    <div class="grid fluid border">
        <p>&nbsp;<!--div onde começará o help//--></p>
    </div>
</div>   