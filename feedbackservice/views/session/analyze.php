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
        if(! isset($_GET["sheet"]))
        {
            showOverview($this->database->getSheetInforsForUser($_SESSION["user"]));
        }
        else
        {
            $this->handleDisplaySheetResults();
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

    function handleDisplaySheetResults()
    {
        $sheet = $_GET["sheet"];
        $results = $this->database->getResultsForSheet($sheet);
        $modules = convertDatabaseSheetToModules($this->database->getSheetJSON($sheet));
        
        $headings = array();
        $values = array();
        $mappings = array();
        
        foreach($modules as $page)
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
                }
                else 
                {
                    $values[$id] = array();    
                }
            }
        }
        
        presentResults($headings, $values, $mappings);
    }
}

?>