<form name="formfiltro" id="formfiltro" action="default.asp" method="post" >
    <fieldset>
    <!-- <p><label>Código</label></p>
        <div class="input-control text" data-role="input-control">
            <p><input type="text" name="var_idauto" id="var_idauto" maxlength="10" placeholder="número" value="<'%=strIDAUTO%>">
            </p><button class="btn-clear" tabindex="-1"></button>   
        </div>//-->
     <p><label>Cód.Info:</label></p>
        <div  class="input-control select"  data-role="input-control">
			<p><select name="var_codigo" id="var_codigo"> 
                <option value="" <%if (strCODIGO="todos") or (strCODIGO = "") then response.Write("selected") end if %>>[selecione]</option>
                <%montaCombo   "STR", "SELECT distinct COD_INFO ,COD_INFO from sys_site_info " ,"COD_INFO" , "COD_INFO", strCODIGO%>
             </select></p>           
        </div>
     <p><label>Descrição:</label></p>
        <div class="input-control text" data-role="input-control">
            <p><input type="text" name="var_descricao" id="var_descricao" maxlength="10" placeholder="número" value="<%=strDESCRICAO%>">
            </p><button class="btn-clear" tabindex="-1"></button>   
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
