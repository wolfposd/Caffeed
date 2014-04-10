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
			if($index + 1 < count($arrayvalue))
			{
				$major = $this->mysqli->real_escape_string($arrayvalue[$index+1]);

				if(int_ok($major))
				{
					$query .= " AND major = $major ";
				}
			}
		}
		if(in_array("minor", $arrayvalue))
		{
			$index = array_search("minor", $arrayvalue);
			if($index + 1 < count($arrayvalue))
			{
				$minor = $this->mysqli->real_escape_string($arrayvalue[$index+1]);
				if(int_ok($minor))
				{
					$query .= " AND minor = $minor ";
				}
			}
		}

		$query .= " LIMIT 1";

		$result = $this->mysqli->query($query, MYSQLI_USE_RESULT);

		$returnval = array();

		while($row = $result->fetch_assoc())
		{
			$returnval["action_type"] = $row["action_type"];
			$returnval["action_info"] = $row["action_info"];
			break;
		}

		$result->close();

		if(count($returnval) == 0)
		{
			$returnval = $this->error_msg();
		}

		echo json_encode($returnval);
	}


	function rest_get_uuidbylocation($arrayvalue)
	{
		$returnval = $this->error_msg();
		
		$longitude = $this->retrieveValueFromRequest("longitude",$arrayvalue);
		$latitude = $this->retrieveValueFromRequest("latitude",$arrayvalue);

		if(is_numeric($longitude) && is_numeric($latitude))
		{
			$query = "SELECT * FROM
					(SELECT sqrt(pow(longitude-$longitude,2) + pow(latitude-$latitude,2)) AS distance, UUID FROM ibeacons ORDER BY DISTANCE ASC) as temp
					GROUP BY UUID ORDER BY distance ASC LIMIT 20";

			$result= $this->mysqli->query($query);
				
				
			if($result !== false)
			{
				$resultUUIDS = array();

				while($row = $result->fetch_assoc())
				{
					array_push($resultUUIDS, $row["UUID"]);
				}
				$result->free();
				$returnval = $resultUUIDS;
			}
		}

		echo  json_encode($returnval);
	}

	function retrieveValueFromRequest($value, &$requestArr)
	{
		if(in_array($value, $requestArr))
		{
			$index = array_search($value, $requestArr);
			if($index + 1 < count($requestArr))
			{
				$possible = $this->mysqli->real_escape_string($requestArr[$index+1]);
				return $possible;
			}
		}
	}

	function error_msg()
	{
		return array("error"=>"noinfo");
	}

	
}

function int_ok($val)
{
	return ($val !== true) && ((string)(int) $val) === ((string) $val);
}



?>