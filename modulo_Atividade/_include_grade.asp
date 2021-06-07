<% 
If (not objRS.BOF) and (not objRS.EOF) Then 
%>
<style> .indent { height: 50px; }</style>
<table class="tablesort table striped hovered">
<!-- Possibilidades de tipo de sort...  class="sortable-date-dmy" / class="sortable-currency" / class="sortable-numeric" / class="sortable" //-->
    <thead>
        <tr> 
         <th style="width:1%;"></th>
         <th style="width:1%;padding:0px; vertical-align:middle; text-align:center " nowrap><span class="icon-checkbox" onClick="Javascript:data_ToggleCheckAll('msguid_'); return false;" style="cursor:pointer;"></span></th>    
        <% for j=0 to UBound(arrLabels) %>
          <th  nowrap="nowrap"  <%if (arrWidth(j)<>"") then response.write (" style='width:" & arrWidth(j) & ";' ")%> class="<%=arrSort(j)%>" align="left"><%=arrLabels(j)%></th>
        <% next %>
        </tr>
    </thead>
    <tbody>
        <tr>
        <%
        i = 0
        Do While (Not objRS.EOF) and (strFields <>"") and (i < objRS.PageSize)
        %>  
        <!--Menu Action INI-----------------------------------------------------------------------------------------------------//-->
             <td width="3px" align="center">
                    <div class="button-dropdown place-left" style="width:20px; height:20px; border:0px solid #F00;">
                           <img class="dropdown-toggle" src="../img/icon_action.gif"  >                            
                             <ul class="dropdown-menu" data-role="dropdown">
                                <li><%=AthWindow ("update.asp?var_chavereg=" & GetValue(objRS,DKN),  520, 620, "ALTERAR")%></li>
                                <li><%=AthWindow ("detail.asp?var_chavereg=" & GetValue(objRS,DKN),  520, 620, "VISUALIZAR")%></li>
                                <li class="divider">
									<%
                                    if  VerificaDireito ("|DEL|", BuscaDireitosFromDB("modulo_Atividade",Session("METRO_USER_ID_USER")), false) = true then
                                    %>
                                   	 <li><a href="#" style="cursor:pointer;" onClick="Javascript:data_CheckAll('msguid_',false); document.getElementById('msguid_<%=i%>').checked=true; data_DeleteSelect('msguid_','','<%=LTB%>','<%=CFG_DB%>','<%=DKN%>','<%=DLD%>',''); return false;">DELETAR</a></li>
                                    <%
                                    end if
                                    %>
                            </ul>
                    </div>                        
             </td>
        <!--Menu Action FIM-----------------------------------------------------------------------------------------------------//-->
             <td align='center'><input type='checkbox' value='<%=GetValue(objRS,DKN)%>' name='msguid_<%=i%>' id='msguid_<%=i%>'></td>
          <% 
            for j=0 to objRS.Fields.count-1 
              if inStr(strFields, objRS.Fields(j).name)>0 then
                response.Write (" <td  align='left'>")
                strINFO = Server.HTMLEncode(GetValue(objRS,objRS.Fields(j).name))
        
              if (objRS.Fields(j).name = "LOJA_SHOW") Then
                    if (strINFO="0") Then
                        strINFO = Response.Write("<i class='icon-cancel-2'></i>")	
                    else
                        strINFO = Response.Write("<i <i class='icon-checkmark fg-green'></i>")	  
                    End If
                End If
                
                response.Write (strINFO)
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
					<%
                    	if  VerificaDireito ("|DEL|", BuscaDireitosFromDB("modulo_Atividade",Session("METRO_USER_ID_USER")), false) = true then
                    %>
                    <button id="butdelete" name="butdelete" class="button link" alt="Apagar Todos Selecionados" onClick="data_DeleteSelect('msguid_','','<%=LTB%>','<%=CFG_DB%>','<%=DKN%>','<%=DLD%>',''); return false">
                       <i class="icon-forward on-left"></i>deletar
                    </button>
                    <%
					end if
					%>
                 </div> 
                 <div align="center" style="width:40px; height:28px; float:right; text-align:center;border-radius: 25px;  margin-top:5px; padding-top:4px; border:1px solid #00ADEF;" >
                                <i class="icon-cog fg-cyan" id="createFlatWindow" onClick=""  title="Altera Nº de Itens por Página"></i>
                            </div>
                 <div style="width:150px; height:28px; float:right; text-align:center; border:1px solid #00ADEF; border-radius: 25px; background-color:#00ADEF; margin-right:5px; margin-top:5px; padding-top:0px;" >
                  <form name="formPaginar" id="formPaginar" action="default.asp" method="post">
                    <input name="dec" type="button" value="<<" onClick="data_Paginar('formPaginar', 'var_curpage', 'decrementa', 1); return false;" style="background-color:#00ADEF; border:0px; cursor:pointer;  color:#FFF; margin-top:0px;"> 
                    <% 
                     'strALL_PARAMS
                     '"var_cod_evento=&var_nome=&var_pavilhao=Cent&var_estado="
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
                           alt="Página <%=GetCurPage%> de <%=objRS.PageCount%>" title="Página <%=GetCurPage%> de <%=objRS.PageCount%>"> 
                           
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
					
					
					
					function ReportPrintExport(criterio) {
						  if (criterio != '') {
							formReportPrintExport.var_acao.value = criterio;
							formReportPrintExport.submit();
						  }
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
                                        '<label>Linhas por Página</label>' +
                                        '<div class="input-control select">' +
                                        '  <select name="combo_numpage" id="combo_numpage">'+
                                        '    <option value="5"     <%If numPerPage=5    Then response.write(" selected ") End If %> >5</option>'       +
                                        '    <option value="10"    <%If numPerPage=10   Then response.write(" selected ") End If %> >10</option>'      +
                                        '    <option value="20"    <%If numPerPage=20   Then response.write(" selected ") End If %> >20</option>'      +
                                        '    <option value="100"   <%If numPerPage=100  Then response.write(" selected ") End If %> >100</option>'     +
                                        '    <option value="250"   <%If numPerPage=250  Then response.write(" selected ") End If %> >250</option>'     +
                                        '    <option value="500"   <%If numPerPage=500  Then response.write(" selected ") End If %> >500</option>'     +
                                        '    <option value="1000"  <%If numPerPage=1000 Then response.write(" selected ") End If %> >1000</option>'    +
                                        '    <option value="999999"<%If numPerPage>1000 Then response.write(" selected ") End If %> >TODOS</option>'   +
                                             <% IF (inStr("5 , 20 , 30 , 100 , 250 , 500 , 10000 , 999999 ", CStr(numPerPage)&" ")<=0) then response.write("'<option value=" & numPerPage & " selected>"  & numPerPage & "</option>' + " & vbnewline) End IF  %>
                                        '  </select></div>'  +
										' <br>' +
										'  <div><td align="center" class="arial10">Exportar Relatório:' +
																			'		<select name="var_acao" onChange="javascript:ReportPrintExport(this.value);">' +
																			'		   <option value="" selected>Selecione...</option>'   +
																			'		   <option value="printall">Imprimir tudo</option>'   +
																			'		   <option value=".xls">Exportar para Excel</option>' +
																			'		   <option value=".doc">Exportar para Word</option>'  +
																			'		</select>' + 
                                        '<div class="form-actions">'   +
										'<br>'+
                                        '  <button class="button primary" onclick="EnviaParamFiltro(); $.Dialog.close();return false;">ALTERAR</button>' +
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

  <form name="formReportPrintExport" action="ReportPrintExport.asp" method="post" target="_blank">
  <input name="var_acao" type="hidden" value="">
  <input name="var_codativ" type="hidden" value="<%=strCODATIV%>">
  <input name="var_atividade" type="hidden" value="<%=strATIVIDADE%>">
  <input name="var_ativmini" type="hidden" value="<%=strATIVMINI%>">
</form>
<p class="padding20 tertiary-text-secondary">

<%
  'tratamento para visualizar numero de ococrrências e páginas ao fim da body
  response.write(objRS.RecordCount & "&nbsp;Ocorrências, ")
  if (objRS.RecordCount/numPerPage) - fix(objRS.RecordCount/numPerPage)>0 then 
    response.write(fix(objRS.RecordCount/numPerPage)+1) 
  else
    response.write(fix(objRS.RecordCount/numPerPage)) 
  end if	
  response.write(" páginas.") 
%></p>
<div class="indent"></div>
<%
Else
  Mensagem "Não existem dados para esta consulta.<br>Informe novos critérios para efetuar a pesquisa.", "","", true 
End If
'Debug separado e comentado para se necessario. 
'"var_cod_evento=&var_nome=&var_pavilhao=Cent&var_estado="				 
' athDebug "strALL_PARAMS: [" & strALL_PARAMS & "]<br><br>", false
' for each arrItemLC in split(strALL_PARAMS,"&")
'   arrELLC = split(arrItemLC,"=")
'   athDebug "[ input type='hidden' id='" & arrELLC(0) & "' name='" & arrELLC(0) & "' value='" & arrELLC(1) & "' ]<br>", false
' next
%>
