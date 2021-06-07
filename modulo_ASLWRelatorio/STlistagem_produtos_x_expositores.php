<?php
include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");
include_once("../_database/athkernelfunc.php");
$id_evento = getsession('datawide_'."id_evento");
$id_empresa = getsession(CFG_SYSTEM_NAME."_id_mercado");
?> 

<html>
<head>
<title>DATAWIDE</title>
<link rel="stylesheet" href="../_css/datawide.css" type="text/css">
<script language="javascript"> 
function setParamToSQL(){
  var strMySQL, intCont;
  strMySQL = document.formconf.var_strparam.value;
  intCont = 0;
  while(document.formconf.elements[intCont].name != "") {
		strMySQL = strMySQL.replace("<ASLW_DOISPONTOS>" + document.formconf.elements[intCont].name + "<ASLW_DOISPONTOS>",document.formconf.elements[intCont].value);
		intCont++;
  }
	<!--parent.window.frames[0].document.frmRelatorio.var_strparam.value = strMySQL;-->
	<!--	parent.window.frames[0].document.frmRelatorio.action = 'STcarta_IRRF_Exec.php';-->
	<!--	parent.window.frames[0].document.frmRelatorio.submit();-->
}
 
function enableEnter(event){
	var tecla = window.event ? event.keyCode : event.which;
	if(tecla == 13){
		setParamToSQL();
		return false;
	}
}
 
function autoSubmit() {
	if(document.forms[0].elements.length == 4 && document.forms[0].elements[0].value != "") {
		setParamToSQL();
	}
}

function habilita(){                
		
		document.getElementById('txtS').disabled  = document.getElementById('S').checked;
		document.getElementById('txtP').disabled = document.getElementById('P').checked;
		document.getElementById('txtC').disabled = document.getElementById('C').checked;                   
					}       
		window.onload = function()
		{
		document.getElementById('S').onmouseup   = habilita;
		document.getElementById('P').onmouseup   = habilita;
		document.getElementById('C').onmouseup   = habilita;
		}
		
		
function desabilita() {
var x;  

	for(x=0; x<document.formconf.doc.length; x++)
	{
		if(document.formconf.doc[x].checked){
			valor = document.formconf.doc[x].value;
			break;
		}
		
	}
	if(valor == "1"){
	x = document.getElementById("pavilhao");    
	x.disabled = false;
    x = document.getElementById("alfabetica");    
	x.checked = true ;
    x = document.getElementById("parcial"); 	
	x.disabled = false;
    x = document.getElementById("total"); 	
	x.checked = true ;
    x = document.getElementById("chk2");
	x.value = "";	 	
	x.disabled = true;
    x = document.getElementById("dat");
	x.disabled = false;		
	}
	
	if(valor == "2"){
	x = document.getElementById("pavilhao");    
	x.disabled = true;
    x = document.getElementById("alfabetica");    
	x.checked = true ;
    x = document.getElementById("parcial"); 	
	x.disabled = true;
    x = document.getElementById("total"); 	
	x.checked = true ;
    x = document.getElementById("chk2"); 	
	x.disabled = false;	
    x = document.getElementById("dat");
	x.value = "";	
	x.disabled = true;			
	}	

	if(valor == "3"){
	x = document.getElementById("pavilhao");    
	x.disabled = true;
    x = document.getElementById("alfabetica");    
	x.checked = true ;
    x = document.getElementById("parcial"); 	
	x.disabled = true;
    x = document.getElementById("total"); 	
	x.checked = true ;
    x = document.getElementById("chk2");
	x.value = "";	 	
	x.disabled = true;	
    x = document.getElementById("dat");
	x.value = "";	
	x.disabled = true;			
	}	

}		

