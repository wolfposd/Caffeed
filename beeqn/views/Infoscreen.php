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
<h1 class="page-header">Welcome to BeeQn</h1>
BeeQn is an exciting project for the new iBeacon Technology based on Bluetooth LE.



<?php
}


?>