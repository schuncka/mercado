function makeCookie(name, value) { // Argumentos opcionais: expires, path, domain, secure
	args = makeCookie.arguments;
	argsLength = makeCookie.arguments.length;

	expires = (argsLength > 2) ? args[2] : null;
	if(expires != null && expires != "") expires = "; expires = " + expires.toGMTString();
	else expires = "";

	path = (argsLength > 3) ? args[3] : null;
	if(path != null && path != "") path = "; path = " + path;
	else path = "";

	domain = (argsLength > 4) ? args[4] : null;
	if(domain != null && domain != "") domain = "; domain = " + domain;
	else domain = "";

	secure = (argsLength > 5) ? args[5] : false;
	if(secure) secure = "; secure";
	else secure = "";

	document.cookie = name + " = " + escape(value) + expires + path + domain + secure;
}

function addToCookie(name, value) {
  var mydata;
  
    data_expires = new Date(2003,12,24);
	splitChar = "";
	if(addToCookie.arguments.length > 2)
		if(addToCookie.arguments[2])
			splitChar = "|";
	cookieValue = getCookie(name);
	mydata = getCookie(name);
	cookieValue = getCookie(name) + splitChar + value;
	mydata = getCookie(name) + splitChar + value;
	killCookie(name);
//    makeCookie(name, mydata, data_expires, "", "", false);
    makeCookie(name, mydata, "", "", "", false);
	
//	if(cookieValue != null) {
//		cookieLength = document.cookie.length;
//		indexName = document.cookie.indexOf(name);
//		indexEndValue = "";
//		indexEndValue = document.cookie.indexOf(';', indexName);
//		if(indexEndValue == -1) indexEndValue = document.cookie.length;
//		indexEndCookie = "";
//		indexEndCookie = document.cookie.indexOf("=",indexEndValue);
//		cookieTail = "";
//		if(indexEndCookie != -1) {
//			i = indexEndCookie -2;
//			while(indexEndCookie != " ") {
//				indexEndCookie = document.cookie.charAt(i);
//				i--;
//			}
//			indexEndCookie = i+1;
//			cookieTail = document.cookie.substring(indexEndValue, indexEndCookie);
//			document.cookie = name + " = " + escape(getCookie(name)) + escape(splitChar) + escape(value) + cookieTail;
//			alert("addcookie >> " + name + " = " + escape(getCookie(name)) + escape(splitChar) + escape(value) + cookieTail);
//		} else makeCookie(name, value, data_expires, "", "", false);
//
//	} else makeCookie(name, value, data_expires, "", "", false);
}

function sizeFromCookie(name) {
  cookieValue = getCookie(name);
  return (cookieValue.length);
}

function deleteFromCookie(name, value) {
	splitChar = "";
	if(deleteFromCookie.arguments.length > 2)
		if(deleteFromCookie.arguments[2])
			splitChar = "|";
	cookieValue = getCookie(name);
	indexValue = cookieValue.indexOf(value);
	if(indexValue != -1) {
		haveSplit = 0;
		if(cookieValue.indexOf(splitChar) != -1) haveSplit = 1;
		if(cookieValue.length != value.length + haveSplit) {
			cookieValue = cookieValue.substring(0,indexValue) + cookieValue.substring(indexValue + value.length + 1, cookieValue.length);
			setCookie(name, cookieValue);
		} else killCookie(name);
	}
}

function setCookie(name, value) {
    data_expires = new Date(2003,12,24);
//	makeCookie(name, value, data_expires, "", "", false);
	makeCookie(name, value, "", "", "", false);
}

function getCookie(name) {
	cookieLength = document.cookie.length;
	indexName = document.cookie.indexOf(name);
	if(indexName != -1) {
		indexEndValue = "";
		indexEndValue = document.cookie.indexOf(';', indexName);
		if(indexEndValue == -1) indexEndValue = document.cookie.length;

		indexBeginValue = "";
		for(i=document.cookie.indexOf('=',indexName.length); i < indexEndValue; i++)
			if(document.cookie.charAt(i) == " " || document.cookie.charAt(i) == "=")
				indexBeginValue = i + 1;
		return unescape(document.cookie.substring(indexBeginValue, indexEndValue));
	} else return null;
}

function killCookie(name) {
	expire = new Date();
	expire.setTime(expire.getTime() -1);
	cookieValue = getCookie(name);
	document.cookie = name + " = " + cookieValue + "; expires = " + expire.toGMTString();
}