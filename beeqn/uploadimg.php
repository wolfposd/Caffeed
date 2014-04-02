<?php 

if (array_key_exists('img',$_FILES) && isset($_POST["scale"]))
{

	$tmpname = $_FILES['img']['tmp_name'];

	$type = $_FILES['img']['type'];

	$hndFile = fopen($tmpname, "r");

	$data = addslashes(fread($hndFile, filesize($tmpname)));

	include_once 'config.php';



	$mysqli = getConnection();

	$scale =  str_replace(",", ".",$mysqli->real_escape_string($_POST["scale"]));

	$query = "INSERT INTO floor_plan (description, imagedata, imagetype, scale) VALUES ('C-213','$data', '$type', '$scale')";
	$result = $mysqli->query($query);

	if($result === false)
	{
		var_dump($mysqli->error);
	}

	$mysqli->close();
}
else
{
	var_dump($_POST);
	var_dump($_FILES);
}


?>
<!DOCTYPE html>
<html>
<body>
	<h1>Bild hochladen</h1>

	<form method="post" action="<?php echo $_SERVER['PHP_SELF']; ?>" enctype="multipart/form-data">
		<p>
			Bilddatei: <input type="file" name="img" size="40">
		</p>
		<p>
			Scaling Factor: <input type="text" name="scale"> ( 1px = x Meter)
		</p>
		<p>
			<input type="submit" name="submit" value="Abschicken">
		</p>

	</form>
</body>
</html>
