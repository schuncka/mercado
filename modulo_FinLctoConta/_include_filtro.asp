<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>C�digo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_lctoconta" id="var_cod_lctoconta" maxlength="10" placeholder="n�mero" value="<%=strCODLCTOCONTA%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Opera��o:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_operacao" id="var_operacao" maxlength="250" placeholder="texto/n�mero" value="<%=strOPERACAO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>

        <p><label>Tipo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_tipo" id="var_tipo" maxlength="250" placeholder="texto/n�mero" value="<%=strTIPO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>

        <p><label>Per�odo:</label></p>
        <div class="input-control select" data-role="input-control">
            <select name="var_periodo" id="var_periodo" class="" size="1" onchange="ShowPeriodo();" onblur="ShowPeriodo();" onfocus="ShowPeriodo();"><!--onChange="var_dt_ini.value=''; var_dt_fim.value='';"//-->
					<option value="ULT_15D" 	<%if strPERIODO = "ULT_15D"  		then response.Write("selected") end if %>>�ltimos 15 dias</option>
					<option value="MES_ATUAL" 	<%if strPERIODO = "MES_ATUAL"  		then response.Write("selected") end if %>>M�s atual</option>
					<option value="MES_ANTERIOR"<%if strPERIODO = "MES_ANTERIOR"  	then response.Write("selected") end if %>>M�s anterior</option>
					<option value="INIC_ANO"	<%if strPERIODO = "INIC_ANO"  		then response.Write("selected") end if %>>Desde in�cio do ano</option>
					<option value="ULT_60D" 	<%if strPERIODO = "ULT_60D"  		then response.Write("selected") end if %>>�ltimos 60 dias</option>
					<option value="ULT_90D" 	<%if strPERIODO = "ULT_90D"  		then response.Write("selected") end if %>>�ltimos 90 dias</option>
					<option value="ULT_12M" 	<%if strPERIODO = "ULT_12M"  		then response.Write("selected") end if %>>�ltimos 12 meses</option>
					<option value="ESPECIFICO" 	<%if strPERIODO = "ESPECIFICO"  	then response.Write("selected") end if %>>Espec�fico</option>
            </select>
        </div>
		<% if  strPERIODO <> "" then %>
			<%
            if  strPERIODO = "ESPECIFICO" then 
            	response.Write("<div id='show_especifico' style='display:block;'>")
            else 
            	response.Write("<div id='show_especifico' style='display:none;'>")
            end if 
            %>
            <p><label>De:</label></p>
            <div class="input-control text" data-role="input-control">
                <div class="input-control text size2 " data-role="input-control">
                    <p class="input-control text span2 " data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade">
                    <input id="var_dt_ini" name="var_dt_ini" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class=""  />
                    <span class="btn-date"></span>
                	</p>
                </div>
                <div class="input-control text size2" data-role="input-control">                                        
                    <p class="input-control text span2" data-role="datepicker"  data-format="dd/mm/yyyy" data-position="top|bottom" data-effect="none|slide|fade" >
                    <input id="var_dt_fim" name="var_dt_fim" type="text" placeholder="<%=Date()%>" value="" maxlength="11" class="" />
                    <span class="btn-date"></span>
                    </p>
                </div>    
                </div>
            </div>
        <% end if %>
        <p><label>Conta:</label></p>
        <div class="input-control select" data-role="input-control">  
        	<select name="var_fin_conta" id="var_fin_conta" class="edtext_combo" style="width:183px">
        	<option value="" <%if strPERIODO = ""  		then response.Write("selected") end if %>>[Conta]</option>
            <% montaCombo "STR" ,"SELECT COD_CONTA, NOME FROM FIN_CONTA WHERE DT_INATIVO IS NULL ORDER BY NOME", "COD_CONTA", "NOME", "" %>
        	</select>
        </div>     
        <!-- HIDDEN - ITENS POR PAGINA , campo recebe parametros na fun��o "EnviaParamFiltro" //-->
        <div class="input-control select">
            <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
        </div>
        
        <div>
            <legend></legend>
            <button type="submit" class="button primary">ATUALIZAR</button>
        </div>
    </fieldset>
</form>    
