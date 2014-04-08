<?php

include_once 'config.php';


$application = new Application();
$application->handle();


class Application {

	private $mysqli;

	private $owner;

	function __construct()
	{
		global $_SESSION;
		$this->mysqli = getConnection();
		$this->owner = $_SESSION["ownerid"];
	}

	function __destruct()
	{
		$this->mysqli->close();
	}



	function handle()
	{
		if(isset($_GET["floor"]))
		{
			$this->display_floor($_GET["floor"]);
		}
	}


	function display_floor($floor)
	{
		$floor = $this->mysqli->real_escape_string($floor);
		$imgquery = "SELECT description FROM floor_plan WHERE floor_id = $floor";
		$result = $this->mysqli->query($imgquery);
		$obj = $result->fetch_object();
		$result->free();

		new ApplicationUI($obj->description, $floor , $this->get_beacons_by_owner());
	}


	function get_beacons_by_owner()
	{
		$query = "SELECT * FROM ibeacons WHERE owner_id = {$this->owner}";
		$result = $this->mysqli->query($query);
		$returnval = array();
		while($row = $result->fetch_assoc())
		{
			array_push($returnval, $row);
		}
		$result->free();
		return $returnval;
	}


}





class ApplicationUI
{

	function __construct($description, $floorid, $beacons)
	{
		?>
<!DOCTYPE html>
<html>
<body>
	<h2>
		<?php echo $description?>
	</h2>
	<img src="img_get.php?id=<?php echo $floorid?>&beacons">

	<ul>
		<?php foreach($beacons as $beacon) {?>
		<li><?php echo $beacon["UUID"]." ".$beacon["major"]." ".$beacon["minor"];?></li>
		<?php }?>
	</ul>
</body>
</html>
<?php 		
	}
}


?>