<!--#include file="athdbConnCS.asp"-->
<!--#include file="athUtilsCS.asp"-->
<%
'EX: Response.Expires = -1		- nunca ser� armazenado em cache;	
'EX: Response.Expires = 1440	- ir� expirar ap�s 1440 minutos (24 horas);
'variaveis de envio de parametro para MSGDLG(dialog de mensagem)
'EX:========================================================================================================================================================================================================================================= 
'	strTpMsg = ""																														'quando n�o quizer passar o TIPO(info,warning,erro) direto no form o tipo pode-se usar esta variavel;
'	strMSg   = ""																														'quando n�o quizer passar  a mensagem direto no form o tipo pode-se usar esta variavel;
'	strNOME  	= "" 																													'- nome da janela;
'	strTIPO  	= "INFO"																												'- tipo de MSG , ex: INFO,WARN,ERR;
'	strTITULO	=  "C�d. Produto:"&strCOD_PROD																							'- titulo da mensagem;
'	strMSG		= "Este produto foi removido de 'MINHA AGENDA'																			'- text completo da mensagem;
'	strMSGSYS	=  "C�d. Produto:"&strCOD_PROD&"<BR>C�. Inscri��o:"&strCOD_INSC&"<BR>C�d. Empresa:"&strCOD_EMPRESA						'- log de execu��o quando necessario apresentar dos alterado;
'	strICON    = "icon-info fg-blue on-right on-left"																					'- icone usado no tipo de mensagem por padr�o ser�o tr�s possiveis (icon-info&icon-warnning,icon-minus)
'																																			,mas a mesmas poderai receber outros icones para novas janelas de info																													
'																																			,juntamente com a cor e se na classe houver outros atributos de estilo manda junto na string
'	strJScript	= "window.opener.location.reload(true); window.close();"																'- cod javascript que ser� passado no bot�o ok da mensagem;
'===============================================================================================================================================================================================================================================

  Dim ObjConn, strSQL
  'Vari�veis passadas pelo formul�rio
  Dim strNOME, strTpICO, strTIPO, strTITULO, strMSG, strMSGSYS, strICON, strJScript,strDEFAULT_LOCATION
  
  strTIPO	  	= getParam ("var_tipo")				'- tipo de MSG , ex: INFO,WARN,ERR;
  'strICON  		= getParam ("var_icon")				'- icone usado no tipo de mensagem por padr�o ser�o tr�s (icon-info,icon-warnning,icon-minus)										

  strTITULO		= getParam ("var_titulo")			'- titulo da mensagem;
  strMSG		= getParam ("var_msg")				'- text completo da mensagem;

  strMSGSYS		= getParam ("var_msgsys")			'- log de execu��o quando necessario apresentar dos alterado;
													'  , juntamente com a cor e se na classe houver outros atributos de estilo manda junto na string
  strJScript	= getparam ("var_parent")			'- JScript para ser executado no bot�o ok da dialog. Se ele vier vazio, ele executa o close
  strJScript	= replace(strJScript,"''","'")
  
  strDEFAULT_LOCATION = getParam ("DEFAULT_LOCATION")  
  
  	'response.Write("1-chegou pelo getparam"&strDEFAULT_LOCATION)
  	'response.End()
  
  Select Case ucase(strTIPO)
	  Case "INFO","I","AVISO" 			strTpICO  = "icon-info fg-blue"
	  Case "WARNING","W","ALERTA"		strTpICO  = "icon-warning fg-yellow"
	  Case "ERRO","E","ERROR", "ERR"	strTpICO  = "icon-cancel fg-red"
	  Case else	 strTpICO  = "icon-info fg-silver" 'Caso n�o enha o TIPO, a MesageDLG se autop ajhusta como INFO
  End Select  
  
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"-->
<link rel="stylesheet" href="../_css/csm.css" type="text/css">
<script src="../_scripts/scriptsCS.js"></script>
<script type="text/javascript" language="javascript">
<!-- 
/* INI: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ---------
Criando uma condi��o pois na ATHWINDOW temos duas op��es
de abertura de janela "POPUP", "NORMAL" e com este tratamento abaixo os 
bot�es est�o aptos a retornar para default location�s
corretos em cada op��o de janela -------------------------------------- */

function ok() { 
	// Caso especial para ShopAgenda... Todos os demais casos n�o 
	// tem isso, por esse motivo, colocamos o "try catch"
	try { parent.hidePopWin(false); } catch(err) {  }
	
	
	<% 
	'at� aqui � windows.close
	'response.End()  
	'Executa o comando JavaScript passsado por quem acionou esa p�gina
	'Exemplos:
	'   strJScript = "window.opener.location.reload(true); window.close();"
	'   strJScript = "window.close();"
	'   strJScript = "alert ("helo world"); window.close();"
    ' --------------------------------------------------------------------

	'response.Write("1-strJScript / strDEFAULT_LOCATION [" &strJScript&"]/["&strDEFAULT_LOCATION&"] ............. "&vbnewline)
	if (strJScript <> "") then 
  		response.write (strJScript & vbnewline)
		strDEFAULT_LOCATION = ""
  	end if	

	'response.Write("2-chegou pelo strDEFAULT_LOCATION ["&strDEFAULT_LOCATION&"]............."&vbnewline)

    ' --------------------------------------------------------------------
	If (strDEFAULT_LOCATION <> "" ) Then
		response.write ("document.location.href = '" &  strDEFAULT_LOCATION & "'; "  & vbnewline)
		strDEFAULT_LOCATION = ""
	End If

	
	%>
}
<%'response.End() %>
/* FIM: OK, APLICAR e CANCELAR, fun��es para action dos bot�es ------- */
</script>
</head>
<body class="metro"  bgcolor="#FFF">
<!-- INI: BARRA que contem o t�tulo do m�dulo e a��o da dialog //-->
<div class="fg-white" style="width:100%; height:50px; font-size:20px; padding:10px 0px 0px 10px; background:#CCC">
   MESSAGE&nbsp;<sup><span style="font-size:12px"><%=ucase(strTIPO)%></span></sup>
</div>
<!-- FIM:BARRA ----------------------------------------------- //-->
<div class="container padding20">
        <div class="padding5 border">
        	 <div class="grid ">
            	<div class="row padding5">
				<div class="span1 " style="text-align:left;"><h1><i class="<%=strTpICO%>"></i></h1></div><!--icon-info fg-blue on-right on-left//-->                
					<div class="span11 ">
						<h2><strong><%=strTIPO%></strong></h2> 
						<h3><%=strTITULO%></h3>
                    </div>
                </div>
            	<div class="row ">
                	<div class="span1"></div>
                	<div class="span11"><p><%=strMSG%></p></div>
                </div>
            	<div class="row">
                	<div class="span1"></div>
                	<div class="span11"><hr></div>
                </div>
            	<div class="row">
                	<div class="span1"><span class="tertiary-text-secondary"></span></div>
                	<div class="span11"><span class="tertiary-text-secondary"><%=strMSGSYS%></span></div>
                </div>
			</div><!--fim do brid//-->
        </div><!--FIM//-->
        <div style="padding-top:16px;"><!--INI: BOT�ES/MENSAGENS//-->
            <div style="float:left">
             <input class=" primary" type="button" onClick="javascript:ok();return false;" value="OK">     
                        <!--input class=" primary" type="button" onClick="javascript:alert('fafsadfad');" value="OK"//-->                         
            </div>
        </div>
</div><!--//-->									
</body>
</html>
