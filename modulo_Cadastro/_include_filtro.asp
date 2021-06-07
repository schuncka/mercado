											
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><lable>Código:</lable></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_empresa" id="var_cod_empresa" maxlength="10" placeholder="número" value="<%=strCOD_EMPRESA%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><lable>Nome Cliente:</lable></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_nomecli" id="var_nomecli" maxlength="250" placeholder="texto/número" value="<%=strNOMECLI%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><lable>Endereço Full:</lable></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_end_full" id="var_end_full" maxlength="250" placeholder="texto/número" value="<%=strEND_FULL%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><lable>End Estado:</lable></p>
        <div class="input-control select">
            <select name="var_end_estado" id="var_end_estado" >
	            <option value="" <%if strEND_ESTADO = "" then response.Write("selected")%>>[selecione]</option>
				<% montaCombo "STR" ,"SELECT distinct ESTADO_EVENTO AS UF, ESTADO_EVENTO FROM tbl_evento WHERE ESTADO_EVENTO is not null ORDER BY 1", "UF", "ESTADO_EVENTO", strEND_ESTADO %>
            </select>
        </div>
        
                <p><lable>Tipo Pess:</lable></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_tipo_pess" id="var_tipo_pess" maxlength="250" placeholder="texto/número" value="<%=strTIPO_PESS%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>

        
        <p><lable>Situação:</lable></p>
        <div class="input-control select" >
            <select name="var_sys_inativo" id="var_sys_inativo">
            <option value="ativo"   <%if strSYS_INATIVO  ="ativo" then response.Write("selected") end if %>                    >Ativos</option>
            <option value="inativo" <%if strSYS_INATIVO  ="inativo" then response.Write("selected") end if %>                  >Inativos</option>
            <option value="todos"   <%if (strSYS_INATIVO ="todos") or (strSYS_INATIVO = "") then response.Write("selected") end if %>>[selecione]</option>
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
