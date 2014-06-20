<?php
include_once 'functions.php';
include_once 'views/sheet_view.php';
class Sheet
{
    private $database;
    private $sheet = false;
    private $sheettitle = false;

    function __construct(database $database)
    {
        $this->database = $database;
    }

    function __destruct()
    {
    }

    function setup()
    {
        if(isset($_GET["sheet"]))
        {
            $this->sheet = $this->database->getSheetJSON($_GET["sheet"]);
            $this->convertSheetData();
        }
    }

    function convertSheetData()
    {
        $this->sheettitle = $this->sheet["title"];
        
        $pages = array();
        
        foreach($this->sheet["pages"] as $page)
        {
            $pagearray = array();
            $pagearray["title"] = $page["title"];
            $pagearray["id"] = str_replace(" ", "", $page["title"]);
            
            $elements = array();
            
            foreach($page["elements"] as $mod)
            {
                $module = getModuleForType($mod->type, (array) $mod, $mod->id);
                $elements[] = $module;
            }
            $pagearray["elements"] = $elements;
            
            $pages[] = $pagearray;
        }
        
        $this->sheet = $pages;
    }

    function display()
    {
        showPages($this->sheettitle, $this->sheet);
    }

    function additionalJavascript()
    {
        $string = "$('#pageTabs a:first').tab('show');";
        
        
        foreach($this->sheet as $page)
        {
            foreach($page["elements"] as $module)
            {
                $string.=$module->javascript();
            }
        }
        
        return $string;
    }
}

?>