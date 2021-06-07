<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<%
 Dim objConn, objRS, strSQL 
 Dim strCEP
 Dim strENDER, strBAIRRO, strCIDADE, strESTADO, i

 strCEP = getParam("var_cep_search") 
 strCEP = Right("00000000" & strCEP, 8)
 
 AbreDBConn objConn,"BDCEP"
	 
 strSQL =          " SELECT l.endereco, l.logradouro, b.bairro, c.cidade, c.uf, e.estado"
 strSQL = strSQL & "   FROM bdcep.cepbr_endereco l left join bdcep.cepbr_bairro b on l.id_bairro = b.id_bairro"
 strSQL = strSQL & "                         left join bdcep.cepbr_cidade c on l.id_cidade = c.id_cidade"
 strSQL = strSQL & "                         left join bdcep.cepbr_estado e on c.uf = e.uf"
 strSQL = strSQL & "  WHERE l.cep = '" & strCEP & "'" 
	 
 'Response.Write(strSQL&"<BR>")
 Set objRS = objConn.Execute(strSQL)
 If not objRS.EOF Then
%>
<html>
<head>
</head>
<body>
<script type="text/javascript" language="JavaScript">
    parent.SetParentField('formupdate' ,'var_end_logr'   ,'<%=ucase(getVALUE(objRS,"LOGRADOURO"))%>');
    parent.SetParentField('formupdate' ,'var_end_bairro' ,'<%=ucase(getVALUE(objRS,"BAIRRO"))%>');
    parent.SetParentField('formupdate' ,'var_end_cidade' ,'<%=ucase(getVALUE(objRS,"CIDADE"))%>');
    parent.SetParentField('formupdate' ,'var_end_estado' ,'<%=ucase(getVALUE(objRS,"ESTADO"))%>');
    parent.SetParentField('formupdate' ,'var_end_pais'   ,'BRASIL');
</script>
</body>
</html>
<%
 End If
 FechaRecordSet objRS
 FechaDBConn objConn
%>
