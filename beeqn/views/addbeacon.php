<?php

class Addbeacons
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
		showForm();
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
	</form>
</div>

<?php 
}

?>