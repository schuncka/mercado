<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>C�digo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_lctoconta" id="var_cod_lctoconta" maxlength="10" placeholder="n�mero" value="<%=strCODLCTOCONTA%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Opera��o:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_operacao" id="var_operacao" maxlength="250" placeholder="texto/n�mero" value="<%=strOPERACAO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>

        <p><label>Tipo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_tipo" id="var_tipo" maxlength="250" placeholder="texto/n�mero" value="<%=strTIPO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>

 <!--   
 		<p><label>Situa��o:</label></p>
        <div class="input-control select" >
            <select name="var_sys_inativo" id="var_sys_inativo">
            <option value="ativo"   <%'if strSYS_INATIVO  ="ativo" then response.Write("selected") end if %>                    >Ativos</option>
            <option value="inativo" <%'if strSYS_INATIVO  ="inativo" then response.Write("selected") end if %>                  >Inativos</option>
            <option value="todos"   <%'if (strSYS_INATIVO ="todos") or (strSYS_INATIVO = "") then response.Write("selected") end if %>>[selecione]</option>
            </select>
        </div>
-->
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
