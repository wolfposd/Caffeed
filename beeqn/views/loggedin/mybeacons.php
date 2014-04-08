<?php
class MyBeaconsOverview
{
	private $mysqli;

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;
	}
	function __destruct()
	{
	}


	function display()
	{
		$this->showBeaconTable();

		add_beacon_button();
	}



	function showBeaconTable()
	{
		$owner = 0;
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







function showBeaconTable($beacons)
{
	?>
<div class="row">
	<div class="col-md-6">
		<table class="table">
			<tr>
				<th>UUID</th>
				<th>Major</th>
				<th>Minor</th>
				<th>Description</th>
				<th>Location</th>
				<th>Action</th>
			</tr>
			<?php foreach ($beacons as $beacon) { ?>
			<tr>
				<td><?php echo $beacon["UUID"]?></td>
				<td><?php echo $beacon["major"]?></td>
				<td><?php echo $beacon["minor"]?></td>
				<td><?php echo $beacon["description"]?></td>
				<td><?php echo $beacon["location"]?></td>
				<td><?php edit_action($beacon); ?></td>
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
	<input type="submit" class="btn btn-info btn-small" value="Edit Action" />
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