<%@ LANGUAGE=vbscript %>
<% Option Explicit %>
<!--#include file="../../_database/adovbs.inc"-->
<!--#include file="../../_database/config.inc"-->
<!--#include file="../../_database/athDbConn.asp"--> 
<!--#include file="../../_database/athUtils.asp"-->
<!--#include file="../../_database/athSendMail.asp"--> 
<%
Dim strCOD_EVENTO, strCPF ,strRETORNO
Dim objConn, objRS, strSQL
Dim fs
DIM strDDI_FONE, strDDD_FONE ,strFONE 			  
DIM strDDI_FONE1, strDDD_FONE1 ,strFONE1 			  
DIM strDDI_CELULAR, strDDD_CELULAR, strCELULAR
DIM strDDI_FONECOML, strDDD_FONECOML, strFONECOML
Dim strDTNasc

strCpf = Request("var_cpf")
strDTNasc = Request("var_dtnasc")
'strCOD_EVENTO = Request("cod_evento")
'response.write(strCodigoPromo)

'response.write("strCodEvento = "& strCOD_EVENTO)
'response.Write("<br>CodigoPromo = " & strCodigoPromo)

If strCPF = "" Then
%>
<form name="formwebservice" action="valida_codigo_promo.asp" method="post" > 
  CODIGO PROMO: <input type="text" name="var_codigo_promo" value=""  />
 <br /> EVENTO: <input type="text" name="cod_evento" value="" />
  <input type="submit" name="butsend" id="butsend" value="Pesquisar">
</form>
<%
Else

	
	
    AbreDBConn objConn, CFG_DB_DADOS

	If strCPF <> "" Then
	  
				strSQL =          "  SELECT	                       	 		"
				strSQL = strSQL & "   ID_NUM_DOC1                   		"
				strSQL = strSQL & " , EMAIL1                        		"
				strSQL = strSQL & " , EMAIL2                        		"
				strSQL = strSQL & " , NOMECLI                       		"
				strSQL = strSQL & " , NOMEFAN                       		"
				strSQL = strSQL & " , DT_NASC                       		"
				strSQL = strSQL & " , SEXO                          		"
				strSQL = strSQL & " , IMG_FOTO                      		"
				strSQL = strSQL & " , FONE3                         		"
				strSQL = strSQL & " , FONE4                         		"
				strSQL = strSQL & " , FONE2                         		"
				strSQL = strSQL & " , FONE1                         		"
				strSQL = strSQL & " , ENTIDADE_CARGO                		"
				strSQL = strSQL & " , ENTIDADE_DEPARTAMENTO         		"
				strSQL = strSQL & " , EMAIL2                        		"
				strSQL = strSQL & " , PORTADOR_NECESSIDADE_ESPECIAL 		"
				strSQL = strSQL & " , END_LOGR 								"
				strSQL = strSQL & " , END_NUM 								"
				strSQL = strSQL & " , END_COMPL 							"
				strSQL = strSQL & " , END_BAIRRO 							"
				strSQL = strSQL & " , END_CIDADE 							"
				strSQL = strSQL & " , END_ESTADO 							"	
				strSQL = strSQL & " , END_PAIS 								"
				strSQL = strSQL & " , END_CEP 								"
				strSQL = strSQL & " , ENTIDADE_CNPJ 						"
				strSQL = strSQL & " , ENTIDADE 								"
				strSQL = strSQL & " , ENTIDADE_FANTASIA 					"
				strSQL = strSQL & " , CODATIV1 								"
				strSQL = strSQL & " , COD_EMPRESA 							"
				strSQL = strSQL & " , CODBARRA 								"
				strSQL = strSQL & " , END_FULL 								"
				strSQL = strSQL & " , TIPO_PESS 							"				
				strSQL = strSQL & " , COD_STATUS_PRECO 						"
				strSQL = strSQL & " , COD_STATUS_CRED 						"
				strSQL = strSQL & " , COD_EMPRESA 	 						"
				strSQL = strSQL & " , TIPO_PESS 	 						"
				strSQL = strSQL & " , IMG_FOTO								"
				strSQL = strSQL & " , SYS_INATIVO							"
				strSQL = strSQL & " , extra_txt_1							"
				strSQL = strSQL & " , extra_txt_2							"
				strSQL = strSQL & " , extra_txt_3							"
				strSQL = strSQL & " , extra_txt_4							"
				strSQL = strSQL & " , extra_txt_5							"
				strSQL = strSQL & " , extra_txt_6							"
				strSQL = strSQL & " , extra_txt_7							"
				strSQL = strSQL & " , extra_txt_8							"
				strSQL = strSQL & " , extra_txt_9							"
				strSQL = strSQL & " , extra_txt_10							"
		 	  	strSQL = strSQL & " , id_num_doc2							"
				strSQL = strSQL & " , homepage								"
				strSQL = strSQL & " , entidade_setor						"
				strSQL = strSQL & " , id_inscr_est							"
				strSQL = strSQL & " FROM tbl_empresas 						"
				
 			  	strSQL = strSQL & " WHERE (id_num_doc1 = '" & strCPF &"'	OR email1 = '"&strCPF&"') AND sys_inativo IS NULL AND NOMECLI IS NOT NULL AND NOMECLI <> '' "
				if strDTNASC <> "vazio" Then
											strSQL = strSQL & " AND DT_NASC = '" & PrepDataIve(strDTNasc,false,false)  & "'"
				end if

	  
	  
