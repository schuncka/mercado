
<script language="javascript">

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
		$(document).ready(function(){
			$.ajax({url: "./ajax/buscaDadoCPF.asp?var_dtnasc=" + $("#<%=tornaCampoObrigatorio(arrValCampos, "var_data_nasc")%>").val() + "&var_cpf="+$("#var_id_numdoc1_ô").val(), success: function(result){																		
			console.log(result);
			arrResult = result.split("|")							
			if(arrResult[0] == 'error') {
				LimpaCampos();

				} else {	
					HabilitaCampos(false);	

					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email")%>").val(arrResult[1]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email_comercial")%>").val(arrResult[18]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_completo")%>").val(arrResult[2]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_credencial")%>").val(arrResult[2]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_data_nasc")%>").val(arrResult[4]);

					
				    if(arrResult[19] != ''){
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espt")%>").prop( "checked", true);
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espf")%>").prop( "checked", false );
						$("#div_necessidade_especial").css("visibility", "visible");
						$("#var_necessidade_especial").val(arrResult[19]);
						
					} else {
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espt")%>").prop( "checked", false);
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espf")%>").prop( "checked", true );
						$("#div_necessidade_especial").css("visibility", "hidden");
						$("#div_necessidade_especial").val("")
					}

					if(arrResult[5] == 'M'){
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexom")%>").prop( "checked", true);
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexof")%>").prop( "checked", false );
					} else {
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexom")%>").prop( "checked", false);
						$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexof")%>").prop( "checked", true);
					}

					$("#var_ddi1").val(arrResult[7]);
					$("#var_ddd1").val(arrResult[8]);
					$("#var_fone1").val(arrResult[9]);
					
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi3")%>").val(arrResult[10]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd3")%>").val(arrResult[11]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone3")%>").val(arrResult[12]);	
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi4")%>").val(arrResult[13]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd4")%>").val(arrResult[14]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone4")%>").val(arrResult[15]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cargo")%>").val(arrResult[16]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_departamento")%>").val(arrResult[17]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_endereco")%>").val(arrResult[20]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_end_num")%>").val(arrResult[21]);
					$("#var_end_complemento").val(arrResult[22]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_bairro")%>").val(arrResult[23]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cidade")%>").val(arrResult[24]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_estado")%>").val(arrResult[25]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_pais")%>").val(arrResult[26]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cep")%>").val(arrResult[27]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cnpj")%>").val(arrResult[28]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_razao_social")%>").val(arrResult[29]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_fantasia")%>").val(arrResult[30]);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_codativ")%>").val(arrResult[31]);   
					$("#var_cod_empresa").val(arrResult[39]);
					$("#var_tipo_pess").val(arrResult[40]);
					$("#var_img_foto").val(arrResult[41]);	

					document.getElementById("img_captura").src = arrResult[42];
							
					$("#endereco").val(arrResult[20] + " " + arrResult[21] + " " +	arrResult[22]);
					$("#telefone").val(arrResult[10] + " " + arrResult[11] + " " +	arrResult[12]);
					$("#email").val(arrResult[1]);	 
					
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
								
	} else{
			HabilitaCampos(false);	

				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email")%>").val(arrResult[1]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email_comercial")%>").val(arrResult[18]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_completo")%>").val(arrResult[2]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_credencial")%>").val(arrResult[2]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_data_nasc")%>").val(arrResult[4]);

				if(arrResult[5] == 'M'){
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexom")%>").prop( "checked", true);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexof")%>").prop( "checked", false );
				} else {
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexom")%>").prop( "checked", false);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexof")%>").prop( "checked", true);
				}

					
				if(arrResult[19] != ''){
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espt")%>").prop( "checked", true);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espf")%>").prop( "checked", false );
					$("#div_necessidade_especial").css("visibility", "visible");
					$("#var_necessidade_especial").val(arrResult[19]);
					
				} else {
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espt")%>").prop( "checked", false);
					$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espf")%>").prop( "checked", true );
					$("#div_necessidade_especial").css("visibility", "hidden");
					$("#div_necessidade_especial").val("")
				}

				$("#var_ddi1").val(arrResult[7]);
				$("#var_ddd1").val(arrResult[8]);
				$("#var_fone1").val(arrResult[9]);
				
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi3")%>").val(arrResult[10]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd3")%>").val(arrResult[11]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone3")%>").val(arrResult[12]);	
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi4")%>").val(arrResult[13]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd4")%>").val(arrResult[14]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone4")%>").val(arrResult[15]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cargo")%>").val(arrResult[16]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_departamento")%>").val(arrResult[17]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_endereco")%>").val(arrResult[20]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_end_num")%>").val(arrResult[21]);
				$("#var_end_complemento").val(arrResult[22]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_bairro")%>").val(arrResult[23]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cidade")%>").val(arrResult[24]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_estado")%>").val(arrResult[25]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_pais")%>").val(arrResult[26]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cep")%>").val(arrResult[27]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cnpj")%>").val(arrResult[28]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_razao_social")%>").val(arrResult[29]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_fantasia")%>").val(arrResult[30]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_codativ")%>").val(arrResult[31]);   
				$("#var_cod_empresa").val(arrResult[39]);
				$("#var_tipo_pess").val(arrResult[40]);
				$("#var_img_foto").val(arrResult[41]);							
				
				
				$("#endereco").val(arrResult[20] + " " + arrResult[21] + " " +	arrResult[22]);
				$("#telefone").val(arrResult[10] + " " + arrResult[11] + " " +	arrResult[12]);
				$("#email").val(arrResult[1]);

						
				document.getElementById("img_captura").src = arrResult[42];
				
				}
			}});
				
		});	
	}
}

