<?php

/**
 * This is the basic Template for controller-classes
 */
class Home
{
	private $database;

	function __construct(database &$database)
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
		echo "Hello";
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
	 * @return multitype:multitype:string
	 */
	function getNavigationBarLeftContent()
	{
		return array(
				array("MenuTitle"=>"?key","MenuTitle"=>"?key"), // separation
				array("MenuTitle"=>"?key","MenuTitle"=>"?key")
		);
	}
	/**
	 * Remove function if not necessary
	 * @return multitype:string
	 */
	function getNavigationBarTopContent()
	{
		return array("MenuTitle"=>"?key", "MenuTitle"=>"?key");
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