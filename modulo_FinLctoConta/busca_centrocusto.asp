  <!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"--> 
<!--#include file="../_database/secure.asp"--> 
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_SiteInfo",Session("METRO_USER_ID_USER")), true %>
<%
 Const MDL = "DEFAULT"          					' - Default do Modulo...
 Const LTB = "fin_centro_custo"	    			' - Nome da Tabela...
 Const DKN = "COD_CENTRO_CUSTO"          			' - Campo chave...
 Const DLD = "../modulo_FinLctoConta/busca_centrocusto.asp" 		' "../evento/data.asp" - 'Default Location após Deleção
 Const TIT = "BUSCA CENTRO DE CUSTO"    						' - Nome/Titulo sendo referencia como titulo do módulo no botão de filtro


 'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i,j, strALL_PARAMS, strSWFILTRO,strINFO
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage
 'Relativas a FILTRAGEM
 Dim strENTIDADE, strSALDO
 Dim strDT_INI, strDT_FIM
 Dim strCONTA, strPERIODO
 Dim strIO, strTITLE, boolLCTO, boolTRANSF
 Dim strCodigo,strCODLCTOCONTA	,strOPERACAO,strTIPO
 Dim strSEARCH,strINPUT1,strINPUT2,strINPUT_TIPO,strINPUT_NOME
 Dim strFORM, strVEZES, strCOD_RAIZ, strPALAVRA_CHAVE
 Dim strRETORNO1, strRETORNO2
 Dim strCOLOR

 'Antes de abir o banco já carrega as variaveis 
	strCONTA	   			= GetParam("var_fin_conta")
	strPERIODO	   			= GetParam("var_periodo")
	strCODLCTOCONTA			= getParam("var_cod_lctoconta")
	strOPERACAO				= getParam("var_operacao")  
	strTIPO 				= getParam("var_tipo")
	strSEARCH 				= getParam("var_search")&""
	
	strINPUT_TIPO 			= GetParam("var_input_tipo")
	strINPUT_NOME 			= "var_entidade" 'GetParam("var_input_nome")
	strTIPO  				= GetParam("var_tipo")
	strVEZES 				= GetParam("var_vezes")
	
	strFORM 				= GetParam("var_form")
	strINPUT1 				= GetParam("var_input1")
	strINPUT2 				= GetParam("var_input2")
	
	strPALAVRA_CHAVE 		= GetParam("var_palavra_chave")
	
 'response.Write(strSEARCH)
 'response.End()
 
 
 'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------

'abertura do banco de dados e configurações de conexão----------------------------------------------------------
 AbreDBConn objConn, CFG_DB 
'---------------------------------------------------------------------------------------------------------------

 'Relativos a PAGINAÇÃO ----------------------------------------------------------------------------------------
 'Altera a qtde de elemetnos por página a partir do filtrpo 
 auxNumPerPage = Replace(GetParam("var_numperpage"),"'","''") 
 If (auxNumPerPage<>"") then 
  numPerPage = auxNumPerPage
 End If
 'Cuida do controle de página corrente
 Function GetCurPage
   Dim auxCurPage
   auxCurPage = Request.Form("var_curpage") 'neste caso não pode usar GetParam
   If (Not isNumeric(auxCurPage)) or (auxCurPage = "")  then
	 auxCurPage = 1 
   Else
	 If cint(auxCurPage) < 1 Then auxCurPage =  1 
	 If cint(auxCurPage) > objRS.PageCount Then auxCurPage = objRS.PageCount 
   End If
   GetCurPage = auxCurPage
 end function
' ---------------------------------------------------------------------------------------------------------------

' Monta FILTRAGEM -----------------------------------------------------------------------------------------------
 Function MontaWhereAdds
   Dim auxSTR 
 ' response.Write(strSEARCH&"<BR>")
    If isNUmeric(strSEARCH) then 
			auxSTR = auxSTR & " AND COD_CENTRO_CUSTO = '" & Clng(strSEARCH) & "'" 
		'response.Write(isNUmeric(strSEARCH))
		'response.End()
	else
		If strSEARCH   <>   ""  Then 
			auxSTR = auxSTR & " AND NOME  LIKE   '%" & strSEARCH &     "%'"
		end if
	end if		
		
 
   MontaWhereAdds = auxSTR 
 end function
