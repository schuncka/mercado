<form name="formfiltro" id="formfiltro" action="default.asp" method="post" >
 <fieldset>
	<p><label>PAPER</label></p>
	<div class="input-control select">
		<select name="var_COD_PAPER" id="var_COD_PAPER" >
			<option value="" <%if strFilCodPaper = "" then response.Write("selected")%>>[selecione]</option>
			<% montaCombo "STR" ,"SELECT cod_paper, CONCAT(CAST(cod_paper AS CHAR),'.',descricao) as descricao FROM tbl_Paper WHERE cod_evento = " & strCOD_EVENTO, "cod_paper", "descricao", strFilCodPaper %>
		</select>
	</div>

	<p><label>Autor</label></p>
	<div class="input-control text" data-role="input-control">
		<p><input type="text" name="var_autor" id="var_autor" maxlength="255"  placeholder="" value="<%=strFilAutor%>"></p>
		<button class="btn-clear" tabindex="-1"></button>   
	</div>

	<p><label>Título</label></p>
    <div class="input-control text" data-role="input-control">
		<p><input type="text" name="var_titulo" id="var_titulo" maxlength="2550"  placeholder="" value="<%=strFilTitulo%>"></p>
		<button class="btn-clear" tabindex="-1"></button>   
	</div>

	<p><label>Área</label></p>
	<div class="input-control select">
		<select name="var_COD_PAPER_AREA" id="var_COD_PAPER" >
			<option value="" <%if strFilCodArea = "" then response.Write("selected")%>>[selecione]</option>
			<% montaCombo "STR" ,"SELECT cod_paper_area, CONCAT(CAST(cod_paper_area AS CHAR),'.',area_paper) as descricao FROM tbl_Paper_Area WHERE cod_evento = " & strCOD_EVENTO, "cod_paper_area", "descricao", strFilCodArea %>
		</select>
	</div>

	<p><label>Status</label></p>
	<div class="input-control select">
		<select name="var_COD_PAPER_STATUS" id="var_COD_PAPER_STATUS" >
			<option value="" <%if strFilStatus = "" then response.Write("selected")%>>[selecione]</option>
			<% montaCombo "STR" ,"SELECT cod_paper_status, CONCAT(CAST(cod_paper_status AS CHAR),'.',`status`) as descricao FROM tbl_Paper_Status WHERE cod_evento = " & strCOD_EVENTO, "cod_paper_status", "descricao", strFilStatus %>
		</select>
	</div>


    
	<!-- Mantém repassando o Cod_inscrição recebido //-->
	<div class="input-control select">
		<input type="hidden" name="var_chavereg" id="var_chavereg" value="<%=strCOD_INSCRICAO%>">
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