<!--#include file="../_database/athdbConn.asp"--><%' ATENÇÃO: language, option explicit, etc... estão no athDBConn %> 
<html>
<title></title>
<head>
<link rel="stylesheet" type="text/css" href="../_css/tablesort.css">
<style>
.centropreload { width:100px; height:100px;  position:absolute; top:50%; left:50%; margin-top:-50px; margin-left:-50px; }
</style>
<script>
function createAjax() {
var xmlHttp=null;
 try { xmlHttp=new XMLHttpRequest(); } // Firefox, Opera 8.0+, Safari 
 catch (e) {
   try // Internet Explorer
    { xmlHttp=new ActiveXObject("Msxml2.XMLHTTP"); }
   catch (e) { xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");  }
  }
 return xmlHttp;
}

function loadAjaxPage(){
    var objAjax;
  
	//document.getElementById("ImgPreLoad").style.display = "block"; //Mostra o gif animado de pre-load
	objAjax = createAjax();
	objAjax.onreadystatechange = function(){
		if(objAjax.readyState == 4) {
			if(objAjax.status  == 200){			
				document.getElementById("HtmlContent").innerHTML = objAjax.responseText
				//document.getElementById("ImgPreLoad").style.display = "none";//Esconde o gif animado de pre-load
			}
			else {
				document.getElementById("HtmlContent").innerHTML = "Erro no processamento da página: \n\n" + objAjax.status;
			}
		}
	}
	objAjax.open("GET", "main.asp?<%=GetParam("")%>",  true); 
	objAjax.send(null); 
}
</script>
</head>
<body onLoad="loadAjaxPage();" id="HtmlContent">
<span class="centropreload"><img src="../img/anim_preload.gif"></span>
</body>
</html>
