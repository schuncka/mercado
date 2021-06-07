<!--#include file="_database/athdbConnCS.asp"-->
<!--#include file="_database/athUtilsCS.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<% 
  Const GrupoMenu = "TODOS"
  Const CFG_BGMENU_TOP = "#808080" 
  Dim objConn, objRS, strSQL, auxCont, auxStrScodi, auxStrSdesc, teste,objRS2,strSQL2
  Dim strLINK, strTARGET, strROTULO
	  AbreDBConn objConn, "mercado_dados" 

  function RecursiveSubMenus(prCodMenuPai, prStrNivel)
   Dim LocalstrSQL, LocalObjRS, LocalAuxCont
   LocalstrSQL ="SELECT COD_MENU, ROTULO, LINK, TARGET FROM SYS_MENU WHERE GRUPO = '"&GrupoMenu&"' and COD_MENU_PAI = " & prCodMenuPai & " and DT_INATIVO is NULL ORDER by ORDEM"
   AbreRecordSet LocalObjRS, LocalstrSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
   'Set LocalObjRS = objConn.Execute(strSQL)

   LocalAuxCont = 1
   If not LocalObjRS.EOF Then
%>
<ul class="dropdown-menu dark" data-role="dropdown">
<%
   While not LocalObjRS.EOF
     strLINK   = GetValue(LocalObjRS,"LINK")&""
	 strTARGET = GetValue(LocalObjRS,"TARGET")
	 strROTULO = GetValue(LocalObjRS,"ROTULO")

     If Instr(lcase(replace(strROTULO," ","")),"class='divider'") <> 0 Then 'Caso seja um divisor: <li class='divider'></li>
		response.write (strROTULO)
	 Else
		 If (strLINK = "") Then
		 %>
			<li><a class="dropdown-toggle" href='#'><%=strROTULO%></a>
		 <%
		 Else
		   If Instr(strLINK,"?") = 0 Then
			 strLINK = strLINK & "?cachereg=" & Replace(Time,":","")
		   Else
			 strLINK = strLINK & "&cachereg=" & Replace(Time,":","")
		   End If
		 %>
		   <li><a href='<%=strLINK%>' target='<% IF (strTARGET = "") then response.write("fr_principal") else response.write(strTARGET) End If%>'><%=strROTULO%></a>
		 <%
		 End If
			RecursiveSubMenus GetValue(LocalObjRS,"COD_MENU"), prStrNivel & "," & LocalAuxCont
		 %>
		 </li>
	 <%
     End If
     LocalObjRS.MoveNext
     LocalAuxCont = LocalAuxCont + 1
   Wend
%>
</ul>
<%
   End If
   FechaRecordSet(LocalObjRS)
  end function
