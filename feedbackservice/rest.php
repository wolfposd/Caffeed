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

	/**
	 * Returns the value that follows the specified key<br>
	 * also does mysql_escape_string
	 * @param string $value needle
	 * @param string-array $requestArr hackstack
	 * @return string
	 */
	function getRequestValue($key, &$requestArr)
	{
		if(in_array($key, $requestArr))
		{
			$index = array_search($key, $requestArr);
			if($index + 1 < count($requestArr))
			{
				$possible = $this->mysqli->real_escape_string($requestArr[$index+1]);
				return $possible;
			}
		}
		return false;
	}


	function rest_get_sheet($array)
	{
		$id = $this->getRequestValue("id", $array);
		if($id !== false)
		{
			if($id == 3)
			{	//TESTING DATA
				echo '{"title":"iPhone 5s Feedback","id":3,"submitbuttononpage":1,"pages":[{"title":"Page 1","elements":[{"type":"list","id":"list1","text":"Pick one of the following","elements":["good","medium","bad"]},{"type":"photo","id":"photo1","text":"Please take a picture of your face"},{"type":"textfield","id":"textfield1","text":"Add any additonal comments"}]}]}';
			}
		}
	}


	function rest_put_sheet($array)
	{
		$id = $this->getRequestValue("id", $array);
		if($id !== false)
		{
			$input = file_get_contents( 'php://input', 'r' );

			$json = json_decode($input,true);

			if($id == 3)
			{ //TESTING DATA
				if(isset($json["list1"]) && isset($json["photo1"]) && isset($json["textfield1"]))
				{
					echo "success";
				}
				else
				{
					echo "unsuccessfull";
				}
			}
		}
	}


}