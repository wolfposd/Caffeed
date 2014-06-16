<?php

/**
 * This is the basic Template for controller-classes
 */
class Preview
{
	private $database;

	function __construct(database $database)
	{
		$this->database = $database;
	}
	function __destruct()
	{
	}
	
	/**
	 * Remove function if not necessary
	 */
	function handleCookies()
	{
	    
	}
	
	/**
	 * Remove function if not necessary
	 */
	function setup()
	{
	    
	}

	function display()
	{
		echo "This is the Preview Page";
	}

	/**
	 * Remove function if not necessary
	 * @return string
	 */
	function modifiedBodyValues()
	{
		return ""; // <body> tag not modified
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