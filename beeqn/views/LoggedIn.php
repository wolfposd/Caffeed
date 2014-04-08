<?php

class LoggedInContent
{
	private $mysqli;

	private $subcontent = false;


	private $activeTab = false;

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;

		global $_GET;


		if(isset($_GET["mybeacons"]))
		{
			include_once 'views/loggedin/mybeacons.php';
			$this->subcontent = new MyBeaconsOverview($this->mysqli);
				
			$this->activeTab = "Beacons";
		}
		else if(isset($_REQUEST["addbeacon"]))
		{
			include_once 'views/loggedin/addbeacon.php';
			$this->subcontent = new Addbeacons($this->mysqli);
			$this->activeTab = "Beacons";
		}
		else if(isset($_REQUEST["editbeaconaction"]))
		{
			include_once 'views/loggedin/editbeaconaction.php';
			$this->subcontent = new EditBeaconAction($this->mysqli);
			$this->activeTab = "Beacons";
		}
		else if(isset($_GET["myfloors"]))
		{
			include_once 'views/loggedin/myfloors.php';
			$this->subcontent = new MyFloorsOverview($this->mysqli);
			$this->activeTab = "Floors";
		}
		else
		{
			$this->activeTab = "Overview";
		}
	}
	function __destruct()
	{
	}

	function display()
	{
		if($this->subcontent !== false)
		{
			$this->subcontent->display();
		}
		else
		{
			echo "<h2>NOTHING HERE</h2>";
		}
	}



	function showNavigationBarLeft()
	{
		return true;
	}

	function getNavigationBarLeftContent()
	{
		$return = array();
		array_push($return,
		array(
		$this->createTab("Overview","?overview"),
		$this->createTab("Beacons", "?mybeacons"),
		$this->createTab("Floors", "?myfloors"))
		);
		return $return;
	}
	
	function createTab($name, $link)
	{
		$arr = array("name"=>$name, "link"=>$link);
		if($name === $this->activeTab)
		{
			$arr["active"] = true;
		}
		return $arr;
	}
	
	function modifiedBodyValues()
	{
		if(method_exists($this->subcontent, "modifiedBodyValues"))
		{
			return $this->subcontent->modifiedBodyValues();
		}
		else return "";
	}

}


?>