<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>C&oacute;digo</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod" id="var_cod" maxlength="10" placeholder="número" value="<%=strCODIGO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Nome</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_nome" id="var_nome" maxlength="250" placeholder="texto/número" value="<%=strNOME%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
      <p><label>Descri&ccedil;&atilde;o</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_descricao" id="var_descricao" maxlength="250" placeholder="texto/número" value="<%=strDESCRICAO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Usuario CA</label></p>
       <div class="input-control text" data-role="input-control">
            <input type="text" name="var_sysuserca" id="var_sysuserca" maxlength="250" placeholder="texto/número" value="<%=strSYSUSERCA%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Situa&ccedil;&atilde;o</label></p>
        <div class="input-control select" >
            <select name="var_ativo" id="var_ativo">
            <option value="ativo"   <%if strATIVO ="ativo" then response.Write("selected") end if %>>Ativos</option>
            <option value="inativo" <%if strATIVO ="inativo" then response.Write("selected") end if %>             >Inativos</option>
            <option value="todos"   <%if (strATIVO="todos")  or (strATIVO = "")  then response.Write("selected") end if %>>[selecione]</option>
            
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