
<%

Dim strAgrupamento
Function montaForm(prTipo, prTermoTraducao, prTamanho, prNameField, prObrigatorio, prValue, prPlaceholder, prLength, prJavaScript, prFocus, prRadioValue1, prRadioValue2, pradiolabel1, pradiolabel2, pr_Combo_SQL, pr_Combo_colValue, pr_Combo_colText, pr_Combo_Codigo, pr_divId, pr_style, pr_radioCheck1, pr_radioCheck2, pr_comentario)
	Dim strField
	Dim objRS_local, objConn_local,strVALOR,strTEXTO
	strField = ""
	if prTermoTraducao <> "" Then
	    if uCase(prObrigatorio) = "S" Then
		   strField =  "<label> <font color='red'>*</font> "&objLang.SearchIndex(prTermoTraducao,0)&" </label>" & vbnewline
		else
			 strField = "<label> "&objLang.SearchIndex(prTermoTraducao,0)&" </label>" & vbnewline
		end if
    end if
		select case prTipo  

			case "select"
			
			strField = strField &"<div class='input-control select "&prTamanho&"'>" & vbnewline
			strField = strField &	"<select name='"&prNameField&"' id='"&tornaCampoObrigatorio2(prObrigatorio, prNameField)&"' "& prJavaScript&">" & vbnewline
			strField = strField &		"<option value='' selected>"&objLang.SearchIndex("selecione",0)&"</option>" & vbnewline
			strField = strField &		   montaComboReturn(pr_Combo_SQL, pr_Combo_colValue, pr_Combo_colText, "") 
			strField = strField &	"</select>"
			strField = strField &"</div>"  & vbnewline

			case "radio"

			strField = strField	& "<div>" & vbnewline
			strField = strField &	"<div class='input-control radio default-style' data-role='input-control'>" & vbnewline
			strField = strField &		"<label>" & vbnewline
			strField = strField &			"<input type='radio' name='"&prNameField&"'  id='"&tornaCampoObrigatorio2(prObrigatorio, prNameField &"t")&"' "&pr_radioCheck1&" "& prJavaScript&"  value="&prRadioValue1&" />" & vbnewline
			strField = strField	&			"<span class='check' ></span>"&objLang.SearchIndex(pradiolabel1,0)&"" & vbnewline
			strField = strField	&		"</label>" & vbnewline
			strField = strField	&	"</div>" & vbnewline
			strField = strField	&	"<div class='input-control radio default-style' data-role='input-control'>" & vbnewline
			strField = strField	&		"<label>" & vbnewline
			strField = strField &			"<input type='radio' name='"&prNameField&"' id='"&tornaCampoObrigatorio2(prObrigatorio, prNameField &"f")&"' "&pr_radioCheck2&" "&prJavaScript&" checked='checked' value="&prRadioValue2&" />" & vbnewline
			strField = strField	&			"<span class='check' ></span>"&objLang.SearchIndex(pradiolabel2,0)&"" & vbnewline
			strField = strField	&		"</label>" & vbnewline
			strField = strField	&	"</div>" & vbnewline
			strField = strField	&"</div>" & vbnewline

			case "text" 
		
			strField = strField & "<div class='input-control text "&prTamanho&"' data-role='input-control' style='"&pr_style&"' id='"& pr_divId &"'>" & vbnewline 
			strField = strField & 	"<input type='text' placeholder='"&objLang.SearchIndex(prPlaceholder,0)&"' id='"&tornaCampoObrigatorio2(prObrigatorio, prNameField)&"' name='"& prNameField &"' "&prFocus&" maxlength='"& prLength &"' " & prJavaScript &">" & vbnewline
			strField = strField	& 	"<button class='btn-clear' tabindex='-1'></button>" & vbnewline
			strField = strField & "</div>" & vbnewline
			if pr_comentario <>"" Then
				strField = strField & "   <small>"&objLang.SearchIndex(pr_comentario,0)&"</small>"
			end if
			case "number"
			
			strField = strField &"<div class='input-control number "&prTamanho&"' data-role='input-control'>" & vbnewline
			strField = strField	& 	"<input type='number' placeholder='"&objLang.SearchIndex(prPlaceholder,0)&"' "&prFocus&" " & prJavaScript &" maxlength='"&prLength &"' id='"&tornaCampoObrigatorio2(prObrigatorio, prNameField)&"' name='"& prNameField &"'>" & vbnewline
			strField = strField	& 	"<button class='btn-clear' tabindex='-1'></button>" & vbnewline
			strField = strField	& "</div>" & vbnewline

			case "email"
		
			strField = strField &"<div class='input-control email "&prTamanho&"' data-role='input-control'>" & vbnewline
			strField = strField	&	"<input type='email'  placeholder='"&objLang.SearchIndex(prPlaceholder,0)&"' id='"&tornaCampoObrigatorio2(prObrigatorio, prNameField)&"' name='"& prNameField &"' "&prFocus&" maxlength='"& prLength &"' " & prJavaScript &">" & vbnewline
			strField = strField	&	"<button class='btn-clear' tabindex='-1'></button>" & vbnewline
			strField = strField	&"</div>" & vbnewline

			case "foto_br"

            strField =              "<label>"
            strField = strField &"      <i class='icon-camera on-lef style='background: white; color: black; padding: 5px;'onclick='javascript:CapturaImage(""frm_dados"",""var_img_foto"",document.getElementById(""var_id_numdoc1_ô"").value,""img_captura"");'></i>"
            strField = strField &"      <span onclick='javascript:CapturaImage(""frm_dados"",""var_img_foto"",document.getElementById(""var_id_numdoc1_ô"").value,""img_captura"");'>"&objLang.SearchIndex("captura_imagem",0)&"</span>"
			strField = strField &"	</label>"
            strField = strField &"  <div class='input-control' data-role='input-control'>"
            strField = strField &"       <input type='hidden' placeholder='webcam' name='var_img_foto' id='var_img_foto' value='' onchange='alteraFoto(""img_captura"",this.value);'>"                       
            strField = strField &"       <img id='img_captura' src='./webcam/imgphoto/unknownuser.jpg' border='1' onclick='javascript:CapturaImage(""frm_dados"",""var_img_foto"",document.getElementById(""var_id_numdoc1_ô"").value,""img_captura"");'>"			
            strField = strField &"  </div>"
        
            case "foto_nao_br"

            strField =              "<label>"
			strField = strField &" 		<i class='icon-camera on-left' style='background: white; color: black; padding: 5px;'' onclick='javascript:CapturaImage(""frm_dados"",""var_img_foto"","""&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")&StrReverse(request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId"))&""",""img_captura"");'></i>"
			strField = strField &" 		<span onclick='javascript:CapturaImage(""frm_dados"",""var_img_foto"","""&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")&StrReverse(request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId"))&""",""img_captura"");'>"&objLang.SearchIndex("clique_aqui_para_capturar_sua_imagem",0)&"</span>"
			strField = strField &"   </label>"
			strField = strField &" 	<div class='input-control' data-role='input-control'>"
			strField = strField &" 	    <input type='hidden' placeholder='webcam' name='var_img_foto' id='var_img_foto' value='' onchange='alteraFoto(""img_captura"",this.value);'>"                       
			strField = strField &" 	    <img id='img_captura' src='./webcam/imgphoto/unknownuser.jpg' border='1' onclick='javascript:CapturaImage(""frm_dados"",""var_img_foto"","""&request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId")&StrReverse(request.cookies("METRO_ProshopPF")("METRO_ProShopPF_sessionId"))&""",""img_captura"");'>"
			strField = strField &" 	</div>"
			
			
			case "foto_hidden"

			'strField = strField &" 	<div class='input-control' data-role='input-control' style='display:none;'>"
			strField = strField &" 	    <input type='hidden' placeholder='webcam' name='var_img_foto' id='var_img_foto' value=''>"                       
			strField = strField &" 	    <img id='img_captura' src='./webcam/imgphoto/unknownuser.jpg' style='display:none; width:20px; height:20px'>"
			'strField = strField &" 	</div>"


		end select

		response.write(strField)

	end function



