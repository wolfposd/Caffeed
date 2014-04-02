<?php


$app = new ImageGet();
$app->handle();

class ImageGet
{
	private $mysqli;

	function __construct()
	{
		include_once 'config.php';
		$this->mysqli = getConnection();
	}

	function __destruct()
	{
		$this->mysqli->close();
	}


	function handle()
	{
		if(isset($_GET["id"]))
		{
			$id = $this->mysqli->real_escape_string($_GET["id"]);
			$image_array = $this->get_floor_plan_with_id($id);
				
			if(isset($_GET["beacons"]))
			{
				$beacons = $this->get_beacons_on_floor($id);

				if(count($beacons) !== 0)
				{
					$image_array["image"] =	$this->place_beacons_on_image($image_array["image"], $beacons);
				}
					
			}
			output_image($image_array["type"], $image_array["image"]);
		}
	}

	function get_floor_plan_with_id($id)
	{
		$strQuery= "SELECT imagedata, imagetype, scale FROM floor_plan WHERE floor_id=$id";

		$result=$this->mysqli->query($strQuery);

		$row=$result->fetch_assoc();

		$image = imagecreatefromstring($row["imagedata"]);

		$type = $row["imagetype"];
		$scale = $row["scale"];
		$result->free();

		return array("type"=>$type, "image"=>$image, "scale"=>$scale);
	}

	function get_beacons_on_floor($id)
	{
		$query = "SELECT * FROM beacon_on_floor WHERE floor_id = $id";

		$result = $this->mysqli->query($query);

		$returnval = array();

		while($row = $result->fetch_assoc())
		{
			array_push($returnval, $row);
		}

		$result->free();
		return $returnval;
	}

	function place_beacons_on_image($image , $beacons_array)
	{
		$beaconimage = imagecreatefrompng("img/beacon_symbol.png");


		foreach ($beacons_array as $beacon)
		{
			$x = $beacon["x"];
			$y = $beacon["y"];

			imagecopymerge($image, $beaconimage, $x, $y, 0, 0, 25, 25, 100);
		}

		return $image;

		imagedestroy($beaconimage);
	}

}


function output_image($type, $image)
{
	header("Content-type: $type");
	if ($type == "image/jpeg")
	{
		imagejpeg($image);
	}
	else if($type == "image/png")
	{
		imagepng($image);
	}
	else if ($type == "image/gif")
	{
		imagegif($image);
	}
	imagedestroy($image);
}

?>