' --------------------------------------------------------------------------------------------------------------

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------
		  
 strSQL = "SELECT "	
 strSQL = strSQL & "		    COD_CENTRO_CUSTO "	
 strSQL = strSQL & "		  , COD_REDUZIDO " 
 strSQL = strSQL & "		  , NOME " 
 strSQL = strSQL & "		  , NIVEL " 
 strSQL = strSQL & "		  , DT_INATIVO " 
 strSQL = strSQL & "		  FROM FIN_CENTRO_CUSTO "		 
 strSQL = strSQL & "		  WHERE 1 = 1 " & MontaWhereAdds
' If strPALAVRA_CHAVE <> "" Then strSQL = strSQL & " AND NOME LIKE '" & strPALAVRA_CHAVE & "%' "
	strSQL = strSQL & " ORDER BY COD_REDUZIDO, ORDEM, NOME"	
	
'athDebug strSQL , false
 ' String dos filtros, apenas para marcação/exibição de que existe alguma filtragem aciuonada
 strSWFILTRO = RemoveSpaces(replace(MontaWhereAdds,"AND"," | "))
  
 ' Define os campos para exibir na grade
 strFields = "COD_CENTRO_CUSTO,COD_REDUZIDO,NOME,NIVEL,DT_INATIVO"
 arrFields = Split(strFields,",")        

 arrLabels = Array("COD","COD REDUZIDO","NOME","NIVEL","ATIVO")
 arrSort   = Array("sortable-numeric","sortable-numeric","sortable","sortable","sortable-date")
 arrWidth  = Array("2%","6%","30%","30%","30%")  'obs.:[somar 98%] ou deixar todos vazios
' ----------------------------------------------------------------------------------------------------------------------------

 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 

 strALL_PARAMS = URLDecode(Request.Form) 'neste caso não pode usar GetParam
 strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para não trancar a paginaçãoz
 'athDebug "[" & strALL_PARAMS & "]", false

 If (not objRS.eof) Then 
   objRS.AbsolutePage = GetCurPage
 End If
 
 %>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
<script>
function Retorna(valor1,valor2) { 
	var objOption;
	//alert(valor1+valor2);
	window.opener.document.<%=strFORM%>.<%=strINPUT1%>.value = valor1;
	window.opener.document.<%=strFORM%>.<%=strINPUT2%>.value = valor2;
	
	if ('form_principal'=='<%=strFORM%>') {
		// Apaga última opção do combo
		if ('1'!='<%=strVEZES%>')
			window.opener.document.<%=strFORM%>.<%=strINPUT_NOME%>.remove(window.opener.document.<%=strFORM%>.<%=strINPUT_NOME%>.options.length-1);
		
		// Cria uma nova opção no combo	
		objOption = window.opener.document.createElement("OPTION");
		
		window.opener.document.<%=strFORM%>.<%=strINPUT_NOME%>.options.add(objOption);		
		objOption.innerText = valor2;
		objOption.value = "";	
		objOption.selected = 1;
	}
	window.close();
}



</script>
</head>
<body class="metro">
<div class="grid fluid">
	<!-- INI: barra no topo (filtro e adicionar) //-->
    <div class="bg-lightTeal1" style="border:0px solid #F00; width:100%; height:45px; background-color:#CCC; vertical-align:bottom; padding-left:0px;">
        <div style="width:100%;display:inline-block"> 
			<!-- INI: Filtro (accordiion para filtragem) //-->
            <div class="" data-role="accordion" style="z-index:10; position:absolute; top:15px;left:15px;">
                <div class="" style="border:0px solid #F00;">
                     <a class="heading text-left fg-active-black" href="#" style="height:45px; background:#CCC">
	                    <p class="fg-black" style="border:0px solid #FF0; padding:0px; margin:0px;">
							<%=TIT%>
                        </p>
                    </a>
                </div>
            </div>
			<!-- FIM: Filtro (accordiion -para filtragem) //-->			   
			<!-- INI: Botões //-->
            <div class="" style="border:0px solid #F00; position:relative; top:0px; float:right;padding-top:3px;">
            <div class="grid" style="margin:0px;padding:0px;">
                        <div class="row" style="margin:0px;padding:0px;">
                              <form name="formfiltro" id="formfiltro" method="post" action="busca_centocusto.asp" >  
                                  <div class="span12">
                                        <div class="input-control text ">
                                            <input type="text" name="var_search" id="var_search" maxlength="150" placeholder="" value="<%=strSEARCH%>" onKeyPress="">
                                            <button class="btn-search"></button>
                                        </div>
                                        <div class="input-control select" style="display:none;visibility:hidden">
                                            <input type="hidden" name="var_numperpage" id="var_numperpage" value="<%=numPerPage%>">
                                        </div>
                                 </div>       
                            </form> 
                        </div>
                    </div>   
            </div>            
			<!-- FIM: Botões //-->
        </div>
    </div>
	<!-- FIM: grade de dados//-->                
    <!-- INI: grade de dados //-->        
    <div id="body_grade" style="position:absolute; top:45px; z-index:8; width:100%">
       <% 
