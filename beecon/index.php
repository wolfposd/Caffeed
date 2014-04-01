<?php

include_once 'config.php';



// var_dump($_SERVER["REQUEST_METHOD"]);
// var_dump($_SERVER);



// echo "<br><br><br>";
$application = new Application();
$application->handle();


class Application {

	public $mysqli;

	function __construct()
	{
		$this->mysqli = getConnection();
	}
	function __destruct()
	{
		$this->mysqli->close();
	}

	function handle()
	{
		$request = explode("/", substr(@$_SERVER['PATH_INFO'], 1));
		$rest = 'rest_'.strtolower($_SERVER['REQUEST_METHOD']);
		
		if (method_exists($this,$rest)) 
		{
			call_user_func(array($this, $rest), $request);
		}
	}
	
	
	function rest_get($request)
	{
		$function = "rest_get_".$request[0];

		if(method_exists($this,$function))
		{
			call_user_func(array($this,$function),$request[1]);
		}
	}


	function rest_get_beaconsbyuuid($uuid)
	{
		$uuid = $this->mysqli->real_escape_string($uuid);

		$query = "SELECT * FROM ibeacons WHERE UUID = '$uuid'";

		$result = $this->mysqli->query($query,MYSQLI_USE_RESULT);

		$returnval = array();

		while($row = $result->fetch_assoc())
		{
			unset($row["id"]);
			array_push($returnval, $row);
		}

		$result->close();

		echo json_encode($returnval, JSON_FORCE_OBJECT);
	}

}




?>