'	  response.write(strSQL)
	  Set objRS = objConn.Execute(strSQL)
	  If not objRS.EOF  Then
'			response.write(getValue(objRS,"sys_inativo"))
			'If getValue(objRS,"sys_inativo") = "" Then

						strFONE     = getValue(objRS,"FONE2")
						  If InStr(strFONE," ") > 0 Then	  
							strDDD_FONE = Trim(Left(strFONE,InStr(strFONE," ")))
							strFONE = Trim(Right(strFONE,Len(strFONE)-InStr(strFONE," ")))
							If InStr(strFONE," ") > 0 Then
							  strDDI_FONE = strDDD_FONE
							  strDDD_FONE = Trim(Left(strFONE,InStr(strFONE," ")))
							  strFONE = Trim(Right(strFONE,Len(strFONE)-InStr(strFONE," ")))
							ElseIf InStr(strDDD_FONE,"-") > 0 Then
							  strDDI_FONE = Trim(Left(strDDD_FONE,InStr(strDDD_FONE,"-")-1))
							  strDDD_FONE = Trim(Right(strDDD_FONE,Len(strDDD_FONE)-InStr(strDDD_FONE,"-")))
							End If
						  End If
							  
						  
						  strCELULAR  = getValue(objRS,"FONE3")
						  If InStr(strCELULAR," ") > 0 Then
						  
							strDDD_CELULAR = Trim(Left(strCELULAR,InStr(strCELULAR," ")))
							strCELULAR = Trim(Right(strCELULAR,Len(strCELULAR)-InStr(strCELULAR," ")))
							If InStr(strCELULAR," ") > 0 Then
							  strDDI_CELULAR = strDDD_CELULAR
							  strDDD_CELULAR = Trim(Left(strCELULAR,InStr(strCELULAR," ")))
							  strCELULAR = Trim(Right(strCELULAR,Len(strCELULAR)-InStr(strCELULAR," ")))
							ElseIf InStr(strDDD_CELULAR,"-") > 0 Then
							  strDDI_CELULAR = Trim(Left(strDDD_CELULAR,InStr(strDDD_CELULAR,"-")-1))
							  strDDD_CELULAR = Trim(Right(strDDD_CELULAR,Len(strDDD_CELULAR)-InStr(strDDD_CELULAR,"-")))
							End If
							
						  End If
						  
						  strFONECOML = getValue(objRS,"FONE4")
						  If InStr(strFONECOML," ") > 0 Then
						  
							strDDD_FONECOML= Trim(Left(strFONECOML,InStr(strFONECOML," ")))
							strFONECOML = Trim(Right(strFONECOML,Len(strFONECOML)-InStr(strFONECOML," ")))
							If InStr(strFONECOML," ") > 0 Then
							  strDDI_FONECOML = strDDD_FONECOML
							  strDDD_FONECOML = Trim(Left(strFONECOML,InStr(strFONECOML," ")))
							  strFONECOML = Trim(Right(strFONECOML,Len(strFONECOML)-InStr(strFONECOML," ")))
							ElseIf InStr(strDDD_FONECOML,"-") > 0 Then
							  strDDI_FONECOML = Trim(Left(strDDD_FONECOML,InStr(strDDD_FONECOML,"-")-1))
							  strDDD_FONECOML = Trim(Right(strDDD_FONECOML,Len(strDDD_FONECOML)-InStr(strDDD_FONECOML,"-")))
							End If
							
						  End If
						  
						  strFONE1 = getValue(objRS,"FONE1")
						  If InStr(strFONE1," ") > 0 Then
						  
							strDDD_FONE1= Trim(Left(strFONE1,InStr(strFONE1," ")))
							strFONE1 = Trim(Right(strFONE1,Len(strFONE1)-InStr(strFONE1," ")))
							If InStr(strFONE1," ") > 0 Then
							  strDDI_FONE1 = strDDD_FONE1
							  strDDD_FONE1 = Trim(Left(strFONE1,InStr(strFONE1," ")))
							  strFONE1 = Trim(Right(strFONE1,Len(strFONE1)-InStr(strFONE1," ")))
							ElseIf InStr(strDDD_FONE1,"-") > 0 Then
							  strDDI_FONE1 = Trim(Left(strDDD_FONE1,InStr(strDDD_FONE1,"-")-1))
							  strDDD_FONE1 = Trim(Right(strDDD_FONE1,Len(strDDD_FONE1)-InStr(strDDD_FONE1,"-")))
							End If
							
						  End If
	
	
			  
	
	
	
						strRETORNO = getValue(objRS,"ID_NUM_DOC1")                                         '0
						strRETORNO = strRETORNO &"|"&getValue(objRS,"EMAIL1")                              '1
						strRETORNO = strRETORNO &"|"&getValue(objRS,"NOMECLI")                             '2
						strRETORNO = strRETORNO &"|"&getValue(objRS,"NOMEFAN")                             '3
						strRETORNO = strRETORNO &"|"&getValue(objRS,"DT_NASC")                             '4
						strRETORNO = strRETORNO &"|"&getValue(objRS,"SEXO")                                '5
						strRETORNO = strRETORNO &"|"&getValue(objRS,"IMG_FOTO")                            '6						
						if ucase(request.Cookies("METRO_ProShopPF")("lng")) = "BR" then
							strRETORNO = strRETORNO &"|55"			                                          '7   RESIDENCIAL
						else
							strRETORNO = strRETORNO &"|"&strDDI_FONE                                           '7   RESIDENCIAL
						end if
						strRETORNO = strRETORNO &"|"&strDDD_FONE                                           '8   RESIDENCIAL
						strRETORNO = strRETORNO &"|"&strFONE                                  	           '9   RESIDENCIAL						
						if ucase(request.Cookies("METRO_ProShopPF")("lng")) = "BR" then
							strRETORNO = strRETORNO &"|55"			                                         '10   RESIDENCIAL
						else
						strRETORNO = strRETORNO &"|"&strDDI_CELULAR                                        '10  CELULAR
						end if
						strRETORNO = strRETORNO &"|"&strDDD_CELULAR                                        '11  CELULAR
						strRETORNO = strRETORNO &"|"&strCELULAR                                	           '12  CELULAR						
						if ucase(request.Cookies("METRO_ProShopPF")("lng")) = "BR" then
							strRETORNO = strRETORNO &"|55"			                                          '13   RESIDENCIAL
						else
						strRETORNO = strRETORNO &"|"&strDDI_FONECOML                                       '13  COMERCIAL
						end if
						strRETORNO = strRETORNO &"|"&strDDD_FONECOML                                       '14  COMERCIAL
						strRETORNO = strRETORNO &"|"&strFONECOML                               	           '15  COMERCIAL
						strRETORNO = strRETORNO &"|"&getValue(objRS,"ENTIDADE_CARGO")                      '16
						strRETORNO = strRETORNO &"|"&getValue(objRS,"ENTIDADE_DEPARTAMENTO")               '17
						strRETORNO = strRETORNO &"|"&getValue(objRS,"EMAIL2")                              '18
						strRETORNO = strRETORNO &"|"&getValue(objRS,"PORTADOR_NECESSIDADE_ESPECIAL")       '19
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_LOGR")                            '20
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_NUM")                             '21
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_COMPL")                           '22
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_BAIRRO")                          '23
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_CIDADE")                          '24
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_ESTADO")                          '25
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_PAIS")                            '26
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_CEP")                             '27
						strRETORNO = strRETORNO &"|"&getValue(objRS,"ENTIDADE_CNPJ")                       '28
						strRETORNO = strRETORNO &"|"&getValue(objRS,"ENTIDADE")                            '29
						strRETORNO = strRETORNO &"|"&getValue(objRS,"ENTIDADE_FANTASIA")                   '30
						strRETORNO = strRETORNO &"|"&getValue(objRS,"CODATIV1")                            '31
						strRETORNO = strRETORNO &"|"&getValue(objRS,"COD_EMPRESA")                         '32
						strRETORNO = strRETORNO &"|"&getValue(objRS,"CODBARRA")                            '33
						strRETORNO = strRETORNO &"|"&getValue(objRS,"END_FULL")                            '34
						strRETORNO = strRETORNO &"|"&getValue(objRS,"TIPO_PESS")                           '35
						strRETORNO = strRETORNO &"|"&getValue(objRS,"COD_STATUS_PRECO")                    '36
						strRETORNO = strRETORNO &"|"&getValue(objRS,"COD_STATUS_CRED")                     '37
						strRETORNO = strRETORNO &"|"&getValue(objRS,"EMAIL2")                              '38
						strRETORNO = strRETORNO &"|"&getValue(objRS,"COD_EMPRESA")                         '39
						strRETORNO = strRETORNO &"|"&getValue(objRS,"TIPO_PESS")                           '40
						strRETORNO = strRETORNO &"|"&getValue(objRS,"IMG_FOTO")                            '41
						
						

						set fs=Server.CreateObject("Scripting.FileSystemObject")
						if fs.FileExists(replace(Server.MapPath("./../"),"proshoppf","webcam") & "/imgphoto/" & getValue(objRS,"IMG_FOTO")) then
						  strRETORNO = strRETORNO &"|../webcam/imgphoto/"& getValue(objRS,"IMG_FOTO")
						else
						  strRETORNO = strRETORNO &"|./webcam/imgphoto/unknownuser.jpg"
						end if
						set fs=nothing                                                                 '42
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_1")					   '43	
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_2")					   '44
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_3")					   '45
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_4")					   '46
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_5")					   '47
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_6")					   '48
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_7")					   '49
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_8")					   '50
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_9")					   '51
						strRETORNO = strRETORNO &"|"&getValue(objRS,"extra_txt_10")					   '52
						
						strRETORNO = strRETORNO &"|"&getValue(objRS,"id_num_doc2")					   '53
						strRETORNO = strRETORNO &"|"&getValue(objRS,"homepage")					       '54
						strRETORNO = strRETORNO &"|"&getValue(objRS,"entidade_setor")				   '55
						strRETORNO = strRETORNO &"|"&getValue(objRS,"id_inscr_est")					   '56
						
						if ucase(request.Cookies("METRO_ProShopPF")("lng")) = "BR" then
							strRETORNO = strRETORNO &"|55"			                                          '57   RESIDENCIAL
						else
							strRETORNO = strRETORNO &"|"&strDDI_FONE1                                           '57   RESIDENCIAL
						end if
						strRETORNO = strRETORNO &"|"&strDDD_FONE1                                           '58   RESIDENCIAL
						strRETORNO = strRETORNO &"|"&strFONE1                                  	           '59   RESIDENCIAL	
						
						strRETORNO = strRETORNO &"|ok"                                                 '60
	
	
	
													 
			  'Else 
					'strSQL = "delete from tbl_empresas_sub where cod_empresa = " & getValue(objRS,"cod_empresa")
					'objConn.Execute(strSQL)
					'strSQL = "delete from tbl_empresas where cod_empresa = " & getValue(objRS,"cod_empresa")
					'strSQL = "update tbl_empresas set sys_inativo = null where cod_empresa = " & getValue(objRS,"COD_EMPRESA")
					'objConn.Execute(strSQL)
					'strRETORNO = "error|geranovo| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | "
			  'End If
	  Else 
		  strRETORNO = "error| | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | "		  
	  End If
	'  FechaRecordSet objRS
	response.Write(strRETORNO)
	End If
	
FechaDBConn objConn	  

End If
%>