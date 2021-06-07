
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
    <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
        	<input type="text" name="var_id_auto" id="var_id_auto" maxlength="10" placeholder="número" value="<%=strCAMPO1%>" onKeyPress="return validateNumKey(event);">
        		<button class="btn-clear" tabindex="-1"></button>   
        </div>
    <!--<p><label>Código Evento:</label></p>
    <div class="input-control text" data-role="input-control">
    <input type="text" name="var_cod_evento" id="var_cod_evento" maxlength="10" placeholder="número" value="<'%=strCAMPO4%>" >
    <button class="btn-clear" tabindex="-1"></button>   
    </div>//-->
    <p><label>Código Evento:</label></p>
        <div class="input-control select">
        <select name="var_cod_evento" id="var_cod_evento" >
        		<% montaCombo "STR" ,"SELECT COD_EVENTO, CONCAT(CAST(COD_EVENTO AS CHAR), ' - ', CAST(NOME AS CHAR)) AS NOME FROM tbl_evento WHERE SYS_INATIVO IS NULL ORDER BY COD_EVENTO DESC", "COD_EVENTO", "NOME", strCAMPO4 %>
        </select>
        </div>
    <p><label>Tipo:</label></p>
        <div  class="input-control select"  data-role="input-control">
        <!-- <input type="text" name="var_tipo" id="var_tipo" maxlength="250" placeholder="texto/número" value="">
        <button class="btn-clear" tabindex="-1"></button>   -->
        <select name="var_tipo" id="var_tipo"> 
            <option value=""            <%if (strCAMPO3 ="todos") or (strCAMPO3 = "") then response.Write("selected") end if %> >Todos</option>
            <option value="Expositor"   <%if  strCAMPO3 ="Expositor" then response.Write("selected") end if %>                  >Expositor</option>
            <option value="Palestrante" <%if strCAMPO3 ="Palestrante" then response.Write("selected") end if %>                >Palestrante</option>
         </select>
        </div>
    <p><label>Titulo:</label></p>
        <div class="input-control select">
        <select name="var_title" id="var_title" >
        	<option value="" <%if strCAMPO2 = ""  then response.Write("selected")%>>[selecione]</option>
       			<% montaCombo "STR" ,"SELECT distinct TITLE AS COD_EVENTO, TITLE FROM tbl_evento_corresp WHERE ID_AUTO = ID_AUTO GROUP BY 1", "COD_EVENTO", "TITLE", strCAMPO2 %>
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
