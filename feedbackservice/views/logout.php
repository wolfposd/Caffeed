<?php

class logout
{
	private $database;

	function __construct(database $database)
	{
		$this->database = $database;
	}
	
	function handleCookies()
	{
	    unset($_SESSION["login"]);
	    unset($_SESSION["user"]);
	    session_destroy();
	}
	
	/**
	 * Remove function if not necessary
	 */
	function setup()
	{
	    
	}

	function display()
	{
		echo "logged out";
	}

	/**
	 * Remove function if not necessary
	 * @return string
	 */
	function modifiedBodyValues()
	{
		return redirectPageJavaScriptTextForBody(1500);
	}


	/**
	 * Remove function if not necessary
	 * @return string
	 */
	function additionalJavascript()
	{
		return ""; // additional javascript
	}

}


?>