<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn %> 
<% 'VerificaDireito "|UPD|", BuscaDireitosFromDB("modulo_CfgPanel", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%''''''''%>
<html>
<head>
<title>Mercado</title>
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista" onUnload="SaveData()" onLoad="LoadData()">
<div>
    <p>
        <span class="tertiary-text-secondary">
        Favor verificar dados de Help na pasta Help/default.asp , e esta include ser� desabilitada<br>
        temporariamente sendo usado quando for habilitado nas dialogs as guias de consulta rapida
        <!--<ul class="tertiary-text-secondary">
            <li><strong>TOTEM:</strong>CPF;CNPJ;INSCRICAO;[CODBARRA ou SCRAMBLE_CODBARRA]<br>
            (localiza��o -  http://pvista.proevento.com.br/[cliente]/totem/)
            </li>
            <li><strong>TOTEM_CONGRESOS:</strong>CPF;CNPJ;INSCRICAO;NOME<br>
            (localiza��o -  http://pvista.proevento.com.br/[cliente]/totem_congresso/)
            </li>
            <li><strong>TOTEM_VISITANTE:</strong>CPF;CNPJ;[CODBARRA ou SCRAMBLE_CODBARRA]<br>
            (localiza��o -  http://pvista.proevento.com.br/[cliente]/totem_visitante/)
            </li>
        </ul>-->
        </span>
    </p>
<!--OBS: confirmar com gabriel quais paramentros ser�o utlizado em cada totem //-->
</div>
       <p><a href="default.asp" class="default">VOLTAR</a></p>
</body>
</html>

