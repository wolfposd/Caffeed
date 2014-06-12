function changeURL(timeoutPeriod) {
	setTimeout(function() {
		var url = window.location.href;

		if (url.indexOf("?") > -1) {
			url = url.substr(0, url.indexOf("?"));
		}
		window.location.href = url;
	}, timeoutPeriod);

}
function changeURL(timeoutPeriod,destination) {
	setTimeout(function() {
		var url = window.location.href;

		if (url.indexOf("?") > -1) {
			url = url.substr(0, url.indexOf("?"));
		}
		window.location.href = url+destination;
	}, timeoutPeriod);

}
function reloadPage(timeoutPeriod){
	setTimeout(function() { window.location.href = window.location.href;}, timeoutPeriod);
}


function setNameIntoField(name, field)
{
	$('#'+field).val(name);
}



function addItemToBody(moduleitem)
{
	$.get("rest.php/internal_module/" + moduleitem, function (data) 
	{
		var number = 0;
		var elements = $("#sheetmain > div");
		if(elements.length > 0)
		{
			var lastelement = elements[elements.length-1];
			var id = lastelement.id;
			id = id.substr(id.lastIndexOf("_")+1, id.length-1);
			//alert(number);
		}
		$("#sheetmain").append(data.replace(/XXXX/g,number));
	});
}