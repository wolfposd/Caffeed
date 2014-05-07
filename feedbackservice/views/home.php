<?php


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

}


?>