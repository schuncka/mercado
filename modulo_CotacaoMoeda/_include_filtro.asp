
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
  
         <p><label>Código:</label></p>
      <div class="input-control text" data-role="input-control">
            <input type="text" name="var_idauto" id="var_idauto" maxlength="10" placeholder="número" value="<%=strID_AUTO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
      <p><label>Moeda Origem:</label></p>
        <div class="input-control select">
            <select name="var_moedaorigem" id="var_moedaorigem" >
	            <option value="" <%if strCOD_MOEDA_ORIGEM = ""  then response.Write("selected")%>>[selecione]</option>
			  <% montaCombo "STR" ,"SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY COD_MOEDA", "COD_MOEDA", "MOEDA", strCOD_MOEDA_ORIGEM %>
            </select>
        </div>
    
       <p><label>Moeda Destino:</label></p>
        <div class="input-control select">
            <select name="var_moedadestino" id="var_moedadestino" >
	         <option value="" <%if strCOD_MOEDA_DESTINO = ""  then response.Write("selected")%>>[selecione]</option>
			  <% montaCombo "STR" ,"SELECT COD_MOEDA, MOEDA FROM TBL_MOEDA ORDER BY COD_MOEDA", "COD_MOEDA", "MOEDA", strCOD_MOEDA_DESTINO %>
            </select>
        </div>
        
        <p><label>Data Cotação:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_data" id="var_data" maxlength="10" placeholder="AAAA-MM-DD" value="<%PrepData(strDATA),True,True%>" >
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
    <!-- HIDDEN - ITENS POR PAGINA , campo recebe parametros na função "EnviaParamFiltro" //-->
        <div class="input-control select">
            <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
        </div>
        <div class="input-control select">
            <input type="hidden" name="var_codmoeda" id="var_codmoeda" maxlength="10" placeholder="número" value="<%=strCODMOEDA%>" >
        </div>
        
        <div>
            <legend></legend>
            <button type="submit" class="button primary">ATUALIZAR</button>
        </div>
    </fieldset>
</form>    
