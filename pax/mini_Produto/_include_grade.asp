<% 
If (not objRS.BOF) and (not objRS.EOF) Then 
%>
<style> .indent { height: 50px; }</style>
<table class="tablesort table striped hovered">
<!-- Possibilidades de tipo de sort...  class="sortable-date-dmy" / class="sortable-currency" / class="sortable-numeric" / class="sortable" //-->
    <thead>
        <tr> 
         <th style="width:1%;"></th>
        <% for j=0 to UBound(arrLabels) %>
          <th <%if (arrWidth(j)<>"") then response.write (" style='width:" & arrWidth(j) & ";' ")%> class="<%=arrSort(j)%>" align="left"><%=arrLabels(j)%></th>
        <% next %>
        </tr>
    </thead>
    <tbody>
        <tr>
        <%
        i = 0
        Do While (Not objRS.EOF) and (strFields <>"") and (i < objRS.PageSize)
				strSQL = ""                
				strSQL = "SELECT p.cod_prod, concat(D.ROTULO ,'|' , if(D.DOCUMENTO is null , concat('[',D.URL,']') , CONCAT('[../../modulo_admproduto/docs/',D.DOCUMENTO,']'))) AS ARQUIVO, P.COD_EVENTO "
							strSQL = strSQL & " FROM TBL_PRODUTOS P INNER JOIN TBL_INSCRICAO_PRODUTO IP ON P.COD_PROD = IP.COD_PROD "
							strSQL = strSQL & " LEFT JOIN TBL_DOCUMENTOS D ON D.COD_PROD = P.COD_PROD"
							strSQL = strSQL & " WHERE  p.cod_prod = " & GetValue(objRS,"cod_produto") & " AND   IP.COD_INSCRICAO = "& strCOD_INSCRICAO &" ORDER BY P.TITULO"					
							%>
                            <script language="javascript">//console.log('<%=strSQL%>');</script>
                            <%
							strArquivo = ""
							Set objRSDetail = objConn.Execute(strSQL)
							
							if NOT objRSDetail.EOF Then
							   'Formato:  label1[nomearquivo1],label2[nomearquivo2],label3[nomearquivo3],...
							   'response.write(getValue(objRSDetail,"arquivo"))
							   strINFO =""
							   arrTEMPLinha = ""							   
								DO WHILE NOT objRSDetail.EOF
									arrTEMPLinha = replace(getValue(objRSDetail,"arquivo"),",","") 'eliminando vírgulas colocadas pelo GROUP_CONCAT
		
									arrTEMPLinha = split(arrTEMPLinha,"]")
									for i=0 to ubound(arrTEMPLinha)-1
										arrTEMPStr = split(arrTEMPLinha(i),"[")
										strArquivo = strArquivo & "<a href=""javascript:window.open('" & arrTEMPStr(1) & "','','width=540,height=260,top=50,left=50,scrollbars=1');"">"
										strArquivo = strArquivo & "<i class='icon-link fg-gray'></i>&nbsp;" & replace(UCase(arrTEMPStr(0)),"|","") & "</a><br>"
									next
									objRSDetail.movenext
								loop
							End if	

		
		
		
	
		%>  
        <!--Menu Action INI-----------------------------------------------------------------------------------------------------//-->
             <td width="3px" align="center">             
                   <% If GetValue(objRS,"DOWNLOAD_VINCULO_COD_QUESTIONARIO") <> "" then%>
                            <div class="button-dropdown place-left" style="width:20px; height:20px; border:0px solid #F00;">
                                   <img class="dropdown-toggle" src="../../img/icon_action.gif"  >                            
                                     <ul class="dropdown-menu" data-role="dropdown">
                                     <% 
                                            'If GetValue(objRS,"COD_QUESTIONARIO") <> "" Then 
                                     %>                                
                                                <li><a href="../../modulo_Questionario/pesquisa.asp?var_chavereg=<%=getValue(objRS,"DOWNLOAD_VINCULO_COD_QUESTIONARIO")%>&var_codigos=<%=strCODBARRA%>&var_cod_insc=<%=strCOD_INSCRICAO%>&lng=BR"><%=ucase(objLang.SearchIndex("mini_preencher",0))%></a></li>                                                                                                  
                                     <% 
                                            'End if								
                                     %>                            
                                    </ul>
                                    
                                    
                            </div>
                    <%End If %>
             </td>
        <!--Menu Action FIM-----------------------------------------------------------------------------------------------------//-->