If (not objRS.BOF) and (not objRS.EOF) Then 
%>
<style> .indent { height: 50px; }</style>
<table class="tablesort table striped hovered">
<!-- Possibilidades de tipo de sort...  class="sortable-date-dmy" / class="sortable-currency" / class="sortable-numeric" / class="sortable" //-->
    <thead>
        <tr> 
        <% for j=0 to UBound(arrLabels) %>
          <th  nowrap="nowrap"  <%if (arrWidth(j)<>"") then response.write (" style='width:" & arrWidth(j) & ";' ")%> class="<%=arrSort(j)%>" align="left"><%=arrLabels(j)%></th>
        <% next %>
        </tr>
    </thead>
    <tbody>
        <tr>
       <%
        i = 0
        Do While (Not objRS.EOF) and (strFields <>"") and (i < objRS.PageSize)
        %>  
          <% 
            for j=0 to objRS.Fields.count-1 
              if inStr(strFields, objRS.Fields(j).name)>0 then
			  %>
                <td style='cursor:pointer;' onClick="Retorna('<%=GetValue(objRS,"COD_CENTRO_CUSTO")%>','<%=GetValue(objRS,"NOME")%>');">
               <%
		
                'response.Write (" align='left'>")
				strINFO = Server.HTMLEncode(GetValue(objRS,objRS.Fields(j).name))
                response.Write (strINFO)
				
				 if (objRS.Fields(j).name = "DT_INATIVO") Then
                    if  strINFO <> ""  Then
                        strINFO = Response.Write("<i class='icon-cancel fg-red'></i>")  
						else 
					 strINFO =  Response.Write("<i class='icon-checkmark fg-blue'></i>")	
                    End If
					
                End If
                response.Write ("</td></a>" & vbnewline)
              end if 
            next
          %>
           </td>
        </tr>
        <%
        i = i + 1
        athMoveNext objRS, ContFlush, CFG_FLUSH_LIMIT
        Loop
        %>
    </tbody>
    <tfoot>
      <tr>
       <td colspan="<%=UBound(arrFields)+3%>" style="padding-top:3px; border-top:1px solid #000;  background-color:#F8F8F8;" >
            <div style="width:100%; height:35px;">
                 
                 <div style="width:180px; height:25px; float:left; text-align:left; border:0px solid #F00; padding-left:25px;">
                 </div> 
                 <div align="center" style="width:40px; height:28px; float:right; text-align:center;border-radius: 25px;  margin-top:5px; padding-top:4px; border:1px solid #00ADEF;" >
                                <i class="icon-cog fg-cyan" id="createFlatWindow" onClick=""  title="Altera Nº de Itens por Página"></i>
                            </div>
                 <div style="width:150px; height:28px; float:right; text-align:center; border:1px solid #00ADEF; border-radius: 25px; background-color:#00ADEF; margin-right:5px; margin-top:5px; padding-top:0px;" >
                  <form name="formPaginar" id="formPaginar" action="busca_centrocusto.asp" method="post">
                    <input name="dec" type="button" value="<<" onClick="data_Paginar('formPaginar', 'var_curpage', 'decrementa', 1); return false;" style="background-color:#00ADEF; border:0px; cursor:pointer;  color:#FFF; margin-top:0px;"> 
                    <% 
                     'strALL_PARAMS
                     '"var_cod_evento=&var_nome=&var_pavilhao=Cent&var_estado="
                     Dim arrItemLC, arrELLC 
                     for each arrItemLC in split(strALL_PARAMS,"&")
                       arrELLC = split(arrItemLC,"=")
                       If  (lcase(arrELLC(0))<>"var_curpage") then 
                            response.write("<input type='hidden' id='" & arrELLC(0) & "' name='" & arrELLC(0) & "' value='" & arrELLC(1) & "'>" & vbnewline)
                       End If
                     next
                    %>	
                    <input name="var_curpage" id="var_curpage"
                           type="text" 
                           class="texto_corpo_peq" 
                           value="<%=GetCurPage%>" maxlength="4" 
                           style="width:30px; background-color:#00ADEF; border:0px dotted #FFF; color:#FFF; text-align:center;  margin-top:1px;" 
                           alt="Página <%=GetCurPage%> de <%=objRS.PageCount%>" title="Página <%=GetCurPage%> de <%=objRS.PageCount%>"> 
                           
                    <input name="inc" type="button" value=">>" onClick="data_Paginar('formPaginar', 'var_curpage', 'incrementa', <%=objRS.PageCount%>); return false;" style="background-color:#00ADEF; border:0px; cursor:pointer; color:#FFF; margin-top:0px;">
                  </form>
                </div>								
                 <script>
				 	
                 //esta função iguala os valores do formulário a outro variavel mantendo assim mesmo de depois de um refrash os dados digitado no campo 
                 // de pesquisa					
                    function EnviaParamFiltro(){
                        document.getElementById("formfiltro").var_numperpage.value = document.getElementById("combo_numpage").value;
                        document.getElementById("formfiltro").submit();
                    }
    
                      //Relacionado ao efeito de janela modal no botão do foot que esta ao lado 
                      //do páginador e se localiza dentro do HTML pois no nivel fora do body 
                      //ele não repondeu ao click 	
                    $("#createFlatWindow").on('click', function(){
                        $.Dialog({
                            overlay: true,
                            shadow: true,
                            flat: true,
                            draggable: true,
                            icon: '<i class="icon-cog fg-cyan"></i>',
                            title: 'Flat window',
                            content: '',
                            padding: 10,
                            onShow: function(_dialog){
                                var content = '' +
                                        '<label>Linhas por Página</label>' +
                                        '<div class="input-control select">' +
                                        '  <select name="combo_numpage" id="combo_numpage">'+
                                        '    <option value="5"     <%If numPerPage=5    Then response.write(" selected ") End If %> >5</option>'       +
                                        '    <option value="10"    <%If numPerPage=10   Then response.write(" selected ") End If %> >10</option>'      +
                                        '    <option value="20"    <%If numPerPage=20   Then response.write(" selected ") End If %> >20</option>'      +

                                        '    <option value="100"   <%If numPerPage=100  Then response.write(" selected ") End If %> >100</option>'     +
                                        '    <option value="250"   <%If numPerPage=250  Then response.write(" selected ") End If %> >250</option>'     +
                                        '    <option value="500"   <%If numPerPage=500  Then response.write(" selected ") End If %> >500</option>'     +
                                        '    <option value="1000"  <%If numPerPage=1000 Then response.write(" selected ") End If %> >1000</option>'    +
                                        '    <option value="999999"<%If numPerPage>1000 Then response.write(" selected ") End If %> >TODOS</option>'   +
                                             <% IF (inStr("5 , 20 , 30 , 100 , 250 , 500 , 10000 , 999999 ", CStr(numPerPage)&" ")<=0) then response.write("'<option value=" & numPerPage & " selected>"  & numPerPage & "</option>' + " & vbnewline) End IF  %>
                                        '  </select></div>'            +
                                        '<div class="form-actions">'   +
                                        '  <button class="button primary" onclick="EnviaParamFiltro(); $.Dialog.close();return false;">ALTERAR</button>' +
                                        '</div>';
    
                                $.Dialog.title("Config.");
                                $.Dialog.content(content);
                                $.Metro.initInputs('.user-input');
                            }
                        });
                    });
                                
                </script>                
                </div>
       </td>
      </tr>
    </tfoot>
</table>
<p class="padding20 tertiary-text-secondary">

<%
  'tratamento para visualizar numero de ococrrências e páginas ao fim da body
  response.write(objRS.RecordCount & "&nbsp;Ocorrências, ")
  if (objRS.RecordCount/numPerPage) - fix(objRS.RecordCount/numPerPage)>0 then 
    response.write(fix(objRS.RecordCount/numPerPage)+1) 
  else
    response.write(fix(objRS.RecordCount/numPerPage)) 
  end if	
  response.write(" páginas.") 
%></p>
<div class="indent"></div>
<%
Else
  Mensagem "Não existem dados para esta consulta.<br>Informe novos critérios para efetuar a pesquisa.", "","", true 
End If
%>
                                   
    </div>
    <!-- FIM: grade de dados //-->
</div>
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>