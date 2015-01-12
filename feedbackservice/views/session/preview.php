<?php

/**
 * This is the basic Template for controller-classes
 */
class Preview
{
	private $database;

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
	    
	}

	function display()
	{
	    $count = $this->database->getSheetCountForUser($_SESSION["user"]);
        $sheetResults = $this->database->getNumberOfResults($_SESSION["user"]);
        
        if($count > 0)
        {
            echo "<p>Your Sheets:</p>";
            echo "<ul>";
            foreach($this->database->getSheetInfosForUser($_SESSION["user"]) as $sheetid)
            {
                echo "<li class='well'>
                <p><label>$sheetid[1]</label><br>
                <a href='?view=sheet&sheet=$sheetid[0]' target='_blank'>Preview Sheet</a></p>
                </li>";
            }
            echo "</ul>";
        }
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