<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>C�digo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_produto" id="var_cod_produto" maxlength="10" placeholder="n�mero" value="<%=strCOD_PRODUTO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
      <p><label>Raz�o Social:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_produto" id="var_produto" maxlength="250" placeholder="texto/n�mero" value="<%=strPRODUTO%>">
            <button class="btn-clear" tabindex="-1"></button>   
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
