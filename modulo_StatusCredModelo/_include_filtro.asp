
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
    <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
        	<input type="text" name="var_codstatuscred_modelo" id="var_codstatuscred_modelo" maxlength="10" placeholder="número" value="<%=strCOD_STATUS_CRED_MODELO%>" onKeyPress="return validateNumKey(event);">
        		<button class="btn-clear" tabindex="-1"></button>   
        </div>
    
    <p><label>Cod.Evento:</label></p>
        <div class="input-control select text" data-role="input-control">
            <select name="var_cod_evento" id="var_cod_evento" >
            <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", strCOD_EVENTO %>
            </select>
        </div> 
        <p><label>Código Status Cred:</label></p>
        <div class="input-control select">
        <select name="var_codstatus_cred" id="var_codstatus_cred" >
       		<option value="" <%if strCOD_STATUS_CRED = ""  then response.Write("selected")%>>[selecione]</option>
        		<% montaCombo "STR" ,"SELECT COD_STATUS_CRED, CONCAT(CAST(COD_STATUS_CRED AS CHAR), ' - ', CAST(STATUS AS CHAR)) AS STATUS FROM tbl_status_cred ORDER BY COD_STATUS_CRED", "COD_STATUS_CRED", "STATUS", strCOD_STATUS_CRED %>
        </select>
        </div>
     <p><label>Modelo Nome:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_modelo_nome" id="var_modelo_nome" maxlength="80" placeholder="" value="<%=strMODELO_NOME%>" >
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
         <p><label>Modelo Layout:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_modelo_layout" id="var_modelo_layout"  placeholder="" value="<%=strMODELO_LAYOUT%>" >
            <button class="btn-clear" tabindex="-1"></button>   
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
