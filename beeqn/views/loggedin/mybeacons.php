<?php
class MyBeaconsOverview
{
	private $mysqli;
	
	private $modifiedBody ="";

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;
		
		if(isset($_POST["delete"]))
		{
			include_once 'functions.php';
			$this->modifiedBody = reloadPageJavascriptTextForBody(3000);
		}
		
	}
	function __destruct()
	{
	}

	function modifiedBodyValues()
	{
		return $this->modifiedBody;
	}

	function display()
	{
		global $_POST;
		if(isset($_POST["delete"]))
		{
			$success = $this->deleteBeacon();
			
			show_delete_ok($success);
		}
		
		$this->showBeaconTable();

		add_beacon_button();
	}

	
	function deleteBeacon()
	{
		global $_POST;
		include_once 'functions.php';
		$var = decrypt($_POST["delete"]);
		
		$var = explode(";", $var);
		
		if(count($var) === 3)
		{
			$query = "DELETE ibeacons,ibeacon_actions
					FROM ibeacons JOIN ibeacon_actions
					ON ibeacons.id = ibeacon_actions.id
					WHERE UUID = '$var[0]' AND major = '$var[1]' and minor = '$var[2]'";
			
			$result = $this->mysqli->query($query);
			
			if($result === false)
			{
				return false;
			}
			else 
			{
				return true;
			}
		}
	}


	function showBeaconTable()
	{
		global $_SESSION;
		
		$owner = $_SESSION["ownerid"];
		$query = "SELECT * FROM ibeacons WHERE owner_id = $owner";

		$result = $this->mysqli->query($query);
		$beacons = array();
		while($row = $result->fetch_assoc())
		{
			array_push($beacons,$row);
		}
		$result->free();

		showBeaconTable($beacons);
	}
}



function show_delete_ok($insertOK)
{
	include_once 'functions.php';
	show_succes_or_error($insertOK, "Success", "iBeacon was successfully deleted", "Error", "The iBeacon couldn't be deleted");
}





function showBeaconTable($beacons)
{
	?>
<div class="row">
	<div class="">
		<table class="table">
			<tr >
				<th class="text-center">UUID</th>
				<th class="text-center">Major</th>
				<th class="text-center">Minor</th>
				<th class="text-center">Description</th>
				<th class="text-center">Location</th>
				<th class="text-center">GPS</th>
				<th class="text-center">Action</th>
				<th class="text-center">Delete</th>
			</tr>
			<?php foreach ($beacons as $beacon) { ?>
			<tr>
				<td align="center"><?php echo $beacon["UUID"]?></td>
				<td align="center"><?php echo $beacon["major"]?></td>
				<td align="center"><?php echo $beacon["minor"]?></td>
				<td align="center"><?php echo $beacon["description"]?></td>
				<td align="center"><?php echo $beacon["location"]?></td>
				<td align="center"><?php echo $beacon["longitude"]." , ".$beacon["latitude"]?></td>
				<td align="center"><?php edit_action($beacon); ?></td>
				<td align="center"><?php remove_beacon($beacon); ?></td>
			</tr>
			<?php 	}	?>

		</table>
	</div>
</div>
<?php 
}


function edit_action($beacon)
{
	include_once 'functions.php';
	?>
	<form method="get">
		<input type="hidden" name="editbeaconaction" value="<?php echo encrypt($beacon["UUID"].";".$beacon["major"].";".$beacon["minor"])?>"/>
		<input type="submit" class="btn btn-info btn-small" value="Edit Beacon" />
	</form>
	<?php 
}

function remove_beacon($beacon)
{
	include_once 'functions.php';
	?>
	<form method="post">
		<input type="hidden" name="mybeacons"/>
		<input type="hidden" name="delete" value="<?php echo encrypt($beacon["UUID"].";".$beacon["major"].";".$beacon["minor"])?>" />
  		<input type="submit" class="btn btn-danger btn-small" value="Delete" onclick="return confirm('Are you sure you want to delete this iBeacon?');"/>
	</form>
<?php 
}


function add_beacon_button()
{
	?>
<div class="row">
	<form method="get">
		<input type="hidden" name="addbeacon"> <input type="submit" class="btn btn-primary btn-large" value="Add new iBeacon" />
	</form>
</div>
<?php 
}



?>