<!doctype html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<title>Proevento</title>
	<style type="text/css">
		body { font-family: Helvetica, sans-serif; font-size:12px; }
		h2, h3 { margin-top:0; }
		form { margin-top: 5px; }
		form input { margin-right: 5px; }
		#results { float:right; margin:20px; padding:20px; border:1px solid; background:#ccc; }
	</style>
</head>
<body>
<!--
	<div id="results">Sua imagem vai aparecer aqui...</div>
//-->
	<h3>Código: <b><%=Request("id")%></b></h3>
	
    
   	<div id="div_video" style="display:block;" align="center"><video id="video"  width="320" height="240" autoplay></video></div>
	<!--button id="snap"  >Snap Photo</button//-->
	<div id="div_canvas" style="display:none;" align="center"><canvas id="canvas" width="320" height="240"></canvas></div>
    
    <script language="JavaScript">	

	
		document.getElementById('video').width='320';
		document.getElementById('video').height='240';		
		document.getElementById('canvas').width='320';
		document.getElementById('canvas').height='240';
		
	var video = document.getElementById('video');

	// Get access to the camera!
	if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
		// Not adding `{ audio: true }` since we only want video now
		navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
			//video.src = window.URL.createObjectURL(stream);
			video.srcObject = stream;
			video.play();
		});
	}
	
	var canvas = document.getElementById('canvas');
	var context = canvas.getContext('2d');
	var video = document.getElementById('video');
	
	</script>
	<!-- A button for taking snaps -->
	<form>
		<div id="pre_take_buttons">
		  <img src="../img/icon_captura.gif" onClick="preview_snapshot()">
          
		</div>
		<div id="post_take_buttons" style="display:none">
		  <img src="../img/icon_captura_voltar.gif" onClick="cancel_preview()" align="left">
		  <img src="../img/icon_captura_salvar.gif" onClick="save_photo()" align="right">
		</div>
	</form>
    	<script language="JavaScript">
		function preview_snapshot() {
			// freeze camera so user can preview pic
			//alert(navigator.userAgent);
			if(navigator.userAgent.indexOf("Mobile") != -1){				
				context.drawImage(video, 0, 0, 180, 240);
			}
			else{
				
				context.drawImage(video, 0, 0, 320, 240);
			}
			
			// swap button sets
			document.getElementById('pre_take_buttons').style.display = 'none';
			document.getElementById('post_take_buttons').style.display = '';
			
			document.getElementById("div_video").style.display = 'none';
			document.getElementById("div_canvas").style.display = 'block';
		}
		
		function cancel_preview() {
			// cancel preview freeze and return to live camera feed
			//Webcam.unfreeze();
			
			// swap buttons back
			document.getElementById('pre_take_buttons').style.display = '';
			document.getElementById('post_take_buttons').style.display = 'none';
			
			document.getElementById("div_video").style.display = 'block';
			document.getElementById("div_canvas").style.display = 'none';
		}
		
		function save_photo() {
			var photo = canvas.toDataURL("image/png").replace("image/png", "image/octet-stream")	
			document.getElementById('mydata').value = photo;
			//document.getElementById('teste').innerHtml = photo;
			//$.ajax({
			 // method: 'POST',
			 // url: 'save.php',
			 // data: {
			//	photo: photo
			 // }
			//});
			document.getElementById('myform').submit();
		}
	</script>
    
	
	
</body>
	<form id="myform" method="post" action="myscript.asp">
        <input id="mydata" type="hidden" name="mydata" value=""/>
        <input id="id" type="hidden" name="id" value="<%=Request("id")%>"/>
        <input id="cpf" type="hidden" name="cpf" value="<%=Request("id")%>"/>
        <input id="cod_empresa" type="hidden" name="cod_empresa" value="<%=Request("cod_empresa")%>"/>
        <input id="codbarra" type="hidden" name="codbarra" value="<%=Request("codbarra")%>"/>
    </form>
</html>
