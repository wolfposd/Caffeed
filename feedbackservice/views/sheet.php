<?php
include_once 'functions.php';
include_once 'views/sheet_view.php';
class Sheet
{
    private $database;
    private $sheet = false;
    private $sheettitle = false;
    private $shouldShowSheet = false;
    private $postParamsSet = false;
    private $hasPostedIsRedirect = false;

    function __construct(database $database)
    {
        $this->database = $database;
    }

    function __destruct()
    {
    }

    function setup()
    {
        
        if(isset($_GET["success"]))
        {
            $this->hasPostedIsRedirect = true;
            return;
        }
        
        if(isset($_GET["sheet"]))
        {
           $this->getSheetData();
        }
        
        if(isset($_POST) && count($_POST) > 0 && ! $this->isErrorFromDB())
        {
            $this->postParamsSet = true;
            $this->insertSheetResults();
        }
    }

    function insertSheetResults()
    {
        $resultsVerified = array();
        
        foreach($this->sheet as $page)
        {
            foreach($page["elements"] as $module)
            {
                if(isset($_POST[$module->getID()]))
                {
                    $resultsVerified[$module->getID()] = $_POST[$module->getID()];
                }
            }
        }
        
        $result = $this->database->insertResultsForSheet($_GET["sheet"], $resultsVerified);
    }

    function isErrorFromDB()
    {
        return isset($this->sheet["error"]);
    }

    function getSheetData()
    {
        $this->sheet = $this->database->getSheetJSON($_GET["sheet"]);
        
        if($this->isErrorFromDB())
        {
            return;
        }
        
        $this->shouldShowSheet = true;
        $this->sheettitle = $this->sheet["title"];
        $this->sheet = convertDatabaseSheetToModules($this->sheet);
        
    }

    function display()
    {
        if($this->hasPostedIsRedirect)
        {
            show_message_dialog_with_text("Thank you for participating",'<img src="img/success.png" width="100px">');
        }
        else if($this->postParamsSet)
        {
            echo '<div class="text-center"><h1>Inserting Results</h1><br><img src="img/loading.gif" width="100px"></div>';
        }
        else if($this->shouldShowSheet === true)
        {
            showPages($this->sheettitle, $this->sheet);
        }
        else if($this->isErrorFromDB() === true)
        {
            echo $this->sheet["error"];
        }
    }

    function additionalJavascript()
    {
        $string = "";

        if($this->postParamsSet)
        {
            $string.=reloadToPageJavascriptWithParams(array("view"=>$_GET["view"], "success"=>""),3000);
        }
        else if($this->shouldShowSheet)
        {
            $string = "$('#pageTabs a:first').tab('show');";
            
            foreach($this->sheet as $page)
            {
                foreach($page["elements"] as $module)
                {
                    $string .= $module->javascript();
                }
            }
        }
        
        return $string;
    }
}

?>