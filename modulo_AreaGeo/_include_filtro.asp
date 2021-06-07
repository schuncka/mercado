<form name="formfiltro" id="formfiltro" action="default.asp" method="post">
    <fieldset>
    <p><label>Código:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="text" name="var_Id_Areageo" id="var_Id_Areageo" maxlength="10" placeholder="número" value="<%=strCODAREA%>" onKeyPress="return validateNumKey(event);">
        <button class="btn-clear" tabindex="-1"></button>   
    </div>

    <p><label>Área:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="text" name="var_areageo" id="var_areageo" maxlength="250" placeholder="número" value="<%=strAREA%>" >
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