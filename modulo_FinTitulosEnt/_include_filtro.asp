<form name="formfiltro" id="formfiltro" action="default.asp" method="post">
    <fieldset>
        <p><label>Código:</label></p>
        <div class="input-control text" data-role="input-control">
            <input type="text" name="var_cod_titulo" id="var_cod_titulo" maxlength="10" placeholder="número" value="<%=strCODTIT%>" onKeyPress="return validateNumKey(event);">
            <button class="btn-clear" tabindex="-1"></button>   
        </div>
        
        <p><label>Situação:</label></p>
        <div class="input-control select">
            <select name="var_situacao" id="var_situacao" >
                <option value=""             <%if strSITUACAO=""             then Response.Write("selected")%>>[Situação] </option>				
                <option value="ABERTA"       <%if strSITUACAO="ABERTA"       then Response.Write("selected")%>>Aberta     </option>
                <option value="LCTO_PARCIAL" <%if strSITUACAO="LCTO_PARCIAL" then Response.Write("selected")%>>Parcial    </option>
                <option value="LCTO_TOTAL"   <%if strSITUACAO="LCTO_TOTAL"   then Response.Write("selected")%>>Quitada    </option>
                <option value="CANCELADA"    <%if strSITUACAO="CANCELADA"    then Response.Write("selected")%>>Cancelada  </option>											
                <option value="_ABERTA"      <%if strSITUACAO="_ABERTA"      then Response.Write("selected")%>>Não Aberta </option>											
                <option value="_LCTO_TOTAL"  <%if strSITUACAO="_LCTO_TOTAL"  then Response.Write("selected")%>>Não Quitada</option>			
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


 
 

<!-- strCONTA_PREVISTA  = Replace(GetParam("var_cta_prevista"),"'","''")
 strCODIGO_ENT      = Replace(GetParam("var_cod_entidade"),"'","''")
 strCODCCUSTO       = Replace(GetParam("var_cod_custo"),"'","''")
 strCODCONTRATO     = Replace(GetParam("var_cod_contrato"),"'","''")  'aqui muito possivel deverá ser o codigo da inscricao
 
 //-->
