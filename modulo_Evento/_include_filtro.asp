
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_evento" id="var_cod_evento" maxlength="10" placeholder="número" value="<%=strCODIGO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Nome:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_nome" id="var_nome" maxlength="250" placeholder="texto/número" value="<%=strNOME%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Pavilhão:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_pavilhao" id="var_pavilhao" maxlength="250" placeholder="texto/número" value="<%=strPAVILHAO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Estado:</label></p>
        <div class="input-control select">
            <select name="var_estado" id="var_estado" >
	            <option value="" <%if strESTADO = "" then response.Write("selected")%>>[selecione]</option>
				<% montaCombo "STR" ,"SELECT distinct ESTADO_EVENTO AS UF, ESTADO_EVENTO FROM tbl_evento WHERE ESTADO_EVENTO is not null ORDER BY 1", "UF", "ESTADO_EVENTO", strESTADO %>
            </select>
        </div>
        
        <p><label>Situação:</label></p>
        <div class="input-control select" >
            <select name="var_ativo" id="var_ativo">
            <option value="ativo"   <%if strATIVO ="ativo" then response.Write("selected") end if %>                    >Ativos</option>
            <option value="inativo" <%if strATIVO ="inativo" then response.Write("selected") end if %>                  >Inativos</option>
            <option value="todos"   <%if (strATIVO="todos") or (strATIVO = "") then response.Write("selected") end if %>>[selecione]</option>
            </select>
        </div>

        <!-- HIDDEN - ITENS POR PAGINA , campo recebe parametros na função "EnviaParamFiltro" //-->
        <div class="input-control select">
            <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
        </div>
        
        <div>
            <legend></legend>
            <button type="submit" class="button primary">ATUALIZAR</button>
        </div>
    </fieldset>
</form>    
