<!--#include file="../../_database/athdbConnCS.asp"-->
<!--#include file="../../_database/athUtilsCS.asp"-->
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn/athDBConnCS  %> 
<%
	Dim auxFILTRO
	auxFILTRO = Ucase(getParam("var_filtro"))
	
	if 	 auxFILTRO = "" then
		 auxFILTRO = "PDIAS"
	end if
	
	Session("METRO_SHOPAG_FILTRO") = 	auxFILTRO
%>
<html>
<head>
<title>pVISTA ShopAgenda</title>
<script language="javascript" type="text/javascript">

</script>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>
<!-- body onLoad="parent.formgeral.target='fr_principal'; parent.formgeral.submit();" //-->
<body onLoad="window.parent.opener.location.reload(); window.close();">
</body>
</html>