Dim strSQLCampos, objRSCampos

strSQLCampos = "                 SELECT t1.idioma"
strSQLCampos = strSQLCampos & "		 ,t1.cod_evento"
strSQLCampos = strSQLCampos & "		 ,t1.obrigatorio"
strSQLCampos = strSQLCampos & "		 ,t1.habilitado"
strSQLCampos = strSQLCampos & "		 ,t2.tipo"
strSQLCampos = strSQLCampos & "		 ,t2.termo_traducao"
strSQLCampos = strSQLCampos & "	     ,t2.tamanho"
strSQLCampos = strSQLCampos & "		 ,t2.name_field"
strSQLCampos = strSQLCampos & "		 ,t2.value"
strSQLCampos = strSQLCampos & "      ,t2.placeholder"
strSQLCampos = strSQLCampos & "      ,t2.length"
strSQLCampos = strSQLCampos & "      ,t2.javascript"
strSQLCampos = strSQLCampos & "      ,t2.style"
strSQLCampos = strSQLCampos & "      ,t2.array"
strSQLCampos = strSQLCampos & "      ,t2.focus"
strSQLCampos = strSQLCampos & "      ,t1.radio_value2"
strSQLCampos = strSQLCampos & "      ,t1.radio_label1"
strSQLCampos = strSQLCampos & "      ,t1.radio_value1"
strSQLCampos = strSQLCampos & "      ,t1.radio_label2"
strSQLCampos = strSQLCampos & "      ,t1.radio_check1"
strSQLCampos = strSQLCampos & "      ,t1.radio_check2"
strSQLCampos = strSQLCampos & "      ,t1.combo_sql"
strSQLCampos = strSQLCampos & "      ,t1.combo_value"
strSQLCampos = strSQLCampos & "      ,t1.combo_col_text"
strSQLCampos = strSQLCampos & "      ,t1.combo_codigo"
strSQLCampos = strSQLCampos & "      ,t2.div_id"
strSQLCampos = strSQLCampos & "	     ,t2.ajax_return"
strSQLCampos = strSQLCampos & "	     ,t2.tipo_pessoa"
strSQLCampos = strSQLCampos & "	     ,t2.readonly"
strSQLCampos = strSQLCampos & "	     ,t1.grupo"
strSQLCampos = strSQLCampos & "	     ,t2.coluna"
strSQLCampos = strSQLCampos & "      , t1.cod_evento_campos_proshop "
strSQLCampos = strSQLCampos & "      , t1.comentario "
strSQLCampos = strSQLCampos & "  FROM sys_proshop_evento_campos t1"
strSQLCampos = strSQLCampos & "  	INNER JOIN sys_proshop_campos_form t2 on t1.cod_proshop_campos_form = t2.cod_proshop_campos_form"
strSQLCampos = strSQLCampos & "  WHERE cod_evento = "& strCOD_EVENTO 
strSQLCampos = strSQLCampos & "   AND t1.dtt_inativo IS NULL "
strSQLCampos = strSQLCampos & "  AND t1.idioma = '"&strLng&"'"
strSQLCampos = strSQLCampos & "  ORDER BY t1.ordem asc, t1.grupo asc"
'response.write(strSQLCampos)

