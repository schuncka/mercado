<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
          <input type="text" name="var_idauto" id="var_idauto" maxlength="10" placeholder="número" value="<%=strIDAUTO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        <p><label>Cod.Evento:</label></p>
            <p class="input-control select text" data-role="input-control">
                <select name="var_cod_evento" id="var_cod_evento" >
                <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", strCODEVENTO %>
                </select>
            </p>
        <p><label>Campo:</label></p>
        <div class="input-control text" data-role="input-control">   
          <input type="text" name="var_campo" id="var_campo" maxlength="10" placeholder="número/texto" value="<%=strCAMPO%>" >
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        <p><label>Requerido</label></p>
        <div class="input-control select" >
            <select name="var_requerido" id="var_requerido">
            <option value=""    <%if strREQUERIDO = ""  then response.Write("selected") end if %>>[selecione]</option>
            <option value="1"   <%if strREQUERIDO = "1" then response.Write("selected") end if %> >Sim</option>
            <option value="0"   <%if strREQUERIDO = "0" then response.Write("selected") end if %> >Não</option>
            </select>
        </div>
        <!-- ATENÇÃO, neste primeiro m0omento não existem possibilidades 
        	 diferentes de TABELA, FORMULARIO e ETAPA, logo não há necessidade 
             de manter este filtro 
             ------------------------------------------------------------------

        <p><label>Tabela:</label></p>
        <div class="input-control select">
            <select name="var_tabela" id="var_tabela" >
	             <option value="" selected="selected">[selecione]</option>
				<% 'montaCombo "STR" ,"SELECT distinct TABELA AS CADASTRO, TABELA FROM tbl_formulario_setup WHERE TABELA is not null ORDER BY 1", "CADASTRO", "TABELA", strTABELA %>
            </select>
        </div>
        <p><label>Formulario:</label></p>
        <div class="input-control select">
            <select name="var_formulario" id="var_formulario" >
                 <option value="" selected="selected">[selecione]</option>
                 <% 'montaCombo "STR" ,"SELECT distinct FORMULARIO AS CADASTRO, FORMULARIO FROM tbl_formulario_setup WHERE FORMULARIO is not null ORDER BY 1", "CADASTRO", "FORMULARIO", strFORMULARIO %>
            </select>
        </div>
       <p><label>Etapa:</label></p>
        <div class="input-control select">
          <select name="var_etapa" id="var_etapa" >
	             <option value="" selected="selected">[selecione]</option>
				<% 'montaCombo "STR" ,"SELECT distinct ETAPA AS CADASTRO, ETAPA FROM tbl_formulario_setup WHERE ETAPA is not null ORDER BY 1", "CADASTRO", "ETAPA", strETAPA %>
            </select>
        </div>
        //-->
        
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

