<?php

/**
 * This is the basic Template for controller-classes
 */
class Beacons
{
	private $database;
	
	private $beaconWasAdded = array(false, false);

	function __construct(database $database)
	{
		$this->database = $database;
	}
	function __destruct()
	{
	}
	
	/**
	 * Remove function if not necessary
	 */
	function handleCookies()
	{
	    
	}
	
	/**
	 * Remove function if not necessary
	 */
	function setup()
	{
	    if(isset($_POST["uuid"]) )
	    {
	        include_once 'views/items/beacon.php';
	        
	        $beacon = new Beacon($_POST["uuid"], $_POST["major"], $_POST["minor"]);

	        $result = $this->database->addBeaconForUser($beacon,$_SESSION["user"]);

	        
	        $this->beaconWasAdded = array(true, $result);
	    }
	    
	}

	function display()
	{
	    include_once 'views/session/beacons_view.php';
	    
	    if($this->beaconWasAdded[0] === true)
	    {
	        include_once 'functions.php';
	        show_success_or_error($this->beaconWasAdded[1], "Beacon Added", "A new beacon has been added", 
	        "Beacon not added", "The Beacon couldn't be added");
	    }
	    
	    displayBeacons($this->database->getBeaconsForUser($_SESSION["user"]));
	    
	    displayAddBeaconForm(); 
	}

	/**
	 * Remove function if not necessary
	 * @return string
	 */
	function modifiedBodyValues()
	{
		return ""; // <body> tag not modified
	}


	/**
	 * Remove function if not necessary
	 * @return string
	 */
	function additionalJavascript()
	{
		return ""; // additional javascript
	}

}


?>