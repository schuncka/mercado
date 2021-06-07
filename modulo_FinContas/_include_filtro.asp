<form name="formfiltro" id="formfiltro" action="default.asp" method="post">
    <fieldset>
        <p><label>Loja Show</label></p>
        <div class="input-control select" >
            <select name="var_ativo" id="var_ativo">
            <option value="1">Ativo</option>
            <option value="0">Inativo</option>
            <option value="todos" selected>[selecione]</option>
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