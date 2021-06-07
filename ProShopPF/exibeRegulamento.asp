<!DOCTYPE html>
<head>
   <script language="javascript">
   function testaAceiteRegulemento(){
			if(document.getElementById('aceiteRegulamento').checked == true){
				parent.document.getElementById('enviar_regulamento').style.visibility = 'visible';
			}else{parent.document.getElementById('enviar_regulamento').style.visibility = 'hidden';}
			
			
		}
   </script>

</head>
<body class="metro" style="background-color:#F8F8F8">	
<!--span style="font-family: Courier New, monospace;"//-->
<span style="font-family: Segoe UI_, Open Sans, Verdana, Arial, Helvetica, sans-serif;
 font-weight: normal;
  font-style: normal;
  color: #000000;
  font-size: 10pt;
  line-height: 15pt;
  letter-spacing: 0.02em;">
<%
response.write(request.Cookies("METRO_ProshopPF")("METRO_ProShopPF_Regulamento"))
%>

<hr><input type='checkbox' onclick='javascript:testaAceiteRegulemento();' id='aceiteRegulamento'>&nbsp;<strong><%=request("var_aceitar_traduzido")%></strong></span><hr>
</body>
</html>