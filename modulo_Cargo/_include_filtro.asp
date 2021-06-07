
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_cargos" id="var_cod_cargos" maxlength="10" placeholder="número" value="<%=strCODCARGOS%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>ID:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_campo1" id="var_campo1" maxlength="10" placeholder="número" value="<%=strCAMPO1%>" >
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Descrição:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_campo2" id="var_campo2" maxlength="250" placeholder="texto/número" value="<%=strCAMPO2%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Extra:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_campo3" id="var_campo3" maxlength="250" placeholder="texto/número" value="<%=strCAMPO3%>">
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
