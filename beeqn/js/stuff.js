function changeURL(timeoutPeriod) {
	setTimeout(function() {
		var url = window.location.href;

		if (url.indexOf("?") > -1) {
			url = url.substr(0, url.indexOf("?"));
		}
		window.location.href = url;
	}, timeoutPeriod);

}
function reloadPage(timeoutPeriod){
	setTimeout(function() { window.location.href = window.location.href;}, timeoutPeriod);
}


function setNameIntoField(name, field)
{
	$('#'+field).val(name);
}