<% 
	 
           
		  
			Dim objRSDetail
            for j=0 to objRS.Fields.count-1 
              if inStr(strFields, objRS.Fields(j).name)>0 then
                response.Write (" <td  align='left'>")
                'strINFO = Server.HTMLEncode(GetValue(objRS,objRS.Fields(j).name))
                strINFO = GetValue(objRS,objRS.Fields(j).name)				
                'response.Write(objRS.Fields(j).name&"<br>")
				if (objRS.Fields(j).name = "TITULO") OR (objRS.Fields(j).name = "DESCRICAO") then
						response.Write Ucase(strINFO)
				end if
				'if (objRS.Fields(j).name = "ARQUIVO") AND (GetValue(objRS,"DOWNLOAD_VINCULO_COD_QUESTIONARIO") = "" ) THEN
				'	response.Write(strArquivo)
				'end if
				
			if (objRS.Fields(j).name = "ARQUIVO") then
				if  GetValue(objRS,"DOWNLOAD_VINCULO_COD_QUESTIONARIO") = "" then
					response.write(strArquivo)
				else if GetValue(objRS,"COD_QUESTIONARIO") <> "" Then
						response.Write(strArquivo)						
					 else
					 	Response.Write(ucase(objLang.SearchIndex("questionario_pendente",0)))				
					 end if
				end if				
				
			end if
				
				
				
				
				
				'if GetValue(objRS,"DOWNLOAD_VINCULO_COD_QUESTIONARIO") <> "" Then
				'	if (objRS.Fields(j).name = "ARQUIVO") AND GetValue(objRS,"COD_QUESTIONARIO") = "" then
				'		Response.Write(ucase(objLang.SearchIndex("questionario_pendente",0)))
				'	else 
				'		if (objRS.Fields(j).name = "ARQUIVO") then
				'			response.Write(strArquivo)
				'		end if
				'	end if
				'	
				'end if
				
				
				'if (objRS.Fields(j).name = "QUESTIONARIO") AND GetValue(objRS,"COD_QUESTIONARIO") <> "" Then
				'	if (GetValue(objRS,"COD_QUESTIONARIO") = "") Then
				'		Response.Write(ucase(objLang.SearchIndex("questionario_pendente",0)))
				'	else 
				'		response.Write(strArquivo)
				'	End If
				'Else
	             '   if (objRS.Fields(j).name = "TITULO") OR (objRS.Fields(j).name = "DESCRICAO") then
				'		response.Write Ucase(strINFO)
				'	end if
				'	if (objRS.Fields(j).name = "ARQUIVO") AND GetValue(objRS,"DOWNLOAD_VINCULO_COD_QUESTIONARIO") = "" then
				'		response.Write(strArquivo)
				'	end if
				'End If		
					
                response.Write ("</td>" & vbnewline)
              end if 
            next		  
          %>
        </tr>
        <%
        i = i + 1
        athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
        Loop
        %>
    </tbody>
    <tfoot>
      <tr>
       <td colspan="<%=UBound(arrFields)+3%>" style="padding-top:3px; border-top:1px solid #000;  background-color:#F8F8F8;" >
            <div style="width:100%; height:35px;">
                 
                 <div style="width:180px; height:25px; float:left; text-align:left; border:0px solid #F00; padding-left:25px;">
                 </div> 
                 <div align="center" style="width:40px; height:28px; float:right; text-align:center;border-radius: 25px;  margin-top:5px; padding-top:4px; border:1px solid #00ADEF;" >
                                <i class="icon-cog fg-cyan" id="createFlatWindow" onClick=""  title="<%=objLang.SearchIndex("mini_altera_pag",0)%>"></i>
                            </div>
                 <div style="width:150px; height:28px; float:right; text-align:center; border:1px solid #00ADEF; border-radius: 25px; background-color:#00ADEF; margin-right:5px; margin-top:5px; padding-top:0px;" >
                  <form name="formPaginar" id="formPaginar" action="default.asp<%="?var_chavereg="&strCOD_INSCRICAO%>" method="post">
                    <input name="dec" type="button" value="<<" onClick="data_Paginar('formPaginar', 'var_curpage', 'decrementa', 1); return false;" style="background-color:#00ADEF; border:0px; cursor:pointer;  color:#FFF; margin-top:0px;"> 
                    <% 
                     Dim arrItemLC, arrELLC 
                     for each arrItemLC in split(strALL_PARAMS,"&")
                       arrELLC = split(arrItemLC,"=")
                       If  (lcase(arrELLC(0))<>"var_curpage") then 
                            response.write("<input type='hidden' id='" & arrELLC(0) & "' name='" & arrELLC(0) & "' value='" & arrELLC(1) & "'>" & vbnewline)
                       End If
                     next
                    %>	
                    <input name="var_curpage" id="var_curpage"
                           type="text" 
                           class="texto_corpo_peq" 
                           value="<%=GetCurPage%>" maxlength="4" 
                           style="width:30px; background-color:#00ADEF; border:0px dotted #FFF; color:#FFF; text-align:center;  margin-top:1px;" 
                           alt="<%=objLang.SearchIndex("mini_pagina",0)%> <%=GetCurPage%> <%=objLang.SearchIndex("mini_de",0)%> <%=objRS.PageCount%>" title="<%=objLang.SearchIndex("mini_pagina",0)%> <%=GetCurPage%> <%=objLang.SearchIndex("mini_de",0)%> <%=objRS.PageCount%>"> 
                    <input name="inc" type="button" value=">>" onClick="data_Paginar('formPaginar', 'var_curpage', 'incrementa', <%=objRS.PageCount%>); return false;" style="background-color:#00ADEF; border:0px; cursor:pointer; color:#FFF; margin-top:0px;">
                  </form>
                </div>								
                 <script>
				 	
                 //esta função iguala os valores do formulário a outro variavel mantendo assim mesmo de depois de um refrash os dados digitado no campo 
                 // de pesquisa					
                    function EnviaParamFiltro(){
                        document.getElementById("formfiltro").var_numperpage.value = document.getElementById("combo_numpage").value;
                        document.getElementById("formfiltro").submit();
                    }
    
                      //Relacionado ao efeito de janela modal no botão do foot que esta ao lado 
                      //do páginador e se localiza dentro do HTML pois no nivel fora do body 
                      //ele não repondeu ao click 	
                    $("#createFlatWindow").on('click', function(){
                        $.Dialog({
                            overlay: true,
                            shadow: true,
                            flat: true,
                            draggable: true,
                            icon: '<i class="icon-cog fg-cyan"></i>',
                            title: 'Flat window',
                            content: '',
                            padding: 10,
                            onShow: function(_dialog){
                                var content = '' +
                                        '<label><%=objLang.SearchIndex("mini_ln_por_pagina",0)%></label>' +
                                        '<div class="input-control select">' +
                                        '  <select name="combo_numpage" id="combo_numpage">'+
                                        '    <option value="5"     <%If numPerPage="5"    Then response.write(" selected ") End If %> >5</option>'       +
                                        '    <option value="10"    <%If numPerPage="10"   Then response.write(" selected ") End If %> >10</option>'      +
                                        '    <option value="20"    <%If numPerPage="20"   Then response.write(" selected ") End If %> >20</option>'      +
                                        '    <option value="100"   <%If numPerPage="100"  Then response.write(" selected ") End If %> >100</option>'     +
                                        '    <option value="250"   <%If numPerPage="250"  Then response.write(" selected ") End If %> >250</option>'     +
                                        '    <option value="500"   <%If numPerPage="500"  Then response.write(" selected ") End If %> >500</option>'     +
                                        '    <option value="1000"  <%If numPerPage="1000" Then response.write(" selected ") End If %> >1000</option>'    +
                                        '    <option value="999999"<%If numPerPage>"1000" Then response.write(" selected ") End If %> >TODOS</option>'   +
                                             <% IF (inStr("5 , 20 , 30 , 100 , 250 , 500 , 10000 , 999999 ", CStr(numPerPage)&" ")<=0) then response.write("'<option value=" & numPerPage & " selected>"  & numPerPage & "</option>' + " & vbnewline) End IF  %>
                                        '  </select></div>'            +
                                        '<div class="form-actions">'   +
                                        '  <button class="button primary" onclick="EnviaParamFiltro();$.Dialog.close();return false;"><%=ucase(objLang.SearchIndex("mini_aplicar",0))%></button>' +
                                        '</div>';
    
                                $.Dialog.title("Config.");
                                $.Dialog.content(content);
                                $.Metro.initInputs('.user-input');
                            }
                        });
                    });
                                
                </script>                
                </div>
       </td>
      </tr>
    </tfoot>
</table>
<p class="padding20 tertiary-text-secondary">

<%
  'tratamento para visualizar numero de ococrrências e páginas ao fim da body
  response.write(objRS.RecordCount & "&nbsp;" & objLang.SearchIndex("mini_ocorrencias",0) & ", ")
  if (objRS.RecordCount/numPerPage) - fix(objRS.RecordCount/numPerPage)>0 then 
    response.write(fix(objRS.RecordCount/numPerPage)+1) 
  else
    response.write(fix(objRS.RecordCount/numPerPage)) 
  end if	
  response.write(" " & lcase(objLang.SearchIndex("mini_paginas",0)) & ".") 
%></p>
<div class="indent"></div>
<%
Else
  Mensagem objLang.SearchIndex("mini_msgvazio",0) , "","", true 
End If
%>