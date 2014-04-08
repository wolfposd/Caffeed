<?php
class EditBeaconAction
{
	private $mysqli;

	private $beacon = array();

	private $showForm = true;
	
	private $modifiedBody ="";

	function __construct(&$mysqli)
	{
		$this->mysqli = $mysqli;

		if(isset($_REQUEST["editbeaconaction"]))
		{
			global $_REQUEST;
			include_once 'functions.php';
			$var = decrypt($_REQUEST["editbeaconaction"]);

			$var = explode(";", $var);


			if(count($var) == 3)
			{
				$this->beacon["UUID"] = $this->mysqli->real_escape_string($var[0]);
				$this->beacon["major"] = $this->mysqli->real_escape_string($var[1]);
				$this->beacon["minor"] = $this->mysqli->real_escape_string($var[2]);
			}
		}
		
		if(isset ($_POST["editbeaconaction"]))
		{
			$this->showForm = false;
			include_once 'functions.php';
			$this->modifiedBody = reloadPageJavascriptTextForBody(4000);
		}

	}

	function getActionForBeacon()
	{
		$query = "SELECT action_type as type, action_info as info FROM ibeacons, ibeacon_actions 
		WHERE ibeacons.id = ibeacon_actions.id AND UUID = '{$this->beacon["UUID"]}' AND major = {$this->beacon["major"]} AND minor = {$this->beacon["minor"]}";

		$result = $this->mysqli->query($query);

		$row = $result->fetch_assoc();

		$result->free();

		return $row;
	}
	
	function updateAction()
	{
		global $_POST;
		if(isset($_POST["type"]) && isset($_POST["info"]))
		{
			$type = $this->mysqli->real_escape_string($_POST["type"]);
			$info = $this->mysqli->real_escape_string($_POST["info"]);
			
			$query = "UPDATE ibeacon_actions JOIN ibeacons ON ibeacon_actions.id = ibeacons.id 
			SET ibeacon_actions.action_type = '$type', ibeacon_actions.action_info = '$info' 
			WHERE UUID = '{$this->beacon["UUID"]}' AND major = {$this->beacon["major"]} AND minor = {$this->beacon["minor"]}";
			
			
			$result = $this->mysqli->query($query);
			
			if($result !== false)
			{
				return true;
			}
			else 
			{
				return false;
			}
		}
		return false;
	}

	
	function modifiedBodyValues()
	{
		return $this->modifiedBody;
	}

	function display()
	{
		if($this->showForm)
		{
			$action = $this->getActionForBeacon();
			show_form($action);
		}
		else
		{
			$insertOK =	$this->updateAction();
			show_insert_ok($insertOK);
		}
	}

}


function show_form($action)
{
	global $_GET;
	?>
<h2>Edit Beacon Action</h2>

<form method="post">
	<div class="col-md-4 form-group">
		<?php echo show_action_type($action["type"]);?>
		<?php echo show_action_info($action["info"]);?>
		<p></p>
		<input type="hidden" name="editbeaconaction" value="<?php echo $_GET["editbeaconaction"]?>">
		<input type="hidden" name="commit">
		<input type="submit" class="btn btn-primary" value="Change Action" />
	</div>
</form>

<?php 
}


function show_action_type($type)
{
	?>
<p>Action Type:</p>
<select class="form-control" name="type">
	<?php foreach(array("list","url","twitter","facebook","custom") as $key) {?>
	<option<?php if($type === $key) echo " selected=\"true\""?>><?php echo $key?></option>
	<?php }?>
</select>
<?php 
}


function show_action_info($info)
{
?>
<p>Action Info:</p>
<textarea class="form-control" rows="6" name="info"><?php echo $info?></textarea>
<?php 
}


function show_insert_ok($insertOK)
{
	include_once 'functions.php';

	if($insertOK)
	{
		show_message_dialog_with_text("Success","Update was successfully applied");
	}
	else
	{
		show_message_dialog_with_text("Error","Update was not applied");
	}
}

?>