<!-- Facebook Pixel Code -->
<script>
!function(f,b,e,v,n,t,s){if(f.fbq)return;n=f.fbq=function(){n.callMethod?
n.callMethod.apply(n,arguments):n.queue.push(arguments)};if(!f._fbq)f._fbq=n;
n.push=n;n.loaded=!0;n.version='2.0';n.queue=[];t=b.createElement(e);t.async=!0;
t.src=v;s=b.getElementsByTagName(e)[0];s.parentNode.insertBefore(t,s)}(window,
document,'script','https://connect.facebook.net/en_US/fbevents.js');
fbq('init', '<%=strEV_PixelFacebook%>'); // Insert your pixel ID here.
fbq('track', 'PageView');
</script>
<noscript><img height="1" width="1" style="display:none"
src="https://www.facebook.com/tr?id=<%=strEV_PixelFacebook%>&ev=PageView&noscript=1"
/></noscript>
<!-- DO NOT MODIFY -->
<!-- End Facebook Pixel Code -->
<script>fbq('track','inscricao<%=replace(strSTATUS_PRECO," ","")%>',{
			cpf:          '<%=strNUMDOC1%>',
			codigo:       '<%=strCOD_EMPRESA%>',
			nomeInscrito: '<%=strNOMECLI%>',
			entidade:     '<%=strENTIDADE%>',
			endereco:     '<%=strENDER%>',
			bairro:       '<%=strBAIRRO%>',
			cidade:       '<%=strCIDADE%>',
			estado:       '<%=strESTADO%>',
			cep:          '<%=strCEP%>',
			fone1:        '<%=strFONE4%>',
			fone2:        '<%=strFONE1%>',
			fax:          '<%=strFONE2%>',
			celular:      '<%=strFONE3%>',
			email:        '<%=strEMAIL1%>',
			atividade:    '<%=strATIVIDADE%>',
			categoria:    '<%=strSTATUS_PRECO%>',
			produto:      '<%=strProdutoPixel%>',
			valor_total:  '<%=FormatNumber(strVLR_TOTAL)%>'
		});</script>
        
        
        
        
