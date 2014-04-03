<?php


class Content
{
	function __construct()
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
		return true;
	}

	function getNavigationBarLeftContent()
	{
		$return = array();
		array_push($return,
		array(
			array("name"=>"Overview","active"=>true,"link"=>"?overview"),
			array("name"=>"Beacons","link"=>"?mybeacons"),
			array("name"=>"Floors","link"=>"?floors"))
		);
		return $return;
	}

}

?>