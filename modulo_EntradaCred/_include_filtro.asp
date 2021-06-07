<form name="formfiltro" id="formfiltro" action="default.asp" method="post">
    <fieldset>
    <p><label>Código:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="text" name="var_cod_localcredencial" id="var_cod_localcredencial" maxlength="120" placeholder="" value="<%=strCODLOCALCREDENCIAL%>" onKeyPress="return validateNumKey(event);">
        <button class="btn-clear" tabindex="-1"></button>   
    </div>
    <p><label>Nome:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="text" name="var_nome" id="var_nome" maxlength="120" placeholder="" value="<%=strNOME%>">
        <button class="btn-clear" tabindex="-1"></button>   
    </div>
      <p><label>Local:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="text" name="var_local" id="var_local" maxlength="120" placeholder="" value="<%=strLOCAL%>">
        <button class="btn-clear" tabindex="-1"></button>   
    </div>
 <p><label>Descrição:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="textarea" name="var_descricao" id="var_descricao" maxlength="" placeholder="" value="<%=strDESCRICAO%>">
        <button class="btn-clear" tabindex="-1"></button>   
    </div>
    
	<!-- HIDDEN - ITENS POR PAGINA, campo recebe parametros na função "EnviaParamFiltro" //-->
    <div class="input-control select">
        <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
    </div>
    
    <div>
        <legend></legend>
        <button type="submit" class="button primary">ATUALIZAR</button>
    </div>
    </fieldset>
</form> 