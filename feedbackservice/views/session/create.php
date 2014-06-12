<?php

include_once 'views/session/create_view.php';

/**
 * This is the basic Template for controller-classes
 */
class Create
{
	private $database;

	private $mode;
	
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
	    $this->mode = isset($_GET["create"]) ? "create": "show";
	}

	function display()
	{
	    switch ($this->mode)
	    {
	        case "create":
	            $this->handleCreation();
	            break;
	        default:
	            $this->handleSheetConstruction();
	    }
	}
	
	function handleCreation()
	{
	    foreach ($_GET as $key => $value)
	    {
	        echo "$key and $value <br>";
	    }
	}
	
	function handleSheetConstruction()
	{
	    echo "<form method='get'>";
	    
	    showCreateSheet();
	    
	    $this->showCreateButton();
	}
	
	
	function showCreateButton()
	{
	    $var ="";
	    foreach ($_GET as $get => $getval)
	    {
	        $var .= "<input type='hidden' name='$get' value='$getval'>";
	    }
	    echo "<div class='row'></div>
	            <p></p>
	          <div class='col-md-10' style='padding-bottom:20px;'>
    	            
    	            <input type='hidden' name='create'>".$var."
    	            <button class='btn btn-success btn-block'>Create this sheet</button>
    	            </form>
	          </div>
	         ";
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
	    if($this->mode === "show")
	    {
	        return addingJavaScript();
	    }
	    else
	    { 
	        return "";
	    }
	}
	
	
}


?>