set objRSCampos  = objCONN.execute(strSQLCampos)
objRSCampos.MoveFirst
%>

<script language="javascript">
//console.log('<%=strSQLCampos%>');

function validaCpf(prCPF){
if (prCPF == ""){return false;}

if (!checkCPF(prCPF)){
		alert("CPF Invalido");
		$("#var_id_numdoc1_ô").val("");
		return false;
	}
}

function buscaDadoContato(prObj){
	var arrResult;
	if (!validaData(prObj,prObj.value)){return false;}	
		$(document).ready(function(){$
			<% if strLng = "BR" then %>
				$.ajax({url: "./ajax/buscaDadoCPF.asp?var_dtnasc=" + $("#var_data_nasc_ô").val() + "&var_cpf="+$("#var_id_numdoc1_ô").val(), success: function(result){																				
			<% else %>
				$.ajax({url: "./ajax/buscaDadoCPF.asp?var_dtnasc=" + $("#var_data_nasc_ô").val() + "&var_cpf="+$("#var_email_ô").val(), success: function(result){																
			<% end if %>
			console.log(result);
			arrResult = result.split("|")							
			if(arrResult[0] == 'error') {
				LimpaCampos();

				} else {	
					HabilitaCampos(false);
					
					<%  Do while not objRSCampos.EOF 
							if getValue(objRSCampos,"ajax_return") <> "" then 
					%>
								$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val(arrResult[<%=getValue(objRSCampos,"ajax_return")%>]);	
					<%       end if    
							objRSCampos.MoveNext
						loop
						objRSCampos.MoveFirst
					%>		
					document.getElementById("img_captura").src = arrResult[42];
	
			 }
		}});
	});		
}

function buscaDadoContatoEmail(prObj){
	var arrResult;
	var prEmail = "1";
	if (!validaData(prObj,prObj.value)){return false;}
	if (prEmail == ""){
		LimpaCampos();
		
	} else {
    $(document).ready(function(){
		$.ajax({url: "./ajax/buscaDadoCPF.asp?var_dtnasc=" + $("#<%=tornaCampoObrigatorio(arrValCampos, "var_data_nasc")%>").val() + "&var_cpf="+$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email")%>").val(), success: function(result){																		
			console.log(result);
			arrResult = result.split("|")
			console.log(arrResult.length);								
			if(arrResult[0] == 'error'){
			LimpaCampos();
								
	} else {
			HabilitaCampos(false);	

			<%  Do while not objRSCampos.EOF 
	         		 if getValue(objRSCampos,"ajax_return") <> "" then %>
               			  $("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val(arrResult[<%=getValue(objRSCampos,"ajax_return")%>]);	
			<%       end if    
					objRSCampos.MoveNext
				loop
				objRSCampos.MoveFirst
			%>			
			document.getElementById("img_captura").src = arrResult[42];
			
			}
			}});
				
		});	
	}
}

function LimpaCampos() {

	<%  Do while not objRSCampos.EOF 
		if getValue(objRSCampos,"ajax_return") <> "" then  
		   if tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field")) <> "var_email_ô" AND tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field")) <> "var_id_numdoc1_ô" AND tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field")) <>"var_data_nasc_ô" then 
				'if instr(tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field")),"ddi") = 0 AND strLNG = "BR" Then %>
					$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val("");
	<%			'end if
			End if
		end if
		if instr(tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field")),"ddi") > 0 AND strLNG = "BR" Then %>
					$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val("55");
	<%			end if
			objRSCampos.MoveNext
		loop
		objRSCampos.MoveFirst
	%>
	
	document.getElementById("img_captura").src = "./webcam/imgphoto/unknownuser.jpg";
					
	HabilitaCampos(false)
return false;

}
	
function HabilitaCampos(prTrueFalse) {

  <%  Do while not objRSCampos.EOF 
	    if uCase(getValue(objRSCampos,"habilitado")) <> "S" then %>
            $("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").prop("disabled",prTrueFalse);

		<% end if
		if uCase(getValue(objRSCampos,"habilitado")) = "S" then %>		 
            $("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").css("background-color","#ffffcc");
		<% end if %>
				if(prTrueFalse) {
         		  $("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val("");
				}
  <%     		objRSCampos.MoveNext
      
        loop
        objRSCampos.MoveFirst
  %>

	return false;
}

function buscaDadosEntidade(prCNPJ){
	var arrResult;
	if (prCNPJ == "") {		
		<%Do while not objRSCampos.EOF 
	   			if uCase(getValue(objRSCampos,"tipo_pessoa")) = "PJ" then %>
           		  $("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val("");
				  $("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").prop("readonly", false);

        <%      end if    
       			objRSCampos.MoveNext
       		 loop
        objRSCampos.MoveFirst
   		 %>

	return false;
	}

	if (!checkCNPJ(prCNPJ)){
		alert("CNPJ Invalido");
		$("#<%=tornaCampoObrigatorio(arrValCampos, "var_cnpj")%>").val("");
		return false;
	} else {
		$(document).ready(function(){
			$.ajax({url: "./ajax/buscaDadoCPF.asp?var_dtnasc=vazio&var_cpf="+$("#<%=tornaCampoObrigatorio(arrValCampos, "var_cnpj")%>").val(), success: function(result){																		
				console.log(result);
				arrResult = result.split("|");								
				if(arrResult[0] == 'error') {	

					<%  Do while not objRSCampos.EOF 
						if uCase(getValue(objRSCampos,"tipo_pessoa")) = "PJ" and uCase(getValue(objRSCampos,"name_field")) <> "VAR_CNPJ" then %>
							$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val("");
							$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").prop("readonly", false);
					
					<%    end if    
							objRSCampos.MoveNext
						loop
						objRSCampos.MoveFirst
					%>

				return false;

				} else {	

					<%  Do while not objRSCampos.EOF 
					if uCase(getValue(objRSCampos,"tipo_pessoa")) = "PJ" then %>
						$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val(arrResult[<%=getValue(objRSCampos,"ajax_return")%>]);
						<%if uCase(getValue(objRSCampos,"readonly")) = "S" then %>
							$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").prop("readonly", false);
					<% 	  end if
						end if    
							objRSCampos.MoveNext
						loop
						objRSCampos.MoveFirst
					%>			
		        }
		}});
    });	
}
}

function buscaDadoCep(prCEP) {
	$(document).ready(function() {
		$.ajax({url: "./ajax/buscaCEP.asp?var_cep="+$("#var_cep_ô").val(), success: function(result){																		
			console.log(result);
			arrResult = result.split("|");								
			if(arrResult[0] == 'error') {								
				return false;
			} else {									
				
			<%  Do while not objRSCampos.EOF 
					if uCase(getValue(objRSCampos,"tipo_pessoa")) = "E" then %>
						$("#<%=tornaCampoObrigatorio2(getValue(objRSCampos,"obrigatorio"),getValue(objRSCampos,"name_field"))%>").val(arrResult[<%=getValue(objRSCampos,"ajax_return")%>]);
						$("#var_end_num_ô").focus();
			<% 	        
					end if    
						objRSCampos.MoveNext
				loop
				objRSCampos.MoveFirst
			%>		
		   }
	    }});
    });		
}

function showNecessidade() {

	if ($("#var_necessidade_esp_ô").val()=="sim") {
		$("#div_necessidade_especial").css("visibility", "visible");
		$('#var_necessidade_especial').attr('id', 'var_necessidade_especial');
	}

	if ($("#var_necessidade_esp_ô").val() == "nao") {
		$("#div_necessidade_especial").css("visibility", "hidden");
		$('var_necessidade_especial_ô').attr('id', 'var_necessidade_especial');
		$("#var_necessidade_especial").val("");
	}
}
					
function copiaNomeCredencial() {
	$("#var_nome_credencial_ô").val() = $("#var_nome_completo_ô").val();
}

function validaData(campo,valor) {
  if (valor != '') {
	var date=valor;
	var ardt=new Array;
	var ExpReg=new RegExp("(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[012])/[12][0-9]{3}");
	ardt=date.split("/");
	erro=false;
	if ( date.search(ExpReg)==-1){
		erro = true;
		}
	else if (((ardt[1]==4)||(ardt[1]==6)||(ardt[1]==9)||(ardt[1]==11))&&(ardt[0]>30))
		erro = true;
	else if ( ardt[1]==2) {
		if ((ardt[0]>28)&&((ardt[2]%4)!=0))
			erro = true;
		if ((ardt[0]>29)&&((ardt[2]%4)==0))
			erro = true;
	}
	if (erro) {
		alert("\"" + valor + "\" não é uma data válida!!!");
		campo.value = "";
		return false;
	}
	<%
	If session("METRO_ProShopPF_strLimiteIdade")&"" <> "" Then
	%>
	if (calcular_idade(valor) < <%=session("METRO_ProShopPF_strLimiteIdade")%>) { 
	    alert("Acesso restrito a menores de <%=session("METRO_ProShopPF_strLimiteIdade")%> anos");
		campo.value = "";
		return false;
	}
	<%
	End If
	%>
	return true;
  }
}

function concatenaCampos() {	
	$("#endereco").val($("#var_endereco_ô").val() + " " + $("#var_end_num_ô").val() + " " +	$("#var_end_complemento").val());
	$("#telefone").val($("var_ddi3").val() + " " + $("#var_ddd3_ô").val() + " " +	$("#var_fone3_ô").val());
    $("#email").val($("#var_email_ô").val());
}

$("frm_dados").bind("keypress", function (e) {
    if (e.keyCode == 13) {
        return false;
    }
});

</script>
<% if (flagCopy = true) then %>
<label>Copiar dados de</label>
<div class="input-control select">
    <select>
		<option value="1">Alessander Oliveira [1] Congresso + Feira)</option>
		<option value="2">Tatiana Fliegner [2] Congresso + Feira)</option>
		<option value="3">Gabriel Schunck [3] Congresso + Feira)</option>
    </select>
</div>                                        
<% end if  
'response.Write("lang" & strLng)
%>

<form id="frm_dados" name="frm_dados" method="post" action="processa_cadastro.asp" onsubmit="submitForm(); return false;">
	<input type="hidden" value="<%=CFG_DB%>"         name="db">
	<input type="hidden" value="<%=strLng%>"         name="lng">
	<input type="hidden" value="<%=strCOD_EVENTO%>"   name="cod_evento">
	<input type="hidden" value="<%=strCategoria%>"    name="var_categoria">
	<!--<input type="hidden" value="<%=strCodProd%>"      name="cod_prod">-->
	<input type="hidden" value="<%=dblValorProduto%>" name="vlr_prod">
	<input type="hidden" value="<%=dblValorProduto%>" name="var_valor_inscricao">
	<!--<input type="hidden" value="<%=intQuantidade%>"   name="combo_quantidade">-->
	<input type="hidden" value="<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_IntegracaoToken")%>" name="token_rdstation" id="token_rdstation" />
	<input type="hidden" value="<%=request.cookies("METRO_ProshopPF")("METRO_ProShopPF_IntegracaoCampanha")%>" name="identificador" id="identificador" />
	<input type="hidden" name="var_cod_empresa"     id="var_cod_empresa">
	<input type="hidden" name="var_tipo_pess"       id="var_tipo_pess">
	<input type="hidden" name="endereco" id="endereco" />
	<input type="hidden" name="telefone" id="telefone" />
	<input type="hidden" name="email" id="email" />

	<input type="hidden" name="var_cod_questionario" id="var_cod_questionario" value="<%=strCOD_QUESTIONARIO%>"/>
 
