<?php



include_once("../_database/athdbconn.php");
include_once("../_database/athtranslate.php");


$cod_codcli    = getsession(CFG_SYSTEM_NAME."_id_entidade");
$id_empresa    = getsession(CFG_SYSTEM_NAME."_id_mercado");




?>
<html>
<head>


<style type="text/css"> 
 

	.pagina { 
		writing-mode: tb-rl;
		width: 740px;
		height: 1070px;   
		margin: 0% 0% 0% 0%;
		border: 0px  solid #000000;
		overflow: hidden;
	}
	
	.campo { 
		writing-mode: tb-rl;
		margin: 0% 0% 0% 0%;
		overflow: hidden;
	}

		
	.cabecalho{
		border:0px solid #000000;
		height:1068px;
		width:280px;
		vertical-align:top;
		
	}	
	
	.conteudo{
		border:0px solid #000000;
		height:915px;
		width:300px;
		overflow: hidden;
		text-align:center;
		vertical-align:middle;
	}	
	
	.lateral{
		border:0px solid #000000;
		height:150px;
		width:455px;
		float:right;
		vertical-align:bottom;

	}	
	
	.rodape{
		border:0px solid #000000;
		height:910px;
		width:150px;
		overflow: hidden;
		text-align:center;
		vertical-align:middle;
	}	
	
	.rot90 { 
	-webkit-transform: rotate(90deg); 
	-moz-transform: rotate(90deg); 
	rotation: 90deg; 
	filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1); 
	} 

.campo1 {		
		writing-mode: tb-rl;
		margin: 0% 0% 0% 0%;
		overflow: hidden;
		font-size:12px;
}
.campo2 {		writing-mode: tb-rl;
		margin: 0% 0% 0% 0%;
		overflow: hidden;
}
</style> 
</head>


<title><?php echo(CFG_SYSTEM_TITLE); ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<body marginheight="0" marginwidth="0" leftmargin="0" rightmargin="0" topmargin="0">

<?php
$objConn = abreDBConn(CFG_DB); // Abertura de banco


 //$strSQL =	"select a.razao from cad_cadastro a where a.codigo = '".$cod_codcli."' and a.idmercado ilike '".$id_empresa."';";		

try{
//$objResult = $objConn->query($strSQL); // execução da query			
							
}catch(PDOException $e){
		mensagem("err_sql_titulo","err_sql_desc",$e->getMessage(),"","erro",1);
		die();
}

//$objRS 	= $objResult->fetch();

//$razao_cadastro =  getValue($objRS,"razao");

?>			  


<table border="1" align="right" class="campo" height="100%">
  
  <tr>
  	<td><span class="campo1">JOB</span></td>
    <td><span class="campo1">COD</span></td>
    <td rowspan="16" class="campo" align="center"><span class="campo2">OR&Ccedil;AMENTO</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">JOB</span></td>
  </tr>
   <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
   <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
   <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">SOMA</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AV</span></td>
  </tr>
</table>



<table border="1" align="right" class="campo" height="100%">
  
  <tr>
  	<td><span class="campo1">JOB</span></td>
    <td><span class="campo1">COD</span></td>
    <td rowspan="16" class="campo" align="center"><span class="campo2">OR&Ccedil;AMENTO</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">JOB</span></td>
  </tr>
   <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
   <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
   <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AGO/2009</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">SOMA</span></td>
  </tr>
  <tr>
    <td><span class="campo1">JOB</span></td>
	<td><span class="campo1">AV</span></td>
  </tr>
</table>







<!-- div da pagina inteira -->

<?php /*?>
<div class="pagina" > 
	<!-- div cabeçalho -->
	<div class="cabecalho" align="center"></div>
	
	<!-- div conteudo -->
	<div class="conteudo" style="float:left"  align="center">
	
		<br><br>
		<font size="4"  face="Arial, Helvetica, sans-serif">Certificamos que /</font>
		<font size="3"  face="Arial, Helvetica, sans-serif"><i>This is to certify that </i></font>
		<br><br>
		<font size="+3" face="Arial, Helvetica, sans-serif"><b><?php echo $razao_cadastro; ?></b></font>
		
		<br><br><br>
		<font size="4" face="Arial, Helvetica, sans-serif" >Participou da HOSPITALAR 2010 em São Paulo, Brasil, de 25 a 28 de maio de 2010.</font>
		<br><br>
		<font size="3" face="Arial, Helvetica, sans-serif" ><i>Attend HOSDPITALAR 2010 held in São Paulo, Brazil, from May 25 to 28, 2010.</i> </font>
		<br>
		
		
	</div>
	<!-- div lateral -->
	<div class="lateral"><br><img width="400" height="120"  src="../img/certificado_patrocinadores_hosp.jpg" /></div>
	
	<!-- div rodape -->
	<div class="rodape" style="float:left"> <img  src="../img/certificado_assinatura_hosp.jpg" /></div>
	
</div>

<?php */?>
<script type="text/javascript">

alert("Para Imprimir Precione CTRL+P e Selecione a Impressora");

/*
function fechar()
{
  window.print();

  setTimeout("window.close()",50);
}

    fechar();
	window.close();*/
</script>
</body>
</html>
<?php $objConn = NULL; ?>
