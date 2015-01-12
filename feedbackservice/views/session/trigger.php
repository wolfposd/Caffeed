<?php



class Mode {
    const __default = self::NORMAL;
    const NORMAL = 1;
    const ADDGROUP = 2;
    const EDITGROUP = 3;
    const ADDCONTEXTTRIGGERTOGROUP = 4;
}

/**
 * This is the basic Template for controller-classes
 */
class Trigger
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
	    if(isset($_POST["cname"]) && isset($_POST["cbeacon"]))
	    {
	        $this->mode = Mode::ADDGROUP;
	    }
	    else if(isset($_GET["edit"]))
	    {
    	    if(isset($_POST["cttype"]))
    	    {
    	        $this->mode = MODE::ADDCONTEXTTRIGGERTOGROUP;
    	    }
    	    else
    	    {
    	        $this->mode = MODE::EDITGROUP;
    	    }
	    }
	    else
	    {
	        $this->mode = MODE::NORMAL;
	    }
	}

	function display()
	{
	    switch ($this->mode)
	    {
	        case Mode::NORMAL : $this->handleNormalMode();break;
	        case MODE::EDITGROUP:  $this->handleEditMode();break;
	        case MODE::ADDGROUP:  $this->handleAddMode();break;
	        case MODE::ADDCONTEXTTRIGGERTOGROUP : $this->handleAddContextTrigger();break;
	    }
	}
	
	

	function handleAddContextTrigger()
	{
	    $groupid = $_GET["edit"];
	    $extra = $_POST["ctjson"];
	    $type = $_POST["cttype"];
	    $prio = $_POST["ctprio"];
	    
        $insertOK = $this->database->inserTrigger($type, $extra, $prio, $groupid);
         
        show_success_or_error($insertOK, "Success", "Successfully added the new Trigger",
        "Failure", "Couldn't add the new trigger.<br>Reason:".$insertOK);

        $this->handleEditMode();
	}

	function handleAddMode()
	{
	    if(isset($_POST) && !empty($_POST))
	    {
	        include_once 'views/items/beacon.php';
	        include_once 'functions.php';
	        
	        $beacon = Beacon::makeBeacon($_POST["cbeacon"]);
	        $result = $this->database->insertGroup($_POST["cname"], $beacon, $_SESSION["user"]);
	        
	        show_success_or_error($result, "Success", "Successfully added new Group", "Failure", "Couldn't add new group.<br>Reason:".$result);
	        
	    }
	    
	    $this->handleNormalMode();
	}
	
	function handleEditMode()
	{
	    $groupid = $_GET["edit"];
	    
	    $name = $this->database->getContextTriggerNameForID($groupid);
	    
	    $triggers = $this->database->getTriggersForGroupId($groupid);
	    
	    foreach($triggers as &$ex)
	    {
	        $ex["extra"]["sheetinfo"] = $this->database->getSheetInfosByID($ex["extra"]["sheetid"]);
	    }
	    
	    
	    include_once 'views/session/trigger_view.php';
        display_edit_mode_for_group($name, $triggers); 
	}
	
	function handleNormalMode()
	{
	    $groups = $this->database->getContextTriggerGroups($_SESSION["user"]);
	     
	    include_once 'views/session/trigger_view.php';
	     
	    foreach($groups as &$group)
	    {
	        $extra = $this->database->getContextTriggerExtraForGroupID($group["contextid"]);
	    
	        foreach($extra as &$ex)
	        {
	            $ex["sheetinfo"] = $this->database->getSheetInfosByID($ex["sheetid"]);
	        }
	    
	        $group["extra"] = $extra;
	    }
	     
	     
	    displayListOfContextGroups($groups);
	     
	    $beacons = $this->database->getBeaconsForUser($_SESSION["user"]);
	     
	    displayAddContextGroup($beacons);
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
	    ob_start();
	    ?>
	    </script><script type="text/javascript">
	    function updateTrigger(identifier)
	    {
	        var formid = $(identifier).data("sheet");
		    var form = encodeURIComponent($("#triggereditform"+formid).serialize());

		    $.post("rest.php/updatecontexttrigger/"+form)
		    .done(function(data) {
				$("#messagediv"+formid).html(data);
			}).fail(function() {
				$("#messagediv"+formid).html("an error occured");
			});
	    }
	    function deleteTrigger(identifier)
	    {
	    	var formid = $(identifier).data("sheet");
	    	var input = $("#triggereditform"+formid+" :input[name='cgid']").val(); 

	        $.post("rest.php/deletecontexttrigger/"+input)
		    .done(function(data) {
			    data = JSON.parse(data);
		        if(data["delete"] == true)
		        {
		        	$("#formdiv"+formid).remove();
		        }
		        else
		        {
		        	$("#messagediv"+formid).html(data);
		        }
			}).fail(function() {
				$("#messagediv"+sheetid).html("an error occured");
			});
	    }
	    </script><script>
	    <?php 	    
		return ob_get_clean();
	}

}


?>