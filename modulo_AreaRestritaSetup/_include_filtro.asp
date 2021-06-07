<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
          <input type="text" name="var_cod_evento" id="var_cod_evento" maxlength="10" placeholder="número" value="<%=strCOD_EVENTO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
         <!--<p><label>Cod.Evento:</label></p>
            <p class="input-control select text" data-role="input-control">
                <select name="var_cod_evento" id="var_cod_evento" >
                <'% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", strCODEVENTO %>
                </select>
            </p>-->
            <p><label>Nome Evento:</label></p>
            <p class="input-control select text" data-role="input-control">
                <select name="var_nome" id="var_nome" >
                <% montaCombo "STR" ,"SELECT NOME, CONCAT(CAST(NOME AS CHAR), ' - ', CAST(COD_EVENTO AS CHAR)) AS COD_EVENTO FROM tbl_evento WHERE SYS_INATIVO IS NULL", "NOME", "NOME", SESSION("NOME_EVENTO") %>
                </select>
            </p>
        <!--<p><label>Nome Evento:</label></p>
        <div class="input-control text" data-role="input-control">   
          <input type="text" name="var_nome" id="var_nome" maxlength="10" placeholder="" value="<%=strNOME%>" >
            <button class="btn-clear" tabindex="-1"></button>   
        </div>//-->
        <p><label>Lingua:</label></p>
        <p class="input-control select text" data-role="input-control">
            <select name="var_lang" id="var_lang" >
            <% montaCombo "STR" ,"SELECT DISTINCT lang FROM tbl_area_restrita_expositor ORDER BY lang", "lang", "lang", strLANG %>
            </select>
        </p>
                
        <!-- HIDDEN - ITENS POR PAGINA , campo recebe parametros na função "EnviaParamFiltro" //-->
        <div class="input-control select">
            <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
        </div>
        
        <div>
            <legend></legend> <!-- Desenha linha separadora //-->
            <button type="submit" class="button primary" >ATUALIZAR</button>
        </div>
    </fieldset>
</form>  

