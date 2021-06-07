<!--#include file="../_database/config.inc"-->
<!--#include file="../_database/athDbConn.asp"--> 
<!--#include file="../_database/athUtils.asp"--> 
<!--#include file="../_scripts/scripts.js"-->
<%
AbreDBConn objConn, CFG_DB_DADOS

Sql1="SELECT id_areageo, Nome_AreaGeo FROM tbl_Areage OORDER BY ID_AreaGeo"
Set objRSAREAGEO = objConn.Execute(SQl1)
While Not objRSAREAGEO EOF

	
	Sql2="SELECT CEP_INI, CEP_FIM FROM TBL_AREAGEO_CEP WHERE ID_AREAGEO = "&objRSAREAGEO("ID_AreaGeo")
	SET objRS_CEP = objConn.Execute(Sql2)
	
	While NOt obj_CEP.EOF 
	 
	 
	 	strSQLEVENTO2 = "SELECT tbl_evento.NOME, tbl_evento.COD_EVENTO FROM tbl_evento ORDER BY tbl_evento.Nome ASC"
		set objRS_EVENTO2 = objConn.Execute(strSQLEVENTO2)
			
	
			strTOTAL2=0
			
			Do While NOT objRS_EVENTO2.EOF
			
				strTOTAIS = "SELECT Count(tbl_empresas.COD_EMPRESA) AS Total2 "&_
							" FROM (tbl_empresas INNER JOIN tbl_controle_in_hist ON tbl_empresas.COD_EMPRESA = tbl_controle_in_hist.COD_EMPRESA) INNER JOIN tbl_pais ON tbl_empresas.END_PAIS = tbl_pais.PAIS "&_
							" WHERE tbl_empresas.END_CEP BETWEEN ('"&objRS_CEP("Cep_Ini")&"') And ('"&objRS_CEP("Cep_Fim")&"') AND tbl_controle_in_hist.Cod_Evento="&objRS_EVENTO2("COD_EVENTO")&" AND tbl_pais.ID_PAIS='"&objRS_CEP("ID_Pais")&"'"
				set objRS_TOTAIS = objConn.Execute(strTOTAIS)
	 	total=total&","&objRS_TOTAIS("Total2")
	 
	 

%>

