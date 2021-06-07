<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<%Option Explicit %>
<%
 '------------------------------------------------------------------
 'INI: uso do FRAMSET ------------------------------------
 '------------------------------------------------------------------
 'Este código permite que um site tenha "bordas" externas de maneira 
 'parametrizável,  ou seja, via parâmetros pode se definir se o site 
 'deve abrir fechado entre monduras ou não, e inclusive escolher os 
 'tamanhos das partes envolvidas
 '---------------------------------------------- by Aless 08/07/2003
 'Exemplos de uso
 '------------------------------------------------------------------
 '00) ?var_mwidth=*&var_pwidth=778&var_mheight=30&var_pheight=*
 '01) ?var_mwidth=20&var_pwidth=*&var_mheight=1&var_pheight=*
 '02) ?var_mwidth=120&var_pwidth=*&var_mheight=50&var_pheight=*
 '03) ?var_mwidth=*&var_pwidth=800&var_mheight=*&var_pheight=600
 '------------------------------------------------------------------
 Dim mwidth, pwidth, mheight, pheight

 mwidth  = Request.QueryString("var_mwidth") 'Margin width 
 pwidth  = Request.QueryString("var_pwidth") 'Page Width
 mheight = Request.QueryString("var_mheight") 'Margin height 
 pheight = Request.QueryString("var_pheight") 'Page height

 'Determina os valores default...
 if mwidth  = "" then mwidth  = "0" end if 
 if pwidth  = "" then pwidth  = "*" end if 
 if mheight = "" then mheight = "0" end if 
 if pheight = "" then pheight = "*" end if 
 'FIM: uso do FRAMSET -------------------------------------
%>
<html>
<head>
<title>Mercado</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="javascript">
<!--
if ((navigator.userAgent.indexOf('iPhone') != -1) || (navigator.userAgent.indexOf('iPod') != -1))
{
  document.location = "mobile/";
} else {
  document.location = "login.asp";
}
//-->
</script>
</head>
<!-- 13.10.2014 by Aless - a nova interface metro, dispensa o uso desta moldura criada em 2003  ************************************** //-->
<!-- 
<frameset rows="<%=mheight%>,<%=pheight%>,<%=mheight%>" cols="<%=mwidth%>" frameborder="NO" border="0" framespacing="0"> 
  <frame name="fr_mtop" src="moldura_top.asp?var_pwidth=<%=pwidth%>" scrolling="NO" marginwidth="0" marginheight="0" frameborder="NO">
  <frameset cols="<%=mwidth%>,<%=pwidth%>,<%=mwidth%>"> 
    <frame name="fr_mleft"   src="moldura_left.asp"  scrolling="NO" marginwidth="0" marginheight="0" frameborder="NO">
    <frame name="fr_pcenter" src="login.asp"         scrolling="NO" marginwidth="0" marginheight="0" frameborder="NO" noresize>
    <frame name="fr_mright"  src="moldura_right.asp" scrolling="NO" marginwidth="0" marginheight="0" frameborder="NO">
  </frameset>
  <frame name="fr_mbottom" src="moldura_bottom.asp?var_pwidth=<%=pwidth%>" scrolling="NO" marginwidth="0" marginheight="0" frameborder="NO">
<noframes> 
//-->
<!-- ******************************************************************************************************************************** //-->
<body>
</body>
</html>
