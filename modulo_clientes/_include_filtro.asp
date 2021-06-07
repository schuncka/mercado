<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_cliente" id="var_cod_cliente" maxlength="10" placeholder="número" value="<%=strCOD_CLIENTE%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
      <p><label>Razão Social:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_razao" id="var_razao" maxlength="250" placeholder="texto/número" value="<%=strRAZAO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>CNPJ/CPF:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cnpj" id="var_cnpj" maxlength="250" placeholder="texto/número" value="<%=strCNPJ%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        <p><label>Cidade:</label></p>
        <div class="input-control text" data-role="input-control">
	        <input id="var_cidade" name="var_cidade" type="text" placeholder="texto/número" value="<%=strCIDADE%>">
        </div>
        <p><label>Tipo:</label></p>
        <div class="input-control text" data-role="input-control">
	        <input id="strTIPO" name="strTIPO" type="text" placeholder="texto/número" value="<%=strTIPO%>">
        </div>
        <p><label>Marca:</label></p>
        <div class="input-control text" data-role="input-control">
	        <input id="var_marca" name="var_marca" type="text" placeholder="texto/número" value="<%=strMARCA%>">
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
