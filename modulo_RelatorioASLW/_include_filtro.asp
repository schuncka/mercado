<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_relatorio" id="var_cod_relatorio" maxlength="250" placeholder="texto/numero" value="<%=strCOD_RELATORIO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Nome:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_nome" id="var_nome" maxlength="250" placeholder="texto/numero" value="<%=strNOME%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Categoria:</label></p>
        <div class="input-control select">
            <select name="var_cod_categoria" id="var_cod_categoria"> 
                 <option value="" <%if strCOD_CATEGORIA = "" then response.Write("selected") %>>[selecione]</option> 
		   <% montaCombo "STR" ,"SELECT COD_CATEGORIA, CONCAT(CAST(COD_CATEGORIA AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_ASLW_CATEGORIA ORDER BY NOME", "COD_CATEGORIA", "NOME", strCOD_CATEGORIA %>
        	</select>
        </div>

        <p><label>Situação:</label></p>
		<div class="input-control select" >
            <select name="var_ativo" id="var_ativo">
            <option value="ativo"   <%if strATIVO ="ativo" then response.Write("selected") end if %>                    >Ativos</option>
            <option value="inativo" <%if strATIVO ="inativo" then response.Write("selected") end if %>                  >Inativos</option>
            <option value="todos"   <%if (strATIVO="todos") or (strATIVO = "") then response.Write("selected") end if %>>[selecione]</option>
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
