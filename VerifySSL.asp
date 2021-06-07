<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
dim strCERTIFICADO

strCERTIFICADO = "<script type='text/javascript' language='javascript' src='https://seal.godaddy.com/getSeal?sealID=JhfK2dEVk9HdO0CFDOqotLEhm5Iy954PvusmZiF4PRy7yPv87XoO6ZO'></script>"

Response.Write("<!DOCTYPE html>" & vbnewline) 
Response.Write("<html>" & vbnewline)
Response.Write("<head>" & vbnewline)
Response.Write("<title>Mercado</title>" & vbnewline)
Response.Write("</head>" & vbnewline)
Response.Write("<body id='metrotablevista' style='width:100%; height:100%' onblur='window.close();'>" & vbnewline)
Response.Write("<center><div  style='width:250px; height:55px; border:0px solid #F00; vertical-align:middle; margin-top:60px;'>" & vbnewline)    		
Response.Write(strCERTIFICADO & vbnewline) 
Response.Write("</div></center> "& vbnewline)                           
Response.Write("</body>" & vbnewline)
Response.Write("</html>" & vbnewline)
%>
