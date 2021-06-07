
<form name="formfiltro" id="formfiltro" method="post" action="default.asp" >
    <fieldset>
        <p><label>C�digo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_codativ" id="var_codativ" maxlength="10" placeholder="n�mero" value="<%=strCODATIV%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>ID:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_idauto" id="var_idauto" maxlength="10" placeholder="n�mero" value="<%=strIDAUTO%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Atividade:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_atividade" id="var_atividade" maxlength="250" placeholder="texto/n�mero" value="<%=strATIVIDADE%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Res.Atividade:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_ativmini" id="var_ativmini" maxlength="250" placeholder="texto/n�mero" value="<%=strATIVMINI%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
          <p><label>Res.Atividade INTL:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_ativminiintl" id="var_ativminiintl" maxlength="250" placeholder="texto/n�mero" value="<%=strATIVMINI%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Atividade Pai:</label></p>
        <div class="input-control select">
            <select name="var_codativ_pai" id="var_codativ_pai" >
	            <option value="" selected="selected">[selecione]</option>
	<% montaCombo "STR" ,"SELECT CODATIV, ATIVIDADE, ATIVMINI FROM tbl_ATIVIDADE WHERE CODATIV_PAI IS NULL GROUP BY CODATIV ;", "CODATIV", "ATIVIDADE", strCODATIVPAI %>

            </select>
        </div>
        
        <!-- HIDDEN - ITENS POR PAGINA , campo recebe parametros na fun��o "EnviaParamFiltro" //-->
        <div class="input-control select">
            <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
        </div>
        
         <div class="input-control select">
            <input type="hidden" name="var_acao" id="var_acao" value="<%=exportaREL%>">
        </div>
        
        <div>
            <legend></legend>
            <button type="submit" class="button primary">ATUALIZAR</button>
        </div>
    </fieldset>
</form>    
