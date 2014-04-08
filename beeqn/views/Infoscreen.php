<?php



class InfoScreen
{

	function __construct(&$mysqli)
	{
	}
	function __destruct()
	{
	}

	function display()
	{
		show();
	}

	function showNavigationBarLeft()
	{
		return false;
	}

	function getNavigationBarLeftContent()
	{
	}

}



function show()
{
	?>
<div class="col-md-2">
	<img src="img/beeqn_text.png" width="256" height="256">
</div>
<div class="col-md-6">
	<h1 class="page-header">Welcome to BeeQn</h1>
	BeeQn is an exciting project for the new iBeacon Technology based on Bluetooth LE.
</div>
<?php
}


?>