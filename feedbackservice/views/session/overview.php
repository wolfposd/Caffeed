<?php

/**
 * This is the basic Template for controller-classes
 */
class Overview
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
		echo "This is the customer overview";
	}


}


?>