/*
function limpacampos()
	retorna valores vazis quandio os dados não forem validos, limpa os campos de
	preenchimento
*/
function LimpaCampos() {
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email_comercial")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_completo")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_credencial")%>").val("");
	

	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexom")%>").prop( "checked", true);
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexof")%>").prop( "checked", false );

	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espt")%>").prop( "checked", false);
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espf")%>").prop( "checked", true);
	$("#div_necessidade_especial").css("visibility", "hidden");
	$("#div_necessidade_especial").val("")
	
	$("#var_ddi1").val("");
	$("#var_ddd1").val("");
	$("#var_fone1").val("");
	$("#var_id_numdoc1").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi3")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd3")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone3")%>").val("");	
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi4")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd4")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone4")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cargo")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_departamento")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_endereco")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_end_num")%>").val("");
	$("#var_end_complemento").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_bairro")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cidade")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_estado")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_pais")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cep")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cnpj")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_razao_social")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_fantasia")%>").val("");
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_codativ")%>").val("");
	$("#var_cod_empresa").val("");
	$("#var_tipo_pess").val("");
	$("#var_img_foto").val("");	
					
	document.getElementById("img_captura").src = "./webcam/imgphoto/unknownuser.jpg";
					
	HabilitaCampos(false)
return false;

}

/*
function  HabilitaCampos(FALSE){
 	habilita os capos de cadastro quando tive um cpf válido para cadastrar
	 RECEBE FALSE COMO PARAMETRO
 }
*/
	
function HabilitaCampos(prTrueFalse) {

	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_completo")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_credencial")%>").prop( "disabled", prTrueFalse );

	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi3")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd3")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone3")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi4")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd4")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone4")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddi1")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_ddd1")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_fone1")%>").prop( "disabled", prTrueFalse );

	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cargo")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_departamento")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email_comercial")%>").prop( "disabled", prTrueFalse );
	
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cep")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_endereco")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_end_num")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_end_complemento")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_bairro")%>").prop( "disabled", prTrueFalse );
	$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cidade")%>").prop( "disabled", prTrueFalse );

	<% if strLng = "BR" then %>
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_email")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_estado")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cnpj")%>").prop( "disabled", prTrueFalse );
    <%else %>
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_estado")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cnpj")%>").prop( "disabled", prTrueFalse );
    <%end if %>
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_pais")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_razao_social")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_nome_fantasia")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_codativ")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexof")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_sexom")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espt")%>").prop( "disabled", prTrueFalse );
		$("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espf")%>").prop( "disabled", prTrueFalse );

	return false;
}

