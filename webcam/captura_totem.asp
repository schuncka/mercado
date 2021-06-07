<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Webcam Snapshot</title>
<link href="../_css/csm.css" rel="stylesheet" type="text/css">
</head>
<body bgcolor="#F0F0F0" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr>
<td align="center">
Código: <b><%=Request("id")%></b>
<br />
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="400" height="250">
  <param name="flash_component" value="ImageViewer.swc" />
  <param name="movie" value="captureWebcam1.swf" />
  <param name="quality" value="high" />
  <param name="FlashVars" value="flashlet={imageLinkTarget:'_blank',captionFont:'Verdana',titleFont:'Verdana',showControls:true,frameShow:false,slideDelay:5,captionSize:10,captionColor:#333333,titleSize:10,transitionsType:'Random',titleColor:#333333,slideAutoPlay:false,imageURLs:['img1.jpg','img2.jpg','img3.jpg'],slideLoop:false,frameThickness:2,imageLinks:['http://macromedia.com/','http://macromedia.com/','http://macromedia.com/'],frameColor:#333333,bgColor:#FFFFFF,imageCaptions:[]}&cpf=<%=Request("id")%>&cod_empresa=<%=Request("cod_empresa")%>&codbarra=<%=Request("codbarra")%>" /><param name="BGCOLOR" value="#F2F2F2" />
  <param name="wmode" value="transparent" />
  <embed src="captureWebcam1.swf" width="400" height="250" quality="high" flashvars="flashlet={imageLinkTarget:'_blank',captionFont:'Verdana',titleFont:'Verdana',showControls:true,frameShow:false,slideDelay:5,captionSize:10,captionColor:#333333,titleSize:10,transitionsType:'Random',titleColor:#333333,slideAutoPlay:false,imageURLs:['img1.jpg','img2.jpg','img3.jpg'],slideLoop:false,frameThickness:2,imageLinks:['http://macromedia.com/','http://macromedia.com/','http://macromedia.com/'],frameColor:#333333,bgColor:#FFFFFF,imageCaptions:[]}&cpf=<%=Request("id")%>&cod_empresa=<%=Request("cod_empresa")%>&codbarra=<%=Request("codbarra")%>" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" bgcolor="#F2F2F2" flash_component="ImageViewer.swc" wmode="transparent"> </embed>
</object>
</td>
</tr>
</table>
</body>
</html>
