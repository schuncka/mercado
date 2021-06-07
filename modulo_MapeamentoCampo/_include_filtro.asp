<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
     <p><label>Código</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_mapea" id="var_cod_mapea" maxlength="10" placeholder="número" value="<%=strCODMAPEA%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
     <p><label>Cod.Evento:</label></p>
        <div class="input-control select text" data-role="input-control">
            <select name="var_cod_evento" id="var_cod_evento" >
            <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", strCODEVENTO %>
            </select>
        </div>  
     <p><label>Nome Campo Cliente</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_nomecli" id="var_nomecli" maxlength="10" placeholder="número" value="<%=strNOMECAMPOCLI%>" >
            <button class="btn-clear" tabindex="-1"></button>   
        </div> 
        <p><label>Nome Descrição</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_nomedescri" id="var_nomedescri" maxlength="10" placeholder="número" value="<%=strNOMEDESCRI%>" >
            <button class="btn-clear" tabindex="-1"></button>   
        </div> 
        <p><label>Campo Lista Combo</label></p>
        <div class="input-control select">
            <select name="var_campocombolist" id="var_campocombolist" >
	             <option value="" selected="selected">[selecione]</option>
				<% montaCombo "STR" ,"SELECT distinct CAMPO_COMBOLIST AS CAMPO_COR_DESTAQUE, CAMPO_COMBOLIST FROM tbl_mapeamento_campo WHERE CAMPO_COMBOLIST is not null ORDER BY 1", "CAMPO_COR_DESTAQUE", "CAMPO_COMBOLIST", strCAMPOCOMBOLIST %>
            </select>
        </div>
        <!--<p><label>Campo Cor Destaque</label></p>
        <div class="input-control select">
            <select name="var_campocor" id="var_campocor" >
	            <option value="" selected="selected">[selecione]</option>
				<%' montaCombo "STR" ,"SELECT distinct CAMPO_COR_DESTAQUE AS CAMPO_COMBOLIST, CAMPO_COR_DESTAQUE FROM tbl_mapeamento_campo WHERE CAMPO_COR_DESTAQUE is not null ORDER BY 1", "CAMPO_COMBOLIST", "CAMPO_COR_DESTAQUE", strCAMPOCOR %>
            </select>
        </div>//-->
        <p><label>Loja Show</label></p>
        <div class="input-control select" >
            <select name="var_lojashow" id="var_lojashow">
            <option value="1" 		<%if strLOJASHOW ="1" then response.Write("selected") end if %>>Sim</option>
            <option value="0" 		<%if strLOJASHOW <>"1" then response.Write("selected") end if %>>Não</option>
            <option value="todos"	<%if (strLOJASHOW ="todos") or (strLOJASHOW = "") then response.Write("selected") end if %>>[selecione]</option>
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