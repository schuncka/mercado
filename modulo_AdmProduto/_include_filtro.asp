
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_prod" id="var_cod_prod" maxlength="10" placeholder="número" value="<%=strCOD_PROD%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
		 <p><label>Cod.Evento:</label></p>
        <div class="input-control select text" data-role="input-control">
            <select name="var_cod_evento" id="var_cod_evento" >
            <% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL", "COD_EVENTO", "NOME", strCODEVENTO %>
            </select>
        </div> 
         <p><label>Local:</label></p>
        <div class="input-control select">
            <select name="var_local" id="var_local">
            <option value="" <% if (strLOCAL = "")  then response.Write("selected")%>>[selecione]</option>
				<% montaCombo "STR" ,"SELECT distinct LOCAL as COD_EVENTO,LOCAL from tbl_produtos WHERE ID_AUTO IS NOT NULL GROUP BY LOCAL ORDER BY 1 ", "COD_EVENTO", "LOCAL", strLOCAL %>
            </select>
        </div>
    
       <p><label>Grupo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_grupo" id="var_grupo" maxlength="250" placeholder="texto/número" value="<%=strGRUPO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Titulo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_titulo" id="var_titulo" maxlength="250" placeholder="texto/número" value="<%=strTITULO%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Ambiente:</label></p>
        <div class="input-control select">
            <select name="var_mode" id="var_mode"  class="textbox100" <% If Request("var_mode") <> "" Then Response.Write("readonly") End If %>>
                <option value="" selected>[selecione]</option>
                <!--option value="CAEX" <% If strMODE  = "CAEX" Then Response.Write("selected") End If %>>CAEX</option//-->
                <option value="CONGRESSO" <% If strMODE = "CONGRESSO" Then Response.Write("selected") End If %>>CONGRESSO</option>
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
