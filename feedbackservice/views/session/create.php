<?php
include_once 'views/session/create_view.php';
include_once 'database/database.php';
const CREATE = "create";
const CREATESUCCESS = "createsuccess";
const SHOW = "show";

/**
 * This is the basic Template for controller-classes
 */
class Create
{
    private $database;
    private $mode;
    
    private $lastCreateSheetid = false;

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
        if(isset($_GET["create"]))
        {
            if($_GET["create"] === "success")
            {
                $this->mode = CREATESUCCESS;
            }
            else
            {
                $this->mode = CREATE;
            }
        }
        else
        {
            $this->mode = SHOW;
        }
    }

    function display()
    {
        switch ($this->mode)
        {
            case CREATESUCCESS :
                $this->handleCreationSuccess();
                break;
            case CREATE :
                $this->handleCreation();
                break;
            default :
                $this->handleSheetConstruction();
        }
    }

    function handleCreation()
    {
        $title = $_GET["title"];
        
        $modules = array();
        
        $curnum = 0;
        $curvals = array();
        
        foreach($_GET as $key => $value)
        {
            if(strpos($key, "module") !== false)
            {
                $number = str_replace("module_", "", $key);
                $index = strpos($number, "_");
                $type = substr($number, $index + 1);
                $number = substr($number, 0, $index + 1);
                
                if($number != $curnum)
                {
                    $modules[] = $curvals;
                    $curnum = $number;
                    $curvals = array();
                }
                
                if(strpos($value, "\r\n") !== false)
                {
                    $value = explode("\r\n", $value);
                }
                
                if(is_numeric($value) && strpos("min,max,step,length", $type) !== false)
                {
                    $value = (float) $value;
                }
                
                $curvals[$type] = $value;
            }
        }
        
        if(count($curvals) !== 0)
        {
            $modules[] = $curvals;
        }
        $result = $this->database->addNewSheet($title, $_SESSION["user"], $modules);
        
        echo "Creation was " . ($result ? "successfull" : "unsuccessfull") . "<br>RELOADING";
        
        if($result)
        {
            $this->lastCreateSheetid = $this->database->getLastCreatedSheetId($_SESSION["user"]);
        }
    }

    function handleSheetConstruction()
    {
        echo "<form method='get'>";
        
        showCreateSheet();
        
        $this->showCreateButton();
    }

    function handleCreationSuccess()
    {
        echo "SUCCESS<br>";
        
        
        if(isset($_GET["sheet"]))
        {
            echo "Your Sheet-ID: ".$_GET["sheet"];
        }
    }

    function showCreateButton()
    {
        $var = "";
        foreach($_GET as $get => $getval)
        {
            $var .= "<input type='hidden' name='$get' value='$getval'>";
        }
        echo "<div class='row'></div>
	            <p></p>
	          <div class='col-md-10' style='padding-bottom:20px;'>
    	            
    	            <input type='hidden' name='create'>" . $var . "
    	            <button class='btn btn-success btn-block'>Create this sheet</button>
    	            </form>
	          </div>
	         ";
    }

    /**
     * Remove function if not necessary
     *
     * @return string
     */
    function modifiedBodyValues()
    {
        return ""; // <body> tag not modified
    }

    /**
     * Remove function if not necessary
     *
     * @return string
     */
    function additionalJavascript()
    {
        if($this->mode === SHOW)
        {
            return addingJavaScript();
        }
        else if($this->mode === CREATE)
        {
            return reloadToSuccessPage($this->lastCreateSheetid !== false ? "&sheet=".$this->lastCreateSheetid : "");
        }
        else
        {
            return "";
        }
    }
}

?>