<?php

class Addbeacons
{
	private $mysqli;
	
	private $modifiedBody = "";

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;
		
		global $_POST;
		
		if(isset($_POST["addbeacon"]))
		{
			include_once 'functions.php';
			$this->modifiedBody = reloadPageJavascriptTextForBody(4000);
		}
		
	}
	function __destruct()
	{
	}


	function display()
	{
		global $_GET;
		global $_POST;
		if(isset($_POST["addbeacon"]) && isset($_POST["uuid"]))
		{
			$success = $this->addBeaconToDB();
			show_insert_ok($success);
			
			if($success === false)
			{
				echo $this->mysqli->error;
			}
		}
		else if(isset($_GET["addbeacon"]))
		{
			showForm();
		}
	}

	
	function addBeaconToDB()
	{
		//TODO Change Owner
		$owner = 1;
		
		global $_POST;
		$uuid = $this->mysqli->real_escape_string($_POST["uuid"]);
		$major = $this->mysqli->real_escape_string($_POST["major"]);
		$minor = $this->mysqli->real_escape_string($_POST["minor"]);
		$descr = $this->mysqli->real_escape_string($_POST["description"]);
		$loc = $this->mysqli->real_escape_string($_POST["location"]);
		
		$query = "INSERT INTO ibeacons (owner_id, UUID, major, minor, description, location) values ($owner, '$uuid', $major, $minor, '$descr', '$loc')";
		
		$result = $this->mysqli->query($query);
		
		if($result !== false)
		{
			$insertid = $this->mysqli->insert_id;
				
			if($insertid !== 0)
			{
				$query = "INSERT INTO ibeacon_actions (id, action_type, action_info ) VALUES ('$insertid', 'custom', 'Hello World!')";
					
				$result = $this->mysqli->query($query);
				
				if($result !== false)
				{
					return true;
				}
			}
		}
		
		return false;
	}
	
	
	function modifiedBodyValues()
	{
		return $this->modifiedBody;
	} 

}

function show_insert_ok($insertOK)
{
	include_once 'functions.php';

	if($insertOK)
	{
		show_message_dialog_with_text("Success","iBeacon was successfully added", $insertOK);
	}
	else
	{
		show_message_dialog_with_text("Error","The iBeacon couldn't be added", $insertOK);
	}
}


function showForm()
{
	?>
<div class="col-md-4">
	<form method="post">
	<h2>Add a new iBeacon</h2>
		<table class="table table-condensed">
			<tr>
				<td>UUID</td>
				<td><input type="text" name="uuid" size="80"/></td>
			</tr>
			<tr>
				<td>Major</td>
				<td><input type="text" name="major" /></td>
			</tr>
			<tr>
				<td>Minor</td>
				<td><input type="text" name="minor" /></td>
			</tr>
			<tr>
				<td>Description</td>
				<td><input type="text" name="description" /></td>
			</tr>
			<tr>
				<td>Location</td>
				<td><input type="text" name="location" /></td>
			</tr>
		</table>
		<input type="hidden" name="addbeacon">
		<input type="submit" class="btn btn-primary" value="Add beacon">
	</form>
</div>

<?php 
}

?>