<div class="grid">
			<div class="row"><!--ini row campos cadastro-->        
				<div class="span6">

								<% 
								Dim strObrigatorio
								   strAgrupamento = ""
								   Do while not objRSCampos.EOF 
										if getValue(objRSCampos,"coluna") = 1 then
													if uCase(getValue(objRSCampos,"grupo")) <> strAgrupamento then %>
														<legend><%=objLang.SearchIndex(getValue(objRSCampos,"grupo"),0)%></legend>
													<% end if 
												strAgrupamento = uCase(getValue(objRSCampos,"grupo"))
												strObrigatorio = uCase(getValue(objRSCampos,"obrigatorio"))
												montaForm getValue(objRSCampos,"tipo"),getValue(objRSCampos, "termo_traducao"), getValue(objRSCampos,"tamanho"), getValue(objRSCampos,"name_field"),  strObrigatorio,  getValue(objRSCampos,"value"),getValue(objRSCampos,"placeholder"),  getValue(objRSCampos,"length"),  getValue(objRSCampos,"javascript"),  getValue(objRSCampos,"focus"),  getValue(objRSCampos,"radio_value1"),  getValue(objRSCampos,"radio_value2"),getValue(objRSCampos,"radio_label1"), getValue(objRSCampos,"radio_label2"), getValue(objRSCampos,"combo_sql"), getValue(objRSCampos,"combo_value"), getValue(objRSCampos,"combo_col_text"),getValue(objRSCampos,"combo_codigo"), getValue(objRSCampos,"div_id"), getValue(objRSCampos,"style"), getValue(objRSCampos,"radio_check1"), getValue(objRSCampos,"radio_check2"), getValue(objRSCampos,"comentario")

										end if
									objRSCampos.MoveNext
								   loop
								objRSCampos.MoveFirst

								%>			
				</div>
				<div class="span6">           		
						  <% 
								strAgrupamento = ""
								Do while not objRSCampos.EOF 
										if getValue(objRSCampos,"coluna") = 2 then
													if uCase(getValue(objRSCampos,"grupo")) <> strAgrupamento then %>
														<legend><%=objLang.SearchIndex(getValue(objRSCampos,"grupo"),0)%></legend>
													<% end if 
												strAgrupamento = uCase(getValue(objRSCampos,"grupo"))

												montaForm getValue(objRSCampos,"tipo"),getValue(objRSCampos, "termo_traducao"), getValue(objRSCampos,"tamanho"), getValue(objRSCampos,"name_field"),  getValue(objRSCampos,"obrigatorio"),  getValue(objRSCampos,"value"),getValue(objRSCampos,"placeholder"),  getValue(objRSCampos,"length"),  getValue(objRSCampos,"javascript"),  getValue(objRSCampos,"focus"),  getValue(objRSCampos,"radio_value1"),  getValue(objRSCampos,"radio_value2"),getValue(objRSCampos,"radio_label1"), getValue(objRSCampos,"radio_label2"), getValue(objRSCampos,"combo_sql"), getValue(objRSCampos,"combo_value"), getValue(objRSCampos,"combo_col_text"),getValue(objRSCampos,"combo_codigo"), getValue(objRSCampos,"div_id"), getValue(objRSCampos,"style"), getValue(objRSCampos,"radio_check1"), getValue(objRSCampos,"radio_check2"), getValue(objRSCampos,"comentario")

										end if
									objRSCampos.MoveNext
								loop
								objRSCampos.MoveFirst

							%>		        		
				 <!--</form> -->          
				</div> 
				
			</div><!--fim row campos cadastro-->
			<% 
			
				if strCOD_QUESTIONARIO <> "" Then
										strSQLQuestionario = " SELECT QP.COD_QUESTIONARIO_PERGUNTA, QP.PERGUNTA, QP.OBSERVACAO, QP.PERGUNTA_US, QP.OBSERVACAO_US, QP.PERGUNTA_US, QP.PERGUNTA_ES, QP.OBSERVACAO_US, QP.ORDEM, QP.CAMPO_TIPO, QP.CAMPO_REQUERIDO, QG.GRUPO, QG.GRUPO_US, QG.GRUPO_ES, QG.ORDEM AS ORDEM_GRUPO, QP.ORIENTACAO, QP.NRO_LIMITE, qp.explicativo, qp.combo_list, qp.limite_resp " 
										strSQLQuestionario = strSQLQuestionario & "   FROM tbl_questionario q inner join tbl_QUESTIONARIO_PERGUNTA QP ON q.cod_questionario = qp.cod_questionario LEFT JOIN tbl_QUESTIONARIO_GRUPO QG ON (QP.COD_QUESTIONARIO_GRUPO = QG.COD_QUESTIONARIO_GRUPO)"
										strSQLQuestionario = strSQLQuestionario & "  WHERE QP.COD_QUESTIONARIO = " & strCOD_QUESTIONARIO & " AND q.sys_inativo is null ORDER BY QG.ORDEM, QP.ORDEM"
										'response.write(strSQLQuestionario)
										set objRSQuestionario = objCONN.execute(strSQLQuestionario)
										
					if NOT objRSQuestionario.EOF Then %>
							<div class="accordion with-marker" data-role="accordion" data-closeany="true">
										<div class="accordion-frame" style="padding-top:20px;">
												<a class="active heading bg-cyan fg-white" href="#">Pesquisa</a>
												<div class="content">		
														<div class="row"><!--ini row campos pesquisa-->
													
															<%	
															dim strJustificativa, strQuestRequerido
															strJustificativa = ""
																Do While not objRSQuestionario.EOF 
																strQuestRequerido = ""
																if getValue(objRSQuestionario,"CAMPO_REQUERIDO") = 1 then
																		strQuestRequerido = "_ô"
																end if
																	response.Write("<div class='span12' style='margin-left:0px;'><label><strong>"&getvalue(objRSQuestionario,"pergunta")& "</strong></label>" )&vbnewline
																		
																				strSQLQuestionarioResposta = "SELECT COD_QUESTIONARIO_RESPOSTA, CODIGO, CODBAR, RESPOSTA, RESPOSTA_US, RESPOSTA_ES, OBSERVACAO, ORDEM, CAMPO_EXTRA, URL_DESTINO FROM tbl_QUESTIONARIO_RESPOSTA WHERE COD_QUESTIONARIO_PERGUNTA = " & getvalue(objRSQuestionario,"COD_QUESTIONARIO_PERGUNTA") & " ORDER BY ORDEM" & vbnewline
																				set objRSQuestionarioResposta = objCONN.execute(strSQLQuestionarioResposta)
																				Do While not objRSQuestionarioResposta.EOF 
																						if objRSQuestionarioResposta.eof then
																							response.write("</div>")
																						end if
																						if y = 0 then
																							response.write("<div>")
																						end if
																						y=y+1
																						strJustificativa = ""

																						If objRSQuestionarioResposta("CAMPO_EXTRA")&"" = "OUTROS" Then
																						
																							strJustificativa = "<input type='text' maxlength='"&objRSQuestionario("LIMITE_RESP")&"' id='input_"&objRSQuestionario("COD_QUESTIONARIO_PERGUNTA")&"' name='quest_"&objRSQuestionario("COD_QUESTIONARIO_PERGUNTA")&"' value='' >"
																								
																						End If
																								
																						Select Case lcase(getValue(objRSQuestionario,"campo_tipo"))
																							case "radio"
																								'response.write  "<div class='span4'>" 
																								response.write 	"<div class='input-control span6 radio default-style' style='margin-left:0px; data-role='input-control '>"&vbnewline 
																								response.write 		"<label style='margin-left:0px;'>" &vbnewline 
																								response.write 			"<input type='radio' name='quest_"&getValue(objRSQuestionario,"COD_QUESTIONARIO_PERGUNTA")&"'  id='"&getValue(objRSQuestionario,"COD_QUESTIONARIO_PERGUNTA") & strQuestRequerido&"' value='"&getValue(objRSQuestionarioResposta,"COD_QUESTIONARIO_RESPOSTA")&"_"&getValue(objRSQuestionarioResposta,"CODIGO")&"' />"&vbnewline 
																								response.write 			"<span class='check' ></span>"&getValue(objRSQuestionarioResposta,"RESPOSTA")&""&vbnewline 
																									if objRSQuestionarioResposta("CAMPO_EXTRA")&""  <> "" then
																									Response.write "<input type='text' maxlength='"&objRSQuestionario("LIMITE_RESP")&"' id='input_"&objRSQuestionario("COD_QUESTIONARIO_PERGUNTA")&"' name='quest_"&objRSQuestionario("COD_QUESTIONARIO_PERGUNTA")&"_"&getValue(objRSQuestionarioResposta,"COD_QUESTIONARIO_RESPOSTA")&"' value='' >"&vbnewline 
																								end if
																								response.write 		"</label>"&vbnewline 
																								response.write 	"</div>"&vbnewline 			
																								'response.write "</div>"
																							case "checkbox"									
																							''	response.write "<div class='span4'> "
																								response.write "	<div class='input-control span6 checkbox'  style='margin-left:0px; data-role='input-control >" &vbnewline
																								response.write "		<label style='margin-left:0px;'>" &vbnewline 
																								response.write "			<input type='checkbox'  name='quest_"&getValue(objRSQuestionario,"COD_QUESTIONARIO_PERGUNTA")&"' id='"&getValue(objRSQuestionario,"COD_QUESTIONARIO_PERGUNTA")&strQuestRequerido&"' value='"&getValue(objRSQuestionarioResposta,"COD_QUESTIONARIO_RESPOSTA")&"_"&getValue(objRSQuestionarioResposta,"CODIGO")&"' />"&vbnewline 
																								response.write "			<span class='check'></span>" & getValue(objRSQuestionarioResposta,"RESPOSTA") &vbnewline 

																								if objRSQuestionarioResposta("CAMPO_EXTRA")&"" <> "" then
																									Response.write "<input type='text' maxlength='"&objRSQuestionario("LIMITE_RESP")&"' id='input_"&objRSQuestionario("COD_QUESTIONARIO_PERGUNTA")&"' name='quest_"&objRSQuestionario("COD_QUESTIONARIO_PERGUNTA")&"_"&getValue(objRSQuestionarioResposta,"COD_QUESTIONARIO_RESPOSTA")&"' value='' >"&vbnewline 
																								end if								
																								response.write "		</label>" &vbnewline 
																								response.write "	</div> "&vbnewline 
																							''	response.write "</div>" 						
																						End Select
																						
																							
																						'response.write(strSQLQuestionarioResposta)
																					objRSQuestionarioResposta.MoveNext
																						if y=2  then
																							response.write("</div>"&vbnewline)
																							y=0
																						end if	
																				loop
																	response.write("</div>")
																	objRSQuestionario.MoveNext
																	
																Loop
															%>
														
														</div>
												</div>
											
										</div>
							</div>
			<%		end if
			
			end if %>	
		</form>
</div><!--fim grid-->

<script language="javascript">
	HabilitaCampos(true); 
</script>




