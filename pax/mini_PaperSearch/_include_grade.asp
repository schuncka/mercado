<% 
If (not objRS.BOF) and (not objRS.EOF) Then 
%>
<style> .indent { height: 50px; }</style>
<table class="tablesort table striped hovered">
<!-- Possibilidades de tipo de sort...  class="sortable-date-dmy" / class="sortable-currency" / class="sortable-numeric" / class="sortable" //-->
    <thead>
        <tr> 
         <th style="width:1%;"></th>
         <th nowrap="nowrap" style='width:5%;' class="sortable-numeric" align="left">Id</th>
         <th nowrap="nowrap" style='width:94%;' class="sortable-numeric" align="left">Paper</th>                  
        </tr>
    </thead>
    <tbody>
        <tr>
        <%
        i = 0
        While (Not objRS.EOF) and (i < objRS.PageSize)
        %>  
        <!--Menu Action INI-----------------------------------------------------------------------------------------------------//-->
             <td width="3px" align="center">
                    <div class="button-dropdown place-left" style="width:20px; height:20px; border:0px solid #F00;">
                           <img class="dropdown-toggle" src="../../img/icon_action.gif"  >                            
                             <ul class="dropdown-menu" data-role="dropdown">
                                <li><%=AthWindow("viewer.asp?strFileName=" & getValue(objRS,"CAMPO_VALOR") & "&cod_paper=" & strFilCodPaper, 520, 400, ucase(objLang.SearchIndex("mini_papersearch_view",0)) )%></li>
                              </ul>
                    </div>                        
             </td>
        <!--Menu Action FIM-----------------------------------------------------------------------------------------------------//-->
             <td><%=getValue(objRS,"IDENTIFICACAO")%></td>
             <%
			 	'Foi criado o campo [EXIBIR_CAMPO_PAX] na [tbl_Paper_Sub], para indicar se este valor deve ou não ser MOSTRAR. 
				'Desta forma, no SQL abaixo poderia desconsiderar campos desse tipo. Entretanto um campo tipo 'F' deveria ser 
				'sempre mostrado, assim como um campo que tenha a nomeclatura "TÍTULO". Pois a construção da grade depende disso.
			 
                strSQL =          " SELECT tbl_Paper_Sub_Valor.CAMPO_VALOR "
                strSQL = strSQL & "		  ,tbl_Paper_Sub.CAMPO_NOME "
                strSQL = strSQL & "		  ,tbl_Paper_Sub.CAMPO_TIPO "
                strSQL = strSQL & "   FROM tbl_Paper_Sub, tbl_Paper_Sub_Valor "
                strSQL = strSQL & "  WHERE tbl_Paper_Sub.COD_PAPER_SUB = tbl_Paper_Sub_Valor.COD_PAPER_SUB"
                strSQL = strSQL & "    AND tbl_Paper_Sub.COD_PAPER = " & getValue(objRS,"COD_PAPER")
				strSQL = strSQL & "    AND tbl_Paper_Sub.EXIBIR_CAMPO_PAX = 1 " 
                strSQL = strSQL & "    AND tbl_Paper_Sub_Valor.COD_PAPER_CADASTRO = " & getValue(objRS,"COD_PAPER_CADASTRO")
                strSQL = strSQL & "  ORDER BY  tbl_Paper_Sub.COD_PAPER_SUB"
                Set objRSDetail = objConn.Execute(strSQL)
                If not objRSDetail.EOF then
				%>
                    <td>
                        <div class="accordion" data-role="accordion" style="margin-top:5px; margin-bottom:15px;">
                            <div class="accordion-frame" style="border:1px solid #999; background-color:#FFF;">
                                <a href="#" class="heading" style="background-color:#f9f9f9; padding-left:5px; padding-top:5px; padding-bottom:5px;">
						            <!-- i class="icon-arrow-down-5 on-right on-left" style="background:silver; color: white; padding:3px; border-radius:70%"></i //-->
                                    <% 
									  'Infelizmente, nesse momento, precisou de uma "gambiarra" pra tentar descobrir o TITILO do trabalho
									  'Neste caso o TITULO sendo o PRIMEIRO campo (campo_ordem menor) irá funcionar satisfatoriamente (por enauanto)
									  'response.write (getValue(objRSDetail,"CAMPO_VALOR"))
									  flagACHOU = false
                                      While ( (not objRSDetail.EOF) and (not flagACHOU) )  
										if (  ( inStr(getValue(objRSDetail,"CAMPO_NOME"),"Título") > 0 ) or ( inStr(getValue(objRSDetail,"CAMPO_NOME"),"Titulo") > 0 ) ) then 
											response.write( getValue(objRSDetail,"CAMPO_VALOR") )
											flagACHOU = true
										end if
                                        objRSDetail.MoveNext
                                      Wend
									%>
                                </a>
	                            <div class="content">
                                    <div class="grid show-grid">
											<%
											    objRSDetail.movefirst
                                                Do While not objRSDetail.EOF 
                                                    if ( getValue(objRSDetail,"CAMPO_VALOR") <> "" ) and ( ucase(getValue(objRSDetail,"CAMPO_TIPO")) <> "F" ) then
								                        response.write ("<div class='row'>")
								                        response.write ("<div class='span3' style='background-color:#f9f9f9; text-align:right; padding:5px;'>" & getValue(objRSDetail,"CAMPO_NOME")  & "</div>")
								                        response.write ("<div class='span8' style='background-color:#e9e9e9; text-align:left;  padding:5px; overflow:hidden;'>" & getValue(objRSDetail,"CAMPO_VALOR") & "</div>")
								                        response.write ("</div>")
                                                        'response.write (getValue(objRSDetail,"CAMPO_NOME")& ": <b>" & getValue(objRSDetail,"CAMPO_VALOR") & "</b><br>")
                                                    end if
                                                    objRSDetail.MoveNext
                                                Loop
                                            %>
                                    </div><!-- Grid //-->
                                </div><!-- Content //-->
                            </div><!-- Accordion Frame //-->
                        </div><!-- Accordion //-->
                    </td>
				<%
                End If
                FechaRecordSet objRSDetail
             %>             
        </tr>
        <%
        i = i + 1
        athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
        Wend
        %>
    </tbody>
    <tfoot>
      <tr>
       <td colspan="6" style="padding-top:3px; border-top:1px solid #000;  background-color:#F8F8F8;" >
            <div style="width:100%; height:35px;">
                 
                 <div style="width:180px; height:25px; float:left; text-align:left; border:0px solid #F00; padding-left:25px;">

                 </div> 
                 <div align="center" style="width:40px; height:28px; float:right; text-align:center;border-radius: 25px;  margin-top:5px; padding-top:4px; border:1px solid #00ADEF;" >
                    <i class="icon-cog fg-cyan" id="createFlatWindow" onClick=""  title="<%=objLang.SearchIndex("mini_altera_pag",0)%>"></i>
                 </div>
                 <div style="width:150px; height:28px; float:right; text-align:center; border:1px solid #00ADEF; border-radius: 25px; background-color:#00ADEF; margin-right:5px; margin-top:5px; padding-top:0px;" >
                  <form name="formPaginar" id="formPaginar" action="default.asp" method="post">
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
                                        '    <option value="5"     <%If numPerPage=5    Then response.write(" selected ") End If %> >5</option>'       +
                                        '    <option value="10"    <%If numPerPage=10   Then response.write(" selected ") End If %> >10</option>'      +
                                        '    <option value="20"    <%If numPerPage=20   Then response.write(" selected ") End If %> >20</option>'      +
                                        '    <option value="100"   <%If numPerPage=100  Then response.write(" selected ") End If %> >100</option>'     +
                                        '    <option value="250"   <%If numPerPage=250  Then response.write(" selected ") End If %> >250</option>'     +
                                        '    <option value="500"   <%If numPerPage=500  Then response.write(" selected ") End If %> >500</option>'     +
                                        '    <option value="1000"  <%If numPerPage=1000 Then response.write(" selected ") End If %> >1000</option>'    +
                                        '    <option value="999999"<%If numPerPage>1000 Then response.write(" selected ") End If %> >TODOS</option>'   +
                                             <% IF (inStr("5 , 20 , 30 , 100 , 250 , 500 , 10000 , 999999 ", CStr(numPerPage)&" ")<=0) then response.write("'<option value=" & numPerPage & " selected>"  & numPerPage & "</option>' + " & vbnewline) End IF  %>
                                        '  </select></div>'            +
                                        '<div class="form-actions">'   +
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
%>
  