</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body style="margin:10px;" bgcolor="#CFCFCF" background="../img/bgFrame_imgVWHITE_main.jpg" onLoad="autoSubmit();">
<table border="0" cellpadding="0" cellspacing="0" width="100%" height="100%">
 <tr>
   <td align="center" valign="top">
	 <div id="DialogGlass" class="bordaBox" style="width:600; height:none;">
				<div class="b1"></div><div class="b2"></div><div class="b3"></div><div class="b4"></div>
				<div class="center">
					<div id="Conteudo" class="conteudo" style="width:582;  height:none;"><div id="GlassHeader" class="header" style="background-color:#C9DCF5;width:582px;"><span style='margin-left:4px;'>RELATÓRIOS - Produtos Expositores</span></div> 
		<table border="0" width="100%" bgcolor="#FFFFFF" style="border:1px #A6A6A6 solid;">
		  <form name="formconf" action="STlistagem_produtos_x_expositores_exe.php" method="post">
			<tr>
				<td align="center" valign="top">
					<table width="550" border="0" cellspacing="0" cellpadding="4">
                  <tr>				  
                    <td align="center"><fieldset>						
						<input type="radio" id="S" name="doc" value="1" style="border:none; background:none;" onClick="desabilita();"/> Todos Serviços 
                    	<input type="radio" id="P" name="doc" value="2" style="border:none; background:none;" onClick="desabilita();"/> Escolher Produto 
                    	<input type="radio" id="C" name="doc" value="3" style="border:none; background:none;" onClick="desabilita();"/> Escolher Categoria 
					</fieldset>
					</td>				
                  </tr>
				  
                  <tr>				  
                    <td align="center"><fieldset>
					    <input type="radio" id="pavilhao" name="doc1" style="border:none; background:none;" checked="checked" /> Por Pavilhão 
						<input type="radio" id="alfabetica" name="doc1" style="border:none; background:none;" /> Ordem Alfabética
					</fieldset>
					</td>				
                  </tr>
				  
                  <tr>				  
                    <td align="center"><fieldset>
					    <input type="radio" id="parcial" name="doc2" style="border:none; background:none;" checked="checked" /> Parcial a partid de... 
                    	<input type="radio" id="total" name="doc2" style="border:none; background:none;" /> Total
					</fieldset>
					</td>				
                  </tr>
				  
				  <tr>				  
                    <td>
						
					    Escolha o Evento............: <select name="nome_cliente" id="chk1" style="width: 300px;">
							
									<?php
										$objConn = abreDBConn(CFG_DB); // Abertura de banco						
										$strSQL = " SELECT DISTINCT
																cad_evento.nome_completo AS evento
																, cad_evento.edicao AS edicao
																, cad_evento.dt_inicio AS início
																, cad_evento.dt_fim AS termino
																, cad_evento.pavilhao AS pavilhao
																, ped_pedidos.idevento as idevento
															FROM 
																cad_evento 
																INNER JOIN 
																ped_pedidos 
																ON cad_evento.idevento = ped_pedidos.idevento
															WHERE 
																(ped_pedidos.idmercado = '$id_empresa')
															ORDER BY 
																cad_evento.dt_inicio DESC;";
																												
										$objResult = $objConn->query($strSQL); // execução da query
										foreach($objResult as $objRS){
									?>

									<option value="<?php  echo getValue($objRS,"idevento");  ?>">
                        			<?php echo getValue($objRS,"evento"); ?>
                        <?php } ?>
                    </select>				 
					</td>									
                  </tr>	
				  
				  <tr>				  
                    <td>
						Entre com a Data............: <input type="text" name="data" id="dat" >
					</td>									
                  </tr>	
				  <tr>				  
                    <td>
					    Escolha o Produto..........: <select name="nome_cliente" id="chk2" style="width: 300px;">
							
									<?php
										$objConn = abreDBConn(CFG_DB); // Abertura de banco						
										$strSQL = " SELECT 
															descrproduto
															, idproduto
														FROM 
															ped_produtos_lista_preco
														WHERE 
															(ped_produtos_lista_preco.idevento = '$id_evento')
														ORDER BY
															ped_produtos_lista_preco.descrproduto;";
										$objResult = $objConn->query($strSQL); // execução da query
										foreach($objResult as $objRS){
									?>
												
												<option value="<?php  echo getValue($objRS,"idproduto");  ?>">
                        <?php echo getValue($objRS,"descrproduto"); ?>
                        <?php } ?>
                    </select>				 
					</td>									
                  </tr>				  				  					  				  
				  
				

							<td align="right" colspan="3" style="padding:10px 0px 10px 10px;">
								<button type="submit">OK</button>
								<button onClick="parent.window.close();">Cancelar</button>							</td>
						</tr>
					</table>
				</td>
			</tr>
			<input type="hidden" name="var_strparam" value="select 
 ped_pedidos_parcelamento.vencimentoped as Dt_Vcto 
 ,ped_pedidos.codigope as COD
 ,ped_pedidos.razaope as Razão_Social
 ,ped_pedidos_parcelamento.nroduplicata as Número_Duplicata
 ,ped_pedidos_parcelamento.valorpar  as Valor_Parcela
from 
 (cad_evento 
inner join 
 ped_pedidos on cad_evento.idevento = ped_pedidos.idevento) 
inner join 
  ped_pedidos_parcelamento on (ped_pedidos.idpedido =  ped_pedidos_parcelamento.idpedido) 
 and 
  (ped_pedidos.idmercado = ped_pedidos_parcelamento.idmercado) 
where 
 (((ped_pedidos_parcelamento.vencimentoped) 
between 
 to_date( <ASLW_APOSTROFE><ASLW_DOISPONTOS>dt_inicio<ASLW_DOISPONTOS><ASLW_APOSTROFE>, <ASLW_APOSTROFE>DD/MM/YYYY<ASLW_APOSTROFE>) 
   and 
    to_date( <ASLW_APOSTROFE><ASLW_DOISPONTOS>dt_final<ASLW_DOISPONTOS><ASLW_APOSTROFE>, <ASLW_APOSTROFE>DD/MM/YYYY<ASLW_APOSTROFE>)) 
     and 
      ((ped_pedidos_parcelamento.datafat) is null) 
       and 
        ((ped_pedidos.excluida) = false) 
         and 
          ((ped_pedidos.confirmado) = true) 
           and 
            ((ped_pedidos.idstatus) not ilike <ASLW_APOSTROFE>005<ASLW_APOSTROFE> 
             and 
               (ped_pedidos.idstatus) not ilike <ASLW_APOSTROFE>100<ASLW_APOSTROFE>)) 
group by 
 cad_evento.nome_completo 
 , ped_pedidos.codigope 
 , ped_pedidos.razaope 
 ,ped_pedidos_parcelamento.nroduplicata 
 ,ped_pedidos_parcelamento.valorpar 
 ,ped_pedidos_parcelamento.vencimentoped 
order by 
cad_evento.nome_completo, ped_pedidos.razaope; ">
		  </form>
		</table>
		 </div>
			    </div>
			   <div class="b4"></div><div class="b3"></div><div class="b2"></div><div class="b1"></div>
		     </div>	   </td>
 </tr>
</table>
</body>
</html>