%>
<html>
<head>
<title>Mercado</title>
<!--#include file="metacssjs_root.inc"--> 
<script src="./_scripts/scriptsCS.js"></script>
<script language='Javascript'>
function adjustWindow() {
var h=window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
  document.getElementById('fr_principal').height = h-96;
}
</script>
<style>
 .indent      { height: 50px; background:#E8E8E8; }
 .indent_mini { height:  5px; background:#FFFFFF; }
</style>
</head>
<body class="metro "  style="margin:0px; padding:0px; background:#333;" onResize="adjustWindow();" onLoad="adjustWindow();">
<div style="border:0px solid #0F0;">
<div class="navigation-bar dark">
 <div class="navigation-bar-content">
   <!--
   <a href="nucleo.asp" class="element"><img src="img/SistemLogo.gif" width="185" height="54" border="0" style="padding-top:-5px;"></a>
   <span class="element-divider"></span>
   //-->
   <a href="principal.asp" class="element" target="fr_principal"></span>Mercado <!--sup>vista</sup--></a>
   <span class="element-divider"></span>

        
   <a class="element1 pull-menu" href="#"></a> <!-- Faz o menu ficar MINI quando em mobiles //-->
   <ul class="element-menu">
   <%
    strSQL ="SELECT COD_MENU, ROTULO, LINK, TARGET FROM SYS_MENU WHERE GRUPO = '"&GrupoMenu&"' and COD_MENU_PAI <= 0 and DT_INATIVO is NULL ORDER by ORDEM"
	AbreRecordSet ObjRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, -1 
    auxCont=1
    While not ObjRS.EOF
     strLINK = GetValue(ObjRS,"LINK")&""
     If strLINK = "" Then
	 %>
		<li><a class="dropdown-toggle no-marker <% if ucase(GetValue(ObjRS,"ROTULO")) = "SISTEMA" then response.write("fg-yellow") %>" href='#'><%=GetValue(ObjRS,"ROTULO")%></a>
	 <%
     Else
	 %>
		<li><a href='<%=strLINK%>' target='<%=getValue(ObjRS,"TARGET")%>'><%=GetValue(ObjRS,"ROTULO")%></a>
	 <%
	 End If
        RecursiveSubMenus GetValue(ObjRS,"COD_MENU"),auxCont
	 %>
	</li>
    <%
      ObjRS.MoveNext
      auxCont = auxCont + 1
    Wend
    FechaRecordSet(ObjRS)
    %>
   </ul>
   
   <div class="no-tablet-portrait">
   		
        <a class="element place-right" href="logout.asp"><span class="icon-exit"></span>&nbsp;<span class="element-menu">SAIR</span></a>
        <!--a class="element place-right" href="trocaevento.asp" target="fr_principal"><span class="icon-loop"></span>&nbsp;<span class="element-menu">TROCA EVENTO</span></a//-->
   </div>
   
   
 </div>
</div>
<div class="indent_mini" style="background-color:#333333;"></div>
<!-- <a href="logout.asp"><img src="img/logout_quick.gif" border="0" alt="logout"></a> //-->
<center>
<iframe scrolling="auto" 
        id="fr_principal" 
        name="fr_principal" 
        src="principal.asp?cachereg=<%=Session.SessionID & "_" & Replace(Time,":","")%>" 
        width="99%" 
        height="10" 
        frameborder="0" style="border:0px dashed #cccccc;background:#FFF">
</iframe>
</center>
<div style=" border:#FF0 0px solid; width:100%;height:40px; padding-left:10px;padding-top:0px;margin:0px; ">
<%

	' INI: Atalhos por TIPO, cria atalhos para todos os tipos/grupos distintos de atalhos existentes ---------------------------------------------
	strSQL =          "SELECT DISTINCT tile_view"
	strSQL = strSQL & "  FROM sys_painel "
	strSQL = strSQL & " WHERE DT_INATIVO IS NULL "
	strSQL = strSQL & "   AND TILE_VIEW IS NOT NULL "
	
'	strSQL2 = "SELECT oculto FROM TBL_USUARIO WHERE ID_USER ='" & SESSION("ID_USER") &"'"
'	set objRS2 = objConn.Execute(strSQL2)
'	
'	IF getValue(objRS2,"OCULTO") = "0" THEN 
'		strSQL = strSQL & "and tile_view <> 'private' "
'	END IF  
	 
	' RESPONSE.Write(strSQL)
	' RESPONSE.End()
	
	
	AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, null 
	
	response.write ("<div class='' style='float:left;border-left:5px #E3C800 solid;margin:0px;padding-top:0px;padding-button:0px;padding-left:10px;width:230px'>")
	response.write ("<nav class='horizontal-menu style='margin:0px;padding:0px;'>")
	response.write ("<ul style='margin:0px;padding:0px;'>")
	response.write ("<li>")
	response.write ("<a class='dropdown-toggle fg-white no-marker' href='#'><p class=' fg-white'><i class='icon-tree-view' style='margin-right:10px;'></i>&nbsp;Painéis de Atalho</p></a>")
	response.write ("<ul class='dropdown-menu dark drop-up' data-role='dropdown' >")
	
	DO WHILE NOT objRS.EOF
		auxSTR = "./principal_GenericPanel.asp?var_tileview="&getValue(objRS,"TILE_VIEW")
		response.write ("<li class''><a href='"& auxSTR & "' target='fr_principal'><p class='fg-white'>" & getValue(objRS,"TILE_VIEW") & "</p></a></li>")
		'--------------------------------
		objRS.MoveNext
	Loop

	response.write ("<li class='divider'></li>")		
	response.write ("<li class''><a href='./principal.asp' target='fr_principal'><p class='fg-white'>HOME</p></a></li>")
	
	response.write ("</ul>")
	response.write ("</li>")
	response.write ("</ul>")
	response.write ("</li>")
	response.write ("</ul>")
	response.write ("</nav>")
	response.write ("</div>")
	response.write ("<div class='' style='float:right; text-align:right; padding-right:10px; margin:0px; padding-top:0px;'>")
	response.write ("<p style='font-family:Arial; color:#FFF; font-size:10px;line-height:160%;'>")	
	Response.write (Session("GRP_USER") & " (" & Session("ID_USER") & ")<br>")
    Response.Write("" & Ucase(CFG_DB) & " - " & Request.Cookies("sysMetro")("CODEVENTO"))
	response.write ("</p>")	
	
	response.write ("</div>")
	' FIM: Atalhos por TIPO. ---------------------------------------------------------------------------------------------------------------------

%> 
</div>
</div> <!-- container //-->
</body>
</html>
<%
  FechaDBConn objConn
%>