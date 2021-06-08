<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|INS|", BuscaDireitosFromDB("modulo_clientes",Session("METRO_USER_ID_USER")), true %>
<%

 Const MDL = "DEFAULT"          											' - Default do Modulo...
 Const LTB = "tbl_clientes_sub"							    		' - Nome da Tabela...
 Const DKN = "cod_tbl_clientes_sub"										      	  		' - Campo chave...
 Const DLD = "../modulo_clientes/mini_Contatos/default.asp" 	' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "Relatório Comissão"													' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro

 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL, strSQL2
 'Adicionais
 Dim i,j, strINFO, strALL_PARAMS, strSWFILTRO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim  strCodCli
 

'Carraga a chave do registro, porém neste caso a relação masterdetail 
'ocorre com COD_EVENTO mesmo a chave do pai sendo ID_AUTO. 
'---------------carrega cachereg do pai local cred-----------------
'strCodEvento 	= Replace(GetParam("var_cod_evento"),"'","''")
strCodCli 		= Replace(GetParam("var_chavereg"),"'","''")

'------------------------------------------------------------------

%> 
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<!--#include file="../_metroui/meta_css_js_forhelps.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script language="javascript" type="text/javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, funções para action dos botões ---------
Criando uma condição pois na ATHWINDOW temos duas opções
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
botões estão aptos a retornar para default location´s
corretos em cada opção de janela -------------------------------------- */
function ok() { 
 
	if (validateRequestedFields("forminsert")) { 
		document.forminsert.submit(); 
	} 
}

function cancelar() { 
 <% if (CFG_WINDOW = "NORMAL") then 
  		response.write ("window.history.back()")
	 else
  		response.write ("window.close();")
  	 end if
 %> 
}
/* FIM: OK, APLICAR e CANCELAR, funções para action dos botões ------- */
</script>
</head>
<body class="metro" id="metrotablevista" >
<!-- INI: BARRA que contem o título do módulo e ação da dialog //-->
<div class="bg-darkEmerald fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px;">
   <%=TIT%>&nbsp;<sup><span style="font-size:12px"></span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
<!--div class TAB CONTROL --------------------------------------------------//-->
   <form name="forminsert" id="forminsert" action="movimentoMensalComissao.asp" method="post">
                    


 <div class="tab-control" data-effect="fade" data-role="tab-control">
       <ul class="tabs"><!--ABAS DO TAB CONTROL//-->
            <li class="active"><a href="#DADOS">Rel Movimento Mensal</a></li>
            <!--li class="#"><a href="#EXTRA">EXTRA</a></li//-->
        </ul>

		<div class="frames">
            <div class="frame" id="DADOS" style="width:100%;">
                <h2 id="_default"><!-- breve resumo sobre este dialog/grupo  //--></h2>
                <div class="grid" style="border:0px solid #F00">   
      
                <div class="row">
                    <div class="row">
                            <div class="span2"><p>Data Inicio / Fim</p></div>
                                <div class="span4">
                                    <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                        <input id="var_dt_inicio" name="var_dt_inicio" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                        <span class="btn-date"></span>
                                    </p>
                                            
                                </div>
                                <div class="span4">
                                    <p class="input-control text info-state" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                                        <input id="var_dt_fim" name="var_dt_fim" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  >
                                        <span class="btn-date"></span>
                                    </p>
                                </div>
                        </div>
                </div>

                

                 <div class="row">
                        <div class="span2"><p>Representante</p></div>
                            <div class="span8"><p>
                               <div class="input-control select info-state" data-role="input-control">
                                    <select id="DBVAR_STR_IDREPRE"name="DBVAR_STR_IDREPRE" >
                                     <option value="">Selecione...</option>
                                        <% montaComboReturnPrint "select CODIGODOCLIENTE, NOMEDOCLIENTE from TBL_CLIENTES where tipo in(5)  order by 2", "CODIGODOCLIENTE", "NOMEDOCLIENTE","" %>
                                    </select>
                                </div>
                                <span class="tertiary-text-secondary"></span>
                            </div>
                    </div>

               
                                   
                </div> <!--FIM GRID//-->
            </div><!--fim do frame dados//-->           
	</div><!--FIM TABCONTROL //--> 
  <div style="padding-top:16px;"><!--INI: BOTÕES/MENSAGENS//-->
        <div style="float:left">
            <input  class="primary" type="button"  value="OK"      onClick="javascript:ok();return false;">
            <input  class=""        type="button"  value="CANCEL"  onClick="javascript:cancelar();return false;">                               
        </div>
        <div style="float:right">
	        <small class="text-left fg-teal" style="float:right"> <strong>(borda azul) e/ou (*)</strong> campos obrigatórios</small>
        </div> 
    </div><!--FIM: BOTÕES/MENSAGENS //--> 
	</form>
</div> <!--FIM ----DIV CONTAINER//-->  
</body>
</html>                    

