<?php
include_once 'functions.php';
include_once 'views/session/analyze_view.php';
/**
 * This is the basic Template for controller-classes
 */
class Analyze
{
    private $database;

    function __construct(database $database)
    {
        $this->database = $database;
    }

    /**
     * Remove function if not necessary
     */
    function setup()
    {
    }

    function display()
    {
        if(isset($_GET["sheet"]))
        {
            $this->handleDisplaySheetResults();
        }
        else if(isset($_GET["ct"]))
        {
            $this->handleDisplayDynamicResults();
        }
        else
        {
            showOverview($this->database->getSheetInfosForUser($_SESSION["user"]),
                         $this->database->getContextTriggerGroups($_SESSION["user"]));
        }
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
        return ""; // additional javascript
    }
    
    
    function getSheetResultsAndAnalyzeForSheet($sheet)
    {
        $results = $this->database->getResultsForSheet($sheet);
        $sheetpages = convertDatabaseSheetToModules($this->database->getSheetJSON($sheet));
        
        $headings = array();
        $values = array();
        $mappings = array();
        $analyzes = array();
        
        foreach($sheetpages as $page)
        {
            foreach($page["elements"] as $module)
            {
                $id = $module->getID();
                $headings[$id] = array("text" => $module->getText(), "id" => $id, "class" => get_class($module));
        
                if(isset($results[$id]))
                {
                    if($elements = $module->getElements())
                    {
                        $mappings[$id] = $elements;
                    }
        
                    foreach($results[$id] as $val)
                    {
                        if($val !== "")
                        {
                            $values[$id][] = $val;
                        }
                    }
        
                    $resultscount = count($values[$id]);
        
                    $hasAnalyze = $module->analyzehtml($values[$id],$module->getElements() ? $mappings[$id]:array());
                    if($hasAnalyze !== false)
                    {
                        $analyzes[$id] = array($resultscount ,$hasAnalyze);
                    }
                    else
                    {
                        $analyzes[$id] = array($resultscount,"TEST");
                    }
                }
                else
                {
                    $values[$id] = array();
                    $analyzes[$id] =  array(0,"");
                }
        
            }
        }
        
        return array($headings, $analyzes);
    }

    function handleDisplaySheetResults()
    {
        $sheet = $_GET["sheet"];
       
        $HeadingsAndResults = $this->getSheetResultsAndAnalyzeForSheet($sheet);

        presentResults($HeadingsAndResults[0], $HeadingsAndResults[1]);
    }
    
    
    function getSheetIdsForTriggerGroup($triggerGroup)
    {
        $sheetids = array();
        $triggerextras = $this->database->getContextTriggerExtraForGroupID($triggerGroup);

        foreach ($triggerextras as $triggerextra)
        {
            $sheetids[] = $this->database->getRestIDforSheetID($triggerextra["sheetid"]);
        }
        
        return $sheetids;
    }
    
    function handleDisplayDynamicResults()
    {
        $sheetRestIds = $this->getSheetIdsForTriggerGroup($_GET["ct"]);
        $name = $this->database->getContextTriggerNameForID($_GET["ct"]);
        echo "<h2>Dynamic results for ".$name."</h2>";
             
        $alreadyHandles = array();
        
        foreach($sheetRestIds as $sheet)
        {
            
            if(!isset($alreadyHandles[$sheet]))
            {
                $alreadyHandles[$sheet] = 1;
                $HeadingsAndResults = $this->getSheetResultsAndAnalyzeForSheet($sheet);

                $title = $this->database->getSheetJSON($sheet);

                presentResults($HeadingsAndResults[0], $HeadingsAndResults[1], "Results for: ". $title["title"]);
                echo "<br>";
                echo "<br>";
            }
        }
    }
}

?>