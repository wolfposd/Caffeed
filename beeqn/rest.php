<?php

include_once 'config.php';


$application = new Application();
$application->handle();


class Application {

	private $mysqli;

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
		$rest = 'rest_'.strtolower($_SERVER['REQUEST_METHOD'])."_".$request[0];
		
		if (method_exists($this,$rest)) 
		{
			call_user_func(array($this, $rest), $request);
		}
	}

	function rest_get_beaconsinfo($arrayvalue)
	{
		
		$uuid = $this->mysqli->real_escape_string($arrayvalue[1]);

		$query = "SELECT * FROM ibeacons, ibeacon_actions WHERE ibeacons.id = ibeacon_actions.id AND UUID = '$uuid'";
		
		
		if(in_array("major", $arrayvalue))
		{
			$index = array_search("major", $arrayvalue);
			$major = $this->mysqli->real_escape_string($arrayvalue[$index+1]);
			$query .= " AND major = $major ";
		}
		if(in_array("minor", $arrayvalue))
		{
			$index = array_search("minor", $arrayvalue);
			$major = $this->mysqli->real_escape_string($arrayvalue[$index+1]);
			$query .= " AND minor = $major ";
		}
		
		$query .= " LIMIT 1";

		$result = $this->mysqli->query($query,MYSQLI_USE_RESULT);

		$returnval = array();

		while($row = $result->fetch_assoc())
		{
			unset($row["id"]);
			$returnval = $row;
		}

		$result->close();

		if(count($returnval) == 0)
		{	
			array_push($returnval, array("error"=>"noinfo"));
		}

		echo json_encode($returnval);
	}

}




?>