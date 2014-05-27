<?php


class Home
{
	private $database;

	function __construct($database)
	{
		$this->database = $database;
	}
	function __destruct()
	{
	}

	function display()
	{
		echo "Hello, this is the start screen";
	}

}


?>