$(function(){
    /*INICIALIZA JavaSCRIPTs ... ------------------------------------------------------------------------------- */
    /* if ((document.location.host.indexOf('.dev') > -1) || (document.location.host.indexOf('modernui') > -1) ) {
        $("<script/>").attr('src', '_metroUI/js/metro/metro-loader.js').appendTo($('head'));
    } else {
        $("<script/>").attr('src', '_metroUI/js/metro.min.js').appendTo($('head'));
    }

	... modificado para verificar caminhos a partir do "location" da página que esta 
	    chamando/incluindo js metro (<script src="_metroUI/js/load-metro.js"></script>)                          */
    /* --------------------------------------------------------------------------------------------------------- */
	var LP_BASE  = "/_metrodocs/";
	var PATMETRO = "_metroUI/js/metro.min.js";
    var i, arrAUX, auxPATH, auxSTR;

	auxSTR = window.location.pathname;
	arrAUX = auxSTR.split("/");

	//alert("DEBUG: " + LP_BASE + " <=> " + auxSTR + "  ( split=" + arrAUX.length + " )");

	auxPATH = PATMETRO;
    if (LP_BASE != auxSTR) {
		auxPATH = "";
	    if (arrAUX.length > 3) {
		  for(i=0; i<(arrAUX.length-3); i++) { 
		     auxPATH = auxPATH + "../";  
		  }
		} else { 
		  if (arrAUX.length < 3) { alert("ERROR: caminho inválido para uso da metroUI, \n" + LP_BASE + " <=> " + auxSTR + "  ( split=" + arrAUX.length + " )"); }
		}
		auxPATH = auxPATH + PATMETRO;
	} 

    //alert("DEBUG: metropath = " + auxPATH);
	$("<script/>").attr('src', auxPATH).appendTo($('head'));
    /* ------------------------------------------------------------------------------------ 27.06.2014 by Aless -- */
})