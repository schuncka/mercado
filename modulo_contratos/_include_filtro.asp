<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_tbl_contrato" id="var_cod_tbl_contrato" maxlength="10" placeholder="número" value="<%=strCOD_CONTRATO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
      <p><label>Razão Social:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_idcontrato" id="var_idcontrato" maxlength="250" placeholder="texto/número" value="<%=strIDCONTRATO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>CNPJ/CPF:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_nomev" id="var_nomev" maxlength="250" placeholder="texto/número" value="<%=strNOMEV%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        <p><label>Cidade:</label></p>
        <div class="input-control text" data-role="input-control">
	        <input id="var_nomec" name="var_nomec" type="text" placeholder="texto/número" value="<%=strNOMEC%>">
        </div>
        <p><label>Tipo:</label></p>
        <div class="input-control text" data-role="input-control">
	        <input id="var_data" name="var_data" type="text" placeholder="texto/número" value="<%=strDATA%>">
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