function buscaDadosEntidade(prCNPJ){
		var arrResult;
	if (prCNPJ == "") {		
		$("#<%=tornaCampoObrigatorio(arrValCampos, "var_razao_social")%>").val("");
		$("#<%=tornaCampoObrigatorio(arrValCampos, "var_nome_fantasia")%>").val("");
		$("#<%=tornaCampoObrigatorio(arrValCampos, "var_razao_social")%>").prop("readonly", false);
		$("#<%=tornaCampoObrigatorio(arrValCampos, "var_nome_fantasi")%>").prop("readonly", false);	
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
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_razao_social")%>").val("");
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_nome_fantasia")%>").val("");
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_razao_social")%>").prop("readonly", false);
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_nome_fantasi")%>").prop("readonly", false);	

					return false;

				} else {									
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_cnpj")%>").val(arrResult[0]);
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_razao_social")%>").val(arrResult[2]);
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_nome_fantasia")%>").val(arrResult[3]);
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_razao_social")%>").prop("readonly", true);
					$("#<%=tornaCampoObrigatorio(arrValCampos, "var_nome_fantasia")%>").prop("readonly", true);
		    }
		}});
    });	
}
								
/*
strRETORNO = getValue(objRS,"ID_NUM_DOC1")                                         '0						
strRETORNO = strRETORNO &"|"&getValue(objRS,"NOMECLI")                             '2
strRETORNO = strRETORNO &"|"&getValue(objRS,"NOMEFAN")                             '3						
*/									
}

function buscaDadoCep(prCEP) {
	//'                   0                1                   2                3                  4  
	//  response.write(strENDER & "|" & strBAIRRO & "|" & strCIDADE & "|" & strESTADO & "|" & "BRASIL")	
	$(document).ready(function() {
		$.ajax({url: "./ajax/buscaCEP.asp?var_cep="+$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cep")%>").val(), success: function(result){																		
			console.log(result);
			arrResult = result.split("|");								
			if(arrResult[0] == 'error') {								
				return false;
			} else {									
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_endereco")%>").val(arrResult[0]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_bairro")%>").val(arrResult[1]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_cidade")%>").val(arrResult[2]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_estado")%>").val(arrResult[3]);
				$("#<%=tornaCampoObrigatorio(arrValCampos,"var_pais")%>").val(arrResult[4]);
				$("#var_end_num_ô").focus();
		   }
	    }});
    });	
	
}

