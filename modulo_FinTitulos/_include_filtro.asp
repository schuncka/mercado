<form name="formfiltro" id="formfiltro" action="default.asp" method="post">
    <fieldset>
        <p><label>C�digo:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_titulo" id="var_cod_titulo" maxlength="10" placeholder="n�mero" value="<%=strCODTIT%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Data In�cio:</label></p>
        <div class="input-control text" data-role="input-control">
            <input name="var_dt_ini" id="var_dt_ini" maxlength="250" placeholder="data in�cio" value="<%=strDT_INI%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
    
        <p><label>Data Fim:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_dt_fim" id="var_dt_fim" maxlength="250" placeholder="data fim" value="<%=strDT_FIM%>">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Situa��o:</label></p>
        <div class="input-control select">
            <select name="var_situacao" id="var_situacao" >
	            <option value="" 			<%If strSITUACAO = "" 				then response.Write("selected") end if%>>[SELECIONE]</option>
                <option value="ABERTA" 		<%If strSITUACAO = "ABERTA" 		then response.Write("selected") end if%>>ABERTA</option>
                <option value="LCTO_PARCIAL"<%If strSITUACAO = "LCTO_PARCIAL" 	then response.Write("selected") end if%>>LCTO PARCIAL</option>
                <option value="LCTO_TOTAL" 	<%If strSITUACAO = "LCTO_TOTAL" 	then response.Write("selected") end if%>>LCTO TOTAL</option>
                <option value="CANCELADA" 	<%If strSITUACAO = "CANCELADA" 		then response.Write("selected") end if%>>CANCELADA</option>
            </select>
        </div>
        <p><label>Tipo:</label></p>
        <div class="input-control select">
            <select name="var_tipo" id="var_tipo" >
	            <option value=""  <%If strTIPO = ""  then response.Write("selected") end if%>>[SELECIONE]</option>
                <option value="1" <%If strTIPO = "1" then response.Write("selected") end if%>>PAGAR</option>
                <option value="0" <%If strTIPO = "0" then response.Write("selected") end if%>>RECEBER</option>       
            </select>
        </div>
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


 
 

<!-- strCONTA_PREVISTA  = Replace(GetParam("var_cta_prevista"),"'","''")
 strCODIGO_ENT      = Replace(GetParam("var_cod_entidade"),"'","''")
 strCODCCUSTO       = Replace(GetParam("var_cod_custo"),"'","''")
 strCODCONTRATO     = Replace(GetParam("var_cod_contrato"),"'","''")  'aqui muito possivel dever� ser o codigo da inscricao
 
 //-->
