<form name="formfiltro" id="formfiltro" action="default.asp" method="post">
    <fieldset>
    <p><label>Código:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="text" name="var_cod_painel" id="var_cod_painel" maxlength="10" placeholder="número" value="<%=strCODPAINEL%>" onKeyPress="return validateNumKey(event);">
        <button class="btn-clear" tabindex="-1"></button>   
    </div>

    <p><label>Rótulo:</label></p>
    <div class="input-control text" data-role="input-control">
        <input type="text" name="var_rotulo" id="var_rotulo" maxlength="250" placeholder="número" value="<%=strROTULO%>" >
        <button class="btn-clear" tabindex="-1"></button>   
    </div>
  
    <p><label>Tipo:</label></p>
    <div  class="input-control select"  data-role="input-control">
        <select name="var_tile_type" id="var_tile_type"> 
            <option value="">[selecione]</option>
            <option value="half"   <%if (strTILETYPE ="half")   then response.Write("selected") end if %> >half</option>
            <option value=""       <%if (strTILETYPE ="tile")   then response.Write("selected") end if %> >tile</option>
            <option value="double" <%if (strTILETYPE ="double") then response.Write("selected") end if %> >double</option>
            <option value="triple" <%if (strTILETYPE ="triple") then response.Write("selected") end if %> >triple</option>
         </select>
    </div>
    
    <p><label>Visualização:</label></p>
     <div class="input-control select">
        <select name="var_tile_view" id="var_tile_view" >
            <option value="">[selecione]</option>
            <option value="PUBLIC"  <%if (strTILEVIEW ="PUBLIC") then response.Write("selected") end if %> >PUBLIC</option>
            <option value="PRIVATE" <%if (strTILEVIEW ="PRIVATE") then response.Write("selected") end if %> >PRIVATE</option>
            <option value="MOBILE"  <%if (strTILEVIEW ="MOBILE") then response.Write("selected") end if %> >MOBILE</option>
            <option value="PAINEL"  <%if (strTILEVIEW ="PAINEL") then response.Write("selected") end if %> >PAINEL</option>
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

    <!-- HIDDEN - ITENS POR PAGINA, campo recebe parametros na função "EnviaParamFiltro" //-->
    <div class="input-control select">
        <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
    </div>
    
    <div>
        <legend></legend>
        <button type="submit" class="button primary">ATUALIZAR</button>
    </div>
    </fieldset>
</form> 