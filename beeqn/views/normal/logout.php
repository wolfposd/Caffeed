<?php
class Logout
{
	private $logoutSuccess = false;

	function __construct(&$mysqli)
	{
		$this->logoutSuccess = session_destroy();
	}
	
	function display()
	{
		include_once 'functions.php';
		
		show_succes_or_error($this->logoutSuccess, "Success", "Logged out successfully<br>You will automatically be redirected in 3 seconds",
		 "Error", "Oops Something went wrong");
	}

	function modifiedBodyValues()
	{
		include_once 'functions.php';
		return redirectPageJavaScriptTextForBody(3000,"");
	}

}
?>