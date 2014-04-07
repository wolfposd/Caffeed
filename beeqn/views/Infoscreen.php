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
		?>
<h1 class="page-header">Hier Default Template</h1>
Hier kann auch Text stehen
<?php
	}

	function showNavigationBarLeft()
	{
		return false;
	}

	function getNavigationBarLeftContent()
	{
	}

}


?>