function showNecessidade() {

	if ($("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espt")%>").prop( 'checked' )) {
		$("#div_necessidade_especial").css("visibility", "visible");
		$('#var_necessidade_especial').attr('id', 'var_necessidade_especial_ô');
	}

	if ($("#<%=tornaCampoObrigatorio(arrValCampos,"var_necessidade_espf")%>").prop( 'checked' )) {
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
	$("#endereco").val() = $("#var_endereco_ô").val() + " " + $("#var_end_num_ô").val() + " " +	$("#var_end_complemento").val();
	$("#telefone").val() = $("var_ddi3_ô").val() + " " + $("#var_ddd3_ô").val() + " " +	$("#var_fone3_ô").val();
    $("#email").val() = $("#var_email_ô").val();
}

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
<form id="frm_dados" name="frm_dados" method="post" action="processa_cadastro.asp">
	<input type="hidden" value=<%=CFG_DB%>          name="db">
	<input type="hidden" value=<%=strLng%>          name="lng">
	<input type="hidden" value=<%=strCOD_EVENTO%>   name="cod_evento">
	<input type="hidden" value=<%=strCategoria%>    name="var_categoria">
	<input type="hidden" value=<%=strCodProd%>      name="cod_prod">
	<input type="hidden" value=<%=dblValorProduto%> name="vlr_prod">
	<input type="hidden" value=<%=intQuantidade%>   name="combo_quantidade">
	<input type="hidden" value="<%=session("METRO_ProShopPF_IntegracaoToken")%>" name="token_rdstation" id="token_rdstation" />
	<input type="hidden" value="<%=session("METRO_ProShopPF_IntegracaoCampanha")%>" name="identificador" id="identificador" />
	<input type="hidden" name="var_cod_empresa"     id="var_cod_empresa">
	<input type="hidden" name="var_tipo_pess"       id="var_tipo_pess">
	<input type="hidden" name="endereco" id="endereco" />
	<input type="hidden" name="telefone" id="telefone" />
	<input type="hidden" name="email" id="email" />
    <input type="hidden" name="var_valor_inscricao" id="var_valor_inscricao" value="<%=dblTotalComprado%>" />
 
	<div class="grid">
		<!--div class="row">	
			<div class="fb-login-button" data-max-rows="1" data-size="medium" data-button-type="continue_with" data-show-faces="false" data-auto-logout-link="false" data-use-continue-as="true"></div>
		</div//-->
		<div class="row">        
			<div class="span6">
				<legend><%=objLang.SearchIndex("geral",0)%></legend>
				<% if strLng = "BR" Then %>
					<label><%=objLang.SearchIndex("cpf",0)%></label>
					<div class="input-control text" data-role="input-control">
						<input type="text" style="background-color:#FFFFCC;" placeholder="<%=objLang.SearchIndex("placeholder_cpf",0)%>" autofocus onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="11" id="var_id_numdoc1_ô" name="var_id_numdoc1" onblur="javascript:validaCpf(this.value);return false;">
						<button class="btn-clear" tabindex="-1"></button>
					</div>

					<label><%=objLang.SearchIndex("dt_nasc",0)%></label>
					<div class="input-control text" data-role="input-control">                             
						<input id="<%=tornaCampoObrigatorio(arrValCampos, "var_data_nasc")%>"  name="var_data_nasc" style="background-color:#FFFFCC;" type="text"  placeholder="<%=objLang.SearchIndex("placeholder_dt_nasc",0)%>" maxlength="10" class="" onKeyPress="Javascript:return validateNumKey(event);return false;"  onkeyup="var v = this.value;if (v.match(/^\d{2}$/) !== null) {this.value = v + '/';} else if (v.match(/^\d{2}\/\d{2}$/) !== null) {this.value = v + '/';}" onblur="javascript:buscaDadoContato(this);return false;">                            
						</p>
					</div>

					<label><%=objLang.SearchIndex("email1",0)%></label>
					<div class="input-control text" data-role="input-control">
						<input type="email" placeholder="<%=objLang.SearchIndex("placeholder_email",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_email")%>" name="var_email" autofocus maxlength="120" onblur="javascript:isMail(this);">
						<button class="btn-clear" tabindex="-1"></button>
					</div>
				<% else  %>
					<label><%=objLang.SearchIndex("email1",0)%></label>                    
					<div class="input-control text" data-role="input-control">
						<input type="text" style="background-color:#FFFFCC;" placeholder="<%=objLang.SearchIndex("placeholder_email",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_email")%>" name="var_email" autofocus maxlength="120" onblur="javascript:isMail(this);return false;">
						<input type="hidden" placeholder="<%=objLang.SearchIndex("placeholder_cpf",0)%>" autofocus maxlength="11" id="var_id_numdoc1" name="var_id_numdoc1" >
						<button class="btn-clear" tabindex="-1"></button>
					</div>

					<label><%=objLang.SearchIndex("dt_nasc",0)%></label>
					<div class="input-control text" data-role="input-control">                             
							<input id="<%=tornaCampoObrigatorio(arrValCampos, "var_data_nasc")%>" style="background-color:#FFFFCC;" name="var_data_nasc" type="text"  placeholder="<%=objLang.SearchIndex("placeholder_dt_nasc",0)%>" maxlength="10" class="" onKeyPress="Javascript:return validateNumKey(event);return false;" onblur="javascript:buscaDadoContatoEmail(this);return false;" onkeyup="var v = this.value;if (v.match(/^\d{2}$/) !== null) {this.value = v + '/';} else if (v.match(/^\d{2}\/\d{2}$/) !== null) {this.value = v + '/';}">                            
						</p>
					</div>
				<% end if %> 

				<label><%=objLang.SearchIndex("nome_completo",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_nome_completo",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_nome_completo")%>" name="var_nome_completo" maxlength="140" onblur="javascript:copiaNomeCredencial();">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<label><%=objLang.SearchIndex("nome_credencial",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_nome_credencial",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_nome_credencial")%>"name="var_nome_credencial" maxlength="80">
					<button class="btn-clear" tabindex="-1"></button>
				</div>	
											
				<label><%=objLang.SearchIndex("sexo",0)%></label>
				<div>
					<div class="input-control radio default-style" data-role="input-control">
						<label>
							<input type="radio" name="var_sexo" id="<%=tornaCampoObrigatorio(arrValCampos,"var_sexom")%>" checked value="M" />
							<span class="check"></span><%=objLang.SearchIndex("masc",0)%>
						</label>
					</div>
					<div class="input-control radio  default-style" data-role="input-control">
						<label>
							<input type="radio" name="var_sexo" id=<%=tornaCampoObrigatorio(arrValCampos,"var_sexof")%> value="F" />
							<span class="check"></span><%=objLang.SearchIndex("fem",0)%>
						</label>
					</div>
				</div> 

				<%if strLng = "BR" then%>
					<label>
						<i class="icon-camera on-left"style="background: white; color: black; padding: 5px;" onclick="javascript:CapturaImage('frm_dados','var_img_foto',document.getElementById('var_id_numdoc1_ô').value,'img_captura');"></i>
						<span onclick="javascript:CapturaImage('frm_dados','var_img_foto',document.getElementById('var_id_numdoc1_ô').value,'img_captura');"><%=objLang.SearchIndex("captura_imagem",0)%></span>
					</label>
					<div class="input-control" data-role="input-control">
						<input type="hidden" placeholder="webcam" name="var_img_foto" id="var_img_foto" value="" onchange="alteraFoto('img_captura',this.value);">                        
						<img id="img_captura" src="./webcam/imgphoto/unknownuser.jpg" border="1" onclick="javascript:CapturaImage('frm_dados','var_img_foto',document.getElementById('var_id_numdoc1_ô').value,'img_captura');">		
					</div>
				<%else %>     
					<label>
						<i class="icon-camera on-left"style="background: white; color: black; padding: 5px;" onclick="javascript:CapturaImage('frm_dados','var_img_foto','<%=Session.SessionID&StrReverse(Session.SessionID)%>','img_captura');"></i>
						<span onclick="javascript:CapturaImage('frm_dados','var_img_foto','<%=Session.SessionID&StrReverse(Session.SessionID)%>','img_captura');"><%=objLang.SearchIndex("clique_aqui_para_capturar_sua_imagem",0)%></span>
					</label>
					<div class="input-control" data-role="input-control">
						<input type="hidden" placeholder="webcam" name="var_img_foto" id="var_img_foto" value="" onchange="alteraFoto('img_captura',this.value);">                        
						<img id="img_captura" src="./webcam/imgphoto/unknownuser.jpg" border="1" onclick="javascript:CapturaImage('frm_dados','var_img_foto','<%=Session.SessionID&StrReverse(Session.SessionID)%>','img_captura');">
					</div>
				<%end if %>

				<label><%=objLang.SearchIndex("celular",0)%></label>
				<div class="input-control text size1" data-role="input-control">
					<input type="text" <%if strLng = "BR" then%> value="55" <%Else%> placeholder="<%=objLang.SearchIndex("placeholder_ddi",0)%>" <%End if%>  autofocus id="<%=tornaCampoObrigatorio(arrValCampos,"var_ddi3")%>" name="var_ddi3" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="3">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<div class="input-control text size1" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_ddd",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos,"var_ddd3")%>" name="var_ddd3" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="3">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<div class="input-control text size2" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_fone",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_fone3")%>" name="var_fone3" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="40" onblur="javascript: concatenaCampos();return false;">
					<button class="btn-clear" tabindex="-1"></button>
				</div>
				
				<label><%=objLang.SearchIndex("fone_comercial",0)%></label>
				<div class="input-control text size1" data-role="input-control">
					<input type="text" <%if strLng = "BR" then%> value="55" <%Else%> placeholder="<%=objLang.SearchIndex("placeholder_ddi",0)%>" <%End if%> autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_ddi4")%>" name="var_ddi4" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="3">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<div class="input-control text size1" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_ddd",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_ddd4")%>" name="var_ddd4" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="3">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<div class="input-control text size2" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_fone",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_fone4")%>" name="var_fone4" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="40">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<label><%=objLang.SearchIndex("fone_residencial",0)%></label>
				<div class="input-control text size1" data-role="input-control">
					<input type="text" <%if strLng = "BR" then%> value="55" <%Else%> placeholder="<%=objLang.SearchIndex("placeholder_ddi",0)%>" <%End if%> autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_ddd1")%>" name="var_ddi1" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="3">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<div class="input-control text size1" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_ddd",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_ddd1")%>" name="var_ddd1" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="3">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<div class="input-control text size2" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_fone",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_fone1")%>" name="var_fone1" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="40">
					<button class="btn-clear" tabindex="-1"></button>
				</div>
				
				<label><%=objLang.SearchIndex("cargo",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cargo",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_cargo")%>" name="var_cargo" maxlength="80">
					<button class="btn-clear" tabindex="-1"></button>
				</div>

				<label><%=objLang.SearchIndex("departamento",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_departamento",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_departamento")%>" name="var_departamento" maxlength="50">
					<button class="btn-clear" tabindex="-1"></button>
				</div>
				
				<label><%=objLang.SearchIndex("email_comercial",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="email" placeholder="<%=objLang.SearchIndex("placeholder_email_comercial",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_email_comercial")%>" name="var_email_comercial" autofocus maxlength="120" onblur="javascript:isMail(this);return false;" >
					<button class="btn-clear" tabindex="-1"></button>
				</div>
				
				<label><%=objLang.SearchIndex("necessidade_especial",0)%></label>
				<div>
					<div class="input-control radio default-style " data-role="input-control">
						<label>
							<input type="radio" name="var_necessidade_esp"  id="<%=tornaCampoObrigatorio(arrValCampos, "var_necessidade_espt")%>"  onclick="javascript:showNecessidade();" value="sim"  />
							<span class="check"></span><%=objLang.SearchIndex("sim",0)%>
						</label>
					</div>
					<div class="input-control radio default-style " data-role="input-control">
						<label>
							<input type="radio" name="var_necessidade_esp" id="<%=tornaCampoObrigatorio(arrValCampos, "var_necessidade_espf")%>"  onclick="javascript:showNecessidade();" checked="checked" value="nao"/>
							<span class="check"></span><%=objLang.SearchIndex("nao",0)%>
						</label>
					</div>
					<div class="input-control text" data-role="input-control" style="visibility:hidden;" id="div_necessidade_especial">
						<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_necessidade_especial",0)%>" id="var_necessidade_especial" name="var_necessidade_especial" autofocus maxlength="140">
						<button class="btn-clear" tabindex="-1"></button>
					</div>    
				</div>    
						
				<!--legend>Arquivos</legend>
				<label>Upload/Imagens</label>
				<div class="input-control file" data-role="input-control">
					<input type="file" placeholder="Arquivo">
					<button class="btn-file"></button>
				</div//-->			
					
			</div>
			<div class="span6">           		
			<legend><%=objLang.SearchIndex("end_correspondencia",0)%></legend>
			<%if strLng = "BR" Then%>
				<label><%=objLang.SearchIndex("cep",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cep",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_cep")%>" name="var_cep" onblur="javascript:buscaDadoCep(this.value);return false;" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="8">
					<button class="btn-clear" tabindex="-1"></button>
				</div>                    
			<% else %>         
				<label><%=objLang.SearchIndex("cep",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cep",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_cep")%>" name="var_cep" onblur="javascript:buscaDadoCep(this.value);return false;" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="8">
					<button class="btn-clear" tabindex="-1"></button>
				</div>	
			<% end if %>     

			<label><%=objLang.SearchIndex("endereco",0)%></label>
			<div class="input-control text" data-role="input-control">
				<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_endereco",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_endereco")%>" name="var_endereco" maxlength="100">
				<button class="btn-clear" tabindex="-1"></button>
			</div>

			<label><%=objLang.SearchIndex("numero_complemento",0)%></label>
			<div class="input-control text size2" data-role="input-control">
				<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_numero",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_end_num")%>" name="var_end_num" maxlength="40">
				<button class="btn-clear" tabindex="-1"></button>
			</div>

			<div class="input-control text size3" data-role="input-control">
				<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_numero_complemento",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_end_complemento")%>" name="var_end_complemento" maxlength="40">
				<button class="btn-clear" tabindex="-1"></button>
			</div>

			<%if strLng = "BR" then%>
				<label><%=objLang.SearchIndex("bairro",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_bairro",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_bairro")%>" name="var_bairro" maxlength="70">
					<button class="btn-clear" tabindex="-1"></button>
				</div>
			<% else %>
				<label><%=objLang.SearchIndex("bairro",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_bairro",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_bairro")%>" name="var_bairro" maxlength="70">
					<button class="btn-clear" tabindex="-1"></button>
				</div>                    
			<%end if %>

			<label><%=objLang.SearchIndex("cidade",0)%></label>
			<div class="input-control text" data-role="input-control">
				<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cidade",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_cidade")%>" name="var_cidade" maxlength="70">
				<button class="btn-clear" tabindex="-1"></button>
			</div>
			
			<%if strLng = "BR" Then%>
			<label><%=objLang.SearchIndex("estado",0)%></label>
				<div class="input-control select">
					<select name="var_estado" id="<%=tornaCampoObrigatorio(arrValCampos, "var_estado")%>">
						<option value="" selected><%=objLang.SearchIndex("selecione",0)%></option>
						<%		                    
							strSQL = "SELECT SIGLA_UF, NOME_UF FROM TBL_ESTADOS ORDER BY SIGLA_UF"
							MontaCombo strSQL, "SIGLA_UF", "NOME_UF", ""
						%>  
					</select>
				</div> 
			<% else %>
			<label><%=objLang.SearchIndex("estado",0)%></label>
			<div class="input-control text" data-role="input-control"> 
				<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_estado",0)%>" autofocus id="<%=tornaCampoObrigatorio(arrValCampos, "var_estado")%>" name="var_estado" maxlength="40">
				<button class="btn-clear" tabindex="-1"></button>
			</div>
	    	<%  end if %>                                       
			<label><%=objLang.SearchIndex("pais",0)%></label>
			<div class="input-control select">
				<select name="var_pais" id="<%=tornaCampoObrigatorio(arrValCampos, "var_pais")%>">
					<option value="" selected><%=objLang.SearchIndex("selecione",0)%></option>
						<% 			
			
							strSQL =          " SELECT DISTINCT tbl_PAISES.PAIS, tbl_PAIS.PAIS AS COD_PAIS "
							strSQL = strSQL & "   FROM tbl_PAIS, tbl_PAISES "
							strSQL = strSQL & "  WHERE tbl_PAIS.ID_PAIS = tbl_PAISES.ID_PAIS"
							strSQL = strSQL & "  ORDER BY ORDEM DESC, tbl_PAISES.PAIS  "
							MontaCombo strSQL, "COD_PAIS", "PAIS", ""
						
						%>   			
				</select>
			</div>
				
			<legend><%=objLang.SearchIndex("empresa_entidade",0)%></legend>
   			<%if strLng = "BR" then%>
				<label><%=objLang.SearchIndex("cnpj",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cnpj",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_cnpj")%>" name="var_cnpj" onblur="javascript:buscaDadosEntidade(this.value);return false;" onKeyPress="Javascript:return validateNumKey(event);return false;" maxlength="14">
					<button class="btn-clear" tabindex="-1"></button>
				</div>
			<%else %>
				<label><%=objLang.SearchIndex("cnpj",0)%></label>
				<div class="input-control text" data-role="input-control">
					<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_cnpj",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_cnpj")%>" name="var_cnpj" maxlength="50">
					<button class="btn-clear" tabindex="-1"></button>
				</div>               
			<%end if%>

			<label><%=objLang.SearchIndex("razao_social",0)%></label>
			<div class="input-control text" data-role="input-control">
				<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_razao_social",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_razao_social")%>" name="var_razao_social" maxlength="140">
				<button class="btn-clear" tabindex="-1"></button>
			</div>
			<label><%=objLang.SearchIndex("nome_fantasia",0)%></label>
			<div class="input-control text" data-role="input-control">
				<input type="text" placeholder="<%=objLang.SearchIndex("placeholder_nome_fantasia",0)%>" id="<%=tornaCampoObrigatorio(arrValCampos, "var_nome_fantasia")%>" name="var_nome_fantasia" maxlength="70">
				<button class="btn-clear" tabindex="-1"></button>
			</div>
			<label><%=objLang.SearchIndex("atividade",0)%></label>
			<div class="input-control select" data-role="input-control">
			<select id="<%=tornaCampoObrigatorio(arrValCampos, "var_codativ")%>"name="var_codativ">
				<option value="" selected><%=objLang.SearchIndex("selecione",0)%></option>
				<%  
					Select Case ucase(strLng)
						Case "BR"				
							strSQL =          " SELECT A1.CODATIV, A1.ATIVMINI, A1.ATIVMINI AS ATIVIDADE "
							strSQL = strSQL & "   FROM tbl_Atividade A1 "
							strSQL = strSQL & "  WHERE A1.LOJA_SHOW = 1 AND (A1.TIPOPESS = 'A' OR A1.TIPOPESS = 'J')"
							strSQL = strSQL & "  ORDER BY A1.CODATIV, A1.ATIVIDADE, A1.ATIVMINI"
						Case "SP","ES"
							strSQL =          " SELECT A1.CODATIV, A1.ATIVMINI_SP AS ATIVMINI, A1.ATIVMINI_SP AS ATIVIDADE"
							strSQL = strSQL & "   FROM tbl_Atividade A1  "
							strSQL = strSQL & "  WHERE A1.LOJA_SHOW = 1 AND (A1.TIPOPESS = 'A' OR A1.TIPOPESS = 'J')"
							strSQL = strSQL & "  ORDER BY A1.CODATIV, A1.ATIVMINI_INTL, A1.ATIVMINI"				
						Case "US","EN","INTL"
							strSQL =          " SELECT A1.CODATIV, A1.ATIVMINI_INTL AS ATIVMINI, A1.ATIVMINI_INTL AS ATIVIDADE "
							strSQL = strSQL & "   FROM tbl_Atividade A1  "
							strSQL = strSQL & "  WHERE A1.LOJA_SHOW = 1 AND (A1.TIPOPESS = 'A' OR A1.TIPOPESS = 'J')"
							strSQL = strSQL & "  ORDER BY A1.CODATIV, A1.ATIVMINI_INTL, A1.ATIVMINI"
						End Select
						
						MontaCombo strSQL, "CODATIV", "ATIVIDADE", ""
				%>
			</select>
		 </div>		
	 </form>            
 </div>       
</div>
</div>

<script language="javascript">
	HabilitaCampos(true); 
</script>

