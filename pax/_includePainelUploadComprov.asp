<%
  ' ATENÇÂO ------------------------------------------------------------------------------
  ' Este include é adicionada como parte integranda da PAINEL.ASP
  ' sendo ele incluso numa parte de código em laço de recordset(objRS).
  ' --------------------------------------------------------------------------------------
  ' Para cada registro, quando necessário, será criado link para visualização de arquivo
  '	e botão(com form) de upload para envio do arquivios (atestado/comprovante)
  ' --------------------------------------------------------------------------------------
  ' --------------------------------------------------------------------------------------
  ' Variáveis estão todas declarasds na página pai deste incluide, ou seja na PAINEL.ASP
  ' --------------------------------------------------------------------------------------
  '	2 Funções JavaSCRIPT necessárias na página pai:
  '	SetFormField(formname, fieldname, valor) ...
  ' UploadImage(formname,fieldname, dir_upload, id_file, tamanho, extensao) ...
  ' ------------------------------------------------------------------------- 09/03/2017 -


  ' -------------------------------------------------------------------------------------------------------
  ' INI: ALGORITIMO exibir da status (ok, em análise e pendente), links de arq e upload -------------------
  strMsgCateg   = "" 'getValue(objRS,"CATEGORIA")
  strMsgObs     = getValue(objRS,"CATEGORIA_OBSERVACAO")
  strMsgLink1   = "comprovante/" & getValue(objRS,"COMPROVANTE_CATEGORIA")
  strMsgLink2   = "comprovante/" & getValue(objRS,"COMPROVANTE_CATEGORIA2")
  strMsgUpload1 = ""
  strMsgUpload2 = ""
	
  If getValue(objRS,"COMPROVANTE_CATEGORIA")<>"" Then
		'strMsgLink1 = "mantém o link1..."
		If getValue(objRS,"COMPROVANTE_CATEGORIA2") <> "" and cint(objRS("QTDE_COMPROVANTE")) >= 2 Then
			'strMsgLink2 = "mantém o link2..."
		else
			strMsgLink2 = ""
		End If
  else 
		strMsgLink1 = ""
		strMsgLink2 = ""
  End If

  strMsgIcoCor = "silver"	
  If getValue(objRS,"UPLOAD_COMPROVANTE") = "1"   then
	  If getValue(objRS,"CHECK_STATUS_PRECO") = "" Then
			If getValue(objRS,"COMPROVANTE_CATEGORIA") = "" Then
				strMsgCateg = "(" & objLang.SearchIndex("msg_pendente",0) & ")"
				strMsgIcoCor = "red"
			else
				strMsgCateg = "(" & objLang.SearchIndex("msg_em_analise",0) & ")"
				strMsgIcoCor = "gray"
			End If
			strMsgUpload1 = "  <i class='icon-upload-3' style='font-size:40px;'></i>"
			If cInt(getValue(objRS,"QTDE_COMPROVANTE")) >= 2 Then
				strMsgUpload2 = "[UPLOAD 2]"
			End If
	  Else
			strMsgCateg = "(" & objLang.SearchIndex("msg_ok",0) & ")"
			strMsgIcoCor = "silver"
			If getValue(objRS,"COMPROVANTE_CATEGORIA") <> "" Then
				'strMsgLink1 = "mantém o link1..."
			else
				strMsgLink1 = ""
			End If
			If getValue(objRS,"COMPROVANTE_CATEGORIA2") <> "" and cInt(getValue(objRS,"QTDE_COMPROVANTE")) >= 2 Then
				'strMsgLink2 = "mantém o link2..."
			else
				strMsgLink2 = ""
			End If
	  End If
  End If
  ' FIM: ALGORITIMO exibir da status (ok, em análise e pendente), links de arq e upload -------------------
  ' -------------------------------------------------------------------------------------------------------
