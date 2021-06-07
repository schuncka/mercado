
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>HTML e Ajax com jQuery | Integrações RD Station</title>
<style type="text/css">
html,body{text-align:center;}
#wrapper{width:600px; margin:0 auto; text-align:center;}
#conversion-form{width:300px; margin:0 auto; border:1px solid silver;text-align:left;}
#conversion-form .field{padding:4px;}
#conversion-form .actions{text-align:center;}
#conversion-form label{display:block;}
#conversion-form input[type=text]{width:90%;}
</style>
</head>
<body>
<div id="wrapper">
    
      

  <form id="conversion-form" action="https://www.rdstation.com.br/api/1.2/conversions" method="POST">
    <input type="hidden" name="token_rdstation" value="17b30c1ce63b7b6add8ad707f5f088ae" />
    <!--
      * Atenção!
      * Token de testes - Usar o próprio de sua conta encontrado em: https://www.rdstation.com.br/docs/api
    -->
    <input type="hidden" name="identificador" value="CREDENCIAMENTO_CM2019" />
    <input type="text" name="email_lead" class="required email" />
    <input type="text" name="nome" class="required" />
    <input type="text" name="empresa" class="" />


    <div class="actions">
      <input type="submit" id="cf_submit" value="Enviar" />
      <img src="//rdstation-static.s3.amazonaws.com/images/ajax-loader.gif" id="ajax-loader" alt="Enviando..." />
    </div>
  </form>
  <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
  <script type="text/javascript" src="//rdstation-static.s3.amazonaws.com/js/jquery.validate/1.9/jquery.validate.min.js"></script>
  <script type="text/javascript" src="//rdstation-static.s3.amazonaws.com/js/jquery.form/2.02/jquery.form.js"></script>
  <script type="text/javascript" src="//rdstation-static.s3.amazonaws.com/js/rd/1.2/rdlps.min.js"></script>
  <script type="text/javascript">
    var origConversionSuccess = conversionSuccess;
    conversionSuccess = function(resp) {
      origConversionSuccess(resp);
      try { _gaq.push(['_trackPageview', '/teste-html-ajax/conversao']); } catch(err) { }
      alert("Obrigado.");
      location.href = 'http://www.rdstation.com.br';
    }
  </script>
  <script type="text/javascript" src="//rdstation-static.s3.amazonaws.com/js/rd/1.2/rdlps-autofill.min.js"></script>

</div>

</body>
</html>