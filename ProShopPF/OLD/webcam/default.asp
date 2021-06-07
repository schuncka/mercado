<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"--> 
<!--#include file="../../_class/ASPMultiLang/ASPMultiLang.asp"-->

<!DOCTYPE html>
<head>

    <!--meta charset="iso-8859-1"//-->
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta name="viewport"    content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <meta name="product"     content="PRO MetroUI  Framework">
    <meta name="description" content="Simple responsive css framework">
    <meta name="author" 	 content="Sergey P. - adapted by Aless">

    <link href="../_metroUI/css/metro-bootstrap.css" rel="stylesheet">
    <link href="../_metroUI/css/metro-bootstrap-responsive.css" rel="stylesheet">
    <link href="../_metroUI/css/iconFont.css" rel="stylesheet">
    <link href="../_metroUI/css/docs.css" rel="stylesheet">
    <link href="../_metroUI/js/prettify/prettify.css" rel="stylesheet">
    <!-- Load JavaScript Libraries -->
    <script src="../_metroUI/js/jquery/jquery.min.js"></script>
    <script src="../_metroUI/js/jquery/jquery.widget.min.js"></script>
    <script src="../_metroUI/js/jquery/jquery.mousewheel.js"></script>
    <script src="../_metroUI/js/prettify/prettify.js"></script>

    <!-- PRO  MetroUI  JavaScript plugins -->
    <script src="../_metroUI/js/load-metro.js"></script>

    <!-- Local JavaScript -->
    <script src="../_metroUI/js/docs.js"></script>
    <script src="../_metroUI/js/github.info.js"></script>

    <!-- Tablet Sort -->
	<script src="../_metroUI/js/tablesort_metro.js"></script>

    <title>pVISTA ShopMetroUI</title>
    <style>
    	body { font-family: Helvetica, sans-serif; font-size:12px; }
		h2, h3 { margin-top:0; }
		form { margin-top: 5px; }
		form input { margin-right: 5px; }
		#results { float:inherit; margin:20px; padding:20px; border:1px solid; background:#ccc; }
    </style>
    <script language="JavaScript" type="text/javascript" src="_scripts/SiteScripts.js"></script>
	
	
	
	
	
	<style type="text/css">
	
	</style>
</head>
<body>
<!--
	<div id="results">Sua imagem vai aparecer aqui...</div>
//-->
	
	
	<div id="my_camera" class="span3"></div>
	
	<!-- First, include the Webcam.js JavaScript Library -->
	<script type="text/javascript" src="webcam.js"></script>
	
	<!-- Configure a few settings and attach camera -->
	<script language="JavaScript">		
	if(navigator.userAgent.indexOf("Mobile") != -1)
    {
        Webcam.set({
			width: 180,
			height: 240,
			image_format: 'jpeg',
			jpeg_quality: 90
		});
    }else{
		Webcam.set({
			width: 320,
			height: 240,
			image_format: 'jpeg',
			jpeg_quality: 90
		});
	}
		Webcam.attach( '#my_camera' );
	</script>
	
	<!-- A button for taking snaps -->
	<form>
		<div id="pre_take_buttons">
		  <img src="../../img/icon_captura.gif" onClick="preview_snapshot()">
          
		</div>
		<div id="post_take_buttons" style="display:none">
		  <img src="../../img/icon_captura_voltar.gif" onClick="cancel_preview()" align="left">
		  <img src="../../img/icon_captura_salvar.gif" onClick="save_photo()" align="right">
		</div>
	</form>
	
	<!-- Code to handle taking the snapshot and displaying it locally -->
	<script language="JavaScript">
		function preview_snapshot() {
			// freeze camera so user can preview pic
			Webcam.freeze();
			
			// swap button sets
			document.getElementById('pre_take_buttons').style.display = 'none';
			document.getElementById('post_take_buttons').style.display = '';
		}
		
		function cancel_preview() {
			// cancel preview freeze and return to live camera feed
			Webcam.unfreeze();
			
			// swap buttons back
			document.getElementById('pre_take_buttons').style.display = '';
			document.getElementById('post_take_buttons').style.display = 'none';
		}
		
		function save_photo() {
			// actually snap photo (from preview freeze) and display it
			Webcam.snap( function(data_uri) {
				// display results in page
				//alert(data_uri);
				var raw_image_data = data_uri.replace(/^data\:image\/\w+\;base64\,/, '');
				//document.getElementById('results').innerHTML = 
				//	'<h2>Sua imagem:</h2>' + 
				//	'<img src="'+data_uri+'"/>';
				 document.getElementById('mydata').value = raw_image_data;
				 document.getElementById('myform').submit();
				// swap buttons back
				document.getElementById('pre_take_buttons').style.display = '';
				document.getElementById('post_take_buttons').style.display = 'none';
			} );
		}
	</script>
	
</body>
	<form id="myform" method="post" action="myscript.asp">
        <input id="mydata" type="hidden" name="mydata" value=""/>
        <input id="id" type="hidden" name="id" value="<%=Request("id")%>"/>
        <input id="cpf" type="hidden" name="cpf" value="<%=Request("id")%>"/>
        <input id="frm_name" type="hidden" name="frm_name" value="<%=Request("formulario")%>"/>
        <input id="var_campo" type="hidden" name="var_campo" value="<%=Request("campo")%>"/>
        <input id="var_campo_foto1" type="hidden" name="var_campo_foto1" value="<%=Request("campo_foto")%>">
    </form>
</html>
