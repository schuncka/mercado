<!--#include file="../_database/athdbConnCS.asp"-->
<!--#include file="../_database/athUtilsCS.asp"-->  
<% 'ATENÇÃO: doctype, language, option explicit, etc... estão no athDBConn %> 
<% 'VerificaDireito "|VIEW|", BuscaDireitosFromDB("modulo_...", Request.Cookies("pVISTA")("ID_USUARIO")), true %>
<%
  Const MDL = "DEFAULT"          ' - Default do Modulo...
  Const LTB = "tbl_produtos"	    ' - Nome da Tabela...
  Const DKN = "ID_AUTO"          ' - Campo chave...
  Const DLD = "../modulo_AdmProduto" ' "../evento/data.asp" - 'Default Location após Deleção
  
 '------------------------------------------------------------------------------------------------------------
 'sera confgurado esse valor em CFG_NUM_PER_PAGE pois esta grade apresenta todos o valores em uma unica página 
 'sendo assim para não desfazer o código setamos apenas um valor alto
 
 CFG_NUM_PER_PAGE = 1000
 '-------------------------------------------------------------------------------------------------------------
  
  'Relativas a conexão com DB, RecordSet e SQL
 Dim objConn, objRS, strSQL
 'Adicionais
 Dim i, F, j, z, strBgColor, strINFO, strALL_PARAMS
 'Relativas a SQL principal do modulo
 Dim strFields, arrFields, arrLabels, arrSort, arrWidth, iResult, strResult
 'Relativas a FILTRAGEM e Paginação	
 Dim  arrAuxOP, flagEnt, numPerPage, CurPage, auxNumPerPage, auxCurPage,strMODE
 Dim strCOD_PROD, strGRUPO, strTITULO, strAtivo,strDT_OCORRENCIA, strDT_TERMINO, strLOCAL
 
'Antes de abir o banco já carrega as variaveis 
 strCOD_PROD            = Replace(GetParam("var_cod_prod"),"'","''")
 strGRUPO               = Replace(GetParam("var_grupo"),"'","''")
 strTITULO              = Replace(GetParam("var_titulo"),"'","''")
 strMODE                = Replace(GetParam("var_mode"),"'","''")
 strDT_TERMINO          = Replace(GetParam("var_dt_termino"),"'","'")
 strDT_OCORRENCIA       = Replace(GetParam("var_dt_ocorrencia"),"'","'")
 strLOCAL               = Replace(GetParam("var_local"),"'","'")
'--------------------------------------------------------------------------------------------------------------
 

'Relativo Páginação, mas para controle de linhas por página----------------------------------------------------
 numPerPage  = Replace(GetParam("var_numperpage"),"'","''")
 If (numPerPage ="") then 
    numPerPage = CFG_NUM_PER_PAGE 
 End If
'---------------------------------------------------------------------------------------------------------------


'abertura do banco de dados e configurações de conexão
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

' Monta SQL e abre a consulta ----------------------------------------------------------------------------------

		  strSQL = " SELECT     ID_AUTO "
 strSQL = strSQL & "		  , COD_PROD"
 strSQL = strSQL & "		  , GRUPO "
 strSQL = strSQL & "		  , DT_OCORRENCIA "
 strSQL = strSQL & "		  , DT_TERMINO "
 strSQL = strSQL & "		  , LOCAL "
 strSQL = strSQL & "		  , TITULO "    
 strSQL = strSQL & "   FROM " & LTB 
 strSQL = strSQL & "  WHERE COD_EVENTO = " & Session("COD_EVENTO") 
 strSQL = strSQL & "  ORDER BY GRUPO, TITULO"

 ' Define os campos para exibir na grade
 strFields = "COD_PROD,GRUPO,DT_OCORRENCIA,DT_TERMINO,LOCAL,TITULO" 
 arrFields = Split(strFields,",")        

 arrLabels = Array(    "COD_PROD"     ,"TITULO"   , "REALIZACAO"      ,"ENCERRAMENTO"     , "LOCAL", "GRUPO"       )
 arrSort   = Array("sortable-numeric" ,"sortable" ,"sortable-date-dmy","sortable-date-dmy","sortable", "sortable"  )
 arrWidth  = Array(      "2%"         , "16%"     , "5%"             ,   "5%"           ,   "30%" ,   "40%"      )  'obs.:[somar 98%] ou deixar todos vazios
' --------------------------------------------------------------------------------------------------------------


 AbreRecordSet objRS, strSQL, objConn, adLockOptimistic, adOpenDynamic, adUseClient, numPerPage 



 strALL_PARAMS = URLDecode(Request.Form) 'neste caso não pode usar GetParam
 strALL_PARAMS = Replace(strALL_PARAMS,"var_curpage="&GetCurPage&"&","") 'Retira o var_curpage da querystring para não trancar a paginaçãoz
 'athDebug "[" & strALL_PARAMS & "]", false

 If (not objRS.eof) Then 
   objRS.AbsolutePage = GetCurPage
 End If

%>
<!DOCTYPE html>
<html>
<head>
<title>Mercado</title>
<!--#include file="../_metroui/meta_css_js.inc"--> 
<script src="../_scripts/scriptsCS.js"></script>
</head>
<body class="metro" id="metrotablevista" onunload="SaveData()" onload="LoadData()">
<div class="grid fluid">
               <table class="tablesort table striped hovered" width="100%">
<!-- Possibilidades de tipo de sort...  class="sortable-date-dmy" / class="sortable-currency" / class="sortable-numeric" / class="sortable" //-->
    <thead>
        <tr> 
         <th style="width:1%;"></th>
        <% for j=0 to UBound(arrLabels) %>
          <th <%if (arrWidth(j)<>"") then response.write (" style='width:" & arrWidth(j) & ";' ")%> class="<%=arrSort(j)%>" align="left"><%=arrLabels(j)%></th>
        <% next %>
        </tr>
    </thead>
    <tbody>
        <tr>
        <%
        i = 0
        Do While (Not objRS.EOF) and (strFields <>"") and (i < objRS.PageSize)
        %>  
        <!--Menu Action INI-----------------------------------------------------------------------------------------------------//-->
             <td width="3px" align="center">
                    <div class="button-dropdown place-left" style="width:20px; height:20px; border:0px solid #F00;">
                          
                    </div>                        
             </td>
        <!--Menu Action FIM-----------------------------------------------------------------------------------------------------//-->
          <% 
            for j=0 to objRS.Fields.count-1 
              if inStr(strFields, objRS.Fields(j).name)>0 then
                response.Write (" <td  align='left'>")
                strINFO = Server.HTMLEncode(GetValue(objRS,objRS.Fields(j).name))                
                response.Write (strINFO)
                response.Write ("</td>" & vbnewline)
              end if 
            next
          %>
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
                 
               
              <!--   <div align="center" style="width:40px; height:28px; float:right; text-align:center;border-radius: 25px;  margin-top:5px; padding-top:4px; border:1px solid #00ADEF;" >
                                <i class="icon-cog fg-cyan" id="createFlatWindow" onClick=""  title="Altera Nº de Itens por Página"></i>
                            </div>
                 <div style="width:150px; height:28px; float:right; text-align:center; border:1px solid #00ADEF; border-radius: 25px; background-color:#00ADEF; margin-right:5px; margin-top:5px; padding-top:0px;" >
                  <form name="formPaginar" id="formPaginar" action="default.asp" method="post">
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
                </div>								-->
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

</div>
</body>
</html>
<% 
  FechaRecordSet ObjRS
  FechaDBConn ObjConn 
%>