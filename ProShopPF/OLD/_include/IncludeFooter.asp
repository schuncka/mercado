<%
Dim strFooter, strLinkFooter

strLinkFooter     = "https://" & Replace(lcase(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("URL")),"proshoppf/passo4_.asp","")

strFooter = " <div class='page-footer padding10' style='background-color:#282828; color:#FFF'>" & vbnewline
strFooter = strFooter & "  <div class='page container'>" & vbnewline
strFooter = strFooter & "    <div class='grid' ><!-- show-grid //-->" & vbnewline
        'If strEmailEvento <> ""  or strEmailContato1 <> "" or strEmailContato2 <> "" Then 
strFooter = strFooter & "            <div class='row'>" & vbnewline
strFooter = strFooter & "                <div class='span10' >" & vbnewline
                  If session("METRO_ProShopPF_strEmailEvento") <> ""  or session("METRO_ProShopPF_strEmailContato1") <> "" or session("METRO_ProShopPF_strEmailContato2") <> "" Then 
strFooter = strFooter & "                    <h4 class='fg-white'><strong>"&(objLang.SearchIndex("rodape_titulo",0))&"</strong></h4>" & vbnewline
                  End If
strFooter = strFooter & "                        <div class='grid'>" & vbnewline
strFooter = strFooter & "                            <div class='row'>" & vbnewline
                  If session("METRO_ProShopPF_strEmailEvento") <> ""  or session("METRO_ProShopPF_strEmailContato1") <> "" Then 
strFooter = strFooter & "                                <div class='span4'>" & vbnewline
                                 If session("METRO_ProShopPF_strEmailEvento") <> "" Then
strFooter = strFooter & "    	                                <h4 class='fg-white'><strong>"&(objLang.SearchIndex("rodape_contato1",0))&"</strong></h4>" & vbnewline
strFooter = strFooter & "        	                            <p class='tertiary-text-secondary fg-white'>"&session("METRO_ProShopPF_strEmailEvento")&"</p>" & vbnewline
                                 End If
								 If session("METRO_ProShopPF_strEmailContato1") <> "" Then 
strFooter = strFooter & "	                                    <p class='tertiary-text-secondary fg-white'>"&session("METRO_ProShopPF_strEmailContato1")&"</p>" & vbnewline
                                 End If 
strFooter = strFooter & "                                </div>" & vbnewline
                  End If  
							   	 If session("METRO_ProShopPF_strEmailContato2") <> "" Then							    
strFooter = strFooter & "                                    <div class='span3'>" & vbnewline
strFooter = strFooter & "                                        <h4 class='fg-white'><strong>"&(objLang.SearchIndex("rodape_contato2",0))&"</strong></h4>" & vbnewline
strFooter = strFooter & "                                        <p class='tertiary-text-secondary fg-white'>"&session("METRO_ProShopPF_strEmailContato2")&"</p>" & vbnewline
strFooter = strFooter & "                                    </div>" & vbnewline
                                 End If 
strFooter = strFooter & "                                <div class='span3'>" & vbnewline
strFooter = strFooter & "                                    <img src='https://pvista.proevento.com.br/cm/proshoppf/imgdin/bandeiras_cartoes.png'>" & vbnewline
strFooter = strFooter & "                                </div>" & vbnewline
strFooter = strFooter & "                            </div>" & vbnewline
strFooter = strFooter & "                        </div>" & vbnewline
strFooter = strFooter & "                </div>" & vbnewline
        'End if 
strFooter = strFooter & "            <div class='span4'>" & vbnewline
strFooter = strFooter & "            	<h4 class='fg-white'><strong>powered by</strong></h4>" & vbnewline
strFooter = strFooter & "                    <div class='row'>" & vbnewline
strFooter = strFooter & "                        <div class='span'>" & vbnewline
strFooter = strFooter & "                            <p class='tertiary-text-secondary fg-white'>PROEVENTO <small>T E C N O L O G I A</small></p>" & vbnewline
strFooter = strFooter & "                            <p class='tertiary-text-secondary fg-white'>Brooklin</p>" & vbnewline
strFooter = strFooter & "                            <p class='tertiary-text-secondary fg-white'>04571.925 | S&atilde;o Paulo | SP</p>" & vbnewline
strFooter = strFooter & "                            <!-- " & vbnewline
strFooter = strFooter & "                            <p class='tertiary-text-secondary fg-white'><br></p>" & vbnewline
strFooter = strFooter & "                            <p class='tertiary-text-secondary fg-white'><br></p>" & vbnewline
strFooter = strFooter & "                            <p class='tertiary-text-secondary fg-white'>contato@proevento.com.br</p>" & vbnewline
strFooter = strFooter & "                            <h2 class='fg-white'><strong>+55 11 3192.3933</strong></h2>" & vbnewline
strFooter = strFooter & "                            //-->" & vbnewline
strFooter = strFooter & "                        </div>" & vbnewline
strFooter = strFooter & "                    </div>" & vbnewline
strFooter = strFooter & "            </div>" & vbnewline
strFooter = strFooter & "        </div>" & vbnewline
strFooter = strFooter & "    </div>" & vbnewline
strFooter = strFooter & "  </div>" & vbnewline
strFooter = strFooter & " </div>" & vbnewline
if instr(Request.ServerVariables("SERVER_NAME")&Request.ServerVariables("URL"),"passo4") = 0 Then
	response.write(strFooter)
end if
%>