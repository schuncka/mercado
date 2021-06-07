<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
    	<p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_cod_usuario" id="var_cod_usuario" maxlength="250" placeholder="numero" value="<%=strCODUSUER%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>ID Usuário:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_id_user" id="var_id_user" maxlength="250" placeholder="texto/numero" value="<%=strIDUSER%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Nome:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_nome" id="var_nome" maxlength="250" placeholder="texto/numero" value="<%=strNOME%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Grupo:</label></p>
        <div class="input-control select">
            <select name="var_grp_user" id="var_grp_user"> 
                 <option value="" <%if strGRPUSER = "" then response.Write("selected")%>>[selecione]</option> 
	            <% montaCombo "STR","SELECT distinct GRP_USER FROM tbl_usuario order BY 1","GRP_USER","GRP_USER",strGRPUSER%>
			</select>
        </div>
        
        <p><label>Temporário:</label></p>
        <div class="input-control select">
            <select name="var_temporario" id="var_temporario" >
            <option value="true"   <%if CStr(strTEMP) = "true" then response.Write("selected") end if %>                   >Sim</option>
            <option value="false"  <%if CStr(strTEMP) = "false" then response.Write("selected") end if %>                  >Não</option>
            <option value="todos"  <%if (strTEMP="todos") or (strATIVO = "") then response.Write("selected") end if %>>[selecione]</option>
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