%>
<!-- INI: TabControl - Categoria com OBS. e UPLOAD de arquivos ---------------------------------- //-->
<div class="accordion" data-role="accordion" style="margin-top:5px; margin-bottom:15px;">
    <div class="accordion-frame" style="border:0px solid #999; background-color:#FFF;">
        <a href="#" class="heading" style="background-color:#FFF; padding-left:0; padding-top:5px; padding-bottom:5px;">
            <i class="icon-arrow-down-5 on-right on-left" style="background: <%=strMsgIcoCor%>; color: white; padding: 3px; border-radius: 70%"></i>
            <%=ucase(getValue(objRS,"CATEGORIA"))%>&nbsp;&nbsp;<small><%=strMsgCateg%></small>
        </a>
        <div class="content">
			<%
              Response.Write(strMsgObs)
              Response.Write("<br><br>")
            
              If getValue(objRS,"UPLOAD_COMPROVANTE") = "1"  then 
            %>
                <form name="formcomprovante<%=getValue(objRS,"COD_INSCRICAO")%>" id="formcomprovante<%=getValue(objRS,"COD_INSCRICAO")%>" action="comprovantecategoria.asp" method="post">
                    <input type="hidden" name="var_acao" 					value="">
                    <input type="hidden" name="lng" id="lng" 				value="" />
                    <input type="hidden" name="var_cod_inscricao" 			value="<%=getValue(objRS,"COD_INSCRICAO")%>">
                    <input type="hidden" name="var_comprovante_categoria"	value="<%=getValue(objRS,"COMPROVANTE_CATEGORIA")%>"> 
                    <input type="hidden" name="var_nro_comprovante" 		value="1">
                    <% if strMsgLink1 <> "" then %>
                    <a href="#" onClick="window.open('<%=strMsgLink1%>','','width=540,height=260,top=50,left=50,scrollbars=1');">
                        <button class="image-button bg-silver fg-dark" data-hint="<%=getValue(objRS,"COMPROVANTE_CATEGORIA")%>" data-hint-position="right">
                            <%=Mid(getValue(objRS,"COMPROVANTE_CATEGORIA"),1,18) & "..."%>
                            <i class='icon-eye' style="background-color:#999; color:#CCC;"></i>
                        </button>
                    </a> 
                    <% end if%>
                
                    <% if strMsgUpload1 <> "" then %>                   
                    <a href="#" onClick="javascript:UploadArqComprov('formcomprovante<%=getValue(objRS,"COD_INSCRICAO")%>','var_comprovante_categoria','\\pax\\comprovante\\','<%=getValue(objRS,"COD_INSCRICAO")%>_','','');">
                        <button class="image-button bg-silver fg-dark">
                            Upload1<i class='icon-upload-3' style="background-color:#999; color:#CCC;"></i>
                        </button>                                                        
                    </a> 
                    <% end if %>
                </form>
                <%	If cInt(objRS("QTDE_COMPROVANTE")) >= 2 Then %>
                            <form name="formcomprovante<%=getValue(objRS,"COD_INSCRICAO")%>_2" id="formcomprovante<%=getValue(objRS,"COD_INSCRICAO")%>_2" action="comprovantecategoria.asp" method="post">
                                <input type="hidden" name="var_acao" value="">
                                <input type="hidden" name="lng" id="lng" value="" />
                                <input type="hidden" name="var_cod_inscricao" value="<%=getValue(objRS,"COD_INSCRICAO")%>">
                                <input type="hidden" name="var_comprovante_categoria2" value="<%=getValue(objRS,"COMPROVANTE_CATEGORIA2")%>"> 
                                <input type="hidden" name="var_nro_comprovante" value="2">
                                <% if strMsgLink2 <> "" then %>
                                <a href="#" onClick="window.open('<%=strMsgLink2%>','','width=540,height=260,top=50,left=50,scrollbars=1');">
                                    <button class="image-button bg-silver fg-dark" data-hint="<%=getValue(objRS,"COMPROVANTE_CATEGORIA2")%>" data-hint-position="right">
										<%=Mid(getValue(objRS,"COMPROVANTE_CATEGORIA2"),1,18) & "..."%>
                                        <i class='icon-eye' style="background-color:#999; color:#CCC;"></i>
                                    </button>
                                </a> 
                                <% end if %>
                            
                                <% if strMsgUpload2 <> "" then %>
                                <a href="#" onClick="javascript:UploadArqComprov('formcomprovante<%=getValue(objRS,"COD_INSCRICAO")%>_2','var_comprovante_categoria2','\\pax\\comprovante\\','<%=getValue(objRS,"COD_INSCRICAO")%>_2_','','');">
                                    <button class="image-button bg-silver fg-dark">
                                        Upload2<i class='icon-upload-3' style="background-color:#999; color:#CCC;"></i>
                                    </button>                                                        
                                </a> 
                                <% end if %>
                            </form>
                <% end if %>
            <% End If %>
        </div>
    </div>
</div>
<!-- FIM: TabControl - Categoria com obs e upload de arquivos ---------------------------------- //-->