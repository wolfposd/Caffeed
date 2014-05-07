<?php

/**
 * This is the basic Template for controller-classes
 */
class Home
{
	private $mysqli;

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;
	}
	function __destruct()
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