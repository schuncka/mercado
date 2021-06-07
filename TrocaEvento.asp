<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"-->
<!--#include file="_database/secure.asp"-->
<% 'ATEN��O: doctype, language, option explicit, etc... est�o no athDBConn/athDBConnCS  %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("mini_ListaFormaPgto",Session("METRO_USER_ID_USER")), true %>
<%

 'Const LTB = "TBL_EVENTO_FORMAPGTO" 								    ' - Nome da Tabela...
 'Const DKN = "COD_FORMAPGTO"									        ' - Campo chave...
 'Const DLD = "../modulo_Evento/mini_ListaFormaPgto/default.asp" 	' "../evento/data.asp" - 'Default Location ap�s Dele��o
 Const TIT = "Troca Evento"									' - Nome/Titulo sendo referencia como titulo do m�dulo no bot�o de filtro


 Dim  strCOD_EVENTO,strVALOR, strSQL

strCOD_EVENTO = Replace(GetParam("var_chavemaster"),"'","''")

%> 
<html>
<head>
<title>Mercado</title>
<!--#include file="metacssjs_root.inc"--> 
<script src="./_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ---------
Criando uma condi��o pois na ATHWINDOW temos duas op��es
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
bot�es est�o aptos a retornar para default location�s
corretos em cada op��o de janela -------------------------------------- */
function ok() { 
 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}

function cancelar() { 
 window.close();
 
}
/* FIM: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ------- */
</script>
<script language="javascript" type="text/javascript">
//fun��o para ativar o date picker dos campos data

</script>

</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o t�tulo do m�dulo e a��o da dialog //-->
<div class="bg-darkOrange fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px"></span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
                     <form name="forminsert" id="forminsert" action="trocaeventoexec.asp" method="post">
                    <input type="hidden" name="DEFAULT_DB" value="<%=CFG_DB%>">
                    
                    <input type="hidden" name="DEFAULT_LOCATION" value="">
                    <input type="hidden" name="var_userid" id="var_userid" value="<%=session("ID_USER")%>" >
 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">GERAL</a></li>            
        </ul>
		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">
                   <div class="row ">
                            <div class="span2"><p>Selecione o evento:</p></div>
                            <div class="span8">
                                <div class="input-control select size2" data-role="input-control">
                                    <p>
                                    <select name="var_cod_evento" id="var_cod_evento�" class="">
                                        <option value="" selected>Selecione...</option>
										<% 
											strSQL = "SELECT cod_evento, CONCAT(NOME,' - ',CAST(COD_EVENTO AS CHAR))  as NOME FROM tbl_evento WHERE SYS_INATIVO is null and cod_evento not in ("& session("cod_evento")&")"

											if session("user_oculto")<>1 Then
												strSQL = strSQL & " AND ((cod_evento IN(SELECT cod_evento from tbl_usuario_evento where tbl_usuario_evento.cod_usuario in ("&session("cod_usuario")&")))"
												'inserido trecho controle - quando usu�rio n�o estiver na tbl_usuario_evento pode acessar TODOS os eventos, quando est� deve ser somente aqueles que est� vinculado (TJF 23072018)
												strSQL = strSQL & " OR ('"&session("cod_usuario")&"' NOT IN(SELECT cod_usuario from tbl_usuario_evento where tbl_usuario_evento.cod_usuario in ("&session("cod_usuario")&"))))"
											end if
											response.write(strSQL)
										
										montaCombo "STR" ,strSQL, "cod_evento", "nome", "" 
										%>
                                    </select>
                                    </p>
                                </div>                                 
                           </div>                           
                     </div>
                     <small class="text-left fg-teal" style="float:left"><strong>*</strong> Caso o combo esteja vazio, verifique o v�nculo do usu�rio com eventos espec�ficos no M�dulo de Usu�rio, op��o "Lista Eventos".</small>
                </div> <!--FIM GRID//-->
        </div><!--fim do frame dados//-->
                
		</div><!--FIM - FRAMES//-->
	</div><!--FIM TABCONTROL //--> 

    <div style="padding-top:16px;"><!--INI: BOT�ES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                   
            <input  class=""        type="button"  value="APLICAR" onClick="javascript:ok();return false;">                   
        </div>
    </div><!--FIM: BOT�ES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>                    
